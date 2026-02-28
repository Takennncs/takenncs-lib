RegisterNetEvent('takenncs:showContext')
AddEventHandler('takenncs:showContext', function(menuId)
    takenncs.Context.showContext(menuId)
end)

RegisterNetEvent('takenncs:hideContext')
AddEventHandler('takenncs:hideContext', function(onExit)
    takenncs.Context.hideContext(onExit)
end)

RegisterNetEvent('takenncs:registerContext')
AddEventHandler('takenncs:registerContext', function(context)
    takenncs.Context.registerContext(context)
end)

RegisterNetEvent('takenncs:deleteContext')
AddEventHandler('takenncs:deleteContext', function(menuId)
    takenncs.Context.deleteContext(menuId)
end)

RegisterNetEvent('takenncs:updateContext')
AddEventHandler('takenncs:updateContext', function(menuId, newContext)
    takenncs.Context.updateContext(menuId, newContext)
end)