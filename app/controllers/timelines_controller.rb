class TimelinesController < ApplicationController

  def index
    @timelines = Timeline.all
    
  end

  def new
    @timeline = Timeline.new
  end

  def create
    @timeline = Timeline.new(params[:timeline])
    @timeline.user = current_user
    if @timeline.save
      redirect_to(timelines_path)
    else
      render :action => "new"
    end
#    render :text => params.inspect
  end

  

end
