#global define
define ['components/canvas', 'components/keyboard_controlled',
 'components/moves_around', 'components/attacks_defends', 'components/fights'
 'components/acts','components/tournament'], (
		CanvasComponent,KeyboardControlled,MovesAround,AttacksDefends,Fights,Acts,Tournament) ->
	initialize: ->
		@step = 0
		@entities = []
		@eventSubscriptions = {}
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
			tournament: new Tournament(@)
			keyboardControlled: new KeyboardControlled(@)

	start: ->
		@initializeScene()
		setTimeout (=> 
			@components.tournament.start()
			@runGameLoop()), 5000

	initializeScene: ->
		@initializeBackground()
		@initializeForeGround()
		@playerOne = @createPlayer('right',true)
		@playerTwo = @createPlayer('left',false)

	createPlayer: (faces, keyboard) ->
		entity = @createEntity(
			points: 0
			faces: faces

			image:
				url: 'images/kendo_player.png'
				width: 80
				height: 80

			animations:
				move:
					index: 1
					frames: 5
					duration: 500
				pierce:
					index: 2
					frames: 5
					duration: 600
				hack:
					index: 3
					frames: 5
					duration: 1100
				deflect:
					index: 4
					frames: 5
					duration: 1100

			default_animation:
				index: 0
				frames: 5
				duration: 1000

			default_action: 'defend'
		)
		@resetPlayer(entity)
		@players.push entity


		if entity.faces == 'right'
			entity.key_configuration =
				right: 'd'
				left: 'a'
				down: 's'
				up: 'w'
				pierce_attack: 'f'
				hack_attack: 't'
				deflect_attack: 'y'
		else
			entity.key_configuration =
				right: 'right'
				left: 'left'
				down: 'down'
				up: 'up'
				pierce_attack: 'num1'
				hack_attack: 'num2'
				deflect_attack: 'num3'


		@components.canvas.register(entity)
		@components.keyboardControlled.register(entity)
		@components.movesAround.register(entity)
		@components.attacksDefends.register(entity)
		@components.fights.register(entity)
		@components.acts.register(entity)
		entity

	resetPlayer: (p) ->
		p.health = 10
		x = if p.faces == 'right' then 250 else 450
		p.position =
				x: x
				y: 250

	players: []

	opponents: (player) ->
		if player == @playerOne
			[@playerTwo]
		else
			[@playerOne]

	runGameLoop: ->
		STEPS_PER_SECOND = 30
		setInterval (=> @update()), 1000 / STEPS_PER_SECOND

	update: ->
		console.log 'step'
		return if @paused
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

	on: (name,block) ->
		@eventSubscriptions[name] ?= []
		id = @eventSubscriptions[name].length
		@eventSubscriptions[name].push(block)
		console.log 'subscribed to ' + name
		id

	trigger: (name,event) ->
		if @eventSubscriptions[name]?
			for block in @eventSubscriptions[name]
				console.log 'going to trigger ' + name
				block(event) if block?

	initializeBackground: () ->
		canvas = document.createElement("canvas")
		ctx = canvas.getContext("2d")

		$('#game > .background').append(canvas)

		canvas.className = 'plateau'
		canvas.width = 400
		canvas.height = 300
		ctx.fillStyle = '#000000'
		ctx.fillRect(0,0,canvas.width,canvas.height)

		image = new Image()
		image.src = "images/plateau.png"
		image.onload = () =>
			ctx.drawImage(image,0,0)
	
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

