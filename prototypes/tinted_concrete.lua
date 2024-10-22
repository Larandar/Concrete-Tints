local ConcreteTinter = require('utils.concrete_tinter')

local tile_types = { "refined-concrete" }

-- Revert of style on mining
local mining_revert_style = settings.startup["concrete-tints-revert-on-mining"]
    .value
local mining_revert_tinted = mining_revert_style == "always" or
    mining_revert_style == "tinted-only"
local mining_revert_hazard = mining_revert_style == "always" or
    mining_revert_style == "hazard-only"

data:extend({
    {
        type = "item-subgroup",
        name = "tinted-concrete",
        group = "logistics",
        order = "i[tinted-concrete]"
    }
})

for k, _ in pairs(data.raw['tile']) do
    for _, tile_type in ipairs(tile_types) do
        -- Does it end int tile_type
        if k:sub(-tile_type:len(), -1) == tile_type then
            ConcreteTinter.Tint(tile_type, k:sub(1, -tile_type:len() - 2))
            if mining_revert_tinted then
                ConcreteTinter.ChangeMiningResult(k, tile_type)
            end
        end
    end
end

if mining_revert_hazard then
    ConcreteTinter.ChangeMiningResult("hazard-concrete-left", "concrete")
    ConcreteTinter.ChangeMiningResult("hazard-concrete-right", "concrete")
    ConcreteTinter.ChangeMiningResult("refined-hazard-concrete-left",
        "refined-concrete")
    ConcreteTinter.ChangeMiningResult("refined-hazard-concrete-right",
        "refined-concrete")
end
