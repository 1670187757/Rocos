# 湖州师范学院浙江省机器人比赛ROCOS小型组
工程日志

-----------------------------------------------2023 0410-----------------------------------------------
    在task里面写了 GetPlayerAndEnemyValid() 和 一半的 Confidence_pass(role)
    GetPlayerAndEnemyValid() 可以获取场上存在的机器人 并将他们储存在player_valid = {} enemy_valid = {} 中 只要在 state switch中调用即可
    Confidence_pass(role) 对于传球的置信度计算 但只写了一半 还有好多影响因子没有写进去

-----------------------------------------------2023 0411-----------------------------------------------
    抄袭player.canflatpass() 在task写了一个 between_dotV2(dot1,dot2,r) 效果很好 解决了 之前版本卡顿的问题
    Confidence_pass(role) 加了一些影响因子 

-----------------------------------------------2023 0414-----------------------------------------------
    优化了 grade_dir_goal 让其更合理 准备开始写Confidence_shoot了
