window.UI =
  message: () -> document.getElementById("message")
  msg: (m) -> @message().innerHTML = m
  
  action: () -> document.getElementById("action")
  ref: (m) -> @action().innerHTML = m
  
  dbg: (m) ->
    window.console?.log(m)
    document.getElementById("debug").innerHTML = m
  
  stop: () ->
    @dbg 'UI.stop called'
    @ref 'start'
    window.ondevicemotion = false
  
  start: () ->
    @stop()
    @dbg 'UI.start called'
    @ref 'reset'
    @msg 'Dance.'
    Dance.start()
    window.ondevicemotion = (e) ->
      Dance.register_sample(e)
  
  bind: () ->
    @msg 'Ready thyself.'
    @ref 'start'
    @action().onclick = () ->
      UI.start()
      false
