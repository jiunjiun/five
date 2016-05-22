class HomeController < ApplicationController
  before_action :check_token

  def index
  end

  private
  def check_token
    cookies[:user_token] = SecureRandom.hex(10) if cookies[:user_token].blank?
  end
end
