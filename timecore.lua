--[[ Timecore ]]--

if not init then
    init = true
    
    rx,ry = getResolution()
    
    function Clamp(v, min, max)
        return math.max(math.min(v, max), min)
        end
    
    function Smoothstep(v, a, b)
        v = Clamp((v - a) / (b - a), 0.0, 1.0)
        return v * v * (3 - 2 * v)
        end
    
    end -- init


if not Loop then
    loop = {}
    loop.__index = loop
    
    function Loop(layer,radius,numDots,delay)
        local self = {}
        self.layer = layer or 0
        self.r = radius or 20
        self.n = numDots or 8
        self.d = delay or 0
        
        self.dots = {}
        for i=1,self.n do
            local dot = {}
            dot.x = self.r * math.cos(2*math.pi/self.n*i) + rx/2
            dot.y = self.r * math.sin(2*math.pi/self.n*i) + ry/2
            self.dots[i] = dot
            end
        
        return setmetatable(self,loop)
        end
    
    function loop:draw()
        for _,dot in ipairs(self.dots) do
            addCircle(self.layer,dot.x,dot.y,3)
            end
        end
    
    function loop:update()
        for _,dot in ipairs(self.dots) do
            local ang = {}
            ang.x = math.cos(2*math.pi/self.n*_)
            ang.y = math.sin(2*math.pi/self.n*_)
            
            dot.x = self.r * ang.x + rx/2 + offset*ang.x*Smoothstep((math.sin(self.n/self.d+counter+_/self.d)),0,0.5)
            dot.y = self.r * ang.y + ry/2 + offset*ang.y*Smoothstep((math.sin(self.n/self.d+counter+_/self.d)),0,0.5)            
            end
        end
    
    end -- Loop


l = createLayer()
offset = 30

if not loaded then
    loaded = 1
    counter = 0
    
    
    loop1 = Loop(l,10,8,0)
    loop2 = Loop(l,40,16,0.5)
    loop3 = Loop(l,70,32,1)
    loop4 = Loop(l,100,64,1.5)
    loop5 = Loop(l,130,128,2)
    loop6 = Loop(l,160,256,2.5)
    loop7 = Loop(l,190,512,3)
    
    requestAnimationFrame(3)
    end

if loaded == 1 then
    loaded = loaded + 1
    
    requestAnimationFrame(3)
    end



--Rendering
rx, ry = getResolution()

font = loadFont('Play-Bold', 14)
setBackgroundColor(0.0,0.0,0.05)
setDefaultFillColor(l,Shape_Circle,1,1,1,1)
setDefaultShadow(l, Shape_Circle, 8, 0, 1, 1, 0.5)

setNextShadow(l,ry,0,0,0.01,1)
addCircle(l,rx/2,ry/2,1)

setNextFillColor(l,0,0,0,0)
setNextStrokeColor(l,1,1,1,1)
setNextStrokeWidth(l,2)
addCircle(l,rx/2,ry/2,234)

setNextFillColor(l,0,0,0,0)
setNextStrokeColor(l,1,1,1,0.5)
setNextStrokeWidth(l,3)
addCircle(l,rx/2,ry/2,242)

setNextFillColor(l,0,0,0,0)
setNextStrokeColor(l,1,1,1,1)
setNextStrokeWidth(l,2)
addCircle(l,rx/2,ry/2,24)

addCircle(l,rx/2,ry/2,16)

loop1:draw()
loop2:draw()
loop3:draw()
loop4:draw()
loop5:draw()
loop6:draw()
loop7:draw()

loop1:update()
loop2:update()
loop3:update()
loop4:update()
loop5:update()
loop6:update()
loop7:update()

counter = counter + 0.05



-- TITLE
local layerTitle = createLayer()
local font = loadFont('Play-Bold', 14) 
setDefaultFillColor(layerTitle, Shape_Text, 0.1, 0.1, 0.2, 1) 
addBox(layerTitle, 30, ry-64, 220, 32)
addText(layerTitle, font, "T I M E C O R E . . . . . .", 42, ry-42)



requestAnimationFrame(1)

--[[ Some dude named Bonusaben made this ]]--
--[[   Come visit the Underdun Arcade    ]]--
