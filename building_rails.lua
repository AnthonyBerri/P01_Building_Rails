-- title:   Building Rails
-- author:  Felix
-- desc:    Rails and Cart System
-- script:  lua

local t = 0
local x = 96
local y = 24
local dir = 0
local e_item = 0
local inventorySize = 7
local camX = 0
local camY = 0
local dragStartX = 0
local dragStartY = 0
local isDragging = false
local stationSpawnTime = 20
local seconds = 0

local rails = {}
local carts = {}
local blocks = {}
local stations = {}

local DIRS = {
	[1] = {x = 0, y = -0.5},
	[2] = {x = 0.5, y = 0},
	[3] = {x = 0, y = 0.5},
	[4] = {x = -0.5, y = 0}
}

function pontoEmRetangulo(px, py, rx, ry, rw, rh)
    return px >= rx and       -- Ponto está à direita da borda esquerda
           px <= rx + rw and  -- Ponto está à esquerda da borda direita
           py >= ry and       -- Ponto está abaixo da borda superior
           py <= ry + rh      -- Ponto está acima da borda inferior
end

local function find(t_array ,t)
 for i = 1, #t_array do
  if t == t_array[i] then
  	return i
  end
 end
 return false
end

local function CheckInRail(cx, cy)
 local rx = math.floor(cx + 0.5)
 local ry = math.floor(cy + 0.5)
 for i = 1, #rails do
  if rails[i].x == rx and rails[i].y == ry then
   return rails[i]
  end
 end
 return false
end

local function CheckBlock(cx, cy)
	local bx = math.floor(cx + 0.5)
 local by = math.floor(cy + 0.5)
 for i = 1, #blocks do
  if blocks[i].x == bx and blocks[i].y == by then
   return blocks[i]
  end
 end
 return false
end

local function PlaceRail(px, py, prot, pt)
 for i = 1, #rails do
  if rails[i].x == px and rails[i].y == py then
   return
  end
 end
 table.insert(rails, {x = px, y = py, rot = prot, t_rail = pt})
end

local function PlaceCart(px, py, prot)
 for i = 1, #carts do
 	if carts[i].x == px and carts[i].y == py then
   return
  end
 end
 table.insert(carts, {x = px, y = py, dir = prot, trav = 0})
end

local function UpdateCarts()
 for i = 1, #carts do
  local cart = carts[i]

  if cart.trav == 0 then
  	rail = CheckInRail(cart.x, cart.y)
   if rail then
    if rail.t_rail == 1 then
					if rail.rot == cart.dir then
						cart.dir = (cart.dir + 1) % 4
					else
						cart.dir = (cart.dir + 3) % 4
					end
				else
		   block = CheckBlock(cart.x + (DIRS[cart.dir+1].x * 16),cart.y + (DIRS[cart.dir+1].y * 16))
		   if block then
		   	cart.dir = (cart.dir + 2) % 4
		   end
					if not ((cart.dir % 2) == (rail.rot % 2)) then
						if math.random(0, 1) == 1 then
							cart.dir = (cart.dir + 1) % 4
						else
							cart.dir = (cart.dir - 1) % 4
						end
					end
					
				end
				cart.trav = cart.trav + 0.5
				cart.x = cart.x + DIRS[cart.dir+1].x
				cart.y = cart.y + DIRS[cart.dir+1].y
   end
  else
   if cart.trav < 8 then
    cart.trav = cart.trav + 0.5
    cart.x = cart.x + DIRS[cart.dir+1].x
				cart.y = cart.y + DIRS[cart.dir+1].y
   else
    cart.trav = 0
    cart.x = math.floor(cart.x + 0.5)
    cart.y = math.floor(cart.y + 0.5)
   end
  end
 end
end

local function DrawInventory()

	for i = 1, inventorySize, 1 do
		spr(48 + 256, 52 + (i * 14), 110, 7, 2)
		if e_item+1 == i then
			spr(49 + 256, 52 + (i * 14), 88, 0, 2)
			spr((i-1) + 256, 52 + (i * 14) + 4, 110 + 4, 0, 1, 0, dir)
		else
			spr((i-1) + 256, 52 + (i * 14) + 4, 110 + 4, 0, 1)
		end
	end
