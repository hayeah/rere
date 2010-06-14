class MigrateDataToNewModels < ActiveRecord::Migration
  def self.up
    Relationship.all.each do |r|
      r.from_user.follow(r.to_user)
    end
  end

  def self.down
    Following.delete_all
  end
end
