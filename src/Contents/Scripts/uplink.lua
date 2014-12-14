--[[ Uplink For PSP
	Uplink Server definition File
	]]
	
Uplink = {curView = 'Main',Item = {},cur = 1,i=0}

function Uplink:getNewGateway(i)
	System.message(locale.confirmBuy,1)
	if System.buttonPressed(1)=='yes' then
		if Interface and H_gateway then
			if Interface.currentProfile.money > H_gateway[i]._cost then
				if Interface.currentProfile.CPU > H_gateway[i]._MaxCPU then 
				System.message(locale.informReduceCPU1..Interface.currentProfile.CPU..locale.informReduceCPU2..H_gateway[i]._MaxCPU..' Ghz.',1)
					if System.buttonPressed(1)~='yes' then return end
				end
				if Interface.currentProfile.Modem > H_gateway[i]._MaxModem then 
				System.message(locale.informReduceModem1..Interface.currentProfile.Modem..locale.informReduceModem2..H_gateway[i]._MaxModem..' Mb/s.',1)
					if System.buttonPressed(1)~='yes' then return end
				end
				if Interface.currentProfile.Memory > H_gateway[i]._MaxMemory then 
				System.message(locale.informReduceMemory1..Interface.currentProfile.Memory..locale.informReduceMemory2..H_gateway[i]._MaxMemory..' Gb.',1)
					if System.buttonPressed(1)~='yes' then return end
				end				
			Interface.currentProfile.money = Interface.currentProfile.money - H_gateway[i]._cost
			Interface.currentProfile.gateway = i
				if Interface.currentProfile.CPU > H_gateway[i]._MaxCPU then Interface.currentProfile.CPU = H_gateway[i]._MaxCPU end
				if Interface.currentProfile.Modem > H_gateway[i]._MaxModem then Interface.currentProfile.Modem = H_gateway[i]._MaxModem end
				if Interface.currentProfile.Memory > H_gateway[i]._MaxMemory then Interface.currentProfile.Memory = H_gateway[i]._MaxMemory end			
			System.message(locale.itemPurchased,0)
			else 
			System.message(locale.notEnoughMoney,0)
			end
		end
	end		
end

function Uplink:getCPU(i)
	System.message(locale.confirmBuy,1)
	if System.buttonPressed(1)=='yes' then
		if Interface and H_hardware and H_gateway then
			if Interface.currentProfile.money > H_hardware[i]._price then
				if Interface.currentProfile.CPU + H_hardware[i].Upvalue > H_gateway[Interface.currentProfile.gateway]._MaxCPU then
				System.message(locale.gatewayCPUOver,0)
				else
				Interface.currentProfile.money = Interface.currentProfile.money - H_hardware[i]._price
				Interface.currentProfile.CPU = Interface.currentProfile.CPU+H_hardware[i].Upvalue
				System.message(locale.itemPurchased,0)				
				end			
			else 
			System.message(locale.notEnoughMoney,0)
			end
		end
	end	
end

function Uplink:getModem(i)
	System.message(locale.confirmBuy,1)
	if System.buttonPressed(1)=='yes' then
		if Interface and H_hardware and H_gateway then
			if Interface.currentProfile.money > H_hardware[i]._price then
				if Interface.currentProfile.Modem + H_hardware[i].Upvalue > H_gateway[Interface.currentProfile.gateway]._MaxModem then
				System.message(locale.gatewayModemOver,0)
				else
				Interface.currentProfile.money = Interface.currentProfile.money - H_hardware[i]._price
				Interface.currentProfile.Modem = Interface.currentProfile.Modem+H_hardware[i].Upvalue
				System.message(locale.itemPurchased,0)				
				end			
			else 
			System.message(locale.notEnoughMoney,0)
			end
		end
	end	
end

function Uplink:getMemory(i)
	System.message(locale.confirmBuy,1)
	if System.buttonPressed(1)=='yes' then
		if Interface and H_hardware and H_gateway then
			if Interface.currentProfile.money > H_hardware[i]._price then
				if Interface.currentProfile.Memory + H_hardware[i].Upvalue > H_gateway[Interface.currentProfile.gateway]._MaxMemory then
				System.message(locale.gatewayMemoryOver,0)
				else
				Interface.currentProfile.money = Interface.currentProfile.money - H_hardware[i]._price
				Interface.currentProfile.Memory = Interface.currentProfile.Memory+H_hardware[i].Upvalue
				System.message(locale.itemPurchased,0)				
				end			
			else 
			System.message(locale.notEnoughMoney,0)
			end
		end
	end	
end

