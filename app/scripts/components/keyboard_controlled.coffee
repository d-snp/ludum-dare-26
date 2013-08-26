define ['lib/keyboard', 'component'], (kb, cComponent) ->
	class KeyboardControlled extends cComponent
		register: (entity) ->
			@initialize.apply(entity)
			super(entity)

		initialize: ->
			@control_state = {}

			for control,button of @key_configuration
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

		step: (entity)->
			@reset_input.apply(entity)