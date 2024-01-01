class RemovePositionFromRelationships < ActiveRecord::Migration[7.0]
  def change
    remove_column :relationships, :position, :string
  end
end
