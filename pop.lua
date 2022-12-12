--[[ Pop ]]--

if not init then
    init = true
    
    rx,ry = getResolution()
    
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


if not Player then
    player = {}
    player.__index = player
    
    function Player(layer)
        local self = {}
        self.layer = layer or 0
        self.size = 20
        self.pos = {rx/2,ry/2}
        self.acc = {0,0}
        self.vel = {0,0}
        return setmetatable(self,player)
        end
    
    function player:draw()
        setNextFillColor(self.layer,1,1,1,1)
        addCircle(self.layer,self.pos[1],self.pos[2],self.size)
        end
    
    function player:update()
        --reset acc
        self.acc = {0,0}
        
        --clicked
        if cr then
            --self.acc[2] = self.acc[2] - 20
            self.vel[2] = -maxSpeed/2
            end
        
        --gravity
        self.acc[2] = self.acc[2] + grav
        
        --add acc to vel
        self.vel[1] = self.vel[1] + self.acc[1]
        self.vel[2] = self.vel[2] + self.acc[2]
        
        --terminal velocity
        if GetMag({0,0},self.vel) > maxSpeed then
            SetMag(self.vel,maxSpeed)
            end
        
        --add vel to pos
        self.pos[1] = self.pos[1] + self.vel[1]
        self.pos[2] = self.pos[2] + self.vel[2]
        
        --check borders
        if self.pos[1]-self.size < margin then 
            self.pos[1] = margin+self.size
            self.vel[1] = hSpeed
            score = score + 1
            ActivateSpikes("right")
        elseif self.pos[1]+self.size > rx-margin then
            self.pos[1] = rx-margin-self.size
            self.vel[1] = -hSpeed
            score = score + 1
            ActivateSpikes("left")
            end
        if self.pos[2]-self.size < 20 then
            self.pos[2] = margin+self.size
            self.vel[2] = self.vel[2] *-0.2
        elseif self.pos[2]+self.size > ry-88-self.size then
            self.pos[2] = ry-88-self.size
            KillPlayer()
            end
        
        end
    
    end -- Player

if not Spike then
    spike = {}
    spike.__index = spike
    
    function Spike(layer,side,x,y)
        local self = {}
        self.layer = layer or 0
        self.side = side or "left"
        self.x = 0
        self.y = y
        self.offset = 30
        self.active = false
        self.size = 30
        return setmetatable(self,spike)
        end
    
    function spike:draw()
        if self.side == "left" then
            addTriangle(self.layer,self.x+self.offset,self.y-self.size/2,self.x+self.offset,self.y+self.size/2,self.x+self.offset+self.size,self.y)
            else
            addTriangle(self.layer,rx-self.x-self.offset,self.y-self.size/2,rx-self.x-self.offset,self.y+self.size/2,rx-self.x-self.offset-self.size,self.y)
            end
        
        if self.active then
            if self.offset < self.size then
                self.offset = self.offset + 1
                end
            else
            if self.offset > 0 then
                self.offset = self.offset - 1
                end
            end
        end
    
    function spike:getTipPos()
        local tip = {}
        if self.side == "left" then
            tip = {self.x+self.offset+self.size,self.y}
            else
            tip = {rx-self.x-self.offset-self.size,self.y}
            end
        return tip
        end
    
    end -- Spikes

