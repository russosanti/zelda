# Zelda

A top-down action-adventure game inspired by The Legend of Zelda, developed in Lua using LÖVE2D.

## Overview

This project extends the dungeon crawler game Zelda.

## Features

## Heart Drops

Implemented a health recovery system through enemy drops.

### Heart Spawn Logic

- Enemies have a 20% chance of dropping a heart when defeated
- Hearts are only spawned if the player is not already at full health

This prevents unnecessary item generation while rewarding players who take damage.

## Pot System

Added interactive pots that can be carried and thrown throughout the dungeon.

### Pot Generation

- Each room spawns a random number of pots
- Between 0 and 3 pots can appear per room

### Pot Collision

Pots are fully collidable objects:

- Players cannot walk through them
- Enemies cannot pass through them

This adds environmental obstacles and positioning strategies.

### Carry and Throw Mechanics

Players can:

- Press **F** to pick up a pot
- Press **Space** to throw the carried pot

While carrying a pot:

- Sword attacks are disabled
- The player enters dedicated carrying states

### Carrying States

Implemented three new player states:

- `PlayerLiftPotState`
- `PlayerCarryPotIdleState`
- `PlayerCarryPotState`

These states handle lifting animations, idle behavior, and movement while carrying objects.

### Cross-Room Carrying

While being carried:

- The pot is owned by the player
- It is temporarily removed from the room object list

This allows the player to carry pots between rooms.

The room transition stencil was expanded to support objects being carried through transitions.

### Pot Destruction

Thrown pots break on impact.

Implemented:

- Break animations
- Particle effects
- Visual feedback similar to the brick destruction effects used in the Breakout project

### Design Notes

The pot functionality was implemented by extending the existing `GameObject` system.

In retrospect, creating a dedicated `Pot` class would likely have been a cleaner design choice. However, the feature was implemented without a larger refactor in order to preserve the existing architecture.

## Boomerang System

Added a collectible boomerang weapon and inventory system.

### Boomerang Chest Generation

The dungeon generator was modified to:

- Place a special chest containing the boomerang
- Select a random room within the dungeon

The starting room is excluded to prevent players from immediately obtaining the item.

### Dungeon Map

Added a dungeon map overlay displaying:

- Room layout
- Current room position
- Room highlighting for navigation

This helps players locate unexplored areas while searching for the boomerang.

### Inventory System

After collecting the boomerang:

- An inventory icon is displayed on the UI
- The item remains permanently available to the player

### Boomerang Class

Implemented a dedicated `Boomerang` class rather than extending `GameObject`.

This provided a cleaner design than the earlier pot implementation.

### Throw and Return Mechanics

When thrown:

- The boomerang leaves the player's inventory
- It becomes an active object in the current room
- It travels outward and automatically returns to the player

The return behavior is handled inside the boomerang update logic.

### Room Transition Handling

Special handling was added for room transitions.

When a room transition begins:

- The game checks whether the boomerang is currently active in the room
- If present, it is automatically returned to the player
- The room transition then proceeds normally

This prevents the boomerang from becoming orphaned between rooms.

## Technologies

- Lua
- LÖVE2D


## Future Possible Improvements

- Additional dungeon items
- Bomb mechanics
- Enemy-specific weaknesses
- Boss encounters
- Larger dungeon layouts
- Save and inventory persistence
- Additional collectible weapons