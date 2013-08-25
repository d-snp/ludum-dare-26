define ['component'], (Component) ->
	class Acts extends Component
		register: (entity) ->
			super(entity)
			entity.resetAction = @resetAction
			entity.resetAction()
			entity.act = (action) =>
				console.log 'Entity ' + entity.id + ' ' + action.name + 's'
				entity.idle = false
				entity.action = action
				entity.action.started = @game.step
				entity.animation = entity.animations[action.name]

		resetAction: ->
			@action = @default_action
			@idle = true
			@started = 0
			@animation = null

		step: (entity) ->
			if entity.action.duration?
				if @game.step - entity.action.duration > entity.action.started
					entity.resetAction()

