Constants =
    move_threshold: 2
    time_score_multiplier: 10
    section_length: 3609 / 2
    pause_length: 3609 / 2
    prelude_length: 3609 / 2
    initial_length: 3609 / 2
    score_threshold: 15
        
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
        @state = States.prelude
        UI.msg 'Prelude'
        Sound.start 'song'

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

    time : () -> Sound.files['song'].currentTime * 1000.0
    
    doPrelude : () ->
        if @time() > @section_end
            UI.msg 'Initial'
            @section_end += Constants.initial_length
            @state = States.initial
            Sound.start 'countdown'
    
    doInitial : () ->
        UI.dbg("In initial")
        if @time() > @section_end
            UI.msg 'Recording'
            @section_end += Constants.section_length
            @state = States.recording
            Sound.start 'swap'

    doPaused : () ->
        UI.dbg("In paused")
        if @time() > @section_end
            UI.msg 'Mirroring'
            @section_end += Constants.section_length * @num_sections
            @current_events = 0
            @state = States.mirroring
    
    doMirroring : () ->
        UI.dbg("In mirroring")
        time = @time()
        unless @match(time)
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
        UI.dbg("In recording")
        time = @time()
        if Math.abs(@sample.x) + Math.abs(@sample.y) + Math.abs(@sample.z) > Constants.move_threshold
            @dance.push([@sample, time])
        if time > @section_end
            UI.msg 'Paused'
            Sound.start 'swap'
            @section_end += Constants.pause_length
            @num_sections += 1
            @state = States.paused
     
    match : (time) ->
        console.log @current_events, @dance
        [sb, tb] = @dance[@current_events]
        [sa, ta] = [@sample, time]
        [dx, dy, dz] = [Math.abs(sa.x - sb.x), Math.abs(sa.y - sb.y), Math.abs(sa.z - sb.z)]
        #dt = Constants.time_score_multiplier * Math.abs(ta - tb)
        dt = 0
        UI.dbg("#{dx}, #{dy}, #{dz}: #{dt}")
        return Math.max(dx, dy, dz, dt) <= Constants.score_threshold

