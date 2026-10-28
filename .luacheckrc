-- .luacheckrc
std = "lua53"
allow_defined = true
globals = {
    "TIC", "BOOT", "BDR", "OVR", "MENU",
    "cls", "pix", "line", "rect", "rectb", "circ", "circb", "elli", "ellib",
    "tri", "trib", "ttri", "clip", "spr", "map", "mget", "mset", "print",
    "font", "btn", "btnp", "key", "keyp", "mouse", "sfx", "music",
    "peek", "poke", "peek4", "poke4", "peek2", "poke2", "peek1", "poke1",
    "pmem", "memcpy", "memset", "exit", "reset", "sync", "time", "tstamp", "trace", "vbank",
    "rail", "block", "isDragging"
}
-- Ignora todos os warnings de estilo/variáveis (1xx a 6xx) e falha APENAS se houver erro real de sintaxe Lua (0xx)
ignore = {"1.*", "2.*", "3.*", "4.*", "5.*", "6.*"}
