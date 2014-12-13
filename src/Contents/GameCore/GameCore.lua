--[[ Uplink For PSP
	Core definition file
	 - Creates Core
	 - Sets main funcs
	 Core file acts like a pilot for the program.It runs Menu and its differents parts, loads and run the game
	]]
	
Interface.setLocale()

GameCore = {stateMenu = true,AgentID = ''}

function GameCore.deleteProfile()
	if GameCore and GameCore.Buttons.buttonID.text~='' and GameCore.Buttons.buttonPass.text~='' then
		local idx = searchFieldValue(GameCore.profiles,'name',GameCore.Buttons.buttonID.text)
		--oldprint(idx)
		if idx then
			if GameCore.profiles[idx] and GameCore.profiles[idx].password == GameCore.Buttons.buttonPass.text then
			System.message(locale.confirmDeletion,1)
				if System.buttonPressed(1)=='yes' then
				table.remove(GameCore.profiles,idx)
				local id = GameCore.Buttons.buttonID.text
				System.removeFile('./Contents/profiles/'..id..'.lua')
				System.removeFile('./Contents/profiles/'..id..'_profile_dataset.lua')
				GameCore.saveProfiles()
				GameCore.setButtons()				
				System.message(locale.doneDeletion,0)
				end
			end	
		end
	end
end

function GameCore.GetLocation(cursor,g)
local wMap = Image.load('./Contents/graphics/worldmap.jpg')
local oldkey = Controls.read()
local img = Image.createEmpty(7,7)
local done = false
img:clear(RED)
local location 

local g_I = {}
	for k in pairs(g) do 
	table.insert(g_I,Icon:new{ID = k,x = g[k].x,y=g[k].y,w=g[k].w,h=g[k].h,text=g[k].id,img=img}) 	
	end

	local oldkey = Controls.read()
	while not done do
	local key = Controls.read()
	updateEnv()
	screen:blit(0,0,wMap)
		for k in pairs(g_I) do 
			if key:cross() and not oldkey:cross() and g_I[k]:isOn(cursor) then 
			location = k
			System.message(locale.confirmLocation..g[k].id,1)
				if System.buttonPressed(1)=='yes' then
				done = true
				break 
				end	
			end
		g_I[k]:draw(cursor,key,oldkey) 		
		end
	cursor.draw()
	swapBuffers()
	oldkey = key
	end
	
	--oldprint('location chosen',location)
	return location
end

function GameCore.createProfile()
	if #GameCore.profiles > 5 then 
	System.message(locale.overNumProfiles,0)
	else
		connectUplink(Interface.locale)
		System.message(locale.register,0)
		System.message(locale.register2,0)
		System.message(locale.askForID,0)
		
		--Gets Player ID
		local _ID = ''
		repeat
		_ID = System.startOSK('','')		
		local validate = (type(_ID)=='string') and (_ID:len() > 0) and (_ID:len()<=8)
		local isThere = true
			if validate then isThere = searchFieldValue(GameCore.profiles,'name',_ID) end
			if isThere then System.message(locale.alreadyRegistered,0) 
			_ID = ''
			end		
			if not validate then System.message(locale.askForIDhelp,0) end
		until (validate) and not (isThere)
		
		System.message(locale.askForPw,0)
		--Gets Player Password
		local _Pw = ''
		repeat
		_Pw = System.startOSK('','')
		local validate = (type(_Pw)=='string') and (_Pw:len() > 0) and (_Pw:len()<=8)
			if not validate then System.message(locale.askForPwhelp,0) end
		until validate
		
		--Choose Location
		System.message(locale.willChooseLocation,0)
		local location = GameCore.GetLocation(cursor,gateway)
		
		--writing default data
		local f = assert(io.open('./Contents/profiles/'.._ID..'.lua','w'))
		if f then
		local data = GetProfileData(_ID,_Pw,location)
		f:write(data)
		f:close()
		end		
		System.copyFile('./Contents/data/identities/default_profile_dataset.lua','./Contents/profiles/'.._ID..'_profile_dataset.lua',0)	
		table.insert(GameCore.profiles,{name=_ID,password=_Pw})
		GameCore.saveProfiles()
		GameCore.setButtons()	
		System.message(locale.profileSet,0)
		setGateway(Interface.locale)
	end
