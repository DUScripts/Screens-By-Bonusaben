--[[ Spoon ]]--

if not init then
    init = true
    
    rx,ry = getResolution()
    sinCounter = 0
    dt = getDeltaTime()
    
    cols = {
        {0.035,0.045,0.08},
        {1.00,1.00,1.00},
        {0.50,0.00,0.12},
        {0.01,0.33,0.50},
        {0.00,0.50,0.35}
    }
    
    --charList = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!#¤%&"
    charList = "ABCČĆDĐEFGHIJKLMNOPQRSŠTUVWXYZŽabcčćdđefghijklmnopqrsštuvwxyzžАБВГҐДЂЕЁЄЖЗЅИІЇЙЈКЛЉМНЊОПРСТЋУЎФХЦЧЏШЩЪЫЬЭЮЯабвгґдђеёєжзѕиіїйјклљмнњопрстћуўфхцчџшщъыьэюяΑΒΓΔΕΖΗΘΙΚΛΜΝΞΟΠΡΣΤΥΦΧΨΩαβγδεζηθικλμνξοπρστυφχψωĂÂÊÔƠƯăâêôơư1234567890‘?’“!”%#{@}&®©$€£¥¢"
    
    end --init

if not Letter then
    letter = {}
    letter.__index = letter
    
    function Letter(layer,parent,increment,char,font,pos,delay,life)
        local self = {}
        self.layer = layer or 1
        self.parent = parent or letters1
        self.increment = increment or ry/20
        self.char = char or ""
        self.font = font
        self.pos = pos or {0,0}
        self.delay = delay or 1
        self.life = life or 1
        self.dtCount = 0.0
        self.activated = false
        return setmetatable(self,letter)
        end
    
    function letter:update()
        setNextFillColor(self.layer,self.life,0.5+self.life,self.life,self.life)
        addText(self.layer,self.font,self.char,self.pos[1],self.pos[2])
        self.life = self.life -0.035
        
        if self.dtCount > self.delay and self.activated == false then
            self.parent[#self.parent+1] = Letter(self.layer,self.parent,self.increment,GetRandomChar(),self.font,{self.pos[1],self.pos[2]+self.increment},self.delay)
            self.dtCount = 0.0
            self.activated = true
            if math.random() > 0.8 then
                self.char = GetRandomChar()
                end
            else
            self.dtCount = self.dtCount + dt
            end
        
        if self.pos[2] > ry then
            self.pos[2] = 0
            end
        
        end
    
    function GetRandomChar()
        local r = math.random(#charList)
        local c = string.sub(charList,r,r)
        return c
        end
    
    end --Letter

setBackgroundColor(0,0.02,0)
l3 = createLayer()
l2 = createLayer()
l1 = createLayer()
font1 = loadFont("RobotoMono",14)
font2 = loadFont("RobotoMono",10)
font3 = loadFont("RobotoMono",7)

if not loaded then
    loaded = 1
    
    letters1 = {}
    letters2 = {}
    letters3 = {}
    
    cols1 = 68
    rows1 = 42
    
    cols2 = 98
    rows2 = 62
    
    cols3 = 148
    rows3 = 82
    
    logMessage("Creating chars")
    for i=1,cols1 do
        letters1[i] = Letter(l1,letters1,ry/rows1,GetRandomChar(),font1,{rx/cols1*i,ry/rows1*math.floor(math.random(rows1))},math.random()/12)
        end
    
    for i=1,cols2 do
        --letters2[i] = Letter(l2,letters2,ry/rows2,GetRandomChar(),font2,{rx/cols2*i,ry/rows2*math.floor(math.random(rows2))},math.random()/5)
        table.insert(letters2, Letter(l2,letters2,ry/rows2,GetRandomChar(),font2,{rx/cols2*i,ry/rows2*math.floor(math.random(rows2))},math.random()/10))
        table.insert(letters2, Letter(l2,letters2,ry/rows2,GetRandomChar(),font2,{rx/cols2*i,ry/rows2*math.floor(math.random(rows2))},math.random()/10))
        end
    
    for i=1,cols3 do
        --letters3[i] = Letter(l3,letters3,ry/rows3,GetRandomChar(),font3,{rx/cols3*i,ry/rows3*math.floor(math.random(rows3))},math.random()/3)
        table.insert(letters3,Letter(l3,letters3,ry/rows3,GetRandomChar(),font3,{rx/cols3*i,ry/rows3*math.floor(math.random(rows3))},math.random()/8))
        table.insert(letters3,Letter(l3,letters3,ry/rows3,GetRandomChar(),font3,{rx/cols3*i,ry/rows3*math.floor(math.random(rows3))},math.random()/8))
        --table.insert(letters3,Letter(l3,letters3,ry/rows3,GetRandomChar(),font3,{rx/cols3*i,ry/rows3*math.floor(math.random(rows3))},math.random()/8))
        --table.insert(letters3,Letter(l3,letters3,ry/rows3,GetRandomChar(),font3,{rx/cols3*i,ry/rows3*math.floor(math.random(rows3))},math.random()/8))
        end
    
    
    
    end




for i=#letters1,1,-1 do
    letters1[i]:update()
    if letters1[i].life <= 0 then
        table.remove(letters1,i)
        end
    end

for i=#letters2,1,-1 do
    letters2[i]:update()
    if letters2[i].life <= 0 then
        table.remove(letters2,i)
        end
    end

for i=#letters3,1,-1 do
    letters3[i]:update()
    if letters3[i].life <= 0 then
        table.remove(letters3,i)
        end
    end



-- TITLE
local layerTitle = createLayer()
local fontTitle = loadFont('Play-Bold', 14) 
setDefaultFillColor(layerTitle, Shape_Text, 0.1, 0.1, 0.2, 1) 
addBox(layerTitle, 30, ry-64, 220, 32)
addText(layerTitle, fontTitle, "S P O O N . . . . . . .", 42, ry-42)


sinCounter = sinCounter + 0.05
dt = getDeltaTime()
requestAnimationFrame(1)







--[[ Some dude named Bonusaben made this ]]--
--[[   Come visit the Underdun Arcade    ]]--
