--[[ Cubic ]]--


--[[ init ]]--

if not init then
    init = true
    
    rx, ry = getResolution()
    
    quads = {}
    numQuads = 8
    
    
    for i=1,numQuads do
        local quad = {}
        quad.points = {}
        for i=1,4 do
            local x = math.random(rx)
            local y = math.random(ry)
            local vx = (math.random()-0.5)*2
            local vy = (math.random()-0.5)*2
            
            quad.points[i] = {}
            quad.points[i].x = x
            quad.points[i].y = y
            quad.points[i].vx = vx
            quad.points[i].vy = vy
            
            end
        
        local cMul = math.random()
        quad.col = {1-cMul,0,cMul,1}
        
        table.insert(quads,quad)
        end
    
    function DrawQuads()
        for _,q in ipairs(quads) do
            setNextFillColor(layer1, q.col[1], q.col[2], q.col[3], q.col[4]) 
            addQuad(layer1, q.points[1].x, q.points[1].y, q.points[2].x, q.points[2].y, q.points[3].x, q.points[3].y, q.points[4].x, q.points[4].y) 
            end
        end
    
    function MoveQuads()
        for _,q in ipairs(quads) do
            for i=1,#q.points do
                q.points[i].x = q.points[i].x + q.points[i].vx
                q.points[i].y = q.points[i].y + q.points[i].vy
                
                if q.points[i].x > rx then
                    q.points[i].x = rx
                    q.points[i].vx = q.points[i].vx *-1
                    end
                if q.points[i].x < 0 then
                    q.points[i].x = 0
                    q.points[i].vx = q.points[i].vx *-1
                    end
                if q.points[i].y > ry then
                    q.points[i].y = ry
                    q.points[i].vy = q.points[i].vy *-1
                    end
                if q.points[i].y < 0 then
                    q.points[i].y = 0
                    q.points[i].vy = q.points[i].vy *-1
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
setDefaultStrokeWidth(layer1, Shape_Polygon, 10)
DrawQuads()
MoveQuads()

local font = loadFont('Play-Bold', 14) 
setDefaultFillColor(layerTitle, Shape_Text, 0.1, 0.1, 0.2, 1) 

--setNextFillColor(layer1, 0.8, 0.8, 1, 1) 
setNextFillColor(layer1, 1, 1, 1, 1) 
addBox(layer1, 0, 0, rx, ry)

addBox(layerTitle, 30, ry-64, 220, 32)
addText(layerTitle, font, "C U B I C . . . . .", 42, ry-42)
--addText(layerDebug, font, string.format('render cost : %d / %d',  getRenderCost(), getRenderCostMax()), 16, ry-16)


requestAnimationFrame(3)

--[[ Some dude named Bonusaben made this ]]--
--[[   Come visit the Underdun Arcade    ]]--
