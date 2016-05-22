# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    private
    def find_verified_user
      cookies[:user_token] = SecureRandom.hex(10) if cookies[:user_token].blank?
      cookies[:user_token]
    end
  end
end
