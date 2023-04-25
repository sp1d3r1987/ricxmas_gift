data = {}
local QBRItems
local VorpCore
local VorpInv
local RSGCore = exports['rsg-core']:GetCoreObject()
local RSGInv

local framework = "rsg" --"redemrp" or "qbr" or "rsg" or "vorp" MAKE SURE TO NOT ADD WEAPONS FOR VORP

if framework == "redemrp" then
	TriggerEvent("redemrp_inventory:getData",function(call)
	    data = call
	end)
elseif framework == "qbr" then 
	QBRItems = exports['qbr-core']:GetItems()
elseif framework == "vorp" then 
	TriggerEvent("getCore",function(core)
	    VorpCore = core
	end)
	VorpInv = exports.vorp_inventory:vorp_inventoryApi()
elseif framework == "rsg" then
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
end


RegisterServerEvent("ricxmas_gift:addgift")
AddEventHandler("ricxmas_gift:addgift", function()
	local _source = source
    local label
    local text = ""
if framework == "redemrp" then
    TriggerEvent('redemrp:getPlayerFromId', _source, function(user)
        if user ~= nil then
            local random = math.random(1,#Config.Gifts)
            if  Config.Gifts[random][1] ~= "money" then
                local ItemData = data.getItem(_source, Config.Gifts[random][1])
                local ItemInfo = data.getItemData( Config.Gifts[random][1])
                ItemData.AddItem(Config.Gifts[random][2])
                local label = ItemInfo.label
                text = Config.Recieved.."\n"..label.." ("..Config.Gifts[random][2]..")"
            else
                user.addMoney(Config.Gifts[random][2])
                text = Config.Recieved.."\n+$"..Config.Gifts[random][2]
            end
            TriggerClientEvent("Notification:left_xmas", _source, Config.Title, text, "scoretimer_textures", "scoretimer_generic_tick", 2000)
        end
    end)
elseif framework == "qbr" then 
     local random = math.random(1,#Config.Gifts)
     if  Config.Gifts[random][1] ~= "money" then
          local itemData = QBRItems[Config.Gifts[random][1]]
 	  local User = exports['qbr-core']:GetPlayer(_source)
	  User.Functions.AddItem(Config.Gifts[random][1], Config.Gifts[random][2])
          local label = itemData.label
          text = Config.Recieved.."\n"..label.." ("..Config.Gifts[random][2]..")"
     else
          local User = exports['qbr-core']:GetPlayer(_source)
          User.Functions.AddMoney("cash", Config.Gifts[random][2], "desc")
          text = Config.Recieved.."\n+$"..Config.Gifts[random][2]
     end
     
elseif framework == "vorp" then 
  local random = math.random(1,#Config.Gifts)
     if  Config.Gifts[random][1] ~= "money" then
        VorpInv.addItem(_source, Config.Gifts[random][1], Config.Gifts[random][2])
          text = Config.Recieved.."\n"..Config.Gifts[random][1].." ("..Config.Gifts[random][2]..")"
     else
	local Character = VorpCore.getUser(_source).getUsedCharacter
	Character.addCurrency(0 , Config.Gifts[random][2])
          text = Config.Recieved.."\n+$"..Config.Gifts[random][2]
     end
     TriggerClientEvent("Notification:left_xmas", _source, Config.Title, text, "scoretimer_textures", "scoretimer_generic_tick", 2000)
elseif framework == "rsg" then
    local random = math.random(1,#Config.Gifts)
    if  Config.Gifts[random][1] ~= "money" then
        local User = RSGCore.Functions.GetPlayer(source)
        Player.Functions.AddItem(Config.Gifts[random][1], Config.Gifts[random][2], 1)
        text = Config.Recieved.."\n"..Config.Gifts[random][1].." ("..Config.Gifts[random][2]..")"
    else
        Player.Functions.AddMoney("cash", Config.Gifts[random][2])
        text = Config.Recieved.."\n+$"..Config.Gifts[random][2]
    end
    TriggerClientEvent("Notification:left_xmas", _source, Config.Title, text, "scoretimer_textures", "scoretimer_generic_tick", 2000)
end
end)


local hour = (60*1000)*60
    
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(hour)
        TriggerClientEvent("ricxmas_gift:triggergift", -1)
    end
end)
