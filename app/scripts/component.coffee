define [], () ->
	class Component
		constructor: (game) ->
			@entities = []

		register: (entity) ->
			@entities[entity.id] = entity

		unregister: (entity) ->
			@entities[entity.id] = undefined

		update: ->
			for entity in @entities
				if entity != undefined
					@step(entity)

		step: ->
			throw "Must override step method of Component"