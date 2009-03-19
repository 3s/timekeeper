class TimelinesController < ApplicationController

  def index
    @timelines = Timeline.find_all_by_state("completed")
    @stoptime = Timeline.find_all_by_state("started")
  end

  def new
    @timeline = Timeline.new
  end

  def stop
    t = Timeline.find(params[:id])
    if t.user_id == current_user.id
      t.stop
      t.save
    end
    redirect_to(timelines_path)
  end

  def edit
    @timeline = Timeline.find(params[:id])
    if @timeline.user_id == current_user.id
      render :action => "new"
    else
      redirect_to(timelines_path)
    end
  end

  def update
    @timeline = Timeline.find(params[:id])
    if @timeline.update_attributes(params[:timeline])
    redirect_to(timelines_path)
    else
      render :action => "new"
    end
  end
 
  def create
    @timeline = Timeline.new(params[:timeline])
    @timeline.customer = Customer.find_or_create_by_name(@timeline.customer_name)
    @timeline.user = current_user
    @timeline.start if params[:commit]== "start"
    if @timeline.save
      redirect_to(timelines_path)
    else
      render :action => "new"
    end
    #    render :text => params.inspect
  end
end

 
