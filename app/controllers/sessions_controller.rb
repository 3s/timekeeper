class SessionsController < ApplicationController
  include Clearance::App::Controllers::SessionsController

  skip_before_filter :authenticate
end
