class CreateStreamThoughts < ActiveRecord::Migration
  def self.up
    create_table(:stream_thoughts) do |t|
      t.references :thought
      t.references :to, :polymorphic => true
      t.references :from, :polymorphic => true
    end
  end

  def self.down
    drop_table(:stream_thoughts)
  end
end
