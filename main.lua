-- title:   Building Rails
-- author:  Felix
-- desc:    Rails and Cart System
-- script:  lua

local x = 96
local y = 24
local dir = 0
local e_rail = 0
local inventorySize = 7

local rails = {}
local carts = {}

local DIRS = {
	[1] = {x = 0, y = -0.5},
	[2] = {x = 0.5, y = 0},
	[3] = {x = 0, y = 0.5},
	[4] = {x = -0.5, y = 0}
}

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
   if not rail == false then
    if rail.t_rail == 1 then
					if rail.rot == cart.dir then
						cart.dir = (cart.dir + 1) % 4
					else
						cart.dir = (cart.dir + 3) % 4
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
		if e_rail+1 == i then
			spr(49, 48 + (i * 16), 88, 0, 2)
		end
		spr(48, 48 + (i * 16), 110, 0, 2)
		spr(i-1, 48 + (i * 16) + 4, 110 + 4, 0, 1)
	end
	

end

function TIC()
 if btnp(0) then y = y - 8 end
 if btnp(1) then y = y + 8 end
 if btnp(2) then x = x - 8 end
 if btnp(3) then x = x + 8 end

 if btnp(4) then
 	if e_rail < 3 then
   PlaceRail(x, y, dir, e_rail)
 	elseif e_rail == 3 then
  	PlaceCart(x, y, dir)
  else
  	local rail = CheckInRail(x, y)
	 	local found = find(rails, rail)
	  if not found == false then
	  	table.remove(rails, found)
	  end 
  end
 end

 if btnp(5) then
  if dir >= 3 then
   dir = 0
  else
   dir = dir + 1
  end
 end
 
 if btnp(6) then
 	local rail = CheckInRail(x, y)
 	local found = find(rails, rail)
  if not found == false then
  	table.remove(rails, found)
  end 
 end
 
 if keyp(28) then
 	e_rail = 0
 end
 
 if keyp(29) then
  e_rail = 1
 end
 
 if keyp(30) then
 	e_rail = 2
 end
 
 if keyp(31) then
 	e_rail = 3
 end
 
 if keyp(32) then
 	e_rail = 4
 end

 UpdateCarts()

 cls(1)

 for i = 1, #rails do
 	local r = rails[i]
  spr(r.t_rail, r.x, r.y, 0, 1, 0, r.rot)
 end

 for i = 1, #carts do
  local c = carts[i]
  spr(3, math.floor(c.x + 0.5), math.floor(c.y + 0.5), 0, 1, 0, c.dir)
 end
 
 -- spr(e_rail, x, y, 0, 1, 0, dir, 1, 1)
 spr(32, x, y, 0, 1, 0, dir, 1, 1)
 
 DrawInventory()
 
 print("Rails: " .. #rails, 4, 4, 15)
 print("Carts: " .. #carts, 4, 12, 15)
end