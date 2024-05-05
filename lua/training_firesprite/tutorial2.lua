-- MULTIPLAYER FIX DATE: April 7, 2024  
-- REVISION DATE: April 8, 2024                                                                                           
complete = 0
totalspritecount = 1
taskcount = 3
currenttask = 1
introText = {
    1033,
    1037
}
successText = {
    1046
}
failText = {
    1031,
    1032,
    1460
}
taskText = {
    1745,
    1746,
    1748
}
taskSuccess = {
    function()
        return not gomgr.getbyoid(1652).canbreaknext
    end,
    function()
        return tornadomgr.firstactivetornado:isgrabbingsprites() or tornadomgr.secondactivetornado:isgrabbingsprites()
    end,
    function()
        return tornadomgr.firstactivetornado.firespritescollected >= totalspritecount or
            tornadomgr.secondactivetornado.firespritescollected >= totalspritecount
    end
}
taskFail = {
    function()
        return false
    end,
    function()
        if (tornadomgr.firstactivetornado.firespritescollected >= totalspritecount) then
            return true
        else
            return false
        end
    end,
    function()
        return (tornadomgr.firstactivetornado.firespritescollected >= totalspritecount and tornadomgr.isactionmatched(4))
    end
}

function reset(text)
    --
    gomgr.getbyoid(1849):dispatchlabel("reset")
    tornadomgr.firstactivetornado:resetfirespritescollected()
    gomgr.getbyoid(1652):resetbreak()
    gomgr.getbyoid(1652):resurrect()
    tornadomgr.firstactivetornado:setfujitarating(2.0)
    spritemgr.resetallsprites()
    if (type(text) == "string") then
        text = {text}
    end

    --
    gomgr.getbyoid(1586):freeze()
    engine.pushmode(1)

    --
    gomgr.getbyoid(2021).location = 1
    gomgr.getbyoid(2021).buttonon = true
    gomgr.getbyoid(2021).finishonbuttonpress = false
    for i = 1, #text do
        if i == #text then
            gomgr.getbyoid(2021).finishonbuttonpress = true
        end
        gomgr.getbyoid(2021):settext(" textbox ", text[i])
        beginwait()
        gomgr.getbyoid(2021):start()
        endwait()
    end
    gomgr.getbyoid(2021):finish()

    --
    gomgr.getbyoid(1586):unfreeze()
    engine.popmode(1)

    --
    gomgr.getbyoid(1849).path = gomgr.getbyoid(1591)
    gomgr.getbyoid(1849):dispatchlabel("trainer_fly")

    --
    gomgr.getbyoid(2022):cleartasktext()
    gomgr.getbyoid(2022).taskcount = #taskText
    for i = 1, #taskText do
        gomgr.getbyoid(2022):settasktext(i - 1, taskText[i])
    end
    gomgr.getbyoid(2022):start()

    audio.setstate("EXCITEMENT_LEVEL", "world1_tornado2")
    complete = 0
    currenttask = 1
end

--
function on_gameplaymoduleactive()
    tornadomgr.enableskill(4)
    gomgr.getbyoid(1580):dispatchlabel("weatherphase0")

    --
    while (tornadomgr.firstactivetornado == nil) do
        complete = -1
        pause(0.1)
        logline("waiting")
    end
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

            tornadomgr.firstactivetornado.inforceshowavatarstate = true
            tornadomgr.secondactivetornado.inforceshowavatarstate = true
            gomgr.getbyoid(2005).talkingtotrainer = true
            engine.pushmode(1)

            --
            if #successText > 0 then
                gomgr.getbyoid(2021).finishonbuttonpress = false
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
            gomgr.getbyoid(1849).path = gomgr.getbyoid(1593)
            gomgr.getbyoid(1849):dispatchlabel("trainer_fly")
            pause(0.5)
            gomgr.getbyoid(1599):dispatchlabel("weatherphase1")
            beginwait()
            cinematic.play("2to3")
            endwait()
            engine.popmode(1)
            tornadomgr.firstactivetornado.inforceshowavatarstate = false
            tornadomgr.secondactivetornado.inforceshowavatarstate = false
            gomgr.getbyoid(2005).talkingtotrainer = false
            requestcomplete(true)
            return
        else
            currenttask = currenttask + 1
            audio.postevent("Play_Tutorial_Task_Success")
        end
    end

    --
    if (taskFail[currenttask]()) then
        complete = -1
        gomgr.getbyoid(2022):settaskfail(currenttask - 1)
        pause(2.5)
        audio.postevent("PLAY_TUTORIAL_FAILURE")
        gomgr.getbyoid(2022):finish()

        if (failText[currenttask]) then
            engine.pushmode(1)
            gomgr.getbyoid(2021).location = 0
            gomgr.getbyoid(2021).portrait = 1
            gomgr.getbyoid(2021):settext(" textbox ", failText[currenttask])
            beginwait()
            gomgr.getbyoid(2021):start()
            endwait()
            gomgr.getbyoid(2021):finish()
            engine.popmode(1)
        end

        --
        cameramgr.screenfade(0, 0.7, 1.5, 1.5)
        pause(0.8)
        reset(introText)
    end
end