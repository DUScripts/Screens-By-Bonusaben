--[[ Scratch ]]--


--[[ init ]]--

if not init then
    init = true
    
    rx, ry = getResolution()
    
    ls = {}
    numLines = 50
    
    
    for i=1,numLines do
        local line = {}
        line.points = {}
        for i=1,2 do
            local x = math.random(rx)
            local y = math.random(ry)
            local vx = (math.random()-0.5)*2
            local vy = (math.random()-0.5)*2
            
            line.points[i] = {}
            line.points[i].x = x
            line.points[i].y = y
            line.points[i].vx = vx
            line.points[i].vy = vy
            
            end
        
        local cMul = math.random()
        line.col = {0,cMul/2,cMul,1}
        
        table.insert(ls,line)
        end
    
    function DrawLines()
        for _,l in ipairs(ls) do
            setNextStrokeColor(layer1, l.col[1], l.col[2], l.col[3], l.col[4]) 
            addLine(layer1,l.points[1].x,l.points[1].y,l.points[2].x,l.points[2].y)
            --addLine(layer1,rx/2,ry/2,l.points[2].x,l.points[2].y)
            end
        end
    
    function MoveLines()
        for _,l in ipairs(ls) do
            for i=1,#l.points do
                l.points[i].x = l.points[i].x + l.points[i].vx
                l.points[i].y = l.points[i].y + l.points[i].vy
                
                if l.points[i].x > rx then
                    l.points[i].x = rx
                    l.points[i].vx = l.points[i].vx *-1
                    end
                if l.points[i].x < 0 then
                    l.points[i].x = 0
                    l.points[i].vx = l.points[i].vx *-1
                    end
                if l.points[i].y > ry then
                    l.points[i].y = ry
                    l.points[i].vy = l.points[i].vy *-1
                    end
                if l.points[i].y < 0 then
                    l.points[i].y = 0
                    l.points[i].vy = l.points[i].vy *-1
                    end
                
                
                end
            
            end
        end
    
    
    

    end



--[[ rendering ]]--

layer1 = createLayer()
layerTitle = createLayer()
layerDebug = createLayer()

setDefaultStrokeColor(layer1, Shape_Polygon, 1, 1, 1, 1)
setDefaultStrokeWidth(layer1, Shape_Line, 2)
DrawLines()
MoveLines()

local font = loadFont('Play-Bold', 14) 
setDefaultFillColor(layerTitle, Shape_Text, 0.1, 0.1, 0.2, 1) 

--setNextFillColor(layer1, 0.8, 0.8, 1, 1) 
setNextFillColor(layer1, 0.1, 0.2, 0.3, 1) 
addBox(layer1, 0, 0, rx, ry)

addBox(layerTitle, 30, ry-64, 220, 32)
addText(layerTitle, font, "S C R A T C H . . .", 42, ry-42)
--addText(layerDebug, font, string.format('render cost : %d / %d',  getRenderCost(), getRenderCostMax()), 16, ry-16)


requestAnimationFrame(3)

--[[ Some dude named Bonusaben made this ]]--
--[[   Come visit the Underdun Arcade    ]]--
