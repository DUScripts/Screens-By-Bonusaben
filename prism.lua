--[[ Prism ]]--


--[[ init ]]--

if not init then
    init = true
    
    rx, ry = getResolution()
    
    boxes = {}
    numBoxes = 500
    
    
    for i=1,numBoxes do
        local box = {}
        box.pos = {math.random(0,rx),math.random(0,ry)}
        box.dir = {math.random(-10,10)/10,math.random(-10,10)/10}
        box.size = math.random(20,120)
        box.col = {math.random(),math.random(),math.random(),0.1}
        
        table.insert(boxes,box)
        end
    
    
    function DrawBoxes()
        for _,box in ipairs(boxes) do
            setNextFillColor(layer1, box.col[1], box.col[2], box.col[3], box.col[4]) 
            addBox(layer1, box.pos[1], box.pos[2], box.size, box.size)
            end
        end
    
    function MoveBoxes()
        for i,box in ipairs(boxes) do
            box.pos[1] = box.pos[1]+box.dir[1]
            box.pos[2] = box.pos[2]+box.dir[2]
            
            --[[ Flip at borders ]]--
            if box.pos[1] > rx then
                box.pos[1] = rx
                box.dir[1] = box.dir[1]*-1
                end
            if box.pos[1] < 0 then
                box.pos[1] = 0
                box.dir[1] = box.dir[1]*-1
                end
            if box.pos[2] > ry then
                box.pos[2] = ry
                box.dir[2] = box.dir[2]*-1
                end
            if box.pos[2] < 0 then
                box.pos[2] = 0
                box.dir[2] = box.dir[2]*-1
                end
            end
        end
    
    
    function VecMag(vec1, vec2)
        local x1 = vec1[1]
        local y1 = vec1[2]
        local x2 = vec2[1]
        local y2 = vec2[2]
        return math.sqrt((x2-x1)*(x2-x1)+(y2-y1)*(y2-y1))
        end
    
    function VecNorm(vec,mag)
        local outVec = {}
        outVec[1] = vec[1]/mag
        outVec[2] = vec[2]/mag
        return outVec
        end
    
    end




--[[ rendering ]]--

layer1 = createLayer()
layerTitle = createLayer()
layerDebug = createLayer()

local font = loadFont('Play-Bold', 14) 
setDefaultFillColor(layer1, Shape_Box, 0.5, 0.5, 0.6, 1) 
setDefaultFillColor(layerTitle, Shape_Text, 0.1, 0.1, 0.2, 1) 

setNextFillColor(layer1, 0.8, 0.8, 1, 1) 
addBox(layer1, 0, 0, rx, ry)

DrawBoxes()
MoveBoxes()

addBox(layerTitle, 30, ry-64, 220, 32)
addText(layerTitle, font, "P R I S M . . . . .", 42, ry-42)
--addText(layerDebug, font, string.format('render cost : %d / %d',  getRenderCost(), getRenderCostMax()), 16, ry-16)


requestAnimationFrame(3)

--[[ Some dude named Bonusaben made this ]]--
--[[   Come visit the Underdun Arcade    ]]--