end

local function PlaceBlock(bx, by, brot)
	for i = 1, #blocks do
 	if blocks[i].x == bx and blocks[i].y == by then
   return
  end
 end
 table.insert(blocks, {x = bx, y = by, dir = brot})
end

function SpawnStation(sx, sy)
	for i = 1, #stations do
		if stations[i].x == sx and stations[i].y == sy then
		 return
		end
	end
	table.insert(stations, {x = sx, y = sy, con = false})
end

function HandleStation(s)
	if s.con == false then
		local rail = CheckInRail(s.x, s.y + 16)
		if rail then
			s.con = rail
		end
	else
		PlaceCart(s.x, s.y + 16, 1)
	end
end

function CreateRequest()

end

function MENU() 

end

function TIC()
 if btnp(0) then y = y - 8 end
 if btnp(1) then y = y + 8 end
 if btnp(2) then x = x - 8 end
 if btnp(3) then x = x + 8 end

 if btnp(4) then
 	if e_item < 3 then
   PlaceRail(x, y, dir, e_item)
 	elseif e_item == 3 then
  	PlaceCart(x, y, dir)
  elseif e_item == 5 then
  	local rail = CheckInRail(x, y)
	 	local found = find(rails, rail)
	  if not found == false then
	  	table.remove(rails, found)
	  end
		else
			PlaceBlock(x, y, dir)
  end
 end

 if btnp(5) then
 	dir = (dir + 1) % 4
 end
 
 if btnp(6) then
 	local rail = CheckInRail(x, y)
 	local found = find(rails, rail)
  if not found == false then
  	table.remove(rails, found)
  end 
 end
 
 if keyp(16) then
 	MENU()
 end
 
 if keyp(28) then
 	e_item = 0
 end
 
 if keyp(29) then
  e_item= 1
 end
 
 if keyp(30) then
 	e_item = 2
 end
 
 if keyp(31) then
 	e_item = 3
 end
 
 if keyp(32) then
 	e_item = 4
 end
 
 if keyp(33) then
  e_item = 5
 end
 
 if keyp(34) then
 	e_item = 6
 end
 
 if keyp(89) then
 	camX = camX + 8
  camY = camY + 8
 end
 
 if keyp(90) then
 	camX = camX - 8
  camY = camY - 8
 end

 UpdateCarts()

 cls()
 
 local localSeconds = math.floor(time() / 1000)
 
 t = t + 1
 
 if t >= 60 then
 	seconds = seconds + 1
  t = 0
  for i = 1, #stations do
  	HandleStation(stations[i])
  end
 
	 if (seconds % stationSpawnTime) == 0 then
	  SpawnStation(
	  	math.random(0, 29) * 8,
	   math.random(0, 16) * 8
	  )
		end
 end
 
 local mx, my, press = mouse()

 for i = 1, inventorySize, 1 do
	if press then
		if pontoEmRetangulo(mx, my, 52 + (i * 14), 110, 8, 8) then
			e_item = i - 1
		end
	end
