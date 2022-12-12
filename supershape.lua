--[[ Supershape ]]--

if not init then
    init = true
    
    rx, ry = getResolution()
    
    supershape = {}
    
    m = 20
    n1 = 2.2
    n2 = 3
    n3 = 1
    numPoints = 2000
    angMul = 12
    
    ang = 0
    a = 1
    b = 1
    
    scale = ry/3
    
    bw = 20 -- border width
    
    for i=1,numPoints do
        point = {0,0}
        supershape[i] = point
        end
    
    function DrawBackground()        
        --green board
        setNextFillColor(l,0,0.2,0,1)
        addBox(l,0,0,rx,ry)
        
        --shadow
        setNextFillColor(l,0,0.1,0,1)
        addBox(l,bw,bw,rx-bw*2,bw/2)
        
        setNextFillColor(l,0,0.1,0,1)
        addBox(l,bw,ry-bw,rx-bw*2,-bw/2)
        
        setNextFillColor(l,0,0.1,0,1)
        addBox(l,bw,bw,bw/2,ry-bw*2)
        
        setNextFillColor(l,0,0.1,0,1)
        addBox(l,rx-bw,bw,-bw/2,ry-bw*2)
        
        --border
        setNextFillColor(l,0.8,0.6,0.3,1)
        addBox(l,0,0,rx,bw)
        
        setNextFillColor(l,0.8,0.6,0.3,1)
        addBox(l,0,ry-bw,rx,bw)
        
        setNextFillColor(l,0.8,0.6,0.3,1)
        addBox(l,0,0,bw,ry)
        
        setNextFillColor(l,0.8,0.6,0.3,1)
        addBox(l,rx-bw,0,rx,ry)
        
        end --DrawBackground
    
    
    function Eval(ang)
        local r = 0
        local t1 = 0
        local t2 = 0
        local p = {0,0}

        t1 = math.cos(m * ang / 4) / a;
        t1 = math.abs(t1);
        t1 = t1^n2;

        t2 = math.sin(m * ang / 4) / b;
        t2 = math.abs(t2);
        t2 = t2^n3;

        r = (t1+t2)^(1/n1);
        if (math.abs(r) == 0) then
            p[1] = 0;
            p[2] = 0;
            else
            r = 1 / r;
            p[1] = r * math.cos(ang);
            p[2] = r * math.sin(ang);
            end
        return p
        end
    
    function CreateSuperShape()
        for i=1,numPoints do
            ang = i * (math.pi * 2) * angMul / numPoints
            supershape[i] = Eval(ang)
            end
        end
    
    function DrawSuperShape()
        for i=1,numPoints-1 do
            local x1 = rx/2+supershape[i][1]*scale
            local y1 = ry/2+supershape[i][2]*scale
            local x2 = rx/2+supershape[i+1][1]*scale
            local y2 = ry/2+supershape[i+1][2]*scale
            
            if x1 < bw then x1 = bw end
            if x1 > rx-bw then x1 = rx-bw end
            if y1 < bw then y1 = bw end
            if y1 > ry-bw then y1 = ry-bw end
            if x2 < bw then x2 = bw end
            if x2 > rx-bw then x2 = rx-bw end
            if y2 < bw then y2 = bw end
            if y2 > ry-bw then y2 = ry-bw end
            
            addLine(l,x1,y1,x2,y2)
            --addLine(l,rx/2+supershape[i][1]*scale,ry/2+supershape[i][2]*scale,rx/2+supershape[i+1][1]*scale,ry/2+supershape[i+1][2]*scale)
            end
        --end gap
        addLine(l,rx/2+supershape[numPoints][1]*scale,ry/2+supershape[numPoints][2]*scale,rx/2+supershape[1][1]*scale,ry/2+supershape[1][2]*scale)
        end
    
    
    end -- init




