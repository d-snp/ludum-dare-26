define [], () ->
	initialize: ->
		canvas = document.createElement("canvas")
		ctx = canvas.getContext("2d")

		$('#game > .static-objects').append(canvas)

		canvas.width = 100
		canvas.height = 100
		ctx.fillStyle = '#000000'
		ctx.fillRect(0,0,100,100)

		canvas.style.position = 'absolute'
		@canvas = canvas
		@game.engines.draw.register(@)

	draw: ->
		@canvas.style.top = @position.y + 'px'
		@canvas.style.left = @position.x + 'px'

	attach_to: (entity) ->
		entity.draw = @draw
		@initialize.apply(entity)
