# frozen_string_literal: true

class CreateSeminars < ActiveRecord::Migration[7.0]
  def up
    create_table :seminars do |t|
      t.string :title, null: false
      t.integer :year, null: false
      t.integer :month, null: false
      t.integer :day, null: false
      t.string :start_time, null: false
      t.string :end_time, null: false
      t.string :teacher, null: false

      t.timestamps
    end

    execute <<-SQL.squish
      COMMENT ON COLUMN seminars.title IS 'セミナーのタイトル';
      COMMENT ON COLUMN seminars.year IS 'セミナーの開催年';
      COMMENT ON COLUMN seminars.month IS 'セミナーの開催月';
      COMMENT ON COLUMN seminars.day IS 'セミナーの開催日';
      COMMENT ON COLUMN seminars.start_time IS 'セミナーの開始時間';
      COMMENT ON COLUMN seminars.end_time IS 'セミナーの終了時間';
      COMMENT ON COLUMN seminars.teacher IS '講師の名前';
    SQL
  end

  def down
    execute <<-SQL.squish
      COMMENT ON COLUMN seminars.title IS NULL;
      COMMENT ON COLUMN seminars.year IS NULL;
      COMMENT ON COLUMN seminars.month IS NULL;
      COMMENT ON COLUMN seminars.day IS NULL;
      COMMENT ON COLUMN seminars.start_time IS NULL;
      COMMENT ON COLUMN seminars.end_time IS NULL;
      COMMENT ON COLUMN seminars.teacher IS NULL;
    SQL

    drop_table :seminars
  end
end
