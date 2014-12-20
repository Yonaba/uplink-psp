--[[ Uplink For PSP
	Cursor definition File
	]]
	
	cursor = {x = 240,y=136,img=Image.load("./Contents/graphics/mouse.png"),w=11,h=19,
		draw=function()
		local key=Controls.read()
		local ax = key:analogX()
		local ay = key:analogY()
		--Analog scroll		
		if ax>50 then if cursor.x < SCREEN_WIDTH-1 then cursor.x = cursor.x+2 end end 
		if ax<-50 then if cursor.x > 0 then cursor.x = cursor.x-2 end end
		if ay>50 then if cursor.y< SCREEN_HEIGHT-1 then cursor.y = cursor.y+2 end  end
		if ay<-50 then if cursor.y > 0 then cursor.y = cursor.y-2   end end
		if ax>80 then if cursor.x < SCREEN_WIDTH-1 then cursor.x = cursor.x+4   end end
		if ax<-80 then if cursor.x > 0 then cursor.x = cursor.x-4  end end
		if ay>80 then if cursor.y< SCREEN_HEIGHT-1 then cursor.y = cursor.y+4   end end
		if ay<-80 then if cursor.y > 0 then cursor.y = cursor.y-4   end end
		if ax>120 then if cursor.x < SCREEN_HEIGHT-1 then cursor.x = cursor.x+6  end end
		if ax<-120 then if cursor.x > 0 then cursor.x = cursor.x-6  end end
		if ay>120 then if cursor.y< SCREEN_HEIGHT-1 then cursor.y = cursor.y+6 end  end
		if ay<-120 then if cursor.y > 0 then cursor.y = cursor.y-6  end end	
		
		--Smooth scroll using keypad arrows
		if key:up() and cursor.y > 0 then cursor.y=cursor.y-1 end
		if key:down() and cursor.y < SCREEN_HEIGHT then cursor.y=cursor.y+1  end
		if key:left() and cursor.x > 0 then cursor.x=cursor.x-1  end
		if key:right() and cursor.x < SCREEN_WIDTH then cursor.x=cursor.x+1  end
		screen:blit(cursor.x,cursor.y,cursor.img)
end}