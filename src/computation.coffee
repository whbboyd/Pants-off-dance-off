Constants =
    move_threshold: 10
    time_score_multiplier: 10
    section_length: 20
    pause_length: 5
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
    running: 0
    paused: 1
    done: 2
    
Dance =

    # State

    # Whole performance: list of list of events by section 
    dance: []

    section_events: []
    section_counter: 0
    section_end: 0


    state: States.done

    # Methods

    register_sample: (sample) ->

        # If we're not running, exit now
        return if @state is States.done
    
        sample = sample.acceleration
        UI.dbg("#{sample.x} #{sample.y} #{sample.z}")

        # We need to keep track of where in the song we are
        time = Date.now()

        # If we're paused, wait until we hit the end of the pause
        if @state is States.paused and time < @section_end
            return
        else
            @state = States.running
            @section_end += Constants.section_length

        # If we've passed the end of the section
        if time > @section_end
            # If this is the latest section of the dance, store it, switch to pause state
            if @section_counter > @dance.length
                @dance.append(@section_events)
                @section_events = []
                @section_counter = 0
                @section_end += Constants.pause_length
                @state = States.paused
            else
                # Otherwise, just register it and move on
                @section_end += Constants.section_length
                @section_counter += 1

        #TODO: If we've passed the end of the song, end
#        if time > @song_end
#            @state = States.done
#            UI.victory()
#            return

        event_check = false

        # If this looks like an event, store it.
        if sample.x + sample.y + sample.z > Constants.move_threshold
            @section_events.push([sample, time])
            event_check = true

        #TODO: if there's a recorded event we should be checking against, do so

        # If this is a previously recorded section, check this event.
        if @section_counter < @dance.length and event_check
            # MATH GOES HERE
            ea = @section_events[-1]
            sa = ea[0]
            ta = ea[1]
            eb = @dance[-1][@section_events.length - 1]
            sb = eb[0]
            tb = eb[1]
            [dx, dy, dz] = [Math.abs(sa.x - sb.x), Math.abs(sa.y - sb.y), Math.abs(sa.z - sb.z)]
            dt = Constants.time_score_multiplier * Math.abs(ta - tb)

            # Player screwed up
            if Math.max(dx, dy, dz, dt) > Constants.score_threshold
                @end_dance()
                return

    start_dance: () ->
        @dance = []
        @state = States.running

    end_dance: () ->
        @state = States.done
        UI.game_over()

