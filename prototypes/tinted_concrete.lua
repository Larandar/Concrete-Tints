local ConcreteTinter = require('utils.concrete_tinter')

local tile_types = {"refined-concrete"}

for k, _ in pairs(data.raw['tile']) do
    for _, tile_type in ipairs(tile_types) do
        -- Does it end int tile_type
        if k:sub(-tile_type:len(), -1) == tile_type then
            ConcreteTinter.Tint(
                tile_type,
                k:sub(1, -tile_type:len()-2)
            )
        end
    end
end
