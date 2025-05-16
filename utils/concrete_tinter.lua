local ConcreteTinter = {}

-- Create a item for a tinted concrete
function ConcreteTinter.MakeItem(concrete_item, tinted_tile)
    local tinted_item = table.deepcopy(concrete_item)

    tinted_item.name = tinted_tile.name
    tinted_item.subgroup = "tinted-concrete"
    tinted_item.place_as_tile.result = tinted_tile.name
    tinted_item.icons = { {
        icon = concrete_item.icon,
        icon_mipmaps = concrete_item.icon_mipmaps or 4,
        icon_size = concrete_item.icon_size or 64,
        tint = tinted_tile.tint
    } }
    tinted_item.localised_name = tinted_tile.localised_name

    return tinted_item
end

-- Create a recipe for a tinted concrete
function ConcreteTinter.MakeRecipe(concrete_recipe, tinted_tile)
    local recipe = table.deepcopy(concrete_recipe)

    -- Alter normal recipe
    recipe.name = tinted_tile.name
    recipe.ingredients = { {
        type = "item",
        name = concrete_recipe.name,
        amount = 10
    } }
    recipe.results = { {
        type = "item",
        name = tinted_tile.name,
        amount = 10
    } }

    -- Double the time of hazard concrete because:
    -- > @sorahn: .5 since hazard concrete only paints half of it :wink:
    recipe.energy_required = 0.5

    -- Make is so we can pocket craft tinted concrete
    recipe.category = nil

    return recipe
end

-- Tint a concrete if the tile exist
function ConcreteTinter.Tint(concrete_type, color)
    -- Get the tinted tile
    local concrete_item = data.raw['item'][concrete_type]
    local concrete_tile = data.raw['tile'][concrete_type]
    local tinted_name = string.format("%s-%s", color, concrete_type)
    local tinted_tile = data.raw['tile'][tinted_name]

    -- If the tile does not exist just pass
    if (tinted_tile == nil) then return end

    -- Make tiles blueprintable
    tinted_tile.subgroup = "artificial-tiles"
    tinted_tile.can_be_part_of_blueprint = true

    -- Change tiles to be minable
    if (tinted_tile.minable == nil) then
        tinted_tile.minable = table.deepcopy(
            concrete_tile.minable
        )
    end
    tinted_tile.minable.result = tinted_tile.name


    -- Setting up item
    local tinted_item = ConcreteTinter.MakeItem(
        concrete_item,
        tinted_tile
    )
    data.raw["item"][tinted_item.name] = tinted_item

    -- Setting up recipe
    local tinted_recipe = ConcreteTinter.MakeRecipe(
        data.raw["recipe"][concrete_type],
        tinted_tile
    )
    data.raw["recipe"][tinted_recipe.name] = tinted_recipe

    -- Make the recipe available for the punny engineer
    table.insert(
        data.raw["technology"]["concrete"]["effects"],
        { type = "unlock-recipe", recipe = tinted_recipe.name }
    )
end

return ConcreteTinter
