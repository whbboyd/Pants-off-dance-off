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
    
Sound.init 'song',       'audio/sweetdaftstarships.mp3'
Sound.init 'three',      'audio/three.mp3'
Sound.init 'two',        'audio/two.mp3'
Sound.init 'one',        'audio/one.mp3'
Sound.init 'failure',    'audio/failure.mp3'
Sound.init 'swap',       'audio/swap.mp3'
Sound.init 'nextplayer', 'audio/nextplayer.mp3'
Sound.init 'keepgoing',  'audio/keepgoing.mp3'
