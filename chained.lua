--[[ Chained ]]--

if not init then
    init = true
    
    rx,ry = getResolution()
    
    function FormatNum(val)
        local i, j, minus, int, fraction = tostring(val):find('([-]?)(%d+)([.]?%d*)')

        -- reverse the int-string and append a comma to all blocks of 3 digits
        int = int:reverse():gsub("(%d%d%d)", "%1,")

        -- reverse the int-string back remove an optional comma and put the 
        -- optional minus and fractional part back
        return minus .. int:reverse():gsub("^,", "") -- .. fraction
        end
    
    function GetMag(posA, posB)
        local d = (posB[1]-posA[1])*(posB[1]-posA[1]) + (posB[2]-posA[2])*(posB[2]-posA[2])
        return math.sqrt(d)
        end
    
    function Normalize(vec2d)
        local mag = GetMag({0,0}, vec2d)
        vec2d[1] = vec2d[1] / mag
        vec2d[2] = vec2d[2] / mag
        return vec2d
        end
    
    function SetMag(vec2d,mag)
        local vec = Normalize(vec2d)
        vec[1] = vec[1] * mag
        vec[2] = vec[2] * mag
        return vec
        end
    
    end -- init


if not Ball then
    ball = {}
    ball.__index = ball
    local bSpeed = 2
    local bSize = 5
    function Ball()
        local self = {}
        self.pos = {math.random(rx),math.random(ry)}
        self.vel = Normalize({1-math.random()*2,1-math.random()*2})
        self.col = {math.random(),math.random(),math.random()}
        self.active = true
        return setmetatable(self,ball)
        end
    
    function ball:draw()
        setNextFillColor(l,self.col[1],self.col[2],self.col[3],1)
        addCircle(l,self.pos[1]+cam.x,self.pos[2]+cam.y,bSize)
        end
    
    function ball:collision()
        for _,exp in ipairs(explosions) do
            if self.active and exp.active and GetMag(self.pos,exp.pos) < bSize+exp.size then
                self.active = false
                explosions[#explosions+1] = Explosion(self.pos,exp.chain*2)
                score = score + exp.chain*2
                CamShake()
                end
            end
        end
    
    function ball:update()
        self.pos[1] = self.pos[1] + self.vel[1]
        self.pos[2] = self.pos[2] + self.vel[2]
        
        if self.pos[1] < bSize then
            self.pos[1] = bSize
            self.vel[1] = self.vel[1] * -1
            elseif self.pos[1] > rx-bSize then
            self.pos[1] = rx-bSize
            self.vel[1] = self.vel[1] * -1            
            end
        
        if self.pos[2] < bSize then
            self.pos[2] = bSize
            self.vel[2] = self.vel[2] * -1
            elseif self.pos[2] > ry-bSize then
            self.pos[2] = ry-bSize
            self.vel[2] = self.vel[2] * -1
            end
        end
    
    end --Ball

if not Explosion then
    explosion = {}
    explosion.__index = explosion
    function Explosion(pos,chain)
        local self = {}
        self.pos = pos
        self.chain = chain or 1
        self.size = 0
        self.life = 70
        self.active = true
        self.col = {math.random(),math.random(),math.random()}
        self.particles = {}
        self.numParticles = 50
        self.pSpeed = 5
        self.pLife = 30
        
        for i=1,self.numParticles do
            local particle = {}
            particle.pos = {self.pos[1],self.pos[2]}
            particle.vel = Normalize({(1-math.random()*2),(1-math.random()*2)})
            particle.vel[1] = particle.vel[1]*self.pSpeed*(1+math.random())
            particle.vel[2] = particle.vel[2]*self.pSpeed*(1+math.random())
            particle.life = math.random(self.pLife)
            self.particles[i] = particle
            end
        
        return setmetatable(self,explosion)
        end
    
    function explosion:draw()
        if self.active then
            --setNextFillColor(0,self.col[1],self.col[2],self.col[3],1)
            
            setNextFillColor(l,self.col[1]*2,self.col[2]*2,self.col[3]*2,1)
            setNextStrokeColor(l,self.col[1],self.col[2],self.col[3],1)
            setNextStrokeWidth(l,10*(self.size/maxExplosionSize))
            setNextShadow(l, self.size+5*(maxExplosionSize-self.size)*(self.life/70), self.col[1],self.col[2],self.col[3],0.5)
            addCircle(l,self.pos[1]+cam.x,self.pos[2]+cam.y,self.size)
            
            if self.life >= 0 then
                --setNextFillColor(l,1-self.col[1]*2,1-self.col[2]*2,1-self.col[3]*2,1)
                setNextFillColor(l,0,0,0,1)
                setNextTextAlign(l, AlignH_Center, AlignV_Middle)
                addText(l,expfont,self.chain,self.pos[1]+2,self.pos[2]-100*(1-self.life/70)+2)
                
                setNextFillColor(l,1,1,1,1)
                setNextTextAlign(l, AlignH_Center, AlignV_Middle)
                addText(l,expfont,self.chain,self.pos[1],self.pos[2]-100*(1-self.life/70))
                
                if self.size < maxExplosionSize then
                    self.size = self.size + 2
                    end
                self.life = self.life - 1
                end
            if self.life < 0 then
                if self.size > 0 then
                    self.size = self.size -0.5
                    else
                    self.active = false
                    end
                end
            
            --particles
            if self.pLife > 0 then
                for _,p in ipairs(self.particles) do
                    if p.life > 0 then
                        setNextFillColor(l,self.col[1]*4,self.col[2]*4,self.col[3]*4,1)
                        --setNextShadow(l, 10*self.pLife/20, self.col[1]*2,self.col[2]*2,self.col[3]*2,0.5)
                        setNextShadow(l, 10*p.life/20, self.col[1]*2,self.col[2]*2,self.col[3]*2,0.5)
                        addCircle(l,p.pos[1]+cam.x,p.pos[2]+cam.y,5*p.life/20)
                        p.pos[1] = p.pos[1] + p.vel[1]
                        p.pos[2] = p.pos[2] + p.vel[2]
                        p.life = p.life - 1
                        end
                    end
                --self.pLife = self.pLife - 1
                else
                self.particles = nil
                end
            end
        end --draw
    end --Explosion

if not CamShake then
    cam = {}
    cam.x = 0
    cam.y = 0
    amount = 0
    
    function CamShake()
        amount = 5
        end
    
    function CamShakeUpdate()
        if amount > 0 then
            local vec = Normalize({ (1-math.random()*2) , (1-math.random()*2)})
            cam.x = vec[1] * amount
            cam.y = vec[2] * amount
            amount = amount - 0.25
            else
            amount = 0
            cam.x = 0
            cam.y = 0
            end
        end
    
    end --camshake



bg = createLayer()
l  = createLayer()
l2 = createLayer()
font = loadFont('Play-Bold', 14)
expfont = loadFont('Play-Bold', 24)

if not loaded then
    loaded = 1
    
    
    balls = {}
    explosions = {}
    maxExplosionSize = 50
    sessionMaxScore = 0
    
    
    requestAnimationFrame(3)
    end

if loaded == 1 then
    loaded = loaded + 1
    score = 0
    local numBalls = 100
    for i=1,numBalls do
        local ball = Ball()
        balls[i] = ball
        end
    gameRunning = false
    requestAnimationFrame(3)
    end



--Rendering
rx, ry = getResolution()
cx,cy = getCursor()
cr = getCursorReleased()

setBackgroundColor(0.05,0.05,0.05)

-- BG grid
setDefaultStrokeColor(bg,Shape_Line,0.1,0.1,0.1,1)
local cols = 30
local rows = 18
for x=1,cols-1 do
    addLine(bg,rx/cols*x+cam.x,0+cam.y,rx/cols*x+cam.x,ry+cam.y)
    end

for y=1,rows-1 do
    addLine(bg,0+cam.x,ry/rows*y+cam.y,rx+cam.x,ry/rows*y+cam.y)
    end

if not gameRunning then
    font = loadFont('Play-Bold', 22) 
    setNextTextAlign(l, AlignH_Center, AlignV_Middle)
    addText(l, font, "Click somewhere to start the chain reaction!!", rx/2, ry/2)
    
    setNextFillColor(l,0,0,0,0)
    setNextStrokeColor(l,1,1,1,1)
    setNextStrokeWidth(l,5)
    addCircle(l,cx,cy,maxExplosionSize)
    if cr then
        score = 0
        explosions[1] = Explosion({cx,cy})
        gameRunning = true
        end
    else
    if score > sessionMaxScore then sessionMaxScore = score end
    if numExplosions == 0 then
        font = loadFont('Play-Bold', 22) 
        setNextTextAlign(l, AlignH_Center, AlignV_Middle)
        addText(l, font, "Round has ended! Click to reset the game.", rx/2, ry/2)
        if cr then
            loaded = 1
            end
        end
    end

font = loadFont('Play-Bold', 22) 
setNextTextAlign(l, AlignH_Center, AlignV_Middle)
addText(l, font, "SCORE: "..FormatNum(score), rx/2, 20)

font = loadFont('Play-Bold', 12) 
setNextTextAlign(l, AlignH_Center, AlignV_Middle)
addText(l, font, "SESSION MAX: "..FormatNum(sessionMaxScore), rx/2, 40)

for _,b in ipairs(balls) do
    if b.active then
        b:draw()
        b:update()
        b:collision()
        end
    end

numExplosions = 0
for _,e in ipairs(explosions) do
    if e.active then
        e:draw()
        numExplosions = numExplosions+1
        end
    end

CamShakeUpdate()

-- TITLE
local layerTitle = createLayer()
font = loadFont('Play-Bold', 14) 
setDefaultFillColor(layerTitle, Shape_Text, 0.1, 0.1, 0.2, 1) 
addBox(layerTitle, 30, ry-64, 220, 32)
addText(layerTitle, font, "C H A I N E D . . . .", 42, ry-42)



requestAnimationFrame(1)

--[[ Some dude named Bonusaben made this ]]--
--[[   Come visit the Underdun Arcade    ]]--
