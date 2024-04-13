# frozen_string_literal: true

class OrganizationsController < ApplicationController
  # indexアクションは、組織図に必要なデータと検索機能をビューに提供します。
  def index
    setup_search_options
    @status_query = params[:status_query]
    @level_query = params[:level_query]

    @users, @level_counts, @total_count, @active_count, @inactive_count = fetch_users_with_hierarchy(
      @status_query, @level_query
    )
  end

  private

  # 組織内のユーザーとその階層情報を取得するメソッドです。検索クエリも考慮します。
  def fetch_users_with_hierarchy status_query, level_query
    root_id = current_user&.id
    descendants = find_descendants(root_id)
    user_ids = [root_id] + descendants
    users = User.where(id: user_ids, status: [1, 9]).index_by(&:id)

    users_with_level = {}
    level_counts = Hash.new(0)
    active_count = 0
    inactive_count = 0

    users.each do |id, user|
      level = calculate_level(id, root_id)
      parent = Relationship.find_by(child_id: id)
      parent_name = parent ? User.find(parent.parent_id).name : "なし"
      user_info = user.attributes.merge("level" => level, "parent_name" => parent_name)
      users_with_level[id] = user_info
      level_counts[level] += 1
      active_count += 1 if user["status"] == 1
      inactive_count += 1 if user["status"] != 1
    end

    filtered_users = users_with_level.values
    if status_query.present?
      filtered_users = filtered_users.select{|user| user["status"].to_s == status_query}
    end
    if level_query.present?
      filtered_users = filtered_users.select{|user| user["level"].to_s == level_query}
    end

    # 再計算
    active_count = filtered_users.count{|user| user["status"] == 1}
    inactive_count = filtered_users.count{|user| user["status"] != 1}

    # ソート: 階層とIDでソートを保持
    sorted_users = filtered_users.sort_by{|user| [user["level"], user["id"]]}

    total_count = sorted_users.count
    [sorted_users, level_counts, total_count, active_count, inactive_count]
  end

  # 指定された親ユーザーIDから全子孫を再帰的に検索するメソッドです。
  def find_descendants parent_id
    return [] unless parent_id

    # 直接の子ユーザーIDを取得します。
    direct_children = Relationship.where(parent_id:).pluck(:child_id)
    descendants = direct_children.dup

    # 各子ユーザーに対してさらに子孫を検索し、結果を追加します。
    direct_children.each do |child_id|
      descendants += find_descendants(child_id)
    end

    # 重複を除去して返します。
    descendants.uniq
  end

  # ユーザーの階層を計算するメソッドです。
  def calculate_level user_id, root_id, current_level = 0
    # ユーザーIDが基点IDと同じ場合、現在の階層を返します。
    return current_level if user_id == root_id

    # ユーザーの親IDを取得します。
    parent_id = Relationship.find_by(child_id: user_id)&.parent_id

    # 親IDがない場合は現在の階層を返します。
    return current_level unless parent_id

    # 親に対して同じ計算を行い、階層を1増やします。
    calculate_level(parent_id, root_id, current_level + 1)
  end

  def setup_search_options
    # ステータスオプションの生成、特定のステータスコードを除外
    status_mappings = {1 => "活動中", 9 => "退会済"}  # ここで使用するステータスコードと表示名を定義
    status_values = User.distinct.pluck(:status)
    @status_options = status_values.each_with_object([]) do |status, options|
      label = status_mappings[status]
      options << [label, status] if label
    end

    # 階層オプションの設定
    max_level = calculate_max_level(current_user&.id)
    @level_options = (1..max_level).map{|number| ["#{number}段目", number]}
  end

  def calculate_max_level user_id, current_level = 0
    children = Relationship.where(parent_id: user_id).pluck(:child_id)
    return current_level if children.empty?

    # 子ノードの階層中で最大のものを取得
    children_levels = children.map{|child_id| calculate_max_level(child_id, current_level + 1)}
    children_levels.max
  end
end
