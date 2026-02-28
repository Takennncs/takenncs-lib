local takenncs = takenncs or {}
takenncs.Context = takenncs.Context or {}

local registeredMenus = {}
local currentMenu = nil
local menuHistory = {}
local menuCallbacks = {}

function takenncs.Context.registerContext(context)
    if not context.id then
        return
    end
    
    if not context.title then
        return
    end
    
    registeredMenus[context.id] = context
    menuCallbacks[context.id] = menuCallbacks[context.id] or {}
    
    if context.onExit then
        menuCallbacks[context.id].onExit = context.onExit
        context.onExit = nil
    end
    
    if context.onBack then
        menuCallbacks[context.id].onBack = context.onBack
        context.onBack = nil
    end
    
    if context.options then
        for i, option in ipairs(context.options) do
            if option.onSelect then
                menuCallbacks[context.id] = menuCallbacks[context.id] or {}
                menuCallbacks[context.id].options = menuCallbacks[context.id].options or {}
                menuCallbacks[context.id].options[i] = {
                    onSelect = option.onSelect
                }
                option.onSelect = nil
            end
        end
    end
end

local function prepareMenuForNUI(menu)
    if not menu then return nil end
    
    local menuCopy = {}
    for k, v in pairs(menu) do
        menuCopy[k] = v
    end
    
    menuCopy.onExit = nil
    menuCopy.onBack = nil
    
    if menuCopy.options then
        for i, option in ipairs(menuCopy.options) do
            local optionCopy = {}
            for k, v in pairs(option) do
                optionCopy[k] = v
            end
            optionCopy.onSelect = nil
            menuCopy.options[i] = optionCopy
        end
    end
    
    return menuCopy
end

function takenncs.Context.showContext(id)
    local menu = registeredMenus[id]
    if not menu then
        return
    end
    
    currentMenu = menu
    
    local menuForNUI = prepareMenuForNUI(menu)
    
    SendNUIMessage({
        type = 'SHOW_MENU',
        menu = menuForNUI,
        menuId = menu.id
    })
    
    SetNuiFocus(true, true)
end

function takenncs.Context.hideContext(onExit)
    if onExit and currentMenu and currentMenu.id and menuCallbacks[currentMenu.id] and menuCallbacks[currentMenu.id].onExit then
        menuCallbacks[currentMenu.id].onExit()
    end
    
    currentMenu = nil
    menuHistory = {}
    
    SendNUIMessage({
        type = 'HIDE_MENU',
        runOnExit = onExit
    })
    
    SetNuiFocus(false, false)
    SetCursorLocation(0.5, 0.5)
end

function takenncs.Context.getOpenContextMenu()
    return currentMenu and currentMenu.id or nil
end

RegisterNUICallback('navigateToMenu', function(data, cb)
    local menu = registeredMenus[data.menuId]
    if menu then
        if currentMenu then
            table.insert(menuHistory, currentMenu)
        end
        currentMenu = menu
        
        local menuForNUI = prepareMenuForNUI(menu)
        
        SendNUIMessage({
            type = 'SHOW_MENU',
            menu = menuForNUI,
            menuId = menu.id
        })
    end
    cb('ok')
end)

RegisterNUICallback('selectOption', function(data, cb)
    local menuId = data.menuId
    local optionIndex = data.optionIndex
    local optionData = data.optionData
    
    if menuId and optionIndex and menuCallbacks[menuId] and menuCallbacks[menuId].options and menuCallbacks[menuId].options[optionIndex] then
        local callback = menuCallbacks[menuId].options[optionIndex].onSelect
        if callback then
            local success, err = pcall(callback, optionData.args)
            if not success then
         end
        end
    end
    
    if optionData.event then
        TriggerEvent(optionData.event, optionData.args)
    end
    
    if optionData.serverEvent then
        TriggerServerEvent(optionData.serverEvent, optionData.args)
    end
    
    if optionData.closeOnSelect ~= false then
        takenncs.Context.hideContext(false)
    end
    
    cb('ok')
end)

RegisterNUICallback('menuEvent', function(data, cb)
    if data.event == 'onExit' and currentMenu and currentMenu.id and menuCallbacks[currentMenu.id] and menuCallbacks[currentMenu.id].onExit then
        menuCallbacks[currentMenu.id].onExit()
    elseif data.event == 'onBack' and currentMenu and currentMenu.id and menuCallbacks[currentMenu.id] and menuCallbacks[currentMenu.id].onBack then
        menuCallbacks[currentMenu.id].onBack()
    end
    cb('ok')
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        
        if currentMenu and IsControlJustPressed(0, 322) then
            local canClose = true
            
            if currentMenu and currentMenu.canClose ~= nil then
                canClose = currentMenu.canClose
            end
            
            if canClose then
                takenncs.Context.hideContext(true)
            end
        end
    end
end)

RegisterCommand('takenncslibmenu', function()
    local exampleMenu = {
        id = 'example_menu',
        title = 'takenncs Näidismenüü',
        position = 'top-right',
        canClose = true,
        options = {
            {
                title = 'Tere!',
                description = 'See on näidisnupp',
                icon = 'hand',
                onSelect = function()
                end
            },
            {
                title = 'Keelatud nupp',
                description = 'Seda ei saa vajutada',
                icon = 'ban',
                disabled = true
            },
            {
                title = 'Alammenüü',
                description = 'Avab teise menüü',
                menu = 'submenu_example',
                icon = 'bars',
                metadata = {
                    {label = 'Tase', value = 5, progress = 50, colorScheme = 'green'},
                    {label = 'Kogemus', value = '1500/3000'}
                }
            },
            {
                title = 'Eventi näide',
                description = 'Käivitab eventi',
                icon = 'bolt',
                event = 'takenncs:exampleEvent',
                args = {text = 'Tere eventist!'},
                arrow = true
            }
        }
    }
    
    local subMenu = {
        id = 'submenu_example',
        title = 'Alammenüü',
        menu = 'example_menu',
        onBack = function()
        end,
        options = {
            {
                title = 'Tagasi',
                description = 'Naase eelmisse menüüsse',
                menu = 'example_menu',
                icon = 'arrow-left'
            },
            {
                title = 'Progressbar näide',
                description = 'See nupp näitab progressi',
                icon = 'chart-line',
                progress = 75,
                colorScheme = 'blue',
                onSelect = function()
                end
            }
        }
    }
    
    takenncs.Context.registerContext(exampleMenu)
    takenncs.Context.registerContext(subMenu)
    
    takenncs.Context.showContext('example_menu')
end, false)

RegisterCommand('takenncslibclose', function()
    takenncs.Context.hideContext(true)
end, false)

RegisterNetEvent('takenncs:exampleEvent')
AddEventHandler('takenncs:exampleEvent', function(args)
    print("^2[takenncs]^7 Event käivitus:", args.text)
    takenncs.Context.showContext('submenu_example')
end)


exports('registerContext', takenncs.Context.registerContext)
exports('showContext', takenncs.Context.showContext)
exports('hideContext', takenncs.Context.hideContext)
exports('getOpenContextMenu', takenncs.Context.getOpenContextMenu)

_G.takenncs = takenncs