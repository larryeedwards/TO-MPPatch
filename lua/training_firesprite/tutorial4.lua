-- MULTIPLAYER FIX DATE: April 8, 2024  
-- Revision Date: April 17, 2024
-- Changelog: taskFail tweaking
complete = 0
taskcount = 4
currenttask = 1
introText = {
    1064,
    1065,
    1068
}
successText = {
    1069,
    1070,
    1071
}
failText = {
    1487,
    1471,
    1470,
    1469
}
taskText = {
    1463,
    1464,
    1465,
    1466
}
taskSuccess = {
    function()
        if (not gomgr.getbyoid(1688).canbreaknext) then
            return true
        else
            return false
        end
    end,
    function()
        if (tornadomgr.isactionmatched(4)) then
            return true
        else
            return false
        end
    end,
    function()
        if (allbroken()) then
            return true
        else
            return false
        end
    end,
    function()
        if (tornadomgr.getcombinedfiresprites() + spritemgr.getlivespritecount(1) >= 4) then
            return true
        else
            return false
        end
    end
}

taskFail = {
    function()
        return (tornadomgr.firstactivetornado.firespritescollected > 0)
    end,
    function()
        return (tornadomgr.firstactivetornado.firespritescollected > 0)
    end,
    function()
        if (tornadomgr.firstactivetornado.firespritescollected > 0 or not tornadomgr.isactionmatched(4)) then
            return true
        else
            return false
        end
    end,
    function()
        return false
    end
}
function allbroken()
    return (not gomgr.getbyoid(1688).canbreaknext and not gomgr.getbyoid(1689).canbreaknext and
        not gomgr.getbyoid(1690).canbreaknext and
        not gomgr.getbyoid(1691).canbreaknext and
        not gomgr.getbyoid(1694).canbreaknext)
end

function success()
    engine.pushmode(1)
    tornadomgr.firstactivetornado.inforceshowavatarstate = true
	tornadomgr.secondactivetornado.inforceshowavatarstate = true
    gomgr.getbyoid(2005).talkingtotrainer = true
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
    gomgr.getbyoid(1849).path = gomgr.getbyoid(1612)
    gomgr.getbyoid(1849):dispatchlabel("trainer_fly")
    pause(0.5)
    gomgr.getbyoid(1618):dispatchlabel("weatherphase1")
    beginwait()
    cinematic.play("4to5")
    endwait()
    engine.popmode(1)
    tornadomgr.firstactivetornado.inforceshowavatarstate = false
	tornadomgr.secondactivetornado.inforceshowavatarstate = false
    gomgr.getbyoid(2005).talkingtotrainer = false
    requestcomplete(true)
end

function reset(text)
    --
    gomgr.getbyoid(1849):dispatchlabel("reset")
    spritemgr.resetallsprites()
    tornadomgr.firstactivetornado:resetfirespritescollected()
    gomgr.getbyoid(1688):resetbreak()
    gomgr.getbyoid(1688):resurrect()
    gomgr.getbyoid(1689):resetbreak()
    gomgr.getbyoid(1689):resurrect()
    gomgr.getbyoid(1690):resetbreak()
    gomgr.getbyoid(1690):resurrect()
    gomgr.getbyoid(1691):resetbreak()
    gomgr.getbyoid(1691):resurrect()
    gomgr.getbyoid(1694):resetbreak()
    gomgr.getbyoid(1694):resurrect()
    tornadomgr.firstactivetornado:setfujitarating(2.0)

    if (type(text) == "string") then
        text = {text}
    end

    --
    gomgr.getbyoid(1605):freeze()
    engine.pushmode(1)

    --
    gomgr.getbyoid(2021).location = 1
    gomgr.getbyoid(2021).buttonon = true
    gomgr.getbyoid(2021).finishonbuttonpress = false
    for i = 1, #text do
        gomgr.getbyoid(2021):settext(" textbox ", text[i])
        if i == #text then
            gomgr.getbyoid(2021).finishonbuttonpress = true
        end
        beginwait()
        gomgr.getbyoid(2021):start()
        endwait()
    end
    gomgr.getbyoid(2021):finish()

    --
    gomgr.getbyoid(1605):unfreeze()
    engine.popmode(1)

    --
    gomgr.getbyoid(1849).path = gomgr.getbyoid(1610)
    gomgr.getbyoid(1849):dispatchlabel("trainer_fly")

    --
    gomgr.getbyoid(2022):cleartasktext()
    gomgr.getbyoid(2022).taskcount = #taskText
    for i = 1, #taskText do
        gomgr.getbyoid(2022):settasktext(i - 1, taskText[i])
    end
    gomgr.getbyoid(2022):start()

    audio.setstate("EXCITEMENT_LEVEL", "world1_tornado4")
    complete = 0
    currenttask = 1
end

--
function on_gameplaymoduleactive()
    tornadomgr.enableskill(4)
    gomgr.getbyoid(1599):dispatchlabel("weatherphase0")

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
            success()
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
