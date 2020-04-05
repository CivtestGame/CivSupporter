--[[

Database connection functionality via PostgreSQL.

`luarocks install luasql-postgres`

]]--

local ie = ...

local driver = ie.require("luasql.postgres")
local db = nil
local env = nil

local sourcename = minetest.settings:get("civsupporter_db_sourcename")
local username = minetest.settings:get("civsupporter_db_username")
local password = minetest.settings:get("civsupporter_db_password")

local u = pmutils

local function prep_db()
   local res
   env = assert (driver.postgres())
   -- connect to data source
   db = assert (env:connect(sourcename, username, password))

   res = assert(u.prepare(db,  [[
     CREATE TABLE IF NOT EXISTS player_chatcolor (
         player_id VARCHAR(16) REFERENCES player(id),
         color VARCHAR(16),
         assign_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
         expiry_date TIMESTAMP,
         active BOOLEAN DEFAULT TRUE NOT NULL,
         PRIMARY KEY (player_id)
     )]]))
end

prep_db()

minetest.register_on_shutdown(function()
   db:close()
   env:close()
end)

--------------------------------------------------------------------------------
--
-- Queries + query functions
--
--------------------------------------------------------------------------------

-- Name color fetch/update

local QUERY_REGISTER_NAMECOLOR = [[
  INSERT INTO player_chatcolor (player_id, color)
  VALUES (
    (SELECT (id) FROM player WHERE player.name = ?), ?
  )
  ON CONFLICT (player_id) DO UPDATE
    SET color = ?, active = ?;
]]

local QUERY_GET_NAMECOLOR = [[
  SELECT (color) FROM player_chatcolor
  WHERE player_chatcolor.player_id =
      (SELECT (id) FROM player WHERE player.name = ?)
    AND player_chatcolor.active = ?;
]]

function civsupp.db.update_namecolor(pname, color, active)
   -- if a caller doesn't provide the 'active' parameter, just assume they want
   -- the entry to be active.
   if active == nil then
      active = true
   end
   return assert(
      u.prepare(db, QUERY_REGISTER_NAMECOLOR, pname, color, color, active)
   )
end

function civsupp.db.get_namecolor(pname)
   local cur = u.prepare(db, QUERY_GET_NAMECOLOR, pname, true)
   return cur and cur:fetch({}, "a")
end
