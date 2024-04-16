  function underconstruction_exit()
	beginwait()
		uimgr.playhint(1605)
	endwait()
	world.exitworld(0)
end

-- MULTIPLAYER FIX DATE: April 7, 2024
-- Revision Date: April 15, 2024
--[[ TODO: Singleplayer doesn't seem to like the new implementation. Look into a solution for this!]]
-- Alright, the gists of it is to seperate sprite count. Not much, but could be a solution for premature failures in the later tuts.
complete = 0
totalspritecountP1 = 1
totalspritecountP2 = 1
taskcount = 2
currenttask = 1
introText = {
    1027,
    1028,
    1029
}
successText = {
    1030
}
failText = {
    1023,
    1024,
    1025
}
taskText = {
    1740,
    1741
}
taskSuccess = {
    function()
        return not gomgr.getbyoid(1638).canbreaknext
    end,
    -- In theory, this'll check and see if either Zephyr or Wind Warrior exposed the Fire Flyer.
    function()
        return tornadomgr.firstactivetornado.firespritescollected >= totalspritecountP1 or
            tornadomgr.secondactivetornado.firespritescollected >= totalspritecountP2
    end
}

function reset(text)
    --
    gomgr.getbyoid(1849):dispatchlabel("reset")
    spritemgr.resetallsprites()
    tornadomgr.firstactivetornado.showgrowthinfo = false
    tornadomgr.firstactivetornado:warp(gomgr.getbyoid(1581))
    tornadomgr.firstactivetornado:resetfirespritescollected()
    gomgr.getbyoid(1638):resetbreak()
    gomgr.getbyoid(1638):resurrect()
    tornadomgr.firstactivetornado:setfujitarating(2.0)
    audio.setstate("EXCITEMENT_LEVEL", "world1_tornado1")

    --
    gomgr.getbyoid(1576):freeze()
    engine.pushmode(1)

    --
    gomgr.getbyoid(2021).location = 1
    gomgr.getbyoid(2021).buttonon = true
    for i = 1, #text do
        gomgr.getbyoid(2021):settext(" textbox ", text[i])
        if i == 2 then
            gomgr.getbyoid(1576):unfreezecamera()
            pause(0.01)
            cinematic.play("fxshow")
            gomgr.getbyoid(2021).portrait = 1
            gomgr.getbyoid(2021).location = 0
        end

        beginwait()
        gomgr.getbyoid(2021):start()
        endwait()

        if i == 2 then
            cinematic.stop()
            gomgr.getbyoid(2021).location = 1
            gomgr.getbyoid(1576):freeze()
        end
    end

    --
    gomgr.getbyoid(1576):unfreeze()
    engine.popmode(1)

    --
    gomgr.getbyoid(1849).path = gomgr.getbyoid(1582)
    gomgr.getbyoid(1849):dispatchlabel("trainer_fly")

    --
    gomgr.getbyoid(2022):cleartasktext()
    gomgr.getbyoid(2022).taskcount = #taskText
    for i = 1, #taskText do
        gomgr.getbyoid(2022):settasktext(i - 1, taskText[i])
    end
    gomgr.getbyoid(2022):start()

    complete = 0
    currenttask = 1
end

--
function on_gameplaymoduleactive()
    tornadomgr.displayfirespritegoalinfo = false
    tornadomgr.displayfirespritetotalinfo = false
    tornadomgr.enableskill(4)
    gomgr.getbyoid(1580):dispatchlabel("weatherphase1")

    --
    while (tornadomgr.firstactivetornado == nil) do
        complete = -1
        pause(0.1)
        logline("waiting")
    end
    complete = 0
    reset(introText)
end

--
function on_gameplaymoduleupdate()
    if (complete ~= 0) then
        return
    end

    --
    if (taskSuccess[currenttask]()) then
        gomgr.getbyoid(2022):settaskcomplete(currenttask - 1)
        if (currenttask == taskcount) then
            complete = 1
            currenttask = currenttask + 1
            audio.postevent("Play_Tutorial_Success")
            engine.pushmode(1)
            tornadomgr.firstactivetornado.inforceshowavatarstate = true -- Zephyr
            tornadomgr.secondactivetornado.inforceshowavatarstate = true -- Wind Warrior
            gomgr.getbyoid(2005).talkingtotrainer = true

            --
            gomgr.getbyoid(2021).finishonbuttonpress = false
            if #successText > 0 then
                for i = 1, #successText do
                    gomgr.getbyoid(2021).location = 0
                    gomgr.getbyoid(2021).portrait = 1
                    gomgr.getbyoid(2021):settext(" textbox ", successText[i])
                    if i == #successText then
                        gomgr.getbyoid(2021).finishonbuttonpress = true
                    end
                    beginwait()
                    gomgr.getbyoid(2021):start()
                    endwait()
                end
                gomgr.getbyoid(2021):finish()
            end

            gomgr.getbyoid(2022):finish()
            gomgr.getbyoid(1849).path = gomgr.getbyoid(1583)
            gomgr.getbyoid(1849):dispatchlabel("trainer_fly")
            pause(0.5)
            gomgr.getbyoid(1590):dispatchlabel("weatherphase1")
            beginwait()
            cinematic.play("1to2")
            endwait()
            engine.popmode(1)
            tornadomgr.firstactivetornado.inforceshowavatarstate = false -- Zephyr
            tornadomgr.secondactivetornado.inforceshowavatarstate = false -- Wind Warrior
            gomgr.getbyoid(2005).talkingtotrainer = false
            requestcomplete(true)
            return
        else
            currenttask = currenttask + 1
            audio.postevent("Play_Tutorial_Task_Success")
        end
    end
end
