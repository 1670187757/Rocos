# 湖州师范学院ROCOS小型组工程日志


2023 0410

       1. 在task里面写了 GetPlayerAndEnemyValid() 和 一半的 Confidence_pass(role)
       
       2. GetPlayerAndEnemyValid() 可以获取场上存在的机器人 并将他们储存在player_valid = {} enemy_valid = {} 中 只要在 state switch中调用即可
       
       3. Confidence_pass(role) 对于传球的置信度计算 但只写了一半 还有好多影响因子没有写进去

2023 0411

    1.抄袭player.canflatpass() 在task写了一个 between_dotV2(dot1,dot2,r) 效果很好 解决了 之前版本卡顿的问题
    
    2.Confidence_pass(role) 加了一些影响因子 

2023 0414

    1.优化了 grade_dir_goal 让其更合理 准备开始写Confidence_shoot了

2023 0424
       1.优化了GetballV3的旋转方向与旋转朝向 详细如下：
       关于旋转朝向问题：
       
       我们在task.ShowTimeV1_ini(role) 里面添加了StartPos and StartPosBall 作为player触摸到球的初始点与球第一次被触摸时的初始位置
       
       因为之前 GetballV3 的player的朝向始终指向球 导致 球的位置偏移后会不断的累积误差，
       
       将(player.pos(role) - ball.pos()):dir() 改成(StartPosBall - player.pos(role)):dir()后效果显著提升！
