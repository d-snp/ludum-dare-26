#global define
define ['components/canvas', 'components/keyboard_controlled', 'components/moves_around'], (canvasComponent,keyboardControlled,movesAround) ->
	initialize: ->
		@step = 0
		@entities = []
		@engines = {}
		@initializeComponents()

	initializeComponents: ->
		@components =
			canvas: new canvasComponent(@)
			keyboardControlled: new keyboardControlled(@)
			movesAround: new movesAround(@)

	start: ->
		@initializeScene()
		@runGameLoop()

	initializeScene: ->
		@initializeBackground()
		@initializeForeGround()
		@createPlayer()
		@createOpponent()


	createPlayer: ->
		entity = @createEntity(
			position:
				x: 250
				y: 250

			image:
				url: 'images/lame_guy.png'

			animation:
				frames: 5
				duration: 1000
		)

		@components.canvas.register(entity)
		@components.keyboardControlled.register(entity)
		@components.movesAround.register(entity)

	createOpponent: ->
		entity = @createEntity(
			faces: 'left'
			position:
				x: 450
				y: 250

			image:
				url: 'images/lame_guy.png'

			animation:
				frames: 5
				duration: 1000
		)

		@components.canvas.register(entity)
		@components.keyboardControlled.register(entity)
		@components.movesAround.register(entity)

	runGameLoop: ->
		STEPS_PER_SECOND = 15
		setInterval (=> @update()), 1000 / STEPS_PER_SECOND

	update: ->
		console.log 'step'
		@step += 1
		for name,engine of @engines
			engine.update()
		for name,component of @components
			component.update() if component.update?

	createEntity: (entity={})->
		entity.id = @entities.length
		entity.game = @
		@entities.push entity
		entity

	eachEntity: (block) ->
		for entity in @entities
			if entity != null
				block(entity)

	initializeBackground: () ->
		canvas = document.createElement("canvas")
		ctx = canvas.getContext("2d")

		$('#game > .background').append(canvas)

		resize = () ->
			canvas.width = canvas.parentNode.clientWidth
			canvas.height = canvas.parentNode.clientHeight
			ctx.fillStyle = '#3333ff'
			ctx.fillRect(0,0,canvas.width,canvas.height)

		resize()
		$(window).resize resize
	
	initializeForeGround: () ->
		canvas = document.createElement("canvas")
		ctx = canvas.getContext("2d")

		$('#game > .foreground').append(canvas)

		resize = () ->
			canvas.width = canvas.parentNode.clientWidth
			canvas.height = canvas.parentNode.clientHeight
			ctx.fillStyle = '#303030'
			ctx.fillRect(0,0,canvas.width,canvas.height)
			ctx.strokeStyle = "rgba(0,0,0,1)";
			ctx.globalCompositeOperation = 'destination-out'
			ctx.fillRect(10,10, canvas.width - 20, canvas.height - 20)

		resize()
		$(window).resize resize

