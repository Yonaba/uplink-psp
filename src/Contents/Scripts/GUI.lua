--[[ Uplink For PSP
	Mini GUI Class definition File
	 - Create Icon & Button Class
	 - Sets funcs
	]]
	
Icon = {}
Button = {}

function Icon:new(param)
local icon = {ID = param.ID,x = param.x, y = param.y, w = param.w, h = param.h,
				text = param.text,i=0,img = param.img}
self.__index = self
	return setmetatable(icon,self)
end

function Icon:isOn(cursor)
	return staticIsOn(cursor,self)
end

function Icon:hasClicked(cursor,key,oldkey)
	if key and oldkey and key:cross() and not oldkey:cross() then
		return staticIsOn(cursor,self)	
	else return false
	end
	
end

function Icon:typeWrite()	
	if self.i < string.len(self.text) then 
	self.i=self.i+1	
	--io.write(self.i..'\t'..string.sub(self.text,1,self.i)..'\n')
	printf(10,270,string.sub(self.text,1,self.i))
	else
	--self.i,self.tmptext=0,''
	printf(10,270,self.text)
	end	
end


function Icon:highlight(color)
drawrect(self.x-1,self.y-1,self.w+1,self.h+1,color)
end

function Icon:connect(f,...)
self.f = f
self.arg = {}
	for k in ipairs(arg) do
	table.insert(self.arg,arg[k])
	end
end

function Icon:onClickEvent(key,oldkey)
	if key and oldkey then
		if key:cross() and not oldkey:cross() then
			if self.f then self.f(unpack(self.arg)) end
		end
	end
end
			

function Icon:draw(cursor,key,oldkey,color)
	if self:isOn(cursor) then
	self:onClickEvent(key,oldkey)
	self:highlight(color)
		if self.text then self:typeWrite() end
	else self.i=0
	end
	if self.img then screen:blit(self.x,self.y,self.img) end
end

function Button:new(param)
	local button = {x = param.x, y = param.y, w = param.w,h=param.h,text = '',desc = param.desc,i=0}
	self.__index = self
	setmetatable(button,self)
	return button
end

function Button:isOn(cursor)
	return staticIsOn(cursor,self)
end

function Button:typeWrite()	
	if self.i < string.len(self.desc) then 
	self.i=self.i+1	
	--io.write(self.i..'\t'..string.sub(self.text,1,self.i)..'\n')
	printf(10,270,string.sub(self.desc,1,self.i))
	else
	--self.i,self.tmptext=0,''
	printf(10,270,self.desc)
	end	
end

function Button:highlight(color)
	drawrect(self.x-1,self.y-1,self.w+1,self.h+1,color)
end

function Button:onClickEvent(value)	
	if self.text then
		if self.text==value then
		System.message(locale.passwordOK,0)
			if self.f then self.f(unpack(self.arg)) end
		end
	end
end

function Button:connect(f,...)
	if f then 
	self.f = f 
	self.arg = {}
		for k in ipairs(arg) do table.insert(self.arg,arg[k]) end
	end
end

function Button:draw(cursor,key,oldkey,value)
	if self:isOn(cursor) then
		if key and oldkey then
			if key:cross() and not oldkey:cross() then
			self.text = System.startOSK('','')
			end
		end
	self:highlight(color)	
		if self.desc then self:typeWrite() end
	else self.i=0
	end
	self:onClickEvent(value)
	local append = ''
		if data and data[54]:isActive() then append = string.char(math.random(97,122)) end 
	if self.text then print(self.x+10,self.y+5,self.text..append) end
end

function Button:drawSpe(cursor,key,oldkey)
	if self:isOn(cursor) then
	self:highlight(color)	
		if self.desc then self:typeWrite() end
	else self.i=0
	end
	if self.text then print(self.x+10,self.y+5,self.text) end
end
