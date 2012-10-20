window.UI =
  message: () -> document.getElementById("message")
  msg: (m) -> @message().innerHTML = m
  
  action: () -> document.getElementById("action")
  ref: (m) -> @action().innerHTML = m
  
  states:
    initial: 0
    active: 1
    lost: 2
    victory: 3
    
  state: @states.initial
  
  stop: () ->
    @state = @states.initial
    @ref 'start'
    window.ondevicemotion = false
  
  start: () ->
    @stop()
    @ref 'reset'
    @state = @states.active
    Sound.play()
    
    for i in Sound.timings
      window.setTimeout("Sound.countdown()", i)
    
    window.setTimeout("Sound.countdown()", )
    for i in [3..1]
      window.setTimeout("")
    @msg '3'
    
    
    window.setTimeout("UI.msg('2');", 1000)
    window.setTimeout("UI.msg('1');", 2000)
    window.setTimeout("UI.start();", 2999)
    @msg 'Dance.'
    window.ondevicemotion = Dance.register_sample
    
    
    
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
    @ref "start"
    @action().onclick = () ->
      UI.start()
      false
      