local currentVersion = '1.0.0'
local repo = 'Takennncs/takenncs-lib'

CreateThread(function()
    Wait(5000)
    
    PerformHttpRequest(('https://raw.githubusercontent.com/%s/main/version.txt'):format(repo), 
        function(err, text, headers)
            if err == 200 then
                local latestVersion = text:match('(%d+%.%d+%.%d+)')
                if latestVersion and latestVersion ~= currentVersion then
                    print(('^3[takenncs-lib]^7 New version available: %s (current: %s)'):format(latestVersion, currentVersion))
                    print('^3[takenncs-lib]^7 Download: https://github.com/%s/releases/latest'):format(repo))
                else
                    print(('^2[takenncs-lib]^7 Version %s is up to date'):format(currentVersion))
                end
            else
                print('^1[takenncs-lib]^7 Failed to check for updates')
            end
        end, 'GET')
end)