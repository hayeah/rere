class CreateMemberships < ActiveRecord::Migration
  def self.up
    create_table(:memberships) do |t|
      t.integer :group_id
      t.integer :user_id
    end
    add_index :memberships, [:group_id,:user_id], :unique => true
  end

  def self.down
    drop_table(:memberships)
  end
end
