local takenncs = takenncs or {}
takenncs.Context = takenncs.Context or {}

--- @param source number Mängija server ID
--- @param menuId string Menüü ID
--- @param optionId string Valiku ID
function takenncs.Context.serverSelectOption(source, menuId, optionId)
end

--- @param source number Mängija server ID
--- @param menuId string Menüü ID
function takenncs.Context.showContextToPlayer(source, menuId)
    TriggerClientEvent('takenncs:showContext', source, menuId)
end

--- @param source number Mängija server ID
--- @param onExit boolean Kas käivitada onExit
function takenncs.Context.hideContextForPlayer(source, onExit)
    TriggerClientEvent('takenncs:hideContext', source, onExit)
end

--- @param context table Menüü konfiguratsioon
function takenncs.Context.registerContextForAll(context)
    TriggerClientEvent('takenncs:registerContext', -1, context)
end

--- @param source number Mängija server ID
--- @param context table Menüü konfiguratsioon
function takenncs.Context.registerContextForPlayer(source, context)
    TriggerClientEvent('takenncs:registerContext', source, context)
end

--- @param menuId string Menüü ID
function takenncs.Context.deleteContextForAll(menuId)
    TriggerClientEvent('takenncs:deleteContext', -1, menuId)
end

--- @param source number Mängija server ID
--- @param menuId string Menüü ID
function takenncs.Context.deleteContextForPlayer(source, menuId)
    TriggerClientEvent('takenncs:deleteContext', source, menuId)
end

RegisterNetEvent('takenncs:serverSelectOption')
AddEventHandler('takenncs:serverSelectOption', function(data)
    local src = source
    takenncs.Context.serverSelectOption(src, data.menuId, data.optionId)
end)

RegisterNetEvent('takenncs:requestMenuRegistration')
AddEventHandler('takenncs:requestMenuRegistration', function(menuId)
end)

exports('ServerSelectOption', takenncs.Context.serverSelectOption)
exports('serverSelectOption', takenncs.Context.serverSelectOption)
exports('ShowContextToPlayer', takenncs.Context.showContextToPlayer)
exports('showContextToPlayer', takenncs.Context.showContextToPlayer)
exports('HideContextForPlayer', takenncs.Context.hideContextForPlayer)
exports('hideContextForPlayer', takenncs.Context.hideContextForPlayer)
exports('RegisterContextForAll', takenncs.Context.registerContextForAll)
exports('registerContextForAll', takenncs.Context.registerContextForAll)
exports('RegisterContextForPlayer', takenncs.Context.registerContextForPlayer)
exports('registerContextForPlayer', takenncs.Context.registerContextForPlayer)
exports('DeleteContextForAll', takenncs.Context.deleteContextForAll)
exports('deleteContextForAll', takenncs.Context.deleteContextForAll)
exports('DeleteContextForPlayer', takenncs.Context.deleteContextForPlayer)
exports('deleteContextForPlayer', takenncs.Context.deleteContextForPlayer)

_G.takenncs = takenncs