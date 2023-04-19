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

local between_enemy = function(enemy1,enemy2)
	return function()
		return enemy.pos(enemy1) + Utils.Polar2Vector(-1 * (enemy.pos(enemy1) - enemy.pos(enemy2)):mod() / 2,(enemy.pos(enemy1) - enemy.pos(enemy2)):dir())
	end
end
PASS_KP = 0.099
PASS_ERROR = 8
Buffcnt_count = 5
a  = -1
R_robot = 130
pos = {
	CGeoPoint:new_local(-500 - R_robot,0),
	CGeoPoint:new_local(0,500 + R_robot),
	CGeoPoint:new_local(0,-500 - R_robot)
}

DefinePos = {
	CGeoPoint:new_local(0,0),
}

gPlayTable.CreatePlay{
firstState = "inipos",

["inipos"] = {
	switch = function()
		if ball.velMod() > 100 then
			return "BetweenEnemy"
		end
	end,
	Assister = task.goCmuRush(pos[1],0),
	Kicker = task.goCmuRush(pos[2],0),
	Tier = task.goCmuRush(pos[3],0),
	match = "{AKT}"
},
["BetweenEnemy"] = {
	switch = function()
		dist = {
		(ball.pos() - enemy.pos(6)):mod(),
		(ball.pos() - enemy.pos(1)):mod(),
		(ball.pos() - enemy.pos(2)):mod()	
		}
		mindist = math.min(unpack(dist))
		if dist[1] == mindist and dist[1] < 300 then 
			return "attackTier"
		elseif dist[2] == mindist and dist[2] < 300 then 
			return "attackKicker"
		elseif dist[3] == mindist and dist[3] < 300 then 
			return "attackAssister"	
		end
	end,
	Assister = task.goCmuRush(between_enemy(6,1),0,_,_,flag.dodge_ball),
	Kicker = task.goCmuRush(between_enemy(6,2),0,_,_,flag.dodge_ball),
	Tier = task.goCmuRush(between_enemy(1,2),0,_,_,flag.dodge_ball),
	match = "{AKT}"
},

["attackTier"] = {
	switch = function()
		dist = {
		(ball.pos() - enemy.pos(6)):mod(),
		(ball.pos() - enemy.pos(1)):mod(),
		(ball.pos() - enemy.pos(2)):mod()	
		}
		mindist = math.min(unpack(dist))
		if dist[1] == mindist and dist[1] < 300 then 
			return "attackTier"
		elseif dist[2] == mindist and dist[2] < 300 then 
			return "attackKicker"
		elseif dist[3] == mindist and dist[3] < 300 then 
			return "attackAssister"	
		end
	end,
	Assister = task.goCmuRush(between_enemy(6,1),dir_ball("Assister")),
	Kicker = task.goCmuRush(between_enemy(6,2),dir_ball("Kicker")),
	Tier = task.GetBallV2("Tier",ball.pos(),10,2000),
	match = "{AKT}"
},
["attackKicker"] = {
	switch = function()
		dist = {
		(ball.pos() - enemy.pos(6)):mod(),
		(ball.pos() - enemy.pos(1)):mod(),
		(ball.pos() - enemy.pos(2)):mod()	
		}
		mindist = math.min(unpack(dist))
		if dist[1] == mindist and dist[1] < 300 then 
			return "attackTier"
		elseif dist[2] == mindist and dist[2] < 300 then 
			return "attackKicker"
		elseif dist[3] == mindist and dist[3] < 300 then 
			return "attackAssister"	
		end
	end,
	Assister = task.goCmuRush(between_enemy(6,1),dir_ball("Assister")),
	Kicker = task.GetBallV2("Kicker",ball.pos(),10,2000),
	Tier = task.goCmuRush(between_enemy(1,2),dir_ball("Tier")),
	match = "{AKT}"
},
["attackAssister"] = {
	switch = function()
		dist = {
		(ball.pos() - enemy.pos(6)):mod(),
		(ball.pos() - enemy.pos(1)):mod(),
		(ball.pos() - enemy.pos(2)):mod()	
		}
		mindist = math.min(unpack(dist))
		if dist[1] == mindist and dist[1] < 300 then 
			return "attackTier"
		elseif dist[2] == mindist and dist[2] < 300 then 
			return "attackKicker"
		elseif dist[3] == mindist and dist[3] < 300 then 
			return "attackAssister"	
		end
	end,
	Assister = task.GetBallV2("Assister",ball.pos(),10,2000),
	Kicker = task.goCmuRush(between_enemy(6,2),dir_ball("Kicker")),
	Tier = task.goCmuRush(between_enemy(1,2),dir_ball("Tier")),
	match = "{AKT}"
},
--如果有一个人一直持球 那么另外两个人将会沿着 线段的位置向前包夹
name = "BOSS",
applicable ={
	exp = "a",
	a = true
},
attribute = "attack",
timeout = 99999
}
