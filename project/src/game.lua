
local composer = require( "composer" )
local socket = require("socket")

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- 自訂函式寫在這邊
-- -----------------------------------------------------------------------------------


-- Configure image sheet


-- Initialize variables

local Item = {}

function Item:new(name, value, imagePath)
    local newItem = {
        name = name,
        value = value,
        imagePath = imagePath,
    }
    setmetatable(newItem, { __index = Item })
    return newItem
end


local Weapon = {}

function Weapon:new(name, damage, imagePath)
    local newWeapon = Item:new(name, damage, imagePath)
    newWeapon.damage = damage
    setmetatable(newWeapon, { __index = Weapon })
    return newWeapon
end


local Armor = {}

function Armor:new(name, defense, imagePath)
    local newArmor = Item:new(name, defense, imagePath)  
    newArmor.defense = defense
    setmetatable(newArmor, { __index = Armor })
    return newArmor
end


local Potion = {}

function Potion:new(name, healing, imagePath)
    local newPotion = Item:new(name, 2, imagePath)  
    newPotion.healing = healing
    setmetatable(newPotion, { __index = Potion })
    return newPotion
end

-- 編輯道具模板以新增道具

local itemTemplates = {
   {id=1,type="Weapon",name="Weapon",value = 10, imagePath = "resource/icon/release_v1.2-single_100.png"},
   {id=2,type="Armor",name="shield",value = 5, imagePath = "resource/icon/release_v1.2-single_98.png"},
   {id=3,type="Potion",name="healthPotion",value = 2, imagePath = "resource/icon/release_v1.2-single_92.png"},
}

-- 工廠函數，根據類型創建對應的物品

function createItemFromTemplate(id)
    local template = itemTemplates[id]
    if template then
        local newItem
        if template.type == "Weapon" then
          newItem = Weapon:new(template.name, template.value, template.imagePath)
        elseif template.type == "Armor" then
          newItem = Armor:new(template.name, template.value, template.imagePath)
        elseif template.type == "Potion" then
          newItem = Potion:new(template.name, template.value, template.imagePath)
        end
        return newItem
    else
        error("Invalid item type")
    end
end

