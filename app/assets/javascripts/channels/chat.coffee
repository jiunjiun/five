App.chat = App.cable.subscriptions.create { channel: "ChatChannel", room: "Best Room" },
  connected: ->
    console.log 'connected'
    # Called when the subscription is ready for use on the server

  disconnected: ->
    console.log 'disconnected'
    # Called when the subscription has been terminated by the server

  received: (data) ->
    console.log 'received'
    $('#messages').append data['message']

  speak: (content) ->
    @perform 'speak', content: content

$(document).on 'keypress', '[data-behavior~=chat_speaker]', (event) ->
  if event.keyCode is 13 # return/enter = send
    speak()
    return false

$('.chat-controls-btn').click ->
  speak()
  return false

speak = ->
  content = $('.chat-controls-input input')
  App.chat.speak content.val()
  content.val('')

