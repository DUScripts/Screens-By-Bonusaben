--[[ Life ]]--


--[[ init ]]--

if not init then
    init = true
    
    rx, ry = getResolution()
        
    rows = 50
    cols = 80
    cellw = rx/cols
    cellh = ry/rows
    cells = {}
    cellsTmp = {}
    
    for i=1,cols do
        cells[i] = {}
        cellsTmp[i] = {}
        for j=1,rows do
            cells[i][j] = math.random(2)-1
            cellsTmp[i][j] = cells[i][j]
            end
        end
    
    function DrawCells()
        for i=1,cols do
            for j=1,rows do
                if cells[i][j] == 1 then
                    --addBox(layer1,-cellw+i*cellw,-cellh+j*cellh,cellw-1,cellh-1)
                    setNextFillColor(layer1, cells[i][j], 0, 0, 1) 
                    addCircle(layer1,-cellw+i*cellw,-cellh+j*cellh,2)
                    end
                end
            end
        end
    
    function UpdateCells()
        for i=1,cols do
            for j=1,rows do
                local state = cells[i][j]
                local neighbors = CountNeighbors(i,j)
                
                -- state 0
                if state == 0 then
                    
                    if neighbors == 3 then
                        state = 1
                        end
                    
                    else
                -- state 1
                    if neighbors < 2 or neighbors > 3 then
                        state = 0
                        end                        
                    
                    end
                
                cellsTmp[i][j] = state
                
                end
            end
        
        cells = Copy2dArr(cellsTmp)
        
        end
    
    function CountNeighbors(x,y)
        local sum = 0
        for i=-1,1 do
            for j=-1,1 do
                local col = (x+i+cols-1) % cols
                local row = (y+j+rows-1) % rows
                
                sum = sum + cells[col+1][row+1]
                end
            end
        sum = sum - cells[x][y]
        return sum
        end
    
    function Copy2dArr(arr)
        local newArr = {}
        for i=1,#arr do
            newArr[i] = {}
            for j=1,#arr[i] do
                newArr[i][j] = arr[i][j]
                end
            end
        return newArr
        end
    
    end

--[[ rendering ]]--
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


addBox(layerTitle, 30, ry-64, 220, 32)
addText(layerTitle, font, "L I F E . . . . . .", 42, ry-42)

requestAnimationFrame(2)





--[[ Some dude named Bonusaben made this ]]--
--[[   Come visit the Underdun Arcade    ]]--
