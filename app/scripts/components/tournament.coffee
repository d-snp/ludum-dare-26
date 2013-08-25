define ['component'], (Component) ->
	class Tournament extends Component
		constructor: (game) ->
			super(game)
			game.started = new Date()
			game.on('gameOver', (p) => @gameOver(p))
			game.on('matchOver', (p) => @matchOver(p))

		update: ->
			@game.timeLeft = 10 - Math.ceil((new Date() - @game.started) / 1000)

			if @game.timeLeft == 0 
				if @game.playerOne.points > 0 then @game.playerOne.points -= 1
				if @game.playerTwo.points > 0 then @game.playerTwo.points -= 1
				@game.trigger('gameOver', 'draw')

			for e in @game.players
				if e.action.name == 'die' and !e.action.resolved?
					e.action.resolved = true
					@game.opponents(e)[0].points += 1
					@game.trigger('gameOver', @game.opponents(e)[0])

		newRound: ->
			@game.started = new Date()
			for p in @game.players
				p.resetAction()
				@game.resetPlayer(p)

		gameOver: (event) ->
			if event == 'draw'
				console.log 'gameOver: draw'
			else
				console.log 'gameOver: ' + event.id + ' won'
			if @game.playerOne.points == 10
				@game.trigger('matchOver', @game.playerOne)
			else if @game.playerTwo.points == 10
				@game.trigger('matchOver', @game.playerTwo)
			else
				@newRound()

		matchOver: ->
			console.log 'matchOver'
			for p in @game.players
				p.points = 0
			@newRound()