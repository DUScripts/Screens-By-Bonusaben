--[[ Piston ]]--

if not init then
    init = true
    
    rx, ry = getResolution()
    
    cols = 22
    rows = 14
    size = 20
    baseOffset = 16
    baseCol = {1,0.4,0.2}
    counter = 0
    counterInc = -0.05
    sticks = {}
    
    for x = 1, cols do
        for y = 1, rows do
            stick = {}
            stick.pos = {x,y}
            table.insert(sticks,stick)
            end
        end
    
    function DrawSticks()
        for _,stick in ipairs(sticks) do
            
            local c = {cols/2,rows/2}
            local d = GetMag(c,stick.pos)
            local offset = baseOffset * (1+math.sin(d+counter)/2)
            
            local x = (stick.pos[1]-0.5)*rx/cols-size/2
            local y = (stick.pos[2]-0.5)*ry/rows-size/2
            
            local x2 = x + offset
            local y2 = y - offset
            
            --left
            setNextFillColor(l,baseCol[1]/2,baseCol[2]/2,baseCol[3]/2,1)
            addQuad(l,x,y,x2,y2,x2,y2+size,x,y+size)
            
            --right
            setNextFillColor(l,baseCol[1]/3,baseCol[2]/3,baseCol[3]/3,1)
            addQuad(l,x,y+size,x2,y2+size,x2+size,y2+size,x+size,y+size)
            
            --top
            setNextFillColor(l,baseCol[1]*2,baseCol[2]*2,baseCol[3]*2,1)
            addQuad(l,x2,y2,x2+size,y2,x2+size,y2+size,x2,y2+size)
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
font = loadFont('Play-Bold', 8)
setBackgroundColor(1,0.5,0.0)

DrawSticks()
counter = counter + counterInc

local layerTitle = createLayer()
local font = loadFont('Play-Bold', 14) 
setDefaultFillColor(layerTitle, Shape_Text, 0.1, 0.1, 0.2, 1) 
addBox(layerTitle, 30, ry-64, 220, 32)
addText(layerTitle, font, "P I S T O N . . . .", 42, ry-42)

requestAnimationFrame(1)

--[[ Some dude named Bonusaben made this ]]--
--[[   Come visit the Underdun Arcade    ]]--
