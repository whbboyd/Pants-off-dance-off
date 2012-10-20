window.UI =
  message: () -> document.getElementById("message")
  msg: (m) -> @message().innerHTML = m
  
  action: () -> document.getElementById("action")
  ref: (m) -> @action().innerHTML = m
  
  dbg: (m) ->
    window.console?.log(m)
    document.getElementById("debug").innerHTML = m
  
  states:
    initial: 0
    active: 1
    lost: 2
    victory: 3
    
  state: 0
  
  stop: () ->
    @dbg 'UI.stop called'
    @state = @states.initial
    @ref 'start'
    window.ondevicemotion = false
  
  start: () ->
    @stop()
		
    @state = @states.active
    @dbg 'UI.start called'
    @ref 'reset'
    @msg 'Dance.'
    window.ondevicemotion = -> Dance.register_sample()
		Dance.start_dance()

  game_over : () ->
    @stop()
    @state = @states.lost
    @msg 'You Lose.'
    Sound.failure()
    
  victory : () ->
    return unless @state == @states.active
    @stop()
    @state = @states.victory
    @msg 'Victory!'
  
  bind: () ->
    @msg 'Ready thyself.'
    @ref 'start'
    @action().onclick = () ->
      UI.start()
      false
      
