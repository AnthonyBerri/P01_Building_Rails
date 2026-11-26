dofile("building_rails.lua")

rails = {}

assert(PlaceRail(-8, 16, 0, 0) == false, "Erro: Deveria recusar px negativo")
assert(#rails == 0, "Erro: Nao deveria inserir trilho com px negativo")

assert(PlaceRail(16, -8, 0, 0) == false, "Erro: Deveria recusar py negativo")
assert(#rails == 0, "Erro: Nao deveria inserir trilho com py negativo")

assert(PlaceRail(16, 16, 0, 0) == true, "Erro: Deveria permitir coordenada valida")
assert(#rails == 1, "Erro: Deveria ter inserido 1 trilho")

print("Testes automatizados passaram com sucesso!")