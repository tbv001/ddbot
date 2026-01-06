if game.SinglePlayer() or engine.ActiveGamemode() ~= "darkestdays" then return end

AddCSLuaFile("leadbot/shared.lua")

LeadBot = {}

-- Core
include("leadbot/bot.lua")

-- Quota system
include("leadbot/quota.lua")