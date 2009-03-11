class ChangeUsersId < ActiveRecord::Migration
  def self.up
    rename_column :timelines, :users_id, :user_id
  end

  def self.down
    rename_column :timelines, :user_id, :users_id
  end
end
