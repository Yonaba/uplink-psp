--[[ Uplink For PSP
  Data Class definition File
   - Create Data Class
   - Creates all available data and setting sofwares
  ]]

Datum = {}
ActivePID = {}

data = {}

function Datum:new(param)
  local f = {type = param.type,name = param.name,cpu = param.cpu or 0, size=param.size,cpuMax = param.cpuMax or 0,desc = param.desc or {['EN']='File containing crucial data.',['FR']='Fichier contenant des donnees sensibles.'},
      cost = param.cost or 0,encryptionlvl = param.encryptionlvl or 0,version = param.version or 0,owner = param.owner or ''}
  setmetatable(f,self)
  self.__index = self
  return f
end

--
function Datum:linkToFunc(f,...)
  if self.type == 'exe' then
    if f then self.f = f end
  else oldprint('cannot link func to dat file') --debug
  end
end

function Datum:execute(...)
  if self.f then self.f(self,unpack(arg)) end
end
--]]

function Datum:isActive()
  local PID = self.index
  if PID then
    for k in ipairs(ActivePID) do
      if ActivePID[k]==PID then return k end
    end
  end
  return false
end

function Datum:hasEnoughCPU()
  local consumed = 0
  for k,PID in ipairs(ActivePID) do
    if data[PID] then consumed = consumed+data[PID].cpu end
  end
  return ((Interface.currentProfile.CPU-consumed) > self.cpu)
end

function Datum:run()
  if self.type=='exe' then
    if self:isActive() then
      System.message(locale.isAlreadyActive,0)
    else
      if self:hasEnoughCPU() then 
      self.cur = 1
      --oldprint('data '..self.index..' loaded') 
      table.insert(ActivePID,self.index)
      else System.message(locale.notEnoughCPU,0)
      end
    end
  else System.message(locale.cannotRunDat,0)
  end
end

function Datum:close()
  local k = self:isActive()
  if ActivePID[k] then table.remove(ActivePID,k) end
end

--create simple files
local Files = {
{name="Bio-09",size=1,encryptionlvl=0,owner = 'Omicron'},
{name="Bio-10",size=6,encryptionlvl=2,owner = 'Omicron'},
{name="Bio-07",size=3,encryptionlvl=0,owner = 'Omicron'},
{name="Bio-08",size=2,encryptionlvl=0,owner = 'Omicron'},
{name="Bio-11",size=3,encryptionlvl=1,owner = 'Omicron'},
{name="Bio-12",size=1,encryptionlvl=3,owner = 'Omicron'},
{name="Bio-01",size=1,encryptionlvl=4,owner = 'Omicron'},
{name="Bio-02",size=1,encryptionlvl=4,owner = 'Omicron'},
{name="Bio-03",size=2,encryptionlvl=4,owner = 'Omicron'},
{name="Bio-05",size=2,encryptionlvl=4,owner = 'Omicron'},
{name="Bio-04",size=3,encryptionlvl=4,owner = 'Omicron'},
{name="Bio-06",size=8,encryptionlvl=4,owner = 'Omicron'},
{name="Cryo-10",size=3,encryptionlvl=4,owner = 'DataLabs'},
{name="Cryo-07",size=1,encryptionlvl=0,owner = 'DataLabs'},
{name="Cryo-08",size=2,encryptionlvl=3,owner = 'DataLabs'},
{name="Cryo-01",size=3,encryptionlvl=0,owner = 'DataLabs'},
{name="Cryo-02",size=4,encryptionlvl=0,owner = 'DataLabs'},
{name="Cryo-03",size=3,encryptionlvl=2,owner = 'DataLabs'},
{name="Cryo-05",size=9,encryptionlvl=0,owner = 'DataLabs'},
{name="Cryo-00",size=3,encryptionlvl=3,owner = 'DataLabs'},
{name="Cryo-06",size=9,encryptionlvl=0,owner = 'DataLabs'},
{name="Cryo-11",size=9,encryptionlvl=0,owner = 'DataLabs'},
{name="Cryo-12",size=7,encryptionlvl=0,owner = 'DataLabs'},
{name="Cryo-16",size=9,encryptionlvl=0,owner = 'DataLabs'},
{name="Cryo-20",size=3,encryptionlvl=5,owner = 'DataLabs'},
{name="Cryo-15",size=9,encryptionlvl=0,owner = 'DataLabs'},
{name="Cryo-13",size=2,encryptionlvl=0,owner = 'DataLabs'},
{name="Cryo-19",size=9,encryptionlvl=0,owner = 'DataLabs'},
{name="Cryo-14",size=6,encryptionlvl=0,owner = 'DataLabs'},
{name="Cryo-18",size=9,encryptionlvl=5,owner = 'DataLabs'},
{name="Cryo-17",size=9,encryptionlvl=5,owner = 'DataLabs'},
{name="Src-10",size=3,encryptionlvl=4,owner = 'Trinity'},
{name="Src-07",size=10,encryptionlvl=3,owner = 'Trinity'},
{name="Src-08",size=4,encryptionlvl=3,owner = 'Trinity'},
{name="Src-01",size=5,encryptionlvl=0,owner = 'Trinity'},
{name="Src-02",size=5,encryptionlvl=0,owner = 'Trinity'},
{name="Src-03",size=4,encryptionlvl=2,owner = 'Trinity'},
{name="Src-05",size=9,encryptionlvl=0,owner = 'Trinity'},
{name="Src-00",size=3,encryptionlvl=3,owner = 'Trinity'},
{name="Src-06",size=9,encryptionlvl=2,owner = 'Trinity'},
{name="Src-11",size=9,encryptionlvl=1,owner = 'Trinity'},
{name="Src-12",size=7,encryptionlvl=0,owner = 'Trinity'},
{name="Src-16",size=2,encryptionlvl=0,owner = 'Trinity'},
{name="Src-15",size=9,encryptionlvl=2,owner = 'Trinity'},
{name="Src-13",size=2,encryptionlvl=3,owner = 'Trinity'},
{name="Src-14",size=6,encryptionlvl=2,owner = 'Trinity'},
}

