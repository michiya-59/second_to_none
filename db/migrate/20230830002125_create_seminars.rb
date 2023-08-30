class CreateSeminars < ActiveRecord::Migration[7.0]
  def change
    create_table :seminars do |t|
      t.string :title, null: false
      t.timestamp :year, null: false
      t.timestamp :month, null: false
      t.timestamp :day, null: false
      t.timestamp :start_time, null: false
      t.timestamp :end_time, null: false
      t.string :teacher, null: false

      t.timestamps
    end

    execute <<-SQL
      COMMENT ON COLUMN seminars.title IS 'セミナーのタイトル';
      COMMENT ON COLUMN seminars.year IS 'セミナーの開催年';
      COMMENT ON COLUMN seminars.month IS 'セミナーの開催月';
      COMMENT ON COLUMN seminars.day IS 'セミナーの開催日';
      COMMENT ON COLUMN seminars.start_time IS 'セミナーの開始時間';
      COMMENT ON COLUMN seminars.end_time IS 'セミナーの終了時間';
      COMMENT ON COLUMN seminars.teacher IS '講師の名前';
    SQL
  end
end
