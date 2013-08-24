define [], () ->
	initialize: ->

	draw: ->
		@canvas.style.top = @position.y + 'px'
		@canvas.style.left = @position.x + 'px'

	attach_to: (entity) ->
		entity.draw = @draw
		@initialize.apply(entity)