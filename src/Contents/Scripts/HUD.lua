--[[ Uplink For PSP
	Game Interface definition File
	 - Acts like a pilot file for the game itself.Runs all softwares as processes, connects to mainframes, displays player info, and the like.
	]]
	
Interface = {playState,nextTick = 0,store = {},locale = '',connectionPath = {},connected = false, hostType = '',linked = 0,hostName='',
				tray = {},timer = 0,usedMemory = 0,memoryH=0,cpuW = 0,count = 0,bounceLength=0,traceback = 0,dlTimer = 0,dlDataIndex = 0,curDl=0,
			exitCode = 0,pRate = 0,salary=0
			} 
	for k = 1,5 do table.insert(Interface.tray,Image.load('./Contents/graphics/files/tray'..k..'.png')) end

function Interface.setLocale()
	local f = assert(io.open('./Contents/profiles/locale','r'))
	if f then Interface.locale = f:read()
	f:close()
	end	
	dofile ('./Contents/Locale/'..(Interface.locale))
end

function Interface.getPlayerRate()
local p_rate = false
	if H_rating then
		for k in ipairs(H_rating) do
			if Interface.currentProfile.numHackSuccess >= H_rating[k]._success then p_rate = k end
		end
	end
	return p_rate
end

function Interface.loadProfile(name)
local f = assert(io.open('./Contents/profiles/'..name..'.lua','r'))
	if f then
	Interface.currentProfile = {}
	Interface.currentProfile.img = Image.load('./Contents/graphics/photos/image0.jpg')	
	Interface.currentProfile.curName = tostring(f:read())
	Interface.currentProfile.curName2 = tostring(f:read())
	Interface.currentProfile.Location = tonumber(f:read())
	Interface.currentProfile.gateway = tonumber(f:read())
	Interface.currentProfile.CPU = tonumber(f:read())
	Interface.currentProfile.Memory = tonumber(f:read())
	Interface.currentProfile.Modem = tonumber(f:read())
	Interface.currentProfile.acc = tostring(f:read())
	Interface.currentProfile.money = tonumber(f:read()) or 0	
	Interface.currentProfile.degree = (tonumber(f:read()) or 0)	
	Interface.currentProfile.degreeClass = (tonumber(f:read()) or 0)
	Interface.currentProfile.maritalStatus = (tonumber(f:read()) or 0)
	Interface.currentProfile.socialStatus = (tonumber(f:read()) or 0)
	Interface.currentProfile.conviction = (tonumber(f:read()) or 0)
	Interface.dataList = (getIndexFromString(tostring(f:read()),data) or {})
	Interface.currentProfile.numHackSuccess = (tonumber(f:read()))
	Interface.currentProfile.lastTime = getTimeFromString(tostring(f:read()))
		for k,v in pairs(Interface.currentProfile.lastTime) do oldprint(k,v) end
	end

f:close()
	if People then
	dofile('./Contents/profiles/'..name..'_profile_dataset.lua')
	end
	Interface.pRate = Interface.getPlayerRate()	
end

function Interface.saveProfile()
local f = assert(io.open('./Contents/profiles/'..Interface.currentProfile.curName..'.lua','w'))
	if f then
	f:write(Interface.currentProfile.curName..'\n')
	f:write(Interface.currentProfile.curName2..'\n')
	f:write(Interface.currentProfile.Location..'\n')
	f:write(Interface.currentProfile.gateway..'\n')
	f:write(Interface.currentProfile.CPU..'\n')
	f:write(Interface.currentProfile.Memory..'\n')
	f:write(Interface.currentProfile.Modem..'\n')
	f:write(Interface.currentProfile.acc..'\n')
	f:write(Interface.currentProfile.money..'\n')
	f:write(Interface.currentProfile.degree..'\n')
	f:write(Interface.currentProfile.degreeClass..'\n')
	f:write(Interface.currentProfile.maritalStatus..'\n')
	f:write(Interface.currentProfile.socialStatus..'\n')
	f:write(Interface.currentProfile.conviction..'\n')
	f:write('datum ')
		for k in ipairs(Interface.dataList) do f:write(Interface.dataList[k]..'\t') end
	f:write('\n')
	f:write(Interface.currentProfile.numHackSuccess..'\n')
	local chart = {'Year','Month','Day','Hour','Min','Sec'}
		for k,index in pairs(chart) do 
			if Interface.Time then f:write(Interface.Time[index]..'\t') end
		end
	end
