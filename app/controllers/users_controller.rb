class UsersController < ApplicationController
  include Clearance::App::Controllers::UsersController

  skip_before_filter :authenticate, :only => [:new, :create]
end