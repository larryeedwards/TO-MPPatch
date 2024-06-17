-- MULTIPLAYER FIX DATE: April 8, 2024
complete = 0
taskcount = 4
currenttask = 1
started = false
introText = {
    1078,
    1079,
    1080,
    1081,
    1082
}
successText = {
    1017,
    1019
}
failText = {
    1072,
    1461,
    1075,
    1462
}
taskText = {
    1761,
    1762,
    1763,
    1764
}

taskSuccess = {
    function()
        return not gomgr.getbyoid(1724).canbreaknext
    end,
    function()
        return tornadomgr.firstactivetornado:isgrabbingsprites() or tornadomgr.secondactivetornado:isgrabbingsprites()
    end,
    function()
        if (allbroken()) then
            return true
        else
            return false
        end
    end,
    function()
        return tornadomgr.firstactivetornado.firespritescollected >= 1 or
            tornadomgr.secondactivetornado.firespritescollected >= 1
    end
}

taskFail = {
    function()
        return tornadomgr.firstactivetornado.firespritescollected > 10 or
            tornadomgr.secondactivetornado.firespritescollected > 10
    end,
    function()
        return tornadomgr.firstactivetornado.firespritescollected > 10 or
            tornadomgr.secondactivetornado.firespritescollected > 10
    end,
    function()
        if
            tornadomgr.firstactivetornado.firespritescollected > 10 or
                tornadomgr.secondactivetornado.firespritescollected > 10 and not tornadomgr.isactionmatched(4)
         then
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
    return (not gomgr.getbyoid(1724).canbreaknext and not gomgr.getbyoid(1725).canbreaknext and
        not gomgr.getbyoid(1726).canbreaknext and
        not gomgr.getbyoid(1727).canbreaknext and
        not gomgr.getbyoid(1728).canbreaknext and
        not gomgr.getbyoid(1729).canbreaknext and
        not gomgr.getbyoid(1730).canbreaknext and
        not gomgr.getbyoid(1731).canbreaknext and
        not gomgr.getbyoid(1732).canbreaknext)
end

function success()
    pause(2.0)
    tornadomgr.stormchambertimer:stoptimer()
    pause(1.0)
    --

    --
    engine.pushmode(1)
    tornadomgr.firstactivetornado.inforceshowavatarstate = true
    tornadomgr.secondactivetornado.inforceshowavatarstate = true
    gomgr.getbyoid(2005).talkingtotrainer = true
    if #successText > 0 then
        gomgr.getbyoid(2021).finishonbuttonpress = false
        for i = 1, #successText do
            gomgr.getbyoid(2021).location = 0
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
    gomgr.getbyoid(1849).path = gomgr.getbyoid(1621)
    gomgr.getbyoid(1849):dispatchlabel("trainer_fly")
    pause(1.0)
    gomgr.getbyoid(1631):dispatchlabel("weatherphase1")
    gomgr.getbyoid(1816):dispatchlabel("training_closed")
    beginwait()
    cinematic.play("5to6")
    endwait()
    engine.popmode(1)
    tornadomgr.firstactivetornado.inforceshowavatarstate = false
    tornadomgr.secondactivetornado.inforceshowavatarstate = false
    gomgr.getbyoid(2005).talkingtotrainer = false
    requestcomplete(true)
end

function reset(text)
    started = false
    --
    gomgr.getbyoid(1849):dispatchlabel("reset")
    spritemgr.resetallsprites()
    tornadomgr.firstactivetornado:resetfirespritescollected()
    gomgr.getbyoid(1724):resetbreak()
    gomgr.getbyoid(1724):resurrect()
    gomgr.getbyoid(1725):resetbreak()
    gomgr.getbyoid(1725):resurrect()
    gomgr.getbyoid(1726):resetbreak()
    gomgr.getbyoid(1726):resurrect()
    gomgr.getbyoid(1727):resetbreak()
    gomgr.getbyoid(1727):resurrect()
    gomgr.getbyoid(1728):resetbreak()
    gomgr.getbyoid(1728):resurrect()
    gomgr.getbyoid(1729):resetbreak()
    gomgr.getbyoid(1729):resurrect()
    gomgr.getbyoid(1730):resetbreak()
    gomgr.getbyoid(1730):resurrect()
    gomgr.getbyoid(1731):resetbreak()
    gomgr.getbyoid(1731):resurrect()
    gomgr.getbyoid(1732):resetbreak()
    gomgr.getbyoid(1732):resurrect()
    tornadomgr.firstactivetornado:setfujitarating(2.0)

    if (type(text) == "string") then
        text = {text}
    end

    --
    gomgr.getbyoid(1614):freeze()
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
    gomgr.getbyoid(1614):unfreeze()
    engine.popmode(1)

    --
    gomgr.getbyoid(1849).path = gomgr.getbyoid(1619)
    gomgr.getbyoid(1849):dispatchlabel("trainer_fly")

    --
    gomgr.getbyoid(2022):cleartasktext()
    gomgr.getbyoid(2022).taskcount = #taskText
    for i = 1, #taskText do
        gomgr.getbyoid(2022):settasktext(i - 1, taskText[i])
    end
    gomgr.getbyoid(2022):start()

    audio.setstate("EXCITEMENT_LEVEL", "world1_tornado5")

    tornadomgr.stormchambertimer:starttimerforboss(30)

    complete = 0
    currenttask = 1
    started = true
end

--
function on_gameplaymoduleactive()
    tornadomgr.enableskill(4)
    gomgr.getbyoid(1609):dispatchlabel("weatherphase0")

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
    if (taskFail[currenttask]() or (started and tornadomgr.stormchambertimer.timervalue <= 0)) then
        complete = -1
        gomgr.getbyoid(2022):settaskfail(currenttask - 1)
        audio.postevent("PLAY_TUTORIAL_FAILURE")
        gomgr.getbyoid(2022):finish()
        tornadomgr.stormchambertimer:stoptimer()

        if (failText[currenttask] or (started and tornadomgr.stormchambertimer.timervalue <= 0)) then
            engine.pushmode(1)
            gomgr.getbyoid(2021).location = 0
            gomgr.getbyoid(2021).portrait = 1
            if (started and tornadomgr.stormchambertimer.timervalue <= 0) then
                gomgr.getbyoid(2021):settext(" textbox ", 1482)
            else
                gomgr.getbyoid(2021):settext(" textbox ", failText[currenttask])
            end
            beginwait()
            gomgr.getbyoid(2021):start()
            endwait()
            engine.popmode(1)
            gomgr.getbyoid(2021):finish()
        end

        --
        cameramgr.screenfade(0, 0.7, 1.5, 1.5)
        pause(0.8)
        reset(introText)
    end
end
