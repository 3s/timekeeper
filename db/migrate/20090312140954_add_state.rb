class AddState < ActiveRecord::Migration
  def self.up
    add_column :timelines, :state, :string
    add_column :timelines, :started_at, :datetime
  end

  def self.down
    add_column :timelines, :state
    add_column :timelines, :started_at
  end
end
