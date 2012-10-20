


Dance =


	# Configuration:

	move_threshold: 10


	# State

	# Whole performance: list of list of events by section 
	dance: []

	state: States.done

	# Methods

	register_sample: (sample) ->

		if @state is States.done then return

		time = Date.now()
		@current_samples.push((sample, time))

		# If we've passed the end of the section
		if time > @section_end
			# If this is the latest section of the dance, store it, switch to pause state
			if @section_counter > @dance.length
				@dance.append(@section_events)
				@section_counter = 0
				@section_end += @pause_length
				@state = States.paused
			else
				# Otherwise, just register it and move on
				@section_end += @section_length
				@section_counter += 1


		# If we've passed the end of the song, end
		if time > @song_end then
			@state = States.done
			return

		# If this looks like an event, store it.
		if sample.accel.x + sample.accel.y + sample.accel.z > @move_threshold
			@section_events.push(sample, time)

		# If this is a previously recorded section, check this event.
		if @section_counter < @dance.length
			sa = @section_events
			(dx, dy, dz, dt) = (
			



	start_dance: () ->
		@dance = []
		@current_samples = []
		@current_state = States.paused
	
	end_dance: () ->
		@state = States.done


	# Constants:

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
	
