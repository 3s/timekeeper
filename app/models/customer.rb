class Customer < ActiveRecord::Base
  has_many :timelines
end
