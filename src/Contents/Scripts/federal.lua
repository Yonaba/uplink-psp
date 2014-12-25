--[[ Uplink For PSP
  Database definition File
   - Create Database Class
   - Sets funcs
  ]]
  
Database = {count=0,viewing = 'passwordScreen'}
database = {}

function Database:new(id,monitor,firewall,proxy,cypher,level)
  local database = {id = id,connected = false,viewing = 'passwordScreen'}
  database.monitor = (monitor) and true or nil
  database.firewall = (firewall) and true or nil
  database.proxy = (monitor) and true or nil  
  database.cypher = (cypher) and true or nil
  database.level  = {}
  database.trace = 0
  database.hackAttempt = 0
  database.password = getNewPassword(Dictionnary)
  database.DEFAULT_TRACEBACK = 5
    if database.firewall then database.level.firewall = level[2] end
    if database.proxy then database.level.proxy = level[3] end
    if database.monitor then database.level.monitor = level[1] end  
  setmetatable(database,self)
  self.__index = self
  return database
end

function Database:traceback()
  if self.viewing == 'passwordScreen' then
    if data then
      if (self.monitor~=nil) and (self.monitor==true) then
        if data[54]:isActive() then self.trace = self.DEFAULT_TRACEBACK*2 
        else self.trace = 0
        end
      else self.trace = 0  
      end
    end
  else self.trace = self.DEFAULT_TRACEBACK
  end
  --oldprint('trace is ',self.trace)
  if Interface then Interface.traceback = Interface.traceback + self.trace end
end

function Database:resetSecurity()
  if (self.monitor~=nil) then self.monitor = true end
  if (self.proxy~=nil) then self.proxy = true end
  if (self.firewall~=nil) then self.firewall = true end
  if (self.cypher~=nil) then self.cypher = true end
end

function Database:resetAdminPassword()
  self.password = getNewPassword(Dictionnary)
end

function Database:drawSecurity(greenlight,redlight,greylight)    
  if (self.monitor~=nil) then 
  screen:blit(300,120,((self.monitor==true) and greenlight or redlight))
  print(320,120,((self.monitor==true) and locale.monitorEnabled or locale.monitorDisabled))
  else 
  screen:blit(300,120,greylight)
  print(320,120,locale.noMonitor)
  end
    
  if (self.firewall~=nil) then 
  screen:blit(300,135,((self.firewall==true) and greenlight or redlight))
  print(320,135,((self.firewall==true) and locale.firewallEnabled or locale.firewallDisabled))
  else 
  screen:blit(300,135,greylight)
  print(320,135,locale.noFirewall)
  end
      
  if (self.proxy~=nil) then 
  screen:blit(300,150,((self.proxy==true) and greenlight or redlight))
  print(320,150,((self.proxy==true) and locale.proxyEnabled or locale.proxyDisabled))
  else 
  screen:blit(300,150,greylight)
  print(320,150,locale.noProxy)
  end  
      
  if (self.cypher~=nil) then 
  screen:blit(300,165,((self.cypher==true) and greenlight or redlight))
  print(320,165,((self.cypher==true) and locale.cypherEnabled or locale.cypherDisabled))
  else 
  screen:blit(300,165,greylight)
  print(320,165,locale.noCypher)
  end  
end

function Database:drawPasswordScreen()  
local greenlight = Image.load('./Contents/graphics/software/greenlight.jpg')
local redlight = Image.load('./Contents/graphics/software/redlight.jpg')
local greylight = Image.load('./Contents/graphics/software/greylight.jpg')
local passcreenImg = Image.load('./Contents/graphics/passwordscreen.jpg')
self.ButtonPass = Button:new {w = 151, h =21,x = 40+35,y=40+63,desc = locale.buttonPass}
self:resetAdminPassword()

function validate(t)
  t.viewing='Records'
end
self.ButtonPass:connect(validate,self)

