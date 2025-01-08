.model small
.stack 128
.data
       snakeHead      dw 0
       snakeBody      dw 1001 dup (0)                                                                                ; 蛇身体坐标数据
       body           db 0dbh                                                                                        ; 身体图案
       snakeColor     db 08h                                                                                         ; 身体颜色
       snakeHead2     dw 0
       snakeBody2     dw 1001 dup (0)                                                                                ; 蛇身体坐标数据
       body2          db 0dbh                                                                                        ; 身体图案
       snakeColor2    db 02h                                                                                         ; 身体颜色
       food           dw 3 dup(0)                                                                                    ; 食物坐标位置
       foodColor      db 04h                                                                                         ; 食物颜色存
       oldint9        dw 2 dup (0)                                                                                   ; 原来 int9 中断地址暂
       gameStatus     db 4                                                                                           ; 状态：0 游戏中 1 退出 2 暂停 3 游戏失败 4 准备
       initTarget     db 'R'                                                                                         ; 初始方向
       initTarget2    db 'L'
       target         db 'R'                                                                                         ; 方向
       target2        db 'L'
       speed          dw 02h                                                                                         ; 速度
       speed2         dw 02h
       initLen        dw 4                                                                                           ; 初始长度
       len            dw 4                                                                                           ; 长度
       len2           dw 4
       score          dw 0                                                                                           ; 得分
       score2         dw 0
       gameoverStr    db "GAME OVER!", 0                                                                             ; 游戏结束提示
       gamewinnerStr  db "Player 1 Wins!", 0
       gamewinner2Str db "Player 2 Wins!", 0
       scoreStr       db "Player 1 Score: ", 0                                                                       ; 游戏得分提示
       scoreStr2      db "Player 2 Score: ", 0
       tempBuff       db 5 dup(0)
       restartStr     db "Press the R key to restart!", 0                                                            ; 重玩提示
       seed           dw 1998h                                                                                       ; 种子
       seed2          dw 0314h                                                                                       ; 种子
       winner         db 0                                                                                           ; 赢家
       startStr       db "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"          ; 开始提示信息
                      db "@                                                                              @"
                      db "@                                                                              @"
                      db "@                                                                              @"
                      db "@                          Welcome to Snake Game!                              @"
                      db "@                                                                              @"
                      db "@              _______                                   _______    TM         @"
                      db "@             |           |\     |      /\      |    /  |                      @"
                      db "@             |           | \    |     /  \     |  /    |                      @"
                      db "@             |_______    |  \   |    /____\    |/      |_______               @"
                      db "@                     |   |   \  |   /      \   |\      |                      @"
                      db "@                     |   |    \ |  /        \  |  \    |                      @"
                      db "@              _______|   |     \| /          \ |    \  |_______               @"
                      db "@                                                                              @"
                      db "@                                                                              @"
                      db "@                                                                              @"
                      db "@                               Instruction:                                   @"
                      db "@                                                                              @"
                      db "@          Player 1                                       Player 2             @"
                      db "@                                                                              @"
                      db "@             w              P       Pause                   UP                @"
                      db "@                            R       Restart                                   @"
                      db "@         A   S   D      BACKSPACE   Main Menu       LEFT   DOWN     RIGHT     @"
                      db "@                            ESC     Exit                                      @"
                      db "@                                                                              @"
                      db "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@", 0
