is_leave = false
App.chat = App.cable.subscriptions.create { channel: "ChatChannel", room: "Best Room" },
  connected: ->
    # Called when the subscription is ready for use on the server
    console.log 'connected'
    $('#messages').scrollTop(99999)

  disconnected: ->
    # Called when the subscription has been terminated by the server
    console.log 'disconnected'

  received: (data) ->
    console.log data
    if data.message
      $('#messages')
        .append(data.message)
        .scrollTop(99999)
    switch data.action
      when 'init'
        is_leave = data.options.is_leave
      when 'found'
        @found()
      when 'leave'
        is_leave = true

    $('.chat-controls-input input').prop('disabled', is_leave)

  seek: () ->
    # 找妹子
    @perform 'seek'
    $('body .main').addClass('hide')

  found: () ->
    # 發現妹子
    $('.wait_user').addClass('hide')

  speak: (content) ->
    # 跟妹子說話
    @perform 'speak', content: content

  leave: () ->
    # 被妹子打槍
    @perform 'leave'
    $('body .main').removeClass('hide')

$(document).on 'click', '.start_chat .start', ->
  App.chat.seek()
  return false

$(document).on 'keypress', '[data-behavior~=chat_speaker]', (event) ->
  if event.keyCode is 13 # return/enter = send
    speak()
    return false

$(document).on 'click', '.speak', ->
  speak()
  return false

$(document).on 'click', 'button.btn.leave', ->
  unless is_leave
    swal(
      title: '確定要打槍對方?!'
      # title: '確定要打槍對方?!'
      title: '#'
      type: 'error'
      showCancelButton: true
      confirmButtonColor: '#3085d6'
      cancelButtonColor: '#d33'
      cancelButtonText: '取消'
      confirmButtonText: '確定打槍').then (isConfirm) ->
      if isConfirm
        App.chat.leave()
        $('#messages').html('')
      return
  else
    App.chat.leave()
    $('#messages').html('')
    is_leave = false
    $('.chat-controls-input input').prop('disabled', is_leave)
  return false

speak = ->
  content = $('.chat-controls-input input')
  if content.val().length > 0
    App.chat.speak content.val()
    content.val('')

