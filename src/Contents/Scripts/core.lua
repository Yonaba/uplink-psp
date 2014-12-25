--[[ Uplink For PSP
  CoreFunctions definition File
   - sets basic function using int the game code
  ]]
  
font = Font.load('./Contents/Fonts/dungeon.ttf')
font:setPixelSizes(8,10)
math.randomseed(os.time())

Dictionnary={"system","computer","mouse","fucktheboss","screen","monitor","linker",
          "connection","dismissed","threatened","cablelink","universal","datastore",
          "security","basical","rosebud","program","entertain","network","benchmark",
          "cursor","arrays","comptability","gamingroom","universe","unveil","lordsoftheworld",
          "cooler","wintercrash","burdenage","diabolicum","ilovejenna"}

oldprint = print

function getNewPassword(l)
  return l[math.random(1,#l)]
end

function tenFloor(n)
  while (n%10)~=0 do
  n=n+1
  end
  return n
end

function thousandFloor(n)
  while n%1000 ~= 0 do
  n=n-1
    if n < 20000 then return 20000 end
  end
  return n
end

function seekFor(t,v)
  for k in ipairs(t) do
    if t[k].money >= v then return k end
  end
  return nil
end

function getFontSize(f,text)
  if f then 
  local w = Font.getTextSize(f,text)
  return w.width
  end
  return nil
end

function print(x,y,text,color)
screen:print(x,y,text,color or WHITE)
end

function printf(x,y,text,size,color)
screen:fontPrint(font,x,y,text,color or WHITE)
end

function printSpef(font,x,y,text,color)
screen:fontPrint(font,x,y,text,color or WHITE)
end

function formatTime(n)
  return ((n <=9) and string.format('0%d',n) or n)
end

function updateEnv()
  if playList and not Music.playing() then
  local trackPath = playList.getNewStream()
  Music.playFile(trackPath,true)
  end
  screen:clear()
  --print(0,0,tostring(Music.playing()))
end

--Sync screens
function swapBuffers()
screen.waitVblankStart()
screen.flip()
end

function staticIsOn(st,o)
  if st.x > o.x and st.x < o.x+o.w and st.y > o.y and st.y < o.y+o.h then return true end
return false
end

function drawrect(x,y,w,h,color)
  screen:drawLine(x,y,x+w,y,color or YELLOW)
  screen:drawLine(x,y,x,y+h,color or YELLOW)
  screen:drawLine(x+w,y,x+w,y+h,color or YELLOW)
  screen:drawLine(x,y+h,x+w,y+h,color or YELLOW)
end

function drawSegment(x,y,x2,y2,color)
  screen:drawLine(x,y,x2,y2,color or YELLOW)
end

function getDistance(a,b) --simple heuristic
  return 10*(math.abs(b.x-a.x)+math.abs(b.y-a.y))
end

--Item is defined so : {x_field,y_field}
function listed(t,item)
  for k,itm in ipairs(t) do
    if (itm.x==item.x) and (itm.y==item.y) then return k end
  end
return false
end

function table.rawCopy(t,itemIndex)
local ret = {}
  for index,value in pairs(t[itemIndex]) do ret[index] = value end
return ret
end

function moveToEnd(t,itemIndex)
  local item_cpy = table.rawCopy(t,itemIndex)
  local index = listed(t,item_cpy)
    if index then table.remove(t,index) end
  table.insert(t,item_cpy)
end

function searchFieldValue(t,field,value)
  for k in pairs(t) do
    if t[k][field] and t[k][field]==value then return k end
  end
  return nil
end

function isListed(item,t)
  for k in ipairs(t) do
    if t[k]==item then return true end
  end
  return false
end

function rebuild_dataSet(path,t)
  local f = assert(io.open(path,'r'))
  local pos = 0
  if f and t then
  repeat
  local l = f:read()
    if l then
    --print('l=',l)
    local id = (string.find(l,'#') and searchFieldValue(t,'name',string.gsub(l,'#','')) or nil)
      if id and t[id] then
      pos = f:seek()
      t[id].money = (tonumber(f:read()) or 0)--banking
      t[id].degree = (tonumber(f:read()) or 0)--degree
      t[id].degreeClass = (tonumber(f:read()) or 0) --class
      t[id].maritalStatus = (tonumber(f:read()) or 0) --marital status
      t[id].socialStatus = (tonumber(f:read()) or 0)--social status
      t[id].conviction = (tonumber(f:read()) or 0)--conviction
      end      
    else break
    end  
  until (not l)
  end
f:close()
end

function saveCommit(t,Interface)
  if Interface then
  local f = assert(io.open('./Contents/profiles/'..Interface.currentProfile.curName..'_profile_dataset.lua','w'))
  local field = {'name','name2','pass','acc','img'}
    if f then
      for k=1,(#t)-1 do
        for key,value in pairs(t[k]) do
          if not isListed(key,field) then
          f:write('People['..k..'].'..key..'='..value..'\n')
          end
        end
      end  
    end
  f:close()
  end
end

function getIndexFromString(str,T) 
  local t = {}
  for index in string.gfind(str,'%d+') do 
  local Idx = tonumber(index)
    if Idx and T[Idx] then table.insert(t,Idx) end    
  end
  return t
end

function getTimeFromString(str)
local t={}
  for tm in string.gfind(str,'%d+') do
  local tmr = tonumber(tm)
    if tmr then table.insert(t,tmr) end
  end
return t
end

function typewrite(str,i)
  if i<=str:len() then 
  i=i+1
  return str:sub(1,i)
  else return str
  end
end

function AlphaBlit(splash)
local image = splash
local fader = Image.createEmpty(480,272)
local alphaValue = 255
local faderColor = Color.new(0,0,0,alphaValue)
local FontBattle = Font.load('./Contents/fonts/battle3.ttf')
  FontBattle:setPixelSizes(35,55)
local i = 0
fader:clear(faderColor)
  while true do
  updateEnv()
  screen:blit(0,0,image)
  screen:blit(0,0,fader)
    if alphaValue > 0 then
    alphaValue = alphaValue - 3
    else
    break
    end
  faderColor = Color.new(0,0,0,alphaValue)
  fader:clear(faderColor)
  swapBuffers()
  end
screen.waitVblankStart(200)
  while true do
    --clear()
  screen:blit(0,0,image)
  screen:blit(0,0,fader)
  printSpef(FontBattle,120,230,"Uplink-PSP",YELLOW)
  printf(120,240,typewrite("Elite Freelance Hacker",i),WHITE)
  i=i+1
    if alphaValue < 255 then
    alphaValue = alphaValue + 2
    else
    break
    end
  faderColor = Color.new(0,0,0,alphaValue)
  fader:clear(faderColor)
  swapBuffers()
  end
alphaValue,fader,faderColor,FontBattle = nil,nil,nil,nil
collectgarbage()
end

function startAnim()
local n = math.random(1,5)
local randomSplash = Image.load('./Contents/graphics/loading/'..n..'.jpg')
AlphaBlit(randomSplash)
return
end

function getProfile()
  dofile './Contents/data/profiles.lua'
  return
end

function exitApp()
  System.Quit()
end



function Menu(gc,cursor)
local ID = Image.load('./Contents/graphics/userid.jpg')
local OK = Image.load('./Contents/graphics/proceed.jpg')

local IDx = 280-ID:width()/2
local IDy = 150-ID:height()/2
local OKx = IDx+ID:width()- OK:width()
local OKy = IDy+ID:height()+2
local oldkey = Controls.read()

  while gc.stateMenu do
  local key = Controls.read()
  updateEnv()
  screen:blit(IDx,IDy,ID)
  screen:blit(OKx,OKy,OK)
    for k in pairs(gc.Icons) do gc.Icons[k]:draw(cursor,key,oldkey) end
    for k in pairs(gc.Buttons) do gc.Buttons[k]:drawSpe(cursor,key,oldkey) end
  gc.fill(gc,key,oldkey,cursor)
  cursor.draw()
  swapBuffers()
  oldkey = key
  end
  
end

function GetProfileData(id,pw,loc)
  if id and pw and loc then
    return id..'\n'..pw..'\n'..loc..'\n'..'1\n2\n10\n2\n2531\n5000\n0\n0\n1\n6\n0\ndatum \n0'
  end
end

function connectUplink(l)
  
  local timer = Timer.new()
  timer:start()
  
  local connectionChart={}
  connectionChart['EN'] = { {1,30,'Connecting to Uplink Services'},
                {3,40,'Connection succesfully established'},
                {5,50,'Requesting resgistration form'},
                {7,60,'Downloading'},
                {9,70,'Done. Proceeding registration'},
              }
  connectionChart['FR'] = { {1,30,'Connection au serveur Uplink'},
                {3,40,'Connection etablie'},
                {5,50,'Requete du formulaire d\'inscription'},
                {7,60,'Telechargement en cours'},
                {9,70,'Fait. Procedure d\'inscription initialisee'},
              }          
  
  while true do
  updateEnv()
  local curTime = (timer:time()/1000)
  --print(10,10,curTime)
    for k,str in ipairs(connectionChart[l]) do
      if curTime > str[1] then printf(30,str[2],str[3]) end    
    end
    
    if curTime > 12 then break end
  swapBuffers()
  end
  return
end

function setGateway(l)
  
  local timer = Timer.new()
  timer:start()
  
  local connectionChart={}
  connectionChart['EN'] = { {1,30,'Installing Gateway : Arknos TTG'},
                {3,40,'Installing Kernel and core functions'},
                {5,50,'Installing security packages'},
                {7,60,'Veryfing installation'},
                {9,70,'All done.Back to login Menu'},
              }

  connectionChart['FR'] = { {1,30,'Installation de la passerelle par defaut : Arknos TTG'},
                {3,40,'Installation du Kernel et reglages systeme'},
                {5,50,'Installation des modules de securite'},
                {7,60,'Verifications en cours'},
                {9,70,'Effectue.Retour a l\'ecran d\'accueil'},
              }              
  
  while true do
  updateEnv()
  local curTime = (timer:time()/1000)
  --print(10,10,curTime)
    for k,str in ipairs(connectionChart[l]) do
      if curTime > str[1] then printf(30,str[2],str[3]) end    end
    
    if curTime > 12 then break end
  swapBuffers()
  end
  return
end


