# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class ChatChannel < ApplicationCable::Channel

  def subscribed
    stream_from "chat_#{current_user}"
    init
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def seek
    Seek.create(current_user)
  end

  def speak(data)
    room = Room.find_by_user_token(current_user)
    room.messages.create(user_token: current_user, content: data['content'])
  end

  def leave
    room = Room.find_by_user_token(current_user)
    if room.present? and room.leave_at.blank?
      room.leave(current_user)
      room.messages.create(user_token: current_user, content: I18n.t('helpers.leave_msg'), is_last: true)

      user_tokens = $redis.smembers "room_#{room.token}"
      notice_another_user = user_tokens.reject {|token| token == current_user}.first
      ActionCable.server.broadcast "chat_#{notice_another_user}", action: Room::Actions::LEAVE, message: render_leave_message(room)
    end
    $redis.del "user_#{current_user}"
  end

  private
  def render_leave_message(room)
    ApplicationController.renderer.render partial: 'messages/leave_message', locals: {leave_at: room.leave_at}
  end

  def init
    options = {}
    room = Room.find_by_user_token(current_user)
    if room.present?
      options[:is_leave] = true if room.leave?

      ActionCable.server.broadcast "chat_#{current_user}", action: Room::Actions::INIT, options: options
    end
  end
end
