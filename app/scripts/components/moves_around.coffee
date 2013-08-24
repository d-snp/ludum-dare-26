define [], () ->
	initialize: ->

	act: ->
		if @control_state.right.down or @control_state.right.pressed
			@position.x += 10
		if @control_state.left.down or @control_state.left.pressed
			@position.x -= 10
		if @control_state.up.down or @control_state.up.pressed
			@position.y -= 10
		if @control_state.down.down or @control_state.down.pressed
			@position.y += 10
		console.log 'act'

	attach_to: (entity) ->
		entity.game.engines.action.register(entity)
		entity.act = @act
		@initialize.apply(entity)
