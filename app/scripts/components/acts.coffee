define ['component'], (Component) ->
	class Acts extends Component
		register: (entity) ->
			super(entity)
			entity.action = entity.default_action
			entity.started = 0
			entity.idle = true
			entity.act = (action) =>
				console.log 'Entity ' + entity.id + ' ' + action.name + 's'
				entity.idle = false
				entity.action = action
				entity.action.started = @game.step

		step: (entity) ->
			if entity.action.duration?
				if @game.step - entity.action.duration > entity.action.started
					entity.action = entity.default_action
					entity.idle = true


