-- MULTIPLAYER FIX DATE: April 8, 2024
-- REVISION DATE: April 16, 2024
-- Changelog: Replaced firespritecount with getcombinedfiresprites.
complete = 0
totalspritecount = 50
taskcount = 3
currenttask = 1
introText = {
  1484,
  1087,
  1088,
  1089
}
successText = {
  1090
}
failText = { 
  1084,
  1468,
  1085
}
taskText = {
  1766,
  1767,
  1768
}
endText = {
  1091,
  1092
}
taskSuccess = {
  
  function ()
    return tornadomgr.getcombinedfiresprites() + spritemgr.getlivespritecount(1) >= 25
    end,
  function () 
    return tornadomgr.getcombinedfiresprites() + spritemgr.getlivespritecount(1) >= 50
 end
}
taskFail = {
  function () return (tornadomgr.stormchambertimer.timervalue <= 0) end,
  function () return (tornadomgr.stormchambertimer.timervalue <= 0) end,
  function () return (tornadomgr.stormchambertimer.timervalue <= 0) end,
  --                                                           
}

function on_label(label)
  if (label == "on_triggered") then
    if (complete == 0 and currenttask > 1) then
      complete = 1
      gomgr.getbyoid(2022):settaskcomplete(2)
      tornadomgr.stormchambertimer:stoptimer()
      
	    --                  
      if #successText > 0 then
        engine.pushmode(1)
        tornadomgr.firstactivetornado.inforceshowavatarstate = true
        tornadomgr.secondactivetornado.inforceshowavatarstate = true
        gomgr.getbyoid(2005).talkingtotrainer = true
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
        engine.popmode(1)
        gomgr.getbyoid(2021):finish()
        tornadomgr.firstactivetornado.inforceshowavatarstate = false
        tornadomgr.secondactivetornado.inforceshowavatarstate = false
        gomgr.getbyoid(2005).talkingtotrainer = false
      end
      
      audio.postevent("Play_Tutorial_Success")
	    gomgr.getbyoid(2022):finish()
      requestcomplete(true)
    end
  end
end

function reset(text)
  --                                                                         
  gomgr.getbyoid(1849):dispatchlabel("reset")
  spritemgr.resetallsprites()
  tornadomgr.firstactivetornado:resetfirespritescollected()
	gomgr.getbyoid(1770):resetbreak()
	gomgr.getbyoid(1770):resurrect()
	gomgr.getbyoid(1798):resetbreak()
	gomgr.getbyoid(1798):resurrect()
	gomgr.getbyoid(1811):resetbreak()
	gomgr.getbyoid(1811):resurrect()
	gomgr.getbyoid(1785):resetbreak()
	gomgr.getbyoid(1785):resurrect()
	gomgr.getbyoid(1804):resetbreak()
	gomgr.getbyoid(1804):resurrect()
	gomgr.getbyoid(1784):resetbreak()
	gomgr.getbyoid(1784):resurrect()
	gomgr.getbyoid(1783):resetbreak()
	gomgr.getbyoid(1783):resurrect()
	gomgr.getbyoid(1796):resetbreak()
	gomgr.getbyoid(1796):resurrect()
	gomgr.getbyoid(1769):resetbreak()
	gomgr.getbyoid(1769):resurrect()
	gomgr.getbyoid(1782):resetbreak()
	gomgr.getbyoid(1782):resurrect()
	gomgr.getbyoid(1768):resetbreak()
	gomgr.getbyoid(1768):resurrect()
	gomgr.getbyoid(1795):resetbreak()
	gomgr.getbyoid(1795):resurrect()
	
	gomgr.getbyoid(1781):resetbreak()
	gomgr.getbyoid(1781):resurrect()
	gomgr.getbyoid(1780):resetbreak()
	gomgr.getbyoid(1780):resurrect()
	gomgr.getbyoid(1779):resetbreak()
	gomgr.getbyoid(1779):resurrect()
	gomgr.getbyoid(1767):resetbreak()
	gomgr.getbyoid(1767):resurrect()

	gomgr.getbyoid(1778):resetbreak()
	gomgr.getbyoid(1778):resurrect()
	gomgr.getbyoid(1766):resetbreak()
	gomgr.getbyoid(1766):resurrect()
	gomgr.getbyoid(1777):resetbreak()
	gomgr.getbyoid(1777):resurrect()
	gomgr.getbyoid(1797):resetbreak()
	gomgr.getbyoid(1797):resurrect()
	
	gomgr.getbyoid(1813):resetbreak()
	gomgr.getbyoid(1813):resurrect()
	gomgr.getbyoid(1776):resetbreak()
	gomgr.getbyoid(1776):resurrect()
	gomgr.getbyoid(1794):resetbreak()
	gomgr.getbyoid(1794):resurrect()
	gomgr.getbyoid(1793):resetbreak()
	gomgr.getbyoid(1793):resurrect()
	gomgr.getbyoid(1775):resetbreak()
	gomgr.getbyoid(1775):resurrect()
	gomgr.getbyoid(1814):resetbreak()
	gomgr.getbyoid(1814):resurrect()
	gomgr.getbyoid(1807):resetbreak()
	gomgr.getbyoid(1807):resurrect()
	gomgr.getbyoid(1774):resetbreak()
	gomgr.getbyoid(1774):resurrect()
	gomgr.getbyoid(1765):resetbreak()
	gomgr.getbyoid(1765):resurrect()
	gomgr.getbyoid(1792):resetbreak()
	gomgr.getbyoid(1792):resurrect()
	
	gomgr.getbyoid(1773):resetbreak()
	gomgr.getbyoid(1773):resurrect()
	gomgr.getbyoid(1808):resetbreak()
	gomgr.getbyoid(1808):resurrect()
	gomgr.getbyoid(1805):resetbreak()
	gomgr.getbyoid(1805):resurrect()
	gomgr.getbyoid(1806):resetbreak()
	gomgr.getbyoid(1806):resurrect()
	gomgr.getbyoid(1812):resetbreak()
	gomgr.getbyoid(1812):resurrect()
	gomgr.getbyoid(1772):resetbreak()
	gomgr.getbyoid(1772):resurrect()
	gomgr.getbyoid(1771):resetbreak()
	gomgr.getbyoid(1771):resurrect()
	gomgr.getbyoid(1791):resetbreak()
	gomgr.getbyoid(1791):resurrect()
	gomgr.getbyoid(1790):resetbreak()
	gomgr.getbyoid(1790):resurrect()
	gomgr.getbyoid(1789):resetbreak()
	gomgr.getbyoid(1789):resurrect()
	gomgr.getbyoid(1788):resetbreak()
	gomgr.getbyoid(1788):resurrect()
  tornadomgr.firstactivetornado:setfujitarating(2.0)
  
  if (type(text) == "string") then text = { text } end
    
	--                
  gomgr.getbyoid(1623):freeze()
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
  gomgr.getbyoid(1623):unfreeze()
  engine.popmode(1)
  
  --               
  gomgr.getbyoid(2022):cleartasktext()
  gomgr.getbyoid(2022).taskcount = #taskText
  for i = 1, #taskText do
    gomgr.getbyoid(2022):settasktext(i-1, taskText[i])
  end
  gomgr.getbyoid(2022):start()
  
  --                           
  gomgr.getbyoid(1849).path = gomgr.getbyoid(1633)
  gomgr.getbyoid(1849):dispatchlabel("trainer_fly")
  
  audio.setstate("EXCITEMENT_LEVEL", "world1_tornado6")
  
  tornadomgr.stormchambertimer:starttimerforboss(30)
  --                               
  --                                       
  --                                          
  
  complete = 0
	currenttask = 1
