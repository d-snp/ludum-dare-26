require.config({
    paths: {
        jquery: '../bower_components/jquery/jquery'
    }
});

require(['game', 'jquery', 'polyfills'],
 function (game, $) {
    'use strict';

    game.initialize();
    game.start()

    console.log("Running");
});
