# 湖州师范学院ROCOS小型组工程日志


2023 0410

       1. 在task里面写了 GetPlayerAndEnemyValid() 和 一半的 Confidence_pass(role)
       
       2. GetPlayerAndEnemyValid() 可以获取场上存在的机器人 并将他们储存在player_valid = {} enemy_valid = {} 中 只要在 state switch中调用即可
       
       3. Confidence_pass(role) 对于传球的置信度计算 但只写了一半 还有好多影响因子没有写进去
       
       --------Umbrella

2023 0411

       1.抄袭player.canflatpass() 在task写了一个 between_dotV2(dot1,dot2,r) 效果很好 解决了 之前版本卡顿的问题
    
       2.Confidence_pass(role) 加了一些影响因子 
    
       --------Umbrella

2023 0414

       1.优化了 grade_dir_goal 让其更合理 准备开始写Confidence_shoot了
    
       --------Umbrella

2023 0424

       1.优化了GetballV3的旋转方向与旋转朝向 详细如下：
       
       关于旋转朝向问题：
       
       我们在task.ShowTimeV1_ini(role) 里面添加了StartPos and StartPosBall 作为player触摸到球的初始点与球第一次被触摸时的初始位置
       
       因为之前 GetballV3 的player的朝向始终指向球 导致 球的位置偏移后会不断的累积误差，
       
       将(player.pos(role) - ball.pos()):dir() 改成(StartPosBall - player.pos(role)):dir()后效果显著提升！
       
       
       关于旋转方向问题：
       
       之前的GetballV3是无法对最优旋转方向作出判断，不论怎样的情况player只能按着顺或逆时针旋转
       
       我们的解决方法是 (((StartPos - StartPosBall):dir() * 57.3 + 180) - ((StartPos - p1):dir()*57.3 +180)) 当其大于0时 player将会瞬时针旋转 反而之
       
       后面关于GetballV3的问题只剩下调整参数 其他问题待发现    
       
       --------Wuf Zhoujunjie Umbrella
       

2023 0428 ～ 0509

       1.我们发现了 GetballV3的新转向bug并将其解决：
       
       添加了4个条件判断StartPosBall and StartPos 的xy的相对位置作为转向依据
       
       
       2.完成了 PENALTY 进攻与防守脚本的编写 防守攻有待优化
       
       3.为了解决传统goCmuRush近点坐标移动速度过慢的问题，写了一个新的goCmuRushV2将其传入的坐标点为PlayerPos与targetpos的延长线上
       
       4. 我们完成了 进攻时状态置信度函数的编写 [PASS,SHOOT,DRBBLING] 它真的很完美
       
       在ConfidencePass中我们不仅仅考虑了带球者的角度与接球者的角度 、 是否被敌人遮挡 来衡量分数 
       
       甚至还 加入了 
       
              4.1 传球线路的安全性motionLineSafety(pos1,pos2) 他是用 接球点与敌人坐标 还有 接球点与发球点
       
       的比值来确定安全性的  经过测试 相同的球速下 其不同位置的 安全性比值一样时 其安全程度一样的 （后期还可以以球速为系数动态调整安全阈值）
       
              4.2 被传球人的射门概率
       
       
       
