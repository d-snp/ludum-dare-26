require.config({
    paths: {
        jquery: '../bower_components/jquery/jquery'
    }
});

require(['game', 'jquery', 'engines/draw','engines/input', 'engines/generic'],
 function (game, $, drawEngine,inputEngine,genericEngine) {
    'use strict';

    game.initialize();
    game.engines.draw = drawEngine.initialize(game);
    game.engines.action = genericEngine('act').initialize(game);
    game.engines.input = inputEngine.initialize(game);
    game.start()

    console.log("Running");
});
