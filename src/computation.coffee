Constants =
    move_threshold: 10
    time_score_multiplier: 10
    section_length: 481.39*8
    pause_length: 481.39*14
    prelude_length: 481.39*3
    initial_length: 481.39*3
    score_threshold: 3
        
States =
    prelude: -1
    initial: 0
    paused: 1
    done: 2
    mirroring: 3
    recording: 4
    
Dance =

    state: States.done

    start : () ->
        @section_end = Constants.prelude_length
        @current_events = 0
        @num_sections = 0
        @dance = []
        @state = States.initial

    register_sample : (sample) ->
        return if @state is States.done
        
        @sample = sample.acceleration
        UI.dbg("#{@sample.x} #{@sample.y} #{@sample.z}")
        
        switch @state
            when States.prelude   then @doPrelude()
            when States.initial   then @doInitial()
            when States.paused    then @doPaused()
            when States.mirroring then @doMirroring()
            when States.recording then @doRecording()

    time : () -> Date.now()
    
    doPrelude : () ->
        UI.msg 'Prelude'
        if @time() > @section_end
            UI.msg 'Initial'
            @section_end += Constants.initial_length
            @state = States.initial
            Sound.start '321'
    
    doInitial : () ->
        if @time() > @section_end
            UI.msg 'Recording'
            @section_end += Constants.section_length
            @state = States.recording
            Sound.start '321swap321'

    doPaused : () ->
        if @time() > @section_end
            UI.msg 'Mirroring'
            @section_end += Constants.section_length*@num_sections
            @current_events = 0
            @state = States.mirroring
    
    doMirroring : () ->
        time = @time()
        unless @match(time)
            UI.msg 'Game Over!'
            Sound.start 'failure'
            @state = States.done
            return
        if time > @section_end
            UI.msg 'Recording'
            @section_end += Constants.section_length
            @state = States.recording
        
    doRecording : () ->
        @dbg 'Do Recording'
        time = @time()
        if @sample.x + @sample.y + @sample.z > Constants.move_threshold
            @dance.push([@sample, time])
        if time > @section_end
            UI.msg 'Paused'
            Sound.start 'swap'
            @section_end += Constants.pause_length
            @state = States.paused
            @numSection += 1
     
    match : (time) ->
        [sb, tb] = @dance[@current_events]
        [sa, ta] = [@sample, time]
        [dx, dy, dz] = [Math.abs(sa.x - sb.x), Math.abs(sa.y - sb.y), Math.abs(sa.z - sb.z)]
        dt = Constants.time_score_multiplier * Math.abs(ta - tb)
        return Math.max(dx, dy, dz, dt) <= Constants.score_threshold
