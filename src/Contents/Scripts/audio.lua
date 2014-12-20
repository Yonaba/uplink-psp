--[[ Uplink For PSP
	PlayList Mini Class
	 - Creates PlayList
	 - Sets func for playlist infinite loop
	]]
	
playList = {
	files = {'./Contents/Audio/Music/DeepInHerEyes.s3m',
			 './Contents/Audio/Music/Mystique-Part1.s3m',
			 './Contents/Audio/Music/Mystique-Part2.s3m',
			 './Contents/Audio/Music/Symphonic.mod',
			 './Contents/Audio/Music/TheBlueValley.s3m',
			}
		   }
		   
function playList.getNewStream()
	local n = math.random(1,#playList.files)
	return playList.files[n]
end

			

