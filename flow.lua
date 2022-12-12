--[[ Flow ]]--

local mapping = {
    columns = 120,
    rows = 80,
}

local gradSize = 0

if not rnd then 
    rnd = 1
    off = 1
end

local rx,ry = getResolution()

if getCursorReleased() then
    local cx,cy = getCursor()
    rnd = (rnd+cx+cy)*getDeltaTime()
    math.randomseed(rnd)
    loaded = {1,1}
    band = {1,0}
    ready = nil
    off = math.random() * rnd
end

local square = 7 -- scale / zoom ?
local loadLimit = 2000




local font = loadFont("RobotoMono",20)
local l = createLayer()

local numParticles = 2000


if not ready then
    if not init then
        init = true
        loaded = {1,1}
        band = {1,0}
        map = {}
    end
    perlin = {}
    perlin.p = {}
    perlin.permutation = {151,160,137,91,90,15,131,13,201,95,96,53,194,233,7,225,140,36,103,30,69,142,8,99,37,240,21,10,23,190,6,148,247,120,234,75,0,26,197,62,94,252,219,203,117,35,11,32,57,177,33,88,237,149,56,87,174,20,125,136,171,168,68,175,74,165,71,134,139,48,27,166,77,146,158,231,83,111,229,122,60,211,133,230,220,105,92,41,55,46,245,40,244,102,143,54,65,25,63,161,1,216,80,73,209,76,132,187,208,89,18,169,200,196,135,130,116,188,159,86,164,100,109,198,173,186,3,64,52,217,226,250,124,123,5,202,38,147,118,126,255,82,85,212,207,206,59,227,47,16,58,17,182,189,28,42,223,183,170,213,119,248,152,2,44,154,163,70,221,153,101,155,167,43,172,9,129,22,39,253,19,98,108,110,79,113,224,232,178,185,112,104,218,246,97,228,251,34,242,193,238,210,144,12,191,179,162,241,81,51,145,235,249,14,239,107,49,192,214,31,181,199,106,157,184,84,204,176,115,121,50,45,127,4,150,254,138,236,205,93,222,114,67,29,24,72,243,141,128,195,78,66,215,61,156,180}
    perlin.size = 256
    perlin.gx = {}
    perlin.gy = {}
    perlin.randMax = 256
    
    function perlin:load(  )
        for i=1,self.size do
            self.p[i] = self.permutation[i]
            self.p[256+i] = self.p[i]
        end
    end

    function perlin:noise( x, y, z )
        local X = math.floor(x) % 256
        local Y = math.floor(y) % 256
        local Z = math.floor(z) % 256
        x = x - math.floor(x)
        y = y - math.floor(y)
        z = z - math.floor(z)
        local u = fade(x)
        local v = fade(y)
        local w = fade(z)
        local A  = self.p[X+1]+Y
        local AA = self.p[A+1]+Z
        local AB = self.p[A+2]+Z
        local B  = self.p[X+2]+Y
        local BA = self.p[B+1]+Z
        local BB = self.p[B+2]+Z

        return lerp(w, lerp(v, lerp(u, grad(self.p[AA+1], x  , y  , z  ),
                    grad(self.p[BA+1], x-1, y  , z  )),
                lerp(u, grad(self.p[AB+1], x  , y-1, z  ),
                    grad(self.p[BB+1], x-1, y-1, z  ))),
            lerp(v, lerp(u, grad(self.p[AB+2], x  , y  , z-1),
                    grad(self.p[BA+2], x-1, y  , z-1)),
                lerp(u, grad(self.p[AB+2], x  , y-1, z-1),
                    grad(self.p[BB+2], x-1, y-1, z-1))))
    end
    
    function fade( t )
        return t * t * t * (t * (t * 6 - 15) + 10)
    end

    function lerp( t, a, b )
        return a + t * (b - a)
    end

    function len(x,y)
        return math.sqrt(x * x + y * y)
    end

    function grad( hash, x, y, z )
        local h = hash % 16
        local u = h < 8 and x or y
        local v = h < 4 and y or ((h == 12 or h == 14) and x or z)
        return ((h % 2) == 0 and u or -u) + ((h % 3) == 0 and v or -v)
    end
    
    perlin:load()
    local i = 0
    maxLen = (len(1-(mapping.columns/2),15-(mapping.rows/2))^4)
    while i < loadLimit do
        if loaded[2] > mapping.rows then
            loaded[1] = loaded[1]+1
            loaded[2] = 1
        end
        if loaded[1] > mapping.columns then
            ready = true
            break
        end
        if not map[loaded[1]] then
            map[loaded[1]] = {}
        end
        map[loaded[1]][loaded[2]] = 
        perlin:noise((off+loaded[1])/square,(off+loaded[2])/square,square)-- - 
        --math.min(1,(len(loaded[1]-(mapping.columns/2),loaded[2]-(mapping.rows/2))^4)/maxLen)
        band[1] = math.min(band[1],map[loaded[1]][loaded[2]])
        band[2] = math.max(band[2],map[loaded[1]][loaded[2]])
        loaded[2] = loaded[2] + 1
        i = i + 1
    end
    
    addText(l,font,"Loaded: "..((loaded[1]-1)*mapping.rows)+loaded[2],rx/2,200)
    requestAnimationFrame(1)
