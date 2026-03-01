local currentVersion = '1.0.0'

CreateThread(function()
    Wait(5000)
    print(('^2[takenncs-lib]^7 Version %s'):format(currentVersion))
    PerformHttpRequest('https://raw.githubusercontent.com/Takennncs/takenncs-lib/main/version.txt', 
        function(err, text, headers)
            if err == 200 then
                local latestVersion = text:match('(%d+%.%d+%.%d+)')
                if latestVersion and latestVersion ~= currentVersion then
                    print(('^3[takenncs-lib]^7 New version available: %s'):format(latestVersion))
                end
            else
          end
        end, 'GET')
end)