local oldkey = Controls.read()
  while self.viewing=='passwordScreen' and Interface.connected do
  local key = Controls.read()
  updateEnv()
  screen:blit(40,40,passcreenImg)
  self:drawSecurity(greenlight,redlight,greylight)
  self:traceback()
  self.ButtonPass:draw(cursor,key,oldkey,self.password)    
  --print(380,260,self.viewing)
  Interface.draw(cursor,key,oldkey)  
  swapBuffers()
  oldkey = key
  end
  self.trace = 0
end

function Database:updateRecords(Interface,curId)
  if (self.proxy~=nil) and (self.proxy==true) then
  System.message(locale.modProxy,0)
  self.trace = self.DEFAULT_TRACEBACK*2
  return
  end
  if (self.firewall~=nil) and (self.firewall==true) then
  System.message(locale.modFirewall,0)
  self.trace = self.DEFAULT_TRACEBACK*2
  return
  end
  if (self.cypher~=nil) and (self.cypher==true) then
  System.message(locale.modCypher,0)
  self.trace = self.DEFAULT_TRACEBACK*2
  return
  end  
local set = records[Interface.locale][self.id]
System.message(locale.confirmUpdateRecords,1)
  if System.buttonPressed(1)~='yes' then return end  
  if self.id == 'International Academic Database' then
  --Modify Degree
  local str =''
    for k in ipairs(set) do str= str..k..' : '..set[k]..'\n' end 
  System.message(locale.explainUpdateDegree..str,1)
    if System.buttonPressed(1)=='yes' then
    local n_Degree = tonumber(System.startOSK('',''))    
      if n_Degree and n_Degree >= -1 and n_Degree <= #set then
        if People[curId] then
          if n_Degree == -1 then People[curId].degree = 0
          elseif n_Degree ~= 0 then People[curId].degree = n_Degree
          --System.message('n_degree was '..n_Degree..' and curFile is '..curId,0)
          --System.message('degree '..,0)
          end
        System.message(locale.updated,0)
        end  
      else System.message(locale.notValidDegree,0)
      end
    else System.message(locale.degreeNotModified,0)
    end    
    
  --Modify Degree Class
  System.message(locale.explainUpdateDegreeClass,1)
    if System.buttonPressed(1)=='yes' then
    local n_DegreeClass = tonumber(System.startOSK('',''))    
      if n_DegreeClass and n_DegreeClass >= 1 and n_DegreeClass <= 4 then
        if People[curId] then
        People[curId].degreeClass = n_DegreeClass
        System.message(locale.updated,0)
        end  
      else System.message(locale.notValidDegreeClass,0)
      end
    else System.message(locale.degreeClassNotModified,0)
    end
  end

  if self.id == 'International Social Database' then
  --Modify Marital status
  local str=''
    for k in ipairs(set) do  if k <= 5 then str = str..k..' : '..set[k]..'\n' end end
  System.message(locale.explainUpdateMarital..str,1)
    if System.buttonPressed(1)=='yes' then
    local n_Marital = tonumber(System.startOSK('',''))    
      if n_Marital and n_Marital >= 0 and n_Marital <= 5 then
        if People[curId] then
          if n_Marital ~= 0 then People[curId].maritalStatus = n_Marital end
        end
      System.message(locale.updated,0)
      else System.message(locale.notValidMarital,0)
      end
    else System.message(locale.MaritalNotModified,0)
    end    
    
  --Modify Social Status
  local str=''
    for k in ipairs(set) do  if k > 5 then str = str..(k-5)..' : '..set[k]..'\n' end end
  System.message(locale.explainUpdateSocial..str,1)
    if System.buttonPressed(1)=='yes' then
    local n_Social = tonumber(System.startOSK('',''))    
      if n_Social and n_Social >= 0 and n_Social <= 4 then
        if People[curId] then
          if n_Social ~= 0 then People[curId].socialStatus = n_Social+5 end
        System.message(locale.updated,0)
        end  
      else System.message(locale.notValidSocial,0)
      end
    else System.message(locale.socialNotModified,0)
    end
  end
  
  if self.id == 'International Criminal Database' then
  --Modify Conviction status
  local str=''
    for k in ipairs(set) do str=str..k..' : '..set[k]..'\n' end
  System.message(locale.explainUpdateConviction..str,1)
    if System.buttonPressed(1)=='yes' then
    local n_Conviction = tonumber(System.startOSK('',''))    
      if n_Conviction and n_Conviction >= -1 and n_Conviction <= #set then
        if People[curId] then
          if n_Conviction == -1 then People[curId].conviction = 0 
          elseif n_Marital ~= 0 then 
          People[curId].conviction = n_Conviction 
            if Interface then News.launch(Interface,4,Interface.getTimeString(),People[curId].name..' '..People[curId].name2,records[Interface.locale][self.id][n_Conviction]) end
          end
        end
      System.message(locale.updated,0)
      else System.message(locale.notValidConviction,0)
      end
    else System.message(locale.convictionNotModified,0)
    end    
    
  end
  
  if People and Interface then saveCommit(People,Interface) end
