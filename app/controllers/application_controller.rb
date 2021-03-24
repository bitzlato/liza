class ApplicationController < ActionController::Base
  include CurrentUser
  include RescueErrors

  layout 'application'
end
