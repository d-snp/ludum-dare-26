define ['component'], (Component) ->
	class MovesAround extends Component
		step: (entity) ->
			@move.apply(entity)
			@perform(entity)

		perform: (e) ->
			if e.action.name == 'move'
				move = e.action
				distance =  move.distance / move.duration
				dX = 0
				dY = 0
				if move.direction == 'right'
					dX = distance
				if move.direction == 'left'
					dX = -distance
				if move.direction == 'up'
					dY = -distance
				if move.direction == 'down'
					dY = distance

				e.position.x += Math.round(dX)
				e.position.y += Math.round(dY)


		move: () ->
			if @idle
				if @control_state.right.down or @control_state.right.pressed
					way = 'right'
				if @control_state.left.down or @control_state.left.pressed
					way = 'left'
				# Let's not make this game too complicated.
				#if @control_state.up.down or @control_state.up.pressed
				#	way = 'up'
				#if @control_state.down.down or @control_state.down.pressed
				#	way = 'down'

				if way?
					move =
						name: 'move'
						direction: way
						duration: 10
						distance: 30
					@act(move)