end

function GameCore.saveProfiles()
	local f = assert(io.open('./Contents/data/profiles.lua','w'))
	if f then
	f:write('GameCore.profiles = {}\n')
		for k in ipairs(GameCore.profiles) do
		f:write('GameCore.profiles['..k..']={name='..string.format('%q',GameCore.profiles[k].name)..',password='..string.format('%q',GameCore.profiles[k].password)..'}\n')
		end
	f:close()
	end	
end

function GameCore.getLang()
	local curLang,lg
	local f = assert(io.open('./Contents/profiles/locale','r'))
	if f then curLang = f:read()
	f:close()
	end
	return curLang
end

function GameCore.showOptions()
local curLang = GameCore.getLang()
curLang = curLang or 'EN'
local cur = curLang
local opt = {['FR']='Francais',['EN']='English'}
local str
local oldkey = Controls.read()

	while true do
	local key = Controls.read()
	updateEnv()
	drawrect(10,5,SCREEN_WIDTH-10*2,SCREEN_HEIGHT-5*2)
		if key:l() and not oldkey:l() and cur == 'EN' then cur = 'FR' end
		if key:r() and not oldkey:r() and cur == 'FR' then cur = 'EN' end
		if key:triangle() and not oldkey:triangle() then
			if cur ~= curLang then 
			local append = (cur=='FR' and 'Francais/French' or 'Anglais/English')
			System.message(locale.confirmLang..append,1)
				if System.buttonPressed(1)=='yes' then
				local f = assert(io.open('./Contents/profiles/locale','w'))
					if f then
					f:write(cur)
					f:close()				
					end
					if Interface then
					Interface.locale = cur					
					end
					System.message(locale.restart,0)
					System.Quit()
					break
				end	
			else break
			end
		end
		
		if cur =='EN' then str = 'Language : '..opt[cur]
		elseif cur =='FR' then str = 'Langue : '..opt[cur] 
		end
		
		local len = getFontSize(font,str)
		if not len then len = str:len()*8 end
		printf(240-len/2,136,'< '..str..' >')
		printf(350,260,locale.optionsKeys)
		printf(350,250,locale.back)

	swapBuffers()
	oldkey = key
	end
	return
end

GameCore.run = function(f,...)
	if f then return f(unpack(arg)) end
end


GameCore.run(getProfile)

GameCore.Icons = {}
GameCore.Buttons = {}

GameCore.setButtons = function()
	GameCore.Buttons = {}	
		for k=1,#GameCore.profiles do 
		GameCore.Buttons[k] = Button:new {x = 20,y = 90+15*k,w = 120, h = 15, desc = ''}
		GameCore.Buttons[k].text =  k..'. '..GameCore.profiles[k].name
		end
	GameCore.Buttons.buttonID = Button:new {x = 280-110+58, y = 150-55+48,w = 149, h = 17, desc = locale.buttonIDesc}
	GameCore.Buttons.buttonPass = Button:new {x = 280-110+58, y = 150-55+72,w = 149, h = 17, desc = locale.buttonPassDesc}
	GameCore.Buttons.buttonValid = Button:new {x = 280+110-81, y = 95+110+1,w = 82, h = 17, desc = locale.validScreen}	
end

