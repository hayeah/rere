class AddGroupPermalink < ActiveRecord::Migration
  def self.up
    add_column :groups, :permalink, :string
    add_index :groups, :permalink, :unique => true
  end

  def self.down
    remove_column :groups, :permalink
    remove_index :groups, :permalink
  end
end
