class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(message)
    user_tokens = $redis.smembers "room_#{message.room.token}"
    user_tokens.each do |user_token|
      whosay = user_token
      ActionCable.server.broadcast "chat_#{user_token}", action: Room::Actions::CHAT, message: render_message(whosay, message)
    end
  end

  private
  def render_message(whosay, message)
    ApplicationController.renderer.render(partial: 'messages/message', locals: {message: message, whosay: whosay})
  end
end