f:close()
	Close:play()
	Interface.playState = false
end

function Interface.drawGateway()
	local index = Interface.currentProfile.gateway	
	if H_gateway[index] then
	local blitX = (SCREEN_WIDTH/2)-(H_gateway[index].img:width()/2)	
	local vertSpacing = 10
	local blitDownY = (20+H_gateway[index].img:height()+vertSpacing)
		while true do
		updateEnv()			
		drawrect(10,5,SCREEN_WIDTH-10*2,SCREEN_HEIGHT-5*2)
		screen:blit(blitX,20,H_gateway[index].img)		
		printf(20,blitDownY,H_gateway[index]._name)
		printf(20,blitDownY+vertSpacing*2,H_gateway[index]._desc[Interface.locale])
		printf(20,blitDownY+vertSpacing*3,locale.rateBandWidth..Interface.currentProfile.Modem..'/'..H_gateway[index]._MaxModem..' Mb/s')
		printf(20,blitDownY+vertSpacing*4,locale.rateMemory..Interface.currentProfile.Memory..'/'..H_gateway[index]._MaxMemory..' Gb')
		printf(20,blitDownY+vertSpacing*5,locale.rateCPU..Interface.currentProfile.CPU..'/'..H_gateway[index]._MaxCPU..' Ghz')
		printf(380,260,locale.back)
		--cursor.draw()
			if Controls.read():triangle() then break end
		swapBuffers()
		end
	else 
	return 
	end
	collectgarbage()
end

function Interface.drawMemory()
local h = math.ceil((Interface.usedMemory*100)/Interface.currentProfile.Memory)
	h = ((h >= 99) and 99 or h)
	if Interface.memoryH < h then Interface.memoryH = Interface.memoryH + 1 end
	if Interface.memoryH > h then Interface.memoryH = Interface.memoryH - 1 end
drawrect(SCREEN_WIDTH-12-10,SCREEN_HEIGHT-42-100,10,100)
--screen:fillRect(SCREEN_WIDTH-11-10,SCREEN_HEIGHT-11-100,9,99,GREEN)
screen:fillRect(SCREEN_WIDTH-11-10,SCREEN_HEIGHT-41-(Interface.memoryH+1),9,Interface.memoryH,RED)
printf(410,250,locale.remMem..Interface.getFreeMemory()..' Gb')
end

function Interface.getFreeCPU()
local usedCPU = 0
	for k,PID in ipairs(ActivePID) do
		if data[PID] then usedCPU = usedCPU + data[PID].cpu end	
	end
	return usedCPU
end

function Interface.drawCPU()
local w = math.ceil((Interface.getFreeCPU(ActivePID)*75/Interface.currentProfile.CPU))
	if Interface.cpuW < w then Interface.cpuW = Interface.cpuW + 1 end
	if Interface.cpuW > w then Interface.cpuW = Interface.cpuW - 1 end
drawrect(170,5,77,12)
screen:fillRect(171,6,Interface.cpuW,10,BLUE)
end

