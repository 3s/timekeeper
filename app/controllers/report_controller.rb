class ReportController < ApplicationController

  def index
      
  end

  def search
    from = params[:from_date].blank? ? 5.years.ago : Date.parse(params[:from_date])- 1.day
    to = params[:to_date].blank? ? Time.now.tomorrow : Date.parse(params[:to_date])+ 1.day
    customer = params[:customer].blank? ? "%" : params[:customer]
    user = params[:user].blank? ? "%" : params[:user]

    @timelines = Timeline.find(:all,
      :conditions => ["users.email like ? and customers.name like ? and time_spend_at between ? and ?", user, customer, from, to],
      :include => [:customer, :user])

    @total_time_spend = @timelines.inject(0) do |counter, timeline|
      logger.info(counter)
      counter += timeline.time_spend || 0
    end

    render :action => "index"
  end

end
