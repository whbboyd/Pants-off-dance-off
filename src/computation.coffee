Constants =
    move_threshold: 15
    time_score_multiplier: 10
    section_length: 3609
    pause_length: 6347.7549
    prelude_length: 3317.550897
    initial_length: 3609
    score_threshold: 15
        
States =
    prelude: -1
    initial: 0
    paused: 1
    done: 2
    mirroring: 3
    recording: 4
 
Token = 
    x: 0
    y: 1
    z: 2
    get: (s)->
        switch Math.max(Math.abs(s.x), Math.abs(s.y), Math.abs(s.z))
            when Math.abs(s.x) then 0
            when Math.abs(s.y) then 1
            when Math.abs(s.z) then 2
 
Dance =

    state: States.done

    start : () ->
        @section_end = Constants.prelude_length
        @current_events = 0
        @num_sections = 0
        @dance = []
        @state = States.prelude
        UI.msg 'Prelude'
        Sound.start 'song'

    register_sample : (sample) ->
        return if @state is States.done
        
        @sample = sample.acceleration
        # UI.dbg("#{@sample.x} #{@sample.y} #{@sample.z}")
        
        switch @state
            when States.prelude   then @doPrelude()
            when States.initial   then @doInitial()
            when States.paused    then @doPaused()
            when States.mirroring then @doMirroring()
            when States.recording then @doRecording()

    time : () -> Sound.files['song'].currentTime * 1000.0
    
    doPrelude : () ->
        if @time() > @section_end
            UI.msg 'Initial'
            Sound.start 'countdown'
            @section_end += Constants.initial_length
            @state = States.initial
    
    doInitial : () ->
        if @time() > @section_end
            UI.msg 'Recording'
            @section_end += Constants.section_length
            @state = States.recording

    doPaused : () ->
        if @time() > @section_end
            UI.msg 'Mirroring'
            @section_end += Constants.section_length * @num_sections
            @current_events = 0
            @state = States.mirroring
    
    doMirroring : () ->
        time = @time()
        if @threshold() and not @match()
            UI.msg 'Game Over!'
            Sound.start 'failure'
            @state = States.done
            return
        @current_events += 1
        if time > @section_end
            UI.msg 'Recording'
            @section_end += Constants.section_length
            @state = States.recording
        
    doRecording : () ->
        time = @time()
        if @threshold()
            @dance.push(Token.get(@sample))
        if time > @section_end
            UI.msg 'Paused'
            Sound.start 'swap'
            @section_end += Constants.pause_length
            @num_sections += 1
            @state = States.paused
     
    threshold : () ->
        Math.abs(@sample.x) + Math.abs(@sample.y) + Math.abs(@sample.z) > Constants.move_threshold

    match : () ->
        Token.get(@sample) == @dance[@current_events]
