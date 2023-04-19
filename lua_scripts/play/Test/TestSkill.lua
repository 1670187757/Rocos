local f = flag.dribbling
local p = CGeoPoint:new_local(4500,0)
local p1 = CGeoPoint:new_local(0,0)
local kick = 0x00000001
local chip = 0x00000002	
local pos = function()
	return function()
		return task.GetShootDel()
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

local Dir_goal1 = function(role)
	return function()
		return (p - player.pos(role)):dir()
	end
end
gPlayTable.CreatePlay{

firstState = "t",
["t"] = {
	switch = function()
	end,
	Leader = task.WaitInterShoot("Leader",p1,p,f,2),
	match = "[L]"
},

name = "TestSkill",
applicable ={
	exp = "a",
	a = true
},
attribute = "attack",
timeout = 99999
}
