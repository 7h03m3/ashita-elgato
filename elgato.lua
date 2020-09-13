_addon.author = '7h03m3';
_addon.name = 'Elgato';
_addon.version = '0.0.1';

require 'common'

----------------------------------------------------------------------------------------------------
local elgatoData = {};
elgatoData.loadConfigFirstTime = true;
elgatoData.commandFile = "";

----------------------------------------------------------------------------------------------------
local function clearCommandFile()
    local commandFile = io.open(elgatoData.commandFile, "w");
    io.close(commandFile);
end

----------------------------------------------------------------------------------------------------
local function event_load() elgatoData.addonPath = _addon.path; end

----------------------------------------------------------------------------------------------------
local function event_unload() end

----------------------------------------------------------------------------------------------------
local function event_render()
    if (elgatoData.loadConfigFirstTime == true) then
        local player = GetPlayerEntity();
        if (player ~= nil) then
            elgatoData.loadConfigFirstTime = false;
            elgatoData.commandFile = _addon.path .. "command_" .. player.Name ..
                                         ".txt"
            clearCommandFile();
        end
    end

    if ((elgatoData.commandFile ~= nil) and (elgatoData.commandFile ~= "")) then
        local commandFile = io.open(elgatoData.commandFile, "r+b");

        if (commandFile ~= nil) then
            local command = commandFile:read("*a");

            if ((command ~= nil) and (command ~= "")) then
                AshitaCore:GetChatManager():QueueCommand(command,
                                                         CommandInputType.ForceHandle);
                clearCommandFile();
            end
            io.close(commandFile);
        end
    end
end

----------------------------------------------------------------------------------------------------
local function event_command(cmd, ntype) return false; end

----------------------------------------------------------------------------------------------------
local function event_incomingPacket(id, size, packet) return false; end

----------------------------------------------------------------------------------------------------
ashita.register_event('load', event_load);
ashita.register_event('unload', event_unload);
ashita.register_event('render', event_render);
ashita.register_event('command', event_command);
ashita.register_event('incoming_packet', event_incomingPacket);

