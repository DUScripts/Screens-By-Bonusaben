--[[ Soup ]]--

if not init then
    init = true
    
    rx,ry = getResolution()

    numParticles = 100
    sepDist = 25
    coherenceMul = 7
    separationMul = 1
    alignmentMul = 3
    centerAttractMul = 7
    maxSpeed = 2
    
    
    particles = {}
    for i=1,numParticles do
        local particle = {}
        particle.pos = {math.random()*rx,math.random()*ry}
        particle.vel = {(math.random()-0.5)*2,(math.random()-0.5)*2}
        particle.acc = {0,0}
		
        particles[i] = particle
        end
	
    function DrawParticles()
        setDefaultFillColor(l1,Shape_Circle,0,0,0,1)
        for _,particle in ipairs(particles) do
            addCircle(l1,particle.pos[1],particle.pos[2],2)
            --addText(l,font,"v:"..value,particle.pos[1],particle.pos[2])
            end
        end
	
    function MoveParticles()
        
        
        
        --get avg position and dir
        for _,particle in ipairs(particles) do
            avgPos[1] = avgPos[1] + particle.pos[1]
            avgPos[2] = avgPos[2] + particle.pos[2]
            avgVel[1] = avgVel[1] + particle.vel[1]
            avgVel[2] = avgVel[2] + particle.vel[2]
            end
        
        avgPos[1] = avgPos[1]/numParticles
        avgPos[2] = avgPos[2]/numParticles
        avgVel[1] = avgVel[1]/numParticles
        avgVel[2] = avgVel[2]/numParticles
        avgVel = Normalize(avgVel)
        
        for _,particle in ipairs(particles) do
            --reset acc to 0
            particle.acc = {0,0}
            
            -- COHERENCE  - Steer toward average position
            local dirToAvgPos = {avgPos[1] - particle.pos[1],avgPos[2]-particle.pos[2]}
            dirToAvgPos = Normalize(dirToAvgPos)
            particle.acc[1] = particle.acc[1] + dirToAvgPos[1] * coherenceMul
            particle.acc[2] = particle.acc[2] + dirToAvgPos[2] * coherenceMul
            --addText(l1,font,(math.floor(dirToAvgPos[1]*100)/100)..","..(math.floor(dirToAvgPos[2]*100)/100),particle.pos[1],particle.pos[2]+10)
            
            -- SEPARATION - avoid eachother
            local d = 0
            local dirFromOther = {0,0}
            for i=1,numParticles do
                d = GetMag(particle.pos,particles[i].pos)
                if d < sepDist and d > 0.01 then
                    -- me - him
                    dirFromOther = Normalize({particle.pos[1] - particles[i].pos[1],particle.pos[2] - particles[i].pos[2]})
                    particle.acc[1] = particle.acc[1] + dirFromOther[1] * separationMul
                    particle.acc[2] = particle.acc[2] + dirFromOther[2] * separationMul
                    end
                end
            
            -- ALIGNMENT  - match others average direction
            particle.acc[1] = particle.acc[1] + avgVel[1] * alignmentMul
            particle.acc[2] = particle.acc[2] + avgVel[2] * alignmentMul
            
            -- move towards center of screen
            local dirToCenter = {rx/2 - particle.pos[1],ry/2-particle.pos[2]}
            dirToCenter = Normalize(dirToCenter)
            
            particle.acc[1] = particle.acc[1] + dirToCenter[1] * centerAttractMul
            particle.acc[2] = particle.acc[2] + dirToCenter[2] * centerAttractMul
            
            --normalize acc
            particle.acc = Normalize(particle.acc)
            
            --add acc to vel
            particle.vel[1] = particle.vel[1] + particle.acc[1]
            particle.vel[2] = particle.vel[2] + particle.acc[2]
            
            --normalize vel
            --particle.vel = Normalize(particle.vel)
			
            --add vel to pos
            particle.pos[1] = particle.pos[1] + particle.vel[1]
            particle.pos[2] = particle.pos[2] + particle.vel[2]
			
            --wrap around screen
            --[[
            if particle.pos[1] < 0  then particle.pos[1] = rx end
            if particle.pos[1] > rx then particle.pos[1] = 0  end
            if particle.pos[2] < 0  then particle.pos[2] = ry end
            if particle.pos[2] > ry then particle.pos[2] = 0  end
            ]]--
            
            --flip at edges
            if particle.pos[1] < 0  then 
                particle.pos[1] = 0
                particle.vel[1] = particle.vel[1]*-0.2
            end
            if particle.pos[1] > rx then 
                particle.pos[1] = rx
                particle.vel[1] = particle.vel[1]*-0.2
            end
            if particle.pos[2] < 0  then 
                particle.pos[2] = 0
                particle.vel[2] = particle.vel[2]*-0.2
            end
            if particle.pos[2] > ry then 
                particle.pos[2] = ry
                particle.vel[2] = particle.vel[2]*-0.2
            end
			
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
    
    
    end -- end init


-- RENDERING
l1 = createLayer()
setBackgroundColor(1,1,1,1)

avgPos = {0,0}
avgVel = {0,0}

MoveParticles()
DrawParticles()


layerTitle = createLayer()
font = loadFont('Play-Bold', 14) 
setDefaultFillColor(layerTitle, Shape_Text, 0.1, 0.1, 0.2, 1) 
addBox(layerTitle, 30, ry-64, 220, 32)
addText(layerTitle, font, "S O U P . . . . . .", 42, ry-42)

requestAnimationFrame(1)






--[[ Some dude named Bonusaben made this ]]--
--[[   Come visit the Underdun Arcade    ]]--
