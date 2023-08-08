# ベースとなるDockerイメージ指定
FROM ruby:3.0.2

# 必要なパッケージのインストール
RUN apt-get update -qq && apt-get install -y build-essential postgresql-client

# ワーキングディレクトリを作成
RUN mkdir /second_to_none

# install nodejs(LTS)
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - && apt-get install -y nodejs

# npm自体のバージョンを最新にする
RUN npm install -g npm

# install yarn
RUN npm install -g yarn

# ワーキングディレクトリを設定
WORKDIR /second_to_none

# ホストのGemfileとGemfile.lockをコンテナにコピー
COPY Gemfile /second_to_none/Gemfile
COPY Gemfile.lock /second_to_none/Gemfile.lock

# パッケージのインストール
RUN bundle install

# ホストのすべてのディレクトリをコンテナの作業ディレクトリにコピー
COPY . /second_to_none

# スクリプトをコピーして実行
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

# Railsサーバーを起動
CMD ["rails", "server", "-b", "0.0.0.0"]