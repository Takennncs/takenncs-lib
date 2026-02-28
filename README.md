# takenncs-lib

A lightweight context menu library for FiveM

## 📋 Features
- 🎯 Custom context menus with easy configuration
- 🎨 Modern, clean NUI interface
- 🔧 Simple export functions
- 📱 FontAwesome icon support
- 🖼️ Image support in menu items
- 📊 Progress bars and metadata displays
- 🔙 Menu history with back navigation
- ⌨️ ESC key support with configurable close behavior

## 📦 Installation
1. Download the resource
2. Place in your `resources` folder
3. Add to `server.cfg`:
```lua
ensure takenncs-lib
```

## 🚀 Quick Start

### Basic Menu Example
```lua
-- Register a menu
exports['takenncs-lib']:registerContext({
    id = 'my_menu',
    title = 'My Menu',
    position = 'top-right',
    options = {
        {
            title = 'Click Me',
            description = 'This button does something',
            icon = 'star',
            onSelect = function()
                print('Button clicked!')
            end
        }
    }
})

-- Show the menu
exports['takenncs-lib']:showContext('my_menu')
```

## 📚 API Reference

### Core Functions

| Function | Parameters | Description |
|----------|------------|-------------|
| `registerContext` | `table context` | Register a new context menu |
| `showContext` | `string id` | Show a registered menu |
| `hideContext` | `boolean onExit` | Hide current menu (true = run onExit) |
| `getOpenContextMenu` | `none` | Get ID of currently open menu |

### Menu Configuration

| Field | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| `id` | string | ✅ | - | Unique menu identifier |
| `title` | string | ✅ | - | Menu title |
| `position` | string | ❌ | `'top-right'` | `'top-left'`, `'top-right'`, `'bottom-left'`, `'bottom-right'` |
| `canClose` | boolean | ❌ | `true` | Can menu be closed with ESC |
| `onExit` | function | ❌ | - | Called when menu closes with ESC |
| `onBack` | function | ❌ | - | Called when back button is pressed |
| `options` | table | ✅ | - | Array of menu buttons |

### Button Options

| Field | Type | Description |
|-------|------|-------------|
| `title` | string | Button text |
| `description` | string | Additional info below title |
| `icon` | string | FontAwesome icon name or image URL |
| `iconColor` | string | Icon color (hex or name) |
| `iconAnimation` | string | Animation: `spin`, `pulse`, `bounce`, etc. |
| `disabled` | boolean | Gray out and disable button |
| `readOnly` | boolean | Remove hover effects and disable click |
| `menu` | string | Navigate to another menu ID |
| `onSelect` | function | Click callback function |
| `event` | string | Trigger client event on click |
| `serverEvent` | string | Trigger server event on click |
| `args` | any | Arguments passed to events/functions |
| `progress` | number | Progress bar (0-100) |
| `colorScheme` | string | Progress bar color: `green`, `red`, `yellow`, `blue`, `purple` |
| `arrow` | boolean | Show arrow (useful for event menus) |
| `image` | string | Image URL to display |
| `metadata` | table | Array of metadata items (see below) |
| `closeOnSelect` | boolean | Close menu after click (default: true) |

### Metadata Items

| Field | Type | Description |
|-------|------|-------------|
| `label` | string | Metadata label |
| `value` | any | Metadata value |
| `progress` | number | Optional progress bar (0-100) |
| `colorScheme` | string | Progress bar color |

## 💡 Advanced Examples

### Menu with Submenu
```lua
-- Main menu
exports['takenncs-lib']:registerContext({
    id = 'main_menu',
    title = 'Main Menu',
    options = {
        {
            title = 'Settings',
            description = 'Open settings menu',
            icon = 'cog',
            menu = 'settings_menu'
        }
    }
})

-- Settings submenu (with back button)
exports['takenncs-lib']:registerContext({
    id = 'settings_menu',
    title = 'Settings',
    menu = 'main_menu', -- This creates the back button
    options = {
        {
            title = 'Option 1',
            onSelect = function() print('Option 1') end
        }
    }
})

exports['takenncs-lib']:showContext('main_menu')
```

### Menu with Progress and Metadata
```lua
exports['takenncs-lib']:registerContext({
    id = 'stats_menu',
    title = 'Player Stats',
    options = {
        {
            title = 'Level 5',
            description = 'Experience progress',
            icon = 'chart-line',
            progress = 65,
            colorScheme = 'green',
            metadata = {
                { label = 'XP', value = '650/1000' },
                { label = 'Kills', value = 42, progress = 42, colorScheme = 'red' },
                { label = 'Health', value = '80%', progress = 80, colorScheme = 'green' }
            }
        }
    }
})
```

### Menu with Event Triggers
```lua
exports['takenncs-lib']:registerContext({
    id = 'event_menu',
    title = 'Event Example',
    options = {
        {
            title = 'Trigger Client Event',
            event = 'my:clientEvent',
            args = { data = 'hello' },
            arrow = true
        },
        {
            title = 'Trigger Server Event',
            serverEvent = 'my:serverEvent',
            args = { playerId = GetPlayerServerId(PlayerId()) }
        }
    }
})
```

### Dynamic Menu from Event
```lua
RegisterNetEvent('my:openDynamicMenu')
AddEventHandler('my:openDynamicMenu', function(items)
    local options = {}
    for _, item in ipairs(items) do
        table.insert(options, {
            title = item.name,
            description = 'Price: $' .. item.price,
            icon = item.icon or 'box',
            onSelect = function()
                TriggerServerEvent('my:buyItem', item.id)
            end
        })
    end
    
    exports['takenncs-lib']:registerContext({
        id = 'dynamic_menu',
        title = 'Shop',
        options = options
    })
    
    exports['takenncs-lib']:showContext('dynamic_menu')
end)
```

## 🎨 Styling

The menu automatically adapts to your FiveM theme. You can customize colors in `html/styles.css`.

## 📋 Requirements
- FiveM server
- No additional dependencies

## 📄 License
MIT License - Free for personal and commercial use

## 👨‍💻 Author
**takenncs**

---
*Version 1.0.0*
