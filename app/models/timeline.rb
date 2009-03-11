class Timeline < ActiveRecord::Base

  belongs_to :user

  attr_reader :time_spend_at_free
  validates_presence_of(:what, :time_spend_at, :user)
  validates_numericality_of :time_spend, :allow_nil => true
  named_scope :recent, {:limit => 10, :order => "created_at DESC"}
  named_scope :by_customer, { :order => "customer, time_spend_at ASC"}
  
  def time_spend_at_free=(something)
    n = Time.now
    begin
      case something
      when "today" then self.time_spend_at = n
      when "tomorrow" then self.time_spend_at = n + (3600*24)
      when "yesterday" then self.time_spend_at = n - (3600*24)
      when /\d+ days* ago/ then self.time_spend_at = n - (3600*24*something[/\d+/].to_i)
      else
        self.time_spend_at = n
      end
    rescue
      self.time_spend_at = n
    end
  end
  
end
