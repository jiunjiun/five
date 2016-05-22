module ApplicationHelper
  def self_say?(message_user_token, whosay)
    message_user_token == whosay
  end

  def random_image
    Dir.new(Rails.root.to_s + "/app/assets/images/spaces").to_a.select{|f| f.downcase.match(/\.jpg|\.jpeg|\.png/) }.sample
  end
end