local H_software = {
{_type="Crackers",_soft="Decrypter v1",_version=1,_desc={['EN']="Decrypts any file with one encryption level",['FR']="Decrypte tout fichier crypte au niveau 1."},_price=3000,_size=0.2,_cpu=1,_cpuMax = 0.5},
{_type="Crackers",_soft="Decrypter v2",_version=2,_desc={['EN']="Decrypts any file with two encryption levels or less",['FR']="Decrypte tout fichier crypte au niveau 2 ou moins."},_price=4500,_size=1.5,_cpu=1.2,_cpuMax = 0.5},
{_type="Crackers",_soft="Decrypter v3",_version=3,_desc={['EN']="Decrypts any file with three encryption levels or less",['FR']="Decrypte tout fichier crypte au niveau 3 ou moins."},_price=5500,_size=2.4,_cpu=1.3,_cpuMax = 0.8},
{_type="Crackers",_soft="Decrypter v4",_version=4,_desc={['EN']="Decrypts any file with four encryption levels or less",['FR']="Decrypte tout fichier crypte au niveau 4 ou moins."},_price=7000,_size=2.4,_cpu=1.3,_cpuMax = 1},
{_type="Crackers",_soft="Decrypter v5",_version=5,_desc={['EN']="Decrypts any file with five encryption levels or less",['FR']="Decrypte tout fichier crypte au niveau 5 ou moins."},_price=7500,_size=2.6,_cpu=1.3,_cpuMax = 1},
{_type="Crackers",_soft="Decrypter v6",_version=6,_desc={['EN']="Decrypts any file with six encryption levels or less",['FR']="Decrypte tout fichier crypte au niveau 6 ou moins."},_price=10000,_size=3,_cpu=1.4,_cpuMax = 1},
{_type="Crackers",_soft="Decypher",_version=1,_desc={['EN']="Actively cracks any system protected by an encryption cypher",['FR']="Infiltre un chiffrage elliptique."},_price=15000,_size=4,_cpu=1,_cpuMax = 1},
{_type="Crackers",_soft="Password Breaker",_version=1,_desc={['EN']="Break into password protected systems.",['FR']="Hacke les systemes proteges par mot de passe."},_price=3500,_size=1.7,_cpu=1,_cpuMax = 0.7},
{_type="Bypassers",_soft="Firewall Bypass v1",_version=1,_desc={['EN']="Actively bypasses a firewall with a security level of 1 ",['FR']="Desactive un pare-feu de niveau 1."},_price=4000,_size=10,_cpu=1.4,_cpuMax = 0.7},
{_type="Bypassers",_soft="Firewall Bypass v2",_version=2,_desc={['EN']="Actively bypasses a firewall with a security level of 2 or less",['FR']="Desactive un pare-feu de niveau 2 ou moins."},_price=5000,_size=12,_cpu=1.4,_cpuMax = 0.9},
{_type="Bypassers",_soft="Firewall Bypass v3",_version=3,_desc={['EN']="Actively bypasses a firewall with a security level of 3 or less",['FR']="Desactive un pare-feu de niveau 3 ou moins."},_price=6000,_size=14,_cpu=1.9,_cpuMax = 1},
{_type="Bypassers",_soft="Proxy Bypass v1",_version=1,_desc={['EN']="Actively bypasses a proxy server with a security level of 1",['FR']="Desactive un proxy de niveau 1."},_price=9000,_size=8,_cpu=0.2,_cpuMax = 0.7},
{_type="Bypassers",_soft="Proxy Bypass v2",_version=2,_desc={['EN']="Actively bypasses a proxy server with a security level of 2 or less",['FR']="Desactive un proxy de niveau 2 ou moins."},_price=12500,_size=9,_cpu=0.2,_cpuMax = 0.8},
{_type="Bypassers",_soft="Proxy Bypass v3",_version=3,_desc={['EN']="Actively bypasses a proxy server with a security level of 3 or less",['FR']="Desactive un proxy de niveau 3 ou moins."},_price=15000,_size=11,_cpu=0.3,_cpuMax = 0.8},
{_type="Bypassers",_soft="Proxy Bypass v4",_version=4,_desc={['EN']="Actively bypasses a proxy server with a security level of 4 or less",['FR']="Desactive un proxy de niveau 4 ou moins."},_price=17500,_size=15,_cpu=0.3,_cpuMax = 0.9},
{_type="Security",_soft="Monitor Bypass v1",_version=1,_desc={['EN']="Bypasses the targetted system monitor v1",['FR']="Desactive un moniteur de niveau 1 ou moins."},_price=22000,_size=3.9,_cpu=1,_cpuMax = 0.9},
{_type="Security",_soft="Monitor Bypass v2",_version=2,_desc={['EN']="Bypasses the targetted system monitor v2 or less",['FR']="Desactive un moniteur de niveau 2 ou moins."},_price=27000,_size=4.3,_cpu=1.5,_cpuMax = 1},
{_type="Security",_soft="Monitor Bypass v3",_version=3,_desc={['EN']="Bypasses the targetted system monitor v3 or less",['FR']="Desactive un moniteur de niveau 3 ou moins."},_price=33000,_size=5,_cpu=1.5,_cpuMax = 1},
{_type="Security",_soft="Trace Tracker v1",_version=1,_desc={['EN']="Informs you about the progress of any traceback in real time.",['FR']="Indique la progression de tout tracage externe de votre passerelle."},_price=12500,_size=2,_cpu=1,_cpuMax = 0.5},
}

