# frozen_string_literal: true

class AddSeminarTypeToSeminars < ActiveRecord::Migration[7.0]
  def change
    add_column :seminars, :seminar_type, :integer
  end
end
