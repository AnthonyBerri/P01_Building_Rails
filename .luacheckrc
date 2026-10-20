std = "lua53"
globals = {
    "TIC", "BOOT", "BDR", "OVR", "MENU",
    "cls", "pix", "line", "rect", "rectb", "circ", "circb", "elli", "ellib",
    "tri", "trib", "ttri", "clip", "spr", "map", "mget", "mset", "print",
    "font", "btn", "btnp", "key", "keyp", "mouse", "sfx", "music",
    "peek", "poke", "peek4", "poke4", "peek2", "poke2", "peek1", "peek1",
    "pmem", "memcpy", "memset", "exit", "reset", "sync", "time", "tstamp", "trace", "vbank"
}
ignore = {"211", "212", "213", "611", "612", "614"} -- Ignora variáveis ainda não usadas e espaços em branco