# frozen_string_literal: true

class Seminar < ApplicationRecord
  has_many :reservations, dependent: :destroy

  # 数値であり、特定の範囲内であるか確認
  validates :year, numericality: {greater_than_or_equal_to: 2023, less_than_or_equal_to: 2040}
  validates :month, numericality: {greater_than_or_equal_to: 1, less_than_or_equal_to: 12}
  validates :day, numericality: {greater_than_or_equal_to: 1, less_than_or_equal_to: 31}
  validate :valid_date
  # カスタムバリデーションも可能
  validate :start_time_before_end_time
  validate :not_in_past

  # テキストフィールドは空でないことを確認
  validates :title, presence: true
  validates :teacher, presence: true

  # カスタムバリデーションメソッド
  def start_time_before_end_time
    if start_time.blank? || end_time.blank?
      errors.add(:base, I18n.t("activerecord.errors.models.seminar.attributes.start_time.start_time_or_end_time_blank"))
      return
    end

    return unless start_time >= end_time

    errors.add(:base, I18n.t("activerecord.errors.models.seminar.attributes.start_time.start_time_before_end_time"))
  end

  def valid_date
    # year, month, dayが全て存在する場合のみ確認を行う
    return if year.blank? || month.blank? || day.blank?

    # Dateオブジェクト作成時にエラーが発生すれば無効な日付
    begin
      Date.new(year, month, day)
    rescue ArgumentError
      errors.add(:base, "日程が不正です。存在する日程を入力してください。")
    end
  end

  def not_in_past
    return if year.blank? || month.blank? || day.blank? || start_time.blank?

    # 時間と分を取り出す
    hour, minutes = start_time.split(":").map(&:to_i)
    begin
      # Railsが設定しているタイムゾーンでDateTimeオブジェクトを作成
      seminar_date = Time.zone.local(year, month, day, hour, minutes)
      # 現在のタイムゾーンでの現在時刻を取得
      current_time = Time.zone.now
      errors.add(:base, "過去の日程は入力しないでください。") if seminar_date < current_time
    rescue ArgumentError
      errors.add(:base, "日程が不正です。")
    end
  end

  def formatted_start_time
    # 年/月/日 時間の形式で日時をフォーマットする
    # オブジェクトの属性に応じて調整してください
    "#{year}/#{month}/#{day} #{start_time} ~ #{end_time}"
  end

  class << self
    def find_seminars
      now = Time.zone.now
      beginning_of_month = now.beginning_of_month.strftime("%Y-%m-%d %H:%M")
      end_of_month = now.end_of_month.strftime("%Y-%m-%d %H:%M")

      sql = "SELECT id, title, year, month, day, start_time, end_time, teacher, seminar_type
            FROM seminars
            WHERE TO_TIMESTAMP(CONCAT(LPAD(year::text, 4, '0'), '-', LPAD(month::text, 2, '0'), '-', LPAD(day::text, 2, '0'), ' ', start_time), 'YYYY-MM-DD HH24:MI') BETWEEN TO_TIMESTAMP(?, 'YYYY-MM-DD HH24:MI') AND TO_TIMESTAMP(?, 'YYYY-MM-DD HH24:MI')
            ORDER BY year, month, day, start_time"

      Seminar.find_by_sql([sql, beginning_of_month, end_of_month])
    end

    def search_by_year_and_month year, month
      where(year:, month:).order(:year, :month, :day, :start_time)
    end

    def find_user_seminars user_id, year, month, join_status
      sql = "SELECT seminars.*, reservations.id as reservation_id, reservations.join_status " \
            "FROM seminars " \
            "INNER JOIN reservations ON seminars.id = reservations.seminar_id " \
            "WHERE reservations.user_id = ? " \
            "AND seminars.year = ? " \
            "AND seminars.month = ? "
      params = [user_id, year, month]

      if join_status.present?
        sql += " AND reservations.join_status = ? "
        params << join_status.to_i
      end

      sql += " ORDER BY seminars.year, seminars.month, seminars.day, seminars.start_time"

      Seminar.find_by_sql([sql, *params])
    end
  end
end
