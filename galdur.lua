--- STEAMODDED HEADER
--- MOD_NAME: Galdur
--- MOD_ID: galdur
--- PREFIX: galdur
--- MOD_AUTHOR: [Eremel_]
--- MOD_DESCRIPTION: A modification to the run setup screen.
--- BADGE_COLOUR: E16036
--- VERSION: 0.1
--- PRIORITY: 1


-- SMODS.AltTexture({ -- Arcane
--     palette = true,
--     key = "galdur1",
--     old_colours = {"4f6367","a58547","dab772","ffe5b4","ffffff"},
--     new_colours = {"2e294e","8661c1","be97c6","efbcd5","4b5267"},
--     type = "Tarot",
--     name = "Galdur"
-- })

-- SMODS.AltTexture({ -- Nature
--     palette = true,
--     key = "galdur2",
--     old_colours = {"4f6367","a58547","dab772","ffe5b4","ffffff"},
--     new_colours = {"2e2c2f","475b63","729b79","bacdb0","f3e8ee"},
--     type = "Tarot",
--     name = "Galdur Alt"
-- })

-- SMODS.AltTexture({ -- Terracotta
--     palette = true,
--     key = "galdur3",
--     old_colours = {"4f6367","a58547","dab772","ffe5b4","ffffff"},
--     new_colours = {"6d6875","b5838d","e5989b","ffb4a2","ffcdb2"},
--     type = "Tarot",
--     name = "Galdur 3"
-- })

-- SMODS.AltTexture({ -- Orange + Blue
--     palette = true,
--     key = "galdur_spec",
--     new_colours = create_colours('Spectral', {'f58506', '0676f5'}),
--     type = "Spectral",
--     name = "Galdur"
-- })

-- SMODS.AltTexture({ -- Underground
--     palette = true,
--     key = "galdur_planet",
--     old_colours = {"4f6367","5b9baa","84c5d2","dff5fc","ffffff"},
--     new_colours = {"240750","344c64","577b8d","57a6a1","ffffff"},
--     type = "Planet",
--     name = "Galdur"
-- })

-- SMODS.AltTexture({
--     palette = true,
--     key = "galdur_suits",
--     old_colours = {"235955","3c4368","f06b3f","f03464"},
--     new_colours = {"3496c7","8234c7","96c734","c7bd34"},
--     suits = {
--         Clubs = "3496c7",
--         Spades = "8234c7",
--         Diamonds = "96c734",
--         Hearts = "c7bd34"
--     },
--     type = "Suit",
--     name = "Galdur"
-- })
-- SMODS.Atlas({
--     key = "galdur_vouchers_atlas",
--     path = "galdur_vouchers.png",
--     px = G.ASSET_ATLAS["Voucher"].px,
--     py = G.ASSET_ATLAS["Voucher"].py
-- })
-- SMODS.AltTexture({
--     texture = true,
--     key = "galdur_vouchers",
--     atlas_key = "balloon_galdur_vouchers_atlas",
--     type = "Voucher",
--     name = "Galdur"
-- })

-- SMODS.Atlas({
--     key = "galdur_boosters_atlas",
--     path = "galdur_boosters.png",
--     px = G.ASSET_ATLAS["Booster"].px,
--     py = G.ASSET_ATLAS["Booster"].py
-- })
-- SMODS.AltTexture({
--     texture = true,
--     key = "galdur_boosters",
--     atlas_key = "balloon_galdur_boosters_atlas",
--     type = "Booster",
--     name = "Galdur"
-- })

Galdur = {}
Galdur.run_setup = {}
Galdur.run_setup.choices = {
    deck = nil,
    stake = nil,
    seed = ""
}
Galdur.run_setup.deck_select_areas = {}
Galdur.run_setup.current_page = 1
Galdur.run_setup.pages = {}
Galdur.run_setup.selected_deck_height = 52
Galdur.use = true
Galdur.animation = true
Galdur.hover_index = 0
Galdur.keyboard = false

SMODS.Atlas({
    key = 'locked_stake',
    path = 'locked_stake.png',
    px = 29,
    py = 29
})

local card_stop_hover = Card.stop_hover
function Card:stop_hover()
    if self.params.stake_chip then
        Galdur.hover_index = 0
    end
    card_stop_hover(self)
end

