
namespace :db do
  task :populate => :environment do
    ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)

    class OldTimeline < ActiveRecord::Base
      establish_connection(:old_development)
      self.table_name = "timelines"
    end

    old_timelines = OldTimeline.all
    old_timelines.each do |old|
    
    
      user = nil
      case old.user
      when "Dries": user = User.find_or_create_by_email("vda.dries@gmail.com")
      when "atog": user = User.find_or_create_by_email("koen@10to1.be")
      when "tomk": user = User.find_or_create_by_email("tom@10to1.be")
      end
      if user
        t = Timeline.new
        t.user = user
        t.what = old.what
        t.customer = Customer.find_or_create_by_name(old.customer)
        t.time_spend_at = old.time_spend_at
        t.time_spend = old.time_spend

        t.save
        
      end

    end
  end
end