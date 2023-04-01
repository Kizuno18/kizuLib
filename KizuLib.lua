-- Adicionar função unload a todas as bibliotecas exceto a biblioteca client_terminal
function justT()
  for _, module in pairs(g_modules.getModules()) do
    if module:getName() ~= "client_terminal" then
      module:unload()
    end
  end
end
-- loginChar("1","1","beta.king-baiak.net",860)
-- Realizar login no jogo
  
function disableUI()
  local rootWidget = g_ui.getRootWidget()
  for i = 1, rootWidget:getChildCount() do
    local childWidget = rootWidget:getChildByIndex(i)
    childWidget:setEnabled(false)
  end
end

function enableUI()
  local rootWidget = g_ui.getRootWidget()
  for i = 1, rootWidget:getChildCount() do
    local childWidget = rootWidget:getChildByIndex(i)
    childWidget:setEnabled(true)
  end
end

function showError(...)
  local errorMsgs = {...}
  
  -- Verifica se o widget já existe
  local errorWindow = rootWidget:getChildById('errorWindow')
  if not errorWindow then
    errorWindow = g_ui.createWidget('Window', rootWidget, 'errorWindow')
    errorWindow:setSize({ width = 310, height = 130 })
    errorWindow:setDraggable(false)
    
    local errorLabel = g_ui.createWidget('Label', errorWindow)
    errorLabel:setSize({ width = 280, height = 100 })
    errorLabel:setPosition({ x = 10, y = 10 })
    errorLabel:setText(table.concat(errorMsgs, "\n\n"))
    
    local displaySize = g_window.getUnmaximizedSize()
    local x = (displaySize.width - errorWindow:getWidth()) / 2
    local y = (displaySize.height - errorWindow:getHeight()) / 2
    errorWindow:setPosition({ x = x, y = y })
    errorWindow:show()
  end
end

function loadBot()
  return g_modules.getModule("game_bot"):load()
end

function loadModule(module)
  return g_modules.getModule(module):load()
end

function unloadModule(module)
  return g_modules.getModule(module):unload()
end

function loginChar(account, password, host, characterName, version)
  g_game.setClientVersion(version)
  g_game.setProtocolVersion(version)
  g_game.loginWorld(account, password, "whatever", host, "7172", characterName)

  -- Descarregar a biblioteca client_entergame
  g_modules.getModule("client_entergame"):unload()

  print("Connected to the game server.")
end

-- Convidar e sair do grupo a cada 1 segundo
function partySpam()
  local playerId = g_game.getLocalPlayer():getId()

  cycleEvent(function()
    if g_game.isOnline() then
      g_game.partyInvite(playerId)
      g_game.partyLeave()
    end
  end, 1000)
end

function doExternalFile(filename)
  local cmd = 'path/to/external/lua/interpreter ' .. filename
  os.execute(cmd)
end

-- Girar o personagem em uma direção aleatória ou em todas as direções
function dance(random, time)
  if random then
    cycleEvent(function() g_game.turn(math.random(0, 3)) end, time)
  else
    for i = 0, 3 do
      cycleEvent(function() g_game.turn(i) end, time)
    end
  end
end

-- Criar uma tabela para armazenar todas as funções da biblioteca
local kizuLib = {
  justT = justT,
  loginChar = loginChar,
  partySpam = partySpam,
  dance = dance,
  loadBot = loadBot,
  loadModule = loadModule,
  unloadModule = unloadModule,
  doExternalFile = doExternalFile
}

-- Adicionar a tabela na tabela global _G, para que outras funções e scripts possam acessar as funções desta biblioteca
_G.kizuLib = kizuLib
