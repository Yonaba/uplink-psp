--[[ Uplink For PSP
	Mainframe Class definition File
	 - Create Mainframe Class
	 - Sets funcs
	]]

Mainframe = {count = 0,viewing = 'passwordScreen'}
mainframe = {}

function Mainframe:new(id,monitor,firewall,proxy,level)
	local mframe = {id = id,connected = false,viewing = 'passwordScreen'}
	mframe.monitor = (monitor) and true or nil
	mframe.firewall = (firewall) and true or nil
	mframe.proxy = (monitor) and true or nil
	mframe.trace = 0
	mframe.sec = level[1]+level[2]+level[3]
	mframe.password = getNewPassword(Dictionnary)
	mframe.hackAttempt = 0
	mframe.HACK_ATTEMPT_COUNT_LIMIT = 2
	mframe.DEFAULT_TRACEBACK = 2
	mframe.level  = {}
		if mframe.firewall then mframe.level.firewall = level[2] end
		if mframe.proxy then mframe.level.proxy = level[3] end
		if mframe.monitor then mframe.level.monitor = level[1] end
	setmetatable(mframe,self)
	self.__index = self
	return mframe
end


function Mainframe:traceback()
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

function Mainframe:resetAdminPassword()
	if self.hackAttempt > self.HACK_ATTEMPT_COUNT_LIMIT then
	self.hackAttempt = 0
	self.password = getNewPassword(Dictionnary)
	end
end

function Mainframe:resetSecurity()
	if (self.monitor~=nil) then self.monitor = true end
	if (self.proxy~=nil) then self.proxy = true end
	if (self.firewall~=nil) then self.firewall = true end
end

function Mainframe:drawSecurity(greenlight,redlight,greylight)
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
end
	
function Mainframe:drawPasswordScreen()
local greenlight = Image.load('./Contents/graphics/software/greenlight.jpg')
local redlight = Image.load('./Contents/graphics/software/redlight.jpg')
local greylight = Image.load('./Contents/graphics/software/greylight.jpg')
local passcreenImg = Image.load('./Contents/graphics/passwordscreen.jpg')
	self.ButtonPass = Button:new {w = 151, h =21,x = 40+35,y=40+63,desc = locale.buttonPass}
	self:resetAdminPassword()
	
function validate(t)
	t.viewing='Files'
end
self.ButtonPass:connect(validate,self)

local oldkey = Controls.read()
	while self.viewing=='passwordScreen' and Interface.connected do
	local key = Controls.read()
	updateEnv()
	self:traceback()
	self:drawSecurity(greenlight,redlight,greylight)
	screen:blit(40,40,passcreenImg)
	self.ButtonPass:draw(cursor,key,oldkey,self.password)		
	--print(380,260,self.viewing)
	Interface.draw(cursor,key,oldkey)		
	swapBuffers()
	oldkey = key
	end
	self.trace = 0
end

function Mainframe:transferFile(f)
	if f and data and data[f] and Interface then
	System.message(locale.confirmDl..data[f].name,1)
		if System.buttonPressed(1)=='yes' then
			if (self.proxy~=nil) and (self.proxy==true) then
			System.message(locale.proxyBlock,0)
			self.trace = self.DEFAULT_TRACEBACK*2
			return
			end
			if (self.firewall~=nil) and (self.firewall==true) then
			System.message(locale.firewallBlock,0)
			self.trace = self.DEFAULT_TRACEBACK*2
			return
			end
			if data[f].size > (Interface.getFreeMemory()) then
				return System.message(locale.notEnoughMemory,0)
			else
				for k in pairs(Interface.dataList) do
					if Interface.dataList[k]==f then return System.message(locale.alreadyGotFile,0) end
				end
				Interface.dlTimer = data[f].size*100
				Interface.dlDataIndex = f
				News.launch(Interface,1,Interface.getTimeString(),self.id,nil)
			end
		else
			return System.message(locale.downloadCancelled,0)
		end
	end
end

function Mainframe:transferFileSpe(f)
	if f and data[f] and Interface then
	System.message(locale.confirmDl..data[f].name,1)
		if System.buttonPressed(1)=='yes' then
			if data[f].size > (Interface.getFreeMemory()) then
			System.message(locale.notEnoughMemory,0)
			else
				for k in pairs(Interface.dataList) do
					if Interface.dataList[k]==f then return System.message(locale.alreadyGotFile,0) end
				end
				if data[f].cost > Interface.currentProfile.money then return System.message(locale.notEnoughCash,0) 
				else
					Interface.currentProfile.money = Interface.currentProfile.money - data[f].cost
					Interface.dlTimer = data[f].size*100
					Interface.dlDataIndex = f
					--News.launch(Interface,1,Interface.getTimeString(),self.id,nil)				
				end
			end
		end
	end
end

function Mainframe:drawFiles()
--local numfiles = 0
local Files = {}
	for k,datum in ipairs(data) do  
		if datum.type=='dat' and datum.owner == self.id then 
		table.insert(Files,{name = datum.name,size = datum.size,encryptionlvl = datum.encryptionlvl,datumIndex = k}) 
		end		
	end
--numfiles = #Files
--local datFile,encFile = Image.createEmpty(64,64),Image.createEmpty(64,64)
	--datFile:clear(BLUE)
	--encFile:clear(RED)
