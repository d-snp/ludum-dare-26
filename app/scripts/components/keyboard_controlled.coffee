define ['lib/keyboard'], (kb) ->
	initialize: ->
		@control_state = {}

		key_configuration =
			right: 'right'
			left: 'left'
			down: 'down'
			up: 'up'

		for control,button of key_configuration
			((control) =>
				@control_state[control] =
					down: false
					pressed: false

				kb.on button,
					(=>
					 @control_state[control].down = true
					),
					(=>
						if @control_state[control].down
							@control_state[control].pressed = true
						@control_state[control].down = false
					)
			)(control)

	reset_input: ->
		for control,state of @control_state
			state.pressed = false

	attach_to: (entity) ->
		entity.reset_input = @reset_input
		entity.game.engines.input.register(entity)
		@initialize.apply(entity)
