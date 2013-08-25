#global define
define ['components/canvas', 'components/keyboard_controlled',
 'components/moves_around', 'components/attacks_defends', 'components/fights'
 'components/acts'], (
		CanvasComponent,KeyboardControlled,MovesAround,AttacksDefends,Fights,Acts) ->
	initialize: ->
		@step = 0
		@entities = []
		@initializeComponents()

	initializeComponents: ->
		# NOTE: this only magically works as long as for loops magically iterate over this loop
		# in declaration order. If it is reordered stuff will break.
		@components =
			canvas: new CanvasComponent(@)
			movesAround: new MovesAround(@)
			attacksDefends: new AttacksDefends(@)
			fights: new Fights(@)
			acts: new Acts(@)
			keyboardControlled: new KeyboardControlled(@)

	start: ->
		@initializeScene()
		@runGameLoop()

	initializeScene: ->
		@initializeBackground()
		@initializeForeGround()
		@playerOne = @createPlayer(250, 'right',true)
		@playerTwo = @createPlayer(450, 'left',false)

	createPlayer: (x, faces, keyboard) ->
		entity = @createEntity(
			health: 30
			faces: faces
			position:
				x: x
				y: 250

			image:
				url: 'images/lame_guy.png'

			animation:
				frames: 5
				duration: 1000

			default_action: (if keyboard then name: 'defend' else name: 'none')
		)

		@components.canvas.register(entity)
		@components.keyboardControlled.register(entity)
		@components.movesAround.register(entity)
		@components.attacksDefends.register(entity)
		@components.fights.register(entity)
		@components.acts.register(entity)
		entity

	opponents: (player) ->
		if player == @playerOne
			[@playerTwo]
		else
			[@playerOne]

	runGameLoop: ->
		STEPS_PER_SECOND = 15
		setInterval (=> @update()), 1000 / STEPS_PER_SECOND

	update: ->
		console.log 'step'
		@step += 1
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

