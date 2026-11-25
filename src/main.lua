function MENU()
end

function TIC()
    -- 1. Controlos de navegação e colocação
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

    -- 2. Seleção de itens e câmara por teclas
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

    -- 3. Atualização de entidades
    UpdateCarts()

    -- 4. Temporizadores e estações
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

    -- 5. Interação com rato (inventário e arrasto da câmara)
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

    -- 6. Renderização
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