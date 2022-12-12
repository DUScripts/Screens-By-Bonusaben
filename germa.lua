--[[ Germa ]]--

local rx,ry = getResolution()

if not init then
    init = true
    
    startingDots = 100
    dotRadMul = 2
    baseViewDist = 100
    colDist = 10
    maxSpeed = 5 -- minus level
    dotsExplosionNum = 25
    
    --create dots
    dots = {}
    for i=1,startingDots do
        dot = {}
        dot.pos = {}
        dot.pos.x = math.random()*rx
        dot.pos.y = math.random()*ry
        dot.acc = {0,0}
        dot.vel = {-1+math.random()*2,-1+math.random()*2}
        dot.level = 1
        dots[i] = dot
        end
    
    function DrawDots()
        for _,dot in ipairs(dots) do
            setNextFillColor(l,dot.level/6,3-dot.level,4-dot.level,1)
            addCircle(l,dot.pos.x,dot.pos.y,dot.level*dotRadMul)
            end
        end
    
    function MoveDots()
        
        for _,dot in ipairs(dots) do
            --reset acc
            dot.acc = {0,0}
            for i=#dots,1,-1 do
                local mag = GetMag( {dot.pos.x,dot.pos.y}, {dots[i].pos.x,dots[i].pos.y} )
                if mag < baseViewDist and mag > 0.1 then
                    local dir = GetDirNorm({dot.pos.x,dot.pos.y},{dots[i].pos.x,dots[i].pos.y})
                    
                    if mag < colDist then
                        --same level collide, level increases, delete one
                        if dot.level == dots[i].level then
                            dot.level = dot.level + 1
                            dots[i].level = 0
                        --higher level eats lower level
                        elseif dot.level > dots[i].level then
                            dots[i].level = 0
                            end    
                        end
                    
                    --attract to same level AND lower level
                    if dot.level >= dots[i].level then
                        dot.acc[1] = dot.acc[1] + dir[1]
                        dot.acc[2] = dot.acc[2] + dir[2]
                        end
                    
                    --repel from higher level
                    if dot.level < dots[i].level then
                        dot.acc[1] = dot.acc[1] - dir[1]*2
                        dot.acc[2] = dot.acc[2] - dir[2]*2
                        end
                    
                    end
                end
            
            --attract to center based on distance
            local distToCenter = GetMag({dot.pos.x,dot.pos.y},{rx/2,ry/2})
            local dirToCenter = GetDirNorm({dot.pos.x,dot.pos.y},{rx/2,ry/2})
            dot.acc[1] = dot.acc[1] + dirToCenter[1] * (distToCenter/rx/2)
            dot.acc[2] = dot.acc[2] + dirToCenter[2] * (distToCenter/rx/2)
            
            --add acc to vel
            dot.vel[1] = dot.vel[1] + dot.acc[1]
            dot.vel[2] = dot.vel[2] + dot.acc[2]
            --set max vel
            if GetMag({0,0},dot.vel) > maxSpeed-dot.level then
                dot.vel = SetMag(dot.vel,maxSpeed-dot.level)
                end
            --add vel to pos
            dot.pos.x = dot.pos.x + dot.vel[1]
            dot.pos.y = dot.pos.y + dot.vel[2]
            --flip at screen edges
            if dot.pos.x < 0 then
                dot.pos.x = 0
                dot.vel[1] = -dot.vel[1]
                end
            if dot.pos.x > rx then
                dot.pos.x = rx
                dot.vel[1] = -dot.vel[1]
                end
            if dot.pos.y < 0 then
                dot.pos.y = 0
                dot.vel[2] = -dot.vel[2]
                end
            if dot.pos.y > ry then
                dot.pos.y = ry
                dot.vel[2] = -dot.vel[2]
                end
            end
        end
    
    function RemoveDeadDots()
        for i=#dots,1,-1 do
            if dots[i].level == 0 then
                --dots[i] = nil
                table.remove(dots,i)
            elseif dots[i].level == 5 then
                --dots[i] = nil
                local pos = dots[i].pos
                table.remove(dots,i)
                --explode into new dots
                CreateNewDots(pos)
                end
            end
        end
    
    function CreateNewDots(pos)
        for i=#dots+1,#dots+dotsExplosionNum do
            dot = {}
            dot.pos = {}
            dot.pos.x = pos.x+math.random(-60,60)
            dot.pos.y = pos.y+math.random(-60,60)
            dot.acc = {0,0}
            dot.vel = GetDirNorm({pos.x,pos.y},{dot.pos.x,dot.pos.y})
            dot.level = 1
            dot.col = {1,1,1}
            dots[i] = dot
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
    
    function GetDirNorm(posA, posB)
        local dir = {}
        dir[1] = posB[1]-posA[1]
        dir[2] = posB[2]-posA[2]
        dir = Normalize(dir)
        return dir
        end
    
    
    end -- end init

    
    
--Rendering
l = createLayer()

setBackgroundColor(0.1,0.5,0.5)

DrawDots()
MoveDots()
RemoveDeadDots()

local layerTitle = createLayer()
local font = loadFont('Play-Bold', 14) 
setDefaultFillColor(layerTitle, Shape_Text, 0.1, 0.1, 0.2, 1) 
addBox(layerTitle, 30, ry-64, 220, 32)
addText(layerTitle, font, "G E R M A . . . . .", 42, ry-42)
    
requestAnimationFrame(1)

--[[ Some dude named Bonusaben made this ]]--
--[[   Come visit the Underdun Arcade    ]]--
