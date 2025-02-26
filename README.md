# 2025 Winter Game Jam

## Theme

Control the Environment, Not the Player

## Idea

Auto-walking platformer where you need to get the player to the exit, by placing down `actions` for the player to take on the map.

Each level has a different set of actions available to players.

## Flow

Game is either 'PAUSE' or 'PLAY'.
Each map starts in _PAUSE_ state.

### When in _PAUSE_ state

Players can place `actions` into the environment.
All non-placed actions are displayed on UI.

Entities do not move.

Players can hit _spacebar_ to switch to _PLAY_ state.

### When in _PLAY_ state

Camera follows player character

Entities move

Actions cannot be placed

Players can hit _spacebar_ to switch to _PAUSE_ state.

## Implementation


---

## TODO

### Actions

* long jump
* wait
* drill
