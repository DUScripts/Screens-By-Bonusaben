--[[ Amazed ]]--

if not init then
    init = true
    
    rx, ry = getResolution()
    mx,my = getCursor()
    
    cols = 64 -- 64
    rows = 32 -- 32
    
    pPos = {math.floor(cols/8),math.floor(rows/2)}
    ePos   = {math.floor(cols-cols/8),math.floor(rows/2)}
    
    gameWin = false
    
    cSize = ry*0.8/rows
    
    cells = {}
    stack = {}
    numVisited = 0
    mazeReady = false
    
    maxWalks = 500
    numWalks = 0

    
    function CreateCells()
        for x=1,cols do
            cells[x] = {}
            for y=1,rows do
                cell = {}
                cell.x = rx/2+(x-1)*cSize-cols/2*cSize
                cell.y = ry*0.45+(y-1)*cSize-rows/2*cSize
                cell.walls = {true,true,true,true} -- r,d,l,u
                cell.v = false
                cells[x][y] = cell
                end
            end
        end
    
    function CellWalk(x,y)
        numWalks = numWalks + 1
        
        if numWalks >= maxWalks then
            numWalks = 0
            return
            end
        
        if cells[x][y].v == false then
            cells[x][y].v = true
            numVisited = numVisited + 1
            table.insert(stack,{x,y})
            else
            table.remove(stack)
            end
        
        if numVisited == cols*rows then
            mazeReady = true
            return
        end
        
        -- get unvisited neighbors
        local uvNeighbors = {}
        
        if x < cols then
            if cells[x+1][y].v == false then
                table.insert(uvNeighbors,{x+1,y})
                end
            end
        
        if y < rows then
            if cells[x][y+1].v == false then
                table.insert(uvNeighbors,{x,y+1})
                end
            end
        
        if x > 1 then
            if cells[x-1][y].v == false then
                table.insert(uvNeighbors,{x-1,y})
                end
            end
        
        if y > 1 then
            if cells[x][y-1].v == false then
                table.insert(uvNeighbors,{x,y-1})
                end
            end
        
        -- if number of unvisited neighbors > 0, move to a random one
        if #uvNeighbors > 0 then
            local r = math.floor(math.random(#uvNeighbors))
            
            --open walls on both
            if uvNeighbors[r][1] == x+1 then --right
                cells[x][y].walls[1] = false
                cells[x+1][y].walls[3] = false
                
            elseif uvNeighbors[r][2] == y+1 then --down
                cells[x][y].walls[2] = false
                cells[x][y+1].walls[4] = false
            
            elseif uvNeighbors[r][1] == x-1 then --left
                cells[x][y].walls[3] = false
                cells[x-1][y].walls[1] = false
                
            elseif uvNeighbors[r][2] == y-1 then --up
                cells[x][y].walls[4] = false
                cells[x][y-1].walls[2] = false
                
                end
            
            CellWalk(uvNeighbors[r][1],uvNeighbors[r][2])
            
            return
            else
        
            -- else, move backwards
            local _x = stack[#stack][1]
            local _y = stack[#stack][2]
            --table.remove(stack)
            CellWalk(_x,_y)
            return
            end
        
        end
    
    function DrawCells()
        for x=1,cols do
            for y=1,rows do
                cell = cells[x][y]
                --base
                if cell.v then
                    --setNextFillColor(l,0.3+0.2*((x+y)%2),0.3+0.2*((x+y)%2),0.3+0.2*((x+y)%2),1)
                    --local v = (cell.walls[1] and 1 or 0) + (cell.walls[2] and 1 or 0) + (cell.walls[3] and 1 or 0) + (cell.walls[4] and 1 or 0)
                    --v = 0.6-v/16
                    --setNextFillColor(l,v,v,v,1)
                    --addBox(l,cell.x,cell.y,cSize,cSize)
                    end
            
                --walls -- r,d,l,u
                if cell.walls[1] then --right
                    addLine(l,cell.x+cSize,cell.y,cell.x+cSize,cell.y+cSize)
                    end
                if cell.walls[2] then --down
                    addLine(l,cell.x,cell.y+cSize,cell.x+cSize,cell.y+cSize)
                    end
                if cell.walls[3] then --left
                    addLine(l,cell.x,cell.y,cell.x,cell.y+cSize)
                    end
                if cell.walls[4] then --up
                    addLine(l,cell.x,cell.y,cell.x+cSize,cell.y)
                    end
                
                end
            end
        
        
        --draw exit
        x = cells[ePos[1]][ePos[2]].x
        y = cells[ePos[1]][ePos[2]].y
        setNextFillColor(l,1,0.3,0.3,1)
        addBox(l,x,y,cSize,cSize)
        end
    
    function NewMaze()
        cells = {}
        stack = {}
        numVisited = 0
        mazeReady = false
        gameWin = false
        pPos = {math.floor(cols/8),math.floor(rows/2)}
        loaded = nil
        end
    
    function CheckWin()
        if pPos[1] == ePos[1] and pPos[2] == ePos[2] then
           gameWin = true
            end
        end
    
    function GetMag(posA, posB)
        local d = (posB[1]-posA[1])*(posB[1]-posA[1]) + (posB[2]-posA[2])*(posB[2]-posA[2])
        return math.sqrt(d)
        end
    
    end -- init

if not Dragable then
    local dragable = {}
    dragable.__index = dragable
    
    function Dragable(layer,x,y,dragSize)
        local self = {}
        self.layer = layer or 1
        self.x = x or 0
        self.y = y or 0
        self.dragSize = dragSize or 0
        self.doDrag = false
        return setmetatable(self,dragable)
        end
    
    function dragable:draw()
        local cd = getCursorDown()
        local mx, my = getCursor()
        local x = cells[pPos[1]][pPos[2]].x+cSize/2
        local y = cells[pPos[1]][pPos[2]].y+cSize/2
        local mag = GetMag({x,y},{mx,my})
        if mag < self.dragSize and mag > cSize*0.75 and cd then
            self.doDrag = true
            else
            self.doDrag = false
            end
        
        if self.doDrag then
            local mDir = {0,0}
            mDir[1] = mx-x
            mDir[2] = my-y
            local moveDir = 0
            
            -- get dir to move
            if math.abs(mDir[1]) > math.abs(mDir[2]) then
                if mDir[1] > 0 then -- move right
                    moveDir = 1
                    else -- move left
                    moveDir = 3
                    end
            else
                if mDir[2] > 0 then -- move down
                    moveDir = 2
                    else -- move up
                    moveDir = 4
                    end
                end
            
            --move
            if moveDir > 0 then
                self:Move(moveDir)
                end
            
            end
        
        --draw player
        local x = cells[pPos[1]][pPos[2]].x+cSize/2
        local y = cells[pPos[1]][pPos[2]].y+cSize/2
        setNextFillColor(l,0.3,1,0.3,1)
        if self.doDrag then
            setNextFillColor(l,0.8,1,0.8,1)
            end
        addCircle(l,x,y,5)
        
        setNextFillColor(l,0,0,0,0)
        setNextStrokeColor(l,0.3,1,0.3,1)
        setNextStrokeWidth(l,1)
        addCircle(l,x,y,self.dragSize)
        
        end -- draw
    
    function dragable:Move(d)
        -- 1 r, 2 d, 3 l, 4 u
        if d == 1 and cells[pPos[1]][pPos[2]].walls[1] == false then
            --move right
            pPos[1] = pPos[1]+1
        elseif d == 2 and cells[pPos[1]][pPos[2]].walls[2] == false then
            --move down
            pPos[2] = pPos[2]+1
        elseif d == 3 and cells[pPos[1]][pPos[2]].walls[3] == false then
            --move left
            pPos[1] = pPos[1]-1
        elseif d == 4 and cells[pPos[1]][pPos[2]].walls[4] == false then
            --move up
            pPos[2] = pPos[2]-1
            end
        end
    
    end -- Dragable

if not Button then
    local button = {}
    button.__index = button
    
    function Button(layer,x,y,width,height,label,action)
        self = {}
        self.layer = layer or 0
        self.x = x or 0
        self.y = y or 0
        self.w = width or 20
        self.h = height or 10
        self.label = label or ""
        self.action = action
        return setmetatable(self,button)
        end
    
    function button:draw()
        local click = getCursorReleased()
        
        if mx > self.x and mx < self.x+self.w and my > self.y and my < self.y+self.h then
            if click then
                self.action()
                end
            setNextFillColor(self.layer,0.7,0.7,0.7,1)
            else
            setNextFillColor(self.layer,1,1,1,1)
            end
        
        addBox(self.layer,self.x,self.y,self.w,self.h)
        local font = loadFont("Montserrat",self.w/8)
        setNextFillColor(self.layer,0,0,0,1)
        setNextTextAlign(self.layer, AlignH_Center, AlignV_Middle)
        addText(self.layer,font,self.label,self.x+self.w/2,self.y+self.h/2)
        
        end
    
    end --button



if not loaded then
    loaded = 1
    CreateCells()
    
    --layer,x,y,width,height,label,action
    NewMazeButton = Button(l,rx/2-50,ry-64,100,32,"NEW MAZE",NewMaze) 
    Player = Dragable(l,pPos[1],pPos[2],50)
    
    requestAnimationFrame(3)
    end

if loaded == 1 then
    while not mazeReady do
        if #stack > 0 then
            --logMessage("Max walks reached, running again")
            CellWalk(stack[#stack][1],stack[#stack][2])
            else
            --logMessage("Initial run")
            CellWalk(1,1)
            end
        requestAnimationFrame(3)
        end
    
    logMessage("Maze ready")
    loaded = loaded + 1
    
    end

--Rendering
l = createLayer()
l2 = createLayer()
font = loadFont('Play-Bold', 14)
setBackgroundColor(0.0,0.08,0.16)
--setBackgroundColor(1.0,0.2,0.2)
--setBackgroundColor(0.5,0.13,0.16)
    
setDefaultStrokeColor(l,Shape_Line,1,1,1,1)
setDefaultStrokeWidth(l,Shape_Line,2)
--setDefaultFillColor(l,Shape_Box, 0.8, 0.8, 1, 1)

mx,my = getCursor()
--cr = getCursorReleased()
--cd = getCursorDown()


DrawCells()

CheckWin()

if not gameWin then
    Player:draw()
    end

NewMazeButton:draw()

setNextTextAlign(l, AlignH_Center, AlignV_Middle)
addText(l,font,"Drag the green dot to the exit",rx/2,18)

if gameWin then
    local w = 200
    local h = 50
    setNextFillColor(l2,1,1,1,1)
    setNextStrokeColor(l2,0.0,0.08,0.16,1)
    setNextStrokeWidth(l2,10)
    addBox(l2,rx/2-w/2,ry/2-h/2,w,h)
    
    setNextFillColor(l2,0.0,0.08,0.16,1)
    loadingFont = loadFont('Play-Bold', 22)
    setNextTextAlign(l2, AlignH_Center, AlignV_Middle)
    addText(l2,loadingFont,"Y O U  W I N !",rx/2,ry/2)
    end

-- TITLE
local layerTitle = createLayer()
local font = loadFont('Play-Bold', 14) 
setDefaultFillColor(layerTitle, Shape_Text, 0.1, 0.1, 0.2, 1) 
addBox(layerTitle, 30, ry-64, 220, 32)
addText(layerTitle, font, "A M A Z E D . . .", 42, ry-42)


requestAnimationFrame(1)

--[[ Some dude named Bonusaben made this ]]--
--[[   Come visit the Underdun Arcade    ]]--