--隨機生成道具
function randomCreateItem()
  local newItem = createItemFromTemplate(math.random(1, #itemTemplates))
  return newItem
end

--character類別
local character={}
function character:new(name)
    local Character={}
    setmetatable(character, self)
    self.__index = self
    Character.name =name
    Character.health = 40
    Character.MP = 15
    Character.money = 15
    Character.item={}
    Character.itemCount=0
    
    function Character:adjustHealth(add_or_subtract,delta)
        if add_or_subtract == 1 then
          self.health = self.health + delta
        elseif add_or_subtract == 0 then
          self.health = self.health - delta
          print("Character took " .. delta .. " damage. Health: " .. self.health)
        end
    end

    function Character:addItem()
      if self.itemCount <=8 then
        table.insert(self.item, randomCreateItem())
        self.itemCount = self.itemCount+1
      end
    end
    return Character
end

--player類別繼承character
local player ={}
function player:new(name)
    local Player = character:new(name)
    return Player
end

--npc類別繼承character
local npc ={}
function npc:new(name)
    local NPC = character:new(name)
    return NPC
end

local myPlayer
local myNPC

local turn=0

local backGroup
local mainGroup
local uiGroup


local exitButton
local playerUseItemButton
local turnText
local itemButtonRects = {} 
local itemIconRects ={}

local playerNameBar
local playerNameBar2
local playerNameText
local playerNameText2
local npcNameBar
local npcNameText2
local showAttackIcon
local waitMessage

local function endGame()
  composer.gotoScene( "menu", { time=800, effect="crossFade" } )
end

function generateRandomChineseName(length)
    local name = ""
    for i = 1, length do
        local randomChar = string.char(math.random(0, 191))
        name = name .. randomChar
    end
    return name
end

local function initCharacter()
  myPlayer= player:new(_G.username)
  myNPC= npc:new(generateRandomChineseName(math.random(1, 3)))
  
  for i=1,8 do
    myPlayer:addItem()
    myNPC:addItem()
  end
 
end




local function initGameUI(sceneGroup)
  uiGroup = display.newGroup()
  waitMessage = display.newGroup()
  sceneGroup:insert( uiGroup )
  sceneGroup:insert(waitMessage)
  
  turnText = display.newText( uiGroup, "TURN: " .. turn, display.contentCenterX, -20, native.systemFont, 20 )
  
  playerUseItemButton = display.newImageRect( uiGroup, "resource/game_playerArea.png", 125, 225 )
  playerUseItemButton.x = display.contentCenterX-80
  playerUseItemButton.y = 130
  
  playerNameBar = display.newImageRect( uiGroup, "resource/game_namebar.png", 125, 20 )
  playerNameBar.x = display.contentCenterX-80
  playerNameBar.y = 5
  if(myPlayer) then
    playerNameText = display.newText( uiGroup, myPlayer.name,display.contentCenterX-80, 5, native.systemFont, 12 )
  else
    playerNameText = display.newText( uiGroup, "player",display.contentCenterX-75, 5, native.systemFont, 12 )
  end
  
  playerNameBar2 = display.newImageRect( uiGroup, "resource/game_namebar.png", 180, 30 )
  playerNameBar2.x = display.contentCenterX
  playerNameBar2.y = display.contentCenterY+160
  
  playerNameText2 = display.newText( uiGroup, "player",display.contentCenterX, display.contentCenterY+160, native.systemFont, 12 )
  
  npcNameBar = display.newImageRect( uiGroup, "resource/game_namebar.png", 180, 30 )
  npcNameBar.x = display.contentCenterX
  npcNameBar.y = display.contentCenterY+200
  
  npcNameText2 = display.newText( uiGroup, "TEST",display.contentCenterX, display.contentCenterY+200, native.systemFont, 12 )
  
  exitButton = display.newImageRect( uiGroup, "resource/game_exitButton.png", 20, 20 )
  exitButton.x = display.contentCenterX-125
  exitButton.y = -20
  exitButton:addEventListener( "tap", endGame )
  
  showAttackIcon = display.newImageRect( uiGroup, "resource/game_showAttack.png", 25, 25 )
  showAttackIcon.x = display.contentCenterX
  showAttackIcon.y = 5
  showAttackIcon.isVisible = false
  

  for i = 1, 4 do
    itemButtonRects[i] = display.newImageRect("resource/game_itemButton.png", 50, 50)
    itemButtonRects[i].x = (display.contentCenterX+35) + (i - 3) * 70  -- 設置 x 座標
    itemButtonRects[i].y = (display.contentCenterY+30)  -- 設置 y 座標
    itemButtonRects[i]:toBack()
    
    itemIconRects[i] = display.newImageRect("resource/game_itemButton.png", 40, 40)
    itemIconRects[i].x = (display.contentCenterX+35) + (i - 3) * 70  -- 設置 x 座標
    itemIconRects[i].y = (display.contentCenterY+30)  -- 設置 y 座標
    itemIconRects[i].isHitTestable = false
    itemIconRects[i].alpha = 1
  end
  
  for i =5,8 do
    itemButtonRects[i] = display.newImageRect("resource/game_itemButton.png", 50, 50)
    itemButtonRects[i].x = (display.contentCenterX+35) + (i - 7) * 70  -- 設置 x 座標
    itemButtonRects[i].y = (display.contentCenterY+30)+70  -- 設置 y 座標
    itemButtonRects[i]:toBack()
    
    itemIconRects[i] = display.newImageRect("resource/game_itemButton.png", 40, 40)
    itemIconRects[i].x = (display.contentCenterX+35) + (i - 7) * 70  -- 設置 x 座標
    itemIconRects[i].y = (display.contentCenterY+30)+70  -- 設置 y 座標
    itemIconRects[i].isHitTestable = false
    itemIconRects[i].alpha = 1
  end
  

 
 local waitMessageFrame = display.newImageRect(waitMessage,"resource/game_playerArea.png", 300, 250)
 waitMessageFrame.x = display.contentCenterX
 waitMessageFrame.y = display.contentCenterY-50
 local waitMessageText = display.newText( waitMessage, "決鬥準備開始",display.contentCenterX,display.contentCenterY-50 , native.systemFont, 40 )
 waitMessage:toFront()
 
end

local function setPlayerNameText()
    playerNameText.text = myPlayer.name
    playerNameText2.text = myPlayer.name
    npcNameText2.text = myNPC.name
end

local function setItemImage()
  for i =1 , #myPlayer.item  do
    print(myPlayer.item[i])
    itemIconRects[i].fill={type = "image", filename = myPlayer.item[i].imagePath}
    itemIconRects[i].alpha = 1
  end
end

local function hideMessage()
  waitMessage.isVisible = false
end


local function gameLoop()

 
end





-- -----------------------------------------------------------------------------------
-- 跟場景有關的寫在這邊
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )
  local sceneGroup = self.view
  initGameUI(sceneGroup)

  
  
end


-- show()
function scene:show( event )
  initCharacter()
  setPlayerNameText()
  setItemImage()
  hideMessage()
  
  
  
end


-- hide()
function scene:hide( event )

end


-- destroy()
function scene:destroy( event )

  local sceneGroup = self.view
  -- Code here runs prior to the removal of scene's view
  myPlayer:removeSelf()
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