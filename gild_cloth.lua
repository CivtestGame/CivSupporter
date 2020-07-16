
minetest.register_privilege(
   "gild_cloth",
   {
      description = "Allows the player to gild Cloth Armor.",
      give_to_admin = false
   }
)

minetest.register_chatcommand(
   "gild_cloth",
   {
      description = "Gilds the currently held Cloth Armor item.",
      params = "",
      privs = { gild_cloth = true },
      func = function(pname, param)
         local player = minetest.get_player_by_name(pname)
         if not player then
            return
         end

         local item = player:get_wielded_item()
         if not item or item:is_empty() then
            return false, "Invalid item."
         end

         local def = item:get_definition()
         if not def or not def.groups or not def.groups.gildable then
            return false, "Invalid item."
         end

         local new_name = item:get_name() .. "_g"


         item:set_name(new_name)

         local meta = item:get_meta()
         local new_desc = item:get_definition().description
         local amended_desc = new_desc .. "\n"
            .. "Gilded by " .. pname .. "\n"

         meta:set_string("description", amended_desc)

         if player:set_wielded_item(item) then
            minetest.chat_send_player(
               pname, def.description .. " was gilded!"
            )
            return true
         end
      end
   }
)
