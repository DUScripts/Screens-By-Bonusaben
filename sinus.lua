--[[ Sinus ]]--


--[[ init ]]--

if not init then
    init = true
    
    rx, ry = getResolution()

    maxSpots = 50
    spotSize = 25
    spots = {}
    
    counter = 0
    
    function CreateSpots()
        for i=1,maxSpots do
            spots[i] = {}
            spots[i].x = rx/maxSpots*i
            spots[i].y = ry/2
            spots[i].z = 1
            end
        end
    
    
    function DrawSpots()
        for _,spot in ipairs(spots) do
            --setNextFillColor(layer1,spot.y/ry,1-spot.y/ry,0,1)
            setNextFillColor(layer1, spot.z, 0, 1-spot.z, 0.1+spot.z)
            addCircle(layer1, spot.x, spot.y, 10+spotSize*spot.z)
            end
        end
    
    function MoveSpots()
        for _,spot in ipairs(spots) do
            --spot.x = 0
            --spot.y = ry/2
            spot.y = 40+((math.sin(_/5+counter)+1)/2)*(ry-80)
            spot.z = (math.cos(_/5+counter)+1)/2
            
            end
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


-- Spots
DrawSpots()
MoveSpots()
counter = counter+0.05

addBox(layerTitle, 30, ry-64, 220, 32)
addText(layerTitle, font, "S I N U S . . . . .", 42, ry-42)

requestAnimationFrame(2)






--[[ Some dude named Bonusaben made this ]]--
--[[   Come visit the Underdun Arcade    ]]--
