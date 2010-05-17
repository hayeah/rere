class Relationship < ActiveRecord::Migration
  def self.up
    create_table(:relationships) do |t|
      t.integer :from_user_id
      t.integer :to_user_id
      t.string :type
    end

    add_index :relationships, [:from_user_id,:to_user_id], :unique => true
  end

  def self.down
    drop_table(:relationships)
  end
end
