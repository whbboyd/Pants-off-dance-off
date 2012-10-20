Sound =
  files: {}
  
  init : (name, path) ->
    @files[name] = f = new Audio(path)
    f.play()
    
    if f.readyState != 4
      p = () => f.pause()
      n = () -> false
      r = () => f.currentTime = 0.1
      f.addEventListener 'canplaythrough', n, false
      f.addEventListener 'load', n, false
      f.addEventListener 'ended', r, false
      setTimeout p, 1
  
  start : (name) ->
    @files[name].play()
    
Sound.init 'song',       'audio/sweetdaftstarships.mp3'
Sound.init 'countdown',  'audio/countdown.mp3'
Sound.init 'failure',    'audio/failure.mp3'
Sound.init 'swap',       'audio/swap.mp3'
Sound.init 'nextplayer', 'audio/nextplayer.mp3'
Sound.init 'keepgoing',  'audio/keepgoing.mp3'