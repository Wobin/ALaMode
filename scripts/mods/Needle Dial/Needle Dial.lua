--[[
Title: Needle Dial
Author: Wobin
Date: 11/12/2025
Repository: https://github.com/Wobin/NeedleDial
Version: 1.0.0
--]]

local mod = get_mod("Needle Dial")
mod.version = "1.0.0"

local Color = Color
local table = table
local equals = table.equals
local Managers = Managers
local ManagersPlayer = Managers.player

local needlePistol = "content/items/weapons/player/ranged/needlepistol_p1_m1"
local needlePistol2 = "content/items/weapons/player/ranged/needlepistol_p1_m2"

mod.game_state = mod:persistent_table("gameState", {})

mod.init = function()
    mod:hook_safe(CLASS.HudElementPlayerWeapon,"update", function(self)            
        if self._parent._player._profile.archetype.name == "broker" and self._slot_name == "slot_secondary" and (self._weapon_name == needlePistol or self._weapon_name == needlePistol2) then        
            local special_active = self._slot_component.special_active
            local icon_widget = self._widgets_by_name.icon
            local icon_style = icon_widget.style.icon
            
            local cyan = Color.cyan(255, true)
            local yellow = Color.yellow(255, true)

            if (special_active and not equals(icon_style.color, cyan)) or (not special_active and not equals(icon_style.color, yellow)) then            
                icon_style.color = special_active and cyan or yellow             
                icon_widget.dirty = true                    
            end                          
        end    
    end)
    mod.initialized = true    
end

mod.on_game_state_changed = function(status, state_name)        
    if not mod.initialized and status == "enter" and state_name == "GameplayStateRun" then            
        if ManagersPlayer:local_player(1)._profile.archetype.name == "broker" then
            mod:init()
        end
    end
    mod.game_state.status = status
    mod.game_state.state_name = state_name    
end

mod.on_all_mods_loaded = function()
    mod:info(mod.version)
    if mod.game_state.status and mod.game_state.state_name then        
        mod.on_game_state_changed(mod.game_state.status, mod.game_state.state_name)
    end
end