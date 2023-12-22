# frozen_string_literal: true

# lib/line_notifier.rb
require "net/http"
require "uri"
require "json"

module LineNotifier
  LINE_NOTIFY_TOKEN = ENV.fetch("LINE_NOTIFY_TOKEN", nil)
  LINE_NOTIFY_URL = "https://notify-api.line.me/api/notify"

  def self.notify_error error
    return unless Rails.env.production? # 本番環境のみ実行

    message = format_message(error)
    uri = URI.parse(LINE_NOTIFY_URL)
    request = Net::HTTP::Post.new(uri)
    request["Authorization"] = "Bearer #{LINE_NOTIFY_TOKEN}"
    request.set_form_data(message:)

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == "https") do |http|
      http.request(request)
    end

    handle_response(response)
  end

  def self.notify_tmp_entry message
    # 本番環境のみ実行のコメントアウトを解除してください
    return unless Rails.env.production?

    send_message = tmp_entry_format_message message

    uri = URI.parse(LINE_NOTIFY_URL)
    request = Net::HTTP::Post.new(uri)
    request["Authorization"] = "Bearer #{LINE_NOTIFY_TOKEN}"
    request.set_form_data(message: send_message)

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == "https") do |http|
      http.request(request)
    end

    handle_response(response)
  end

  def self.tmp_entry_format_message message
    user_name = message.name
    entry_plan = message.incentive_id == 1 ? "ノーマルプラン" : "アドバンスプラン"
    introduce_user = User.find(message.introducer_id).name
    salse_user = User.find(message.sales_id).name
    entry_created_at = Time.zone.now.strftime("%Y/%m/%d %H:%M:%S")

    <<~MESSAGE
      【仮登録通知】
      仮登録が完了しました。
      仮登録ユーザーは以下の通りです。

      名前：#{user_name}
      登録プラン：#{entry_plan}
      紹介者：#{introduce_user}
      営業担当者：#{salse_user}
      仮登録日時：#{entry_created_at}
    MESSAGE
  end

  def self.format_message error
    backtrace_info = error.backtrace_locations&.first
    location = if backtrace_info
                 "#{backtrace_info.path}　#{backtrace_info.lineno}行目"
               else
                 "バックトレース情報なし"
               end

    <<~MESSAGE
      エラーが発生しました:
      #{error.message}
      発生場所:
      #{location}
      発生時刻:
      #{Time.current.strftime('%Y/%m/%d %H:%M:%S')}
      バックトレースの先頭10行:
      #{error.backtrace.take(10).join("\n")}
    MESSAGE
  end

  def self.handle_response response
    case response
    when Net::HTTPSuccess, Net::HTTPRedirection
      JSON.parse(response.body)
    else
      response.value
    end
  end
end
