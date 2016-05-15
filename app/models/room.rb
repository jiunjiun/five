class Room < ApplicationRecord
  has_many :messages, dependent: :destroy

  module Actions
    INIT  = "init"
    CHAT  = "chat"
    LEAVE = "leave"
  end

  def self.find_by_user_token(user_token)
    Room.where(token: $redis.get("user_#{user_token}")).last
  end

  def leave(user_token)
    self.leave_at = DateTime.now
    self.save
  end

  def leave?
    self.leave_at.present?
  end
end
