
local modpath = minetest.get_modpath(minetest.get_current_modname())

civsupp = {}
civsupp.db = {}

local ie = minetest.request_insecure_environment() or
   error("CivSupporter needs to be a trusted mod. "
            .."Add it to `secure.trusted_mods` in minetest.conf")

loadfile(modpath .. "/db.lua")(ie)
dofile(modpath .. "/namecolor.lua")
dofile(modpath .. "/alphahat.lua")
dofile(modpath .. "/gild_cloth.lua")

minetest.debug("[CivSupporter] Initialised.")

return civsupp
