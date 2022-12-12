--[[ Imposter ]]--

--[[ init ]]--

if not init then
    init = true
    
    rx, ry = getResolution()

    counter = 10
    frameWait = 8 -- seconds
    
    bgpoints = {}
    bgpoints[1] = {0,0}
    bgpoints[2] = {0,0}
    bgpoints[3] = {0,0}
    bgpoints[4] = {0,0}
    midPoint = {rx/2,ry/2}
    shape = math.random(3)
    p1,p2,p3,p4 = {}
    cRadius = 100+math.random()*100
    shapeOffset = {0,0}
    shapeOffsetMul = 1
    
    col1 = {0.02,0.02,0.05}
    col2 = {0.9,0.9,0.8}
    col3 = {math.random(),math.random(),math.random()}
    
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
    
    function Rotate(point,ang,origin)
        --rotate point around origin by angle
        local vec = {}
        local o = origin or {0,0}
        vec[1] = math.cos(ang) * (point[1]-o[1]) - math.sin(ang) * (point[2]-o[2]) + o[1]
        vec[2] = math.sin(ang) * (point[1]-o[1]) + math.cos(ang) * (point[2]-o[2]) + o[2]
        return vec
        end
    
    function RotateGroup(points,ang,origin)
        --rotate a group of points around origin by angle
        local o = origin or {0,0}
        local group = {}
        for _,point in ipairs(points) do
            group[_] = {}
            group[_][1] = math.cos(ang) * (point[1]-o[1]) - math.sin(ang) * (point[2]-o[2]) + o[1]
            group[_][2] = math.sin(ang) * (point[1]-o[1]) + math.cos(ang) * (point[2]-o[2]) + o[2]
            end
        return group
        end
    
    function FindMidPoint(_a,_b)
        local m = {}
        m[1] = (_a[1]+_b[1])/2
        m[2] = (_a[2]+_b[2])/2
        return m
        end
    
    function SetColors()
        local c = math.random(5)
        if c == 1 then
            col1 = {0.02,0.02,0.05}
            col2 = {0.9,0.9,0.8}
            col3 = {math.random(),math.random(),math.random()}
            elseif r == 2 then
            col1 = {0.02,0.02,0.05}
            col3 = {0.9,0.9,0.8}
            col2 = {math.random(),math.random(),math.random()}
            elseif r == 3 then
            col2 = {0.02,0.02,0.05}
            col1 = {0.9,0.9,0.8}
            col3 = {math.random(),math.random(),math.random()}
            elseif r == 4 then
            col2 = {0.02,0.02,0.05}
            col3 = {0.9,0.9,0.8}
            col1 = {math.random(),math.random(),math.random()}
            elseif r == 5 then
            col3 = {0.02,0.02,0.05}
            col1 = {0.9,0.9,0.8}
            col2 = {math.random(),math.random(),math.random()}
            else
            col3 = {0.02,0.02,0.05}
            col2 = {0.9,0.9,0.8}
            col1 = {math.random(),math.random(),math.random()}
            end
        end
    
    function CreateShapes()
        --pick edge
        local r = math.random(4)
        if r == 1 then --up
            bgpoints[1] = {0,0}
            bgpoints[2] = {rx,0}
            bgpoints[3] = {rx,ry*math.random()}
            bgpoints[4] = {0,ry*math.random()}
            shapeOffset = {50*(-1+math.random()*2),-50+math.random()*-50}
        elseif r == 2 then --right
            bgpoints[1] = {rx,0}
            bgpoints[2] = {rx,ry}
            bgpoints[3] = {rx*math.random(),ry}
            bgpoints[4] = {rx*math.random(),0}
            shapeOffset = {50+math.random()*50,50*(-1+math.random()*2)}
        elseif r == 3 then --down
            bgpoints[1] = {rx,ry}
            bgpoints[2] = {0,ry}
            bgpoints[3] = {0,ry*math.random()}
            bgpoints[4] = {rx,ry*math.random()}
            shapeOffset = {50*(-1+math.random()*2),50+math.random()*50}
        else --left
            bgpoints[1] = {0,ry}
            bgpoints[2] = {0,0}
            bgpoints[3] = {rx*math.random(),0}
            bgpoints[4] = {rx*math.random(),ry}
            shapeOffset = {-50+math.random()*-50,50*(-1+math.random()*2)}
            end
        
        midPoint = FindMidPoint(bgpoints[3],bgpoints[4])
        
        --pick shape
        shape = math.random(2)
        if shape == 1 then --rectangle
            local w = 75+math.random()*75
            local h = 75+math.random()*75
            local ang = math.random()*2*math.pi
            p1 = Rotate({midPoint[1]-w,midPoint[2]-h},ang,{midPoint[1],midPoint[2]})
            p2 = Rotate({midPoint[1]+w,midPoint[2]-h},ang,{midPoint[1],midPoint[2]})
            p3 = Rotate({midPoint[1]+w,midPoint[2]+h},ang,{midPoint[1],midPoint[2]})
            p4 = Rotate({midPoint[1]-w,midPoint[2]+h},ang,{midPoint[1],midPoint[2]})
        else --circle
            cRadius = 50+math.random()*50
            end
        
        end
    
    function DrawShapes(_layer)
        -- Background
        setNextFillColor(_layer,col2[1],col2[2],col2[3],1)
        addQuad(_layer,bgpoints[1][1],bgpoints[1][2],bgpoints[2][1],bgpoints[2][2],bgpoints[3][1],bgpoints[3][2],bgpoints[4][1],bgpoints[4][2])
        
        --shape1
        setNextFillColor(_layer+1,col1[1],col1[2],col1[3],1)
        if shape == 1 then --rectangle
            addQuad(_layer+1,p1[1]+shapeOffset[1]*shapeOffsetMul, p1[2]+shapeOffset[2]*shapeOffsetMul, p2[1]+shapeOffset[1]*shapeOffsetMul, p2[2]+shapeOffset[2]*shapeOffsetMul, p3[1]+shapeOffset[1]*shapeOffsetMul, p3[2]+shapeOffset[2]*shapeOffsetMul,p4[1]+shapeOffset[1]*shapeOffsetMul,p4[2]+shapeOffset[2]*shapeOffsetMul)
            else --circle
            addCircle(_layer+1,midPoint[1]+shapeOffset[1]*shapeOffsetMul,midPoint[2]+shapeOffset[2]*shapeOffsetMul,cRadius)
            end
        --shape2
        setNextFillColor(_layer+1,col2[1],col2[2],col2[3],1)
        if shape == 1 then --rectangle
            addQuad(_layer+1,p1[1]+shapeOffset[1]*shapeOffsetMul*-1, p1[2]+shapeOffset[2]*shapeOffsetMul*-1, p2[1]+shapeOffset[1]*shapeOffsetMul*-1, p2[2]+shapeOffset[2]*shapeOffsetMul*-1, p3[1]+shapeOffset[1]*shapeOffsetMul*-1, p3[2]+shapeOffset[2]*shapeOffsetMul*-1,p4[1]+shapeOffset[1]*shapeOffsetMul*-1,p4[2]+shapeOffset[2]*shapeOffsetMul*-1)
            else --circle
            addCircle(_layer+1,midPoint[1]+shapeOffset[1]*shapeOffsetMul*-1,midPoint[2]+shapeOffset[2]*shapeOffsetMul*-1,cRadius)
            end
        --shape3
        setNextFillColor(_layer+1,col3[1],col3[2],col3[3],1)
        if shape == 1 then --rectangle
            addQuad(_layer+1,p1[1], p1[2], p2[1], p2[2], p3[1], p3[2],p4[1],p4[2])
            else --circle
            addCircle(_layer+1,midPoint[1],midPoint[2],cRadius)
            end
        end
    
    end

--[[ rendering ]]--
layer1 = createLayer()
layer2 = createLayer()

setBackgroundColor(col1[1],col1[2],col1[3])

if not loaded then
    loaded = true
    
    end

if counter > frameWait then
    counter = 0
    SetColors()
    CreateShapes()
    DrawShapes(layer1)
    else
    shapeOffsetMul = (counter/frameWait) * (counter/frameWait) * (3.0 - 2.0 * (counter/frameWait))
    DrawShapes(layer1)
    counter = counter + 1*getDeltaTime()
    end


layerTitle = createLayer()
font = loadFont('Play-Bold', 14) 
setDefaultFillColor(layerTitle, Shape_Text, 0.1, 0.1, 0.2, 1) 
addBox(layerTitle, 30, ry-64, 220, 32)
addText(layerTitle, font, "I M P O S T E R . . . . .", 42, ry-42)

requestAnimationFrame(1)






--[[ Some dude named Bonusaben made this ]]--
--[[   Come visit the Underdun Arcade    ]]--

--[[ Some dude named Bonusaben made this ]]--
--[[   Come visit the Underdun Arcade    ]]--
