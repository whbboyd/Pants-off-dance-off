// Generated by CoffeeScript 1.3.3

window.UI = {
  message: function() {
    return document.getElementById("message");
  },
  msg: function(m) {
    return this.message().innerHTML = m;
  },
  action: function() {
    return document.getElementById("action");
  },
  ref: function(m) {
    return this.action().innerHTML = m;
  },
  dbg: function(m) {
    var _ref;
    if ((_ref = window.console) != null) {
      _ref.log(m);
    }
    return document.getElementById("debug").innerHTML = m;
  },
  states: {
    initial: 0,
    active: 1,
    lost: 2,
    victory: 3
  },
  state: 0,
  stop: function() {
    this.dbg('UI.stop called');
    this.state = this.states.initial;
    this.ref('start');
    return window.ondevicemotion = false;
  },
  start: function() {
    this.stop();
    this.state = this.states.active;
    this.dbg('UI.start called');
    this.ref('reset');
    this.msg('Dance.');
    Sound.start('song');
    window.ondevicemotion = function(e) {
      return Dance.register_sample(e);
    };
    return Dance.start_dance();
  },
  game_over: function() {
    this.stop();
    this.state = this.states.lost;
    this.msg('You Lose.');
    return Sound.failure();
  },
  victory: function() {
    if (this.state !== this.states.active) {
      return;
    }
    this.stop();
    this.state = this.states.victory;
    return this.msg('Victory!');
  },
  bind: function() {
    this.msg('Ready thyself.');
    this.ref('start');
    return this.action().onclick = function() {
      UI.start();
      return false;
    };
  }
};
