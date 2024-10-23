--- STEAMODDED HEADER
--- MOD_NAME: ror2deck
--- MOD_ID: ror2deck
--- MOD_AUTHOR: [aou, elbe]
--- MOD_DESCRIPTION: decks!
--- PREFIX: ror2d
----------------------------------------------
------------MOD CODE -------------------------

SMODS.Back {
    key = 'happiest',
    loc_txt = {
        name = "Happiest Deck",
        text = {
            "Start with {C:attention}Happiest Mask{}",
            "and an {C:attention}Immolate{}"
        }
    },
    pos = { x = 5, y = 2 },
    config = {},
    apply = function(self)
        G.E_MANAGER:add_event(Event({
            func = (function()
            local card = create_card('Spectral', G.consumeables, nil, nil, nil, nil, 'c_immolate', 'w')
            card:add_to_deck()
            G.consumeables:emplace(card)

            if (SMODS.Mods["RiskofJesters"] or {}).can_load then
                card = create_card('Joker', G.jokers, nil, nil, nil, nil, 'j_happiest_mask', 'ww')
            else
                card = create_card('Joker', G.jokers, nil, nil, nil, nil, 'j_ror2_happiestmask', 'ww')
            end
            --card:set_eternal(true)
            card:add_to_deck()
            G.jokers:emplace(card)
        return true end)}))
    end,
}
SMODS.Back {
    key = 'order',
    loc_txt = {
        name = "Deck of Order",
        text = {
            "Start with {C:attention}Riff Raff{}",
            "and a {C:attention}Shrine of Order{}"
        }
    },
    pos = { x = 6, y = 1 },
    config = {},
    apply = function(self)
        G.E_MANAGER:add_event(Event({
            func = (function()
            local card = create_card('Spectral', G.consumeables, nil, nil, nil, nil, 'c_ror2s_ordershrine', 'w')
            card:add_to_deck()
            G.consumeables:emplace(card)

            card = create_card('Joker', G.jokers, nil, nil, nil, nil, 'j_riff_raff', 'ww')
            card:add_to_deck()
            G.jokers:emplace(card)
        return true end)}))
    end,
}
SMODS.Back {
    key = 'bloom',
    loc_txt = {
        name = "Bloom Deck",
        text = {
            "Start with {C:attention}Benthic Bloom{}"
        }
    },
    pos = { x = 4, y = 2 },
    config = {},
    apply = function(self)
        G.E_MANAGER:add_event(Event({
            func = (function()
                local card = nil
            if (SMODS.Mods["RiskofJesters"] or {}).can_load then
                card = create_card('Joker', G.jokers, nil, nil, nil, nil, 'j_benthic', 'ww')
            else
                card = create_card('Joker', G.jokers, nil, nil, nil, nil, 'j_ror2_benthicbloom', 'ww')
            end
           -- card:set_eternal(true)
            card:add_to_deck()
            G.jokers:emplace(card)
        return true end)}))
    end,
}

----------------------------------------------
------------MOD CODE END----------------------