function Interface.downloadProcess(key,oldkey)
	if Interface.connected and Interface.hostType=='mframe' and mainframe and mainframe[Interface.linked].viewing~='passwordScreen' then
		if Interface.dlTimer > 0 and data and data[Interface.dlDataIndex] then
		--oldprint('dling')
		Interface.curDl = Interface.curDl + (Interface.currentProfile.Modem/2)
		local IDLE = math.floor(Interface.curDl*75/Interface.dlTimer)
		drawrect(350,150,77,12)
		screen:fillRect(351,151,IDLE,10,BLUE)
			if Interface.curDl >= Interface.dlTimer then
			Interface.curDl = 0
			Interface.dlTimer = 0
			table.insert(Interface.dataList,Interface.dlDataIndex)
			Interface.dlDataIndex = 0
			Done:play()
			System.message(locale.dlSuccess,0)			
			end
			if key and oldkey and key:triangle() and not oldkey:triangle() then
			System.message(locale.abortDownload,1)
				if System.buttonPressed(1)=='yes' then
				Interface.curDl = 0
				Interface.dlTimer = 0
				Interface.dlDataIndex = 0
				end
			end
		end
	end
end

function Interface.getFreeMemory()
Interface.usedMemory = 0
	if data then
		for k,index in ipairs(Interface.dataList) do
		Interface.usedMemory = Interface.usedMemory + data[index].size
		end
	end
	return (Interface.currentProfile.Memory - Interface.usedMemory)
end

function Interface.drawFiles()
	local lf = Image.load('./Contents/graphics/arrows/left.jpg')
	local rg = Image.load('./Contents/graphics/arrows/right.jpg')
	local encFile = Image.load('./Contents/graphics/files/encrypted.png')
	local datFile = Image.load('./Contents/graphics/files/data.png')
	local softPics = {}
	softPics['Password Breaker'] = Image.load('./Contents/graphics/files/password breaker.png')
	softPics['Monitor'] = Image.load('./Contents/graphics/files/monitor.png')
	softPics['Decypher'] = Image.load('./Contents/graphics/files/decypher.png')
	softPics['Decrypter'] =  Image.load('./Contents/graphics/files/decrypter.png')
	softPics['Firewall Bypass'] =  Image.load('./Contents/graphics/files/firewall bypass.png')
	softPics['Proxy Bypass'] = Image.load('./Contents/graphics/files/proxy bypass.png')
	softPics['Trace Tracker'] = Image.load('./Contents/graphics/files/trace tracker.png')
	
	local FileList = {}
	Interface.usedMemory = 0
		for k,index in ipairs(Interface.dataList) do
		Interface.usedMemory = Interface.usedMemory + data[index].size
			--for k,v in pairs(data[index]) do oldprint(k,v) end
			table.insert(FileList,{type = data[index].type,name = data[index].name,version = data[index].version,size = data[index].size,desc = data[index].desc,cpu = data[index].cpu,encryptionlvl = data[index].encryptionlvl,index = index,idxDataList = k})
		end
	
	local function drawArrows(curFile)
		if FileList[curFile-1] then screen:blit(120,20+87.5, lf) end
		if FileList[curFile+1] then screen:blit(340,20+87.5, rg) end	
	end
	
	local function getFileImg(f)
		for k in pairs(softPics) do
			if string.find(f.name,k) then return softPics[k] end
		end
		if f.type == 'dat' then
			if f.encryptionlvl > 0 then return encFile
			else return datFile
			end
		end
	end
	
	local curFile = 1
	
	local function drawFiles(key,oldkey)
		if FileList[curFile] then
		local img = getFileImg(FileList[curFile])
		screen:blit((SCREEN_WIDTH/2)-(img:width()/2),106-img:height()/2,img)
			if FileList[curFile].type=='exe' then					
				print(30,210,'Software : '..FileList[curFile].name)
				print(30,225,locale.gatewayFileSpec..FileList[curFile].cpu..' Ghz / '..FileList[curFile].size..' Gb')
					if data[FileList[curFile].index]:isActive() then 	
					print(30,240,locale.status..locale.isRunning)
					end
			else 
				print(30,210,locale.gatewayFileName..FileList[curFile].name)
				print(30,225,locale.gatewayFileSize..FileList[curFile].size..' Gb')
				print(30,240,locale.gatewayFileEnc..FileList[curFile].encryptionlvl)
			end
		end	
		if key and oldkey then		
			if key:l() and not oldkey:l() and FileList[curFile-1] then  curFile = curFile-1 end
			if key:r() and not oldkey:r() and FileList[curFile+1] then  curFile = curFile+1 end
			if key:square() and not oldkey:square() and #FileList > 0 then 
			System.message(locale.delFile..FileList[curFile].name,1)
				if System.buttonPressed(1)=='yes' then
					if Interface and Interface.dataList[FileList[curFile].idxDataList] then 
					table.remove(Interface.dataList,FileList[curFile].idxDataList)
					Interface.getFreeMemory()
					System.message(locale.fileDeleted,0)
					return 
					end
				end
			end
			if key:cross() and not oldkey:cross() and #FileList > 0 then 
			--oldprint('loading data '..FileList[curFile].index)
				if data[FileList[curFile].index]:isActive() then
				System.message(locale.close,1)
					if System.buttonPressed(1)=='yes' then data[FileList[curFile].index]:close() end
				else
				ExecuteSoft:play()
				data[FileList[curFile].index]:run() 
				end
			end
		end
	end
	
	local oldkey = Controls.read()
	while true do
	local key = Controls.read()
	updateEnv()
	drawrect(10,5,SCREEN_WIDTH-10*2,SCREEN_HEIGHT-5*2)
	drawrect(350,15,SCREEN_WIDTH-350-21,50)
	drawFiles(key,oldkey,curFile)
	drawArrows(curFile)
	Interface.drawMemory()	
	printf(370,30,locale.openSoft)
	printf(370,40,locale.deleteSoft)
	printf(370,50,locale.back)
	cursor.draw()
		if key:triangle() and not oldkey:triangle() then 
		Interface.memoryH = 0
		break 
		end
	swapBuffers()
	oldkey = key
	end
