-- MULTIPLAYER FIX DATE: April 7, 2024
-- REVISION DATE: May 12, 2024
-- Changelog: Adding OID for Wind Warrior. These don't seem to do anything?
complete = 0
taskcount = 4
currenttask = 1
introText = {
  1056,
  1057, 
  1488
}
successText = {
  1063
}
failText = {
  1047,
  1050,
  1053,
  1467,
}
taskText = {
  1751,
  1752,
  1753,
  1754
}
taskSuccess = {
    function()
        if (not gomgr.getbyoid(1673).canbreaknext) then
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
        if (not gomgr.getbyoid(1672).canbreaknext and not gomgr.getbyoid(1671).canbreaknext) then
            return true
        else
            return false
        end
    end,
    function()
        if (tornadomgr.getcombinedfiresprites() + spritemgr.getlivespritecount(1) >= 3) then
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

function success()
  engine.pushmode(1)
  tornadomgr.firstactivetornado.inforceshowavatarstate = true -- Zephyr
  tornadomgr.secondactivetornado.inforceshowavatarstate = true -- Wind Warrior

  gomgr.getbyoid(2005).talkingtotrainer = true
--gomgr.getbyoid(2009).talkingtotrainer = true
  --                  
  if #successText > 0 then
    gomgr.getbyoid(2021).finishonbuttonpress = false
    for i = 1, #successText do
      gomgr.getbyoid(2021).location = 0
      gomgr.getbyoid(2021).portrait = 1
      gomgr.getbyoid(2021):settext(" textbox ", successText[i])
      if i == #successText then gomgr.getbyoid(2021).finishonbuttonpress = true end
      beginwait()
        gomgr.getbyoid(2021):start()
      endwait()
    end
    gomgr.getbyoid(2021):finish()
  end
  
  gomgr.getbyoid(2022):finish()
  gomgr.getbyoid(1849).path = gomgr.getbyoid(1602)
  gomgr.getbyoid(1849):dispatchlabel("trainer_fly")
  pause(0.5)
  gomgr.getbyoid(1609):dispatchlabel("weatherphase1")
  beginwait()
  	cinematic.play("3to4")
  endwait()
  engine.popmode(1)
  tornadomgr.firstactivetornado.inforceshowavatarstate = false -- Zephyr
  tornadomgr.secondactivetornado.inforceshowavatarstate = false -- Wind Warrior
  gomgr.getbyoid(2005).talkingtotrainer = false
--gomgr.getbyoid(2009).talkingtotrainer = false
  requestcomplete(true)
end

function reset(text)
  --                                                                         
  gomgr.getbyoid(1849):dispatchlabel("reset")
  spritemgr.resetallsprites()
  tornadomgr.firstactivetornado:resetfirespritescollected()
	gomgr.getbyoid(1671):resetbreak()
	gomgr.getbyoid(1671):resurrect()
	gomgr.getbyoid(1672):resetbreak()
	gomgr.getbyoid(1672):resurrect()
	gomgr.getbyoid(1673):resetbreak()
	gomgr.getbyoid(1673):resurrect()
  tornadomgr.firstactivetornado:setfujitarating(2.0)
  
  if (type(text) == "string") then text = { text } end
    
	--                
  gomgr.getbyoid(1595):freeze()
  engine.pushmode(1)
  
  --           
  gomgr.getbyoid(2021).location = 1
  gomgr.getbyoid(2021).buttonon = true
  gomgr.getbyoid(2021).finishonbuttonpress = false
  for i = 1, #text do
    gomgr.getbyoid(2021):settext(" textbox ", text[i])
    if i == #text then gomgr.getbyoid(2021).finishonbuttonpress = true end
    beginwait()
      gomgr.getbyoid(2021):start()
    endwait()
  end
  gomgr.getbyoid(2021):finish()  
    
  --         
  gomgr.getbyoid(1595):unfreeze()
  engine.popmode(1)
  
  --                           
  gomgr.getbyoid(1849).path = gomgr.getbyoid(1600)
  gomgr.getbyoid(1849):dispatchlabel("trainer_fly")
  
  --               
  gomgr.getbyoid(2022):cleartasktext()
  gomgr.getbyoid(2022).taskcount = #taskText
  for i = 1, #taskText do
    gomgr.getbyoid(2022):settasktext(i-1, taskText[i])
  end
  gomgr.getbyoid(2022):start()
  
  audio.setstate("EXCITEMENT_LEVEL", "world1_tornado3")
  complete = 0
  triggered = false
	currenttask = 1
end

--      
function on_gameplaymoduleactive()
  tornadomgr.enableskill(4)
  gomgr.getbyoid(1590):dispatchlabel("weatherphase0") 
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
  if (complete ~= 0) then return end
    
  --              
  if (taskSuccess[currenttask]()) then
    gomgr.getbyoid(2022):settaskcomplete(currenttask-1)
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
    gomgr.getbyoid(2022):settaskfail(currenttask-1)
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