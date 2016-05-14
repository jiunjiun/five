class Room < ApplicationRecord
  has_many :messages

  def self.find_by_user_token(user_token)
    Room.find_by_token($redis.get("user_#{user_token}"))
  end

  def forfeit
    self.forfeit_at = DateTime.now
    self.save

    user_tokens = $redis.smembers "room_#{self.token}"
    user_tokens.each do |user_token|
      $redis.del "user_#{user_token}"
    end
  end
end
