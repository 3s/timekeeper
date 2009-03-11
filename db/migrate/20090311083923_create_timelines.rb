class CreateTimelines < ActiveRecord::Migration
  def self.up
    create_table :timelines do |t|
      t.references(:users)
      t.string(:what, :null => false)
      t.string(:customer)
      t.datetime(:time_spend_at)
      t.decimal(:time_spend, :scale => 2, :precision => 10)
      t.text(:more)
      t.timestamps
    end
  end

  def self.down
    drop_table :timelines
  end
end
