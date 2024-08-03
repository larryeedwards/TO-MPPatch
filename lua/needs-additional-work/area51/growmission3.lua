-- MULTIPLAYER FIX REVISION DATE: 8/3/2024
-- NOTES: Lua Runtime Error upon retrying zone - Blue Screen.
-- Collision not turning off when the criteria is met during the walled section.

canbreakoutoffence = false

function on_gameplaymoduleactive()
    --
    gomgr.getbyoid(3082):dispatchlabel("weatherphase2")
	-- We should probably add the walled section OID, which is 3094.
	gomgr.getbyoid(3094):addtoworld()
    canbreakoutoffence = false
    gomgr.getbyoid(3143):addtoworld()
    gomgr.getbyoid(3143):dispatchlabel("idle")
    gomgr.getbyoid(3141):childbyoid(3125):childbyoid(3129):dispatchlabel("opened")
end

function on_gameplaymoduleupdate()
    -- Like with barnmission, we use firstactivetornado to determine if a specific critia is met.
    -- In theory, this should ONLY allow the tornadoes to explore outside the cell block if one of them is size seven.
    if
        tornadomgr.firstactivetornado:fujirating() >= 2.7 or
            tornadomgr.secondactivetornado:fujirating() >= 2.7 and canbreakoutoffence == false
     then
        canbreakoutoffence = true
		gomgr.getbyoid(3094):removefromworld()
        gomgr.getbyoid(3082):dispatchlabel("weatherphase1")
    end
end

function on_gameplaymodulecomplete(succeeded)
    if succeeded then
        --
        gomgr.getbyoid(3083):dispatchlabel("weatherphase1")
        gomgr.getbyoid(3082):dispatchlabel("weatherphase0")

        --
        tornadomgr.stormchambertimer:finish()
        --
        gomgr.getbyoid(3143):removefromworld()
    end
end