for _,file in ipairs(Files) do 
  table.insert(data,Datum:new{type='dat',name = file.name,size = file.size,encryptionlvl = file.encryptionlvl,owner = file.owner}) 
end

for _,file in ipairs(H_software) do 
  table.insert(data,Datum:new{type='exe',name = file._soft,cpu = file._cpu,cpuMax = file._cpuMax,size=file._size,desc = file._desc,cost = file._price,version = file._version}) 
end  

for k in ipairs(data) do
  data[k].index = searchFieldValue(data,'name',data[k].name)
end

--Specific functions for EXE softwares

  function PasswordBreaker(myF,host)
    if host and host.password then
    --host.password = host.password..'_'
      if host.ButtonPass and host.ButtonPass.text~= host.password then
      host.count = host.count+1        
        if host.count > 50 then 
        host.count  = 0         
        --oldprint(myF.cur)
        host.ButtonPass.text = host.ButtonPass.text..string.sub(host.password,myF.cur,myF.cur)
        myF.cur = myF.cur + 1 
        end  
      else 
      myF.cur = 1
      host.hackAttempt = host.hackAttempt+1
      end
    --[[
    elseif People and host and host.ButtonId and host.ButtonPass then
      if host.ButtonId.text~='' then
      local k = searchFieldValue(People,'acc',host.ButtonId.text)
        if k then 
          if host.ButtonPass.text ~= People[k].pass then
          host.count = host.count+1
            if host.count > 100 then
            host.count = 0
            host.ButtonPass.text = host.ButtonPass.text..string.sub(People[k].pass,myF.cur,myF.cur)
            myF.cur = myF.cur+1
            end
          else myF.cur = 1
          end
        end
      end
    --]]
    end    
  end
  
