define ['component'], (Component) ->
	class AttacksDefends extends Component
		# So an entity can only issue an action if it is currently not doing
		# anything. The idle action is defend.
		step: (entity) ->
			@attack.apply(entity)

		attack: (way) ->
			if @idle
				if @control_state.pierce_attack.pressed
					way = 'pierce'
				else if @control_state.hack_attack.pressed
					way = 'hack'
				else if @control_state.deflect_attack.pressed
					way = 'deflect'
				if way?
					attack =
						name: way
						duration: 30
						attack: true
						effect_frame: 10
					@act(attack)