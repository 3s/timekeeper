class ChangeToDecimal < ActiveRecord::Migration
  def self.up
    change_column :timelines, :time_spend, :decimal, :precision => 10, :scale => 2
  end

  def self.down
    change_column :timelines, :time_spend, :integer
  end
end