local encFile = Image.load('./Contents/graphics/files/encfile.png')
local datFile = Image.load('./Contents/graphics/files/datfile.png')
local left = Image.load('./Contents/graphics/arrows/left.jpg')
local right = Image.load('./Contents/graphics/arrows/right.jpg')

local curFile = 1

	local function explore(self,key,oldkey)
		if key and oldkey then
			if key:l() and not oldkey:l() and Files[curFile-1] then curFile = curFile-1 end
			if key:r() and not oldkey:r() and Files[curFile+1] then curFile = curFile+1 end
			if key:square() and not oldkey:square() then self:transferFile(Files[curFile].datumIndex) end
		end
	end
	
	local function drawArrows(curFile)
	local lft = Files[curFile-1]
	local rgt = Files[curFile+1]
		if lft then screen:blit(30,60+30,left) end
		if rgt then screen:blit(30+64+30,60+30,right) end	
	end
	
	local function drawFile(curFile)	
		print(30,60+64+15,locale.nm..Files[curFile].name)
		print(30,60+64+30,locale.sz..Files[curFile].size ..'Gb')
		print(30,60+64+45,locale.enc..Files[curFile].encryptionlvl)		
		local img = ((Files[curFile].encryptionlvl>0) and encFile or datFile)
		screen:blit(60,60,img)
	end
	
local oldkey = Controls.read()

	while self.viewing=='Files' and Interface.connected do
	local key = Controls.read()
	updateEnv()
	self:traceback()
	explore(self,key,oldkey)
	drawFile(curFile)
	drawArrows(curFile)
	--print(380,260,self.viewing)
	Interface.draw(cursor,key,oldkey)
	printf(350,115,locale.dlButton)
	swapBuffers()
	oldkey = key
	end
	self.viewing = 'passwordScreen'
	self.trace = 0
	self:resetSecurity()
end

function Mainframe:drawFilesSpe(data)
	if data then
	self.viewing = 'Files'
	--oldprint(type(data),#data)
		local i = 0
		local leftImg = Image.load('./Contents/graphics/arrows/left.jpg')
		local rightImg = Image.load('./Contents/graphics/arrows/right.jpg')
		local F = {}
			for k = 47,65 do table.insert(F,{index=k}) end
		local curFile = 1
		local pics = {}
		local pics = {}
		pics['Password Breaker'] = Image.load('./Contents/graphics/files/password breakerFTP.png')
		pics['Monitor'] = Image.load('./Contents/graphics/files/monitorFTP.png')
		pics['Decypher'] = Image.load('./Contents/graphics/files/decypherFTP.png')
		pics['Decrypter'] =  Image.load('./Contents/graphics/files/decrypterFTP.png')
		pics['Firewall Bypass'] =  Image.load('./Contents/graphics/files/firewall bypassFTP.png')
		pics['Proxy Bypass'] = Image.load('./Contents/graphics/files/proxy bypassFTP.png')
		pics['Trace Tracker'] = Image.load('./Contents/graphics/files/trace trackerFTP.png')		
		
		local function getPic(desc)		
			for k in pairs(pics) do
				if string.find(desc,k) then return pics[k] end
			end
			return Image.createEmpty(60,60)
		end
		
		local function explore(self,key,oldkey)
				if key and oldkey then
					if key:l() and not oldkey:l() and F[curFile-1] then i=0 curFile = curFile-1 end
					if key:r() and not oldkey:r() and F[curFile+1] then i=0 curFile = curFile+1 end
					if key:square() and not oldkey:square() then self:transferFileSpe(F[curFile].index) end
				end
			end
			
		local function drawArrows(curFile)
			local lft = F[curFile-1]
			local rgt = F[curFile+1]
				if lft then screen:blit(30,60+30,leftImg) end
				if rgt then screen:blit(30+64+30,60+30,rightImg) end	
			end
			
		local function drawFile(curFile)				
			print(285,175,data[F[curFile].index].name)
			print(285,190,locale.costG..data[F[curFile].index].cost)
			print(285,205,locale.usageCPU..data[F[curFile].index].cpu..' Ghz')
			print(285,220,locale.usageMemory..data[F[curFile].index].size..' Gb')
			screen:blit(60,60,getPic(data[F[curFile].index].name))
				if i<data[F[curFile].index].desc[Interface.locale]:len() then 
				i=i+1				
				else i=data[F[curFile].index].desc[Interface.locale]:len()+1
				end
				if cursor and cursor.y < SCREEN_HEIGHT-14-25 then printf(10,270,typewrite(data[F[curFile].index].desc[Interface.locale],i)) end
			end
			
		local oldkey = Controls.read()		
		while Interface.connected do
		local key = Controls.read()
		self.trace=0
		updateEnv()
		--self:traceback()
		explore(self,key,oldkey)
		drawFile(curFile)
		drawArrows(curFile)
		--print(380,260,self.viewing)
		Interface.draw(cursor,key,oldkey)
		printf(350,115,locale.dlButton)
		swapBuffers()
		oldkey = key
		end
		self.viewing = 'Files'
		self.trace = 0
		self:resetSecurity()
	end
end


mainframe[1]=Mainframe:new('Omicron',true,true,false,{2,3,3})
mainframe[2]=Mainframe:new('DataLabs',true,false,false,{3,1,4})
mainframe[3]=Mainframe:new('Trinity',true,true,true,{1,1,3})
mainframe[4]=Mainframe:new('Uplink Softs',false,false,false,{0,0,0})

