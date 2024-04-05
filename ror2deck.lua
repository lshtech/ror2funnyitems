--- STEAMODDED HEADER
--- MOD_NAME: ror2deck
--- MOD_ID: ror2deck
--- MOD_AUTHOR: [aou]
--- MOD_DESCRIPTION: decks!
----------------------------------------------
------------MOD CODE -------------------------


function SMODS.INIT.ror2deck()
    local happiest_def = {
        ["name"]="Happiest Deck",
        ["text"]={
            [1]="Start with an",
            [2]="{C:attention}Eternal Happiest Mask{}",
            [3]="and an {C:attention}Immolate{}"
        },
    }
    local order_def = {
        ["name"]="Deck of Order",
        ["text"]={
            [1]="Start with {C:attention}Riff Raff{}",
            [2]="and a {C:attention}Shrine of Order{}"
        },
    }
    local bloom_def = {
        ["name"]="Bloom Deck",
        ["text"]={
            [1]="Start with an",
            [2]="{C:attention}Eternal Benthic Bloom{}"
        },
    }
    local happiest = SMODS.Deck:new("Happiest Deck", "happiest", {happiest = true}, {x = 5, y = 2}, happiest_def)
    happiest:register()
    local order = SMODS.Deck:new("Deck of Order", "order", {order = true}, {x = 6, y = 1}, order_def)
    order:register()
    local bloom = SMODS.Deck:new("Bloom Deck", "bloom", {bloom = true}, {x = 4, y = 2}, bloom_def)
    bloom:register()

    local Backapply_to_runRef = Back.apply_to_run
    function Back.apply_to_run(self)
        Backapply_to_runRef(self)
        if self.effect.config.happiest then
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
        if self.effect.config.order then
            G.E_MANAGER:add_event(Event({
                func = (function()
                local card = create_card('Spectral', G.consumeables, nil, nil, nil, nil, 'c_ordershrine', 'w')
                card:add_to_deck()
                G.consumeables:emplace(card)
                
                local card = create_card('Joker', G.jokers, nil, nil, nil, nil, 'j_riff_raff', 'ww')
                card:add_to_deck()
                G.jokers:emplace(card) 
            return true end)}))
        end
        if self.effect.config.bloom then
            G.E_MANAGER:add_event(Event({
                func = (function()
                local card = create_card('Joker', G.jokers, nil, nil, nil, nil, 'j_benthicbloom', 'ww')
                card:set_eternal(true)
                card:add_to_deck()
                G.jokers:emplace(card) 
            return true end)}))
        end
    end
end

----------------------------------------------
------------MOD CODE END----------------------