GameCore.setIcons = function()
		GameCore.Icons.newUser = Icon:new {ID = 'New User',x = 395, y = 95, w = 32, h = 32,
											text = locale.nwuser,img = Image.load('./Contents/graphics/mainmenu/1.jpg')}
		GameCore.Icons.deleteUser = Icon:new {ID = 'Delete User',x = 395, y = 95+32+2, w = 32, h = 32,
											text = locale.deleteUser,img = Image.load('./Contents/graphics/mainmenu/2.jpg')}
		GameCore.Icons.options = Icon:new {ID = 'Options',x = 395, y = 95+(32+2)*2, w = 32, h = 32,
											text = locale.optionsMenu,img = Image.load('./Contents/graphics/mainmenu/3.jpg')}
		GameCore.Icons.exit = Icon:new {ID = 'Exit',x = 395, y = 95+(32+2)*3, w = 32, h = 32,
											text = locale.exitApp,img = Image.load('./Contents/graphics/mainmenu/4.jpg')}	
											
		GameCore.Icons.newUser:connect(GameCore.createProfile)
		GameCore.Icons.deleteUser:connect(GameCore.deleteProfile)
		GameCore.Icons.options:connect(GameCore.showOptions)
		GameCore.Icons.exit:connect(exitApp)
end

GameCore.setIcons()	
GameCore.setButtons()
--GameCore.Buttons.buttonID = Button:new {x = 280-110+58, y = 150-55+48,w = 149, h = 17, desc = locale.buttonIDesc}
--GameCore.Buttons.buttonPass = Button:new {x = 280-110+58, y = 150-55+72,w = 149, h = 17, desc = locale.buttonPassDesc}
--GameCore.Buttons.buttonValid = Button:new {x = 280+110-81, y = 95+110+1,w = 82, h = 17, desc = locale.validScreen}
		

GameCore.fill = function(GameCore,key,oldkey,cursor)
	for k in pairs(GameCore.Buttons) do
		if key and oldkey and key:cross() and not oldkey:cross() and GameCore.Buttons[k]:isOn(cursor) and (type(k)=='number') then
		--oldprint('cross on profile name')
		--oldprint('yay ',GameCore.profiles[k].name)
		--oldprint('yay2 ',GameCore.profiles[k].password)
		GameCore.Buttons.buttonID.text = GameCore.profiles[k].name
		GameCore.Buttons.buttonPass.text = GameCore.profiles[k].password
		--]]
		elseif key and oldkey and key:cross() and not oldkey:cross() and k=='buttonValid' and GameCore.Buttons[k]:isOn(cursor)  then
		--oldprint('cross on buttonValid')
		local idx = searchFieldValue(GameCore.profiles,'name',GameCore.Buttons.buttonID.text)
		--oldprint('searching '..GameCore.Buttons.buttonID.text..' found '..idx)
			if idx then 
				if (GameCore.profiles[idx].password == GameCore.Buttons.buttonPass.text) then
				System.message(locale.gainEntry,0)
				GameCore.AgentID = GameCore.Buttons.buttonID.text				
				--GameCore.stateMenu = false	
				local onExitThreadCode = GameCore.run(GameCore.playGame,GameCore.AgentID)
					if onExitThreadCode == 1 then 
					--oldprint('errorcode',onExitThreadCode) 
					GameCore.Buttons={}
					GameCore.setButtons()
					GameCore.Buttons.buttonID = Button:new {x = 280-110+58, y = 150-55+48,w = 149, h = 17, desc = locale.buttonIDesc}
					GameCore.Buttons.buttonPass = Button:new {x = 280-110+58, y = 150-55+72,w = 149, h = 17, desc = locale.buttonPassDesc}
					GameCore.Buttons.buttonValid = Button:new {x = 280+110-81, y = 95+110+1,w = 82, h = 17, desc = locale.validScreen}
					break 
					end
				else
				System.message(locale.wrongPass,0)
				end
			else
				System.message(locale.cannotFindUser,0)
			end
		--]]
		end
	end
end

function GameCore.playGame(ID)
Interface.setIcons()
Interface.loadProfile(ID)
Interface.playState = true
	local oldkey = Controls.read()
Login:play()
	while Interface.playState do
	local key = Controls.read()
	updateEnv()

		Interface.run(cursor,key,oldkey)		
		
	swapBuffers()
	oldkey = key
	end
	return Interface.exitCode
end
		
GameCore.run(startAnim)
GameCore.run(Menu,GameCore,cursor)	
--GameCore.run(GameCore.playGame,'admj')







