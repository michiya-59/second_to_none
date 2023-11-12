# frozen_string_literal: true

class CreatePosts < ActiveRecord::Migration[7.0]
  def up
    create_table :posts do |t|
      t.string :title, null: false
      t.string :body, null: false
      t.integer :category_flg, null: false
      t.integer :user_id

      t.timestamps
    end

    execute <<-SQL.squish
      COMMENT ON COLUMN posts.title IS 'イベント・お知らせのタイトル';
      COMMENT ON COLUMN posts.body IS 'イベント・お知らせの内容';
      COMMENT ON COLUMN posts.category_flg IS '１：イベント、２：お知らせ';
    SQL
  end

  def down
    execute <<-SQL.squish
      COMMENT ON COLUMN posts.title IS NULL;
      COMMENT ON COLUMN posts.body IS NULL;
      COMMENT ON COLUMN posts.category_flg IS NULL;
    SQL

    drop_table :posts
  end
end
