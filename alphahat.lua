-- Temporarily handles distribution of the Alpha Hat

minetest.register_privilege(
   "alpha_hat",
   {
      description = "Allows the player to acquire the Alpha Hat.",
      give_to_admin = false
   }
)

minetest.register_chatcommand(
   "alpha_hat",
   {
      description = "Gives a player the Alpha Hat, if allowed.",
      params = "",
      privs = { alpha_hat = true },
      func = function(pname, param)
         local player = minetest.get_player_by_name(pname)
         if not player then
            return
         end

         player_api.give_item(player, "3d_armor:hat_alpha")
         minetest.chat_send_player(pname, "Alpha Hat added to inventory.")
      end
   }
)