if not ActivateSpikes then
    function ActivateSpikes(side)
        local numToFlip = 3
        local picked = {}
        
        if side == "left" then
            for i=#spikes/2,#spikes do -- deactivate all right spikes
                spikes[i].active = false
                end
            
            local n = {1,2,3,4,5,6,7,8,9,10,11}
            for i=1,numToFlip do
                local pick = math.random(#n)
                picked[#picked+1] = n[pick]
                table.remove(n,pick)
                end
            
            else
            for i=1,#spikes/2 do -- deactivate all left spikes
                spikes[i].active = false
                end
            
            local n = {12,13,14,15,16,17,18,19,20,21,22}
            for i=1,numToFlip do
                local pick = math.random(#n)
                picked[#picked+1] = n[pick]
                table.remove(n,pick)
                end
            end
        
        for _,pick in ipairs(picked) do
            spikes[pick].active = true
            end
        
        end
    end --ActivateSpikes

if not KillPlayer then
    particles = {}
    numParticles = 28
    pSpeed = 12
    pLife = 30
    
    function KillPlayer()
        gameRunning = false
        
        --reset particles
        particles = {}
        for i=1,numParticles do
            local particle = {}
            particle.pos = {player.pos[1],player.pos[2]}
            particle.vel = {(1-math.random()*2)*pSpeed,(math.random()*2)*-pSpeed}
            particle.life = pLife
            particles[i] = particle
            end
        end
    
    function UpdateParticles()
        for i=#particles,1,-1 do
            particles[i].vel[2] = particles[i].vel[2] + 2
            
            particles[i].pos[1] = particles[i].pos[1] + particles[i].vel[1]
            particles[i].pos[2] = particles[i].pos[2] + particles[i].vel[2]
            
            if particles[i].life > 0 then
                particles[i].life = particles[i].life - 1
                else
                table.remove(particles,i)
                end
            end
        end
    
    function DrawParticles()
        for _,p in ipairs(particles) do
            setNextFillColor(l2,1,1,1,p.life/pLife)
            addCircle(l2,p.pos[1],p.pos[2],10*p.life/pLife)
            end
        end
    
    end -- KillPlayer


l  = createLayer()
l2 = createLayer()

if not loaded then
    loaded = 1
    grav = 2
    maxSpeed = 42
    hSpeed = 10
    margin = 32
    killDist = 19
    sessionHighscore = 0
    score = 0
    player = Player(l)
    gameRunning = false
    particles = {}
    requestAnimationFrame(3)
    end

if loaded == 1 then
    loaded = loaded + 1
    
    numSpikes = 11
    spikes = {}
    for i=1,numSpikes do
        spikes[i] = Spike(l,"left",margin,42*i)
        end
    
    for i=1,numSpikes do
        spikes[numSpikes+i] = Spike(l,"right",rx-margin,42*i)
        end
    
    
    requestAnimationFrame(3)
    end



--Rendering
rx, ry = getResolution()
cx,cy = getCursor()
cr = getCursorReleased()

setBackgroundColor(0.05,0.05,0.05)

setDefaultFillColor(l,Shape_Polygon,1,0,0.25,1)

if gameRunning then
    player:update()
    player:draw()
    else
    if cr then -- start new game
        gameRunning = true
        score = 0
        player.pos = {rx/2,ry/2}
        player.vel = {hSpeed,-maxSpeed/2}
        for _,spike in ipairs(spikes) do
            spike.active = false
            end
        end
    end

for _,spike in ipairs(spikes) do
    spike:draw()
    if gameRunning then
        if GetMag(player.pos,spike:getTipPos()) < killDist then
            KillPlayer()
            end
        else
        spike.active = true
        end
    end

if #particles > 0 then
    DrawParticles()
    UpdateParticles()
    end

-- BORDERS
setNextFillColor(l2,0.2,0.2,0.2,1)
addBox(l2,0,0,28,ry)

setNextFillColor(l2,0.2,0.2,0.2,1)
addBox(l2,rx-28,0,rx,ry)

setNextFillColor(l2,0.2,0.2,0.2,1)
addBox(l2,0,0,rx,20)

setNextFillColor(l2,0.2,0.2,0.2,1)
addBox(l2,0,ry-88,rx,88)

setNextFillColor(l2,1,0.0,0.25,1)
addBox(l2,30,ry-88,rx-60,5)

-- TEXT
if score > sessionHighscore then sessionHighscore = score end

if gameRunning then
    setNextFillColor(l,1,1,1,0.3)
    else
    setNextFillColor(l,1,1,1,1)
    end
font = loadFont('Play-Bold', 142) 
setNextTextAlign(l, AlignH_Center, AlignV_Middle)
addText(l, font, score, rx/2, ry/2-50)

if gameRunning then
    setNextFillColor(l,1,1,1,0.3)
    else
    setNextFillColor(l,1,1,1,1)
    end
font = loadFont('Play-Bold', 12)
setNextTextAlign(l, AlignH_Center, AlignV_Middle)
addText(l, font, "session high: "..sessionHighscore, rx/2, ry/2+20)

-- TITLE
local layerTitle = createLayer()
local font = loadFont('Play-Bold', 14) 
setDefaultFillColor(layerTitle, Shape_Text, 0.1, 0.1, 0.2, 1) 
addBox(layerTitle, 30, ry-64, 220, 32)
addText(layerTitle, font, "P O P . . . . . .", 42, ry-42)



requestAnimationFrame(1)

--[[ Some dude named Bonusaben made this ]]--
--[[   Come visit the Underdun Arcade    ]]--
