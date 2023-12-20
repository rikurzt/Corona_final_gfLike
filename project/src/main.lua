local composer = require( "composer" )

-- Hide status bar
display.setStatusBar( display.HiddenStatusBar )

-- Seed the random number generator
math.randomseed( os.time() )
_G.username = nil
-- Go to the menu screen
composer.gotoScene( "menu" )
