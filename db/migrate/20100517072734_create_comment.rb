class CreateComment < ActiveRecord::Migration
  def self.up
    create_table(:comments) do |t|
      t.integer :user_id, :null => false
      t.integer :thought_id, :null => false
      t.text :content
      t.timestamps
    end
  end

  def self.down
    drop_table(:comments)
  end
end
