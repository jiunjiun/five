class HomeController < ApplicationController
  before_action :check_token

  def index
    room = Room.find_by_user_token(cookies[:user_token])
    @messages = room.present? ? room.messages : []
  end

  private
  def check_token
    cookies[:user_token] = SecureRandom.hex(10) if cookies[:user_token].blank?
  end
end
