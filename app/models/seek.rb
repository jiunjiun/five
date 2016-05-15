class Seek
  def self.create(user_token)
    return if Room.find_by_user_token(user_token)
    if found_user_token = $redis.spop("seeks")
      room_token = Digest::MD5.hexdigest("#{user_token}-#{found_user_token}")
      Room.create(token: room_token)

      Rails.logger.debug { " -- room_#{room_token}" }
      $redis.sadd "room_#{room_token}", [user_token, found_user_token]
      $redis.set "user_#{user_token}", room_token
      $redis.set "user_#{found_user_token}", room_token
    else
      $redis.sadd('seeks', user_token)
    end
  end

  def self.clear_all
    $redis.del("seeks")
  end
end
