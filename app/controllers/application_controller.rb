class ApplicationController < ActionController::API
  include TokenAuthenticatable
  include Response
  include ExceptionHandler
end