.code
       start:         
                      mov   ax, @data
                      mov   ds, ax

          
       ; 安装 int9 中断按键服务
                      call  instKey

       pre_start:     
       ; 清屏
                      call  clearDis
       ; 准备界面
                      call  readly
                           
       readly_s1:     
                      cmp   gameStatus[0], 4
                      je    readly_s1
       ; 初始化程序
                      call  init
       s:                                                              ; 运动
                      call  run
       ; call delay
       ; 游戏暂停
       suspend:       cmp   gameStatus[0], 2
                      je    suspend

       ; 游戏失败
       game_fail:     cmp   gameStatus[0], 3
                      je    game_fail

                      cmp   gameStatus[0], 4
                      je    pre_start

       ; 游戏正常循环
                      cmp   gameStatus[0], 0
                      je    s


       ; 复原之前 int9 的中断程序
                      call  unKey

                      mov   ax, 4c00h
                      int   21h



       ; 显示单个字符函数
       ; @ dh 行
       ; @ dl 列
       ; @ ch 颜色
       ; @ cl 内容
       display1:      push  es
                      push  di
                      push  ax

                      mov   ax, 0b800h
                      mov   es, ax
                      mov   di, 0

                      mov   al, 160
                      mul   dh
                      add   di, ax

                      mov   al, 2
                      mul   dl
                      add   di, ax

                      mov   word ptr es:[di], cx

                      pop   ax
                      pop   di
                      pop   es
                      ret

       ; 显示单个方块函数
       ; @ dh 行
       ; @ dl 列
       display2:      
                      push  es
                      push  di
                      push  ax
                      push  ds

                      mov   ax, @data
                      mov   ds, ax

                      mov   ax, 0b800h
                      mov   es, ax
                      mov   di, 0

                      mov   al, 160
                      mul   dh
                      add   di, ax

                      mov   al, 4
                      mul   dl
                      add   di, ax

                      mov   word ptr es:[di], cx
                      mov   word ptr es:[di + 2], cx

                      pop   ds
                      pop   ax
                      pop   di
                      pop   es
                      ret

       

       ; 游戏准备界面
       readly:        push  es
                      push  di
                      push  ax
                      push  ds
                      push  cx
                      push  bx

                      mov   ax, @data
                      mov   ds, ax

                      mov   ax, 0b800h
                      mov   es, ax
                      mov   di, 0

                      mov   bx, 0
                      mov   ch, 0
       red_s1:        mov   cl, startStr[bx]
                      jcxz  red_end
                      mov   byte ptr es:[di], cl
                      mov   byte ptr es:[di + 1], 1eh
                      inc   bx
                      add   di, 2
                      jmp   red_s1

       red_end:       pop   bx
                      pop   cx
                      pop   ds
                      pop   ax
                      pop   di
                      pop   es
                      ret

       ; 游戏结束
       dis_g_o:       push  es
                      push  di
                      push  ax
                      push  ds
                      push  cx
                      push  bx
                      push  dx

                      mov   ax, @data
                      mov   ds, ax

                      mov   gameStatus[0], 3

                      mov   ax, 0b800h
                      mov   es, ax
                      mov   di, 10 * 160 + 60
       

       ; GAME OVER!
                      mov   dl, winner
                      mov   bx, 0
                      mov   ch, 0

                      
                      cmp   dl, 1
                      jne   winner_s2_con
       winner_s1:     mov   cl, gamewinnerStr[bx]
                      jmp   dis_s1
       winner_s2_con: 
                      cmp   dl, 2
                      jne   gameover
       winner_s2:     
                      mov   cl, gamewinner2Str[bx]
                      jmp   dis_s1
       gameover:      
                      mov   cl, gameoverStr[bx]
       dis_s1:        
                      jcxz  dis_scord
                      mov   byte ptr es:[di], cl
                      mov   byte ptr es:[di + 1], 82h
                      inc   bx
                      add   di, 2
                      cmp   dl, 1
                      je    winner_s1
                      cmp   dl, 2
                      je    winner_s2
                      jmp   gameover

       ; SCORE
       dis_scord:     
                      mov   di, 12*160 + 50
                      mov   bx, 0
                      mov   ch, 0
       dis_s2:        mov   cl, scoreStr[bx]
                      jcxz  dis_scord2
                      mov   byte ptr es:[di ], cl
                      mov   byte ptr es:[di + 1], 82h
                      inc   bx
                      add   di, 2
                      jmp   dis_s2

       dis_scord2:    mov   di, 14*160 + 50
                      mov   bx, 0
                      mov   ch, 0
       dis_s22:       mov   cl, scoreStr2[bx]
                      jcxz  dis_press
                      mov   byte ptr es:[di], cl
                      mov   byte ptr es:[di + 1], 82h
                      inc   bx
                      add   di, 2
                      jmp   dis_s22

       ; Press the R key to restart
       dis_press:     mov   di, 16*160 + 50
                      mov   bx, 0
                      mov   ch, 0
       dis_s3:        mov   cl, restartStr[bx]
                      jcxz  dis_nu
                      mov   byte ptr es:[di], cl
                      mov   byte ptr es:[di + 1], 82h
                      inc   bx
                      add   di, 2
                      jmp   dis_s3

       dis_nu:        
                      mov   di, 10*160 + 170                           ; 显示得分
                      mov   ax, score[0]
       dis_nu1:       mov   bl, 10
                      div   bl

                      cmp   ax, 0
                      je    dis_nu2
                      add   ah, 48
                      mov   byte ptr es:[di + 292 + 8 - 54], ah
                      mov   byte ptr es:[di + 293 + 8 - 54], 84h

                      mov   ah, 0
                      sub   di, 2
          
                      jmp   dis_nu1
       dis_nu2:       
                      mov   di, 12*160 + 170                           ; 显示得分
                      mov   ax, score2[0]
       dis_nu12:      mov   bl, 10
                      div   bl

                      cmp   ax, 0
                      je    dis_end
                      add   ah, 48
                      mov   byte ptr es:[di + 292 + 8 - 54], ah
                      mov   byte ptr es:[di + 293 + 8 - 54], 84h

                      mov   ah, 0
                      sub   di, 2
          
                      jmp   dis_nu12

       dis_end:       pop   dx
                      pop   bx
                      pop   cx
                      pop   ds
                      pop   ax
                      pop   di
                      pop   es
                      ret

       ; 重置游戏
       restart:       push  ax
                      push  ds

                      mov   ax, @data
                      mov   ds, ax

       ; 清屏
                      call  clearDis

       ; 速度复原
                      mov   speed[0], 1h
                      mov   speed2[0], 1h

       ; 积分清空
                      mov   score[0], 0
                      mov   score2[0], 0

       ; 初始化方向
                      mov   al, initTarget[0]
                      mov   target[0], al
                      mov   al, initTarget2[0]
                      mov   target2[0], al

       ; 蛇长度初始化
                      mov   ax, initLen[0]
                      mov   len[0], ax
                      mov   ax, initLen[0]
                      mov   len2[0], ax

       ; 调用初始化函数
                      call  init

                      pop   ds
                      pop   ax
                      retf

       ; 显示完整蛇身体
       disAll:        push  ax
                      push  ds
                      push  bx
                      push  cx

                      mov   ax, @data
                      mov   ds, ax

                      mov   bx, 0
                      mov   cx, len[0]
       all_s:         mov   dx, snakeBody[bx]
                      push  cx
                      mov   ch, snakeColor[0]
                      mov   cl, body[0]
                      call  display2
                      pop   cx
                      add   bx, 2
                      loop  all_s

                      mov   bx, 0
                      mov   cx, len2[0]
       all_s2:        mov   dx, snakeBody2[bx]
                      push  cx
                      mov   ch, snakeColor2[0]
                      mov   cl, body2[0]
                      call  display2
                      pop   cx
                      add   bx, 2
                      loop  all_s2

                      push  es
                      mov   ax, 0b800h
                      mov   es, ax
                      mov   di, 0
       dis_score:     
                      mov   bx, 0
                      mov   ch, 0
       dis_score_s2:  
                      mov   cl, scoreStr[bx]
                      jcxz  disall_nu
                      mov   byte ptr es:[di], cl
                      mov   byte ptr es:[di + 1], 0eh
                      inc   bx
                      add   di, 2
                      jmp   dis_score_s2
       disall_nu:                                                      ; 显示得分
                      mov   di, 40
                      mov   ax, score[0]
       disall_nu1:    mov   bl, 10
                      div   bl

                      cmp   ax, 0
                      je    dis_score2
                      add   ah, 48
                      mov   byte ptr es:[di], ah
                      mov   byte ptr es:[di + 1], 0eh

                      mov   ah, 0
                      sub   di, 2
          
                      jmp   disall_nu1
       dis_score2:    
                      mov   di, 90
                      mov   bx, 0
                      mov   ch, 0
       dis_score2_s2: 
                      mov   cl, scoreStr2[bx]
                      jcxz  disall_nu2
                      mov   byte ptr es:[di], cl
                      mov   byte ptr es:[di + 1], 0eh
                      inc   bx
                      add   di, 2
                      jmp   dis_score2_s2
       disall_nu2:                                                     ; 显示得分
                      mov   di, 130
                      mov   ax, score2[0]
       disall_nu12:   mov   bl, 10
                      div   bl

                      cmp   ax, 0
                      je    disall_end
                      add   ah, 48
                      mov   byte ptr es:[di], ah
                      mov   byte ptr es:[di + 1], 0eh

                      mov   ah, 0
                      sub   di, 2
          
                      jmp   disall_nu12
       disall_end:    
                      pop   es
                      pop   cx
                      pop   bx
                      pop   ds
                      pop   ax
                      ret


       ; 消除位移之后，尾部最后一个方块
       clearend:      push  ax
                      push  ds
                      push  dx
                      push  cx
                      push  bx
          
                      mov   ax, @data
                      mov   ds, ax

                      mov   bx, len[0]
                      add   bx, bx
                      mov   dx, snakeBody[bx]
                      mov   cx, 0
                      call  display2

                      mov   bx, len2[0]
                      add   bx, bx
                      mov   dx, snakeBody2[bx]
                      mov   cx, 0
                      call  display2

                      pop   bx
                      pop   cx
                      pop   dx
                      pop   ds
                      pop   ax
                      ret

       ; 安装中断按键程序
       instKey:       push  ax
                      push  ds
                      push  si
                      push  es
                      push  di
                      push  cx

                      mov   ax, @data
                      mov   ds, ax

                      mov   ax, 0
                      mov   es, ax

                      push  es:[9 * 4]
                      pop   oldint9[0]
                      push  es:[9 * 4 + 2]
                      pop   oldint9[2]

                      mov   ax, seg do0
                      mov   ds, ax
                      mov   si, offset do0

                      mov   ax, 0
                      mov   es, ax
                      mov   di, 200h

                      mov   cx, offset do0end - offset do0
                      cld
                      rep   movsb

                      mov   word ptr es:[9 * 4], 200h
                      mov   word ptr es:[9 * 4 + 2], 0

                      pop   cx
                      pop   di
                      pop   es
                      pop   si
                      pop   ds
                      pop   ax
                      ret

       ; 恢复之前 int9 程序指向
       unKey:         push  ax
                      push  es

                      mov   ax, @data
                      mov   ds, ax

                      mov   ax, 0
                      mov   es, ax

                      push  oldint9[0]
                      pop   es:[4 * 9]
                      push  oldint9[2]
                      pop   es:[4 * 9 + 2]

                      pop   es
                      pop   ax
                      ret

       ; 初始化
       init:                                                           ; 设置初始蛇的身体数据
                      call  set_ibd
       ; 显示蛇的身体
                      call  disAll
       ; 随机生成食物
                      call  random

                      ret

       ; 设置初始蛇的身体数据
       set_ibd:       push  ax
                      push  ds
                      push  dx
                      push  bx
                      push  cx

                      mov   ax, @data
                      mov   ds, ax

                      mov   dh, 12
                      mov   dl, 6
                      mov   bx, 0
                      add   dl, byte ptr len[1]
                      mov   cx, len[0]
       ibd_s0:        mov   snakeBody[bx], dx
                      dec   dl
                      add   bx, 2
                      loop  ibd_s0

                      mov   dh, 12
                      mov   dl, 30
                      mov   bx, 0
                      add   dl, byte ptr len2[1]
                      mov   cx, len2[0]
       ibd_s02:       
                      mov   snakeBody2[bx], dx
                      inc   dl
                      add   bx, 2
                      loop  ibd_s02
                      pop   cx
                      pop   bx
                      pop   dx
                      pop   ds
                      pop   ax
                      ret

       ; 运动
       run:           push  ax
                      push  ds
                      push  dx
                      push  cx
          
                      mov   ax, @data
                      mov   ds, ax

                      mov   dx, snakeBody[0]

                      cmp   target[0], 'U'
                      jne   run_D
                      dec   dh
                      jmp   run_U2
          
       run_D:         cmp   target[0], 'D'
                      jne   run_L
                      inc   dh
                      jmp   run_U2

       run_L:         cmp   target[0], 'L'
                      jne   run_R
                      dec   dl
                      jmp   run_U2

       run_R:         cmp   target[0], 'R'
                      jne   run_U2
                      inc   dl
       run_U2:        
                      mov   snakeHead, dx
                      mov   dx, snakeBody2[0]
                      cmp   target2[0], 'U'
                      jne   run_D2
                      dec   dh
                      jmp   run_dis
          
       run_D2:        cmp   target2[0], 'D'
                      jne   run_L2
                      inc   dh
                      jmp   run_dis

       run_L2:        cmp   target2[0], 'L'
                      jne   run_R2
                      dec   dl
                      jmp   run_dis

       run_R2:        cmp   target2[0], 'R'
                      inc   dl
       run_dis:       
                      mov   snakeHead2, dx                             ; 运动
                      call  move
       ; 显示全部身体
                      call  disAll
                      call  check
       ; 判断是否游戏结束
                      cmp   gameStatus[0], 0
                      jne   run_over
          
       ; 显示食物
                      push  si
                      mov   si, 0
       food_dis:      
                      mov   dx, food[si]
                      mov   cl, body[0]
                      mov   ch, foodColor[0]
                      call  display2
                      add   si, 2
                      cmp   si, 6
                      jne   food_dis
                      pop   si
       ; 消除位移之后最后一个尾巴块
                      call  clearend
       ; 延时
                      call  delay

       run_over:      pop   cx
                      pop   dx
                      pop   ds
                      pop   ax
                      ret
       
       ; 蛇身体列表集体向高位位移一个字
       ; dx 新的蛇头的坐标
       ;
       move:          
                      push  ax
                      push  bx
                      push  ds

                      mov   ax, @data
                      mov   ds, ax

                      mov   bx, len[0]
                      add   bx, bx
       move_s:        mov   ax, snakeBody[bx - 2]
                      mov   snakeBody[bx], ax
                      sub   bx, 2
                      cmp   bx, 0
                      jne   move_s

                      mov   dx, snakeHead
                      mov   snakeBody[0], dx

                      mov   bx, len2[0]
                      inc   bx
                      add   bx, bx

       move_s2:       mov   ax, snakeBody2[bx - 2]
                      mov   snakeBody2[bx], ax
                      sub   bx, 2
                      cmp   bx, 0
                      jne   move_s2

                      mov   dx, snakeHead2
                      mov   snakeBody2[0], dx
                      pop   ds
                      pop   bx
                      pop   ax
                      ret

       win_1:         
                      mov   cl, 1
                      mov   winner, cl
                      ret
       win_2:         
                      mov   cl, 2
                      mov   winner, cl
                      ret

       ; 校验是否违规结束 或 吃到食物
       check:         push  ax
                      push  bx
                      push  ds
                      push  cx
                      push  di
                      push  si

                      mov   ax, @data
                      mov   ds, ax

                      mov   ax, snakeBody[0]
                      mov   bx, snakeBody2[0]
       ; 碰撞右侧墙壁
                      cmp   al, 40 - 1
                      ja    g_o
                      cmp   bl, 40 - 1
                      ja    g_o2

       ; 碰撞左侧墙壁
                      cmp   al, 0
                      jb    g_o
                      cmp   bl, 0
                      jb    g_o2

       ; 碰撞上方墙壁
                      cmp   ah, 0
                      jb    g_o
                      cmp   bh, 0
                      jb    g_o2

       ; 碰撞下方墙壁
                      cmp   ah, 25 - 1
                      ja    g_o
                      cmp   bh, 25 - 1
                      ja    g_o2

       ; 蛇和蛇2 碰撞
                      cmp   ax, bx
                      je    g_o3

                      mov   cx, len2[0]
                      dec   cx
                      mov   di, 2
       other_12_s:    
                      cmp   ax, snakeBody2[di]
                      je    g_o
                      add   di, 2
                      loop  other_12_s

                      mov   cx, len[0]
                      dec   cx
                      mov   di, 2
       other_21_s:    
                      cmp   bx, snakeBody[di]
                      je    g_o2
                      add   di, 2
                      loop  other_21_s
       
       ; 咬到自己身体
                      mov   di, 2                                      ; 忽略头部，从第二节身体开始
                      mov   cx, len[0]
                      dec   cx                                         ; 循环计数也需要少算一个头部
       self_1_s:      mov   ax, snakeBody[di]
       ; 碰到了身体
                      cmp   ax, snakeBody[0]
                      je    g_o
       ; 碰到了食物
                      mov   si, 0
       food_touch:    
                      cmp   ax, food[si]
                      je    levelup
                      add   si, 2
                      cmp   si, 6
                      jne   food_touch
                      add   di, 2
                      loop  self_1_s

       self_2_s_ready:
       ; 咬到自己身体
                      mov   di, 2                                      ; 忽略头部，从第二节身体开始
                      mov   cx, len2[0]
                      dec   cx                                         ; 循环计数也需要少算一个头部
       self_2_s:      mov   bx, snakeBody2[di]
       ; 碰到了身体
                      cmp   bx, snakeBody2[0]
                      je    g_o
       ; 碰到了食物
                      mov   si, 0
       food_touch2:   
                      cmp   bx, food[si]
                      je    levelup2
                      add   si, 2
                      cmp   si, 6
                      jne   food_touch2
                      add   di, 2
                      loop  self_2_s

                      jmp   ct_game

       g_o:           
                      call  win_2
                      call  dis_g_o
                      jmp   ct_game
       g_o2:          
                      call  win_1
                      call  dis_g_o
                      jmp   ct_game
       g_o3:          
                      call  dis_g_o
                      jmp   ct_game

       levelup:       inc   len[0]                                     ; 身体长度+1
                      inc   score[0]                                   ; 分数+1
                      cmp   score[0], 9
                      jna   notWin
                      mov   cl, 1
                      mov   winner, cl
                      call  dis_g_o
                      jmp   ct_game
       notWin:        
                      call  random
                      jmp   self_2_s_ready
       ; 生成新的食物
       levelup2:      inc   len2[0]                                    ; 身体长度+1
                      inc   score2[0]                                  ; 分数+1
                      cmp   score2[0], 9
                      jna   notWin2
                      mov   cl, 2
                      mov   winner, cl
                      call  dis_g_o
                      jmp   ct_game
       notWin2:       
                      call  random                                     ; 生成新的食物

       ct_game:       
                      pop   si
                      pop   di
                      pop   cx
                      pop   ds
                      pop   bx
                      pop   ax
                      ret

       

       ; 随机生成蛇的食物
       random:        push  ax
                      push  ds
                      push  cx
                      push  bx
                      push  dx
                      push  di
                      push  si

                      mov   ax, @data
                      mov   ds, ax

                      mov   si, 0
       ; 获取时间秒数，用于生成随机数
       re_create:     mov   al, 0
                      out   70h, al
                      in    al, 71h
                      mov   ah, al
                      add   ax, seed[0]
                      mov   cl, 3
                      shr   ax, cl

                      mov   bx, ax
                      mov   dl, 40
                      div   dl
                      mov   byte ptr food[si], ah

                      mov   ax, bx
                      add   ax, seed2[0]
                      mov   cl, 3
                      shr   ax, cl

                      mov   dl, 25
                      div   dl
                      mov   byte ptr food[si + 1], ah

                      mov   dx, food[si]
          
                      mov   di, 0
                      mov   cx, len[0]
       rd_s:          mov   ax, snakeBody[di]
                      cmp   ax, dx
                      je    re_create
                      add   di, 2
                      loop  rd_s
                      mov   cx, len2[0]
       rd_s2:         mov   ax, snakeBody2[di]
                      cmp   ax, dx
                      je    re_create
                      add   di, 2
                      loop  rd_s2
                      
                      add   si, 2
                      cmp   si, 6
                      jne   re_create

                      pop   si
                      pop   di
                      pop   dx
                      pop   bx
                      pop   cx
                      pop   ds
                      pop   ax
                      ret

       ; 清屏
       clearDis:      push  ax
                      push  es
                      push  di
                      push  cx

                      mov   ax, 0b800h
                      mov   es, ax
                      mov   di, 0

                      mov   cx, 4000
       clr_s:         mov   word ptr es:[di], 0
                      inc   di
                      loop  clr_s

                      pop   cx
                      pop   di
                      pop   es
                      pop   ax
                      ret

       ; 蛇和食物闪烁，暂停
       blbl:          push  ax
                      push  ds
                      push  bx
                      push  cx

                      mov   ax, @data
                      mov   ds, ax

                      mov   bx, 0
                      mov   cx, len[0]
       blbl_s:        mov   dx, snakeBody[bx]
                      push  cx
                      mov   ch, snakeColor[0]
                      mov   cl, body[0]
       ; 蛇身体闪烁
                      or    ch, 10000000b
                      call  display2
                      pop   cx
                      add   bx, 2
                      loop  blbl_s

                      mov   bx, 0
                      mov   cx, len2[0]
       blbl_s2:       mov   dx, snakeBody2[bx]
                      push  cx
                      mov   ch, snakeColor2[0]
                      mov   cl, body2[0]
       ; 蛇身体闪烁
                      or    ch, 10000000b
                      call  display2
                      pop   cx
                      add   bx, 2
                      loop  blbl_s2
          
       ; 食物闪烁
                      mov   dx, food[0]
                      mov   cl, body[0]
                      mov   ch, foodColor[0]
                      or    ch, 10000000b
                      call  display2

                      pop   cx
                      pop   bx
                      pop   ds
                      pop   ax
                      retf

       ; 延迟
       delay:         push  ax
                      push  dx
                      push  ds
          
                      mov   ax, @data
                      mov   ds, ax

                      mov   dx, 01h
                      mov   ax, 0
       s1:            sub   ax, 1
                      sbb   dx, 0
                      cmp   ax, 0
                      jne   s1
                      cmp   dx, 0
                      jne   s1

                      pop   ds
                      pop   dx
                      pop   ax
                      ret

       ; 重写后的按键中断程序
       do0:           push  ax
                      push  bx
                      push  ds
                      push  dx
                      push  cx

                      mov   ax, @data
                      mov   ds, ax

                      in    al, 60h

                      pushf

                      pushf
                      pop   bx
                      and   bh, 11111100b
                      push  bx
                      popf

                      call  dword ptr oldint9[0]

       ; 方向调节
       ; 键盘 W 按下
                      cmp   al, 11h
                      jne   dkn_a
                      cmp   target[0], 'D'
                      je    board_1
                      mov   target[0], 'U'
       board_1:       jmp   do0over
          
       ; 键盘 A 按下
       dkn_a:         cmp   al, 1Eh
                      jne   dkn_s
                      cmp   target[0], 'R'
                      je    board_2
                      mov   target[0], 'L'
       board_2:       jmp   do0over

       ; 键盘 S 按下
       dkn_s:         cmp   al, 1Fh
                      jne   dkn_d
                      cmp   target[0], 'U'
                      je    board_3
                      mov   target[0], 'D'
       board_3:       jmp   do0over

       ; 键盘 D 按下
       dkn_d:         cmp   al, 20h
                      jne   dkn_up
                      cmp   target[0], 'L'
                      je    board_4
                      mov   target[0], 'R'
       board_4:       jmp   do0over
       ; 键盘 ↑ 按下
       dkn_up:        cmp   al, 48h
                      jne   dkn_lf
                      cmp   target2[0], 'D'
                      je    board_5
                      mov   target2[0], 'U'
       board_5:       jmp   do0over
          
       ; 键盘 ← 按下
       dkn_lf:        cmp   al, 4bh
                      jne   dkn_dw
                      cmp   target2[0], 'R'
                      je    board_6
                      mov   target2[0], 'L'
       board_6:       jmp   do0over

       ; 键盘 ↓ 按下
       dkn_dw:        cmp   al, 50h
                      jne   dkn_rg
                      cmp   target2[0], 'U'
                      je    board_7
                      mov   target2[0], 'D'
       board_7:       jmp   do0over

       ; 键盘 → 按下
       dkn_rg:        cmp   al, 4dh
                      jne   dkn_p
                      cmp   target2[0], 'L'
                      je    board_8
                      mov   target2[0], 'R'
       board_8:       jmp   do0over

       ; 键盘 P 按下 游戏暂停
       dkn_p:         cmp   al, 19h
                      jne   dkn_r
                      cmp   gameStatus[0], 0
                      jne   p_ne_1
                      mov   gameStatus[0], 2
       ; 屏幕闪烁
                      call  far ptr blbl
                      jmp   do0over

       p_ne_1:        cmp   gameStatus[0], 2
                      jne   do0over
                      mov   gameStatus[0], 0
                      jmp   do0over
          
       ; 键盘 R 按下
       dkn_r:         cmp   al, 13h
                      jne   dkn_spe
       ; 判断游戏是不是失败状态，只有失败状态这个按键才有效
                      cmp   gameStatus[0], 3
                      jne   do0over
                      call  far ptr restart
                      mov   gameStatus[0], 0
                      jmp   do0over

       ; 键盘 space 按下
       dkn_spe:       cmp   al, 39h
                      jne   dkn_esc
       ; 判断游戏是不是准备状态，只有准备状态这个按键才有效
                      cmp   gameStatus[0], 4
                      jne   do0over
                      call  far ptr restart
                      mov   gameStatus[0], 0
                      jmp   do0over

       ; 键盘 ESC 按下 退出游戏
       dkn_esc:       cmp   al, 01h
                      jne   dkn_backspace
                      mov   gameStatus[0], 1
                      jmp   do0over

       ; 键盘 BACKSPACE 按下 回到主页面
       dkn_backspace: cmp   al, 0eh
                      jne   do0over
                      cmp   gameStatus[0], 2
                      je    backspace
                      cmp   gameStatus[0], 3
                      je    backspace
                      jmp   do0over
       backspace:     
                      mov   gameStatus[0], 4

       do0over:       
                      
                      pop   cx
                      pop   dx
                      pop   ds
                      pop   bx
                      pop   ax
                      iret

       do0end:        nop
end start