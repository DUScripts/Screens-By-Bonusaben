--[[ Hanger ]]--

if not init then
    init = true
    
    rx, ry = getResolution()
    
    counter = 0
    counterInc = 0.01
    speed = 1
    
    cols = {}
    cols[1] = {1.0,0.0,0.0}
    cols[2] = {1.0,0.5,0.0}
    cols[3] = {0.0,0.0,1.0}
    
    maxYOffset = math.floor(ry/3)
    minSize = 15
    maxSize = 80
    
    numPoints = 5
    points = {}
    
    for i=1,numPoints+2 do
        point = {}
        point.pos = {(i-1)*rx/numPoints,ry/2+(-maxYOffset+math.random(maxYOffset)*2)}
        point.col = cols[math.floor(math.random(#cols))]
        points[i] = point
        end
    
    function DrawPoints()
        -- center line
        
        setNextStrokeColor(l,1/2,1/2,0.9/2,0.5)
        addLine(l,0,ry/2+5,rx,ry/2+5)
        addLine(l,0,ry/2,rx,ry/2)
        
        for _,p in ipairs(points) do
            local r = math.min((minSize + math.abs(ry/2-p.pos[2])/3),maxSize)
            local offsetFromCenter = p.pos[2]-ry/2
            local offsetDelta = offsetFromCenter*math.sin(offsetFromCenter+counter)
            
            --shadow
            setNextFillColor(l,1/2,1/2,0.9/2,0.3)
            addCircle(l,p.pos[1],ry/2+offsetDelta+8,r*1.05)
            --setNextStrokeColor(l,1/2,1/2,0.9/2,0.5)
            --addLine(l,p.pos[1],p.pos[2]+5,p.pos[1],ry/2+5)
            
            addLine(l,p.pos[1],ry/2+offsetDelta,p.pos[1],ry/2)
            
            setNextFillColor(l2,p.col[1],p.col[2],p.col[3],1)
            addCircle(l2,p.pos[1],ry/2+offsetDelta,r)
            
            end
        end
    
    function MovePoints()
        for _,p in ipairs(points) do
            p.pos[1] = p.pos[1]+speed
            if p.pos[1] > rx+(rx/numPoints) then
                p.pos[1] = -rx/numPoints
                p.pos[2] = ry/2+(-maxYOffset+math.random(maxYOffset)*2)
                p.col = cols[math.floor(math.random(#cols))]
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
    
    end -- init

--Rendering
l = createLayer()
l2 = createLayer()
font = loadFont('Play-Bold', 8)
setBackgroundColor(1,1,0.9,1)
setDefaultStrokeColor(l,Shape_Line,0,0,0,1)
setDefaultStrokeWidth(l,Shape_Line,10)



DrawPoints()
MovePoints()
counter = counter + counterInc

local layerTitle = createLayer()
local font = loadFont('Play-Bold', 14) 
setDefaultFillColor(layerTitle, Shape_Text, 0.1, 0.1, 0.2, 1) 
addBox(layerTitle, 30, ry-64, 220, 32)
addText(layerTitle, font, "H A N G E R . . . .", 42, ry-42)

requestAnimationFrame(1)

--[[ Some dude named Bonusaben made this ]]--
--[[   Come visit the Underdun Arcade    ]]--
