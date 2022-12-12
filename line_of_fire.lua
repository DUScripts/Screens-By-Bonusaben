--[[ Line_of_fire ]]--

local rx,ry = getResolution()

if not init then
    init = true
    
    lines = {}
    numLines = 1
    speed = 10
    lineLength = 400
    trailLife = 600
    trailCounter = 0
    newLines = {}
    
    function CreateLine(pos,vel,length,angle)
        line = {}
        line.pos = {}
        line.pos[1] = pos[1]
        line.pos[2] = pos[2]
        line.vel = {}
        line.vel[1] = vel[1]
        line.vel[2] = vel[2]
        line.length = length
        line.angle = angle
        line.life = trailLife
        line.hasSpawnedNewLine = false
        table.insert(newLines,line)
        end
    
    function DrawLines()
        for _,line in ipairs(lines) do
            local dirX = math.sin(line.angle)
            local dirY = math.cos(line.angle)
            local x1 = line.pos[1]-dirX*line.length/2
            local y1 = line.pos[2]-dirY*line.length/2
            local x2 = line.pos[1]+dirX*line.length/2
            local y2 = line.pos[2]+dirY*line.length/2
            
            setNextStrokeColor(l,1,line.life/trailLife,0,1-line.life/trailLife)
            addLine(l,x1,y1,x2,y2)
            end
        end
    
    function MoveLines()
        newLines = {}
        
        if trailCounter < 0 then
            createTrail = true
            trailCounter = 2
            else
            createTrail = false
            trailCounter = trailCounter - 1
            end
        
        for _,line in ipairs(lines) do
            
            if createTrail and not line.hasSpawnedNewLine then
                CreateLine(line.pos,line.vel,line.length,line.angle)
                line.hasSpawnedNewLine = true
                end
            
            line.pos[1] = line.pos[1] + line.vel[1] * speed
            line.pos[2] = line.pos[2] + line.vel[2] * speed
            
            --flip at edges
            if line.pos[1] < 0 then
                line.pos[1] = 0
                line.vel[1] = line.vel[1] * -1
                end
            if line.pos[1] > rx then
                line.pos[1] = rx
                line.vel[1] = line.vel[1] * -1
                end
            if line.pos[2] < 0 then
                line.pos[2] = 0
                line.vel[2] = line.vel[2] * -1
                end
            if line.pos[2] > ry then
                line.pos[2] = ry
                line.vel[2] = line.vel[2] * -1
                end
            
            line.angle = line.angle - 0.05
            
            end
        
        for i=#lines,1,-1 do
            if lines[i].life <= 0 then
                table.remove(lines,i)
                else
                lines[i].life = lines[i].life - 1
                end
            end
        
        for _,line in ipairs(newLines) do
            table.insert(lines,line)
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
    
    
    
    for i=1,numLines do
        line = {}
        line.pos = {}
        line.pos[1] = math.random()*rx
        line.pos[2] = math.random()*ry
        line.vel = Normalize({-1+math.random()*2,-1+math.random()*2})
        line.length = lineLength
        line.angle = math.random()*2*math.pi
        line.life = trailLife
        lines[i] = line
        end
    
    
    end -- end init

    
    
--Rendering
l = createLayer()

setBackgroundColor(0.0,0.0,0.1)
setDefaultStrokeWidth(l,Shape_Line,5)
DrawLines()
MoveLines()





local layerTitle = createLayer()
local font = loadFont('Play-Bold', 14) 
setDefaultFillColor(layerTitle, Shape_Text, 0.1, 0.1, 0.2, 1) 
addBox(layerTitle, 30, ry-64, 220, 32)
addText(layerTitle, font, "L I N E . O F . F I R E", 42, ry-42)

--addText(l,font, "Lines: "..#lines,30,ry-20)

requestAnimationFrame(1)

--[[ Some dude named Bonusaben made this ]]--
--[[   Come visit the Underdun Arcade    ]]--
