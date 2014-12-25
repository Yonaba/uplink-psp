--[[/*
  =============================================================================
  =                                                                            =
  =                       UPLINK For PSP                                        =
  =                                                                            =
  =               Started August '10                                            =
  =                                                                            =
  =            Source Code: Roland Y.                                          =
  =                                                                           =
  =          Uses 'Uplink Hacker Elite' Original Graphics                      =
  =                                                                            =
  =                                                                            =
  =============================================================================
  */
--]]

--Pilot File : Inits all modules

--lphmEmu is not executed on PSP, just on PC for debug
if os.getenv("os")=='Windows_NT' then
  require './Contents/Scripts/lphmEmu'
end


--Disables ME to use old Soud and Music Funcs  
System.oaenable()
  
--Loads Libraries
require './Contents/Scripts/Constants'  
require './Contents/Scripts/Sounds'  
require './Contents/Scripts/Audio'  
require './Contents/Data/Identities/ids'  
require './Contents/Scripts/Core'
require './Contents/Scripts/Cursor'
require './Contents/scripts/GUI'
require './Contents/scripts/news'
require './Contents/scripts/resource'
require './Contents/scripts/uplink'
require './Contents/Data/Files/files'
require './Contents/scripts/server'
require './Contents/scripts/bank'
require './Contents/scripts/federal'
require './Contents/scripts/Time'
require './Contents/Scripts/HUD'
require './Contents/scripts/missions'
require './Contents/GameCore/GameCore'

System.oadisable()