function Uplink:browseItem(key,oldkey,CPU,Modem,Memory)
	if key and oldkey then
		if key:l() and not oldkey:l() and Uplink.Item[Uplink.cur-1] then 
		Uplink.cur = Uplink.cur - 1 
		Uplink.i = 0
		end
		if key:r() and not oldkey:r() and Uplink.Item[Uplink.cur+1] then 
		Uplink.cur = Uplink.cur + 1 
		Uplink.i = 0
		end
	end

	if Uplink.Item[Uplink.cur].type == 'Gateway' then
	local img = H_gateway[Uplink.Item[Uplink.cur].index].img
	local desc = H_gateway[Uplink.Item[Uplink.cur].index]._desc[Interface.locale]
	screen:blit(147-img:width()/2,115-img:height()/2,img)
		if cursor and cursor.y < SCREEN_HEIGHT-14-25 and not Interface.Map:isOn(cursor) and not Interface.Close:isOn(cursor) then
		printf(10,270,typewrite(desc,Uplink.i))
			if Uplink.i < desc:len() then Uplink.i = Uplink.i + 1 else Uplink.i = desc:len() + 1 end
		end
	print(285,115,locale.typeGateway)
	print(285,130,H_gateway[Uplink.Item[Uplink.cur].index]._name)
	print(285,145,locale.costG..H_gateway[Uplink.Item[Uplink.cur].index]._cost)
	print(285,160,locale.maxCPU..H_gateway[Uplink.Item[Uplink.cur].index]._MaxCPU..' Ghz')
	print(285,175,locale.maxBandWidth..H_gateway[Uplink.Item[Uplink.cur].index]._MaxModem..' Mb/s')
	print(285,190,locale.maxMemory..H_gateway[Uplink.Item[Uplink.cur].index]._MaxMemory..' Gb')
		if key:square() and not oldkey:square() then Uplink:getNewGateway(Uplink.Item[Uplink.cur].index) end
	elseif Uplink.Item[Uplink.cur].type == 'CPU' then
	local img = CPU
	local desc = H_hardware[Uplink.Item[Uplink.cur].index]._desc[Interface.locale]
	screen:blit(147-img:width()/2,115-img:height()/2,img)
		if cursor and cursor.y < SCREEN_HEIGHT-14-25 and not Interface.Map:isOn(cursor) and not Interface.Close:isOn(cursor) then
		printf(10,270,typewrite(desc,Uplink.i))
			if Uplink.i < desc:len() then Uplink.i = Uplink.i + 1 else Uplink.i = desc:len() + 1 end
		end	
	print(285,115,'CPU')
	print(285,130,H_hardware[Uplink.Item[Uplink.cur].index].Upvalue..' Ghz')
	print(285,145,locale.costG..H_gateway[Uplink.Item[Uplink.cur].index]._cost)
		if key:square() and not oldkey:square() then Uplink:getCPU(Uplink.Item[Uplink.cur].index) end
	elseif Uplink.Item[Uplink.cur].type == 'Modem' then
	local img = Modem
	local desc = H_hardware[Uplink.Item[Uplink.cur].index]._desc[Interface.locale]
	screen:blit(147-img:width()/2,115-img:height()/2,img)
		if cursor and cursor.y < SCREEN_HEIGHT-14-25 and not Interface.Map:isOn(cursor) and not Interface.Close:isOn(cursor) then
		printf(10,270,typewrite(desc,Uplink.i))
			if Uplink.i < desc:len() then Uplink.i = Uplink.i + 1 else Uplink.i = desc:len() + 1 end
		end	
	print(285,115,locale.sellModem)
	print(285,130,H_hardware[Uplink.Item[Uplink.cur].index].Upvalue..' Mb/s')
	print(285,145,locale.costG..H_gateway[Uplink.Item[Uplink.cur].index]._cost)	
		if key:square() and not oldkey:square() then Uplink:getModem(Uplink.Item[Uplink.cur].index) end
	elseif Uplink.Item[Uplink.cur].type == 'Memory' then
	local desc = H_hardware[Uplink.Item[Uplink.cur].index]._desc[Interface.locale]
	local img = Memory
	screen:blit(147-img:width()/2,115-img:height()/2,img)
		if cursor and cursor.y < SCREEN_HEIGHT-14-25 and not Interface.Map:isOn(cursor) and not Interface.Close:isOn(cursor) then
		printf(10,270,typewrite(desc,Uplink.i))
			if Uplink.i < desc:len() then Uplink.i = Uplink.i + 1 else Uplink.i = desc:len() + 1 end
		end	
	print(285,115,locale.sellMem)
	print(285,130,H_hardware[Uplink.Item[Uplink.cur].index].Upvalue..' Gb')
	print(285,145,locale.costG..H_gateway[Uplink.Item[Uplink.cur].index]._cost)	
		if key:square() and not oldkey:square() then Uplink:getMemory(Uplink.Item[Uplink.cur].index) end
	end
end

function Uplink:drawMain()
local oldkey = Controls.read()
local lfArrow = Image.load('./Contents/graphics/arrows/left.jpg')
local rgArrow = Image.load('./Contents/graphics/arrows/right.jpg')
local CPU = Image.load('./Contents/graphics/gateway/cpu.jpg')
local Modem = Image.load('./Contents/graphics/gateway/modem.jpg')
local Memory = Image.load('./Contents/graphics/gateway/memory.jpg')
Uplink.Item = {}
	for k in ipairs(H_gateway) do table.insert(Uplink.Item,{type = 'Gateway',index = k}) end
	for k in ipairs(H_hardware) do table.insert(Uplink.Item,{type = H_hardware[k]._hardw,index = k}) end
Uplink.cur = 1

	if Interface then 
		while Interface.connected do
		local key = Controls.read()
		updateEnv()
			if Uplink.Item[Uplink.cur-1] then screen:blit(25,70,lfArrow) end
			if Uplink.Item[Uplink.cur+1] then screen:blit(260,70,rgArrow) end
		Uplink:browseItem(key,oldkey,CPU,Modem,Memory)
		Interface.draw(cursor,key,oldkey)		
		swapBuffers()
		oldkey=key
		end
	end
end

