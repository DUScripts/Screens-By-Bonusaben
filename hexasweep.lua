--[[ Hexasweep ]]--

if not init then
    init = true
    
    rx, ry = getResolution()
    
    gridSize = 10 -- number of hexes to each side
    hexSize = (ry*0.6)/(gridSize*2+1)
    bombs = gridSize*5
    
    numRevealed = 0
    
    col1 = {228/255,239/255,240/255} --standard tile
    col2 = {78/255,121/255,136/255} --revealed tile
    col3 = {0.1,0.0,0.0} --revealed bomb
    col4 = {0/255,36/255,57/255} --empty tile
    col5 = {120/255,204/255,226/255} --highlight
    
    xV = {math.cos(math.rad(30)),math.sin(math.rad(30))}
    yV = {math.cos(math.rad(150)),math.sin(math.rad(150))}
    zV = {math.cos(math.rad(270)),math.sin(math.rad(270))}
    
    hexagons = {}
    
    function CreateGrid()
        for x=-gridSize,gridSize,1 do
            for y=-gridSize,gridSize,1 do
                for z=-gridSize,gridSize,1 do
                    if (x+y+z) == 0 then
                        hex = {}
                        hex.id = {x,y,z}
                        hex.pos = {}
                        hex.pos[1] = (x*xV[1]) + (y*yV[1]) + (z*zV[1])
                        hex.pos[2] = (x*xV[2]) + (y*yV[2]) + (z*zV[2])
                        hex.val = 0
                        hex.revealed = false
                        hex.neighbors = {}
                        table.insert(hexagons,hex)
                        end
                    end
                end
            end        
        end -- CreateGrid()
    
    
    function DrawGrid()
        for _,hex in ipairs(hexagons) do
            local x = rx/2+hex.pos[1]*hexSize
            local y = ry/2+hex.pos[2]*hexSize
            local s = hexSize*0.9
            
            if hex.revealed == false then
                setNextFillColor(l,col1[1],col1[2],col1[3],1)
                addQuad(l, x,y, x,y+zV[2]*s, x+xV[1]*s,y-xV[2]*s, x-yV[1]*s,y+yV[2]*s)
                setNextFillColor(l,col1[1]*0.9,col1[2]*0.9,col1[3]*0.9,1)
                addQuad(l, x,y, x-xV[1]*s,y+xV[2]*s, x+yV[1]*s,y-yV[2]*s, x,y+zV[2]*s)
                setNextFillColor(l,col1[1]*0.8,col1[2]*0.8,col1[3]*0.8,1)
                addQuad(l, x,y, x-yV[1]*s,y+yV[2]*s, x,y-zV[2]*s,x-xV[1]*s,y+xV[2]*s)
                
                if GetMag({mx,my},{x,y}) < hexSize/2 then -- mouse is over the hex
                    setNextFillColor(l,col5[1],col5[2],col5[3],1)
                    addQuad(l, x,y, x,y+zV[2]*s, x+xV[1]*s,y-xV[2]*s, x-yV[1]*s,y+yV[2]*s)
                    setNextFillColor(l,col5[1]*0.9,col5[2]*0.9,col5[3]*0.9,1)
                    addQuad(l, x,y, x-xV[1]*s,y+xV[2]*s, x+yV[1]*s,y-yV[2]*s, x,y+zV[2]*s)
                    setNextFillColor(l,col5[1]*0.8,col5[2]*0.8,col5[3]*0.8,1)
                    addQuad(l, x,y, x-yV[1]*s,y+yV[2]*s, x,y-zV[2]*s,x-xV[1]*s,y+xV[2]*s)
                    if getCursorReleased() and not gameWin then
                        Reveal(hex)
                        end
                    end
                
                else
                
                --revealed tiles
                if hex.val == -1 then -- bomb
                    setNextFillColor(l,col3[1],col3[2],col3[3],1)
                    addQuad(l, x,y, x,y+zV[2]*s, x+xV[1]*s,y-xV[2]*s, x-yV[1]*s,y+yV[2]*s)
                    setNextFillColor(l,col3[1]*0.9,col3[2]*0.9,col3[3]*0.9,1)
                    addQuad(l, x,y, x-xV[1]*s,y+xV[2]*s, x+yV[1]*s,y-yV[2]*s, x,y+zV[2]*s)
                    setNextFillColor(l,col3[1]*0.8,col3[2]*0.8,col3[3]*0.8,1)
                    addQuad(l, x,y, x-yV[1]*s,y+yV[2]*s, x,y-zV[2]*s,x-xV[1]*s,y+xV[2]*s)
                    elseif hex.val == 0 then -- empty
                    setNextFillColor(l,col4[1],col4[2],col4[3],1)
                    addQuad(l, x,y, x,y+zV[2]*s, x+xV[1]*s,y-xV[2]*s, x-yV[1]*s,y+yV[2]*s)
                    setNextFillColor(l,col4[1]*0.9,col4[2]*0.9,col4[3]*0.9,1)
                    addQuad(l, x,y, x-xV[1]*s,y+xV[2]*s, x+yV[1]*s,y-yV[2]*s, x,y+zV[2]*s)
                    setNextFillColor(l,col4[1]*0.8,col4[2]*0.8,col4[3]*0.8,1)
                    addQuad(l, x,y, x-yV[1]*s,y+yV[2]*s, x,y-zV[2]*s,x-xV[1]*s,y+xV[2]*s)
                    else -- numbered tiles
                    local v = hex.val/12
                    setNextFillColor(l,col2[1]+v,col2[2]-v,col2[3]-v,1)
                    addQuad(l, x,y, x,y+zV[2]*s, x+xV[1]*s,y-xV[2]*s, x-yV[1]*s,y+yV[2]*s)
                    setNextFillColor(l,col2[1]*0.9+v,col2[2]*0.9-v,col2[3]*0.9-v,1)
                    addQuad(l, x,y, x-xV[1]*s,y+xV[2]*s, x+yV[1]*s,y-yV[2]*s, x,y+zV[2]*s)
                    setNextFillColor(l,col2[1]*0.8+v,col2[2]*0.8-v,col2[3]*0.8-v,1)
                    addQuad(l, x,y, x-yV[1]*s,y+yV[2]*s, x,y-zV[2]*s,x-xV[1]*s,y+xV[2]*s)
                    
                    setNextFillColor(l2,1,1,1,1)
                    setNextTextAlign(l2, AlignH_Center, AlignV_Middle)
                    addText(l2,font,hex.val,x,y)
                    end
                
                end
            
            end
        end -- DrawGrid()
    
    function SetNeighbors(ind)
        local n = {}
        n[1] = { 1,-1, 0}
        n[2] = { 1, 0,-1}
        n[3] = { 0, 1,-1}
        n[4] = {-1, 1, 0}
        n[5] = {-1, 0, 1}
        n[6] = { 0,-1, 1}
        
        for index=ind,ind+5 do
            if index <= #hexagons then
                for i=1,#hexagons do
                    for j=1,6 do
                        if  hexagons[index].id[1] == hexagons[i].id[1] + n[j][1]
                        and hexagons[index].id[2] == hexagons[i].id[2] + n[j][2]
                        and hexagons[index].id[3] == hexagons[i].id[3] + n[j][3] then
                            table.insert(hexagons[index].neighbors,i)
                            end
                        end
                    end
                end
            end
        
        end -- SetNeighbors
    
    function CreateBombs()
        local b = 0
        if not randSeed then
            randSeed = math.random()*123.123
            
            else
            randSeed = math.random()*123.023
            
            end
        math.randomseed(randSeed)
        
        while b < bombs do
            
            local r = math.floor(math.random(#hexagons))
            if hexagons[r].val ~= -1 then
                hexagons[r].val = -1
                for _,n in ipairs(hexagons[r].neighbors) do
                    if hexagons[n].val ~= -1 then
                        hexagons[n].val = hexagons[n].val + 1
                        end
                    end
                b=b+1
                end
            end
        end
    
    function Reveal(hex)
        if hex.val == -1 then -- hex is a bomb
            --end game
            for _,h in ipairs(hexagons) do
                h.revealed = true
                end
            return
            end
        
        if hex.val == 0 then -- hex has no neighboring bombs
            --flood fill
            hex.revealed = true
            numRevealed = numRevealed + 1
            for n=1,#hex.neighbors do
                if not hexagons[hex.neighbors[n]].revealed then
                    Reveal(hexagons[hex.neighbors[n]])
                    end
                end
            return
            end
        
        hex.revealed = true
        numRevealed = numRevealed + 1
        
        end --reveal
    
    function NewGame()
        logMessage("Generating new grid...")
        loadLevel = 1
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
                
--    CreateGrid()
--    CreateBombs()
--    SetNeighbors()
    
    end -- init


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
            setNextFillColor(self.layer,col5[1],col5[2],col5[3],1)
            else
            setNextFillColor(self.layer,col1[1],col1[2],col1[3],1)
            end
        
        addBox(self.layer,self.x,self.y,self.w,self.h)
        local font = loadFont("Montserrat",self.w/8)
        setNextFillColor(self.layer,col4[1],col4[2],col4[3],1)
        setNextTextAlign(self.layer, AlignH_Center, AlignV_Middle)
        addText(self.layer,font,self.label,self.x+self.w/2,self.y+self.h/2)
        
        end
    
    end --button

if not Slider then
    local slider = {}
    slider.__index = slider
    function Slider(layer,x,y,width,length,min,max,defaultValue,label)
        self = {}
        self.layer = layer or 0
        self.x = x or 0
        self.y = y or 0
        self.l = length or 100
        self.w = width or 20
        self.min = min or 0
        self.max = max or 1
        self.value = math.max(self.min,math.min(self.max,defaultValue)) or self.min
        self.label = label or ""
        self.doDrag = false
        return setmetatable(self, slider)
    end
    
    function slider:getFraction()
        return (self.value-self.min)/(self.max-self.min)
    end
    
    function slider:setValue(val)
        self.value = math.floor(math.max(self.min,math.min(self.max,val)))
    end
    
    function slider:draw()
        local cx,cy = getCursor()
        local cd = getCursorDown()
        
        if cd and cx >= self.x and cx <= (self.x+self.w) and cy >= self.y+self.l-(self:getFraction()*self.l) and cy <= self.y+(self.w/5)+self.l-(self:getFraction()*self.l)+(2*self.w/5) then
            self.doDrag = true
        elseif cd == false or cx == -1 then
            self.doDrag = false
        end
    
        if self.doDrag then
            local vy = 1-((cy-self.y-self.w/5)/self.l)
            self.value = math.floor(math.max(self.min,math.min(self.max,self.min+((self.max-self.min)*vy))))
        end
        
        setNextFillColor(self.layer,col2[1],col2[2],col2[3],1)
        addBox(self.layer,self.x+(self.w/2.5),self.y+self.w/5,self.w/6,self.l) -- line
        setNextFillColor(self.layer,col1[1],col1[2],col1[3],1)
        addBox(self.layer,self.x,self.y+self.l-(self:getFraction()*self.l),self.w,self.w/2.5) -- drag box
        -- add some labels for knowing whats what
        local font = loadFont("Montserrat",self.w/3)
        local tw,th = getTextBounds(font, self.label)
        local vw,vh = getTextBounds(font, math.floor(self.value))
        addText(self.layer,font,self.label,self.x+(self.w/2)-(tw/2),self.y-(th*0.5))
        --setNextFillColor(self.layer,0.1,0.1,0.1,1)
        --addText(self.layer,font,math.floor(self.value),self.x+(self.w/2)-(vw/2),self.y+self.l-(self:getFraction()*self.l)+(self.w/5)+(vh/2))
        --addText(self.layer,font,math.floor(self.value*100)*0.01,self.x+(self.w/2)-(vw/2),self.y+self.l-(self:getFraction()*self.l)+(self.w/5)+(vh/2))
    end
        
end --slider


--Loading
if not loadLevel then
    loadLevel = 1
    
    tilesSlider = Slider(exampleLayer,rx-100,ry/8,30,120,3,18,10,"TILES")
    bombsSlider = Slider(exampleLayer,rx-150,ry/8,30,120,3,8,5,"BOMBS")
    newGameButton = Button(l,rx-150,ry*0.38,80,20,"NEW GAME",NewGame)
    
    requestAnimationFrame(3)
    end

if loadLevel == 1 then
    gameReady = false
    gameWin = false
    gridSize = tilesSlider.value
    bombs = gridSize*bombsSlider.value
    numRevealed = 0
    hexagons = {}
    hexSize = (ry*0.6)/(gridSize*2+1)
    index = nil
    
    CreateGrid()
    loadLevel = loadLevel +1
    requestAnimationFrame(3)
    end

if loadLevel == 2 then
    if not index then
        index = 1
        else
        index = index+6
        end
    
    SetNeighbors(index)
    
    if index >= #hexagons then
        loadLevel = loadLevel +1
        requestAnimationFrame(3)
        end
    
    requestAnimationFrame(3)     

    end

if loadLevel == 3 then
    CreateBombs()
    loadLevel = loadLevel + 1
    requestAnimationFrame(3)
    end

if loadLevel == 4 then
    gameReady = true
    end

--Win check

if numRevealed == #hexagons-bombs then
    gameWin = true
    end

--Rendering
l = createLayer()
l2 = createLayer()
font = loadFont('Play-Bold', 24-gridSize)
setBackgroundColor(0/255,36/255,57/255,1)

setNextFillColor(l,0,0,0,0)
setNextStrokeColor(l,col5[1],col5[2],col5[3],0.25)
setNextStrokeWidth(l,6)
addCircle(l,rx/2,ry/2,rx/3.1)

setNextFillColor(l,0,0,0,0)
setNextStrokeColor(l,col5[1],col5[2],col5[3],0.5)
setNextStrokeWidth(l,4)
addCircle(l,rx/2,ry/2,rx/3.2)

setNextFillColor(l,0,0,0,0)
setNextStrokeColor(l,col5[1],col5[2],col5[3],0.75)
setNextStrokeWidth(l,2)
addCircle(l,rx/2,ry/2,rx/3.3)

mx,my = getCursor()

if gameReady then    
    DrawGrid()
    else
    loadingFont = loadFont('Play-Bold', 22)
    setNextTextAlign(l, AlignH_Center, AlignV_Middle)
    addText(l,loadingFont,"L O A D I N G . . .",rx/2,ry/2)
    end

if gameWin then
    local w = 200
    local h = 50
    setNextFillColor(l2,col1[1],col1[2],col1[3],1)
    setNextStrokeColor(l2,col4[1],col4[2],col4[3],1)
    setNextStrokeWidth(l2,4)
    addBox(l2,rx/2-w/2,ry/2-h/2,w,h)
    
    setNextFillColor(l2,col4[1],col4[2],col4[3],1)
    loadingFont = loadFont('Play-Bold', 22)
    setNextTextAlign(l2, AlignH_Center, AlignV_Middle)
    addText(l2,loadingFont,"Y O U  W I N !",rx/2,ry/2)
    end

tilesSlider:draw()
bombsSlider:draw()
newGameButton:draw()

--addText(l,font,"Tiles left: "..(#hexagons-numRevealed-bombs),50,50)

local layerTitle = createLayer()
local font = loadFont('Play-Bold', 14) 
setDefaultFillColor(layerTitle, Shape_Text, 0.1, 0.1, 0.2, 1) 
addBox(layerTitle, 30, ry-64, 220, 32)
addText(layerTitle, font, "H E X A S W E E P . . .", 42, ry-42)


requestAnimationFrame(1)

--[[ Some dude named Bonusaben made this ]]--
--[[   Come visit the Underdun Arcade    ]]--
