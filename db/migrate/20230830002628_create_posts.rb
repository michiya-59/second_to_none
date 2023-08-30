class CreatePosts < ActiveRecord::Migration[7.0]
  def change
    create_table :posts do |t|
      t.string :title, null: false
      t.string :body, null: false
      t.integer :category_flg, null: false
      t.integer :user_id

      t.timestamps
    end

    execute <<-SQL
      COMMENT ON COLUMN posts.title IS 'イベント・お知らせのタイトル';
      COMMENT ON COLUMN posts.body IS 'イベント・お知らせの内容';
      COMMENT ON COLUMN posts.category_flg IS '１：イベント、２：お知らせ';
    SQL
  end
end