else
    -- Noise is loaded and "ready" is set to true
    
    l2 = createLayer()
    
    -- Create particles
    if not particlesReady then
        particlesReady = true
                
        particles = {}
        for i=1,numParticles do
            local particle = {}
            particle.pos = {math.random()*rx,math.random()*ry}
            particle.vel = {(math.random()-0.5)*2,(math.random()-0.5)*2}
            particle.acc = {0,0}
            
            particles[i] = particle
            end
        
        function DrawParticles()
            --setDefaultFillColor(l2,Shape_Circle,0.5,0.6,1,1)
            setDefaultFillColor(l2,Shape_Circle,0.8,0.9,1,1)
            for _,particle in ipairs(particles) do
                --local value = map[Clamp(1+math.floor(particle.pos[1]/rx*mapping.columns),1,mapping.columns)][Clamp(1+math.floor(particle.pos[2]/ry*mapping.rows),1,mapping.rows)]
                
                addCircle(l2,particle.pos[1],particle.pos[2],1)
                --addText(l,font,"v:"..value,particle.pos[1],particle.pos[2])
                end
            end
        
        function MoveParticles()
            for _,particle in ipairs(particles) do
                --reset acc to 0
                particle.acc = {0,0}
                
                -- get dir from noise map
                local value = map[Clamp(1+math.floor(particle.pos[1]/rx*mapping.columns),1,mapping.columns)][Clamp(1+math.floor(particle.pos[2]/ry*mapping.rows),1,mapping.rows)]
                particle.acc[1] = math.cos((value+0.5)*3.5)/100
                particle.acc[2] = math.sin((value+0.5)*3.5)/100
                --[[
                    V.x = cos(A)
                    V.y = sin(A)
                    ]]--
                
                
                --add acc to vel
                particle.vel[1] = particle.vel[1] + particle.acc[1]
                particle.vel[2] = particle.vel[2] + particle.acc[2]
                
                --normalize vel
                particle.vel = Normalize(particle.vel)
                
                --add vel to pos
                particle.pos[1] = particle.pos[1] + particle.vel[1]
                particle.pos[2] = particle.pos[2] + particle.vel[2]
                
                --wrap around screen
                if particle.pos[1] < 0  then particle.pos[1] = rx end
                if particle.pos[1] > rx then particle.pos[1] = 0  end
                if particle.pos[2] < 0  then particle.pos[2] = ry end
                if particle.pos[2] > ry then particle.pos[2] = 0  end
                
                end
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
        
        function Clamp(v,min,max)
            if v <= min then
                return min
            elseif v >= max then
                return max
            else
                return v 
                end
            end
        
        end
    
    -- Draw the noise map
    --[[
    for c=1, mapping.columns, 1 do
        for r=1, mapping.rows, 1 do
            local v = math.floor(map[c][r]*100)/100
            setNextFillColor(l,v,v,v,1)
            addBox(l,(c-1)*(rx/mapping.columns),(r-1)*(ry/mapping.rows),(rx/mapping.columns),(ry/mapping.rows))
            end
        end
    ]]--
    
    setBackgroundColor(0.3,0.5,1,1)
    
    DrawParticles()
    MoveParticles()
    
    --addText(l,font,"Particles: "..#particles,10,ry-10)
    layerTitle = createLayer()
    font = loadFont('Play-Bold', 14) 
    setDefaultFillColor(layerTitle, Shape_Text, 0.1, 0.1, 0.2, 1) 
    addBox(layerTitle, 30, ry-64, 220, 32)
    addText(layerTitle, font, "F L O W . . . . . .", 42, ry-42)
    
    requestAnimationFrame(1)
end



--[[ Some dude named Bonusaben made this ]]--
--[[   Come visit the Underdun Arcade    ]]--
