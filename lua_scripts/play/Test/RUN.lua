local f = flag.dribbling --  + flag.dodge_ball + flag.allow_dss
-- local p = CGeoPoint:new_local(1000,1000)
local p = CGeoPoint:new_local(3000,0)
local p1 = CGeoPoint:new_local(500,0)
local O = CGeoPoint:new_local(0,0)
local Home1 = CGeoPoint:new_local(-3300,1000)
local Home2 = CGeoPoint:new_local(-3300,0)
local Home3 = CGeoPoint:new_local(-3300,-1000)

local pos = function()
	return function()
		return task.GetShootdot()
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
-- task.Shootdot(p1,true,_,0)
-- pos()
---夺旗思路: ShowTime函数： 2类评分
--1. 计算 传球或者带球的最优得分
--2. 带球计算：ShowTime
--然后 传球 拿到球的人 就 ShowTime 其他人 就跑空为 准备接球与ShowTime
gPlayTable.CreatePlay{
firstState = "v",

["v"] = {
	switch = function()
		task.GetGoalPos(task.GetDefenseEnemyNum())
		task.GetShootdot_Debug()
		debugEngine:gui_debug_x(task.GetGoalPos(task.GetDefenseEnemyNum()),1)
		if(ball.posX() > 3500 or ball.posX() < -3500) then 
			return "getball_back"
		end

		return "getball"
	end,
	Assister = task.stop(),
	Kicker = task.stop(),
	match = "[AK]"
},
["getball"] = {
	switch = function()
		debugEngine:gui_debug_x(task.GetGoalPos(task.GetDefenseEnemyNum()),1)
		if player.toTargetDist("Assister") < 100 and player.infraredCount("Kicker") > 50 then
			return "pass"
		end
		--task.GetShootdot_Debug()
		-- debugEngine:gui_debug_arc(player.pos("Assister"),100,360,360,3)
		-- debugEngine:gui_debug_arc(player.pos("Assister"),110,360,360,2)
	end,
	Assister = task.goCmuRush(pos(),Dir_ball("Assister")),
	Kicker = task.GetBallV2("Kicker",pos_self("Assister"),200,800), -- p之后改成最佳射门点task.getball(150,task.GetShootdot(),_,flag.dodge_ball + flag.allow_dss), -- p之后改成最佳射门点
	match = "{AK}"
},
["getball_back"] = {
	switch = function()
		debugEngine:gui_debug_x(task.GetGoalPos(task.GetDefenseEnemyNum()),1)
		if player.toTargetDist("Kicker") < 180 then
			return "getball"
		end
		--task.GetShootdot_Debug()
		-- debugEngine:gui_debug_arc(player.pos("Assister"),100,360,360,3)
		-- debugEngine:gui_debug_arc(player.pos("Assister"),110,360,360,2)
	end,
	Assister = task.goCmuRush(pos(),Dir_ball("Assister")),
	Kicker = task.getball(250,pos(), a, flag.dodge_ball + flag.allow_dss, r, v), -- p之后改成最佳射门点task.getball(150,task.GetShootdot(),_,flag.dodge_ball + flag.allow_dss), -- p之后改成最佳射门点
	match = "{AK}"
},
["pass"] = {
	switch = function()
		debugEngine:gui_debug_x(task.GetGoalPos(task.GetDefenseEnemyNum()),1)
		if (ball.pos() - player.pos("Assister")):mod() < 200 then
			return "shoot"
		end
		--task.GetShootdot_Debug()
		-- debugEngine:gui_debug_arc(player.pos("Assister"),100,360,360,3)
		-- debugEngine:gui_debug_arc(player.pos("Assister"),110,360,360,2)
	end,
	Assister = task.Getballv4("Assister",pos_self("Assister")),
	Kicker = task.Shootdot(pos_self("Assister"),false,0.1,8,1), -- p之后改成最佳射门点
	match = "{AK}"
},

["shoot"] = {
	switch = function()
		debugEngine:gui_debug_x(task.GetGoalPos(task.GetDefenseEnemyNum()),1)
		if player.toTargetDist("Assister") < 100 and player.infraredCount("Assister") > 40 then
			return "dribbling"
		end
		-- debugEngine:gui_debug_arc(player.pos("Assister"),100,360,360,3)
		-- debugEngine:gui_debug_arc(player.pos("Assister"),110,360,360,2)
	end,
	Assister = task.GetBallV2("Assister",GoalPos(),200,300), -- p之后改成最佳射门点
	Kicker = task.goCmuRush(p1,_,_,flag.dodge_ball + flag.allow_dss),
	match = "{AK}"
},

["dribbling"] = {
	switch = function()
		debugEngine:gui_debug_x(task.GetGoalPos(task.GetDefenseEnemyNum()),1)
		if player.toTargetDist("Assister") < 20 then
			return "shoot1"
		end
	end,
	Assister = task.goCmuRush(pos(),Dir_goal("Assister"),300,flag.dribbling), -- p之后改成最佳射门点
	Kicker = task.goCmuRush(p1,_,_,flag.dodge_ball + flag.allow_dss),
	match = "{AK}"
},
["shoot_last"] = {
	switch = function()
		debugEngine:gui_debug_x(task.GetGoalPos(task.GetDefenseEnemyNum()),1)
		if bufcnt(1,120) then
			return "shoot1"
		end
		-- debugEngine:gui_debug_arc(player.pos("Assister"),100,360,360,3)
		-- debugEngine:gui_debug_arc(player.pos("Assister"),110,360,360,2)
	end,
	Assister = task.goCmuRush(pos(),Dir_goal("Assister"),_,f),--task.getball(380,GoalPos(),_,flag.dodge_ball + flag.allow_dss), -- p之后改成最佳射门点
	Kicker = task.goCmuRush(p1,_,_,flag.dodge_ball + flag.allow_dss),
	match = "{AK}"
},
["shoot1"] = {
	switch = function()
		debugEngine:gui_debug_x(task.GetGoalPos(task.GetDefenseEnemyNum()),1)
		if player.kickBall("Assister") then
			return "stop"
		end
	end,
	Assister = task.Shootdot(GoalPos(),false,10,10,1), -- p之后改成最佳射门点
	Kicker = task.goCmuRush(p1,_,_,flag.dodge_ball + flag.allow_dss),
	match = "{AK}"
},

["stop"] = {
	switch = function()
		debugEngine:gui_debug_x(task.GetGoalPos(task.GetDefenseEnemyNum()),1)
		-- task.GetShootdot_Debug()
		-- debugEngine:gui_debug_arc(player.pos("Assister"),100,360,360,3)
		-- debugEngine:gui_debug_arc(player.pos("Assister"),110,360,360,2)
	end,
	Assister = task.stop(), -- p之后改成最佳射门点
	Kicker = task.stop(),
	match = "{AK}"
},
name = "RUN",
applicable ={
	exp = "a",
	a = true
},
attribute = "attack",
timeout = 99999
}