local card_hover_ref = Card.hover
function Card:hover()
    if self.deck_select_position and (not self.states.drag.is or G.CONTROLLER.HID.touch) and not self.no_ui and not G.debug_tooltip_toggle then
        self:juice_up(0.05, 0.03)
        play_sound('paper1', math.random()*0.2 + 0.9, 0.35)
        if self.children.alert and not self.config.center.alerted then
            self.config.center.alerted = true
            G:save_progress()
        end

        local back = Back(self.config.center)

        self.config.h_popup = {n=G.UIT.C, config={align = "cm", minh = 1.7, r = 0.1, colour = G.C.L_BLACK, padding = 0.1, outline=1}, nodes={
            {n=G.UIT.R, config={align = "cm", r = 0.1, minw = 3, maxw = 4, minh = 0.6}, nodes={
              {n=G.UIT.O, config={object = UIBox{definition = {n=G.UIT.ROOT, config={align = "cm", colour = G.C.CLEAR}, nodes={
                  {n=G.UIT.O, config={object = DynaText({string = back:get_name(),maxw = 4, colours = {G.C.WHITE}, shadow = true, bump = true, scale = 0.5, pop_in = 0, silent = true})}},
                }},
                config = {offset = {x=0,y=0}, align = 'cm', parent = e}
              }}},
            }},
            {n=G.UIT.R, config={align = "cm", colour = G.C.WHITE, minh = 1.5, maxh = 3, minw = 3, maxw = 4, r = 0.1}, nodes={
                {n=G.UIT.O, config={object = UIBox{definition = back:generate_UI(), config = {offset = {x=0,y=0}}}}}
            }}       
          }}
        self.config.h_popup_config = self:align_h_popup()

        Node.hover(self)
    elseif self.params.stake_chip and (not self.states.drag.is or G.CONTROLLER.HID.touch) and not self.no_ui and not G.debug_tooltip_toggle then
        Galdur.hover_index = self.params.hover or 0
        local stake_sprite = get_stake_sprite(self.params.stake)
        self:juice_up(0.05, 0.03)
        play_sound('paper1', math.random()*0.2 + 0.9, 0.35)


        self.config.h_popup = {n=G.UIT.ROOT, config={align = "cm", colour = G.C.BLACK, r = 0.1, padding = 0.1, outline = 1}, nodes={
            {n=G.UIT.C, config={align = "cm", padding = 0}, nodes={
                {n=G.UIT.T, config={text = localize('k_stake'), scale = 0.4, colour = G.C.L_BLACK, vert = true}}
            }},
            {n=G.UIT.C, config={align = "cm", padding = 0.1}, nodes={
                {n=G.UIT.C, config={align = "cm", padding = 0}, nodes={
                    {n=G.UIT.O, config={colour = G.C.BLUE, object = stake_sprite, hover = true, can_collide = false}},
                }},
                G.UIDEF.stake_description(self.params.stake)
            }}
        }}
        if self.params.stake_chip_locked then
            self.config.h_popup = {n=G.UIT.ROOT, config={align = "cm", colour = G.C.BLACK, r = 0.1, padding = 0.1, outline = 1}, nodes={
                {n=G.UIT.C, config={align = "cm", padding = 0.05, r = 0.1, colour = G.C.L_BLACK}, nodes={
                    {n=G.UIT.R, config={align = "cm", padding = 0}, nodes={
                      {n=G.UIT.T, config={text = localize{type = 'name_text', key = G.P_CENTER_POOLS.Stake[self.params.stake].key, set = 'Stake'}, scale = 0.35, colour = G.C.WHITE}}
                    }},
                    {n=G.UIT.R, config={align = "cm", padding = 0.03, colour = G.C.WHITE, r = 0.1, minh = 1, minw = 3.5}, nodes=
                        create_stake_unlock_message(G.P_CENTER_POOLS.Stake[self.params.stake])
                    }
                  }}
            }}
        end   
        self.config.h_popup_config = self:align_h_popup()
        Node.hover(self)
    else
       card_hover_ref(self) 
    end
end

local card_click_ref = Card.click
function Card:click() 
    if self.deck_select_position and self.config.center.unlocked then
        Galdur.run_setup.selected_deck_from = self.area.config.index
        Galdur.run_setup.choices.deck = Back(self.config.center)
        Galdur.run_setup.choices.stake = get_deck_win_stake(Galdur.run_setup.choices.deck.effect.center.key)+1
        populate_deck_preview(Galdur.run_setup.choices.deck)

        local texts = split_string_2(Galdur.run_setup.choices.deck.loc_name)
        local text = G.OVERLAY_MENU:get_UIE_by_ID('selected_deck_name')
        text.config.text = texts[1]
        text.config.scale = 0.7/math.max(1,string.len(texts[1])/8)
        text.UIBox:recalculate()
        text = G.OVERLAY_MENU:get_UIE_by_ID('selected_deck_name_2')
        text.config.text = texts[2]
        text.config.scale = 0.75/math.max(1,string.len(texts[2])/8)
        text.UIBox:recalculate()
    elseif self.params.stake_chip and not self.params.stake_chip_locked then
        Galdur.run_setup.choices.stake = self.params.stake
        populate_chip_tower(self.params.stake)
    else
        card_click_ref(self)
    end
end

function generate_deck_card_areas()
    if Galdur.run_setup.deck_select_areas then
        for i=1, #Galdur.run_setup.deck_select_areas do
            for j=1, #G.I.CARDAREA do
                if Galdur.run_setup.deck_select_areas[i] == G.I.CARDAREA[j] then
                    table.remove(G.I.CARDAREA, j)
                    Galdur.run_setup.deck_select_areas[i] = nil
                end
            end
        end
    end
    Galdur.run_setup.deck_select_areas = {}
    for i=1, 12 do
        Galdur.run_setup.deck_select_areas[i] = CardArea(G.ROOM.T.x + 0.2*G.ROOM.T.w/2,G.ROOM.T.h, G.CARD_W, G.CARD_H, 
        {card_limit = 5, type = 'deck', highlight_limit = 0, deck_height = 0.75, thin_draw = 1, deck_select = true, index = i})
    end
end

function generate_deck_card_areas_ui()
    local deck_ui_element = {}
    local count = 1
    for i=1, 2 do
        local row = {n = G.UIT.R, config = {colour = G.C.LIGHT}, nodes = {}}
        for j=1, 6 do
            if count > #G.P_CENTER_POOLS.Back then return end
            table.insert(row.nodes, {n = G.UIT.O, config = {object = Galdur.run_setup.deck_select_areas[count], r = 0.1, id = "deck_select_"..count, outline_colour = G.C.YELLOW}})
            count = count + 1
        end
        table.insert(deck_ui_element, row)
    end

    populate_deck_card_areas(1)

    return {n=G.UIT.R, config={align = "cm", minh = 3.3, minw = 5, colour = G.C.BLACK, padding = 0.15, r = 0.1, emboss = 0.05}, nodes=deck_ui_element}
end

