module PgHealth
  class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
    layout "pg_health/application"
  end
end
