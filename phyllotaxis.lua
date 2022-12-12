--[[ Phyllotaxis ]]--

if not init then
    init = true
    
    rx, ry = getResolution()
    
    ang = math.rad(137.5)
    c = 5
    
    dots = {}
    numDots = 2000
    dotSize = 3
    
    bright = 100
    outRGB = {1,1,1}
    
    function CreateDots()
        
        
        for i=1,numDots do
            dot = {}
            dot.x = rx/2+(c*math.sqrt(i)) * math.cos(i*ang)
            dot.y = ry/2+(c*math.sqrt(i)) * math.sin(i*ang)
            dot.ang = i*ang
            dots[i] = dot
            end
        end
    
    function DrawDots()
        for _,dot in ipairs(dots) do
            local rgb = HSBtoRGB(math.deg(dot.ang),_/numDots*100,bright)
            
            --highlight
            if GetMag({dot.x,dot.y},{cx,cy}) < 1.25*dotSize then
                setNextFillColor(l,1,1,1,1)
                addCircle(l,dot.x,dot.y,dotSize*2)
                
                if cd then
                    outRGB = rgb
                    end
                end
            
            --setNextFillColor(l,(_%256)/255,1,1-(_%256)/255,1)
            --local rgb = HSBtoRGB(_%360,100,100)
            
            setNextFillColor(l,rgb[1],rgb[2],rgb[3],1)
            addCircle(l,dot.x,dot.y,dotSize)
            
            end
        end
    
    function HSBtoRGB(h,s,b)
        
        local s = s/100
        local b = b/100
        
        local k = function(n) return (n + h / 60) % 6 end
        local f = function(n) return b * (1 - s * math.max(0, math.min(k(n), 4 - k(n), 1))) end
        
        --local RGB = {255 * f(5), 255 * f(3), 255 * f(1)}
        local RGB = {f(5), f(3),f(1)}
    --const k = (n) => (n + h / 60) % 6;
    --const f = (n) => b * (1 - s * Math.max(0, Math.min(k(n), 4 - k(n), 1)));
    --return [255 * f(5), 255 * f(3), 255 * f(1)];
        
        return RGB
        end
    
    function GetMag(posA, posB)
        local d = (posB[1]-posA[1])*(posB[1]-posA[1]) + (posB[2]-posA[2])*(posB[2]-posA[2])
        return math.sqrt(d)
        end
    
    end -- init


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
        
        setNextFillColor(self.layer,1,1,1,0.5)
        addBox(self.layer,self.x+(self.w/2.5),self.y+self.w/5,self.w/6,self.l) -- line
        setNextFillColor(self.layer,1,1,1,1)
        addBox(self.layer,self.x,self.y+self.l-(self:getFraction()*self.l),self.w,self.w/2.5) -- drag box
        -- add some labels for knowing whats what
        local font = loadFont("Montserrat",self.w/3)
        local tw,th = getTextBounds(font, self.label)
        local vw,vh = getTextBounds(font, math.floor(self.value))
        addText(self.layer,font,self.label,self.x+(self.w/2)-(tw/2),self.y-(th*0.5))
        setNextFillColor(self.layer,0.1,0.1,0.1,1)
        addText(self.layer,font,math.floor(self.value),self.x+(self.w/2)-(vw/2),self.y+self.l-(self:getFraction()*self.l)+(self.w/5)+(vh/2))
        --addText(self.layer,font,math.floor(self.value*100)*0.01,self.x+(self.w/2)-(vw/2),self.y+self.l-(self:getFraction()*self.l)+(self.w/5)+(vh/2))
    end
        
end --slider


if not loaded then
    loaded = true
    
    iX = rx-175
    
    --Slider(layer,x,y,width,length,min,max,defaultValue,label)
    BrightSlider = Slider(l,iX-15,ry/2-100,30,150,0,100,100,"BRIGHT")
    end

--Rendering
l = createLayer()
l2 = createLayer()
font = loadFont('Play-Bold', 14)
setBackgroundColor(0,0,0.05)

setNextFillColor(l,0,0,0,1)
setNextStrokeColor(l,1,1,1,1)
setNextStrokeWidth(l,3)
addCircle(l,rx/2,ry/2,ry/2*0.85)

cx,cy = getCursor()
cd = getCursorReleased()

CreateDots()
DrawDots()

BrightSlider:draw()
bright = BrightSlider.value

local r = math.floor(outRGB[1]*100)/100
local g = math.floor(outRGB[2]*100)/100
local b = math.floor(outRGB[3]*100)/100

setNextFillColor(l,r,g,b,1)
setNextStrokeColor(l,1,1,1,1)
setNextStrokeWidth(l,2)
addCircle(l,iX,ry/2+100,25)

setNextTextAlign(l, AlignH_Center, AlignV_Middle)
addText(l,font,"RGB: "..r..", "..g..", "..b,iX,ry/2+150)

local layerTitle = createLayer()
local font = loadFont('Play-Bold', 14) 
setDefaultFillColor(layerTitle, Shape_Text, 0.1, 0.1, 0.2, 1) 
addBox(layerTitle, 30, ry-64, 220, 32)
addText(layerTitle, font, "P H Y L L O T A X I S . . .", 42, ry-42)


requestAnimationFrame(1)

--[[ Some dude named Bonusaben made this ]]--
--[[   Come visit the Underdun Arcade    ]]--
