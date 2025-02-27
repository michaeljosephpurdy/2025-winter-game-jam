---@meta
---Components are colletions of data that make up entities

---@class CameraActor
---@field camera_actor _CameraActor
---@class _CameraActor
---@field is_active boolean

---@class AutoWalk
---@field auto_walk boolean
---@class Gravity
---@field gravity _Gravity
---@class _Gravity
---@field disabled? boolean
---@field on_ground? boolean

---@class OldPosition
---@field old_position Vector.lua
---@class Position
---@field position Vector.lua
---@class FuturePosition
---@field future_position Vector.lua
---@class DeltaPosition
---@field delta_position Vector.lua
---@class Velocity
---@field velocity Vector.lua

---@class Collidable
---@field collidable _Collidable
---@class _Collidable
---@field width number
---@field height number
---@field filter? fun(self: Entity, other: Entity)
---@field is_solid? boolean
---@field is_tile? boolean
---@field detection? boolean
---@field on_ground? boolean
---@field left_wall? boolean
---@field right_wall? boolean
---@field on_collide? function

---@class LinkedLevel
---@field linked_level_id string

---@class Movable
---@field movable _Movable
---@class _Movable
---@field paused? boolean
---@field is_moving boolean
---@field last_direction 'forward' | 'backward'
---@field move_forward boolean
---@field move_backward boolean
---@field speed number
---@field acceleration number
---@field max_speed number
---@field current_max_speed? number
---@field friction? number

---@class Drawable
---@field drawable _Drawable
---@class _Drawable
---@field z_index? number
---@field rotation? number
---@field sprite? love.Image
---@field animation? {}
---@field flip? boolean
---@field sprite_offset? Vector.lua
---@field rotation_offset? Vector.lua
---@field hidden? boolean
---@field color? { r: number, g: number, b: number }
---@field width? number
---@field height? number

---@class PlayerSpawn
---@field player_spawn boolean

---@class Player
---@field player _Player
---@class _Player
---@field is_active boolean

---@class Trigger
---@field trigger _Trigger
---@class _Trigger
---@field triggered? boolean

---@class Event
---@field event _Event
---@class _Event
---@field load_tile_map? boolean
---@field ldtk_level_name? string
---@field key_press? boolean
---@field key_release? boolean
---@field keycode? string
---@field screen_resize? boolean
---@field width? number
---@field height? number

---@class Text
---@field text string

---@class ShortLived
---@field time_to_live number

---@class ScreenTransitionEvent
---@field screen_transition_event _ScreenTransitionEvent
---@class _ScreenTransitionEvent
---@field transition_time number
---@field progress? number
---@field fade_in? boolean
---@field fade_out? boolean
---@field level_to_load? string

---@class Animation
---@field animation _Animation
---@class _Animation
---@field data string
---@field image love.Image
---@field tags string[]
---@field current_tag string
---@field animation {}
---
---@class LevelExit
---@field is_level_exit boolean
---@field linked_level_id? string
---
---@class Killer
---@field kills_player boolean
---
---
---
---GO UPDATE entity-factory EntityTypes
---@alias ActionType
---|'JUMP'
---|'LONG_JUMP'
---|'WAIT'
---|'DRILL'
---@class Action
---@field action ActionType