function populate_deck_card_areas(page)
    local count = 1 + (page - 1) * 12
    for i=1, 12 do
        if count > #G.P_CENTER_POOLS.Back then return end
        local card_number = 10
        for index = 1, card_number do
            local card = Card(Galdur.run_setup.deck_select_areas[i].T.x,Galdur.run_setup.deck_select_areas[i].T.y, G.CARD_W, G.CARD_H, G.P_CENTER_POOLS.Back[count], G.P_CENTER_POOLS.Back[count],
                {viewed_back = Back(G.P_CENTER_POOLS.Back[count]), deck_select = true})
            card.sprite_facing = 'back'
            card.facing = 'back'
            card.children.back = Sprite(card.T.x, card.T.y, card.T.w, card.T.h, G.ASSET_ATLAS[G.P_CENTER_POOLS.Back[count].atlas], G.P_CENTER_POOLS.Back[count].unlocked and G.P_CENTER_POOLS.Back[count].pos or {x = 4, y = 0})
            card.children.back.states.hover = card.states.hover
            card.children.back.states.click = card.states.click
            card.children.back.states.drag = card.states.drag
            card.children.back.states.collide.can = false
            card.children.back:set_role({major = card, role_type = 'Glued', draw_major = card})
            if not Galdur.run_setup.deck_select_areas[i].cards then Galdur.run_setup.deck_select_areas[i].cards = {} end
            Galdur.run_setup.deck_select_areas[i]:emplace(card)
            if index == card_number then
                G.sticker_card = card
                card.sticker = get_deck_win_sticker(G.P_CENTER_POOLS.Back[count])
                card.deck_select_position = {page = page, count = i}
            end
        end
        count = count + 1
    end
end


-- Stake Selection Functions
function generate_stake_card_areas()
    if Galdur.run_setup.stake_select_areas then
        for i=1, #Galdur.run_setup.stake_select_areas do
            for j=1, #G.I.CARDAREA do
                if Galdur.run_setup.stake_select_areas[i] == G.I.CARDAREA[j] then
                    table.remove(G.I.CARDAREA, j)
                    Galdur.run_setup.stake_select_areas[i] = nil
                end
            end
        end
    end
    Galdur.run_setup.stake_select_areas = {}
    for i=1, 24 do
        Galdur.run_setup.stake_select_areas[i] = CardArea(G.ROOM.T.w * 0.116, G.ROOM.T.h * 0.209, 3.4*14/41, 3.4*14/41, 
        {card_limit = 1, type = 'deck', highlight_limit = 0, stake_select = true})
    end
end

function generate_stake_card_areas_ui()
    local stake_ui_element = {}
    local count = 1
    for i=1, 3 do
        local row = {n = G.UIT.R, config = {colour = G.C.LIGHT, padding = 0.1}, nodes = {}}
        for j=1, 8 do
            if count > #G.P_CENTER_POOLS.Stake then return end
            table.insert(row.nodes, {n = G.UIT.O, config = {object = Galdur.run_setup.stake_select_areas[count], r = 0.1, id = "stake_select_"..count, outline_colour = G.C.YELLOW}})
            count = count + 1
        end
        table.insert(stake_ui_element, row)
    end

    populate_stake_card_areas(1)

    return {n=G.UIT.R, config={align = "cm", minh = 0.45+G.CARD_H+G.CARD_H, minw = 10.7, colour = G.C.BLACK, padding = 0.15, r = 0.1, emboss = 0.05}, nodes=stake_ui_element}
end

function get_stake_sprite_in_area(_stake, _scale, _area)
    _stake = _stake or 1
    _scale = _scale or 1
    _area = _area.T or {x = 0, y = 0}
    local stake_sprite = Sprite(_area.x, _area.y, _scale*1, _scale*1,G.ASSET_ATLAS[G.P_CENTER_POOLS.Stake[_stake].atlas], G.P_CENTER_POOLS.Stake[_stake].pos)
    stake_sprite.states.drag.can = false
    if G.P_CENTER_POOLS['Stake'][_stake].shiny then
        stake_sprite.draw = function(_sprite)
            _sprite.ARGS.send_to_shader = _sprite.ARGS.send_to_shader or {}
            _sprite.ARGS.send_to_shader[1] = math.min(_sprite.VT.r*3, 1) + G.TIMERS.REAL/(18) + (_sprite.juice and _sprite.juice.r*20 or 0) + 1
            _sprite.ARGS.send_to_shader[2] = G.TIMERS.REAL

            if _sprite.won then
                Sprite.draw_shader(_sprite, 'dissolve')
                Sprite.draw_shader(_sprite, 'voucher', nil, _sprite.ARGS.send_to_shader)
            else
                Sprite.draw_self(_sprite, G.C.L_BLACK) 
            end
        end
    end
    return stake_sprite
end

function populate_stake_card_areas(page)
    local count = 1 + (page - 1) * 24
    sendDebugMessage(tostring(G.PROFILES[G.SETTINGS.profile].all_unlocked))
    for i=1, 24 do
        if count > #G.P_CENTER_POOLS.Stake then return end
        local card = Card(Galdur.run_setup.stake_select_areas[i].T.x,Galdur.run_setup.stake_select_areas[i].T.y, 3.4*14/41, 3.4*14/41,
            Galdur.run_setup.choices.deck.effect.center, Galdur.run_setup.choices.deck.effect.center, {stake_chip = true, stake = count})
        card.facing = 'back'
        card.sprite_facing = 'back'
        card.children.back = get_stake_sprite_in_area(count, 3.4*14/41, card)
        card.children.back.states.hover = card.states.hover
        card.children.back.states.click = card.states.click
        card.children.back.states.drag = card.states.drag
        card.states.collide.can = false
        card.children.back:set_role({major = card, role_type = 'Glued', draw_major = card})
        local unlocked = true
        local save_data = G.PROFILES[G.SETTINGS.profile].deck_usage[Galdur.run_setup.choices.deck.effect.center.key]
        for _,v in ipairs(G.P_CENTER_POOLS.Stake[count].applied_stakes) do
            if not G.PROFILES[G.SETTINGS.profile].all_unlocked and (not save_data or (save_data and not save_data.wins[G.P_STAKES['stake_'..v].stake_level])) then
                unlocked = false
            end
        end
        if not unlocked then
            card.params.stake_chip_locked = true
            card.children.back = Sprite(card.T.x, card.T.y, 3.4*14/41, 3.4*14/41,G.ASSET_ATLAS['galdur_locked_stake'], {x=0,y=0})
        end
        if save_data and save_data.wins[count] then
            card.children.back.won = true
        end
        Galdur.run_setup.stake_select_areas[i]:emplace(card)
        count = count + 1
    end
