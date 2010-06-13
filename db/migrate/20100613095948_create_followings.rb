class CreateFollowings < ActiveRecord::Migration
  def self.up
    create_table(:followings) do |t|
      t.references :follower
      t.references :followed
    end
  end

  def self.down
    drop_table :followings
  end
end
