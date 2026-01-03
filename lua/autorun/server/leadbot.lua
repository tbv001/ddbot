if game.SinglePlayer() or engine.ActiveGamemode() ~= "darkestdays" then return end

-- Config
LeadBot = {}
LeadBot.NoNavMesh = {}
LeadBot.Models = {}
LeadBot.Prefix = ""

-- Core
include("leadbot/bot.lua")

-- Modules
local _, dir = file.Find("leadbot/modules/*", "LUA")

for k, v in pairs(dir) do
    local f = table.Add(file.Find("leadbot/modules/" .. v .. "/sv_*.lua", "LUA"), file.Find("leadbot/modules/" .. v .. "/sh_*.lua", "LUA"))
    f = table.Add(f, file.Find("leadbot/modules/" .. v .. "/cl_*.lua", "LUA"))
    for i, o in pairs(f) do
        local file = "leadbot/modules/" .. v .. "/" .. o

        if string.StartWith(o, "cl_") then
            AddCSLuaFile(file)
        else
            include(file)
            if string.StartWith(o, "sh_") then
                AddCSLuaFile(file)
            end
        end
    end
end