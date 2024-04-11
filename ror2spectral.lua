--- STEAMODDED HEADER
--- MOD_NAME: ror2spectral
--- MOD_ID: ror2spectral
--- MOD_AUTHOR: [aou]
--- MOD_DESCRIPTION: spectrals from Risk of Rain 2
----------------------------------------------
------------MOD CODE -------------------------


function SMODS.INIT.ror2spectral()
    local c_localization = {
        c_mountainshrine = {
            name = "Shrine of the Mountain",
            text = {
                "During a {C:attention}Boss Blind{}, increase",
                "chip requirement by {X:black,C:white}X2{}, but recieve",
                "an {C:attention}Economy Tag{}"
            }
        },
        c_ordershrine = {
            name = "Shrine of Order",
            text = {
                "All jokers of the same {C:attention}rarity{} will be",
                "converted to a random owned joker",
                "in that rarity"
            }
        }
    }
    local spectrals = {
        {
            name = "Shrine of the Mountain", slug = "mountainshrine",
            config = {},
        },
        {
            name = "Shrine of Order", slug = "ordershrine",
            config = {},
        }
    }
    
    
    for k, v in pairs(spectrals) do
        SMODS.Spectral:new(v.name, v.slug, v.config, {x = 0, y = 0}, c_localization["c_"..v.slug], 4, true, true):register()
        SMODS.Sprite:new("c_"..v.slug, SMODS.findModByID("ror2spectral").path, "c_"..v.slug..".png", 71, 95, "asset_atli"):register()    
    end


    function SMODS.Spectrals.c_mountainshrine.use(card, area, copier)
        if G.STATE == 6 then
            G.GAME.blind.chips = G.GAME.blind.chips * 2
            G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                add_tag(Tag('tag_economy'))
                play_sound('generic1', 0.6 + math.random()*0.1, 0.8)
                play_sound('holo1', 1.1 + math.random()*0.1, 0.4)
                card:juice_up(0.3, 0.5)
                return true end }))
            delay(0.6)
        else
            --sendDebugMessage(tostring(G.STATE).."  this is the STATE! "..string.char(10))
            local card = create_card('Spectral', G.consumeables, nil, nil, nil, nil, 'c_mountainshrine', 'deck')
            card:add_to_deck()
            G.consumeables:emplace(card)
        end
    end
    function SMODS.Spectrals.c_mountainshrine.can_use(card)
        if (G.STATE == G.STATES.SELECTING_HAND and G.GAME.blind.boss) or (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK)  then return true end
    end
        
    function SMODS.Spectrals.c_ordershrine.use(card, area, copier)
        local rarities = {}
        for i = 1, #G.jokers.cards do
            if not table.contains(rarities, G.jokers.cards[i].config.center.rarity) then 
                rarities[#rarities+1] = G.jokers.cards[i].config.center.rarity 
            end
        end
        
        for i = 1, #rarities do
            local jokersofthatrarity = {}
            for j = 1, #G.jokers.cards do
                if G.jokers.cards[j].config.center.rarity == rarities[i] then
                    jokersofthatrarity[#jokersofthatrarity + 1] = G.jokers.cards[j]
                end
            end
            local chosen_joker = jokersofthatrarity[math.random(#jokersofthatrarity)]
            rarities[i] = chosen_joker
        end

        for j = 1, #G.jokers.cards do
            for i = 1, #rarities do
                if G.jokers.cards[j].config.center.rarity == rarities[i].config.center.rarity then
                    local eternaljoker = nil
                    if G.jokers.cards[j].ability.eternal then eternaljoker = G.jokers.cards[j] end
                    local sliced_card = G.jokers.cards[j]
                    sliced_card.getting_sliced = true
                    G.GAME.joker_buffer = G.GAME.joker_buffer - 1
                    G.E_MANAGER:add_event(Event({func = function()
                        G.GAME.joker_buffer = 0
                        sliced_card:start_dissolve({HEX("ff00ff")}, nil, 1.6)
                    return true end }))
                    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.0, func = function()
                        local card = copy_card(eternaljoker or rarities[i], nil, nil, nil, nil)
                        card:add_to_deck()
                        G.jokers:emplace(card)
                    return true end }))
                end
            end
        end
        play_sound('timpani')
    end
    function SMODS.Spectrals.c_ordershrine.can_use(card)
        if #G.jokers.cards > 0 then return true end
    end

    function table.contains(table, element)
        for _, value in pairs(table) do
            if value == element then return true end
        end
        return false
    end
end

----------------------------------------------
------------MOD CODE END----------------------
