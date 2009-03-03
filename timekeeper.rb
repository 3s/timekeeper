require "rubygems"
require "sinatra"
require "activerecord"


use Rack::Session::Cookie, :secret => "phom2be7ov9vik7at9ej1celf1aish7bei6flen7"

configure do
  ActiveRecord::Base.logger = Logger.new(STDOUT)
  ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => "timekeeper.sqlite3")
  ActiveRecord::Schema.define do
    begin
      create_table(:users) do |t|
        t.string(:username, :null => false)
        t.string(:password, :null => false)
      end
    rescue
      #table exists
    end
    begin
      create_table(:timelines) do |t|
        t.string(:user, :null => false)
        t.string(:what, :null => false)
        t.string(:customer)
        t.datetime(:time_spend_at)
        t.integer(:time_spend)
        t.text(:more)
        t.timestamps
      end
    rescue
      # table exists
    end
  end
  ActiveRecord::Migration.verbose = true
  ActiveRecord::Migrator.migrate("db/migrate")
end

class User < ActiveRecord::Base
  validates_presence_of :username, :password
end

class Timeline < ActiveRecord::Base
  attr_reader :time_spend_at_free
  validates_presence_of :user, :what, :time_spend_at
  validates_numericality_of :time_spend, :allow_nil => true
  named_scope :recent, {:limit => 10, :order => "created_at DESC"}
  named_scope :by_customer, { :order => "customer, time_spend_at ASC"}
  
  def time_spend_at_free=(something)
    t = Time.now
    begin
      case something
      when "today": self.time_spend_at = t
      when "tomorrow" : self.time_spend_at = t + (3600*24)
      when "yesterday" : self.time_spend_at = t - (3600*24)
      when /\d+ days* ago/: self.time_spend_at = t - (3600*24*something[/\d+/].to_i)
      else
        self.time_spend_at = t
      end
    rescue
      self.time_spend_at = t
    end
  end
  
end

before do
  unless session[:user] || request.path_info =~ /login/
    redirect("/login")
    return false
  end
end

get "/" do
  @recent = Timeline.recent
  haml :index
end

post "/add" do
  params[:timeline][:user] = session[:user]
  timeline = Timeline.new(params[:timeline])
  timeline.save!
  redirect("/")
end

get "/login" do
  haml :login
end

post "/login" do
  if (user = User.find_by_username(params[:username])) && user.password == params[:password]
    session[:user] = user.username
    redirect("/")
  else
    redirect("/login")
  end
end

get "/logout" do
  session[:user] = nil
  redirect("/")
end

get "/list" do
  @list = Timeline.by_customer
  haml :list
end

use_in_file_templates!

__END__

@@ layout
%h2 Timekeeper
=yield

@@ index

%h3 Add new entry
%form{ :action => "/add", :method => "post" }
  %p
    %label{ :for => "what" } what were you doing?
    %input{ :type => "text", :name => "timeline[what]", :id => "what" }
    %label{ :for => "customer" } for
    %input{ :type => "text", :name => "timeline[customer]", :id => "customer" }    
    %label{ :for => "time_spend_at" } when
    %input{ :type => "text", :name => "timeline[time_spend_at_free]", :id => "time_spend_at"}
    %label{ :for => "time_spend" } Time spend
    %input{ :type => "text", :name => "timeline[time_spend]", :id => "time_spend", :size => 4 }
    %input{ :type => "submit", :value => "add" }

%h3 Latest entries
%ul
  - @recent.each do |t|
    %li="#{t.time_spend_at.strftime("%d/%m/%Y")} on #{t.what} for #{t.customer}, #{t.time_spend} hours by #{t.user}"

@@ list
%ul
  - @list.each do |t|
    %li="#{t.time_spend_at.strftime("%d/%m/%Y")} on #{t.what} for #{t.customer}, #{t.time_spend} hours by #{t.user}"

@@ login

%h3 Login
%form{ :action => "/login", :method => "post" }
  %p
    %label{ :for => "username" } username
    %input{ :type => "text", :name => "username", :id => "username" }
  %p
    %label{ :for => "password" } password
    %input{ :type => "password", :name => "password", :id => "password" }
  %p
    %input{ :type => "submit", :value => "login" }
    