if not Slider then
    local slider = {}
    slider.__index = slider
    function Slider(layer,x,y,width,length,min,max,defaultValue,label,floor)
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
        self.floor = floor
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
            if self.floor then
                self.value = math.floor(math.max(self.min,math.min(self.max,self.min+((self.max-self.min)*vy))))
                else
                self.value = math.max(self.min,math.min(self.max,self.min+((self.max-self.min)*vy)))
                end
        end
        
        setNextFillColor(self.layer,0.5,0.8,0.5,1)
        addBox(self.layer,self.x+(self.w/2.5),self.y+self.w/5,self.w/6,self.l) -- line
        setNextFillColor(self.layer,1,1,1,1)
        addBox(self.layer,self.x,self.y+self.l-(self:getFraction()*self.l),self.w,self.w/2.5) -- drag box
        -- add some labels for knowing whats what
        local font = loadFont("Montserrat",self.w/3)
        local tw,th = getTextBounds(font, self.label)
        local vw,vh = getTextBounds(font, math.floor(self.value*10)/10)
        if self.floor then
            vw,vh = getTextBounds(font, math.floor(self.value))
            end
        addText(self.layer,font,self.label,self.x+(self.w/2)-(tw/2),self.y-(th*0.5))
        setNextFillColor(self.layer,0.1,0.1,0.1,1)
        if self.floor then
            addText(self.layer,font,math.floor(self.value),self.x+(self.w/2)-(vw/2),self.y+self.l-(self:getFraction()*self.l)+(self.w/5)+(vh/2))
            else
            addText(self.layer,font,math.floor(self.value*10)/10,self.x+(self.w/2)-(vw/2),self.y+self.l-(self:getFraction()*self.l)+(self.w/5)+(vh/2))
            end
        --addText(self.layer,font,math.floor(self.value*100)*0.01,self.x+(self.w/2)-(vw/2),self.y+self.l-(self:getFraction()*self.l)+(self.w/5)+(vh/2))
    end
        
end --slider

if not loaded then
    loaded = true
    
    local slidersX   = rx/3*2
    local slidersY   = ry/3*2
    local slidersOff = 42
    
    --Slider(layer,x,y,width,length,min,max,defaultValue,label)
    mSlider   = Slider(l,slidersX+slidersOff*1,slidersY,30,120,0,20,6,"m",false)
    n1Slider  = Slider(l,slidersX+slidersOff*2,slidersY,30,120,0.1,20,1,"n1",false)
    n2Slider  = Slider(l,slidersX+slidersOff*3,slidersY,30,120,0.1,20,1,"n2",false)
    n3Slider  = Slider(l,slidersX+slidersOff*4,slidersY,30,120,0.1,20,1,"n3",false)
    mulSlider = Slider(l,slidersX+slidersOff*5,slidersY,30,120,1,20,1,"mul",true)
    nPSlider  = Slider(l,slidersX+slidersOff*6,slidersY,30,120,3,2000,1000,"points",true)
    end


--get slider values
m = mSlider.value
n1 = n1Slider.value
n2 = n2Slider.value
n3 = n3Slider.value
numPoints = nPSlider.value

if (mulSlider.value % 2 == 0) then
    angMul = mulSlider.value
    else
    angMul = mulSlider.value + 1
    end


--Rendering
l = createLayer()
l2 = createLayer()
font = loadFont('Play-Bold', 14)
setBackgroundColor(0/255,36/255,57/255,1)

DrawBackground()
CreateSuperShape()
DrawSuperShape()

mSlider:draw()
n1Slider:draw()
n2Slider:draw()
n3Slider:draw()
mulSlider:draw()
nPSlider:draw()

local layerTitle = createLayer()
local font = loadFont('Play-Bold', 14) 
setDefaultFillColor(layerTitle, Shape_Text, 0.1, 0.1, 0.2, 1) 
addBox(layerTitle, 30, ry-64, 220, 32)
addText(layerTitle, font, "S U P E R S H A P E . . .", 42, ry-42)


requestAnimationFrame(1)

--[[ Some dude named Bonusaben made this ]]--
--[[   Come visit the Underdun Arcade    ]]--
