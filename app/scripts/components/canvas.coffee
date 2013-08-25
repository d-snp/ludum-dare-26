define ['component'], (cComponent) ->
	class Canvas extends cComponent
		constructor: (entity) ->
			super(entity)
			@runDrawLoop()

		register: (entity) ->
			@initialize.apply(entity)
			super(entity)

		step: ->
			# Do Nothing

		runDrawLoop: ->
			requestAnimationFrame => @runDrawLoop()
			@render()

		render: ->
			for entity in @entities
				if entity != undefined
					@draw.apply(entity)

		initialize: ->
			canvas = document.createElement("canvas")
			ctx = canvas.getContext("2d")

			$('#game > .objects').append(canvas)

			if @image
				image = new Image()
				image.src = @image.url 
				image.onload = () =>
					@image.ready = true
					canvas.width = @image.width
					canvas.height = @image.height
					canvas.image = image
					canvas.ctx = ctx
					ctx.clear = -> @clearRect(0,0,canvas.width,canvas.height)

			canvas.style.position = 'absolute'
			@canvas = canvas

		draw: ->
			if @animation
				step = @animation.duration / @animation.frames
				@animation.began ?= performance.now()
				@animation.previous_frame ?= -1
				current_frame = Math.round((performance.now() - @animation.began?) / step) % @animation.frames
				if @animation.previous_frame != current_frame
					@animation.previous_frame = current_frame
					if @canvas.image?
						@canvas.ctx.clear()
						frame_width = @image.width

						if @faces == 'left' and !@canvas.flipped?
							@canvas.ctx.translate(@canvas.width,0)
							@canvas.ctx.scale(-1,1)
							@canvas.flipped = true
						else if @faces != 'left' and @canvas.flipped?
							@canvas.ctx.translate(@canvas.width,0)
							@canvas.ctx.scale(-1,1)
							@canvas.flipped = true

						@canvas.ctx.drawImage(
							@canvas.image,
							frame_width * current_frame,
							@canvas.height * @animation.index,
							frame_width ,
							@canvas.height,
							0,0,
							frame_width,
							@canvas.height
						 )
			else if @image.ready && !@image.drawn
				if @faces == 'left' and !@canvas.flipped?
					@canvas.ctx.translate(@canvas.width,0)
					@canvas.ctx.scale(-1,1)
					@canvas.flipped = true
				else if @faces != 'left' and @canvas.flipped?
					@canvas.ctx.translate(@canvas.width,0)
					@canvas.ctx.scale(-1,1)
					@canvas.flipped = true
				@canvas.ctx.drawImage(@canvas.image,0,0)
				@image.drawn = true



			@canvas.style.top = @position.y + 'px'
			@canvas.style.left = @position.x + 'px'