end --end func

function Database:drawRecords()
local numfiles = #People

local lK = Image.load('./Contents/graphics/arrows/left.jpg')
local rK = Image.load('./Contents/graphics/arrows/right.jpg')


local commit = Image.load('./Contents/graphics/hud/commit.jpg')
local Commit = Icon:new{img = commit,w = commit:width(), h = commit:height(),
            x = Interface.Buttons.profile.x+Interface.Buttons.profile.w+2,y=SCREEN_HEIGHT-14-commit:height(),
            ID='Commit',text = locale.modifyRecords}

local curFile = 1            
--Commit:connect(self.updateRecords,self,Interface,curFile)            


  local function explore(key,oldkey)
    if key and oldkey then
      if key:l() and not oldkey:l() and People[curFile-1] then 
      curFile = curFile-1 
      --Commit:connect(self.updateRecords,self,Interface,curFile)
      end
      if key:r() and not oldkey:r() and People[curFile+1] then 
      curFile = curFile+1 
      --Commit:connect(self.updateRecords,self,Interface,curFile)
      end
      Commit:connect(self.updateRecords,self,Interface,curFile)
    end
  end
  
  local function drawArrows(curFile)
  local lftK = People[curFile-1]
  local rgtK = People[curFile+1]
    if lftK then screen:blit(30,60+30,lK) end
    if rgtK then screen:blit(30+100+45,60+30,rK) end  
  end
  
  local function drawFile(curFile,s)
    if records then
    print(30,60+100+15,locale.file..People[curFile].name..' '..People[curFile].name2)    
      if s.id=='International Academic Database' then 
      print(30,60+100+30,locale.grade..tostring(records[Interface.locale][s.id][People[curFile].degree] or ' - ')..'/'..(People[curFile].degreeClass or ' - '))
      elseif s.id=='International Social Database' then 
      print(30,60+100+30,locale.social..tostring(records[Interface.locale][s.id][People[curFile].socialStatus]))
      print(30,60+100+45,locale.marital..tostring(records[Interface.locale][s.id][People[curFile].maritalStatus]))
      elseif s.id == 'International Criminal Database' then 
        if People[curFile].conviction~='' then print(30,60+100+30,locale.criminal..tostring(records[Interface.locale][s.id][People[curFile].conviction] or ' - ')) end
      end    
    end
  screen:blit(60,60,People[curFile].img)
  end
  
local oldkey = Controls.read()
if Interface then News.launch(Interface,2,Interface.getTimeString(),self.id,nil) end

  while self.viewing=='Records' and Interface.connected do
  local key = Controls.read()
  updateEnv()  
  explore(key,oldkey)
  drawFile(curFile,self)
  drawArrows(curFile)
  self:traceback()
  Commit:draw(cursor,key,oldkey)
  --print(380,260,self.viewing)
  Interface.draw(cursor,key,oldkey)  
  swapBuffers()
  oldkey = key
  end
  self.viewing = 'passwordScreen'
  self.trace = 0
  self:resetSecurity()
end


database[1]=Database:new('International Academic Database',true,true,false,false,{3,2,2})
database[2]=Database:new('International Social Database',true,true,false,true,{2,2,3})
database[3]=Database:new('International Criminal Database',true,true,true,false,{2,2,4})
