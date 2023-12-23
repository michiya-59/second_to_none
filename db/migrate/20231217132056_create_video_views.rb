# frozen_string_literal: true

class CreateVideoViews < ActiveRecord::Migration[7.0]
  def change
    create_table :video_views do |t|
      t.references :user, null: false, foreign_key: true
      t.references :learn, null: false, foreign_key: true

      t.timestamps
    end
  end
end
