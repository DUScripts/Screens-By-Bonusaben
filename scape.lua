--[[ Scape ]]--

if not init then
    init = true
    
    rx, ry = getResolution()
    
    columns = 36
    rows = 36
    
    pixelW = 10 -- if not fullscreen
    
    tileWidth = 30
    tileHeight = 15
    groundHeight = 55
    local yOff = 100 -- 100
    
    col1 = {0,0,0.3,1} -- deep water
    col2 = {0,0,0.7,0.7} -- water
    col3 = {0.9,0.9,1,0.6} -- splash
    col4 = {0.9,0.8,0.4,1} -- sand
    col5 = {0.3,1,0.2,1} -- grass
    col6 = {0.2,0.2,0.3,1} -- stone
    col7 = {0.9,0.9,0.9,1} -- snow
    col = {}
    
    numPoints = 15
    pointMaxAmount = 2
    pointMaxValue = 0
    
    pixels = {}
    points = {}
    
    -- create "pixels"
    function CreatePixels()
        for x=1,columns do
            for y=1,rows do
                pixel = {}
                pixel.pos = {x,y}
                pixel.col = {math.random(),math.random(),math.random()}
                table.insert(pixels,pixel)
                end
            end
        end
    
    function CreatePoints()
        for i=1,numPoints do
            point = {}
            point.pos = {math.random()*rx,math.random()*ry}
            point.acc = {0,0}
            point.vel = {-1+math.random()*2,-1+math.random()*2}
            points[i] = point
            end
        end
    
    function DrawPixels(fullscreen)
        maxValue = 0
        for _,p in ipairs(pixels) do
            if fullscreen then
                local x = rx/columns*(p.pos[1]-1)
                local y = ry/rows*(p.pos[2]-1)
                local w = rx/columns
                --local avgDist = GetDistanceToClosestPoint({x,y})
                local avgDist = GetAvgDistToClosestPoints({x,y})
                
                
                local v = 0
                if avgDist > 0 then
                    v = 1-avgDist/maxValue
                    --v = 1-avgDist/maxValue
                    end
                
                v = v * v / 2
                
                setNextFillColor(l,v,v,v,1)
                addBox(l,x,y,w,w)
                --addText(l,font,v,x,y)
                end
            end
        end
    
    function DrawMap()
        maxValue = 0
        
        for c=1, columns, 1 do
            for r=1, rows, 1 do
                --(r-1)*(columns-1)+(c-1)+1 -- MAGIC
                local x = rx/columns*(pixels[(r-1)*(columns)+(c-1)+1].pos[1]-1)
                local y = rx/rows*(pixels[(r-1)*(columns)+(c-1)+1].pos[2]-1)
                
                --local avgDist = GetDistanceToClosestPoint({x,y})
                local avgDist = GetAvgDistToClosestPoints({x,y})
                avgDist = 1-avgDist / maxValue -- 0 to 1
                
                local d = 1-math.sqrt( (rx/2-rx/columns*(c-1))^2 + (ry/2-ry/rows*(r-1))^2 )/ry -- gradient
                
                local v = 0
                --v = avgDist^2 * d^2
                v = (avgDist^2 + d^2)^1.5/2
                
                
                if v < 0.2 then
                    col = col1
                elseif v < 0.3 then
                    col = col2
                elseif v < 0.32 then
                    col = col3
                elseif v < 0.4 then
                    col = col4
                elseif v < 0.85 then
                    col = col5
                elseif v < 0.95 then
                    col = col6
                    else
                    col = col7
                end
                
            
                local off = v*-30
                
                --if v > 0.4 then
                    off = math.min(v*-30+(v-0.4)*-yOff,tileHeight/2)
                --    end
                
            
            
                --local X = (c-1) * (rx/columns) / 2 + (r-1) * (rx/columns) / 2
                --local Y = off+ry/2+(r-1) * (ry/rows) / 2 - (c-1) * (ry/rows) / 2
                
                local X = rx/2 + (c-1) * (rx/columns) / 2 - (r-1) * (rx/columns) / 2
                local Y = off  + (r-1) * (ry/rows)    / 2 + (c-1) * (ry/rows)    / 2
                
                setNextFillColor(l,col[1],col[2],col[3],col[4])
                addQuad(l, X,Y, X+tileWidth/2,Y+tileHeight/2, X,Y+tileHeight, X-tileWidth/2,Y+tileHeight/2)
            
                setNextFillColor(l,col[1]/2,col[2]/2,col[3]/2,col[4])
                addQuad(l, X-tileWidth/2,Y+tileHeight/2, X,Y+tileHeight, X,Y+tileHeight+groundHeight, X-tileWidth/2,Y+tileHeight/2+groundHeight)
            
                setNextFillColor(l,col[1]/3,col[2]/3,col[3]/3,col[4])
                --addQuad(l,X,Y,X+tileWidth,Y+tileHeight/2,X,Y+tileHeight,X-tileWidth,Y+tileHeight/2)
                addQuad(l, X,Y+tileHeight, X+tileWidth/2,Y+tileHeight/2, X+tileWidth/2,Y+tileHeight/2+groundHeight,X,Y+tileHeight+groundHeight)
            
                --addText(l,font,c..","..r,X,Y)
                --addText(l,font,d,X,Y)
                        
                end
            end
        end
    
    function GetDistanceToClosestPoint(pos)
        local d = 99999
        
        for _,p in ipairs(points) do
            local dist = GetMag(p.pos,pos)
            if dist < d then
                d = dist
                end
            end
        
        if d > maxValue then
            maxValue = d
            end
        
        return d
        end
    
    function GetAvgDistToClosestPoints(pos)
        local val = 0
        local closestValues = {}
        
        for i=1,pointMaxAmount do
            closestValues[i] = 99999
            end
        
        for _,p in ipairs(points) do
            local d = GetMag(p.pos,pos)
            table.insert(closestValues,d)
            end
        
        table.sort(closestValues)
        
        for i=1,pointMaxAmount do
            val = val + closestValues[i]
            end
        
        val = val / pointMaxAmount
                
        if val > maxValue then
            maxValue = val
            end
        
        return val
        end
    
    function DrawPoints()
        for _,p in ipairs(points) do
            setNextFillColor(l,1,0,0,1)
            addCircle(l,p.pos[1],p.pos[2],1)
            end
        end
    
    function MovePoints()
        for _,p in ipairs(points) do
            --reset acc
            p.acc = {0,0}
            
            --add acc to vel
            p.vel[1] = p.vel[1] + p.acc[1]
            p.vel[2] = p.vel[2] + p.acc[2]
            
            --normalize vel
            
            --add vel to pos
            p.pos[1] = p.pos[1] + p.vel[1]
            p.pos[2] = p.pos[2] + p.vel[2]
            
            --flip vel at edges
            if p.pos[1] < 0 then
                p.pos[1] = 0
                p.vel[1] = -p.vel[1]
                end
            if p.pos[1] > rx then
                p.pos[1] = rx
                p.vel[1] = -p.vel[1]
                end
            if p.pos[2] < 0 then
                p.pos[2] = 0
                p.vel[2] = -p.vel[2]
                end
            if p.pos[2] > ry then
                p.pos[2] = ry
                p.vel[2] = -p.vel[2]
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
    
    CreatePixels()
    CreatePoints()
    
    end -- init
    
-- Rendering
l = createLayer()
setBackgroundColor(0,0,0.05)
--font = loadFont('Play-Bold', 8)
--DrawPixels(true)
DrawMap()
--DrawPoints()
MovePoints()

local layerTitle = createLayer()
local font = loadFont('Play-Bold', 14) 
setDefaultFillColor(layerTitle, Shape_Text, 0.1, 0.1, 0.2, 1) 
addBox(layerTitle, 30, ry-64, 220, 32)
addText(layerTitle, font, "S C A P E . . . . .", 42, ry-42)

requestAnimationFrame(1)

--[[ Some dude named Bonusaben made this ]]--
--[[   Come visit the Underdun Arcade    ]]--
