-- title:   Building Rails
-- author:  Felix
-- desc:    Rails and Cart System
-- script:  lua

local x = 96
local y = 24
local dir = 0
local e_rail = 0

local rails = {}
local carts = {}

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

local function CheckRailRotation(rail)

	if rail.rot == 0 and rail.t_rail == 0 then
		return "negy"
	elseif rail.rot == 1 and rail.t_rail == 0 then
		return "posx"
	elseif rail.rot == 2 and rail.t_rail == 0 then
		return "posy"
	elseif rail.rot == 3 and rail.t_rail == 0 then
		return "negx"
	elseif rail.rot == 0 and rail.t_rail == 1 then
		return "posx"
	elseif rail.rot == 1 and rail.t_rail == 1 then
		return "posy"
	elseif rail.rot == 2 and rail.t_rail == 1 then
		return "negx"
	elseif rail.rot == 3 and rail.t_rail == 1 then
		return "negy"
	else
		return false
	end
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
   	railRot = CheckRailRotation(rail)
    if railRot == "negx" then
	    cart.trav = cart.trav + 0.5
	    cart.x = cart.x - 0.5
					cart.dir = 1
				elseif railRot == "posx" then
					cart.trav = cart.trav + 0.5
					cart.x = cart.x + 0.5
					cart.dir = 3
				elseif railRot == "negy" then
					cart.trav = cart.trav + 0.5
					cart.y = cart.y - 0.5
					cart.dir = 0
				elseif railRot == "posy" then
					cart.trav = cart.trav + 0.5
					cart.y = cart.y + 0.5
					cart.dir = 2
				else
					
				end
   end
  else
   if cart.trav < 8 then
    cart.trav = cart.trav + 0.5
    if cart.dir == 0 then
    	cart.y = cart.y - 0.5
    elseif cart.dir == 1 then
    	cart.x = cart.x - 0.5
    elseif cart.dir == 2 then
    	cart.y = cart.y + 0.5
    else
    	cart.x = cart.x + 0.5
    end
   else
    cart.trav = 0
    cart.x = math.floor(cart.x + 0.5)
    cart.y = math.floor(cart.y + 0.5)
   end
  end
 end
end

function TIC()
 if btnp(0) then y = y - 8 end
 if btnp(1) then y = y + 8 end
 if btnp(2) then x = x - 8 end
 if btnp(3) then x = x + 8 end

 if btnp(4) then
     PlaceRail(x, y, dir, e_rail)
 end

 if btnp(5) then
     if dir >= 3 then
         dir = 0
     else
         dir = dir + 1
     end
 end

 if btnp(6) then
     if e_rail == 1 then
         e_rail = 0
     else
         e_rail = 1
     end
 end

 if btnp(7) then
     PlaceCart(x, y, rot)
 end

 UpdateCarts()

 cls(1)

 for i = 1, #rails do
     local r = rails[i]
     spr(r.t_rail, r.x, r.y, 0, 1, 0, r.rot)
 end

 for i = 1, #carts do
     local c = carts[i]
     spr(3, math.floor(c.x + 0.5), math.floor(c.y + 0.5), 0)
 end
 
 spr(e_rail, x, y, 0, 1, 0, dir, 1, 1)
 
 print("Rails: " .. #rails, 4, 4, 15)
 print("Carts: " .. #carts, 4, 12, 15)
end