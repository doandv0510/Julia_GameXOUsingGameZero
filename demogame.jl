HEIGHT = 600
WIDTH = 1000
COLORWILDSAND = colorant"#f7f7f7"
COLORBLACK = colorant"black"
COLORGRAY = colorant"gray"
BACKGROUND = COLORWILDSAND

board_ = fill(0,3,3)  # 3x3 matrix of the isRunning_ of each tile
isRunning_ = false  
playerOne_ = true
isHuman_ = false


check_ = Actor("close.png")
check_.pos = (785,155)
txtWin_ = Actor("who_winner.png")
btnPlay_ = Actor("play.png")
function draw()
    if isRunning_ == false
        fill(COLORGRAY)
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
    #draw text who is the winner?
    txtWin_.center = (800, 500)
    draw(txtWin_)
    # draw Human or Ai
    draw(Rect(780, 150,40,40), COLORBLACK)
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

function on_mouse_down(g,pos)
    xPosOfMouse = pos[1]
    yPosOfMouse = pos[2]
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
    if 620 <= xPosOfMouse && xPosOfMouse <720 && 100 <= yPosOfMouse && yPosOfMouse <= 150
        if isRunning_ == false
            global isRunning_ = true
            global btnPlay_ = Actor("pause.png")
            btnPlay_.pos = (620, 100)
        else 
            global isRunning_ = false
            global btnPlay_ = Actor("play.png")
            btnPlay_.pos = (620, 100)   
        end
    end
    if isRunning_
        if 0 <= xPosOfMouse && xPosOfMouse <= 600
            yPosOfActor = xPosOfMouse < 200 ? 1 : ( xPosOfMouse < 400 ? 2 : 3)
            xPosOfActor = yPosOfMouse < 200 ? 1 : ( yPosOfMouse < 400 ? 2 : 3)
            
                if board_[xPosOfActor, yPosOfActor] == 0
                    if playerOne_ == true
                        board_[xPosOfActor, yPosOfActor] = 1
                        if isHuman_ == false
                            random_ai()
                        end
                    elseif playerOne_ == false 
                        board_[xPosOfActor, yPosOfActor] = -1
                    end
                    global playerOne_ = !playerOne_
                else
                    println("Invalid move")
                    play_sound("assets_audio_hit.wav")
                    global playerOne_ = !playerOne_
                end
            game_over()
        end
    end
end

function game_over()
    if all(board_.!=0)
        println("DRAW!")
        global isRunning_ = false
    end

    for i in 1:3
        if all(board_[i,:].== 1) || all(board_[:,i].== 1)
            global txtWin_ = Actor("player1win.png")
            txtWin_.pos = (620, 100)
            global isRunning_ = false
        elseif all(board_[i,:].== -1) || all(board_[:,i].== -1)
            global txtWin_ = Actor("player2win.png")
            txtWin_.pos = (620, 100)
            global isRunning_ = false
        end
    end
end

function random_ai()
    indices = findall(x -> x == 0, board_)
    board_[rand(indices)] = -1
    global playerOne_ = !playerOne_
end