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

gPlayTable.CreatePlay{
firstState = "v_Assister",

["v_Assister"] = {
	switch = function()

	end,
	Assister = task.GetBallV2("Assister",CGeoPoint:new_local(0,0),50,1500),
	Kicker = task.GetBallV2("Kicker",CGeoPoint:new_local(0,0),50,1500),
	Tier = task.GetBallV2("Tier",CGeoPoint:new_local(0,0),50,1500),
	match = "{AKT}"
},



name = "ShowTime",
applicable ={
	exp = "a",
	a = true
},
attribute = "attack",
timeout = 99999
}
