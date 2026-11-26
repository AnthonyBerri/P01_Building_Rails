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
 