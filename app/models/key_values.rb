# encoding: utf-8
module KeyValues

  # NEVER change the existed code sequence
  class Base < ActiveHash::Base
    def self.options
      all.map { |t| [t.name, t.code] }
    end

    # {code1: name1, code2: name2}
    def self.hash
      Hash[*(all.map { |t| [t.code, t.name] }.flatten)]
    end

  end

  class ChatActions < KeyValues::Base
    self.data = [
      {id: 1, code: Room::Actions::INIT,  name: '初始' },
      {id: 2, code: Room::Actions::CHAT,  name: '聊天' },
      {id: 3, code: Room::Actions::LEAVE, name: '離開' },
    ]
  end
end
