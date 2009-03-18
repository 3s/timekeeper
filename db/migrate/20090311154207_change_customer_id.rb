class ChangeCustomerId < ActiveRecord::Migration
  def self.up
    remove_column(:timelines, :customer)
    add_column(:timelines, :customer_id, :integer)
  end

  def self.down
    remove_column(:timelines, :customer_id, :integer)
    add_column(:timelines, :customer)
  end
end
