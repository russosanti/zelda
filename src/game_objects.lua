--[[
    CS50 2D
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

GAME_OBJECT_DEFS = {
    ['switch'] = {
        type = 'switch',
        texture = 'switches',
        frame = 2,
        width = 16,
        height = 16,
        solid = false,
        defaultState = 'unpressed',
        states = {
            ['unpressed'] = {
                frame = 2
            },
            ['pressed'] = {
                frame = 1
            }
        }
    },
    ['heart'] = {
        type = 'heart',
        texture = 'hearts',
        frame = 5,
        width = 8,
        height = 8,
        scale = .5,
        solid = false,
        consumable = true,
        defaultState = 'full',
        states = {
            ['full'] = {frame = 5}
        }
    },
    ['pot'] = {
        type = 'pot',
        texture = 'tiles',
        frame = 14,
        width = 16,
        height = 16,
        solid = true,
        defaultState = 'default',
        states = {
            ['default'] = {frame = 14}
        },
        maxDistance = 4 * TILE_SIZE
    }
}