end

--      
function on_gameplaymoduleactive()
  tornadomgr.displayfirespritegoalinfo = true
  tornadomgr.displayfirespritetotalinfo = true
  tornadomgr.enableskill(4)
  gomgr.getbyoid(1618):dispatchlabel("weatherphase0")
  
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
    complete = 1
  
    --               
    if (currenttask == 2) then
      beginwait()
        uimgr.playhint(1483)
      endwait()

      if (gomgr.getbyoid(16) == tornadomgr.firstactivetornado) then
        tagamestats.unlockaward(0, 17)
      else
        tagamestats.unlockaward(1, 17)
      end
    end
      
    if (currenttask == 1) then
      audio.postevent("Play_Tutorial_Task_Success")
      --           
        --                                                       
      --         
      
      --                                      
      tornadomgr.stormchambertimer:pausetimer()
      engine.pushmode(1)
      cinematic.play("loadIntro")
      
      --           
      gomgr.getbyoid(2021).finishonbuttonpress = false
      for i = 1, #endText do
        gomgr.getbyoid(2021).location = 0
        gomgr.getbyoid(2021).buttonon = true
        gomgr.getbyoid(2021):settext(" textbox ", endText[i])
        gomgr.getbyoid(2021).finishonbuttonpress = true
        beginwait()
          gomgr.getbyoid(2021):start()
        endwait()
        if (i == 1) then
          pause(0.5)
          gomgr.getbyoid(1816):dispatchlabel("show")
          gomgr.getbyoid(2022):settaskcomplete(currenttask-1)
          pause(2.0)
        end
      end
      pause(0.5)
      gomgr.getbyoid(2021):finish()
      
      --         
      cinematic.stop()
      engine.popmode(1)
      if (gomgr.getbyoid(16) == tornadomgr.firstactivetornado) then
        cameramgr.deactivatecamera(0, 14, 0)
      else
        cameramgr.deactivatecamera(1, 14, 0)
      end
      tornadomgr.stormchambertimer:starttimer()
    else
      gomgr.getbyoid(2022):settaskcomplete(currenttask-1)
    end
    
    complete = 0
    currenttask = currenttask + 1
  end
  
  --              
  if (taskFail[currenttask]()) then
    complete = -1
    gomgr.getbyoid(2022):settaskfail(currenttask-1)
    audio.postevent("PLAY_TUTORIAL_FAILURE")
    gomgr.getbyoid(2022):finish()
    tornadomgr.stormchambertimer:stoptimer()
    
    if (failText[currenttask]) then
      engine.pushmode(1)
      gomgr.getbyoid(2021).location = 0
      gomgr.getbyoid(2021).portrait = 1
      gomgr.getbyoid(2021):settext(" textbox ", failText[currenttask])
      beginwait()
        gomgr.getbyoid(2021):start()
      endwait()
      engine.popmode(1)
      gomgr.getbyoid(2021):finish()
    end
    
    --           
    cameramgr.screenfade(0, 0.7, 1.5, 1.5)
    pause(0.8)
    gomgr.getbyoid(1816):dispatchlabel("training_hide")
    reset(introText)
  end
  
end
