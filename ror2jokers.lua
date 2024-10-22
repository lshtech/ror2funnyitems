--- STEAMODDED HEADER
--- MOD_NAME: ror2jokers
--- MOD_ID: ror2jokers
--- MOD_AUTHOR: [aou]
--- MOD_DESCRIPTION: jokers from Risk of Rain 2
----------------------------------------------
------------MOD CODE -------------------------


function SMODS.INIT.ror2jokers()
    local j_localization = {
        j_benthicbloom = {
            name = "Benthic Bloom",
            text = {
                "When {C:attention}Boss Blind{} is selected,",
                "destroy a random {C:attention}joker{}",
                "and create one of the",
                "next higher {C:attention}rarity{}"
            }
        },
        -- j_egocentrism2 = {
        --     name = "Egocentrism",
        --     text = {
        --         "{X:mult,C:white}X1.25{} Mult",
        --         "When {C:attention}Blind{} is selected,",
        --         "{C:green}#1# in #2#{} chance to destroy a",
        --         "random {C:attention}card{}, {C:attention}joker{}, or {C:attention}consumable{}",
        --         "and create a {C:dark_edition}negative{} {C:attention}Egocentrism{}"
        --     }
        -- },
        j_spineltonic = {
            name = "Spinel Tonic",
            text = {
                "{X:mult,C:white}X4{} Mult",
                "{C:green}#1# in #2#{} chance to create a",
                "{C:dark_edition}Tonic Affliction{} per hand played"
            }
        },
        j_tonicaffliction = {
            name = "Tonic Affliction",
            text = {
                "When {C:attention}Blind{} is selected,",
                "increase blind requirement",
                "by {X:black,C:white}X1.2{}"
            }
        },
        j_happiestmask = {
            name = "Happiest Mask",
            text = {
                "When a {C:attention}card{} is destroyed,",
                "{C:green}#1# in #2#{} chance to create a",
                "{C:dark_edition}negative{} copy of that card",
                "{C:inactive}(negative cards give +1 hand size",
                "{C:inactive}while in hand)"
            }
        },
        j_symbioticscorpion = {
            name = "Symbiotic Scorpion",
            text = {
                "Reduce {C:attention}Blind{} by {X:black,C:white}25%{}",
                "if played hand is your",
                "least played {C:attention}poker hand{}",
            }
        },
        j_gesturedrowned = {
            name = "Gesture of the Drowned",
            text = {
                "{X:mult,C:white}X3{} Mult",
                "Forces 1 {C:attention}card{} to always",
                "be selected"
            }
        }
    }
    local jokers = {
        {
            name = "Benthic Bloom", slug = "benthicbloom",
            config = {}, rarity = 3, cost = 9, 
            blueprint_compat = true, 
            eternal_compat = true
        },
        -- {
        --     name = "Egocentrism", slug = "egocentrism2",
        --     config = { Xmult = 1.25, extra = 3}, rarity = 3, cost = 6, 
        --     blueprint_compat = true, 
        --     eternal_compat = true
        -- },
        {
            name = "Spinel Tonic", slug = "spineltonic",
            config = { Xmult = 4, extra = 4}, rarity = 3, cost = 9, 
            blueprint_compat = true, 
            eternal_compat = true
        },
        {
            name = "Tonic Affliction", slug = "tonicaffliction",
            config = { extra = 1.2 }, rarity = 1, cost = 0, 
            blueprint_compat = true, 
            eternal_compat = true
        },
        {
            name = "Happiest Mask", slug = "happiestmask",
            config = { extra = 2 }, rarity = 2, cost = 7, 
            blueprint_compat = true, 
            eternal_compat = true
        },
        {
            name = "Symbiotic Scorpion", slug = "symbioticscorpion",
            config = { extra = .75 }, rarity = 2, cost = 5, 
            blueprint_compat = true, 
            eternal_compat = true
        },
        {
            name = "Gesture of the Drowned", slug = "gesturedrowned",
            config = { Xmult = 3 }, rarity = 2, cost = 5, 
            blueprint_compat = true, 
            eternal_compat = true
        }
    }
    
    for k, v in pairs(jokers) do
        SMODS.Joker:new(v.name, v.slug, v.config, {x = 0, y = 0}, j_localization["j_"..v.slug], v.rarity, v.cost, true, true, v.blueprint_compat, v.eternal_compat):register()
        SMODS.Sprite:new("j_"..v.slug, SMODS.findModByID("ror2jokers").path, "j_"..v.slug..".png", 71, 95, "asset_atli"):register()    
    end

    
    
    SMODS.Jokers.j_gesturedrowned.calculate = function(self, context) 
        if context.emplace then
            local any_forced = nil
            for k, v in ipairs(G.hand.cards) do
                if v.ability.forced_selection then
                    any_forced = true
                end
            end
            if not any_forced and #G.hand.cards > 0 then 
                G.hand:unhighlight_all()
                local forced_card = pseudorandom_element(G.hand.cards, pseudoseed('gesture'))
                forced_card.ability.forced_selection = true
                G.hand:add_to_highlighted(forced_card)
            end
        end
        if context.selling_self then
            for k, v in ipairs(G.playing_cards) do
                v.ability.forced_selection = nil
            end
        end
        if SMODS.end_calculate_context(context) then
            return {
                message = localize{type='variable',key='a_xmult',vars={self.ability.x_mult}},
                Xmult_mod = self.ability.x_mult,
            }
        end

    end
   

    SMODS.Jokers.j_symbioticscorpion.calculate = function(self, context) 
        if context.cardarea == G.jokers and context.before then
            local least = true
            local play_less_than = (G.GAME.hands[context.scoring_name].played or 0) - 1
            for k, v in pairs(G.GAME.hands) do
                if k ~= context.scoring_name and v.played < play_less_than and v.visible then
                    least = false
                end
            end
            if least then
                G.GAME.blind.chips = G.GAME.blind.chips * self.ability.extra
                G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
                return {
                    card = self,
                    message = "Reduced!",
                    colour = G.C.BLACK
                }
            end
        end
    end
    
    --negative card thingy
    local negativehandsizediff = 0
    local original_emplace = CardArea.emplace
    function CardArea:emplace(card, location, stay_flipped)
        original_emplace(self, card, location, stay_flipped)
        if G.jokers ~= nil and self == G.hand and (G.STATE == 1 or G.STATE == 6 or G.STATE == 3)   then
            if card and card.edition and card.edition.type == 'negative' then
                sendDebugMessage(tostring(G.STATE).."  this is the STATE! "..string.char(10))
                G.hand:change_size(1)
                negativehandsizediff = negativehandsizediff + 1
                sendDebugMessage("+hand size diff "..negativehandsizediff..""..string.char(10))
            end
            for _, v in pairs(G.jokers.cards) do
                if v.ability.name == "Gesture of the Drowned" then
                    v:calculate_joker({ emplace = true, emplaced_card = card })
                end
            end
        end
    end
    local original_remove_card = CardArea.remove_card
    function CardArea:remove_card(card, discarded_only)
        if self == G.hand and (G.STATE == 3 or G.STATE == 2) then
            if card and card.edition and card.edition.type == 'negative' then
                sendDebugMessage(tostring(G.STATE).."  this is the STATE! "..string.char(10))
                G.hand:change_size(-1)
                negativehandsizediff = negativehandsizediff - 1
                sendDebugMessage("-hand size diff "..negativehandsizediff..""..string.char(10))
            end
        end 
        return original_remove_card(self, card, discarded_only)
    end
    local original_defeat = Blind.defeat
    function Blind:defeat(silent)
        original_defeat(self, silent)
        sendDebugMessage("hand size changed by "..-negativehandsizediff..""..string.char(10))
        G.hand:change_size(-negativehandsizediff)
        negativehandsizediff = 0
    end
    --

    SMODS.Jokers.j_happiestmask.calculate = function(self, context)
        if context.remove_playing_cards then
            for k, v in pairs(context.removed) do
                if pseudorandom('mask') < G.GAME.probabilities.normal/self.ability.extra then
                    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                        play_sound('timpani')
                        local card = copy_card(v, nil, nil, nil, nil)
                        card:set_edition({negative = true}, true) 
                        card:add_to_deck()
                        card.playing_card = G.playing_card
                        G.hand:emplace(card)
                        return true end }))
                end
            end
        end
    end

    SMODS.Jokers.j_tonicaffliction.calculate = function(self, context) 
        if context.setting_blind and not context.blueprint and not self.getting_sliced then
            G.GAME.blind.chips = G.GAME.blind.chips * self.ability.extra
            G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
        end
    end
    
    SMODS.Jokers.j_spineltonic.calculate = function(self, context) 
        if context.after then
            if pseudorandom('tonic') < G.GAME.probabilities.normal/self.ability.extra then
                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                    play_sound('timpani')
                    local card = create_card('Joker', G.jokers, nil, nil, nil, nil,'j_tonicaffliction', nil)
                    --card.config.center.eternal_compat = true
                    card:set_eternal(true)
                    card:set_edition({negative = true}, true) 
                    card.cost = 0
                    card.sell_cost = 0
                    card:add_to_deck()
                    G.jokers:emplace(card)
                    return true end }))
            end
        end
        if SMODS.end_calculate_context(context) then
            return {
                message = localize{type='variable',key='a_xmult',vars={self.ability.x_mult}},
                Xmult_mod = self.ability.x_mult,
            }
        end
    end

    SMODS.Jokers.j_egocentrism.calculate = function(self, context) 
        if context.setting_blind and not context.blueprint and not self.getting_sliced then
            if pseudorandom('ego') < G.GAME.probabilities.normal/self.ability.extra then
                local deletables = {}
                for i = 1, #G.jokers.cards do
                    if G.jokers.cards[i].ability.name ~= 'Egocentrism' and G.jokers.cards[i].config.center.rarity ~= 4 and not G.jokers.cards[i].ability.eternal and not G.jokers.cards[i].getting_sliced then deletables[#deletables+1] = G.jokers.cards[i] end
                end
                for i =1, #G.consumeables.cards do
                    deletables[#deletables+1] = G.consumeables.cards[i] 
                end
                for i = 1, #G.playing_cards do
                    deletables[#deletables+1] = G.playing_cards[i] 
                end
                local chosen = #deletables > 0 and pseudorandom_element(deletables, pseudoseed('ego')) or nil
                if chosen and not self.getting_sliced and not chosen.ability.eternal and not chosen.getting_sliced then 
                    local sliced_card = chosen
                    sliced_card.getting_sliced = true
                    G.E_MANAGER:add_event(Event({func = function()
                        self:juice_up(0.8, 0.8)
                        sliced_card:start_dissolve({HEX("ff00ff")}, nil, 1.6)
                        play_sound('slice1', 0.96+math.random()*0.08)
                    return true end }))  
                    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                        play_sound('timpani')
                        local card = copy_card(self, nil, nil, nil, nil)
                        card:set_edition({negative = true}, true) 
                        card.cost = 0
                        card.sell_cost = 0
                        card:add_to_deck()
                        G.jokers:emplace(card)
                        return true end }))
                end
            end
        end

        if SMODS.end_calculate_context(context) then
            return {
                message = localize{type='variable',key='a_xmult',vars={self.ability.x_mult}},
                Xmult_mod = self.ability.x_mult,
            }
        end

    end

    SMODS.Jokers.j_benthicbloom.calculate = function(self, context)
        if context.setting_blind and not context.blueprint and context.blind.boss and not self.getting_sliced then
            local deletable_jokers = {}
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] ~= self and G.jokers.cards[i].config.center.rarity ~= 4 and not G.jokers.cards[i].ability.eternal and not G.jokers.cards[i].getting_sliced then deletable_jokers[#deletable_jokers+1] = G.jokers.cards[i] end
            end
            local chosen_joker = #deletable_jokers > 0 and pseudorandom_element(deletable_jokers, pseudoseed('benthic')) or nil
           
            if chosen_joker and not self.getting_sliced and not chosen_joker.ability.eternal and not chosen_joker.getting_sliced then 
                local sliced_card = chosen_joker
                sliced_card.getting_sliced = true
                G.GAME.joker_buffer = G.GAME.joker_buffer - 1
                G.E_MANAGER:add_event(Event({func = function()
                    G.GAME.joker_buffer = 0
                    self:juice_up(0.8, 0.8)
                    sliced_card:start_dissolve({HEX("ff00ff")}, nil, 1.6)
                    play_sound('slice1', 0.96+math.random()*0.08)
                return true end }))     

                local rarity = chosen_joker.config.center.rarity == 3 and 4 or chosen_joker.config.center.rarity - .25
                
                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                    play_sound('timpani')
                    local card = create_card('Joker', G.jokers, rarity > 3, rarity, nil, nil, nil, 'benthic')
                    card:add_to_deck()
                    G.jokers:emplace(card)
                    return true end }))
            end
        end
    end

    SMODS.Jokers.j_egocentrism.loc_def = function(self)
        return { G.GAME.probabilities.normal, 3 }
    end
    SMODS.Jokers.j_spineltonic.loc_def = function(self)
        return { G.GAME.probabilities.normal, 4 }
    end
    SMODS.Jokers.j_happiestmask.loc_def = function(self)
        return { G.GAME.probabilities.normal, 2 }
    end
    

    --remove tonic affliction from pools. thanks myst!
    local original_inject_jokers = SMODS.injectJokers
    function SMODS.injectJokers() 
        original_inject_jokers()
        if G.P_CENTERS['j_tonicaffliction'] then
            G.P_CENTERS['j_tonicaffliction'].yes_pool_flag = "never"
        end
    end
end

----------------------------------------------
------------MOD CODE END----------------------
