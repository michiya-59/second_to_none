class CreateGrades < ActiveRecord::Migration[6.1]
  def change
    create_table :grades do |t|
      t.string :grade_name, null: false, comment: '1：エグゼクティブ、2：ルビーエグゼクティブ、3：エメラルドエグゼクティグ'
      t.timestamps
    end
  end
end
