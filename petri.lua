--[[ Petri ]]--


--[[ init ]]--

if not init then
    init = true
    
    rx, ry = getResolution()
        
    petriRadius = ry/2-20
    
    maxSpots = 250
    spotSize = 2
    spots = {}
    
    function CreateSpots()
        for i=1,maxSpots do
            spots[i] = {}
            spots[i].pos = {}
        
            local r = (petriRadius-50) * math.sqrt(math.random())
            local theta = math.random() * 2 * math.pi
        
            spots[i].pos.x = rx/2 + r * math.cos(theta)
            spots[i].pos.y = ry/2 + r * math.sin(theta)
            
            --spots[i].vel = Normalize( { (math.random()-0.5)*2, (math.random()-0.5)*2 } )
            spots[i].vel = { (math.random()-0.5)*5, (math.random()-0.5)*5 }
            spots[i].acc = {0,0}
        
            end
        end
    
    
    function DrawSpots()
        for _,spot in ipairs(spots) do
            addCircle(layer1, spot.pos.x+math.random(-1,1), spot.pos.y+math.random(-1,1), spotSize+math.random(-1,1))
            end
        end
    
    function MoveSpots()
        for _,spot in ipairs(spots) do
            local dirToCenter = {rx/2 - spot.pos.x,ry/2-spot.pos.y}
            dirToCenter = Normalize(dirToCenter)
            
            spot.acc[1] = dirToCenter[1]/10
            spot.acc[2] = dirToCenter[2]/10
            
            spot.vel[1] = spot.vel[1] + spot.acc[1]
            spot.vel[2] = spot.vel[2] + spot.acc[2]
            
            spot.pos.x = spot.pos.x + spot.vel[1]
            spot.pos.y = spot.pos.y + spot.vel[2]
            end
        end
    
    function GetMag(posA, posB)
        local d = (posB[1]-posA[2])*(posB[1]-posA[2]) + (posB[2]-posA[1])*(posB[2]-posA[1])
        return math.sqrt(d)
        end
    
    function Normalize(vec2d)
        local mag = GetMag({0,0}, vec2d)
        vec2d[1] = vec2d[1] / mag
        vec2d[2] = vec2d[2] / mag
        return vec2d
        end
    
    
    
    CreateSpots()
    
    end

--[[ rendering ]]--
layer1 = createLayer()
layerTitle = createLayer()

layerDebug = createLayer()

local font = loadFont('Play-Bold', 14) 
setDefaultFillColor(layer1, Shape_Circle, 1, 1, 0, 0.8) 
setDefaultFillColor(layer1, Shape_Box, 0.5, 0.5, 0.6, 1) 
setDefaultFillColor(layer1, Shape_Line, 0.5, 0.5, 0.6, 1) 
setDefaultFillColor(layerDebug, Shape_Text, 0.1, 0.1, 0.2, 1) 
setDefaultFillColor(layerTitle, Shape_Text, 0.1, 0.1, 0.2, 1) 


-- BG
setNextFillColor(layer1, 1/255*140, 1/255*17, 1/255*8, 0.5) 
setNextStrokeColor(layer1,1,1,1,1)
setNextStrokeWidth(layer1, 5) 
addCircle(layer1, rx/2,ry/2,petriRadius)

-- Spots
DrawSpots()
MoveSpots()

addBox(layerTitle, 30, ry-64, 220, 32)
addText(layerTitle, font, "P E T R I . . . . .", 42, ry-42)

requestAnimationFrame(3)





--[[ Some dude named Bonusaben made this ]]--
--[[   Come visit the Underdun Arcade    ]]--
