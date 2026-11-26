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
