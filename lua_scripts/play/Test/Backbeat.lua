local pos_self = function(role)
	return function()
		return player.pos(role)
	end
end
local dir_pos = function (pos1,pos2)
	return function()
		debugEngine:gui_debug_msg(CGeoPoint:new_local(0,0),pos1:x().."  "..pos2:x())
		return (pos2 - pos1):dir()
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
local backbeat = function(Enemynum)
	return function()
		return ball.pos() + Utils.Polar2Vector(-95,(ball.pos() - enemy.pos(Enemynum)):dir())
	end
end
pos = {
	CGeoPoint:new_local(0,0),
	CGeoPoint:new_local(-2300,1500),
	CGeoPoint:new_local(-2300,-1500)
}
local DSS_FLAG = bit:_or(flag.allow_dss,flag.dodge_ball)
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
firstState = "ini",
--role   使用这个函数的角色
--p	     等待位置
["ini1"] = {
	switch = function()

	end,
	Assister = task.goCmuRush(pos[1],0),
	Kicker = task.goCmuRush(pos[2],0),
	Tier = task.goCmuRush(pos[3],0),
	match = "{AKT}"
},

["ini"] = {
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
			return "backbeat"
		end
	end,
	Assister = task.stop(),
	Kicker = task.Getballv4("Kicker",pos_self("Kicker")),
	Tier = task.stop(),
	match = "{AKT}"
},

["backbeat"] = {
	switch = function()
		if bufcnt(true,80) then
			return "backbeat1"
		end
	end,
	Assister = task.stop(),
	Kicker = task.goCmuRush(backbeat(4),dir_ball("Kicker"),_,DSS_FLAG),
	Tier = task.stop(),
	match = "{AKT}"
},


["backbeat1"] = {
	switch = function()

	end,
	Assister = task.stop(),
	Kicker = task.goCmuRush(backbeat(4),dir_ball("Kicker"),_,0x00000100),
	Tier = task.stop(),
	match = "{AKT}"
},
name = "Backbeat",
applicable ={
	exp = "a",
	a = true
},
attribute = "attack",
timeout = 99999
}
