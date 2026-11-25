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
