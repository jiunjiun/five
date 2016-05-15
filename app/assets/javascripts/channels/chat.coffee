App.chat = App.cable.subscriptions.create { channel: "ChatChannel", room: "Best Room" },
  connected: ->
    $('#messages').scrollTop(99999);
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    $('#messages').append(data['message']).scrollTop(99999);

  speak: (content) ->
    @perform 'speak', content: content

  exit: (content) ->
    @perform 'exit'

$(document).on 'keypress', '[data-behavior~=chat_speaker]', (event) ->
  if event.keyCode is 13 # return/enter = send
    speak()
    return false

$(document).on 'click', '.speak', ->
  speak()
  return false

$(document).on 'click', '.exit', ->
  swal(
    title: '確定要離開?'
    # text: 'You won\'t be able to revert this!'
    type: 'error'
    showCancelButton: true
    confirmButtonColor: '#3085d6'
    cancelButtonColor: '#d33'
    cancelButtonText: '取消'
    confirmButtonText: '確定離開').then (isConfirm) ->
    if isConfirm
      App.chat.exit()
      $('#messages').html('')
    return
  return false

speak = ->
  content = $('.chat-controls-input input')
  App.chat.speak content.val()
  content.val('')

