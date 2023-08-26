# frozen_string_literal: true

class CreateGrades < ActiveRecord::Migration[7.0]
  def change
    create_table :grades do |t|
      t.string :grade_name, null: false, comment: "1：エグゼクティブ、2：ルビーエグゼクティブ、3：エメラルドエグゼクティグ"

      t.timestamps
    end
  end
end
