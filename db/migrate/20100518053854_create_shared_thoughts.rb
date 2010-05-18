class CreateSharedThoughts < ActiveRecord::Migration
  def self.up
    create_table(:shared_thoughts) do |t|
      t.references :subject, :polymorphic => true
      t.references :thoughts
    end
  end

  def self.down
    drop_table(:shared_thoughts)
  end
end
