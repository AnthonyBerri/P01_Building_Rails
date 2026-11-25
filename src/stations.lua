StationType = {
    PRODUCER = 1, -- Gera carrinhos/recursos
    CONSUMER = 2  -- Pede recursos (acumula pins)
}

function SpawnStation(sx, sy, stype, color_id)
    table.insert(stations, {
        x = sx,
        y = sy,
        type = stype,            -- PRODUCER ou CONSUMER
        color = color_id,        -- 1=Azul, 2=Vermelho, etc.
        requests = 0,            -- Pins acumulados
        incoming_carts = 0,      -- Carrinhos já despachados a caminho
        timer = 0,
        max_requests = 6         -- Se bater 6, game over (como no Mini Motorways)
    })
end

function HandleStation(s)
    if s.con == false then
        local connectedRail = CheckInRail(s.x, s.y + 16)
        if connectedRail then
            s.con = connectedRail
        end
    else
        if s.requests > 0 then
            PlaceCart(s.x, s.y + 16, 1)
        end
    end
end

function UpdateStations()
    for i = 1, #stations do
        local s = stations[i]
        
        if s.type == StationType.CONSUMER then
            s.timer = s.timer + 1
            -- A cada 5 segundos gera um pedido novo
            if s.timer >= 300 then
                s.timer = 0
                s.requests = s.requests + 1
                
                -- Checagem de derrota estilo Mini Motorways
                if s.requests >= s.max_requests then
                    -- Trigger Game Over por superlotação
                end
            end
            
            -- Se tem pedido e não tem carrinho a caminho suficiente:
            if (s.requests - s.incoming_carts) > 0 then
                local producer = FindProducerFor(s.color, s.x, s.y)
                if producer then
                    DispatchCart(producer, s)
                    s.incoming_carts = s.incoming_carts + 1
                end
            end
        end
    end
end

function CreateRequest()
    -- Mecânica reservada para pedidos/passageiros

end