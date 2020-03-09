
local modpath = minetest.get_modpath(minetest.get_current_modname())

civsupp = {}
civsupp.db = {}

dofile(modpath .. "/db.lua")
dofile(modpath .. "/namecolor.lua")

minetest.debug("[CivSupporter] Initialised.")

return civsupp
