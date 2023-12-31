
local composer = require( "composer" )
local native = require( "native" )


local scene = composer.newScene()
local textField
-- -----------------------------------------------------------------------------------
-- 自訂函式寫在這邊
-- -----------------------------------------------------------------------------------

local function gotoGame()
  print(_G.username)
  if _G.username and _G.username ~= "" then
    composer.gotoScene( "game", { time=800, effect="crossFade" } )
   end
end


local function gotoHighScores()
  composer.gotoScene( "highscores", { time=800, effect="crossFade" } )
end


local function initUI(sceneGroup)
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
    
  textField = native.newTextField( display.contentCenterX, 300, 200, 30 )
  textField.placeholder  = "報上你的名號，挑戰者"
  sceneGroup:insert(textField)
  function textField:userInput(event)

  if event.phase == "began" then
  
    elseif event.phase == "ended" then
      
      _G.username =  textField.text
      print( "使用者輸入的文字是: " .. _G.username )
    elseif event.phase == "editing" then
      _G.username =  textField.text
    end
end
  
  textField:addEventListener( "userInput", textField )
  playButton:addEventListener( "tap", gotoGame )


end


-- -----------------------------------------------------------------------------------
-- 跟場景有關的寫在這邊
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

  local sceneGroup = self.view
  -- Code here runs when the scene is first created but has not yet appeared on screen
  
end


-- show()
function scene:show( event )

  local sceneGroup = self.view
  local phase = event.phase

  if ( phase == "will" ) then
    -- Code here runs when the scene is still off screen (but is about to come on screen)
    initUI(sceneGroup)
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
    native.setKeyboardFocus(nil)
    textField.isVisible = false
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
-- 場景Event
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