end

function Interface.computeBounceLength(localhost)
	if #Interface.connectionPath > 0 then
	local t={localhost}
	local l = 0
		for k,point in ipairs(Interface.connectionPath) do table.insert(t,point) end	
		for k = 2,#t do l = l + getDistance(t[k],t[k-1]) end
		return l		
	else return 0
	end
end


function Interface.drawWorld()
	if not Interface.bounce then Interface.bounce = {} end
	if not Interface.WorldBackground then Interface.WorldBackground = Image.load('./Contents/graphics/worldmap.jpg') end	
	local DotSize = 10
	local oldkey = Controls.read()
	local localhost = {x = gateway[Interface.currentProfile.Location].x-DotSize/2, y = gateway[Interface.currentProfile.Location].y-DotSize/2,w = DotSize,h=DotSize}
	
	function Interface.updateBounceList(Dot,key,oldkey)
		if key and oldkey then
			if key:cross() and not oldkey:cross() then
			local newItem = {x = Dot.x+(Dot.w/2),y=Dot.y+(Dot.h/2),linked=Dot.linked,type = Dot.type,_=Dot._}
			local index = listed(Interface.connectionPath,newItem)
				if not index then table.insert(Interface.connectionPath,newItem) 
				else moveToEnd(Interface.connectionPath,index)
				end		
			AddLink:play()
			end
		end	
	end

	function Interface.drawBounceList(localhost)
		if #Interface.connectionPath > 0 then
			for k = 1,(#Interface.connectionPath)-1 do
				drawSegment(Interface.connectionPath[k].x,Interface.connectionPath[k].y,Interface.connectionPath[k+1].x,Interface.connectionPath[k+1].y)
			end
		drawSegment(localhost.x,localhost.y,Interface.connectionPath[1].x,Interface.connectionPath[1].y,RED)	
		end
	end

	while true do
	local key = Controls.read()
	updateEnv()		
	screen:blit(0,0,Interface.WorldBackground)
		for _,server in ipairs(H_servers) do
			local Dot = {x = server._link.x-(DotSize/2),y=server._link.y-(DotSize/2),w = DotSize,h=DotSize,linked = server._linked,type = server._type,_= _}
			if staticIsOn(cursor,Dot) then
			Interface.updateBounceList(Dot,key,oldkey)
			drawrect(Dot.x-1,Dot.y-1,Dot.w+2,Dot.h+2,WHITE)
			printf(10,270,server._name[Interface.locale])
			end
			screen:fillRect(server._link.x-(DotSize/2),server._link.y-(DotSize/2),DotSize,DotSize,YELLOW)
		end
		if key:select() and not oldkey:select() then 
		Interface.connectionPath = {} 
		AddLink:play()
		end
		if key:l() and not oldkey:l() and (Interface.connected) then 
		--Interface.connectionPath = {} 
		Interface.connected = false
		Interface.hostType,Interface.hostName = '',''
		Interface.linked = 0
		Interface.traceback = 0
		Interface.curDl = 0
		Interface.dlTimer = 0
		Interface.dlDataIndex = 0
		Close:play()		
		System.message(locale.disconnect,0)		
		break
		end
		if key:r() and not oldkey:r() and #Interface.connectionPath > 0  then
		table.remove(Interface.connectionPath) 
		AddLink:play()
		end
		if key:square() and not oldkey:square() then 
			if Interface.connected then System.message(locale.cannotModCurConnection,0)
			else
				if #Interface.connectionPath > 0 then
				Interface.connected = true
				Interface.hostType = Interface.connectionPath[#Interface.connectionPath].type
				Interface.linked = Interface.connectionPath[#Interface.connectionPath].linked
				Interface.hostName = H_servers[Interface.connectionPath[#Interface.connectionPath]._]._name[Interface.locale]
				System.message(locale.confirmConnection..Interface.hostName,0)
				end
			end
		end
		if staticIsOn(cursor,localhost) then 
		drawrect(localhost.x-1,localhost.y-1,localhost.w+2,localhost.h+2,WHITE) 
		printf(10,270,'Localhost')
		end
		screen:fillRect(localhost.x,localhost.y,localhost.w,localhost.h,RED)
		if key:triangle() and not oldkey:triangle() then 
		Interface.bounceLength = Interface.computeBounceLength(localhost)
		break 
		end
	Interface.drawBounceList(localhost)
	printf(10,10,locale.WorldKeys)
	--printf(10,20,Interface.computeBounceLength(localhost))
	cursor.draw()
	swapBuffers()
	oldkey = key
	end
end

function Interface.drawFinance()
	--[[Report from: International Bank\n
		Account Owner: --\n
		Account Number:--\n
		
		Dear Customer,
		Here is the response to your demand. 
		We inform you that you have ..num.. credits on your account.
		
		If you have any doubt on the thruthfulness of these informations, 
		please logon with your account details on our public server and check out.
		
		Be sure of our best attention at all times,
		Yours sincerely.
		]]	
	System.message(locale.financeFrom..locale.financeOwner..Interface.currentProfile.curName..'\n'..locale.financeAcc..Interface.currentProfile.acc..'\n\n'..locale.financeCre1..Interface.currentProfile.money..locale.financeCre2,0)
end



function Interface.drawProfile()
--[[ From : Uplink Corporation
     Agent ID : --\n 
	 Successfull Operations Made : --\n
	 Ranking : --\n
	 Comment : --\n
	]]
local p_rate = Interface.pRate
	if p_rate and H_rating and H_rating[p_rate] then
	System.message(locale.profileFrom..locale.profileID..Interface.currentProfile.curName..'\n'..locale.numSuccess..Interface.currentProfile.numHackSuccess..'\n'..locale.profileRanking..H_rating[p_rate]._rate[Interface.locale]..'\n'..locale.profileComment..H_rating[p_rate]._comment[Interface.locale],0)
	else 
		return
	end
end

function Interface.setIcons()
local wMap = Image.load('./Contents/graphics/worldmapsmall.jpg')
local gatewayPic = Image.load('./Contents/graphics/hud/hardware.jpg')
local memoryPic = Image.load('./Contents/graphics/hud/memory.jpg')
local financePic = Image.load('./Contents/graphics/hud/finance.jpg')
local profilePic = Image.load('./Contents/graphics/hud/profile.jpg')
local close = Image.load('./Contents/graphics/close.jpg')
local mailPic = Image.load('./Contents/graphics/hud/mdetails.jpg')
local sendNote = Image.load('./Contents/graphics/hud/send.jpg')

Interface.Map = Icon:new{img = wMap,w = wMap:width(),h=wMap:height(),
						x = SCREEN_WIDTH-wMap:width()-2,y = 1,ID = 'MapSmall',
						text = locale.mapSmallDesc[false]}
Interface.Close = Icon:new{img = close,w = close:width(),h = close:height(),
							x = 1,y=1,text = locale.closeInterface}
							
Interface.Buttons = {}
Interface.Buttons.gateway = Icon:new{img = gatewayPic,w = gatewayPic:width(),h=gatewayPic:height(),
						x = 1,y = SCREEN_HEIGHT-14-gatewayPic:height(),ID = 'View_Gateway',
						text = locale.View_GatewayDesc}
Interface.Buttons.memory = Icon:new{img = memoryPic,w = memoryPic:width(),h=memoryPic:height(),
						x = Interface.Buttons.gateway.x+Interface.Buttons.gateway.img:width()+2,y = SCREEN_HEIGHT-14-memoryPic:height(),ID = 'View_Memory',
						text = locale.View_MemoryDesc}
Interface.Buttons.finance = Icon:new{img = financePic,w = financePic:width(),h=financePic:height(),
						x = Interface.Buttons.memory.x+Interface.Buttons.memory.img:width()+2,y = SCREEN_HEIGHT-14-financePic:height(),ID = 'View_Finance',
						text = locale.View_FinanceDesc}
Interface.Buttons.profile = Icon:new{img = profilePic,w = profilePic:width(),h=profilePic:height(),
						x = Interface.Buttons.finance.x+Interface.Buttons.finance.img:width()+2,y = SCREEN_HEIGHT-14-profilePic:height(),ID = 'View_Profile',
						text = locale.View_ProfileDesc}	
Interface.Buttons.missionDesc = Icon:new{img = mailPic,w=mailPic:width(),h=mailPic:height(),
						x = Interface.Buttons.profile.x+24+24+2+2+Interface.Buttons.profile.img:width()+2,y =SCREEN_HEIGHT-14-mailPic:height(),ID = 'View_Mission_Description',
						text = locale.missionReadDesc}						
Interface.Buttons.sendNote = Icon:new{img = sendNote,w=sendNote:width(),h=sendNote:height(),
						x = Interface.Buttons.missionDesc.x+Interface.Buttons.missionDesc.img:width()+2,y =SCREEN_HEIGHT-14-sendNote:height(),ID = 'Send_Notification' ,
						text = locale.sendNotification}	

--Connects Icons to funcs()
Interface.Map:connect(Interface.drawWorld)
Interface.Close:connect(Interface.saveProfile)
Interface.Buttons.gateway:connect(Interface.drawGateway)						
Interface.Buttons.memory:connect(Interface.drawFiles)						
Interface.Buttons.finance:connect(Interface.drawFinance)						
Interface.Buttons.profile:connect(Interface.drawProfile)	
	
end



--Gets the current time and draws it
function Interface.drawTime()
	--Interface.Time={Year=System.getDate(1),Month=formatTime(System.getDate(2)),Day=formatTime(System.getDate(3)),Hour=formatTime(System.getTime(1)),Min=formatTime(System.getTime(2)),Sec=formatTime(System.getTime(3))}
	if not Interface.Time then 
	Interface.Time = Ctime:new{year = Interface.currentProfile.lastTime[1] or System.getDate(1),
								month=Interface.currentProfile.lastTime[2] or System.getDate(2),
								day=Interface.currentProfile.lastTime[3] or System.getDate(3),
								hour=Interface.currentProfile.lastTime[4] or System.getTime(1),
								min=Interface.currentProfile.lastTime[5] or System.getTime(2),
								sec=Interface.currentProfile.lastTime[6] or System.getTime(3)
								} 
	end
	Interface.Time:flow()
	Interface.Time:payFee(Interface.currentProfile.money)
	local str = (Interface.locale=='EN') and (formatTime(Interface.Time.Month))..'/'..(formatTime(Interface.Time.Day))..'/'..(Interface.Time.Year)..' - '..(formatTime(Interface.Time.Hour))..':'..(formatTime(Interface.Time.Min))..':'..(formatTime(Interface.Time.Sec)) or (formatTime(Interface.Time.Day))..'/'..(formatTime(Interface.Time.Month))..'/'..(Interface.Time.Year)..' '..(formatTime(Interface.Time.Hour))..':'..(formatTime(Interface.Time.Min))..':'..(formatTime(Interface.Time.Sec))
	printf(20,10,str)
end

function Interface.getTimeString()
local str=''
	if Interface.Time then
	str = formatTime(Interface.Time.Hour)..':'..formatTime(Interface.Time.Min)
	end
return str
end

function Interface.drawTrayConnection()
	--print(300,200,Interface.timer)
	Interface.timer = Interface.timer + 0.5	
	local cur_tray = math.floor(Interface.timer/10)+1
		if Interface.timer > 49 then
			Interface.timer = math.random(49)
		end
	screen:blit(SCREEN_WIDTH-Interface.tray[cur_tray]:width(),SCREEN_HEIGHT-12-Interface.tray[cur_tray]:height(),Interface.tray[cur_tray])
		
end

function Interface.runActiveProcesses()
	--if Interface.connected then
		for k,PID in ipairs(ActivePID) do
			if ActivePID[k] then
				if data[PID] and data[PID].f then 
				local host
					if Interface.hostType == 'mframe' then host = mainframe[Interface.linked]
					elseif Interface.hostType == 'database' then host = database[Interface.linked]
					elseif Interface.hostType == 'bank' then host = bank[Interface.linked]
					end
					
					if not string.find(data[PID].name,'Decrypter') and not string.find(data[PID].name,'Trace') then data[PID]:execute(host)
					else data[PID]:execute(Interface)
					end
				end	
			else break
			end
		end
	--end
end

function Interface.traceLevelPercentage()
	local l = math.floor(Interface.traceback*75/Interface.bounceLength)
	if l > 75 then l = 75 end
	return l
end

function Interface.wipeProfile()	
	System.message(locale.over,0)
	if GameCore then 
	local idx = searchFieldValue(GameCore.profiles,'name',Interface.currentProfile.curName)
		if idx then
			if GameCore.profiles[idx] then				
			table.remove(GameCore.profiles,idx)
			local id = Interface.currentProfile.curName
			System.removeFile('./Contents/profiles/'..id..'.lua')
			System.removeFile('./Contents/profiles/'..id..'_profile_dataset.lua')
			GameCore.saveProfiles()
			GameCore.setButtons()
			Interface.exitCode = 1
			Interface.playState = false
			end		
		end
	end
end


function Interface.draw(cursor,key,oldkey)
Interface.drawTime()
Interface.Map:draw(cursor,key,oldkey)
Interface.Close:draw(cursor,key,oldkey)
Interface.drawCPU()

	if data and data[65]:isActive() then	
	--TraceBeep:play()
	local l = 0
		if Interface.connected then l = Interface.traceLevelPercentage() end		
	--oldprint('drawing trace:',l)
	drawrect(170,20,77,12)
	screen:fillRect(171,21,l,10,RED)	
	end
	
	if Interface.traceLevelPercentage()>=75 then
		Interface.connectionPath = {} 
		Interface.connected = false
		Interface.hostType,Interface.hostName = '',''
		Interface.linked = 0
		Interface.traceback = 0
		Interface.curDl = 0
		Interface.dlTimer = 0
		Interface.dlDataIndex = 0
		Interface.wipeProfile()		
	end
Interface.runActiveProcesses()
Interface.downloadProcess(key,oldkey)
	for k in pairs(Interface.Buttons) do 
		if k~='missionDesc' and k~='sendNote' then
		Interface.Buttons[k]:draw(cursor,key,oldkey) 
		end
	end
	--print(10,20,'Dltmer '..Interface.dlTimer)
	--print(10,30,'curDL '..Interface.curDl)
	--print(10,40,'dataK '..Interface.dlDataIndex)
Interface.drawTrayConnection()
	if Mission then Mission.Draw(cursor,key,oldkey) end
cursor.draw()
end

--[[Debug Method
function Interface.drawRanking(key,oldkey)
	if key and oldkey and key:select() and oldkey:select() then
	Interface.currentProfile.numHackSuccess = Interface.currentProfile.numHackSuccess + 1
	end
	print(10,20,Interface.currentProfile.numHackSuccess)
	
end
--]]

function Interface.drawNews()
	if #Interface.store == 0 then Interface.nextTick = 0
	else
	Interface.nextTick = Interface.nextTick + 1
		if Interface.nextTick > 200 then 
		Interface.nextTick = 0
		System.message(Interface.store[#Interface.store],0) 		
		table.remove(Interface.store)
		end
	end
end



function Interface.run(cursor,key,oldkey)
	Interface.salary = Interface.pRate*500+3000
	if not Interface.connected then 
		--if key:cross() and not oldkey:cross() then Interface.currentProfile.numHackSuccess = Interface.currentProfile.numHackSuccess-1 end
		if Interface.pRate ~= Interface.getPlayerRate() then
			if Interface.pRate < Interface.getPlayerRate() then
			System.message(locale.profileFrom..locale.profileID..Interface.currentProfile.curName..'\n'..locale.nextRating..H_rating[Interface.getPlayerRate()]._rate[Interface.locale],0)	
			else
			System.message(locale.profileFrom..locale.profileID..Interface.currentProfile.curName..'\n'..locale.downRating..H_rating[Interface.getPlayerRate()]._rate[Interface.locale],0)				
			end
		Interface.pRate = Interface.getPlayerRate()
		end
	
	Interface.draw(cursor,key,oldkey)
	Interface.drawNews()
	--print(10,10,Interface.nextTick)
	else	
		if Interface.hostType == 'mframe' then
		local hostIndex = Interface.linked
			if hostIndex==4 then
				mainframe[hostIndex]:drawFilesSpe(data)
			else
				if mainframe[hostIndex].viewing=='passwordScreen' then mainframe[hostIndex]:drawPasswordScreen() 
				elseif mainframe[hostIndex].viewing=='Files' then mainframe[hostIndex]:drawFiles() 
				end
			end
		elseif Interface.hostType == 'bank' then
		local hostIndex = Interface.linked
			if bank[hostIndex].viewing=='passwordScreen' then bank[hostIndex]:drawPasswordScreen() 
			elseif bank[hostIndex].viewing=='Records' then bank[hostIndex]:drawClientInterface() 
			end		
		elseif Interface.hostType == 'database' then
		local hostIndex = Interface.linked
			if database[hostIndex].viewing=='passwordScreen' then database[hostIndex]:drawPasswordScreen() 
			elseif database[hostIndex].viewing=='Records' then database[hostIndex]:drawRecords() 
			end	
		elseif Interface.hostType == 'uplink' then
			Uplink:drawMain()
		end
	end
end



