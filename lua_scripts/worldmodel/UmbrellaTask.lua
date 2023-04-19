module(..., package.seeall)


----------------------------------------------------------------------------------------------------------
-- 500 ~ 250
-- 250 ~ 0
-- 0 ~ -250

goalPos = {
	4500,--更改标记#########################################################################################
	0,
}

function GetGoalPos(num)
	local y = enemy.posY(num)
	if enemy.posY(num) >= 0 then
			goalPos[2] =  y - (y + 500) / 2 --更改标记#########################################################################################
		else
			goalPos[2] =  y + (500 - y) / 2
	end
	return CGeoPoint:new_local(goalPos[1],goalPos[2])
end

function GetDefenseEnemyNum()
	local enemyX
	local enemyY
	local num = 0
	for i=0,param.maxPlayer do--更改标记#########################################################################################
		if(enemy.valid(i)) then 
			enemyX = enemy.posX(i)
			enemyY = enemy.posY(i)
			if enemyX > 3500 and enemyX < 4700 and enemyY > -1000 and enemyY < 1000 then
				return i
			end
		end
	end
	return num
end

-------------------------------------------------------算法工具-----------------------------------------------------------
function dotEnemyDistance(dotx,doty,num) --求xy 到某球员的距离
	return math.sqrt((dotx - enemy.posX(num))^2 + (doty - enemy.posY(num))^2)
end

function slope_local(x,y,x1,y1) --求两坐标之间的斜率
	local k = 0
	k =  (x - x1) / (y - y1) 
	return math.abs(math.atan(k) * 57.3)
end
-------------------------------------------------------算法工具-----------------------------------------------------------


--------------------------得分函数---------------------------------------

function grade_pass(x,y)
	if between_dot(CGeoPoint:new_local(x,y),ball.pos()) == 1 then
		return 0
	else 
		return -99999
	end
end
function grade_goal(dotx,doty)  --球门 与坐标点 得分函数 归一化
	return 1400 / math.sqrt((dotx - goalPos[1])^2 + (doty - goalPos[2])^2)
end

function grade_enemy(x,y)   --敌人位置 与坐标点 得分函数  归一化
	local grade = 0
	enemy_dis = {}
	enemy_min = 0
	enemy_grade = 0
	local j = 1
	for i = 0,param.maxPlayer do
		if enemy.valid(i) then
			enemy_dis[j] = dotEnemyDistance(x,y,i)
			j = j + 1
		end
	end 
	local enemy_min = math.max(unpack(enemy_dis))
	for i = 1,#enemy_dis do 
		if enemy_dis[i] == enemy_min then
			enemy_dis[i] = 0
		end
		enemy_grade = enemy_grade + 20 * enemy_dis[i]
	end
	enemy_grade = enemy_grade + 0.8 * enemy_min 

	return enemy_grade / 5100 / 20
end







function grade_ball(x,y) -- 球位置 得分函数 归一化
	local ballX = ball.posX()
	local ballY = ball.posY()
	return 1 - math.sqrt((x - ballX)^2 + (y - ballY)^2) / 10816
end

function grade_dir_goal(x,y)
	return math.sin(slope_local(x,y,goalPos[1],goalPos[2]) / 90 * math.pi)
end

function grade_Mydis(role,x,y)
	local p = player.pos(role)
	local px = p:x()
	local py = p:y()
	return 1 - math.sin( math.sqrt( (px - x)^2 + (py - y)^2) / 1000 / 2)
end
function grade_enemyV2(x,y)   --敌人位置 与坐标点 得分函数  归一化
	local grade = 0
	enemy_dis = {}
	enemy_min = 0
	enemy_grade = 0
	local j = 0
	for i = 0,param.maxPlayer do
		if enemy.valid(i) then
			enemy_dis[j + 1] = dotEnemyDistance(x,y,i)
			j = j + 1
		end
	end 

	for i = 1,#enemy_dis do 
		enemy_grade = enemy_grade + enemy_dis[i]
	end

	return enemy_grade / 9800
end

function grade_enemyV3(x,y,r)   --检测该点附近有无敌人 有则直接Pass
	local grade = 0
	enemy_dis = {}
	enemy_min = 0
	enemy_grade = 0
	local j = 0
	for i = 0,param.maxPlayer do
		if enemy.valid(i) then
			enemy_dis[j + 1] = dotEnemyDistance(x,y,i)
			j = j + 1
		end
	end 

	for i = 1,#enemy_dis do
		if enemy_dis[i] < r then  
			return -999
		end
	end
	return 0
