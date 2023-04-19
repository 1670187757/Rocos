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

gPlayTable.CreatePlay{
firstState = "getballassister",
--role   使用这个函数的角色
--p	     等待位置


["getballassister"] = {
	switch = function()
		if player.infraredCount("Assister") > 5 then
			return "passballtokicker"
		end
	end,
	Assister = task.GetBallV2("Assister",pos_self("Kicker"),200,500),
	Kicker = task.goCmuRush(pos_self("Kicker"),dir_self("Kicker","Assister")),
	Tier = task.stop(),
	match = "{AKT}"
},

["passballtokicker"] = {
	switch = function()
		if player.kickBall("Assister") then
			return "getballkicker1"
		end
	end,
	Assister = task.shoot(ball.pos(),dir_self("Assister","Kicker"),_,5000),
	Kicker = task.goCmuRush(pos_self("Kicker"),dir_self("Kicker","Assister")),
	Tier = task.stop(),
	match = "{AKT}"
},


["getballkicker1"] = {
	switch = function()
		if player.infraredCount("Kicker") > 5 then
			return "getballkicker2"
		end
	end,
	Assister = task.stop(),
	Kicker = task.Getballv4("Kicker",pos_self("Kicker")),
	Tier = task.stop(),
	match = "{AKT}"
},




["getballkicker2"] = {
	switch = function()
		if player.infraredCount("Kicker") > 5 then
			return "passballtotier"
		end
	end,
	Assister = task.stop(),
	Kicker = task.GetBallV2("Kicker",pos_self("Tier"),200,500),
	Tier = task.goCmuRush(pos_self("Tier"),dir_self("Tier","Kicker")),
	match = "{AKT}"
},



["passballtotier"] = {
	switch = function()
		if player.kickBall("Kicker") then
			return "getballTier1"
		end
	end,
	Assister = task.stop(),
	Kicker = task.shoot(ball.pos(),dir_self("Kicker","Tier"),_,5000),
	Tier = task.goCmuRush(pos_self("Tier"),dir_self("Tier","Kicker")),
	match = "{AKT}"
},





["getballTier1"] = {
	switch = function()
		if player.infraredCount("Tier") > 5 then
			return "getballTier2"
		end
	end,
	Assister = task.stop(),
	Kicker = task.stop(),
	Tier = task.Getballv4("Tier",pos_self("Tier")),
	match = "{AKT}"
},




["getballTier2"] = {
	switch = function()
		if player.infraredCount("Tier") > 5 then
			return "passballtoassister"
		end
	end,
	Assister = task.stop(),
	Kicker = task.GetBallV2("Kicker",pos_self("Tier"),200,500),
	Tier = task.goCmuRush(pos_self("Tier"),dir_self("Tier","Kicker")),
	match = "{AKT}"
},



name = "eee",
applicable ={
	exp = "a",
	a = true
},
attribute = "attack",
timeout = 99999
}
