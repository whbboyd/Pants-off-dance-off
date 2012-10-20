


Dance =


	# Configuration:

	beats: 4
	samples_per_beat: 5
	
	rel_score_threshold: 2
	abs_score_threshold: 10

	move_threshold: 10


	# State

	# Whole performance: list of bars
	dance: []

	# Current bar: stored as a list of intermediate samples
	current_samples: []

	samples_so_far: 0
	bars_so_far: 0

	state: States.done

	score: 0


	# Methods

	register_sample: (sample) ->

		if @state is States.done then return

		# If we're paused, ignore this sample
		if @state is States.pause
			if @current_samples < @samples_per_beat * @beats:
				@current_samples.append(null)
				return @state
			else
				@current_samples = []
				@state = States.running

		@current_samples.push(sample)

		# If we've passed the end of the bar, register it, score it if possible, reset the sample cache, carry on
		if @current_samples.length >= @samples_per_beat * @beats
			this_bar = tokenize_bar(@current_samples)
			# If this is the last bar of the dance, store it
			if @bars_so_far >= @dance.length
				@score = 0
				@dance.push(this_bar)
				@state = States.pause
			else
				# Otherwise, register and score it.
				this_score = score_bar(this_bar, @dance[-1])
				@score += this_score
				if this_score > @rel_score_threshold or @score > @abs_score_threshold:
					ui.game_over()
					@state = States.done


			@current_samples = []


		return @state

	tokenize_bar: (samples) ->
		# end of bar; compute tokens
		# Euler integrate once to find all peaks
		# Pick max directional acc at each peak over thresh



	score_bar: (bar_a, bar_b) ->
		# score a bar: compute Levenstein distance between bars


	start: () ->
		@dance = []
		@current_samples = []
		@current_state = States.running


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
		pause: 1
		done: 2
	
