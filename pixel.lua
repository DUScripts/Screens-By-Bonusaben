--[[ Pixel ]]--


--[[ init ]]--

if not init then
    init = true
    
    rx, ry = getResolution()

    
    cols = 88
    rows = 42
    pixelW = 10
    pixels = {}
    pickers = {}
    buttons = {}
    
    xOffset = rx/2-(cols/2)*pixelW-pixelW/2
    yOffset = ry/2-(rows/2)*pixelW-pixelW/2
    
    selCol = {1,0,0}
    col1 = {0.2,0.2,0.2}
    col2 = {0.5,0.5,0.5}
    drawGrid = false
    thick = false
    
    drawMode = 1 -- button index (1 pen, 2 line, 3 circle, 4 fill)
    thickness = 5 -- 5, 20
    thickness1 = 5
    thickness2 = 18
    
    startPoint = {0,0}
    endPoint = {}
    
    function CreatePixels()
        for i=1,cols do
            pixels[i] = {}
            for j=1,rows do
                pixels[i][j] = {}
                pixels[i][j].pos = {xOffset+i*pixelW,yOffset+j*pixelW}
                pixels[i][j].col = {1,1,1}
                end
            end
        end
    
    function CreatePickers()
        for i=1,17 do
            picker = {}
            picker.pos = {xOffset+i*pixelW*2,30}
            picker.col = {0,1,0}
            pickers[i] = picker
            end
        
        pickers[1].col = {0.0,0.0,0.0}
        pickers[2].col = {0.25,0.25,0.25}
        pickers[3].col = {0.5,0.5,0.5}
        pickers[4].col = {0.75,0.75,0.75}
        pickers[5].col = {1.0,1.0,1.0}
        
        pickers[6].col =  {1.0,0.0,0.0}
        pickers[7].col =  {1.0,0.5,0.0}
        pickers[8].col =  {1.0,1.0,0.0}
        pickers[9].col =  {0.5,1.0,0.0}
        pickers[10].col = {0.0,1.0,0.0}
        pickers[11].col = {0.0,1.0,0.5}
        pickers[12].col = {0.0,1.0,1.0}
        pickers[13].col = {0.0,0.5,1.0}
        pickers[14].col = {0.0,0.0,1.0}
        pickers[15].col = {0.5,0.0,1.0}
        pickers[16].col = {1.0,0.0,1.0}
        pickers[17].col = {1.0,0.0,0.5}
        
        end
    
    function DrawPixels()
        for i=1,cols do
            for j=1,rows do
                setNextFillColor(layer1, pixels[i][j].col[1],pixels[i][j].col[2],pixels[i][j].col[3],1)
                addBox(layer1,pixels[i][j].pos[1],pixels[i][j].pos[2],pixelW,pixelW)
                end
            end            
        end
    
    function DrawPickers()
        for i=1,#pickers do
            if i==1 then
                setNextStrokeColor(layer1,1,1,1,1)
                setNextStrokeWidth(layer1,1)
                end
            setNextFillColor(layer1, pickers[i].col[1],pickers[i].col[2],pickers[i].col[3],1)
            addBox(layer1,pickers[i].pos[1],pickers[i].pos[2],pixelW,pixelW)                
            end            
        end
    
    function CreateButtons()
        local topMar = 50
        local xOffset = rx/2-pixelW*cols/2
        local width = 60
        local height = 20
        
        -- pen
        button = {}
        button.name = "PEN"
        button.w = width
        button.h = height
        button.pos = {xOffset+(#buttons*(button.w+2)),topMar}
        button.col = col1
        table.insert(buttons,button)
        -- line
        button = {}
        button.name = "LINE"
        button.w = width
        button.h = height
        button.pos = {xOffset+(#buttons*(button.w+2)),topMar}
        button.col = col1
        table.insert(buttons,button)
        -- circle
        button = {}
        button.name = "CIRCLE"
        button.w = width
        button.h = height
        button.pos = {xOffset+(#buttons*(button.w+2)),topMar}
        button.col = col1
        table.insert(buttons,button)
        -- fill
        button = {}
        button.name = "FILL"
        button.w = width
        button.h = height
        button.pos = {xOffset+(#buttons*(button.w+2)),topMar}
        button.col = col1
        table.insert(buttons,button)
        -- spacer
        button = {}
        button.name = ""
        table.insert(buttons,button)
        -- thick
        button = {}
        button.name = "THICK"
        button.w = width
        button.h = height
        button.pos = {xOffset+(#buttons*(button.w+2)),topMar}
        button.col = col1
        table.insert(buttons,button)
        -- drawGrid
        button = {}
        button.name = "GRID"
        button.w = width
        button.h = height
        button.pos = {xOffset+(#buttons*(button.w+2)),topMar}
        button.col = col1
        table.insert(buttons,button)
        -- clearScreen
        button = {}
        button.name = "CLEAR"
        button.w = width
        button.h = height
        button.pos = {xOffset+(#buttons*(button.w+2)),topMar}
        button.col = col1
        table.insert(buttons,button)
        
        end
    
    function DrawButtons()
        for _,button in ipairs(buttons) do
            if button.name == "" then
                
                else
                if _ == drawMode then
                    button.col = col2
                    end
                setNextFillColor(layer2, button.col[1],button.col[2],button.col[3],1)
                addBox(layer2, button.pos[1],button.pos[2],button.w,button.h)
                setNextTextAlign(layer2, AlignH_Center, AlignV_Middle)
                addText(layer2, font, button.name, button.pos[1]+button.w/2, button.pos[2]+button.h/2)
                end
            end
        end
    
    function DrawMouse()
        -- On buttons
        for _,button in ipairs(buttons) do
            if button.name == "" then
                
                else
                local x = button.pos[1]
                local y = button.pos[2]
                if IsPointWithinBox(mx,my,x,y,button.w,button.h) then
                    setNextFillColor(layer2, 0,0,0,0)
                    setNextStrokeColor(layer2,1,1,1,1)
                    setNextStrokeWidth(layer2,1)
                    addBox(layer2,button.pos[1],button.pos[2],button.w,button.h)
                    return
                    end
                end
            end
        -- On pickers
        for _,picker in ipairs(pickers) do
            local x = picker.pos[1]
            local y = picker.pos[2]
            if IsPointWithinBox(mx,my,x,y,pixelW,pixelW) then
                setNextFillColor(layer2, 0,0,0,0)
                setNextStrokeColor(layer2,1,1,1,1)
                setNextStrokeWidth(layer2,2)
                addBox(layer2,picker.pos[1],picker.pos[2],pixelW,pixelW)
                return
                end
            end
        -- On pixel board
        for i=1,cols do
            for j=1,rows do
                local x = pixels[i][j].pos[1]
                local y = pixels[i][j].pos[2]
                if IsPointWithinBox(mx,my,x,y,pixelW,pixelW) then
                    setNextFillColor(layer2, selCol[1],selCol[2],selCol[3],1)
                    
                    if drawMode == 1 then -- pen
                        addBox(layer2,pixels[i][j].pos[1],pixels[i][j].pos[2],pixelW,pixelW)
                        if thick then
                            local targetMag = GetMag(pixels[i][j].pos,{pixels[i][j].pos[1]+thickness,pixels[i][j].pos[2]})
                            for k=1,cols do
                                for l=1,rows do
                                    if (GetMag(pixels[i][j].pos,pixels[k][l].pos) < (targetMag+thickness)) then
                                        setNextFillColor(layer2, selCol[1],selCol[2],selCol[3],1)
                                        addBox(layer2,pixels[k][l].pos[1],pixels[k][l].pos[2],pixelW,pixelW)
                                        end
                                    end
                                end
                            end
                        end
                    
                    if drawMode == 2 then -- line
                        addBox(layer2,pixels[i][j].pos[1],pixels[i][j].pos[2],pixelW,pixelW)
                        if startPoint[1] > 0 then
                            for k=1,cols do
                                for l=1,rows do
                                    if (PointToLineDistance(startPoint,pixels[i][j].pos,pixels[k][l].pos) < thickness) then
                                        setNextFillColor(layer2, selCol[1],selCol[2],selCol[3],1)
                                        addBox(layer2,pixels[k][l].pos[1],pixels[k][l].pos[2],pixelW,pixelW)
                                        end
                                    end
                                end
                            end
                        end
                    
                    if drawMode == 3 then -- circle
                        addBox(layer2,pixels[i][j].pos[1],pixels[i][j].pos[2],pixelW,pixelW)
                        if startPoint[1] > 0 then
                            local targetMag = GetMag(startPoint,pixels[i][j].pos)
                            for k=1,cols do
                                for l=1,rows do
                                    if (GetMag(startPoint,pixels[k][l].pos) < (targetMag+thickness)) and (GetMag(startPoint,pixels[k][l].pos) > (targetMag-thickness)) then
                                        setNextFillColor(layer2, selCol[1],selCol[2],selCol[3],1)
                                        addBox(layer2,pixels[k][l].pos[1],pixels[k][l].pos[2],pixelW,pixelW)
                                        end
                                    end
                                end
                            end
                        end
                    
                    if drawMode == 4 then -- fill
                        addBox(layer2,pixels[i][j].pos[1],pixels[i][j].pos[2],pixelW,pixelW)
                        end
                    
                    return
                    end                
                end
            end
        end
    
    function ClearScreen()
        for i=1,cols do
            for j=1,rows do
                pixels[i][j].col = {1,1,1}
                end
            end
        end
    
    function IsPointWithinBox(px,py,x,y,w,h)
        return (px > x and px < (x + w) and py > y and py < (y + h))
        end
        
    function Click()
        -- Check if clicked button
        for _,button in ipairs(buttons) do
            if button.name == "" then
                
                else
                local x = button.pos[1]
                local y = button.pos[2]
                local w = button.w
                local h = button.h
                if IsPointWithinBox(mx,my,x,y,w,h) and getCursorPressed() then
                
                    if button.name == "CLEAR" then
                        ClearScreen()
                        startPoint = {0,0}
                        return
                        end
                
                    if button.name == "GRID" then -- grid button
                        drawGrid = not drawGrid
                        if drawGrid then
                            button.col = col2
                            else
                            button.col = col1
                            end
                        return
                        end
                    
                    if button.name == "THICK" then -- grid button
                        thick = not thick
                        if thick then
                            button.col = col2
                            thickness = thickness2
                            else
                            button.col = col1
                            thickness = thickness1
                            end
                        return
                        end
                    
                    for i=1,4 do
                        buttons[i].col = col1
                        end
                    
                    if button.name == "PEN" then
                        drawMode = 1
                        end
                    
                    if button.name == "LINE" then
                        drawMode = 2
                        startPoint = {0,0}
                        end
                    
                    if button.name == "CIRCLE" then
                        drawMode = 3
                        startPoint = {0,0}
                        end
                    
                    if button.name == "FILL" then
                        drawMode = 4
                        end
                    
                    logMessage("Drawmode set to: "..button.name)
                
                    return
                    end
                end
            end
        
        -- Check if clicked picker
        for i=1,#pickers do
            local x = pickers[i].pos[1]
            local y = pickers[i].pos[2]
            if IsPointWithinBox(mx,my,x,y,pixelW,pixelW) then
                selCol = pickers[i].col
                return
                end
            end
        
        -- Check if clicked pixel
        for i=1,cols do
            for j=1,rows do
                local x = pixels[i][j].pos[1]
                local y = pixels[i][j].pos[2]
                if IsPointWithinBox(mx,my,x,y,pixelW,pixelW) then
                    
                    if drawMode == 1 then -- pen
                        if thick then
                            DrawCircle({x,y},{x+thickness,y})
                            end
                            SetPixelColor(i,j)
                        end
                    
                    if drawMode == 2 then -- line
                        if startPoint[1] == 0 then
                            startPoint[1] = x
                            startPoint[2] = y
                            --logMessage("Startpoint set: "..x..","..y)
                            else
                            endPoint[1] = x
                            endPoint[2] = y
                            DrawLine(startPoint,endPoint)
                            startPoint[1] = x
                            startPoint[2] = y
                            end
                        end
                    
                    if drawMode == 3 then -- circle
                        if startPoint[1] == 0 then
                            startPoint[1] = x
                            startPoint[2] = y
                            --logMessage("Startpoint set: "..x..","..y)
                            else
                            endPoint[1] = x
                            endPoint[2] = y
                            DrawCircle(startPoint,endPoint)
                            startPoint = {0,0}
                            end
                        end
                    
                    if drawMode == 4 then -- fill
                        if pixels[i][j].col[1] == selCol[1] and pixels[i][j].col[2] == selCol[2] and pixels[i][j].col[3] == selCol[3] then
                            -- if pixel color and selected color are the same, it will do infinite loop
                            else
                            FloodFill(i,j,pixels[i][j].col[1],pixels[i][j].col[2],pixels[i][j].col[3])
                            end
                        end
                    
                    return
                    end
                end
            end
        end
    
    function DrawLine(p1,p2)
        --logMessage("Drawing line from: "..p1[1]..","..p1[2].." to: "..p2[1]..","..p2[2])
        for i=1,cols do
            for j=1,rows do
                if (PointToLineDistance(p1,p2,pixels[i][j].pos) < thickness) then
                    SetPixelColor(i,j)
                    end
                end
            end
        end
    
    function DrawCircle(p1,p2)
        local targetMag = GetMag(p1,p2)
        for i=1,cols do
            for j=1,rows do
                if (GetMag(p1,pixels[i][j].pos) < (targetMag+thickness)) and (GetMag(p1,pixels[i][j].pos) > (targetMag-thickness)) then
                    SetPixelColor(i,j)
                    --setNextFillColor(layer2, selCol[1],selCol[2],selCol[3],1)
                    --addBox(layer2,pixels[k][l].pos[1],pixels[k][l].pos[2],pixelW,pixelW)
                    end
                end
            end
        end
    
    function FloodFill(i,j,r,g,b)
        SetPixelColor(i,j)
        --get neighbors with same color
        --up
        if j > 1 then
            if pixels[i][j-1].col[1] == r and pixels[i][j-1].col[2] == g and pixels[i][j-1].col[3] == b then
                FloodFill(i,j-1,r,g,b)
                end                
            end
        
        --down
        if j < rows then
            if pixels[i][j+1].col[1] == r and pixels[i][j+1].col[2] == g and pixels[i][j+1].col[3] == b then
                FloodFill(i,j+1,r,g,b)
                end                
            end
        
        --left
        if i > 1 then
            if pixels[i-1][j].col[1] == r and pixels[i-1][j].col[2] == g and pixels[i-1][j].col[3] == b then
                FloodFill(i-1,j,r,g,b)
                end                
            end
        
        --right
        if i < cols then
            if pixels[i+1][j].col[1] == r and pixels[i+1][j].col[2] == g and pixels[i+1][j].col[3] == b then
                FloodFill(i+1,j,r,g,b)
                end                
            end
        
        end
    
    function SetPixelColor(i,j)
        pixels[i][j].col[1] = selCol[1]
        pixels[i][j].col[2] = selCol[2]
        pixels[i][j].col[3] = selCol[3]
        end
    
    function PointToLineDistance(A, B, E) 
        -- vector AB
        local AB = {}
        AB[1] = (B[1] - A[1])
        AB[2] = (B[2] - A[2])
 
        -- vector BE
        local BE = {}
        BE[1] = (E[1] - B[1])
        BE[2] = (E[2] - B[2])
 
        -- vector AE
        local AE = {}
        AE[1] = (E[1] - A[1])
        AE[2] = (E[2] - A[2])
 
        -- Variables to store dot product
        --AB_BE, AB_AE;
 
        -- Calculating the dot product
        local AB_BE = (AB[1] * BE[1] + AB[2] * BE[2])
        local AB_AE = (AB[1] * AE[1] + AB[2] * AE[2])
 
        -- Minimum distance from point E to the line segment
        local dist = 0;
 
        -- Case 1
        if (AB_BE > 0) then
            -- Finding the magnitude
            local y = E[2] - B[2]
            local x = E[1] - B[1]
            dist = math.sqrt(x * x + y * y)
        --end
 
        -- Case 2
        elseif (AB_AE < 0) then
            local y = E[2] - A[2]
            local x = E[1] - A[1]
            dist = math.sqrt(x * x + y * y)
        --end
 
        -- Case 3
        else 
            -- Finding the perpendicular distance
            local x1 = AB[1]
            local y1 = AB[2]
            local x2 = AE[1]
            local y2 = AE[2]
            local mod = math.sqrt(x1 * x1 + y1 * y1)
            dist = math.abs(x1 * y2 - y1 * x2) / mod
        end
    return dist;
    end

    function GetMag(posA, posB)
        local d = (posB[1]-posA[1])*(posB[1]-posA[1]) + (posB[2]-posA[2])*(posB[2]-posA[2])
        return math.sqrt(d)
        end
    
    CreatePixels()
    CreatePickers()
    CreateButtons()
    
    end


    --[[ rendering ]]--
layer1 = createLayer()
layer2 = createLayer()
layerTitle = createLayer()

--layerDebug = createLayer()

font = loadFont('Play-Bold', 14) 
--setDefaultFillColor(layer1, Shape_Circle, 1, 1, 0, 0.8) 
setDefaultFillColor(layer1, Shape_Box, 0.5, 0.5, 0.6, 1) 
--setDefaultFillColor(layer1, Shape_Line, 0.5, 0.5, 0.6, 1) 
--setDefaultFillColor(layerDebug, Shape_Text, 0.1, 0.1, 0.2, 1) 
setDefaultFillColor(layerTitle, Shape_Text, 0.1, 0.1, 0.2, 1) 

if drawGrid then
    setDefaultStrokeWidth(layer1, Shape_Box, 0.5)
    setDefaultStrokeColor(layer1, Shape_Box, 0.1, 0.1, 0.1, 1)
    end
    
    -- TITLE
addBox(layerTitle, 30, ry-64, 220, 32)
addText(layerTitle, font, "P I X E L . . . . .", 42, ry-42)
addText(layer1, font, "Images are not saved!", rx-240, 62)

mx, my = getCursor()
if(getCursorDown()) then
    Click()
    end

DrawPixels()
DrawPickers()
DrawButtons()
DrawMouse()


requestAnimationFrame(1)







--[[ Some dude named Bonusaben made this ]]--
--[[   Come visit the Underdun Arcade    ]]--