end


-- UI Stuff
function create_deck_page_cycle()
    local options = {}
    local cycle
    if #G.P_CENTER_POOLS.Back > 12 then
        local total_pages = math.ceil(#G.P_CENTER_POOLS.Back / 12)
        for i=1, total_pages do
            table.insert(options, localize('k_page')..' '..i..' / '..total_pages)
        end
        cycle = create_option_cycle({
            options = options,
            w = 4.5,
            cycle_shoulders = true,
            opt_callback = 'change_deck_page',
            focus_args = { snap_to = true, nav = 'wide' },
            current_option = 1,
            colour = G.C.RED,
            no_pips = true
        })
    end
    return {n = G.UIT.R, config = {align = "cm"}, nodes = {cycle}}
end

function create_stake_page_cycle()
    local options = {}
    local cycle
    if #G.P_CENTER_POOLS.Stake > 24 then
        local total_pages = math.ceil(#G.P_CENTER_POOLS.Stake / 24)
        for i=1, total_pages do
            table.insert(options, localize('k_page')..' '..i..' / '..total_pages)
        end
        cycle = create_option_cycle({
            options = options,
            w = 4.5,
            cycle_shoulders = true,
            opt_callback = 'change_stake_page',
            focus_args = { snap_to = true, nav = 'wide' },
            current_option = 1,
            colour = G.C.RED,
            no_pips = true
        })
    end
    return {n = G.UIT.R, config = {align = "cm"}, nodes = {cycle}}
end

function clean_deck_areas()
    for j = 1, #Galdur.run_setup.deck_select_areas do
        if Galdur.run_setup.deck_select_areas[j].cards then
            remove_all(Galdur.run_setup.deck_select_areas[j].cards)
            Galdur.run_setup.deck_select_areas[j].cards = {}
        end
    end
end

function clean_stake_areas()
    for j = 1, #Galdur.run_setup.stake_select_areas do
        if Galdur.run_setup.stake_select_areas[j].cards then
            remove_all(Galdur.run_setup.stake_select_areas[j].cards)
            Galdur.run_setup.stake_select_areas[j].cards = {}
        end
    end
end

G.FUNCS.change_deck_page = function(args)
    clean_deck_areas()
    populate_deck_card_areas(args.cycle_config.current_option)
end

G.FUNCS.change_stake_page = function(args)
    clean_stake_areas()
    populate_stake_card_areas(args.cycle_config.current_option)
end

function G.UIDEF.run_setup_option_new_model(type)
    if not G.SAVED_GAME then
        G.SAVED_GAME = get_compressed(G.SETTINGS.profile..'/'..'save.jkr')
        if G.SAVED_GAME ~= nil then G.SAVED_GAME = STR_UNPACK(G.SAVED_GAME) end
    end
  
    G.SETTINGS.current_setup = type
    Galdur.run_setup.choices.deck = Back(get_deck_from_name(G.PROFILES[G.SETTINGS.profile].MEMORY.deck))
    G.PROFILES[G.SETTINGS.profile].MEMORY.stake = G.PROFILES[G.SETTINGS.profile].MEMORY.stake or 1

    local area = {}
  
    if G.OVERLAY_MENU then 
        local seed_toggle = G.OVERLAY_MENU:get_UIE_by_ID('run_setup_seed')
        if seed_toggle then seed_toggle.states.visible = true end
    end
    generate_deck_card_areas()
    generate_stake_card_areas()
    generate_dummy_objects()
    
    Galdur.run_setup.choices.stake = G.PROFILES[G.SETTINGS.profile].MEMORY.stake or 1
    G.FUNCS.change_stake({to_key = Galdur.run_setup.choices.stake})
    Galdur.run_setup.current_page = 1
    Galdur.run_setup.pages.prev_button = ""
    Galdur.run_setup.pages.next_button = Galdur.run_setup.pages[2].name

    
    local ordered_names, viewed_deck = {}, 1
    for k, v in ipairs(G.P_CENTER_POOLS.Back) do
        ordered_names[#ordered_names+1] = v.name
        if v.name == Galdur.run_setup.choices.deck.name then viewed_deck = k end
    end
  
    local lwidth, rwidth = 1.4, 1.8
  
    local type_colour = G.C.BLUE
  
    local scale = 0.39
    Galdur.run_setup.choices.seed = ""
    local t = {n=G.UIT.ROOT, config={align = "cm", colour = G.C.CLEAR, minh = 6.6, minw = 6}, nodes={
        {n = G.UIT.C, nodes = {
            {n=G.UIT.R, config = {align = "cm", minw = 3}, nodes ={
                {n = G.UIT.O, config = {id = 'deck_select_pages', object = UIBox{definition = Galdur.run_setup.pages[Galdur.run_setup.current_page].definition(), config = {align = "cm", offset = {x=0,y=0}}}}},
            }},
            {n=G.UIT.R, config = {align = "cm", minw = 3, offset = {x=0, y=-5}}, nodes ={
                {n = G.UIT.C, config = {id = 'previous_selection', minw = 2.5, minh = 0.8, r = 0.1, hover = true, ref_value = -1, button = Galdur.run_setup.current_page > 1 and 'deck_select_next' or nil, colour = Galdur.run_setup.current_page > 1 and G.C.BLUE or G.C.GREY, align = "cm", emboss = 0.1}, nodes = {
                    {n=G.UIT.T, config={ref_table = Galdur.run_setup.pages, ref_value = 'prev_button', scale = 0.4, colour = G.C.WHITE}}
                }},
                {n=G.UIT.C, config={align = "cm", padding = 0.05, minh = 0.9, minw = 6.6}, nodes={
                    {n=G.UIT.O, config={id = 'seed_input', align = "cm", object = Moveable()}, nodes={}},
                }},
                {n=G.UIT.C, config={align = "cm", minw = 2.2, id = 'run_setup_seed'}, nodes={
                    create_toggle{col = true, label = localize('k_seeded_run'), label_scale = 0.25, w = 0, scale = 0.7, callback = G.FUNCS.toggle_seeded_run, ref_table = Galdur.run_setup.choices, ref_value = 'seed_select'} or nil
                }},
                {n = G.UIT.C, config = {minw = 2.5, minh = 0.8, r = 0.1, hover = true, ref_value = 1, button = 'deck_select_next', colour = G.C.BLUE, align = "cm", emboss = 0.1}, nodes = {
                    {n=G.UIT.T, config={ref_table = Galdur.run_setup.pages, ref_value = 'next_button', scale = 0.4, colour = G.C.WHITE}}
                }},
                {n=G.UIT.C, config={minw = 0.5}},
                {n = G.UIT.C, config = {maxw = 2.5, minw = 2.5, minh = 0.8, r = 0.1, hover = true, ref_value = 1, button = 'test_fun', colour = G.C.ORANGE, align = "cm", emboss = 0.1}, nodes = {
                    {n=G.UIT.T, config={text = 'quick start', scale = 0.4, colour = G.C.WHITE}}
                }}
            }}
        }}
    }}
    return t
end

G.FUNCS.deck_select_next = function(e)
    clean_deck_areas()

    Galdur.run_setup.current_page = math.min(math.max(Galdur.run_setup.current_page + e.config.ref_value, 1), #Galdur.run_setup.pages+1)
    if Galdur.run_setup.current_page > #Galdur.run_setup.pages then
        if not Galdur.run_setup.choices.seed_select then Galdur.run_setup.choices.seed = nil end
        G.FUNCS.start_run(nil, Galdur.run_setup.choices)
        return
    elseif Galdur.run_setup.current_page == #Galdur.run_setup.pages then
        Galdur.run_setup.pages.next_button = 'Play'
    else
        Galdur.run_setup.pages.next_button = Galdur.run_setup.pages[Galdur.run_setup.current_page+1].name
    end
    if Galdur.run_setup.current_page == 1 then
        Galdur.run_setup.pages.prev_button = " "
    else
        Galdur.run_setup.pages.prev_button = Galdur.run_setup.pages[Galdur.run_setup.current_page-1].name
    end

    local prev_button = e.UIBox:get_UIE_by_ID('previous_selection')
    prev_button.config.button = Galdur.run_setup.current_page > 1 and 'deck_select_next' or nil
    prev_button.config.colour = Galdur.run_setup.current_page > 1 and G.C.BLUE or G.C.GREY
    prev_button.UIBox:recalculate()

    local current_selector_page = e.UIBox:get_UIE_by_ID('deck_select_pages')
    if not current_selector_page then return end
    current_selector_page.config.object:remove()
    current_selector_page.config.object = UIBox{
        definition = Galdur.run_setup.pages[Galdur.run_setup.current_page].definition(),
        config = {offset = {x=0,y=0}, parent = current_selector_page, type = 'cm'}
    }
    current_selector_page.UIBox:recalculate()
end

function deck_select_page_deck()
    generate_deck_card_areas()
    generate_deck_preview()
    populate_deck_preview(Galdur.run_setup.choices.deck, true)

    return 
        {n=G.UIT.ROOT, config={align = "tm", minh = 3.8, colour = G.C.CLEAR, padding=0.1}, nodes={
            {n=G.UIT.C, config = {padding = 0.15}, nodes ={   
                generate_deck_card_areas_ui(), 
                create_deck_page_cycle(),
            }},
            selected_deck_preview()
        }}
    
end

function deck_select_page_stake()
    generate_stake_card_areas()
    generate_chip_tower()
    populate_chip_tower(get_deck_win_stake(Galdur.run_setup.choices.deck.effect.center.key)+1)
    generate_deck_preview()
    populate_deck_preview(Galdur.run_setup.choices.deck, true)

    local chip_tower = {n=G.UIT.R, config={align = "cm"}, nodes={
        {n = G.UIT.O, config = {object = Galdur.run_setup.chip_tower}}
    }}

    return 
    {n=G.UIT.ROOT, config={align = "tm", minh = 3.8, colour = G.C.CLEAR, padding=0.1}, nodes={
        {n=G.UIT.C, config = {padding = 0.15}, nodes ={    
            {n=G.UIT.R, nodes = {
                generate_stake_card_areas_ui(),
            }},
            create_stake_page_cycle(),
        }},
        {n=G.UIT.C, config = {align = "tm", padding = 0.15}, nodes ={
            {n = G.UIT.C, config = {minh = 5.95, minw = 1.5, maxw = 1.5, colour = G.C.BLACK, r=0.1, align = "bm", padding = 0.15, emboss=0.05}, nodes = {
                chip_tower,
            }}
        }},
        selected_deck_preview()  
    }}
end

table.insert(Galdur.run_setup.pages, {definition = deck_select_page_deck, name = 'Select Deck'})
table.insert(Galdur.run_setup.pages, {definition = deck_select_page_stake, name = 'Select Stake'})

function G.FUNCS.toggle_seeded_run(bool, e)
    if not e then return end
    local current_selector_page = e.UIBox:get_UIE_by_ID('seed_input')
    if not current_selector_page then return end
    current_selector_page.config.object:remove()
    current_selector_page.config.object = bool and UIBox{
        definition = {n=G.UIT.ROOT, config={align = "cr", colour = G.C.CLEAR}, nodes={
          {n=G.UIT.C, config={align = "cm", minw = 2.5, padding = 0.05}, nodes={
            simple_text_container('ml_disabled_seed',{colour = G.C.UI.TEXT_LIGHT, scale = 0.26, shadow = true}),
          }},
          {n=G.UIT.C, config={align = "cm", minw = 0.1}, nodes={
            create_text_input({max_length = 8, all_caps = true, ref_table = Galdur.run_setup.choices, ref_value = 'seed', prompt_text = localize('k_enter_seed')}),
            {n=G.UIT.C, config={align = "cm", minw = 0.1}, nodes={}},
            UIBox_button({label = localize('ml_paste_seed'),minw = 1, minh = 0.6, button = 'paste_seed', colour = G.C.BLUE, scale = 0.3, col = true})
          }}
        }},
        config = {offset = {x=0,y=0}, parent = e, type = 'cm'}
    } or Moveable()
    if Galdur.run_setup.choices.seed_select then current_selector_page.UIBox:recalculate() end
end

function G.FUNCS.toggle_button(e)
    e.config.ref_table.ref_table[e.config.ref_table.ref_value] = not e.config.ref_table.ref_table[e.config.ref_table.ref_value]
    if e.config.toggle_callback then 
      e.config.toggle_callback(e.config.ref_table.ref_table[e.config.ref_table.ref_value], e) -- pass the node it's from too
    end
end

local card_area_align_ref = CardArea.align_cards
function CardArea:align_cards()
    if self.config.stake_chips then -- align chips vertically
        local deck_height = 4.8/math.max(48,#self.cards)
        for k, card in ipairs(self.cards) do

            if not card.states.drag.is then
                card.T.x = self.T.x + 0.5*(self.T.w - card.T.w)
                card.T.y = self.T.y + deck_height - (#self.cards - k + (k <= Galdur.hover_index and 7 or 0))*deck_height  --self.shadow_parrallax.y*deck_height*(#self.cards/(self == G.deck and 1 or 2) - k)
            end
            card.rank = k
        end
    elseif self.config.selected_deck then
        local deck_height = (self.config.deck_height or 0.15)/52
        for k, card in ipairs(self.cards) do
            if card.facing == 'front' then card:flip() end

            if not card.states.drag.is then
                card.T.x = self.T.x + 0.5*(self.T.w - card.T.w)
                card.T.y = self.T.y + 0.5*(self.T.h - card.T.h) + self.shadow_parrallax.y*deck_height*(#self.cards/(self == G.deck and 1 or 2) - k)
            end
        end
    else
        card_area_align_ref(self)
    end
end

G.FUNCS.test_fun = function(e)
    sendDebugMessage(get_deck_win_stake(Galdur.run_setup.choices.deck.effect.center.key))
end




-- Deck Preview Functions
function selected_deck_preview()
    local texts = split_string_2(Galdur.run_setup.choices.deck.loc_name)

    local deck_node = {n=G.UIT.R, config={align = "tm"}, nodes={
        {n = G.UIT.O, config = {object = Galdur.run_setup.selected_deck_area}}
    }}

    return 
    {n=G.UIT.C, config = {align = "tm", padding = 0.15}, nodes ={
        {n = G.UIT.C, config = {minh = 5.95, minw = 3, maxw = 3, colour = G.C.BLACK, r=0.1, align = "bm", padding = 0.15, emboss=0.05}, nodes = {
            {n = G.UIT.R, config = {align = "cm", minh = 0.6, maxw = 2.8}, nodes = {
                {n = G.UIT.T, config = {id = "selected_deck_name", text = texts[1], scale = 0.7/math.max(1,string.len(texts[1])/8), colour = G.C.GREY}},
            }},
            {n = G.UIT.R, config = {align = "cm", minh = 0.6, maxw = 2.8}, nodes = {
                {n = G.UIT.T, config = {id = "selected_deck_name_2", text = texts[2], scale = 0.75/math.max(1,string.len(texts[2])/8), colour = G.C.GREY}}
            }},
            {n = G.UIT.R, config = {align = "cm", minh = 0.2}},
                deck_node,
            {n = G.UIT.R, config = {minh = 0.8, align = 'bm'}, nodes = {
                {n = G.UIT.T, config = {text = 'SELECTED', scale = 0.75, colour = G.C.GREY}}
            }},
        }}
    }}
end

function generate_deck_preview()
    if Galdur.run_setup.selected_deck_area then
        for j=1, #G.I.CARDAREA do
            if Galdur.run_setup.selected_deck_area == G.I.CARDAREA[j] then
                table.remove(G.I.CARDAREA, j)
                Galdur.run_setup.selected_deck_area = nil
            end
        end
    end

    Galdur.run_setup.selected_deck_area = CardArea(15.475, 0, G.CARD_W, G.CARD_H, 
    {card_limit = 52, type = 'deck', highlight_limit = 0, deck_height = 0.15, thin_draw = 1, selected_deck = true})
   
end

function populate_deck_preview(_deck, silent)
    if Galdur.run_setup.selected_deck_area.cards then remove_all(Galdur.run_setup.selected_deck_area.cards); Galdur.run_setup.selected_deck_area.cards = {} end
    if not _deck then _deck = Back(G.P_CENTERS['b_red']) end
    G.GAME.modifiers = {}
    G.GAME.starting_params = get_starting_params()
    _deck:apply_to_run()
    Galdur.run_setup.selected_deck_height = calculate_deck_size()
    for index = 1, Galdur.run_setup.selected_deck_height do
        local card = Card(Galdur.run_setup.selected_deck_area.T.x+2*G.CARD_W, -2*G.CARD_H, G.CARD_W, G.CARD_H,
            _deck.effect.center, _deck.effect.center, {viewed_back = _deck, deck_select = true})
        card.sprite_facing = 'back'
        card.facing = 'back'
        card.children.back = Sprite(card.T.x, card.T.y, card.T.w, card.T.h, G.ASSET_ATLAS[_deck.effect.center.atlas], _deck.effect.center.pos)
        card.children.back.states.hover = card.states.hover
        card.children.back.states.click = card.states.click
        card.children.back.states.drag = card.states.drag
        card.children.back.states.collide.can = false
        card.children.back:set_role({major = card, role_type = 'Glued', draw_major = card})
        if index == Galdur.run_setup.selected_deck_height then
            G.sticker_card = card
            card.sticker = get_deck_win_sticker(_deck.effect.center)
            card.deck_select_position = true
        end
        if silent or not Galdur.animation or index < Galdur.run_setup.selected_deck_height/2 then
            Galdur.run_setup.selected_deck_area:emplace(card)
        else
            G.E_MANAGER:add_event(Event({
                trigger = 'immediate',
                func = (function()
                    play_sound('card1', math.random()*0.2 + 0.9, 0.35)
                    Galdur.run_setup.selected_deck_area:emplace(card)
                    return true
                end)
            }))
        end
    end
end

function calculate_deck_size()
    G.playing_cards = {}
    local card_protos = nil
    local _de = nil

    if not card_protos then 
        card_protos = {}
        for k, v in pairs(G.P_CARDS) do
            local _ = nil
            if G.GAME.starting_params.erratic_suits_and_ranks then _, k = pseudorandom_element(G.P_CARDS, pseudoseed('erratic')) end
            local _r, _s = string.sub(k, 3, 3), string.sub(k, 1, 1)
            local keep, _e, _d, _g = true, nil, nil, nil
            if _de then
                if _de.yes_ranks and not _de.yes_ranks[_r] then keep = false end
                if _de.no_ranks and _de.no_ranks[_r] then keep = false end
                if _de.yes_suits and not _de.yes_suits[_s] then keep = false end
                if _de.no_suits and _de.no_suits[_s] then keep = false end
                if _de.enhancement then _e = _de.enhancement end
                if _de.edition then _d = _de.edition end
                if _de.gold_seal then _g = _de.gold_seal end
            end

            if G.GAME.starting_params.no_faces and (_r == 'K' or _r == 'Q' or _r == 'J') then keep = false end
            
            if keep then card_protos[#card_protos+1] = {s=_s,r=_r,e=_e,d=_d,g=_g} end
        end
    end 

    if G.GAME.starting_params.extra_cards then 
        for k, v in pairs(G.GAME.starting_params.extra_cards) do
            card_protos[#card_protos+1] = v
        end
    end
    
    return #card_protos
end

function split_string_2(_string)
    local length = string.len(_string)
    local split = {}
    for i in string.gmatch(_string, "%S+") do
        table.insert(split, i)
    end
    local words = #split
    local spaces = words - 1
    local mid = math.ceil(length * 0.4)
    
    local text_output = {"", ""}
    for i,v in ipairs(split) do
        if string.len(text_output[1]) > mid or i > spaces then
            text_output[2] = text_output[2] .. v .. " "
        else
            text_output[1] = text_output[1] .. v .. " "
        end
    end
    text_output[1] = string.sub(text_output[1], 1, string.len(text_output[1])-1)
    text_output[2] = string.sub(text_output[2], 1, string.len(text_output[2])-1)
    return text_output
end


-- Chip Tower Functions
function generate_chip_tower()
    if Galdur.run_setup.chip_tower then
        for j=1, #G.I.CARDAREA do
            if Galdur.run_setup.chip_tower == G.I.CARDAREA[j] then
                table.remove(G.I.CARDAREA, j)
                Galdur.run_setup.chip_tower = nil
            end
        end
    end
    Galdur.run_setup.chip_tower = CardArea(G.ROOM.T.w * 0.656, G.ROOM.T.y, 3.4*14/41, 3.4*14/41, 
        {type = 'deck', highlight_limit = 0, draw_layers = {'card'}, thin_draw = 1, stake_chips = true})
end

function populate_chip_tower(_stake)
    if Galdur.run_setup.chip_tower.cards then remove_all(Galdur.run_setup.chip_tower.cards); Galdur.run_setup.chip_tower.cards = {} end
    if _stake == 0 then _stake = 1 end
    local applied_stakes = order_stake_chain(build_stake_chain(_stake), _stake)
    for index, stake_index in ipairs(applied_stakes) do
        local card = Card(Galdur.run_setup.chip_tower.T.x, G.ROOM.T.y, 3.4*14/41, 3.4*14/41,
            Galdur.run_setup.choices.deck.effect.center, Galdur.run_setup.choices.deck.effect.center,
            {hover = #applied_stakes - index, stake = stake_index, stake_chip = true})
        card.facing = 'back'
        card.sprite_facing = 'back'
        card.children.back = get_stake_sprite_in_area(stake_index, 3.4*14/41, Galdur.run_setup.chip_tower)
        card.children.back.won = true
        card.children.back.states.hover = card.states.hover
        card.children.back.states.click = card.states.click
        card.children.back.states.drag = card.states.drag
        card.children.back.states.collide.can = true
        card.children.back:set_role({major = card, role_type = 'Glued', draw_major = card})
        if Galdur.animation then
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.02,
                func = (function()
                    play_sound('chips2', math.random()*0.2 + 0.9, 0.35)
                    Galdur.run_setup.chip_tower:emplace(card)
                    return true
                end)
            }))
        else
            Galdur.run_setup.chip_tower:emplace(card)
        end
    end
end

function build_stake_chain(end_stake_index, chain)
    local stake_chain = chain or {}
    stake_chain[end_stake_index] = end_stake_index
    if end_stake_index > 1 then
        local next_stakes = G.P_CENTER_POOLS.Stake[end_stake_index].applied_stakes
        for _,v in ipairs(next_stakes) do
            stake_chain = build_stake_chain(G.P_STAKES['stake_'..v].stake_level, stake_chain)
        end
        return stake_chain
    else
        return stake_chain
    end
end

function order_stake_chain(stake_chain, _stake)
    local ordered_chain = {}
    for i,_ in ipairs(G.P_CENTER_POOLS.Stake) do
        if stake_chain[i] and i~= _stake then
            ordered_chain[#ordered_chain+1] = i
        end
    end
    ordered_chain[#ordered_chain+1] = _stake
    return ordered_chain
end

for i=1, 10 do
    SMODS.Stake({
        key = "test_"..i,
        applied_stakes = {i==1 and 'white' or "galdur_test_"..(i-1)},
        above_stake = (i==1 and 'gold' or "galdur_test_"..(i-1)),
        loc_txt = {description = {
            name = "Test Stake "..i,
            text = {
            "Required score scales",
            "faster for each {C:attention}Ante"
            }
        }},
        pos = {x = 3, y = 1},
        shiny = true,
        sticker_pos = {x = 1, y = 0},
        sticker_atlas = 'sticker'
    })
    -- SMODS.Back({
    --     key = "test_"..i
    -- })
end

SMODS.Atlas({
    key = 'sticker',
    path = 'stickers.png',
    px = 71,
    py = 95
})

SMODS.Stake({
    key = "test_stake",
    applied_stakes = {"galdur_test_10", "cry_brown"},
    above_stake = ('galdur_test_10'),
    pos = { x = 4, y = 1 },
    loc_txt = {description = {
        name = "Test Stake FINAL",
        text = {
        "Required score scales",
        "faster for each {C:attention}Ante"
        }
    }},
    sticker_pos = {x = 1, y = 0},
    sticker_atlas = 'sticker',
    shiny = true
})

if G.keybind_mapping[1] and Galdur.keyboard then
    G.keybind_mapping = G.keybind_mapping[1]
    _RELEASE_MODE = false -- The controller thing only works in debug mode
    function G.CONTROLLER.keyboard_controller.setVibration() end -- Compat for vibration enable mod
end

function generate_dummy_objects()
      G.consumeables = CardArea(-10, 0,2.3*G.CARD_W,0.95*G.CARD_H, {card_limit = G.GAME.starting_params.consumable_slots, type = 'discard', highlight_limit = 1})
    G.jokers = G.consumeables
    G.discard = G.consumeables
    G.deck = G.consumeables
    G.hand = G.consumeables
    G.play = G.consumeables
end

function get_joker_win_sticker(_center, index)
    if G.PROFILES[G.SETTINGS.profile].joker_usage[_center.key] and
    G.PROFILES[G.SETTINGS.profile].joker_usage[_center.key].wins then 
        local _w = 0
        for k, v in pairs(G.PROFILES[G.SETTINGS.profile].joker_usage[_center.key].wins) do
        _w = math.max(k, _w)
        end
        if index then return _w end
        if _w > 0 then 
            if _w > 8 then
                return G.sticker_map[G.P_CENTER_POOLS.Stake[_w].key]
            end
            return G.sticker_map[_w]
        end
    end
    if index then return 0 end
end

function get_deck_win_sticker(_center)
    if G.PROFILES[G.SETTINGS.profile].deck_usage[_center.key] and
    G.PROFILES[G.SETTINGS.profile].deck_usage[_center.key].wins then 
        local _w = -1
        for k, v in pairs(G.PROFILES[G.SETTINGS.profile].deck_usage[_center.key].wins) do
            _w = math.max(k, _w)
        end
        if _w > 0 then 
            if _w > 8 then
                return G.sticker_map[G.P_CENTER_POOLS.Stake[_w].key]
            end
            return G.sticker_map[_w]
        end
    end
end

function create_stake_unlock_message(stake)
    local number_applied_stakes = #stake.applied_stakes
    local string_output = 'Win with this deck on '
    for i,v in ipairs(stake.applied_stakes) do
        string_output = string_output .. localize({type='name_text', set='Stake', key='stake_'..v}) .. (i < number_applied_stakes and ' and ' or ' ')
    end
    string_output = string_output .. 'to unlock this stake'
    local split = split_string_2(string_output)

    return {
        {n=G.UIT.R, config={align='cm'}, nodes={
            {n=G.UIT.T, config={text = split[1], scale = 0.3, colour = G.C.UI.TEXT_DARK}}
        }},
        {n=G.UIT.R, config={align='cm'}, nodes={
            {n=G.UIT.T, config={text = split[2], scale = 0.3, colour = G.C.UI.TEXT_DARK}}
        }}
    }
end