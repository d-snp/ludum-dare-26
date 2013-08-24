define [], () ->
	initialize: ->
		canvas = document.createElement("canvas")
		ctx = canvas.getContext("2d")

		$('#game > .objects').append(canvas)

		if @image
			image = new Image()
			image.src = @image.url 
			image.onload = () ->
				if @animation
					canvas.width = image.width / @animation.frames
				else
					canvas.width = image.width
				canvas.height = image.height
				canvas.image = image
				canvas.ctx = ctx
				ctx.clear = -> @clearRect(0,0,canvas.width,canvas.height)

		canvas.style.position = 'absolute'
		@canvas = canvas
		@game.engines.draw.register(@)

	draw: ->
		if @animation
			step = @animation.duration / @animation.frames
			@animation.began ?= performance.now()
			@animation.previous_frame ?= 0
			current_frame = Math.round((performance.now() - @animation.began?) / step) % @animation.frames
			if @animation.previous_frame != current_frame
				@animation.previous_frame = current_frame
				if @canvas.image?
					@canvas.ctx.clear()
					frame_width = @canvas.image.width / @animation.frames
					@canvas.ctx.drawImage(
						@canvas.image,
						frame_width * current_frame,
						0,
						frame_width,
						@canvas.image.height,
						0,0,
						frame_width,
						@canvas.image.height
					 )

		@canvas.style.top = @position.y + 'px'
		@canvas.style.left = @position.x + 'px'

	attach_to: (entity) ->
		entity.draw = @draw
		@initialize.apply(entity)