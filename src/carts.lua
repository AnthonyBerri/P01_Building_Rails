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