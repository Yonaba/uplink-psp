--[[ Uplink For PSP
  Bank Class definition File
   - Create Bank Class
   - Sets funcs
  ]]
  
Bank = {count=0,viewing = 'passwordScreen',breakIn=false,PeopleId=0}
bank = {}

function Bank:new(id,monitor,firewall,proxy,cypher,level)
  local bank = {id = id,connected = false,viewing = 'passwordScreen',breakIn=false}
  bank.monitor = (monitor) and true or nil
  bank.firewall = (firewall) and true or nil
  bank.proxy = (monitor) and true or nil  
  bank.cypher = (cypher) and true or nil
  bank.trace = 0
  bank.DEFAULT_TRACEBACK = 8
  bank.level  = {}
  if bank.firewall then bank.level.firewall = level[2] end
  if bank.proxy then bank.level.proxy = level[3] end
  if bank.monitor then bank.level.monitor = level[1] end
  setmetatable(bank,self)
  self.__index = self
  return bank
end

function Bank:traceback()
  if self.viewing ~= 'passwordScreen' then    
  self.trace =  self.DEFAULT_TRACEBACK
  end
  --oldprint('trace is ',self.trace)
  if Interface and self.trace>0 then Interface.traceback = Interface.traceback + self.trace end
end

function Bank:resetSecurity()
  if (self.monitor~=nil) then self.monitor = true end
  if (self.proxy~=nil) then self.proxy = true end
  if (self.firewall~=nil) then self.firewall = true end
  if (self.cypher~=nil) then self.cypher = true end
end

function Bank:drawSecurity(greenlight,redlight,greylight)    
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

function Bank:drawPasswordScreen()  
local greenlight = Image.load('./Contents/graphics/software/greenlight.jpg')
local redlight = Image.load('./Contents/graphics/software/redlight.jpg')
local greylight = Image.load('./Contents/graphics/software/greylight.jpg')
local passcreenImg = Image.load('./Contents/graphics/userid.jpg')
self.ButtonId = Button:new {w = 150, h =16,x = 40+58,y=40+49,desc = locale.accountNumber}
self.ButtonPass = Button:new {w = 150, h =16,x = 40+58,y=40+72,desc = locale.accountPass}

  function validate(t)
    t.viewing='Records'
  end

self.ButtonPass:connect(validate,self)

  function self.ButtonId:draw(cursor,key,oldkey)
    if self:isOn(cursor) then
      if key and oldkey then
        if key:cross() and not oldkey:cross() then
        self.text = System.startOSK('','')
        local k = searchFieldValue(People,'acc',self.text)
        --io.write(k)
          if not k then 
          System.message(locale.noAccount,0) 
          self.text = ''
          end
        end
      end    
    self:highlight(color)
      if self.desc then self:typeWrite() end
    else self.i=0
    end
    if self.text then print(self.x+10,self.y+5,self.text) end
  end

  function self.ButtonPass:draw(cursor,key,oldkey,bk)
  if self:isOn(cursor) then
    if key and oldkey then
      if key:cross() and not oldkey:cross() then
        if bk.ButtonId.text~='' then
        self.text = System.startOSK('','')
        local k = searchFieldValue(People,'pass',self.text)
          if k then
          Bank.PeopleId = k
          --bk.breakIn = true
            if self.f then self.f(unpack(self.arg)) end
            if Interface then News.launch(Interface,3,Interface.getTimeString(),nil,nil) end
          else
          System.message(locale.wrongPass,0)
          self.text = ''
          end
        else System.message(locale.accountFillFirst,0) 
        end
      end
    end    
  self:highlight(color)
    if self.desc then self:typeWrite() end
  else self.i=0
  end
  if self.text then print(self.x+10,self.y+5,self.text) end
end

local oldkey = Controls.read()
  while self.viewing=='passwordScreen' and Interface.connected do
  local key = Controls.read()
  updateEnv()
  screen:blit(40,40,passcreenImg)
  self.ButtonId:draw(cursor,key,oldkey)
  self.ButtonPass:draw(cursor,key,oldkey,self)
  self:drawSecurity(greenlight,redlight,greylight)
  self:traceback()  
  --print(380,260,self.viewing)
  Interface.draw(cursor,key,oldkey)  
  swapBuffers()
  oldkey = key
  end
  self.trace = 0
end

function Bank:moneyTransfer()
  if (self.proxy~=nil) and (self.proxy==true) then
  System.message(locale.transferProxy,0)
  self.trace = self.DEFAULT_TRACEBACK*2
  return
  end
  if (self.firewall~=nil) and (self.firewall==true) then
  System.message(locale.transferFirewall,0)
  self.trace = self.DEFAULT_TRACEBACK*2
  return
  end
  if (self.cypher~=nil) and (self.cypher==true) then
  System.message(locale.transferCypher,0)
  self.trace = self.DEFAULT_TRACEBACK*2
  return
  end  
  
  System.message(locale.askReceiver,0)
  local rcv = System.startOSK('','')
  local checkRcv = searchFieldValue(People,'acc',rcv)
    if checkRcv then
    System.message(locale.confirmSenderPwd,0)
    local senderPwd = System.startOSK('','')
      if (senderPwd==People[self.PeopleId].pass) then
      System.message(locale.amountTransfer,0)
      local money = tonumber(System.startOSK('',0))
        if money then
          if money <= People[self.PeopleId].money then
          People[self.PeopleId].money = People[self.PeopleId].money-money
          People[checkRcv].money = People[checkRcv].money+money
          System.message(locale.transferCommitted,0)
            if People and Interface then saveCommit(People,Interface) end
          else
          System.message(locale.unsufficientAmount,0)
          end        
        else
        System.message(locale.noValidCheckSum,0)
        end
      else
      System.message(locale.wrongSenderPass,0)
      end
    else
    System.message(locale.noReceiver,0)
    end  
end
--
function Bank:drawClientInterface()
local commit = Image.load('./Contents/graphics/hud/commit.jpg')
local Commit = Icon:new{img = commit,w = commit:width(), h = commit:height(),
            x = Interface.Buttons.profile.x+Interface.Buttons.profile.w+2,y=SCREEN_HEIGHT-14-commit:height(),
            ID='Commit',text = locale.transfer}
Commit:connect(self.moneyTransfer,self)
local oldkey = Controls.read()
  while self.viewing=='Records' and Interface.connected do
  local key = Controls.read()
  updateEnv()
  screen:blit(40,40,People[self.PeopleId].img)
  print(40,150,locale.accountOwner..People[self.PeopleId].name)
  print(40,165,locale.accountNumber..People[self.PeopleId].acc)
  print(40,180,locale.accountCredits..People[self.PeopleId].money)
  self:traceback()
  Commit:draw(cursor,key,oldkey)
  --self:moneyTransfer(key,oldkey)
  --print(380,260,self.viewing)
  Interface.draw(cursor,key,oldkey)  
  swapBuffers()
  oldkey = key
  end
  self.viewing = 'passwordScreen'
  self.trace = 0
  self:resetSecurity()
end
--]]

bank[1]=Bank:new('International Bank',true,true,true,true,{3,3,4})
