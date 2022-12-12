--[[ Blinds ]]--

if not init then
    init = true
    rx, ry = getResolution()
    
    windowColor = {0.7,0.8,0.9}
    windowColor2 = {0.3,0.4,0.5}
    windowPosition = 0
    windowSpeed = 150
    
    boxHeight = 20
    blindOffset = 30
    numBlinds = ry/blindOffset
    maxHeightMod = 14
    minHeightMod = 0
    heightMod = 0
    
    end

-- UI COLORS
if not colors then -- for UI elements
    colors = {}
    colors[1] = {1.0,1.0,1.0,1.0} -- base color
    colors[2] = {0.2,0.2,0.2,1.0} -- accent color
    colors[3] = {1.0,1.0,1.0,0.5} -- faded color
    colors[4] = {0.0,1.0,0.0,1.0} -- on color
    colors[5] = {1.0,0.0,0.0,1.0} -- off color
    end

if not Toggle then
    local toggle = {}
    toggle.__index = toggle
    
    function Toggle(layer,x,y,width,height,label,defaultValue)
        local self = {}
        self.layer = layer or 0
        self.x = x or 0
        self.y = y or 0
        self.w = width or 20
        self.h = height or 10
        self.label = label or ""
        self.on = defaultValue or false
        self.toggle = function() self.on = not self.on end
        return setmetatable(self,toggle)
        end
        
    function toggle:draw()
        local hover = cx > self.x and cx < self.x+self.w and cy > self.y and cy < self.y+self.h
        
        if hover then
            if cr then
                self.toggle()
                end
            setNextFillColor(self.layer,colors[2][1],colors[2][2],colors[2][3],colors[2][4])
            else
            setNextFillColor(self.layer,colors[1][1],colors[1][2],colors[1][3],colors[1][4])
            end
        
        addBox(self.layer,self.x,self.y,self.w,self.h)
        
        local font = loadFont(uif,self.w/8)
        if hover then
            setNextFillColor(self.layer,colors[1][1],colors[1][2],colors[1][3],colors[1][4])
            else
            setNextFillColor(self.layer,colors[2][1],colors[2][2],colors[2][3],colors[2][4])
            end
        setNextTextAlign(self.layer, AlignH_Center, AlignV_Middle)
        addText(self.layer,font,self.label,self.x+self.w/2+self.h/4,self.y+self.h/2)
        
        --indicator
        if self.on then
            setNextFillColor(self.layer,colors[4][1],colors[4][2],colors[4][3],colors[4][4])
            else
            setNextFillColor(self.layer,colors[5][1],colors[5][2],colors[5][3],colors[5][4])
            end
        addCircle(self.layer,self.x+self.h/2,self.y+self.h/2,self.h/4)
        
        end
    
    end --Toggle


l = createLayer()

-- UI DEPENDANCIES    
uil = createLayer()
uif = "Montserrat"
cx, cy = getCursor()
cr = getCursorReleased()
cd = getCursorDown()


if not loaded then
    loaded = 1
    
    myToggle = Toggle(uil,20,ry-40,90,30,"Toggle",false)
    myTilt = Toggle(uil,120,ry-40,90,30,"Tilt",false)
    
    requestAnimationFrame(3)
    end


--Rendering
myToggle:draw()
myTilt:draw()



--Draw the blinds
for i=0,numBlinds do
    if i*blindOffset < windowPosition then
        setNextFillColor(l,windowColor[1],windowColor[2],windowColor[3],1.0)
        addBox(l,0,i*blindOffset+4,rx,boxHeight/2+heightMod)
        
        setNextFillColor(l,windowColor2[1],windowColor2[2],windowColor2[3],1.0)
        addBox(l,0,i*blindOffset,rx,boxHeight/6+heightMod/2)
        end
    end

if windowPosition > 0 then
    --Draw the "strings"
    setNextFillColor(l,windowColor2[1],windowColor2[2],windowColor2[3],1.0)
    addBox(l,50,0,4,windowPosition)

    setNextFillColor(l,windowColor2[1],windowColor2[2],windowColor2[3],1.0)
    addBox(l,rx-54,0,4,windowPosition)
    end

--Draw bottom "box"
setNextFillColor(l,windowColor[1],windowColor[2],windowColor[3],1.0)
addBox(l,0,windowPosition,rx,boxHeight)
setNextFillColor(l,windowColor2[1],windowColor2[2],windowColor2[3],1.0)
addBox(l,0,windowPosition,rx,boxHeight/3)


if myTilt.on then
    if heightMod < maxHeightMod then
        heightMod = heightMod+(windowSpeed/10)*getDeltaTime()
        else
        heightMod = maxHeightMod
        end
    else
    if heightMod > minHeightMod then
        heightMod = heightMod-(windowSpeed/10)*getDeltaTime()
        else
        heightMod = minHeightMod
        end
    end

if myToggle.on then
    -- roll down
    if windowPosition < ry-boxHeight then
        windowPosition = windowPosition + windowSpeed*getDeltaTime()
        requestAnimationFrame(1)
        else 
        requestAnimationFrame(4)
        end
    else
    -- roll up
    if windowPosition > 0 then
        windowPosition = windowPosition - windowSpeed*getDeltaTime()
        requestAnimationFrame(1)
        else
        requestAnimationFrame(4)
        end
    end




--[[ Some dude named Bonusaben made this ]]--
--[[   Come visit the Underdun Arcade    ]]--

--[[ Some dude named Bonusaben made this ]]--
--[[   Come visit the Underdun Arcade    ]]--
