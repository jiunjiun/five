module ApplicationHelper
  def self_say?(message_user_token, whosay)
    message_user_token == whosay
  end
end
