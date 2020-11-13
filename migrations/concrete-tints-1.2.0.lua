-- Enable recipes on existing maps with already researched
for _, force in pairs(game.forces) do
    if force.technologies["concrete"].researched then
        for _, recipe in pairs(force.recipes) do
            if recipe.name:match("concrete") then
                recipe.enabled = true
            end
        end
    end
end
