-- .luacheckrc
std = "lua53"
allow_defined = true
globals = {
    "TIC", "BOOT", "BDR", "OVR", "MENU",
    "cls", "pix", "line", "rect", "rectb", "circ", "circb", "elli", "ellib",
    "tri", "trib", "ttri", "clip", "spr", "map", "mget", "mset", "print",
    "font", "btn", "btnp", "key", "keyp", "mouse", "sfx", "music",
    "peek", "poke", "peek4", "poke4", "peek2", "poke2", "peek1", "poke1",
    "pmem", "memcpy", "memset", "exit", "reset", "sync", "time", "tstamp", "trace", "vbank"
}
-- Ignora avisos de variáveis globais (111/112/113), não usadas (211/212/213), estilo (5xx) e indentação/espaços (6xx)
ignore = {"111", "112", "113", "211", "212", "213", "5.*", "6.*"}