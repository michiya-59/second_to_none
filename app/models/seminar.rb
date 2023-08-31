# frozen_string_literal: true

class Seminar < ApplicationRecord
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

  class << self
    def find_seminars
      now = Time.zone.now
      now_str = now.strftime("%Y-%m-%d %H:%M")

      sql = ["SELECT
              id, title, year, month, day, start_time, end_time, teacher
            FROM
              seminars
            WHERE
              TO_TIMESTAMP(CONCAT(year, '-', month, '-', day, ' ', start_time), 'YYYY-MM-DD HH24:MI') >= TO_TIMESTAMP(?, 'YYYY-MM-DD HH24:MI')
            ORDER BY
              year, month, day, start_time", now_str]

      find_by_sql sql
    end

    def search_by_year_and_month year, month
      where(year:, month:)
    end
  end
end
