define ['component'], (Component) ->
	class Fights extends Component
		update: ->
			@eachEntity (entity) => entity.suffers = null

			@eachEntity (entity) =>
				# I want to know of each entity which entity
				# is in his reach. For each entity that is
				# in reach, apply the attack to that entity
				if entity.action.attack?
					if (entity.action.effect_frame + entity.action.started) == @game.step
						for opponent in @game.opponents(entity)
							opponent.suffers = entity.action.name

			@eachEntity (entity) =>
				# For each entity, process incoming blow.
				if (entity.action.name == 'hack' and entity.suffers == 'pierce') or
						(entity.action.name == 'pierce' and entity.suffers == 'deflect') or
						(entity.action.name == 'deflect' and entity.suffers == 'hack') or
						(entity.suffers)
					entity.health -= 10
					console.log 'Entity ' + entity.id + ' suffers hit'
					if entity.health < 1
						console.log 'Entity ' + entity.id + ' died.'