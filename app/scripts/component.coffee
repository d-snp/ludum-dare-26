define [], () ->
	class Component
		constructor: (game) ->
			@game = game
			@entities = []

		register: (entity) ->
			@entities[entity.id] = entity

		unregister: (entity) ->
			@entities[entity.id] = undefined

		update: ->
			@eachEntity (entity) => @step(entity)

		eachEntity: (action) ->
			for entity in @entities
				if entity != undefined
					action(entity)

		step: ->
			throw "Must override step or update method of Component"