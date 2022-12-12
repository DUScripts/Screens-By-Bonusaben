--[[ Pegged ]]--

if not init then
    init = true
    
    rx, ry = getResolution()
    mx, my = getCursor()
    
    pegs = {}
    balls = {}
    
    cols = 16
    rows = 10
    pegR = 5
    ballR = 25
    numBalls = 25
    grav = 0.35
    bounce = 1.1
    maxSpeed = 5
    
    function CreatePegs()
        for x=1,cols do
            pegs[x] = {}
            for y=1,rows do
                peg = {}
                peg.pos = {rx/cols*(x-(y%2)/2),ry/rows*(y-0.5)}                
                pegs[x][y] = peg
                end
            end
        end
    
    function DrawPegs()
        for x=1,cols do
            for y=1,rows do
                addCircle(l,pegs[x][y].pos[1],pegs[x][y].pos[2],pegR)
                end
            end
        end
    
    function CreateBalls()
        for i=1,numBalls do
            ball = {}
            ball.pos = {20+math.random()*rx-20,math.random()*-400}
            ball.vel = {0,0}
            ball.acc = {0,0}
            ball.col = {math.random(),math.random(),math.random()}
            balls[i] = ball
            end
        end
    
    function UpdateBalls()
        for _,ball in ipairs(balls) do
            --reset acc
            ball.acc = {0,0}
            --add gravity
            ball.acc[2] = ball.acc[2] + grav
            --check collisions with pegs
            for x=1,cols do
                for y=1,rows do
                    mag = GetMag(ball.pos,pegs[x][y].pos)
                    if mag <= ballR+pegR then
                        local dir = GetDir(ball.pos,pegs[x][y].pos)
                        
                        ball.pos[1] = ball.pos[1] - dir[1]
                        ball.pos[2] = ball.pos[2] - dir[2]
                        
                        ball.acc[1] = ball.acc[1] - dir[1]*bounce
                        ball.acc[2] = ball.acc[2] - dir[2]*bounce
                        end
                    end
                end
            --normalize acc
            --ball.acc = Normalize(ball.acc)
            --add acc to vel
            ball.vel[1] = ball.vel[1]+ball.acc[1]
            ball.vel[2] = ball.vel[2]+ball.acc[2]
            --set max vel
            if GetMag({0,0},ball.vel) > maxSpeed then
                ball.vel = SetMag(ball.vel,maxSpeed)
                end
            --add vel to pos
            ball.pos[1] = ball.pos[1]+ball.vel[1]
            ball.pos[2] = ball.pos[2]+ball.vel[2]
            
            --reset position and vel at bottom edge
            if ball.pos[2] > ry then
                ball.pos = {20+math.random()*rx-20,math.random()*-200}
                ball.vel = {0,0}
                end
            end
        end
    
    function DrawBalls()
        for _,ball in ipairs(balls) do
            if ball.pos[1]>1-ballR and ball.pos[1]<rx+ballR and ball.pos[2]>-ballR and ball.pos[2]<ry+ballR then
                setNextFillColor(l,ball.col[1]*2,ball.col[2]*2,ball.col[3]*2,1)
                setNextStrokeColor(l,ball.col[1],ball.col[2],ball.col[3],1)
                setNextStrokeWidth(l,5)
                setNextShadow(l, ballR*1.5, ball.col[1],ball.col[2],ball.col[3],0.3)
                addCircle(l,ball.pos[1],ball.pos[2],ballR)
                end
            end
        end
    
    function GetMag(posA, posB)
        local d = (posB[1]-posA[1])*(posB[1]-posA[1]) + (posB[2]-posA[2])*(posB[2]-posA[2])
        return math.sqrt(d)
        end
    
    function SetMag(vec2d,mag)
        local vec = Normalize(vec2d)
        vec[1] = vec[1] * mag
        vec[2] = vec[2] * mag
        return vec
        end
        
    function Normalize(vec2d)
        local mag = GetMag({0,0}, vec2d)
        vec2d[1] = vec2d[1] / mag
        vec2d[2] = vec2d[2] / mag
        return vec2d
        end
    
    function GetDir(posA,posB)
        local dir = {}
        dir[1] = posB[1]-posA[1]
        dir[2] = posB[2]-posA[2]
        dir = Normalize(dir)
        return dir
        end
    
    
    
    end -- init



if not loaded then
    loaded = 1
    CreatePegs()
    CreateBalls()
    requestAnimationFrame(3)
    end

if loaded == 1 then
    loaded = loaded + 1
    requestAnimationFrame(3)
    end



--Rendering
l = createLayer()
l2 = createLayer()
font = loadFont('Play-Bold', 14)
setBackgroundColor(0.125,0.125,0.125)
setDefaultShadow(l, Shape_Circle, 16, 0, 0, 0, 0.2)
setDefaultFillColor(l, Shape_Circle, 0.8, 0.8, 0.8, 1) 
mx, my = getCursor()
--cr = getCursorReleased()
--cd = getCursorDown()

UpdateBalls()
DrawPegs()
DrawBalls()

-- TITLE
local layerTitle = createLayer()
local font = loadFont('Play-Bold', 14) 
setDefaultFillColor(layerTitle, Shape_Text, 0.1, 0.1, 0.2, 1) 
addBox(layerTitle, 30, ry-64, 220, 32)
addText(layerTitle, font, "P E G G E D . . .", 42, ry-42)



requestAnimationFrame(1)

--[[ Some dude named Bonusaben made this ]]--
--[[   Come visit the Underdun Arcade    ]]--
