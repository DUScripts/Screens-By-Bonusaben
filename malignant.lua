--[[ Malignant ]]--

if not init then
    init = true
    
    rx, ry = getResolution()
    mx, my = getCursor()
    
    logMessage(rx.."-"..ry)
    
    bw = false
    
    maxCircles = 200
    maxRadius = 25
    startRadius = 5
    growthRate = 0.5
    margin = 2
    
    activeCircles = 0
    maxActiveCircles = 25
    
    circles = {}
    
    function CreateCircle(x,y,col)
        circle = {}
        circle.x = x
        circle.y = y
        circle.r = startRadius
        circle.col = col
        circle.done = false
        table.insert(circles,circle)
        activeCircles = activeCircles + 1
        end
    
    function UpdateCircles()
        for _,circle in ipairs(circles) do
            if not circle.done then
                if circle.r < maxRadius and not CollidesWithOther(circle) then
                    circle.r = circle.r + growthRate
                    else
                    circle.done = true
                    activeCircles = activeCircles - 1
                    end
                end
            end
        end
    
    function DrawCircles()
        for _,circle in ipairs(circles) do
            if bw then
                setNextStrokeWidth(l,2)
                setNextStrokeColor(l,1,1,1,1)
                setNextFillColor(l,0,0,0,1)
                else
                setNextFillColor(l,circle.col[1],circle.col[2],circle.col[3],1)
                end
            addCircle(l,circle.x,circle.y,circle.r)
            end
        end
    
    function CollidesWithOther(circle)
        for _,circle2 in ipairs(circles) do
            local mag = GetMag({circle.x,circle.y},{circle2.x,circle2.y})
            if mag > 1 then
                if mag < circle.r + circle2.r + margin then
                    return true
                    end
                end
            end
        return false
        end
    
    function IsValidPosition(pos)
        for _,circle in ipairs(circles) do
            local mag = GetMag({circle.x,circle.y},pos)
                if mag < circle.r + startRadius + margin then
                    return false

                end
            end
        return true
        end
    
    function SwitchBW()
        bw = (not bw)
        end
    
    function Reset()
        circles = {}
        activeCircles = 0
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
    bwButton = Button(l,rx-150,ry-100,100,32,"BW / Color",SwitchBW)
    resetButton = Button(l,rx-150,ry-64,100,32,"Reset",Reset)
    requestAnimationFrame(3)
    end

if loaded == 1 then
    loaded = loaded + 1
    
    requestAnimationFrame(3)
    end

--Rendering
l = createLayer()
l2 = createLayer()
font = loadFont('Play-Bold', 14)
if bw then
    setBackgroundColor(0.5,0.5,0.5)
    else
    setBackgroundColor(0.55,0.65,0)
    end

mx, my = getCursor()
--cr = getCursorReleased()
--cd = getCursorDown()

if bw then
    setNextShadow(l, ry*1.5, 0.125, 0.125, 0.125, 1)
    setNextFillColor(l,0.125,0.125,0.125,1)
    else
    setNextShadow(l, ry*1.5, 0.25, 0.5, 0, 1)
    setNextFillColor(l,0.25,0.5,0,1)
    end

addCircle(l,rx/2,ry/2,10)

if activeCircles < maxActiveCircles and #circles < maxCircles then
    --local x = math.random()*rx
    --local y = math.random()*ry
    
    local x = math.random(-1000,1000)
    local y = math.random(-1000,1000)
    local vec = SetMag({x,y},math.random(ry)*0.4)
    x = rx/2+vec[1]
    y = ry/2+vec[2]
    
    if IsValidPosition({x,y}) then
        local col = {0.1+math.random(),0.1+math.random(),0}
        CreateCircle(x,y,col)
        end
    end

UpdateCircles()
DrawCircles()

bwButton:draw()
resetButton:draw()

-- TITLE
local layerTitle = createLayer()
local font = loadFont('Play-Bold', 14) 
setDefaultFillColor(layerTitle, Shape_Text, 0.1, 0.1, 0.2, 1) 
addBox(layerTitle, 30, ry-64, 220, 32)
addText(layerTitle, font, "M A L I G N A N T . . .", 42, ry-42)


requestAnimationFrame(1)

--[[ Some dude named Bonusaben made this ]]--
--[[   Come visit the Underdun Arcade    ]]--
