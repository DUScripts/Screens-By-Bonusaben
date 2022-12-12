--[[ Bezier ]]--

if not init then
    init = true
    
    rx,ry = getResolution()
    
    function Lerp(a,l,h)
        return a*(h-l)+l
        end
    
    function Lerp2D(v1,v2,t)
        return {v1[1] + t*(v2[1] - v1[1]), v1[2] + t*(v2[2] - v1[2])}
        end
    
    colors = {
        {0.035,0.045,0.08},
        {1.00,1.00,1.00},
        {0.50,0.00,0.12},
        {0.01,0.33,0.50},
        {0.00,0.50,0.35}
    }
    
    end

if not Dragable then
    dragable = {}
    dragable.__index = dragable
    
    function Dragable(layer,x,y,topLeft,bottomRight,col,anchor)
        local self = {}
        
        self.layer = layer
        self.pos = {x,y}
        self.topLeft = topLeft or {0,0}
        self.bottomRight = bottomRight or {rx,ry}
        self.col = col or {1,1,1}
        self.anchor = anchor or false
        
        self.size = 10
        self.doDrag = false
        
        return setmetatable(self,dragable)
        end
    
    function dragable:draw()
        if self.anchor then
            setNextFillColor(self.layer,self.col[1],self.col[2],self.col[3],1)
            else
            setNextFillColor(self.layer,colors[1][1],colors[1][2],colors[1][3],1)
            setNextStrokeColor(self.layer,self.col[1],self.col[2],self.col[3],1)
            setNextStrokeWidth(self.layer,3)
            end
        addCircle(self.layer,self.pos[1],self.pos[2],self.size)
        end --draw
    
    function dragable:update()
        if not self.anchor and cd then
            if cx >= self.pos[1]-self.size*2 and cx <= self.pos[1]+self.size*2 and cy >= self.pos[2]-self.size*2 and cy <= self.pos[2]+self.size*2 then
                self.doDrag = true
                end
            else
            self.doDrag = false
            end
        
        if self.doDrag then
            if      cx >= self.topLeft[1]+self.size
                and cx <= self.bottomRight[1]-self.size
                and cy >= self.topLeft[2]+self.size
                and cy <= self.bottomRight[2]-self.size then
                self.pos = {cx,cy}
                else
                self.doDrag = false
                end
            end
        
        if self.pos[1] < self.topLeft[1]+self.size then self.pos[1] = self.topLeft[1]+self.size end
        if self.pos[1] > self.bottomRight[1]-self.size then self.pos[1] = self.bottomRight[1]-self.size end
        if self.pos[2] < self.topLeft[2]+self.size then self.pos[2] = self.topLeft[2]+self.size end
        if self.pos[2] > self.bottomRight[2]-self.size then self.pos[2] = self.bottomRight[2]-self.size end
        
        end --update
    
    end --dragable

if not Bezier then
    function Bezier(p1,p2,p3,p4,t)
        local A = Lerp2D(p1,p2,t)
        local B = Lerp2D(p2,p3,t)
        local C = Lerp2D(p3,p4,t)
        local D = Lerp2D(A,B,t)
        local E = Lerp2D(B,C,t)
        --local P = Lerp2D(D,E,t)
        
        return Lerp2D(D,E,t)
        end
    end --bezier

cx,cy = getCursor()
cd = getCursorDown()
cr = getCursorReleased()
bg= createLayer()
l = createLayer()


if not loaded then
    loaded = 1
    
    --make the points
    points = {}
    points[1] = Dragable(l,rx/4,ry/3*2,{10,10},{rx-10,ry-10},colors[2],true)
    points[2] = Dragable(l,rx/4,ry/4,{10,10},{rx-10,ry-10},colors[3],false)
    points[3] = Dragable(l,rx/4*3,ry/4,{10,10},{rx-10,ry-10},colors[4],false)
    points[4] = Dragable(l,rx/4*3,ry/3*2,{10,10},{rx-10,ry-10},colors[2],true)
    
    requestAnimationFrame(3)
    end

setBackgroundColor(colors[1][1],colors[1][2],colors[1][3])

numBezierPoints = 50
bPoints = {}
for i=1,numBezierPoints do
    bPoints[i] = Bezier(points[1].pos,points[2].pos,points[3].pos,points[4].pos,i/numBezierPoints)
    end

--lines to the dragables
setDefaultStrokeWidth(bg,Shape_Line,1)
setNextStrokeColor(bg,colors[3][1],colors[3][2],colors[3][3],1)
addLine(bg,points[1].pos[1],points[1].pos[2],points[2].pos[1],points[2].pos[2])

setNextStrokeColor(bg,colors[4][1],colors[4][2],colors[4][3],1)
addLine(bg,points[3].pos[1],points[3].pos[2],points[4].pos[1],points[4].pos[2])

setDefaultStrokeWidth(bg,Shape_Line,5)
-- first line
addLine(bg,points[1].pos[1],points[1].pos[2],bPoints[1][1],bPoints[1][2])
for i=1,numBezierPoints-1 do
    addLine(bg,bPoints[i][1],bPoints[i][2],bPoints[i+1][1],bPoints[i+1][2])
    end




for _,p in ipairs(points) do
    p:update()
    p:draw()
    end


--local font = loadFont('Play-Bold', 14) 
--addText(l, font, "RND: "..getRenderCost(), 42, ry-42)
--addText(l, font, "DLT: "..getDeltaTime(), 42, ry-62)

-- TITLE
local layerTitle = createLayer()
local fontTitle = loadFont('Play-Bold', 14) 
setDefaultFillColor(layerTitle, Shape_Text, 0.1, 0.1, 0.2, 1) 
addBox(layerTitle, 30, ry-64, 220, 32)
addText(layerTitle, fontTitle, "B E Z I E R . . . . . . .", 42, ry-42)

requestAnimationFrame(1)





--[[ Some dude named Bonusaben made this ]]--
--[[   Come visit the Underdun Arcade    ]]--
