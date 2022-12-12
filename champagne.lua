--[[ Champagne ]]--


--[[ init ]]--

if not init then
    init = true
    
    rx, ry = getResolution()
    
    bubbles = {}
    numBubbles = 450
    
    counter = 0
    
    function GetWeightedSize()
        while true do
            local r1 = math.random()
            local r2 = math.random()
            if r2 > r1 then
                return r1
                end
            end
        end
    
    for i=1,numBubbles do
        local bubble = {}
        bubble.pos = {math.random(0,rx),math.random(0,ry)}
        --bubble.size = math.random(1,25)
        bubble.size = GetWeightedSize()*25
        
        
        bubble.dir = {math.random(-10,10)/10,-bubble.size/8}
        bubble.col = {0.8,1,0.8,0.1*bubble.size/4}
        
        table.insert(bubbles,bubble)
        end
    
    
    function DrawBubbles()
        for _,bubble in ipairs(bubbles) do
            setNextFillColor(layer1, bubble.col[1], bubble.col[2], bubble.col[3], bubble.col[4]) 
            --addBox(layer1, bubble.pos[1], bubble.pos[2], bubble.size, bubble.size)
            addCircle(layer1,bubble.pos[1],bubble.pos[2],bubble.size)
            setNextFillColor(layer1, 1, 1, 1, 0.6) 
            addCircle(layer1,bubble.pos[1]+bubble.size/4,bubble.pos[2]-bubble.size/4,bubble.size*0.6)
            end
        end
    
    function MoveBubbles()
        for i,bubble in ipairs(bubbles) do
            bubble.pos[1] = bubble.pos[1]+bubble.dir[1]+(math.sin(counter+i)*bubble.size)/15
            bubble.pos[2] = bubble.pos[2]+bubble.dir[2]
            
            --[[ Flip at borders ]]--
            if bubble.pos[1] > rx then
                bubble.pos[1] = rx
                bubble.dir[1] = bubble.dir[1]*-1
                end
            if bubble.pos[1] < 0 then
                bubble.pos[1] = 0
                bubble.dir[1] = bubble.dir[1]*-1
                end
            if bubble.pos[2] < -50 then
                bubble.pos[2] = ry+50
                --bubble.dir[2] = bubble.dir[2]*-1
                end
            end
        end
    
    
    
    
    
    end




--[[ rendering ]]--

layer1 = createLayer()
layerTitle = createLayer()
layerDebug = createLayer()

local font = loadFont('Play-Bold', 14) 
setDefaultFillColor(layer1, Shape_Box, 0.5, 0.5, 0.6, 1) 
setDefaultFillColor(layerTitle, Shape_Text, 0.1, 0.1, 0.2, 1) 

setNextFillColor(layer1, 0.2, 0.7, 0.5, 1) 
addBox(layer1, 0, 0, rx, ry)

DrawBubbles()
MoveBubbles()

counter = counter + 0.1

addBox(layerTitle, 30, ry-64, 220, 32)
addText(layerTitle, font, "C H A M P A G N E .", 42, ry-42)
--addText(layerDebug, font, string.format('render cost : %d / %d',  getRenderCost(), getRenderCostMax()), 16, ry-16)


requestAnimationFrame(2)

--[[ Some dude named Bonusaben made this ]]--
--[[   Come visit the Underdun Arcade    ]]--
