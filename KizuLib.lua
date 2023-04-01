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

function logarAcc()
  loginChar("1","1","beta.king-baiak.net", "Account Manager",860)
  justT()
  g_app.setMaxFps(1)
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
  dance = dance
}

-- Adicionar a tabela na tabela global _G, para que outras funções e scripts possam acessar as funções desta biblioteca
_G.kizuLib = kizuLib
