class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  expose(:room) { Room.find_by_user_token(cookies[:user_token]) }
  expose(:messages) { room.present? ? room.messages : [] }
end
