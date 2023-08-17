# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.0.2"

gem "activestorage-cloudinary-service", "~> 0.2.3"
gem "active_storage_validations"       # 画像ファイルのバリデーション用
gem "bcrypt", "~> 3.1.7"
gem "bootsnap", ">= 1.4.4", require: false
gem "cloudinary", "~> 1.27"
gem "image_processing"                 # (サイズ変更など)画像処理用
gem "jbuilder", "~> 2.7"
gem "pg", "~> 1.1"
gem "puma", "~> 5.0"
gem "rails", "~> 6.1.5"
gem "rails-i18n"
gem "sass-rails", ">= 6"
gem "webpacker", "~> 5.0"

group :development, :test do
  gem "brakeman", require: false
  gem "bullet"
  gem "byebug", platforms: %i[mri mingw x64_mingw]
  gem "pry-byebug"
  gem "pry-rails"
  gem "rspec-rails"
  gem "rubocop", require: false
  gem "rubocop-performance", require: false
  gem "rubocop-rails", require: false
  gem "rubocop-rspec", require: false
  gem "spring-commands-rspec"
end

group :development do
  gem "listen", "~> 3.3"
  # gem "rack-mini-profiler", "~> 2.0"
  gem "spring"
  gem "web-console", ">= 4.1.0"
end

gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]
