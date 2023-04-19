local pos_self = function(role)
	return function()
		return player.pos(role)
	end
end
local dir_self = function(role1,role2)
	return function()
		return (player.pos(role2) - player.pos(role1)):dir()
	end
end

local dir_ball = function(role)
	return function()
		return (ball.pos() - player.pos(role)):dir()
	end
end
PASS_KP = 0.099
PASS_ERROR = 8
Buffcnt_count = 5
a  = -1
DefinePos = {
	CGeoPoint:new_local(0,0),
}


--坐标 CGeoPoint:new_local(0,0)
--方向 dir

position = CGeoPoint:new_local(15,2100)


gPlayTable.CreatePlay{
firstState = "Test1",
--role   使用这个函数的角色
--p	     等待位置


["Test1"] = {
	switch = function()
		debugEngine:gui_debug_x(task.GetGoalPos(task.GetDefenseEnemyNum()))
		task.GetPlayerAndEnemyValid()
		task.Confidence_pass("Assister")
		--task.Confidence_shoot("Assister")
		task.motionLineSafety("Assister",1000)

	end,
	Assister = task.stop(),
	match = "{AKT}"
},

-- ["Test"] = {
-- 	switch = function()
-- 		if player.infraredCount("Assister") > 100 then
-- 			return "Test1"
-- 		end
-- 	end,
-- 	Assister = task.GetBallV2("Assister",CGeoPoint:new_local(0,0) ,100,500),
-- 	match = "{AKT}"
-- },
-- ["Test1"] = {
-- 	switch = function()
-- 		if task.XYroleBallIsLine(CGeoPoint:new_local(-3000,0),"Assister",1) then
-- 			return "TestShoot"
-- 		end
-- 	end,
-- 	Assister = task.GetBallV3("Assister",CGeoPoint:new_local(-3000,0),130,800,150,6,130,5),

-- 	match = "{AKT}"
-- },
-- ["TestShoot"] = {
-- 	switch = function()

-- 	end,
-- 	Assister = task.Shootdot(CGeoPoint:new_local(-3000,0),false,0.01,8,kick.flat),

-- 	match = "{AKT}"
-- },





["ini"] = {
	switch = function()
		if player.infraredCount("Assister") > 10 then
			return "PassballToKicker"
		end
	end,
	Assister = task.GetBallV2("Assister",pos_self("Kicker") ,10,500),
	Kicker = task.goCmuRush(pos_self("Kicker"),dir_self("Kicker","Assister")),
	Tier = task.stop(),
	match = "{AKT}"
},
["PassballToKicker"] = {
	switch = function()
		if player.kickBall("Assister") then
			return "GetballKicker"
		end
	end,
	Assister = task.Shootdot(pos_self("Kicker"),false,PASS_KP,PASS_ERROR,kick.flat),
	Kicker = task.goCmuRush(pos_self("Kicker"),dir_self("Kicker","Assister")),
	Tier = task.stop(),
	match = "{AKT}"
},



["GetballKicker"] = {
	switch = function()
		if player.infraredCount("Kicker") > 10 then
			return "PassballToTier"
		end
	end,
	Assister = task.stop(),
	Kicker = task.Getballv4("Kicker",pos_self("Kicker")),
	Tier = task.stop(),
	match = "{AKT}"
},



["PassballToTier"] = {
	switch = function()
		if player.kickBall("Kicker") then
			return "GetballTier"
		end
	end,
	Assister = task.stop(),
	Kicker = task.Shootdot(pos_self("Tier"),false,PASS_KP,PASS_ERROR,kick.flat),
	Tier = task.goCmuRush(pos_self("Tier"),dir_self("Tier","Kicker")),
	match = "{AKT}"
},

["GetballTier"] = {
	switch = function()
		if player.infraredCount("Tier") > 10 then
			return "PassballToAssister"
		end
	end,
	Assister = task.stop(),
	Kicker = task.stop(),
	Tier = task.Getballv4("Tier",pos_self("Tier")),
	match = "{AKT}"
},


["PassballToAssister"] = {
	switch = function()
		if player.kickBall("Tier") then
			return "GetballAssister"
		end
	end,
	Assister = task.goCmuRush(pos_self("Assister"),dir_self("Assister","Tier")),
	Kicker = task.stop(),
	Tier = task.Shootdot(pos_self("Assister"),false,PASS_KP,PASS_ERROR,kick.flat),
	match = "{AKT}"
},

["GetballAssister"] = {
	switch = function()
		if player.infraredCount("Assister") > 10 then
			return "ini"
		end
	end,
	Assister = task.Getballv4("Assister",pos_self("Assister")),
	Kicker = task.stop(),
	Tier = task.stop(),
	match = "{AKT}"
},


name = "EazyDefend",
applicable ={
	exp = "a",
	a = true
},
attribute = "attack",
timeout = 99999
}