--Firewall Bypassers: 55,56,57
  function FirewallBypass(myF,host)
    if host and (host.firewall~=nil) then
      if (host.firewall==true) then
        if host.level.firewall > myF.version then
        System.message(locale.mustUpdateFirewallBypass..host.level.firewall,0)
        host.trace = host.DEFAULT_TRACEBACK*2
        myF:close()
        else
          host.firewall = false
        end
      end
    end
    if not Interface.connected then 
    myF:close() 
    System.message(locale.noHost,0)
    end
  end

--Proxy Bypassers: 58,59,60,61
  function ProxyBypass(myF,host)
    if host and (host.proxy~=nil) then
      if (host.proxy==true) then
        if host.level.proxy > myF.version then
        System.message(locale.mustUpdateProxyBypass..host.level.proxy,0)
        host.trace = host.DEFAULT_TRACEBACK*2
        myF:close()
        else
          host.proxy = false
        end
      end
    end
    if not Interface.connected then 
    myF:close() 
    System.message(locale.noHost,0)
    end  
  end

--Monitor Bypass:62,63,64
  function MonitorBypass(myF,host)
    if host and (host.monitor~=nil) then
      if (host.monitor==true) then
        if host.level.monitor > myF.version then
        host.trace = host.DEFAULT
        System.message(locale.mustUpdateMonitorBypass..host.level.monitor,0)
        host.trace = host.DEFAULT_TRACEBACK*2
        myF:close()
        else
          host.monitor = false
        end
      end
    end
    if not Interface.connected then 
    myF:close() 
    System.message(locale.noHost,0)
    end  
  end
  
--Decypher: 53
  function Decypher(myF,host)
    if host and (host.cypher) then
      if (host.cypher==true) then
      math.randomseed(os.time())
        local encryptionT = {}
          for k=1,10 do 
          encryptionT[k]={} 
            for j=1,10 do encryptionT[k][j]=math.random(9) end
          end
        local cypheringLevel,done = 200,0
        
        while host.cypher do
        updateEnv()
          done = done + 1
          local lengthBar = math.floor((done/cypheringLevel)*75)
          drawrect(300,100,77,12)
          screen:fillRect(301,101,lengthBar,10,BLUE)
          print(20,30,locale.decyphering)
          print(300,260,locale.backDec)
          for y in ipairs(encryptionT) do
            for x,t in ipairs(encryptionT[y]) do
            t = math.random(9)
            print(40+10*y,40+10*x,t)
            end
          end
          if Controls.read():circle() then 
          System.message(locale.closeDecypher,1)
            if System.buttonPressed(1)=='yes' then
            myF:close()
            break
            end
          end
          if done >= cypheringLevel then 
          host.cypher = false 
          myF:close()
          end
        swapBuffers()
        end  
        
      else
        myF:close()
      end
    end  
  end

--Decrypter: 47,48,49,50,51,52
  function Decrypter(myF,Interface)
    local EncList = {}
    if Interface then
      for k,index in ipairs(Interface.dataList) do
        if data[index].encryptionlvl > 0 then
        table.insert(EncList,index)
        end
      end
      if #EncList > 0 then
      local str = locale.decrypterExplain
        for k,value in ipairs(EncList) do str = str..k..': '..data[value].name..'\n' end
        System.message(str,0)
        local n_Index = tonumber(System.startOSK('',''))
          if n_Index and EncList[n_Index] and data[EncList[n_Index]] then
          local comp = (myF.version > data[EncList[n_Index]].encryptionlvl)
          --oldprint('myF > Data ',comp)
            if comp then 
            data[EncList[n_Index]].encryptionlvl = 0
            myF:close()
            System.message(locale.confirmDecrypted,0)
            else             
            System.message(locale.mustUpdateDecrypter..data[EncList[n_Index]].encryptionlvl,0)
            myF:close()
            end  
          else System.message(locale.notValidDegree,0)
          end
      else
        System.message(locale.noDataToDecrypt,0)
        myF:close()
      end
    end
  end
  
--Trace Tracker:65


--Links softwares to functions
for k=55,57 do data[k]:linkToFunc(FirewallBypass) end
for k=58,61 do data[k]:linkToFunc(ProxyBypass) end
for k=62,64 do data[k]:linkToFunc(MonitorBypass) end
         data[53]:linkToFunc(Decypher)
         data[54]:linkToFunc(PasswordBreaker)
         --data[65]:linkToFunc(TraceTracking)
for k=47,52 do data[k]:linkToFunc(Decrypter) end