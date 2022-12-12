--[[ Shredded ]]--


--[[ init ]]--

if not init then
    init = true
    
    rx, ry = getResolution()
    mx, my = getCursor()
    
    rows = 20
    cols = 30
    spotSize = 1
    spots = {}
    
    maxDist = ry/rows+15
    minSpeed = 0.6
    maxSpeed = 3
    
    mouseEffectRadius = 150
    
    grav = 1.2
    drag = 0.8
    
    function CreateSpots()
        for y=1,rows do
            spots[y] = {}
            for x=1,cols do
                spots[y][x] = {}
                spots[y][x].pos = {rx/cols*(x-0.5),ry/rows*(y-1)}
                spots[y][x].vel = {0,0}
                spots[y][x].acc = {0,0}            
                end
            end
        end
    
    function DrawSpots()
        for i=1,rows do
            for j=1,cols do
                --addCircle(layer1,spots[i][j].pos[1],spots[i][j].pos[2],spotSize)
                if i > 1 then
                    addLine(layer1, spots[i][j].pos[1], spots[i][j].pos[2], spots[i-1][j].pos[1], spots[i-1][j].pos[2])
                    end
                end
            end
        end
    
    function MoveSpots()
        for y=2,rows do
            for x=1,cols do
                
                -- reset acc
                spots[y][x].acc[1] = 0
                spots[y][x].acc[2] = 0
                
                -- constrain to dot above
                local mag = GetMag(spots[y][x].pos,spots[y-1][x].pos)
                if mag > maxDist then
                    local dir = GetDirNorm(spots[y][x].pos, spots[y-1][x].pos)
                    spots[y][x].acc[1] = spots[y][x].acc[1] + dir[1]*math.min(maxSpeed,mag)
                    spots[y][x].acc[2] = spots[y][x].acc[2] + dir[2]*math.min(maxSpeed,mag)
                    end
                
                -- repel from mouse
                if mx > 0 then -- -1 if off screen
                    local mag = GetMag({mx,my},spots[y][x].pos)
                    if mag < mouseEffectRadius then
                        -- apply force away from mouse
                        local dir = GetDirNorm({mx,my},spots[y][x].pos)
                        spots[y][x].acc[1] = spots[y][x].acc[1] + dir[1]*2
                        spots[y][x].acc[2] = spots[y][x].acc[2] + dir[2]*2
                        end
                    end
                
                
                -- apply gravity
                spots[y][x].acc[2] = spots[y][x].acc[2] + grav
                
                -- apply acc to vel
                spots[y][x].vel[1] = spots[y][x].vel[1] + spots[y][x].acc[1]
                spots[y][x].vel[2] = spots[y][x].vel[2] + spots[y][x].acc[2]
                
                -- apply drag
                spots[y][x].vel[1] = spots[y][x].vel[1] * drag
                spots[y][x].vel[2] = spots[y][x].vel[2] * drag
                
                -- if vel is too slow, stop movement
                if GetMag({0,0},spots[y][x].vel) < minSpeed then
                    spots[y][x].vel[1] = 0
                    spots[y][x].vel[2] = 0
                    end
            
                spots[y][x].pos[1] = spots[y][x].pos[1] + spots[y][x].vel[1]
                spots[y][x].pos[2] = spots[y][x].pos[2] + spots[y][x].vel[2]
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
    
    function GetDirNorm(vec1, vec2)
        local outVec = {}
        outVec[1] = vec2[1] - vec1[1]
        outVec[2] = vec2[2] - vec1[2]
        return Normalize(outVec)
        end
    
    
    CreateSpots()
    
    end

--[[ rendering ]]--
layer1 = createLayer()
layerTitle = createLayer()

layerDebug = createLayer()

local font = loadFont('Play-Bold', 14) 
setDefaultFillColor(layer1, Shape_Circle, 1, 1, 0, 0.8) 
setDefaultFillColor(layer1, Shape_Box, 0.5, 0.5, 0.6, 1) 
setDefaultFillColor(layer1, Shape_Line, 0.5, 0.5, 0.6, 1) 
setDefaultStrokeWidth(layer1, Shape_Line, 20) 
setDefaultFillColor(layerDebug, Shape_Text, 0.1, 0.1, 0.2, 1) 
setDefaultFillColor(layerTitle, Shape_Text, 0.1, 0.1, 0.2, 1) 



-- Spots
mx, my = getCursor()
DrawSpots()
MoveSpots()


addBox(layerTitle, 30, ry-64, 220, 32)
addText(layerTitle, font, "S H R E D D E D . .", 42, ry-42)

requestAnimationFrame(1)






--[[ Some dude named Bonusaben made this ]]--
--[[   Come visit the Underdun Arcade    ]]--
