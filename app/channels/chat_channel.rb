# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class ChatChannel < ApplicationCable::Channel

  def subscribed
    stream_from "chat_#{current_user}"
    Seek.create(current_user)
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(data)
    room = Room.find_by_user_token(current_user)
    room.messages.create(user_token: current_user, content: data['content'])
  end

  def exit
    Seek.remove(current_user)
    room = Room.find_by_user_token(current_user)
    room.forfeit if room.present?
  end
end
