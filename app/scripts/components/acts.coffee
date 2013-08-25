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
				entity.animation.began = undefined
				entity.previous_frame = undefined

		resetAction: ->
			@action = @default_action
			@idle = true
			@started = 0
			@animation = @default_animation
			@animation.began = undefined
			@animation.previous_frame = undefined

		step: (entity) ->
			if entity.action.duration?
				if @game.step - entity.action.duration > entity.action.started
					entity.resetAction()

