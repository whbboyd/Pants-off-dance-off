UI =
  timer: () -> document.getElementById("timer")
  startCountdown: () ->
    @timer.innerHTML = '5';
    window.setTimeout("UI.timer.innerHTML = '4';", 2000);
    window.setTimeout("UI.timer.innerHTML = '3';", 3000);
    window.setTimeout("UI.timer.innerHTML = '2';", 4000);
    window.setTimeout("UI.timer.innerHTML = '1';", 5000);
    window.setTimeout("UI.start()", 6000)
    
  bind: () ->
    link = document.getElementById("start")
    link.innerHTML = "GO"
    link.onclick = () ->
      @startCountdown()
      Dance.reset()
      # TODO
      