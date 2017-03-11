class ApplicationController < ActionController::Base
  include HalHelper
  protect_from_forgery with: :exception
end
