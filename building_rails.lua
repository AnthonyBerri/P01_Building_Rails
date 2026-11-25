-- title:   Building Rails
-- author:  Felix
-- desc:    Rails and Cart System
-- script:  lua
t = 0
x = 96
y = 24
dir = 0
e_item = 0
inventorySize = 7
camX = 0
camY = 0
dragStartX = 0
dragStartY = 0
isDragging = false
stationSpawnTime = 20
seconds = 0

rails = {}
carts = {}
blocks = {}
stations = {}

DIRS = {
    [1] = {x = 0, y = -0.5},
    [2] = {x = 0.5, y = 0},
    [3] = {x = 0, y = 0.5},
    [4] = {x = -0.5, y = 0}
}
function pontoEmRetangulo(px, py, rx, ry, rw, rh)
    return px >= rx and
           px <= rx + rw and
           py >= ry and
           py <= ry + rh
end

function find(t_array, t)
    for i = 1, #t_array do
        if t == t_array[i] then
            return i
        end
    end
    return false
end
 
function CheckInRail(cx, cy)
    local rx = math.floor(cx + 0.5)
    local ry = math.floor(cy + 0.5)
    for i = 1, #rails do
        if rails[i].x == rx and rails[i].y == ry then
            return rails[i]
        end
    end
    return false
end

function CheckBlock(cx, cy)
    local bx = math.floor(cx + 0.5)
    local by = math.floor(cy + 0.5)
    for i = 1, #blocks do
        if blocks[i].x == bx and blocks[i].y == by then
            return blocks[i]
        end
    end
    return false
end

function PlaceRail(px, py, prot, pt)
    if px < 0 or py < 0 then
        return false
    end
    for i = 1, #rails do
        if rails[i].x == px and rails[i].y == py then
            return false
        end
    end
    table.insert(rails, {x = px, y = py, rot = prot, t_rail = pt})
    return true
end

function PlaceBlock(bx, by, brot)
    for i = 1, #blocks do
        if blocks[i].x == bx and blocks[i].y == by then
            return
        end
    end
    table.insert(blocks, {x = bx, y = by, dir = brot})
end
function PlaceCart(px, py, prot)
    for i = 1, #carts do
        if carts[i].x == px and carts[i].y == py then
            return
        end
    end
    table.insert(carts, {x = px, y = py, dir = prot, trav = 0})
end

function UpdateCarts()
    for i = 1, #carts do
        local cart = carts[i]

        if cart.trav == 0 then
            local currentRail = CheckInRail(cart.x, cart.y)
            if currentRail then
                if currentRail.t_rail == 1 then
                    if currentRail.rot == cart.dir then
                        cart.dir = (cart.dir + 1) % 4
                    else
                        cart.dir = (cart.dir + 3) % 4
                    end
                else
                    local blockAhead = CheckBlock(cart.x + (DIRS[cart.dir+1].x * 16), cart.y + (DIRS[cart.dir+1].y * 16))
                    if blockAhead then
                        cart.dir = (cart.dir + 2) % 4
                    end
                    if not ((cart.dir % 2) == (currentRail.rot % 2)) then
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
        local connectedRail = CheckInRail(s.x, s.y + 16)
        if connectedRail then
            s.con = connectedRail
        end
    else
        PlaceCart(s.x, s.y + 16, 1)
    end
end

function CreateRequest()
    -- MecÃ¢nica reservada para pedidos/passageiros
end
function DrawInventory()
    for i = 1, inventorySize, 1 do
        spr(48 + 256, 52 + (i * 14), 110, 7, 2)
        if e_item + 1 == i then
            spr(49 + 256, 52 + (i * 14), 88, 0, 2)
            spr((i - 1) + 256, 52 + (i * 14) + 4, 110 + 4, 0, 1, 0, dir)
        else
            spr((i - 1) + 256, 52 + (i * 14) + 4, 110 + 4, 0, 1)
        end
    end
end

function DrawHUD()
    print("Rails: " .. #rails, 4, 4, 15, false, 1, true)
    print("Carts: " .. #carts, 4, 12, 15, false, 1, true)
    print("Blocks: " .. #blocks, 4, 20, 15, false, 1, true)
end
function MENU()
end

function TIC()
    -- 1. Controlos de navegaÃ§Ã£o e colocaÃ§Ã£o
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
            local r = CheckInRail(x, y)
            local found = find(rails, r)
            if found ~= false then
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
        local r = CheckInRail(x, y)
        local found = find(rails, r)
        if found ~= false then
            table.remove(rails, found)
        end
    end

    -- 2. SeleÃ§Ã£o de itens e cÃ¢mara por teclas
    if keyp(16) then MENU() end
    if keyp(28) then e_item = 0 end
    if keyp(29) then e_item = 1 end
    if keyp(30) then e_item = 2 end
    if keyp(31) then e_item = 3 end
    if keyp(32) then e_item = 4 end
    if keyp(33) then e_item = 5 end
    if keyp(34) then e_item = 6 end

    if keyp(89) then
        camX = camX + 8
        camY = camY + 8
    end
    if keyp(90) then
        camX = camX - 8
        camY = camY - 8
    end

    -- 3. AtualizaÃ§Ã£o de entidades
    UpdateCarts()

    -- 4. Temporizadores e estaÃ§Ãµes
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

    -- 5. InteraÃ§Ã£o com rato (inventÃ¡rio e arrasto da cÃ¢mara)
    local mx, my, press = mouse()

    for i = 1, inventorySize, 1 do
        if press and pontoEmRetangulo(mx, my, 52 + (i * 14), 110, 16, 16) then
            e_item = i - 1
        end
    end

    if e_item == 6 then
        if press then
            if not isDragging then
                dragStartX = mx + camX
                dragStartY = my + camY
                isDragging = true
            else
                camX = dragStartX - mx
                camY = dragStartY - my
            end
        else
            isDragging = false
        end
    end

    if e_item == 0 and press then
        if mx % 8 ~= 0 and my % 8 ~= 0 then
            mx = mx - (mx % 8)
            my = my - (my % 8)
            PlaceRail(mx - 4, my - 4, dir, e_item)
        end
    end

    -- 6. RenderizaÃ§Ã£o
    cls()

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

    -- Apontador virtual
    spr(32 + 256, x - camX, y - camY, 0, 1, 0, dir, 1, 1)

    DrawInventory()
    DrawHUD()
end