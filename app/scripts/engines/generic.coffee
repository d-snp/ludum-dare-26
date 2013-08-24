define [], () ->
	(action) ->
		initialize: (game) ->
			@entities = []
			@

		register: (entity) ->
			@entities[entity.id] = entity

		unregister: (entity) ->
			@entities[entity.id] = undefined

		update: ->
			for entity in @entities
				if entity != undefined
					entity[action]()
