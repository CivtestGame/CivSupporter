
minetest.register_privilege(
   "namecolor",
   {
      description = "Allows the player to set their chat name color."
   }
)

local player_chatcolors = {}

local old_get_player_name_color = civchat.get_player_name_color

minetest.register_on_joinplayer(function(player)
      local pname = player:get_player_name()
      local privs = core.get_player_privs(pname)
      local color_entry = civsupp.db.get_namecolor(pname)
      if color_entry then
         if not privs["namecolor"] then
            pmutils.grant_privilege(pname, "namecolor")
            player_chatcolors[pname] = color_entry["color"]
            minetest.log(
               "[CivSupporter] " .. pname .. " was granted namecolor privilege."
            )
         end
         player_chatcolors[pname] = color_entry["color"]
      else
         if privs["namecolor"] then
            pmutils.revoke_privilege(pname, "namecolor")
            player_chatcolors[pname] = nil
            minetest.log(
               "[CivSupporter] " .. pname .. " had namecolor privilege revoked."
            )
         end
      end
end)

function civchat.get_player_name_color(pname)
   return player_chatcolors[pname] or old_get_player_name_color(pname)
end

local function validate_color(str)
   local str = str:lower()
   return str:match("#%x%x%x%x%x%x$") or str:match("#%x%x%x$")
end

minetest.register_chatcommand(
   "namecolor",
   {
      description = "Sets the sender's chat name color. "
         .. "If no parameter specified, unset the player's chat name color.",
      params = "[<hex color code>]",
      privs = { namecolor = true },
      func = function(pname, param)
         local player = minetest.get_player_by_name(pname)

         if param == "" then
            player_chatcolors[pname] = nil
            return true, "Chat name color was unset."
         end

         local color = validate_color(param)
         if not color then
            return false, "Invalid color code format."
         end

         player_chatcolors[pname] = color
         civsupp.db.update_namecolor(pname, color)

         local C = minetest.colorize
         return true, "Chat name color changed to: " .. C(color, color) .. "."
      end
   }
)
