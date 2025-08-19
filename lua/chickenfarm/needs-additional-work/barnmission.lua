-- MULTIPLAYER FIX DATE: April 10, 2024
-- REVISION DATE: August 19, 2025
--[[ None of the current implemented checks work. There's probably something I'm doing that's making it not work. For now though, we'll currently comment out
our previous implemented code until I can come up with a better solution.
]]--
-- CHANGELOG: Commented out code that doesn't work. In release, we'll probably cut these lines of code if I can't get them work.
-- haveplayertwo = false                                         
expandedarea = false
rankforbarn = false
leaveFenceText = {
  1135,
  1136,
}

barnDeadText = {
  1120
}

function on_gameplaymoduleactive()
  --                                              
  gomgr.getbyoid(264):dispatchlabel("weatherphase0")
  gomgr.getbyoid(260):dispatchlabel("weatherphase1")
  gomgr.getbyoid(57):addtoworld()
  tornadomgr.showtornadorank = true
  expandedarea = false
--[[ Commented out. See Changelog for further clarification!
 -- basic check for avatar2.
if taworld.gettornado(1) ~= nil then
    if haveplayertwo == false then
        haveplayertwo = true
        gomgr.getbyoid(3555):addtoworld()
        gomgr.getbyoid(3550):addtoworld()
    end
else
    if haveplayertwo == true then
        haveplayertwo = false
        gomgr.getbyoid(3555):removefromworld()
        gomgr.getbyoid(3550):removefromworld()
    end
end
--]]
  --                                       
  while (tornadomgr.firstactivetornado == nil) do
	  pause(0.1)
	  logline("waiting")
	end
  tornadomgr.firstactivetornado:setfujitarating(0.1)
end

function on_gameplaymoduleupdate()
	--
-- Here, we replace getcombinedfujita with fujirating	
  if tornadomgr.firstactivetornado:fujrating() >= 1 and not expandedarea then
    expandedarea = true
  
    --                                     
    engine.pushmode(1)
    beginwait()
      audio.postevent("enter_camera_slowdown")
      time.lerptotimescale(1.0, 0.1)
    endwait()
    for i = 1, #leaveFenceText do
      gomgr.getbyoid(3568).location = 0
      gomgr.getbyoid(3568).portrait = 1
      gomgr.getbyoid(3568).buttonon = true
      gomgr.getbyoid(3568):settext(" textbox ", leaveFenceText[i])
      gomgr.getbyoid(3568).finishonbuttonpress = (i==#leaveFenceText)
      beginwait()
        gomgr.getbyoid(3568):start()
      endwait()
    end
    beginwait()
      audio.postevent("exit_camera_slowdown")
      time.lerptotimescale(1.0, 1.0)
    endwait()
    engine.popmode(1)
    gomgr.getbyoid(57):removefromworld()
-- Ditto                                                              
  elseif tornadomgr.firstactivetornado:fujrating() >= 3.4 and not rankforbarn then
    rankforbarn = true
  
    --                                   
    engine.pushmode(1)
    beginwait()
      audio.postevent("enter_camera_slowdown")
      time.lerptotimescale(1.0, 0.1)
    endwait()
    gomgr.getbyoid(3568).location = 0
    gomgr.getbyoid(3568).portrait = 1
    gomgr.getbyoid(3568).buttonon = true
    gomgr.getbyoid(3568):settext(" textbox ", 1472)
    beginwait()
      gomgr.getbyoid(3568):start()
    endwait()
    beginwait()
      audio.postevent("exit_camera_slowdown")
      time.lerptotimescale(1.0, 1.0)
    endwait()
    engine.popmode(1)
  end
end

--                                                     
function on_label(label)
  if label == "weeniedead" then
    engine.pushmode(1)
    cinematic.play("barnSlowdown")
  
    --          
    gomgr.getbyoid(3568).location = 0
    gomgr.getbyoid(3568).portrait = 1
    gomgr.getbyoid(3568).buttonon = true
    for i = 1, #barnDeadText do
      gomgr.getbyoid(3568):settext(" textbox ", barnDeadText[i])
      gomgr.getbyoid(3568).finishonbuttonpress = (i==#barnDeadText)
      beginwait()
        gomgr.getbyoid(3568):start()
      endwait()
    end
    
    --       
    cinematic.stop()
    engine.popmode(1)
    cameramgr.screenfade(0, 0.7, 0.25, 1.0)
    pause(0.8)
    gomgr.getbyoid(260):dispatchlabel("weatherphase0")
    gomgr.getbyoid(261):dispatchlabel("weatherphase1")
    requestcomplete(true)
  end
end