end
--------------------------得分函数---------------------------------------
function between_dot1(dot1,dot2)
    local ipos1 = dot1
  	if type(dot1) == 'function' then
  		ipos1 = dot1()
  	else
  		ipos1 = dot1
  	end
    local ipos2 = dot2
  	if type(dot2) == 'function' then
  		ipos2 = dot2()
  	else
  		ipos2 = dot2
  	end

	local enemypos = {
		enemy.pos(0),
		enemy.pos(1),
		enemy.pos(2),
		enemy.pos(3),
		enemy.pos(4),
		enemy.pos(5),
	}
	if(math.abs(ipos1:x() - ipos2:x()) >= 300) then
	  	if(ipos1:x() > ipos2:x()) then
  			if type(dot1) == 'function' then
  				ipos2 = dot1()
  			else
  				ipos2 = dot1
 	 		end
 	 		if type(dot2) == 'function' then
 	 			ipos1 = dot2()
	 	 	else
 	 			ipos1 = dot2
 	 		end
  		end
		for x = ipos1:x() , ipos2:x() , robot_R do
			y = ((x - ipos1:x()) * (ipos2:y() - ipos1:y())) / (ipos2:x() - ipos1:x()) + ipos1:y()
			robot_R = 50
			debugEngine:gui_debug_x(CGeoPoint:new_local(x, y),3)
			debugEngine:gui_debug_msg(CGeoPoint:new_local(0, 0),"X遍历",3)
			for i = 1,6 do
				if(enemypos[i]:x() > x - enemy_R and enemypos[i]:x() < x + enemy_R and enemypos[i]:y() > y - enemy_R and enemypos[i]:y() < y + enemy_R) then
					debugEngine:gui_debug_msg(CGeoPoint:new_local(0, -500),"有人",3)
					return 0
				else
					flag = 1
				end
			end
		end
	else
	  	if(ipos1:y() > ipos2:y()) then
  			if type(dot1) == 'function' then
  				ipos2 = dot1()
  			else
  				ipos2 = dot1
 	 		end
 	 		if type(dot2) == 'function' then
 	 			ipos1 = dot2()
	 	 	else
 	 			ipos1 = dot2
 	 		end
  		end
		for y = ipos1:y() , ipos2:y() , robot_R do
			x = (y - ipos1:y()) / (ipos2:y() - ipos1:y()) * (ipos2:x() - ipos1:x()) + ipos1:x()
			robot_R = 50
			debugEngine:gui_debug_x(CGeoPoint:new_local(x, y),3)
			debugEngine:gui_debug_msg(CGeoPoint:new_local(0, 0),"Y遍历",3)
			for i = 1,6 do
				if(enemypos[i]:x() > x - enemy_R and enemypos[i]:x() < x + enemy_R and enemypos[i]:y() > y - enemy_R and enemypos[i]:y() < y + enemy_R) then
					debugEngine:gui_debug_msg(CGeoPoint:new_local(0, -500),"有人",3)
					return 0
			else
				flag = 1
			end
			end
		end

	end
	debugEngine:gui_debug_msg(CGeoPoint:new_local(0, -500),"无人",3)
	return 1
end








count = 0
position_up = CGeoPoint:new_local(0, 0)
position_down = CGeoPoint:new_local(0, 0)
function GetShootdot_down()
	return position_down
end
function GetShootPoint_Debug_down()
	local max_X = 0
	local max_Y = 0
	local grade = 1
	local grade_last = 0
	local GradeMax = 0
	local GradeEnemy = 0
	local GradeBall = 0
	local GradeGoal = 0
	local GradeDir = 0

	for x=1500,4200,300 do--更改标记#########################################################################################
		for y=-2700,2700,300 do--更改标记#########################################################################################
			grade = grade_enemy(x,y) * 60 + grade_goal(x,y) * 10 + grade_dir_goal(x,y) * 30 + grade_pass(x,y,passer)
			grade = grade / 100
			if(x > 2500 and y < 1500 and y > -1500) then --更改标记#########################################################################################
				grade = 0
			end
			if(grade < 0) then 
				grade = 0
			end
			if(grade > 0) then
				--debugEngine:gui_debug_msg(CGeoPoint:new_local(x,y),string.format ("%.2f",grade_dir_goal(x,y)),1)
				debugEngine:gui_debug_x(CGeoPoint:new_local(x, y),1)
			end

			if(grade > grade_last) then
				if(grade > GradeMax) then
					max_X = x
					max_Y = y
					GradeMax = grade
					GradeEnemy = grade_enemy(x,y)
					GradeGoal = grade_goal(x,y)
					GradeDir =  grade_dir_goal(x,y)
				end
			end
			grade_last = grade
		end
	end
	between_dot1(CGeoPoint:new_local(max_X, max_Y),CGeoPoint:new_local(goalPos[1], goalPos[2]))
	debugEngine:gui_debug_x(CGeoPoint:new_local(max_X, max_Y),1)
	debugEngine:gui_debug_arc(CGeoPoint:new_local(max_X, max_Y), 300, 0,360,1)
	debugEngine:gui_debug_msg(CGeoPoint:new_local(-4000, 0),"GradeMax: "..GradeMax,1)
	debugEngine:gui_debug_msg(CGeoPoint:new_local(-4000, -500),"GradeGoal: "..GradeGoal,1)
	debugEngine:gui_debug_msg(CGeoPoint:new_local(-4000, -1000),"GradeEnemy: "..GradeEnemy,1)
	debugEngine:gui_debug_msg(CGeoPoint:new_local(-4000, -1500),"GradeBall: "..GradeBall,1)
	debugEngine:gui_debug_msg(CGeoPoint:new_local(-4000, -2000),"GradeDir: "..GradeDir,1)
	debugEngine:gui_debug_msg(CGeoPoint:new_local(goalPos[1],goalPos[2]),goalPos[2],1)
	debugEngine:gui_debug_msg(CGeoPoint:new_local(-4000,-2500),"X: "..max_X.."   Y: "..max_Y,1)
	count = count + 1
	position_down = CGeoPoint:new_local(max_X, max_Y)
end