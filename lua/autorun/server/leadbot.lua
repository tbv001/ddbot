if game.SinglePlayer() or engine.ActiveGamemode() ~= "darkestdays" then return end

-- Config
LeadBot = {}
LeadBot.NoNavMesh = {}
LeadBot.Models = {}
LeadBot.Prefix = ""

-- Core
include("leadbot/bot.lua")

-- Quota system
include("leadbot/quota.lua")