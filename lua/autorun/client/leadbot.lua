if game.SinglePlayer() or engine.ActiveGamemode() ~= "darkestdays" then return end

include("leadbot/shared.lua")

hook.Add("CalcMainActivity", "LeadBot_ActivityClient", CalcMainActivityBots)