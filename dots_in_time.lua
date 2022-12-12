--[[ Dots_in_time ]]--

if not init then
    init = true
    
    rx,ry = getResolution()
    
    colors = {
        --{0.035,0.045,0.08}, -- BG
        {1.00,1.00,1.00}, -- White
        {1.00,1.00,1.00}, -- White -- to add more "empty" spots
        {0.50,0.00,0.12}, -- Pink
        {0.01,0.33,0.50}, -- Blue
        {0.00,0.50,0.35} -- Green
    }
    
    function Lerp(a,b,f)
        return (b-a)*f+a
        end
    
    function LerpRGB(col1,col2,f)
        --local col = (col2-col1)*f+col1
        local R = (col2[1]-col1[1])*f+col1[1]
        local G = (col2[2]-col1[2])*f+col1[2]
        local B = (col2[3]-col1[3])*f+col1[3]
        
        return {R,G,B}
        end
    
    end

if not Dot then
    dot = {}
    dot.__index = dot
    
    function Dot(layer,pos,maxSize)
        local self = {}
        self.layer = layer or 1
        self.pos = pos or {0,0}
        self.maxSize = maxSize or 10
        self.radius = math.random(dotSizeVariants)*self.maxSize/dotSizeVariants
        self.radiusPrev = self.radius
        self.radiusNext = math.random(dotSizeVariants)*self.maxSize/dotSizeVariants        
        self.col = colors[math.random(#colors)]
        self.colPrev = self.col
        self.colNext = colors[math.random(#colors)]
        return setmetatable(self,dot)
        end
    
    function dot:draw()
        setNextFillColor(self.layer,self.col[1],self.col[2],self.col[3],1)
        addCircle(self.layer,self.pos[1],self.pos[2],self.radius)
        end
    
    function dot:update(step)
        
        if step == 0 then
            self.radiusPrev = self.radiusNext
            self.colPrev = self.colNext
            --self.radiusNext = math.random(self.maxSize)
            self.radiusNext = math.random(dotSizeVariants)*self.maxSize/dotSizeVariants
            self.colNext = colors[math.random(#colors)]
            end
        
        self.col = LerpRGB(self.colPrev,self.colNext,step)
        self.radius = Lerp(self.radiusPrev,self.radiusNext,step)
        
        end
    
    end --Dot




bg= createLayer()
l = createLayer()


if not loaded then
    loaded = 1
    
    dots = {}
    numDotsW = 8
    numDotsH = 8
    maxDotSize = 20
    dotSizeVariants = 3
    stepSize = 8
    stepCounter = 0
    stepTotal = 15
    speed = 5
    
    for i=1,numDotsW do
        for j=1,numDotsH do
            local x = rx/2-numDotsW/2*maxDotSize*2.1+(j-0.5)*maxDotSize*2.1
            local y = ry/2-numDotsH/2*maxDotSize*2.1+(i-0.5)*maxDotSize*2.1
            dots[#dots+1] = Dot(l,{x,y},maxDotSize)
            end
        end
        
    
    requestAnimationFrame(1)
    return
    end

setBackgroundColor(colors[1][1],colors[1][2],colors[1][3])


stepCounter = stepCounter + getDeltaTime() * speed
--if stepCounter > stepSize then stepCounter = 0 end
if stepCounter > stepTotal then stepCounter = 0 end

for _,d in ipairs(dots) do
    d:draw()
    
    if stepCounter <= stepSize then
        d:update(stepCounter/stepSize)
        else
        d:update(1)
        end
    end


--local font = loadFont('Play-Bold', 14) 
--addText(l, font, "RND: "..getRenderCost(), 42, ry-42)
--addText(l, font, "DLT: "..getDeltaTime(), 42, ry-62)

-- TITLE
local layerTitle = createLayer()
local fontTitle = loadFont('Play-Bold', 14) 
setDefaultFillColor(layerTitle, Shape_Text, 0.1, 0.1, 0.2, 1) 
addBox(layerTitle, 30, ry-64, 220, 32)
addText(layerTitle, fontTitle, "D O T S . I N . T I M E . . .", 42, ry-42)

requestAnimationFrame(1)

--[[ Some dude named Bonusaben made this ]]--
--[[   Come visit the Underdun Arcade    ]]--
