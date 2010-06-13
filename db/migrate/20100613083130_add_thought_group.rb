class AddThoughtGroup < ActiveRecord::Migration
  def self.up
    add_column :thoughts, :group_id, :integer
  end

  def self.down
    remove_column :thoughts, :group_id
  end
end
