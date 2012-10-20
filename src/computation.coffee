Constants =
    move_threshold: 10
    time_score_multiplier: 10
    section_length: 20
    pause_length: 7
    start_length: 3
    score_threshold: 3

Tokens =
    stationary: 0
    up: 1
    down: 2
    left: 3
    right: 4
    forward: 5
    back: 6
        
States =
    paused: 1
    done: 2
    mirroring: 3
    recording: 4
    
Dance =

    state: States.done

    start : () ->
        @section_end = Constants.start_length
        @current_events = 0
        @num_sections = 0
        @dance = []
        @state = States.paused

    register_sample : (sample) ->
        return if @state is States.done
        
        UI.dbg("#{sample.x} #{sample.y} #{sample.z}")
        
        @sample = sample.acceleration
        
        if @state is States.paused
            return @doPaused()
        else if @state is States.mirroring
            return @doMirroring()
        else if @state is States.recording
            return @doRecording()

    time : () -> Date.now()

    doPaused : () ->
        if @time() > @section_end
            @section_end += @section_length*@num_sections
            @current_events = 0
            @state = States.mirroring
    
    doMirroring : () ->
        time = @time()
        unless @match(time)
            @state = States.done
            UI.game_over()
            return
        if time > @section_end
            @section_end += @section_length
            @state = States.recording
        
    doRecording : () ->
        time = @time()
        if @sample.x + @sample.y + @sample.z > Constants.move_threshold
            @dance.push([@sample, time])
        if time > @section_end
            @section_end += @pause_length
            @state = States.paused
            @numSection += 1
     
    match : (time) ->
        [sb, tb] = @dance[@current_events]
        [sa, ta] = [@sample, time]
        [dx, dy, dz] = [Math.abs(sa.x - sb.x), Math.abs(sa.y - sb.y), Math.abs(sa.z - sb.z)]
        dt = Constants.time_score_multiplier * Math.abs(ta - tb)
        return Math.max(dx, dy, dz, dt) <= Constants.score_threshold
