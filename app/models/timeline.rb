class Timeline < ActiveRecord::Base

  attr_accessor :customer_name

  belongs_to :user
  belongs_to :customer

  attr_reader :time_spend_at_free
  validates_presence_of(:what, :time_spend_at, :user_id, :customer_id)
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
        self.time_spend_at = something
      end
    rescue
      self.time_spend_at = n
    end
  end

  state_machine :state, :initial => :completed do

    after_transition :on => :start do |t|
      puts "setting start"
      t.started_at = Time.now
      puts t.started_at
    end

    after_transition :on => :stop do |t|
      puts "completing"
      if t.started_at
        t.time_spend = (Time.now - t.started_at)/3600
        t.started_at = nil
      end
    end

    event :start do
      transition all => :started
    end

    event :stop do
      transition all => :completed
    end

  end
  
end
