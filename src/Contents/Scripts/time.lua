--[[ Uplink For PSP
	Custom Time Class definition File
	- Acts like a custom time class with a rapid flow, in order to make the days go fast...
	- Generates missions randomly
	]]

Ctime = { month31 = {1,3,5,7,8,10,12},month30={4,6,9,11},nextM = true}
function Ctime:new(p)
local this = {Year = p.year,Month = p.month,Day = p.day,Hour=p.hour,Min = p.min,Sec = p.sec,flowSpe = 30,shPay = false}
self.__index = self
return setmetatable(this,self)
end

function Ctime:flow()
self.Sec = self.Sec + self.flowSpe
	if self.Sec > 60 then 
	self.Sec = 0
	self.Min=self.Min+1
	end
	if self.Min > 60 then 
	self.Min = 0
	self.Hour=self.Hour+1
	end	
	--[
	if (self.Hour==8 or self.Hour==16) and (self.Min==0) and (self.sec==30 or self.Sec==60) then
	--oldprint((self.Hour%4==0) and (self.Min==0) and (self.Sec ==0))
		if Interface and not Interface.connected then
			if Ctime.nextM then
			--oldprint('nextM and time')
				if Mission and mission then
				--oldprint('mission')
					if #mission==0 then 
					table.insert(mission,Mission:new())
					mission[1]:askAcceptance()
					--Ctime.nextM = false 
					end
				end				
			end
		end		
	end
	--]]
	if self.Hour > 23 then
	self.shPay = true
	self.Hour = 0
	self.Day=self.Day+1
		if isListed(self.Month,Ctime.month31) and self.Day > 31 then 
		self.Day=1
		self.Month = self.Month+1
		elseif isListed(self.Month,Ctime.month30) and self.Day > 30 then
		self.Day=1
		self.Month = self.Month+1
		else
			if ((self.Year%4)==0) then
				if self.Day > 29 then
				self.Day=1
				self.Month = self.Month+1
				end
			else
				if self.Day > 28 then
				self.Day = 1
				self.Month = self.Month+1
				end
			end
		end
	end	
	if self.Month > 12 then
	self.Month = 1
	self.Year = self.Year+1
	end	
end


function Ctime:payFee()
	if self.shPay then 	
		if Interface then Interface.currentProfile.money = Interface.currentProfile.money+Interface.salary end
	local out = locale.payFee
	out = string.gsub(out,'SALARY',Interface.salary)	
	System.message(out,0) 
	self.shPay = false
	end
end