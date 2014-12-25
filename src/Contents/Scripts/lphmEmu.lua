--[[ Uplink For PSP
  Custom LPHM Emulator
  - Custom functions to override LuaPlayerHm PSP's specific functions
  - This file is not executed on a PSP
  ]]
  
--custom functions to override LuaPlayerhm's func

System = {}

Gu={}
function Gu.start3d() return end
function Gu.end3d() return end

function System.getDate(arg)
local _time = os.date("!*t")
local ret = {}
table.insert(ret,_time.year)
table.insert(ret,_time.month)
table.insert(ret,_time.day)
  return ret[arg]
end

function System.getTime(arg)
local _time = os.date("!*t")
local ret = {}
table.insert(ret,_time.hour)
table.insert(ret,_time.min)
table.insert(ret,_time.sec)
  return ret[arg]
end

function System.message(text,value)
  oldprint(text)
  while true do
  updateEnv()  
    if Controls.read():circle() then 
    oldprint('--------------')
    break 
    end
  swapBuffers()
  end
end

function System.buttonPressed(value)
  return (value==1) and 'yes' or 'no'
end

function System.startOSK(str1,str2)
  local v = 0
  while v<15 do
  v=v+1
  updateEnv()
  print(10,0,v)
  print(10,10,str1)  
  swapBuffers()
  end
  str = io.read()
  return tostring(str)
end

function System.Quit()
  return oldprint('exiting....')
end

function System.removeFile(str)
  return os.remove(str)
end

function System.copyFile(srcpath,destpath,value)
  local data
  local f = assert(io.open(srcpath,'r'))
  if f then
  data = f:read('*a')  
  f:close()
  end
  
  local out = assert(io.open(destpath,'w'))
  if out then
  out:write(data)  
  out:close()
  end
  if value==1 then os.remove(srcpath) end
end

function System.oaenable() return end
function System.oadisable() return end