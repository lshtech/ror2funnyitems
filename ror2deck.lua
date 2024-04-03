--- STEAMODDED HEADER
--- MOD_NAME: ror2deck
--- MOD_ID: ror2deck
--- MOD_AUTHOR: [aou]
--- MOD_DESCRIPTION: Adds the funny items from Risk of Rain 2
----------------------------------------------
------------MOD CODE -------------------------


function SMODS.INIT.ror2deck()
    local loc_def = {
        ["name"]="Happiest Deck",
        ["text"]={
            [1]="Start with Happiest Mask",
            [2]="and an Immolate"
        },
    }

    local happiest = SMODS.Deck:new("Happiest Deck", "happiest", {happiest = true}, {x = 6, y = 2}, loc_def)
    happiest:register()

    local Backapply_to_runRef = Back.apply_to_run
    function Back.apply_to_run(arg_56_0)
        Backapply_to_runRef(arg_56_0)
        if arg_56_0.effect.config.happiest then
            G.E_MANAGER:add_event(Event({
                func = (function()
                    
                    local card = create_card('Spectral', G.consumeables, nil, nil, nil, nil, 'c_immolate', 'w')
                    card:add_to_deck()
                    G.consumeables:emplace(card)
                    
                    local card = create_card('Joker', G.jokers, nil, nil, nil, nil, 'j_happiestmask', 'ww')
                    card:set_eternal(true)
                    card:add_to_deck()
                    G.jokers:emplace(card) 

                    return true end)}))
        end
    end
end

----------------------------------------------
------------MOD CODE END----------------------
