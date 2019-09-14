--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  

Quantum.Item = {}
Quantum.Items = {}

function Quantum.Item.Create( id, args )
    local item = {
        name = args.name, -- items name
        desc = args.desc, -- items description
        icon = args.icon, -- items icon
        stack = args.stack, -- items max stack size
        soulbound = args.soulbound, -- if item could be dropped/traded to other players
        rarity = args.rarity, -- rarity of the item
        usefunction = args.usefunction, -- use function 
        consumefunction = args.consumefunction, --consume function
        equipfunction = args.equipfunction -- equip function
    }
end