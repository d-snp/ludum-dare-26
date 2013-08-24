#global define
define [], () ->
	initialize: () ->
		@entities = []
		@runDrawLoop()
		@

	runDrawLoop: ->
		requestAnimationFrame => @runDrawLoop()
		@draw()

	draw: ->
		for entity in @entities
			if entity != undefined
				entity.draw()

	register: (entity) ->
		@entities[entity.id] = entity
		entity.draw()

	unregister: (entity) ->
		@entities[entity.id] = undefined

	update: ->