end

 if e_item == 6 then
	 -- local mx, my, press = mouse()
	
	 if press then
	  if not isDragging then
	   -- Click started: remember the mouse position and current camera anchor
	   dragStartX = mx + camX
	   dragStartY = my + camY
	   isDragging = true
	  else
	   -- Currently dragging: calculate new camera position based on mouse movement
	   camX = dragStartX - mx
	   camY = dragStartY - my
	  end
	 else
	  -- Left click released
	  isDragging = false
	 end
		-- x = x - camX
	 -- y = y - camY
	end
	
	if e_item == 0 then
		if press then
			if mx % 8 ~= 0 and my % 8 ~= 0 then
				mx = mx - (mx % 8)
				my = my - (my % 8)
				PlaceRail(mx, my, dir, e_item)
			end	
		end
	end

 -- Draw the map offset by the camera variables
 -- Arguments: map( tileX, tileY, tileW, tileH, sx, sy )
 map(math.floor(camX / 8), math.floor(camY / 8), 31, 18, -(camX % 8), -(camY % 8))

 for i = 1, #rails do
 	local r = rails[i]
  spr(r.t_rail + 256, r.x - camX, r.y - camY, 0, 1, 0, r.rot)
 end

 for i = 1, #carts do
  local c = carts[i]
  spr(3 + 256, math.floor(c.x + 0.5) - camX, math.floor(c.y + 0.5) - camY, 0, 1, 0, c.dir)
 end
 
 for i = 1, #blocks do
 	local b = blocks[i]
  spr(4 + 256, b.x - camX, b.y - camY, 0, 1, 0, b.dir)
 end
 
 for i = 1, #stations do
 	local s = stations[i]
  spr(336, s.x - camX, s.y - camY, 0, 1, 0, 0, 2, 2)
 end
 
 -- Virtual Pointer
 spr(32 + 256, x - camX, y - camY, 0, 1, 0, dir, 1, 1)
 
 DrawInventory()
 
 -- map(0, 0, 30, 17, -camX, -camY, -1)
 
 print("Rails: " .. #rails, 4, 4, 15, false, 1, true)
 print("Carts: " .. #carts, 4, 12, 15, false, 1, true)
 print("Blocks: " .. #blocks, 4, 20, 15, false, 1, true)

 
end
-- <TILES>
-- 000:1111111111111111111111111111111111111111111111111111111111111111
-- 001:6555555555555565565555555555555555555655555655555565556555555555
-- 004:044444004e44e4404444444044e4444044e44400444444420444444200044442
-- 005:0000000000000000000000000000000000000000222000002220000022200000
-- 020:00022221022222212222222122222221222222212222222122aaaaa1aaaaaaa0
-- 021:2220000022200000222000002220000022200000222000004440000044400000
-- 036:0aa00aa00aa00aa00aa00aa00aa00aa00aa00aa00aa00aa0fff0fff0fff0fff0
-- </TILES>

-- <SPRITES>
-- 000:0d0000d03d3333d30d0000d03d3333d00d0000d03d3333d30d0000d00d3333d3
-- 001:00000003003ddddd00d003003d0300300d0030030d3003000d03003d3d0030d3
-- 002:3d3333d30d0000d034233243040220403d3333d30d0000d03423324304022040
-- 003:000ee00000effe000effffe00effffe00effffe00effffe00effffe000eeee00
-- 004:00000000002222000222222042cccc24e222222ee022220ee000000ee000000e
-- 005:0dddddd0dddddddd0ffffff00edfeff00edeedf00edeede00edeede00eeeeee0
-- 006:0000000000ccc00000cccc0000cccc00c0ccccc0cccfcfc00ccfcfc000cccc00
-- 032:000000000000000000000000000cc000000cc000000000000000000000000000
-- 048:7444444740000004400000044000000440000004400000044000000474444447
-- 049:0000000000000000000000000000000000000000004004000044440000044000
-- 080:000000000000000000000000000000060000006600000668000066990006699b
-- 081:00000000000000000000000060000000660000008660000099660000b9966000
-- 096:006868880089899900999999009ff99fdd99999fdddddddddddddddddddddddd
-- 097:888686009998980099999900f99ff900f99999dddddddddddddddddddddddddd
-- </SPRITES>

-- <WAVES>
-- 000:00000000ffffffff00000000ffffffff
-- 001:0123456789abcdeffedcba9876543210
-- 002:0123456789abcdef0123456789abcdef
-- </WAVES>

-- <SFX>
-- 000:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000364000000000
-- </SFX>

-- <TRACKS>
-- 000:100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000090
-- </TRACKS>

-- <PALETTE>
-- 000:1a1c2c5d275db13e53ef7d57ffcd75a7f07038b76425717929366f3b5dc941a6f673eff7f4f4f494b0c2566c86333c57
-- </PALETTE>

