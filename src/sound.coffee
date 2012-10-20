Sound =
  files: {}
  
  init : (name, path) ->
    @files[name] = f = new Audio(path)
    f.play()
    
    if f.readyState != 4
      n = () -> false
      f.addEventListener 'canplaythrough', n, false
      f.addEventListener 'load', n, false
      f.addEventListener 'ended', (() => f.currentTime = 0.1), false
      setTimeout((() => f.pause()), 1)
  
  start : (name) ->
    @files[name].play()
  
  is_finished : (name) ->
    @files[name].currentTime == 0.1

  beat : (name, bpm) ->
    @files[name].duration/bpm * 100
    
Sound.init 'song',       'audio/sweetdaftstarships.mp3' 
Sound.init 'countdown',  'audio/three-two-one.mp3'
Sound.init 'failure',    'audio/failure.mp3'
Sound.init 'swap',       'audio/three-two-one-swap-three-two-one.mp3'
