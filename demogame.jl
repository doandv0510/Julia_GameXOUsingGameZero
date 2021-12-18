HEIGHT = 600
WIDTH = 1000
# 
const COLORWILDSAND = colorant"#f7f7f7"
const COLORBLACK = colorant"black"
const COLORGRAY = colorant"gray"
BACKGROUND = COLORWILDSAND

board_ = fill(0,3,3)  # 3x3 matrix of the isRunning_ of each tile
isRunning_ = false  
isReset_ = false  
playerOne_ = true
isHuman_ = false
scorePlayerOne_ = 0
scorePlayerTwo_ = 0

check_ = Actor("close.png")
check_.pos = (785,155)
txtWin_ = Actor("who_winner.png")
btnPlay_ = Actor("play.png")

# vẽ các phần tử lên form game
function draw()
    if isRunning_ == false
        fill(COLORGRAY)
        # restart game
        if isReset_ == true
            global playerOne_ = true
            Winner("who_winner")
            for i in 1:3
                for j in 1:3
                    board_[i, j] = 0
                    if board_[i, j] == 1
                        cancel = Actor("cancel.png", 0, 1200)
                        draw(cancel)
                    elseif board_[i, j] == -1
                        circle = Actor("circle.png", 0, 1200)
                        draw(circle)
                    end
                end
            end
        end
    else
        fill(COLORWILDSAND)
    end
    # draw matrix 3x3
    draw(Line(200, 0, 200, 600), COLORBLACK)
    draw(Line(400, 0, 400, 600), COLORBLACK)
    draw(Line(0, 200, 600, 200), COLORBLACK)
    draw(Line(0, 400, 600, 400), COLORBLACK)
    draw(Line(600, 0, 600, 600), COLORBLACK)
    # draw name game
    logo = Actor("logo.png")
    logo.center = (800, 50)
    draw(logo)
    # draw button play game
    btnPlay_.pos = (620, 100)
    draw(btnPlay_)
    # draw i'm human
    txtImAHuman = Actor("iam_human.png")
    txtImAHuman.pos = (620, 150)
    draw(txtImAHuman)

    # score 
    txtNamePlay1_ = TextActor("Score One: $scorePlayerOne_", "calibrib"; font_size=30, color = Int[0,0,0,0])
    txtNamePlay2_ = TextActor("Score Two: $scorePlayerTwo_", "calibrib"; font_size=30, color = Int[0,0,0,0])
    txtNamePlay1_.pos = (620,200)
    txtNamePlay2_.pos = (620,250)
    draw(txtNamePlay1_)
    draw(txtNamePlay2_)
    #draw text who is the winner?
    txtWin_.center = (800, 500)
    draw(txtWin_)
    # draw Human or Ai
    draw(Rect(780, 150, 40, 40), COLORBLACK)
    # draw close or check a human
    draw(check_)
    # draw x or o
    for i in 1:3
        for j in 1:3
            if board_[i, j] == 1
                cancel = Actor("cancel.png")
                cancel.center = (200j - 100, 200i - 100)
                draw(cancel)
            elseif board_[i, j] == -1
                circle = Actor("circle.png")
                circle.center = (200j - 100, 200i - 100)
                draw(circle)
            end
        end
    end
end

function on_mouse_down(object,MouseButtonEventArgs)
    xPosOfMouse = MouseButtonEventArgs[1]
    yPosOfMouse = MouseButtonEventArgs[2]
    # position check a human
    if 770 <= xPosOfMouse && xPosOfMouse <= 810 && 150 <= yPosOfMouse && yPosOfMouse <= 200
        if isHuman_ == false
            global isHuman_ = true
            global check_ = Actor("check.png")
            check_.pos = (785,160)
        else
            global isHuman_ = false
            global check_ = Actor("close.png")
            check_.pos = (785,155)
        end
    end
    # position btn Play
    if 620 <= xPosOfMouse && xPosOfMouse < 720 && 100 <= yPosOfMouse && yPosOfMouse <= 150
        if isRunning_ == false
            global isRunning_ = true
            DrawButton("play", 620, 100) 
        elseif isReset_ == true && isRunning_ == false
            global isReset_ = true
        elseif isRunning_ == true
            global isRunning_ = false 
            DrawButton("play", 620, 100) 
        end
    end
    # play game
    if isRunning_
        if 0 <= xPosOfMouse && xPosOfMouse <= 600
            yPosOfActor = xPosOfMouse < 200 ? 1 : ( xPosOfMouse < 400 ? 2 : 3)
            xPosOfActor = yPosOfMouse < 200 ? 1 : ( yPosOfMouse < 400 ? 2 : 3)
            
                if board_[xPosOfActor, yPosOfActor] == 0
                    if playerOne_ == true
                        board_[xPosOfActor, yPosOfActor] = 1
                        if isHuman_ == false
                            RandomAi()
                            # CheckStateGame()
                        end
                    elseif playerOne_ == false 
                        board_[xPosOfActor, yPosOfActor] = -1
                    end
                    global playerOne_ = !playerOne_
                else
                    play_sound("assets_audio_hit.wav")
                    println("Invalid move")
                    global playerOne_ = !playerOne_
                end
            CheckStateGame()
        end
    end
end

function CheckStateGame()
    if all(board_.!=0)
        println("DRAW!")
        # hòa
        Winner("")
    end
    for i in 1:3
        if i == 1
            check = board_[i,i] * board_[i*2,i*2] * board_[i*3,i*3]
            if check == 1 &&  board_[i,i] == board_[i*2,i*2] == board_[i*3,i*3] == 1
                Winner("player1win")
            elseif check == -1 &&  board_[i,i] == board_[i*2,i*2] == board_[i*3,i*3] == -1
                Winner("player2win")                              
            end
        elseif i == 3
            check = board_[1,i] * board_[2,2] * board_[i,1]
            if check == 1 && board_[1,i] == board_[2,2] == board_[i,1] == 1 
                Winner("player1win")
            elseif check == -1 && board_[1,i] == board_[2,2] == board_[i,1] == -1 
                Winner("player2win")   
            end
        end
        if all(board_[i,:].== 1) || all(board_[:,i].== 1)
            Winner("player1win")
        elseif all(board_[i,:].== -1) || all(board_[:,i].== -1)
            Winner("player2win")
        end
    end
end

function RandomAi()
    global playerOne_ = !playerOne_
    indices = findall(x -> x == 0, board_)
    board_[rand(indices)] = -1
end

function DrawButton(nameBnt, xPos, yPos)
    global btnPlay_ = Actor(string(nameBnt ,".png"))
    btnPlay_.pos = (xPos, yPos) 
end

function Winner(namePlayer)
    if namePlayer == "player1win"
        global scorePlayerOne_+=1
    elseif namePlayer == "player2win"
        global scorePlayerTwo_+=1
    end
    DrawButton("restart", 620, 100)
    global txtWin_ = Actor( string(namePlayer,".png"))
    global isRunning_ = false
    global isReset_ = true
end