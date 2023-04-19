 local pos_up = function()
	return function()
		return task.GetShootdot_up()
	end
end

local pos_down = function()
	return function()
		return task.GetShootdot_down()
	end
end

local pos_self = function(role)
	return function()
		return player.pos(role)
	end
end

local GoalPos = function()
	return function()
		return task.GetGoalPos(task.GetDefenseEnemyNum())
	end
end

local Dir_ball = function(role)
	return function()
		return (ball.pos() - player.pos(role)):dir()
	end
end

local Dir_goal = function(role)
	return function()
		return (task.GetGoalPos(task.GetDefenseEnemyNum()) - player.pos(role)):dir()
	end
end
local ShowTimeStartPos = function()
	return function()
		return task.ShowTimeV1Pos
	end
end
local dir_self = function(role1,role2)
	return function()
		return (player.pos(role2) - player.pos(role1)):dir()
	end
end

local test = function(role)
	local ball_line = CGeoLine:new_local(ball.pos(),ball.velDir())
	local target_pos = ball_line:projection(player.pos(role))
	
	return target_pos
end

--"[A][K][T]"
--"(A)(K)(T)"
--"[AKT]"
--"(AKT)"
--"{AKT}"
---passball 参数
PASS_KP = 1
PASS_ERROR = 8
Buffcnt_count = 5
a  = -1
--task.GetBallV3("Assister",CGeoPoint:new_local(3000,0),10,1500,250,4,130,8),
gPlayTable.CreatePlay{
firstState = "v_Assister",
["FunctionTest1111"] = {
	switch = function()


	end,
	Assister = task.GetBallV2("Assister",CGeoPoint:new_local(0,0),10,1500),
	Kicker = task.stop(),
	Tier = task.stop(),
	match = "{AKT}"
},
["FunctionTest"] = {
	switch = function()
		if player.infraredCount("Assister") > 10 then
			return "FunctionTest1"
		end

	end,
	Assister = task.GetBallV2("Assister",CGeoPoint:new_local(0,0),10,1500),
	Kicker = task.stop(),
	Tier = task.stop(),
	match = "{AKT}"
},

["FunctionTest1"] = {
	switch = function()
	if task.XYroleBallIsLine(CGeoPoint:new_local(3000,0),"Assister",12) then
		return "shoot"
	end
	end,
	Assister = task.GetBallV3("Assister",CGeoPoint:new_local(3000,0),10,1500,250,4,130,8),
	Kicker = task.goCmuRush(CGeoPoint:new_local(-1000,1000)),
	Tier = task.goCmuRush(CGeoPoint:new_local(1000,-1000)),
	match = "{AKT}"
},

["shoot"] = {
	switch = function()

	end,
	Assister = task.Shootdot(CGeoPoint:new_local(3000,0),false,PASS_KP,5,kick.flat),
	Kicker = task.stop(),
	Tier = task.stop(),
	match = "{AKT}"
},












-- ["Tier_passball_Assister"] = {
-- 	switch = function()
-- 		if player.kickBall("Tier") then -- or (ball.pos() - player.pos("Assister")):mod() > 350
-- 			return "v_Assister"
-- 		end
-- 	end,
-- 	Assister = task.goCmuRush(pos_down(),Dir_ball("Assister")),
-- 	Kicker = task.goCmuRush(pos_up(),Dir_ball("Kicker")),
-- 	Tier = task.Shootdot(pos_self("Assister"),false,PASS_KP,PASS_ERROR,kick.flat),
-- 	match = "{AKT}"
-- },


--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--|||||||
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
["v_Assister"] = {
	switch = function()
		task.GetShootPoint_Debug_down("Assister")
		task.GetShootPoint_Debug_up("Assister")
		return "ready_pos_Assister"
	end,
	Assister = task.GetBallV2("Assister",CGeoPoint:new_local(0,0),50,1500),
	Kicker = task.stop(),
	Tier = task.stop(),
	match = "{AKT}"
},

["v_Kicker"] = {
	switch = function()
		task.GetShootPoint_Debug_down("Kicker")
		task.GetShootPoint_Debug_up("Kicker")
		return "ready_pos_Kicker"
	end,
	Assister = task.goCmuRush(pos_up(),Dir_ball("Assister")),
	Kicker = task.GetBallV2("Kicker",ball.pos() + Utils.Polar2Vector(100,(player.pos("Kicker") - ball.pos()):dir()),10,2000),
	Tier = task.goCmuRush(pos_down(),Dir_ball("Tier")),
	match = "{AKT}"
},
["v_Tier"] = {
	switch = function()
		task.GetShootPoint_Debug_down("Tier")
		task.GetShootPoint_Debug_up("Tier")
		return "ready_pos_Tier"
	end,
	Assister = task.goCmuRush(pos_up(),Dir_ball("Assister")),
	Kicker = task.goCmuRush(pos_down(),Dir_ball("Kicker")),
	Tier = task.GetBallV2("Tier",ball.pos() + Utils.Polar2Vector(100,(player.pos("Tier") - ball.pos()):dir()),10,2000),
	match = "{AKT}"
},

--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--||||||||||||||||||||||||
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++



["ready_pos_Assister"] = {
	switch = function()
	task.ShowTimeV1_ini("Assister")
	task.ShowTimeV1("Assister",1000,4)
	if (player.pos("Assister") - ball.pos()):mod() < 150 then
		return "ShowTime_Assister"
	end
	end,
	Assister = task.Getballv4("Assister",player.pos("Assister")),
	Kicker = task.goCmuRush(pos_up(),Dir_ball("Kicker")),
	Tier = task.goCmuRush(pos_down(),Dir_ball("Tier")),
	match = "{AKT}"
},

["ready_pos_Kicker"] = {
	switch = function()

	task.ShowTimeV1_ini("Kicker")
	task.ShowTimeV1("Kicker",1000,4)
	if (player.pos("Kicker") - ball.pos()):mod() < 150 then
		return "ShowTime_Kicker"
	end
	end,
	Assister = task.goCmuRush(pos_up(),Dir_ball("Assister")),
	Kicker = task.Getballv4("Kicker",player.pos("Kicker")),
	Tier = task.goCmuRush(pos_down(),Dir_ball("Tier")),
	match = "{AKT}"
},
["ready_pos_Tier"] = {
	switch = function()
	task.ShowTimeV1_ini("Tier")
	task.ShowTimeV1("Tier",1000,4)
	if (player.pos("Tier") - ball.pos()):mod() < 150 then
		return "ShowTime_Tier"
	end
	end,
	Assister = task.goCmuRush(pos_up(),Dir_ball("Assister")),
	Kicker = task.goCmuRush(pos_down(),Dir_ball("Kicker")),
	Tier = task.Getballv4("Tier",player.pos("Tier")),
	match = "{AKT}"
},


--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--|||||||||||||||||||||||||||||||||||||||||
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
["ShowTime_Assister"] = {
	switch = function()
		task.ShowTimeV1("Assister",1000,4)
		if bufcnt(task.between_dot1(player.pos("Assister"),player.pos("Kicker")) == 1 and task.XYroleBallIsLine(player.pos("Kicker"),"Assister",12),Buffcnt_count) then
			return "Assister_passball_Kicker"
		elseif bufcnt( task.between_dot1(player.pos("Assister"),player.pos("Tier")) == 1  and task.XYroleBallIsLine(player.pos("Tier"),"Assister",12),Buffcnt_count) then
			return "Assister_passball_Tier"
		end
	end,
	Assister = task.ShowTIme_GetBallV3("Assister",ShowTimeStartPos(),50,500,130,3,100,50),
	Kicker = task.goCmuRush(pos_up(),Dir_ball("Kicker")),
	Tier = task.goCmuRush(pos_down(),Dir_ball("Tier")),
	match = "{AKT}"
},
["ShowTime_Kicker"] = {
	switch = function()
		task.ShowTimeV1("Kicker",1000,4)
		if bufcnt( task.between_dot1(player.pos("Kicker"),player.pos("Assister"))  == 1 and task.XYroleBallIsLine(player.pos("Assister"),"Kicker",12),Buffcnt_count) then
			return "Kicker_passball_Assister"
		elseif bufcnt( task.between_dot1(player.pos("Kicker"),player.pos("Tier")) == 1  and task.XYroleBallIsLine(player.pos("Tier"),"Kicker",12),Buffcnt_count) then
			return "Kicker_passball_Tier"
		end
	end,
	Assister = task.goCmuRush(pos_up(),Dir_ball("Assister")),
	Kicker = task.ShowTIme_GetBallV3("Kicker",ShowTimeStartPos(),50,500,130,3,100,50),
	Tier = task.goCmuRush(pos_down(),Dir_ball("Tier")),
	match = "{AKT}"
},

["ShowTime_Tier"] = {
	switch = function()
		task.ShowTimeV1("Tier",1000,4)
		if bufcnt( task.between_dot1(player.pos("Tier"),player.pos("Assister"))  == 1 and task.XYroleBallIsLine(player.pos("Assister"),"Tier",12),Buffcnt_count) then
			return "Tier_passball_Assister"
		elseif bufcnt( task.between_dot1(player.pos("Tier"),player.pos("Kicker")) == 1  and task.XYroleBallIsLine(player.pos("Kicker"),"Tier",12),Buffcnt_count) then
			return "Tier_passball_Kicker"
		end
	end,
	Assister = task.goCmuRush(pos_up(),Dir_ball("Assister")),
	Kicker = task.goCmuRush(pos_down(),Dir_ball("Kicker")),
	Tier = task.ShowTIme_GetBallV3("Tier",ShowTimeStartPos(),50,500,130,3,100,50),
	match = "{AKT}"
},
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
["Assister_passball_Kicker"] = {
	switch = function()
		if player.kickBall("Assister") then -- or (ball.pos() - player.pos("Assister")):mod() > 350
			return "v_Kicker"
		end
	end,
	Assister = task.Shootdot(pos_self("Kicker"),false,PASS_KP,PASS_ERROR,kick.flat),
	Kicker = task.goCmuRush(pos_up(),Dir_ball("Kicker")),
	Tier = task.goCmuRush(pos_down(),Dir_ball("Tier")),
	match = "{AKT}"
},
["Assister_passball_Tier"] = {
	switch = function()
		if player.kickBall("Assister") then -- or (ball.pos() - player.pos("Assister")):mod() > 350
			return "v_Tier"
		end
	end,
	Assister = task.Shootdot(pos_self("Tier"),false,PASS_KP,PASS_ERROR,kick.flat),
	Kicker = task.goCmuRush(pos_up(),Dir_ball("Kicker")),
	Tier = task.goCmuRush(pos_down(),Dir_ball("Tier")),
	match = "{AKT}"
},

--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

["Kicker_passball_Assister"] = {
	switch = function()
		if player.kickBall("Kicker") then -- or (ball.pos() - player.pos("Assister")):mod() > 350
			return "v_Assister"
		end
	end,
	Assister = task.goCmuRush(pos_up(),Dir_ball("Assister")),
	Kicker = task.Shootdot(pos_self("Assister"),false,PASS_KP,PASS_ERROR,kick.flat),
	Tier = task.goCmuRush(pos_down(),Dir_ball("Tier")),
	match = "{AKT}"
},
["Kicker_passball_Tier"] = {
	switch = function()
		if player.kickBall("Kicker") then -- or (ball.pos() - player.pos("Assister")):mod() > 350
			return "v_Tier"
		end
	end,
	Assister = task.goCmuRush(pos_up(),Dir_ball("Assister")),
	Kicker = task.Shootdot(pos_self("Tier"),false,PASS_KP,PASS_ERROR,kick.flat),
	Tier = task.goCmuRush(pos_down(),Dir_ball("Tier")),
	match = "{AKT}"
},

--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

["Tier_passball_Assister"] = {
	switch = function()
		if player.kickBall("Tier") then -- or (ball.pos() - player.pos("Assister")):mod() > 350
			return "v_Assister"
		end
	end,
	Assister = task.goCmuRush(pos_down(),Dir_ball("Assister")),
	Kicker = task.goCmuRush(pos_up(),Dir_ball("Kicker")),
	Tier = task.Shootdot(pos_self("Assister"),false,PASS_KP,PASS_ERROR,kick.flat),
	match = "{AKT}"
},
["Tier_passball_Kicker"] = {
	switch = function()
		if player.kickBall("Tier") then -- or (ball.pos() - player.pos("Assister")):mod() > 350
			return "v_Kicker"
		end
	end,
	Assister = task.goCmuRush(pos_down(),Dir_ball("Assister")),
	Kicker = task.goCmuRush(pos_up(),Dir_ball("Kicker")),
	Tier = task.Shootdot(pos_self("Kicker"),false,PASS_KP,PASS_ERROR,kick.flat),
	match = "{AKT}"
},
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

name = "ShowTime",
applicable ={
	exp = "a",
	a = true
},
attribute = "attack",
timeout = 99999
}
