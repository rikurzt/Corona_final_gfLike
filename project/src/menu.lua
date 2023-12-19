
local composer = require( "composer" )
local native = require( "native" )


local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- 自訂函式寫在這邊
-- -----------------------------------------------------------------------------------

local function gotoGame()
  composer.gotoScene( "game", { time=800, effect="crossFade" } )
end

local function gotoHighScores()
  composer.gotoScene( "highscores", { time=800, effect="crossFade" } )
end


local function textField(event)
  if event.phase == "began" then

    elseif event.phase == "ended" then

    elseif event.phase == "editing" then

    end
end

-- -----------------------------------------------------------------------------------
-- 跟場景有關的寫在這邊
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

  local sceneGroup = self.view
  -- Code here runs when the scene is first created but has not yet appeared on screen

  local background = display.newImageRect( sceneGroup, "resource/menu_background.jpg", 500, 750 )
  background.x = display.contentCenterX
  background.y = display.contentCenterY

  local title = display.newImageRect( sceneGroup, "resource/menu_title.png", 350, 350 )
  title.x = display.contentCenterX
  title.y = 80

  local playButton = display.newImageRect( sceneGroup, "resource/menu_startbutton.png", 160, 40 )
  playButton.x = display.contentCenterX
  playButton.y = 375
  playButton:setFillColor( 0.82, 0.86, 1 )
  local ButtonText = display.newText( sceneGroup, "塔塔開", display.contentCenterX, 375, native.systemFont, 28 )
    
  local textField = native.newTextField( display.contentCenterX, 300, 200, 30 )
  textField.text = "報上你的名號，挑戰者"
  
  playButton:addEventListener( "tap", gotoGame )

end


-- show()
function scene:show( event )

  local sceneGroup = self.view
  local phase = event.phase

  if ( phase == "will" ) then
    -- Code here runs when the scene is still off screen (but is about to come on screen)

  elseif ( phase == "did" ) then
    -- Code here runs when the scene is entirely on screen

  end
end


-- hide()
function scene:hide( event )

  local sceneGroup = self.view
  local phase = event.phase

  if ( phase == "will" ) then
    -- Code here runs when the scene is on screen (but is about to go off screen)

  elseif ( phase == "did" ) then
    -- Code here runs immediately after the scene goes entirely off screen

  end
end


-- destroy()
function scene:destroy( event )

  local sceneGroup = self.view
  -- Code here runs prior to the removal of scene's view

end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene