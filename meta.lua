--[[ Meta ]]--


--[[ init ]]--

if not init then
    init = true
    
    rx, ry = getResolution()
        
    maxPoints = 4
    pointSize = 10
    points = {}
    
    rows = 50
    cols = 70
    cellw = rx/cols
    cellh = ry/rows
    cells = {}
    
    range = 100
    
    for i=1,maxPoints do
        point = {}
        point.x = math.random(rx)
        point.y = math.random(ry)
        point.vx = (math.random(20)-10)
        point.vy = (math.random(20)-10)
        points[i] = point
        end
    
    for i=1,cols do
        cells[i] = {}
        for j=1,rows do
            cells[i][j] = math.random(2)-1
            end
        end
    
    function MovePoints()
        for _,p in ipairs(points) do
            p.x = p.x + p.vx
            p.y = p.y + p.vy
            --if p.x < 0 then p.x = rx end
            --if p.x > rx then p.x = 0 end
            --if p.y < 0 then p.y = ry end
            --if p.y > ry then p.y = 0 end
            if p.x < 0 then 
                p.x = 0 
                p.vx = p.vx*-1
            end
            if p.x > rx then 
                p.x = rx
                p.vx = p.vx*-1
            end
            if p.y < 0 then 
                p.y = 0
                p.vy = p.vy*-1
            end
            if p.y > ry then 
                p.y = ry
                p.vy = p.vy*-1
            end
            end
        end
    
    function DrawPoints()
        for _,p in ipairs(points) do
            addCircle(layer1, p.x, p.y, pointSize)
            end
        end
    
    function DrawCells()
        for i=1,cols do
            for j=1,rows do
                --addBox(layer2,-cellw+i*cellw,-cellh+j*cellh,cellw-1,cellh-1)
                --setNextFillColor(layer2, 0.9-cells[i][j], 0, cells[i][j], 1) 
                setNextFillColor(layer2, cells[i][j], 0, 1-cells[i][j], 1) 
                addCircle(layer2,-cellw+i*cellw,-cellh+j*cellh,4)
                end
            end
        end
    
    function UpdateCells()
        for i=1,cols do
            for j=1,rows do
                local d = 0
                for _,p in ipairs(points) do
                    local mag = VecMag({-cellw+i*cellw,-cellh+j*cellh},{p.x,p.y})
                    --d = d + mag
                    d = d + mag / ry
                    end
                
                --cells[i][j] = d/#points
                --d = 1.5-math.sqrt(d)
                d = 1.8-math.sqrt(d)
                
                if d > 0.1 then d = 1 else d = 0 end
                
                cells[i][j] = d
                
                --M(x,y) = R / sqrt( (x-x0)^2 + (y-y0)^2 )
                
                
                
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
    
    
    
    end

--[[ rendering ]]--
layer2 = createLayer()
layer1 = createLayer()
layerTitle = createLayer()

layerDebug = createLayer()

local font = loadFont('Play-Bold', 14) 
setDefaultFillColor(layer1, Shape_Circle, 0.5, 0.5, 0.6, 1) 
setDefaultFillColor(layer1, Shape_Box, 0.5, 0.5, 0.6, 1) 
setDefaultFillColor(layer1, Shape_Line, 0.5, 0.5, 0.6, 1) 
setDefaultFillColor(layerDebug, Shape_Text, 0.1, 0.1, 0.2, 1) 
setDefaultFillColor(layerTitle, Shape_Text, 0.1, 0.1, 0.2, 1) 
setNextFillColor(layer1, 0.9, 0.9, 1, 1) 

--addBox(layer2, 0, 0, rx, ry)

UpdateCells()
DrawCells()

MovePoints()

addBox(layerTitle, 30, ry-64, 220, 32)
addText(layerTitle, font, "M E T A . . . . . .", 42, ry-42)

requestAnimationFrame(3)






--[[ Some dude named Bonusaben made this ]]--
--[[   Come visit the Underdun Arcade    ]]--
