-- https://github.com/Necrossin/darkestdays/blob/master/gamemode/obj_player_extend.lua#L165
function RunningCheck(bot)
    local walkSpeed = bot:GetWalkSpeed()
    return bot:GetVelocity():LengthSqr() >= (math.pow(walkSpeed, 2) + 2500 - 100)
end

-- https://github.com/Necrossin/darkestdays/blob/master/gamemode/animations.lua#L43
function CalcMainActivityBots(bot, vel)
    if bot:IsBot() then
        local wep = bot:GetActiveWeapon()

        if RunningCheck(bot) then
            local sequence = "run_all_charging"
            if IsValid(wep) then
                if wep.RunSequence then
                    sequence = wep:RunSequence()
                end
            end
            return ACT_MP_RUN, bot:LookupSequence(sequence)
        end

        if IsValid(wep) and wep.CalcMainActivity then
            local iIdeal, iSeq = wep:CalcMainActivity(vel)
            if iIdeal and iSeq then
                return iIdeal, iSeq
            end
        end

        local len2d = vel:Length2DSqr()
        local onground = bot:OnGround()
        local pt = bot:GetTable()

        if onground and not pt.m_bWasOnGround then
            bot:AnimRestartGesture(GESTURE_SLOT_JUMP, ACT_LAND, true)
            pt.m_bWasOnGround = true
        end

        local waterlevel = bot:WaterLevel()

        if pt.m_bJumping then
            if pt.m_bFirstJumpFrame then
                pt.m_bFirstJumpFrame = false
                bot:AnimRestartMainSequence()
            end

            if waterlevel >= 2 or (CurTime() - (pt.m_flJumpStartTime or 0)) > 0.2 and onground then
                pt.m_bJumping = false
                pt.m_fGroundTime = nil
                bot:AnimRestartMainSequence()
            else
                return ACT_MP_JUMP, -1
            end
        elseif not onground and waterlevel <= 0 then
            if not pt.m_fGroundTime then
                pt.m_fGroundTime = CurTime()
            elseif CurTime() > pt.m_fGroundTime and len2d < 0.25 then
                pt.m_bJumping = true
                pt.m_bFirstJumpFrame = false
                pt.m_flJumpStartTime = 0
            end
        end

        if bot:Crouching() then
            if len2d >= 1 then
                return ACT_MP_CROUCHWALK, -1
            end

            return ACT_MP_CROUCH_IDLE, -1
        end

        if not onground and waterlevel >= 2 then
            return ACT_MP_SWIM, -1
        end

        if len2d >= 22500 then
            return ACT_MP_RUN, -1
        end

        if len2d >= 1 then
            return ACT_MP_WALK, -1
        end

        return ACT_MP_STAND_IDLE, -1
    end
end