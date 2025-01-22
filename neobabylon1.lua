local sound = require('play_sound')

local neobabylon1 = {
    identifier = "Neo Babylon-1",
    title = "Neo Babylon-1",
    theme = THEME.NEO_BABYLON,
    width = 2,
    height = 4,
    file_name = "Neo Babylon-1.lvl",
}

local level_state = {
    loaded = false,
    callbacks = {},
}

neobabylon1.load_level = function()
    if level_state.loaded then return end
    level_state.loaded = true
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		entity.flags = set_flag(entity.flags, 6)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.FLOORSTYLED_BABYLON)
	
	define_tile_code("torches")
	local torch_uid = {}
	local torches = {}
	local x0 = 0
	local y0 = 0
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		x0 = x
		y0 = y
		
		torch_uid[#torch_uid + 1] = spawn(ENT_TYPE.ITEM_WALLTORCH, x, y, layer, 0, 0)
		torch_uid[#torch_uid + 1] = spawn(ENT_TYPE.ITEM_WALLTORCH, x + 2, y, layer, 0, 0)
		torch_uid[#torch_uid + 1] = spawn(ENT_TYPE.ITEM_WALLTORCH, x + 4, y, layer, 0, 0)
		torch_uid[#torch_uid + 1] = spawn(ENT_TYPE.ITEM_WALLTORCH, x + 7, y, layer, 0, 0)
		torch_uid[#torch_uid + 1] = spawn(ENT_TYPE.ITEM_WALLTORCH, x + 9, y, layer, 0, 0)
		torch_uid[#torch_uid + 1] = spawn(ENT_TYPE.ITEM_WALLTORCH, x + 11, y, layer, 0, 0)
		
		for i = 1,#torch_uid do
			torches[#torches + 1] = get_entity(torch_uid[i])
		end
	end, "torches")
	
	local total_frames = 0
	local round = 1
	local random_event = 0
	local event_frames = 0 --Number of frames spent on the current event
	local safe_positions = {}
	local pushblocks1 = {}
	local pushblocks2 = {}
	local pushblocks3 = {}
	local pushblocks4 = {}
	local pushblocks5 = {}
	local pushblocks6 = {}
	local pushblocks7 = {}
	local octopus = {}
	local necromancers = {}
	local moles = {}
	local ladders = {}
	local platform_uids = {}
	local platforms = {}
	local turkey = 0
	local torch_item = {}
	local ushabti_uids = {}
	local ushabti = {}
	local safe_ushabti = {} --animation frame integers
	level_state.callbacks[#level_state.callbacks+1] = set_callback(function ()
		if total_frames == 0 then
			platform_uids = get_entities_by(ENT_TYPE.FLOOR_PAGODA_PLATFORM, 0, 0)
			for i = 1,#platform_uids do
				platforms[#platforms + 1] = get_entity(platform_uids[i])
			end
		end
		
		--List of events
		if round == 1 and total_frames > 180 then --Three torches light up. Always the first event. Wait 3 seconds before starting the game.
			if event_frames == 0 then
				for i = 1,3 do
					safe_positions[#safe_positions + 1] = math.random(6) --Set sequence of 3 safe positions
				end
			elseif event_frames == 1 then
				torches[safe_positions[1]]:light_up(true)
			elseif event_frames == 61 then
				torches[safe_positions[1]]:light_up(false)
			elseif event_frames == 81 then
				torches[safe_positions[2]]:light_up(true)
			elseif event_frames == 141 then
				torches[safe_positions[2]]:light_up(false)
			elseif event_frames == 161 then
				torches[safe_positions[3]]:light_up(true)
			elseif event_frames == 221 then
				torches[safe_positions[3]]:light_up(false)
				for i = 1,14 do
					if x0 - 2 + i ~= torches[safe_positions[1]].x then
						pushblocks1[#pushblocks1 + 1] = get_entity(spawn(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x0 - 2 + i, y0 + 15, 0, 0, 0))
						pushblocks1[#pushblocks1].flags = clr_flag(pushblocks1[#pushblocks1].flags, 14)
					end
				end
			elseif event_frames == 311 then
				for i = 1,14 do
					if x0 - 2 + i ~= torches[safe_positions[2]].x then
						pushblocks2[#pushblocks2 + 1] = get_entity(spawn(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x0 - 2 + i, y0 + 15, 0, 0, 0))
						pushblocks2[#pushblocks2].flags = clr_flag(pushblocks2[#pushblocks2].flags, 14)
					end
				end
			elseif event_frames == 401 then
				for i = 1,14 do
					if x0 - 2 + i ~= torches[safe_positions[3]].x then
						pushblocks3[#pushblocks3 + 1] = get_entity(spawn(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x0 - 2 + i, y0 + 15, 0, 0, 0))
						pushblocks3[#pushblocks3].flags = clr_flag(pushblocks3[#pushblocks3].flags, 14)
					end
				end
			end
			
			if event_frames == 295 then
				for i = 1,#pushblocks1 do
					pushblocks1[#pushblocks1 - i + 1]:kill(true,nil)
				end
				pushblocks1 = {}
			end
			
			if event_frames == 385 then
				for i = 1,#pushblocks2 do
					pushblocks2[#pushblocks2 - i + 1]:kill(true,nil)
				end
				pushblocks2 = {}
			end
			
			if event_frames == 475 then
				for i = 1,#pushblocks3 do
					pushblocks3[#pushblocks3 - i + 1]:kill(true,nil)
				end
				pushblocks3 = {}
				round = round + 1
				event_frames = -1
				safe_positions = {}
			end
			
			event_frames = event_frames + 1
		elseif round == 2 then --Four torches light up. Always the second event.
			if event_frames == 0 then
				toast("Round " .. tostring(round))
				for i = 1,4 do
					safe_positions[#safe_positions + 1] = math.random(6)
				end
			elseif event_frames == 181 then
				torches[safe_positions[1]]:light_up(true)
			elseif event_frames == 226 then
				torches[safe_positions[1]]:light_up(false)
			elseif event_frames == 246 then
				torches[safe_positions[2]]:light_up(true)
			elseif event_frames == 291 then
				torches[safe_positions[2]]:light_up(false)
			elseif event_frames == 311 then
				torches[safe_positions[3]]:light_up(true)
			elseif event_frames == 356 then
				torches[safe_positions[3]]:light_up(false)
			elseif event_frames == 376 then
				torches[safe_positions[4]]:light_up(true)
			elseif event_frames == 421 then
				torches[safe_positions[4]]:light_up(false)
				for i = 1,14 do
					if x0 - 2 + i ~= torches[safe_positions[1]].x then
						pushblocks1[#pushblocks1 + 1] = get_entity(spawn(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x0 - 2 + i, y0 + 15, 0, 0, 0))
						pushblocks1[#pushblocks1].flags = clr_flag(pushblocks1[#pushblocks1].flags, 14)
					end
				end
			elseif event_frames == 511 then
				for i = 1,14 do
					if x0 - 2 + i ~= torches[safe_positions[2]].x then
						pushblocks2[#pushblocks2 + 1] = get_entity(spawn(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x0 - 2 + i, y0 + 15, 0, 0, 0))
						pushblocks2[#pushblocks2].flags = clr_flag(pushblocks2[#pushblocks2].flags, 14)
					end
				end
			elseif event_frames == 601 then
				for i = 1,14 do
					if x0 - 2 + i ~= torches[safe_positions[3]].x then
						pushblocks3[#pushblocks3 + 1] = get_entity(spawn(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x0 - 2 + i, y0 + 15, 0, 0, 0))
						pushblocks3[#pushblocks3].flags = clr_flag(pushblocks3[#pushblocks3].flags, 14)
					end
				end
			elseif event_frames == 691 then
				for i = 1,14 do
					if x0 - 2 + i ~= torches[safe_positions[4]].x then
						pushblocks4[#pushblocks4 + 1] = get_entity(spawn(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x0 - 2 + i, y0 + 15, 0, 0, 0))
						pushblocks4[#pushblocks4].flags = clr_flag(pushblocks4[#pushblocks4].flags, 14)
					end
				end
			end
			
			if event_frames == 495 then
				for i = 1,#pushblocks1 do
					pushblocks1[#pushblocks1 - i + 1]:kill(true,nil)
				end
				pushblocks1 = {}
			end
			
			if event_frames == 585 then
				for i = 1,#pushblocks2 do
					pushblocks2[#pushblocks2 - i + 1]:kill(true,nil)
				end
				pushblocks2 = {}
			end
			
			if event_frames == 675 then
				for i = 1,#pushblocks3 do
					pushblocks3[#pushblocks3 - i + 1]:kill(true,nil)
				end
				pushblocks3 = {}
			end

			if event_frames == 765 then
				for i = 1,#pushblocks4 do
					pushblocks4[#pushblocks4 - i + 1]:kill(true,nil)
				end
				pushblocks4 = {}
				round = round + 1
				event_frames = -1
				safe_positions = {}
			end

			event_frames = event_frames + 1
		elseif round == 3 or random_event == 1 or random_event == 2 or random_event == 4 or random_event == 5 then --Event 1: Five torches light up. Always the third event. Can be randomly chosen on round 4 and onward. Event 2: Apply ink effect to the player. Event 4: Necromancers. Event 5: Fast Mole (Invunerable)
			if event_frames == 0 then
				toast("Round " .. tostring(round))
				turkey = math.random(100)
				for i = 1,5 do
					safe_positions[#safe_positions + 1] = math.random(6)
				end
				if random_event == 2 then
					octopus[#octopus + 1] = get_entity(spawn(ENT_TYPE.MONS_OCTOPUS, x0 - 3, y0, 0, 0, 0))
					octopus[#octopus + 1] = get_entity(spawn(ENT_TYPE.MONS_OCTOPUS, x0 + 14, y0, 0, 0, 0))
					octopus[1].flags = clr_flag(octopus[1].flags, 17)
					octopus[2].flags = set_flag(octopus[2].flags, 17)
				elseif random_event == 4 then
					necromancers[#necromancers + 1] = get_entity(spawn(ENT_TYPE.MONS_NECROMANCER, x0 - 3, y0, 0, 0, 0))
					necromancers[#necromancers + 1] = get_entity(spawn(ENT_TYPE.MONS_NECROMANCER, x0 + 14, y0, 0, 0, 0))
					necromancers[#necromancers + 1] = get_entity(spawn(ENT_TYPE.MONS_NECROMANCER, x0 + 5, y0 + 3, 1, 0, 0))
					necromancers[1].flags = clr_flag(necromancers[1].flags, 17)
					necromancers[2].flags = set_flag(necromancers[2].flags, 17)
				elseif random_event == 5 then
					moles[#moles + 1] = get_entity(spawn(ENT_TYPE.MONS_MOLE, x0 - 3, y0, 0, 0, 0))
					moles[#moles + 1] = get_entity(spawn(ENT_TYPE.MONS_MOLE, x0 + 14, y0, 0, 0, 0))
					moles[1].flags = clr_flag(moles[1].flags, 17)
					moles[2].flags = set_flag(moles[2].flags, 17)
					
					local side = math.random(2)
					if side == 1 then --spawn mole on the left
						moles[#moles + 1] = get_entity(spawn(ENT_TYPE.MONS_MOLE, x0 - 2, y0 + 2, 0, 0, 0))
						moles[3].flags = set_flag(moles[3].flags, 17)
					elseif side == 2 then --spawn mole on the right
						moles[#moles + 1] = get_entity(spawn(ENT_TYPE.MONS_MOLE, x0 + 13, y0 + 2, 0, 0, 0))
						moles[3].flags = clr_flag(moles[3].flags, 17)
					end
					moles[3].flags = set_flag(moles[3].flags, 28)
					moles[3].flags = clr_flag(moles[3].flags, 12)
					moles[3].health = 99
					moles[3].type.max_speed = 0.06
				end
			elseif event_frames == 181 then
				torches[safe_positions[1]]:light_up(true)
				if random_event == 5 then
					moles[3].flags = clr_flag(moles[3].flags, 28)
				end
			elseif event_frames == 226 then
				torches[safe_positions[1]]:light_up(false)
			elseif event_frames == 246 then
				torches[safe_positions[2]]:light_up(true)
			elseif event_frames == 291 then
				torches[safe_positions[2]]:light_up(false)
			elseif event_frames == 311 then
				torches[safe_positions[3]]:light_up(true)
			elseif event_frames == 356 then
				torches[safe_positions[3]]:light_up(false)
			elseif event_frames == 376 then
				torches[safe_positions[4]]:light_up(true)
			elseif event_frames == 421 then
				torches[safe_positions[4]]:light_up(false)
			elseif event_frames == 441 then
				torches[safe_positions[5]]:light_up(true)
			elseif event_frames == 486 then
				torches[safe_positions[5]]:light_up(false)
				for i = 1,14 do
					if x0 - 2 + i ~= torches[safe_positions[1]].x then
						pushblocks1[#pushblocks1 + 1] = get_entity(spawn(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x0 - 2 + i, y0 + 15, 0, 0, 0))
						pushblocks1[#pushblocks1].flags = clr_flag(pushblocks1[#pushblocks1].flags, 14)
					end
				end
				if random_event == 2 then
					spawn(ENT_TYPE.ITEM_INKSPIT, players[1].x, players[1].y, 0, 0, 0)
				elseif random_event == 4 then
					necromancers[3]:kill(true, nil)
					necromancers[2]:kill(true, nil)
					necromancers[1]:kill(true, nil)
					necromancers = {}
				end
			elseif event_frames == 576 then
				for i = 1,14 do
					if x0 - 2 + i ~= torches[safe_positions[2]].x then
						pushblocks2[#pushblocks2 + 1] = get_entity(spawn(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x0 - 2 + i, y0 + 15, 0, 0, 0))
						pushblocks2[#pushblocks2].flags = clr_flag(pushblocks2[#pushblocks2].flags, 14)
					end
				end
				if random_event == 2 then
					spawn(ENT_TYPE.ITEM_INKSPIT, players[1].x, players[1].y, 0, 0, 0)
				end
			elseif event_frames == 666 then
				for i = 1,14 do
					if x0 - 2 + i ~= torches[safe_positions[3]].x then
						if random_event == 1 and turkey == 50 then
							pushblocks3[#pushblocks3 + 1] = get_entity(spawn(ENT_TYPE.ITEM_PICKUP_COOKEDTURKEY, x0 - 2 + i, y0 + 15, 0, 0, 0)) -- 1-in-100 chance to get a row of cooked turkeys in Event 1
							pushblocks3[#pushblocks3].flags = clr_flag(pushblocks3[#pushblocks3].flags, 14)
						else
							pushblocks3[#pushblocks3 + 1] = get_entity(spawn(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x0 - 2 + i, y0 + 15, 0, 0, 0))
							pushblocks3[#pushblocks3].flags = clr_flag(pushblocks3[#pushblocks3].flags, 14)
						end
					end
				end
				if random_event == 2 then
					spawn(ENT_TYPE.ITEM_INKSPIT, players[1].x, players[1].y, 0, 0, 0)
				end
			elseif event_frames == 756 then
				for i = 1,14 do
					if x0 - 2 + i ~= torches[safe_positions[4]].x then
						pushblocks4[#pushblocks4 + 1] = get_entity(spawn(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x0 - 2 + i, y0 + 15, 0, 0, 0))
						pushblocks4[#pushblocks4].flags = clr_flag(pushblocks4[#pushblocks4].flags, 14)
					end
				end
				if random_event == 2 then
					spawn(ENT_TYPE.ITEM_INKSPIT, players[1].x, players[1].y, 0, 0, 0)
				end
			elseif event_frames == 846 then
				for i = 1,14 do
					if x0 - 2 + i ~= torches[safe_positions[5]].x then
						pushblocks5[#pushblocks5 + 1] = get_entity(spawn(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x0 - 2 + i, y0 + 15, 0, 0, 0))
						pushblocks5[#pushblocks5].flags = clr_flag(pushblocks5[#pushblocks5].flags, 14)
					end
				end
			end
			
			if event_frames == 560 then
				for i = 1,#pushblocks1 do
					pushblocks1[#pushblocks1 - i + 1]:kill(true,nil)
				end
				pushblocks1 = {}
			end
			
			if event_frames == 650 then
				for i = 1,#pushblocks2 do
					pushblocks2[#pushblocks2 - i + 1]:kill(true,nil)
				end
				pushblocks2 = {}
			end
			
			if event_frames == 740 then
				for i = 1,#pushblocks3 do
					pushblocks3[#pushblocks3 - i + 1]:kill(true,nil)
				end
				pushblocks3 = {}
			end

			if event_frames == 830 then
				for i = 1,#pushblocks4 do
					pushblocks4[#pushblocks4 - i + 1]:kill(true,nil)
				end
				pushblocks4 = {}
			end

			if event_frames == 920 then
				for i = 1,#pushblocks5 do
					pushblocks5[#pushblocks5 - i + 1]:kill(true,nil)
				end
				pushblocks5 = {}
				round = round + 1
				event_frames = -1
				safe_positions = {}
				
				if random_event == 2 then
					octopus[2]:kill(true, nil)
					octopus[1]:kill(true, nil)
					octopus = {}
				elseif random_event == 5 then
					moles[3]:destroy()
					moles[2]:kill(true, nil)
					moles[1]:kill(true, nil)
					moles = {}
				end
				
				random_event = math.random(8)
				
			end

			event_frames = event_frames + 1
		elseif random_event == 3 then --Event 3: Only uses torches 3 and 4. Quick sequence of 7. Blocks fall faster.
			if event_frames == 0 then
				toast("Round " .. tostring(round))
				for i = 1,7 do
					safe_positions[#safe_positions + 1] = math.random(2) + 2
				end
				torches[1].color.a = 0
				torches[2].color.a = 0
				torches[3].color.a = 1.0
				torches[4].color.a = 1.0
				torches[5].color.a = 0
				torches[6].color.a = 0
			elseif event_frames == 181 then
				torches[safe_positions[1]]:light_up(true)
			elseif event_frames == 196 then
				torches[safe_positions[1]]:light_up(false)
			elseif event_frames == 226 then
				torches[safe_positions[2]]:light_up(true)
			elseif event_frames == 241 then
				torches[safe_positions[2]]:light_up(false)
			elseif event_frames == 271 then
				torches[safe_positions[3]]:light_up(true)
			elseif event_frames == 286 then
				torches[safe_positions[3]]:light_up(false)
			elseif event_frames == 316 then
				torches[safe_positions[4]]:light_up(true)
			elseif event_frames == 331 then
				torches[safe_positions[4]]:light_up(false)
			elseif event_frames == 361 then
				torches[safe_positions[5]]:light_up(true)
			elseif event_frames == 376 then
				torches[safe_positions[5]]:light_up(false)
			elseif event_frames == 406 then
				torches[safe_positions[6]]:light_up(true)
			elseif event_frames == 421 then
				torches[safe_positions[6]]:light_up(false)
			elseif event_frames == 451 then
				torches[safe_positions[7]]:light_up(true)
			elseif event_frames == 466 then
				torches[safe_positions[7]]:light_up(false)
				for i = 1,14 do
					if x0 - 2 + i ~= torches[safe_positions[1]].x then
						pushblocks1[#pushblocks1 + 1] = get_entity(spawn(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x0 - 2 + i, y0 + 15, 0, 0, 0))
						pushblocks1[#pushblocks1].flags = clr_flag(pushblocks1[#pushblocks1].flags, 14)
					end
				end
			elseif event_frames == 506 then
				for i = 1,14 do
					if x0 - 2 + i ~= torches[safe_positions[2]].x then
						pushblocks2[#pushblocks2 + 1] = get_entity(spawn(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x0 - 2 + i, y0 + 15, 0, 0, 0))
						pushblocks2[#pushblocks2].flags = clr_flag(pushblocks2[#pushblocks2].flags, 14)
					end
				end
			elseif event_frames == 546 then
				for i = 1,14 do
					if x0 - 2 + i ~= torches[safe_positions[3]].x then
						pushblocks3[#pushblocks3 + 1] = get_entity(spawn(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x0 - 2 + i, y0 + 15, 0, 0, 0))
						pushblocks3[#pushblocks3].flags = clr_flag(pushblocks3[#pushblocks3].flags, 14)
					end
				end
			elseif event_frames == 586 then
				for i = 1,14 do
					if x0 - 2 + i ~= torches[safe_positions[4]].x then
						pushblocks4[#pushblocks4 + 1] = get_entity(spawn(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x0 - 2 + i, y0 + 15, 0, 0, 0))
						pushblocks4[#pushblocks4].flags = clr_flag(pushblocks4[#pushblocks4].flags, 14)
					end
				end
			elseif event_frames == 626 then
				for i = 1,14 do
					if x0 - 2 + i ~= torches[safe_positions[5]].x then
						pushblocks5[#pushblocks5 + 1] = get_entity(spawn(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x0 - 2 + i, y0 + 15, 0, 0, 0))
						pushblocks5[#pushblocks5].flags = clr_flag(pushblocks5[#pushblocks5].flags, 14)
					end
				end
			elseif event_frames == 666 then
				for i = 1,14 do
					if x0 - 2 + i ~= torches[safe_positions[6]].x then
						pushblocks6[#pushblocks6 + 1] = get_entity(spawn(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x0 - 2 + i, y0 + 15, 0, 0, 0))
						pushblocks6[#pushblocks6].flags = clr_flag(pushblocks6[#pushblocks6].flags, 14)
					end
				end
			elseif event_frames == 706 then
				for i = 1,14 do
					if x0 - 2 + i ~= torches[safe_positions[7]].x then
						pushblocks7[#pushblocks7 + 1] = get_entity(spawn(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x0 - 2 + i, y0 + 15, 0, 0, 0))
						pushblocks7[#pushblocks7].flags = clr_flag(pushblocks7[#pushblocks7].flags, 14)
					end
				end
			end
			
			if event_frames == 540 then
				for i = 1,#pushblocks1 do
					pushblocks1[#pushblocks1 - i + 1]:kill(true,nil)
				end
				pushblocks1 = {}
			end
			
			if event_frames == 580 then
				for i = 1,#pushblocks2 do
					pushblocks2[#pushblocks2 - i + 1]:kill(true,nil)
				end
				pushblocks2 = {}
			end
			
			if event_frames == 620 then
				for i = 1,#pushblocks3 do
					pushblocks3[#pushblocks3 - i + 1]:kill(true,nil)
				end
				pushblocks3 = {}
			end

			if event_frames == 660 then
				for i = 1,#pushblocks4 do
					pushblocks4[#pushblocks4 - i + 1]:kill(true,nil)
				end
				pushblocks4 = {}
			end

			if event_frames == 700 then
				for i = 1,#pushblocks5 do
					pushblocks5[#pushblocks5 - i + 1]:kill(true,nil)
				end
				pushblocks5 = {}
			end

			if event_frames == 740 then
				for i = 1,#pushblocks6 do
					pushblocks6[#pushblocks6 - i + 1]:kill(true,nil)
				end
				pushblocks6 = {}
			end

			if event_frames == 780 then
				for i = 1,#pushblocks7 do
					pushblocks7[#pushblocks7 - i + 1]:kill(true,nil)
				end
				pushblocks7 = {}
				round = round + 1
				event_frames = -1
				safe_positions = {}
				
				random_event = math.random(8)
				
				if random_event ~= 3 and random_event ~= 6 then
					torches[1].color.a = 1
					torches[2].color.a = 1
					torches[5].color.a = 1
					torches[6].color.a = 1
				end
			end
			
			event_frames = event_frames + 1
		elseif random_event == 6 then --Event 6: Ladders
			if event_frames == 0 then
				toast("Round " .. tostring(round))
				for i = 1,5 do
					safe_positions[#safe_positions + 1] = math.random(4) + 1 --outermost torches unused
				end
				
				ladders[#ladders + 1] = get_entity(spawn(ENT_TYPE.FLOOR_LADDER, x0 + 2, y0 - 2, 0, 0, 0))
				ladders[#ladders + 1] = get_entity(spawn(ENT_TYPE.FLOOR_LADDER, x0 + 4, y0 - 2, 0, 0, 0))
				ladders[#ladders + 1] = get_entity(spawn(ENT_TYPE.FLOOR_LADDER, x0 + 7, y0 - 2, 0, 0, 0))
				ladders[#ladders + 1] = get_entity(spawn(ENT_TYPE.FLOOR_LADDER, x0 + 9, y0 - 2, 0, 0, 0))
				
				torches[1].color.a = 0
				torches[6].color.a = 0
				
				torches[3].color.a = 1.0
				torches[4].color.a = 1.0
				torches[2].color.a = 1.0
				torches[5].color.a = 1.0
				
				for i = 1,#platforms do
					platforms[i].color.a = 0.75
				end
				
			elseif event_frames == 181 then
				torches[safe_positions[1]]:light_up(true)
				players[1].flags = clr_flag(players[1].flags, 14)
				
				for i = 1,#platforms do
					platforms[i].color.a = 0
				end
				
			elseif event_frames == 226 then
				torches[safe_positions[1]]:light_up(false)
			elseif event_frames == 246 then
				torches[safe_positions[2]]:light_up(true)
			elseif event_frames == 291 then
				torches[safe_positions[2]]:light_up(false)
			elseif event_frames == 311 then
				torches[safe_positions[3]]:light_up(true)
			elseif event_frames == 356 then
				torches[safe_positions[3]]:light_up(false)
			elseif event_frames == 376 then
				torches[safe_positions[4]]:light_up(true)
			elseif event_frames == 421 then
				torches[safe_positions[4]]:light_up(false)
			elseif event_frames == 441 then
				torches[safe_positions[5]]:light_up(true)
			elseif event_frames == 486 then
				torches[safe_positions[5]]:light_up(false)
				for i = 1,14 do
					if x0 - 2 + i ~= torches[safe_positions[1]].x then
						pushblocks1[#pushblocks1 + 1] = get_entity(spawn(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x0 - 2 + i, y0 + 15, 0, 0, 0))
						pushblocks1[#pushblocks1].flags = clr_flag(pushblocks1[#pushblocks1].flags, 14)
					end
				end
			elseif event_frames == 576 then
				for i = 1,14 do
					if x0 - 2 + i ~= torches[safe_positions[2]].x then
						pushblocks2[#pushblocks2 + 1] = get_entity(spawn(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x0 - 2 + i, y0 + 15, 0, 0, 0))
						pushblocks2[#pushblocks2].flags = clr_flag(pushblocks2[#pushblocks2].flags, 14)
					end
				end
			elseif event_frames == 666 then
				for i = 1,14 do
					if x0 - 2 + i ~= torches[safe_positions[3]].x then
						pushblocks3[#pushblocks3 + 1] = get_entity(spawn(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x0 - 2 + i, y0 + 15, 0, 0, 0))
						pushblocks3[#pushblocks3].flags = clr_flag(pushblocks3[#pushblocks3].flags, 14)
					end
				end
			elseif event_frames == 756 then
				for i = 1,14 do
					if x0 - 2 + i ~= torches[safe_positions[4]].x then
						pushblocks4[#pushblocks4 + 1] = get_entity(spawn(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x0 - 2 + i, y0 + 15, 0, 0, 0))
						pushblocks4[#pushblocks4].flags = clr_flag(pushblocks4[#pushblocks4].flags, 14)
					end
				end
			elseif event_frames == 846 then
				for i = 1,14 do
					if x0 - 2 + i ~= torches[safe_positions[5]].x then
						pushblocks5[#pushblocks5 + 1] = get_entity(spawn(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x0 - 2 + i, y0 + 15, 0, 0, 0))
						pushblocks5[#pushblocks5].flags = clr_flag(pushblocks5[#pushblocks5].flags, 14)
					end
				end
			end
			
			if event_frames == 560 then
				for i = 1,#pushblocks1 do
					pushblocks1[#pushblocks1 - i + 1]:kill(true,nil)
				end
				pushblocks1 = {}
			end
			
			if event_frames == 650 then
				for i = 1,#pushblocks2 do
					pushblocks2[#pushblocks2 - i + 1]:kill(true,nil)
				end
				pushblocks2 = {}
			end
			
			if event_frames == 740 then
				for i = 1,#pushblocks3 do
					pushblocks3[#pushblocks3 - i + 1]:kill(true,nil)
				end
				pushblocks3 = {}
			end

			if event_frames == 830 then
				for i = 1,#pushblocks4 do
					pushblocks4[#pushblocks4 - i + 1]:kill(true,nil)
				end
				pushblocks4 = {}
			end

			if event_frames == 920 then
				for i = 1,#pushblocks5 do
					pushblocks5[#pushblocks5 - i + 1]:kill(true,nil)
				end
				pushblocks5 = {}
				round = round + 1
				event_frames = -1
				safe_positions = {}
				
				random_event = math.random(8)
				
				ladders[4]:kill(true, nil)
				ladders[3]:kill(true, nil)
				ladders[2]:kill(true, nil)
				ladders[1]:kill(true, nil)
				
				if random_event ~= 3 and random_event ~= 6 then
					torches[1].color.a = 1.0
					torches[6].color.a = 1.0
				end
				
				players[1].flags = set_flag(players[1].flags, 14)
				
				for i = 1,#platforms do
					platforms[i].color.a = 1.0
				end
				
			end

			event_frames = event_frames + 1
		elseif random_event == 7 then --Event 7: Multiple safe spots per wave of blocks
			if event_frames == 0 then
				toast("Round " .. tostring(round))
				local temp = {}
				for i = 1,5 do
					for j = 1,3 do
						temp[j] = math.random(6)
					end
					safe_positions[i] = temp
					temp = {}
				end
				torch_item[#torch_item + 1] = get_entity(spawn(ENT_TYPE.ITEM_TORCH, x0 - 3, y0, 0, 0, 0))
				torch_item[#torch_item + 1] = get_entity(spawn(ENT_TYPE.ITEM_TORCH, x0 + 14, y0, 0, 0, 0))
				torch_item[1].flags = clr_flag(torch_item[1].flags, 17)
				torch_item[2].flags = set_flag(torch_item[2].flags, 17)
				torch_item[1]:light_up(true)
				torch_item[2]:light_up(true)
			elseif event_frames == 181 then
				torches[safe_positions[1][1]]:light_up(true)
				torches[safe_positions[1][2]]:light_up(true)
				torches[safe_positions[1][3]]:light_up(true)
			elseif event_frames == 226 then
				torches[safe_positions[1][1]]:light_up(false)
				torches[safe_positions[1][2]]:light_up(false)
				torches[safe_positions[1][3]]:light_up(false)
			elseif event_frames == 246 then
				torches[safe_positions[2][1]]:light_up(true)
				torches[safe_positions[2][2]]:light_up(true)
				torches[safe_positions[2][3]]:light_up(true)
			elseif event_frames == 291 then
				torches[safe_positions[2][1]]:light_up(false)
				torches[safe_positions[2][2]]:light_up(false)
				torches[safe_positions[2][3]]:light_up(false)
			elseif event_frames == 311 then
				torches[safe_positions[3][1]]:light_up(true)
				torches[safe_positions[3][2]]:light_up(true)
				torches[safe_positions[3][3]]:light_up(true)
			elseif event_frames == 356 then
				torches[safe_positions[3][1]]:light_up(false)
				torches[safe_positions[3][2]]:light_up(false)
				torches[safe_positions[3][3]]:light_up(false)
			elseif event_frames == 376 then
				torches[safe_positions[4][1]]:light_up(true)
				torches[safe_positions[4][2]]:light_up(true)
				torches[safe_positions[4][3]]:light_up(true)
			elseif event_frames == 421 then
				torches[safe_positions[4][1]]:light_up(false)
				torches[safe_positions[4][2]]:light_up(false)
				torches[safe_positions[4][3]]:light_up(false)
			elseif event_frames == 441 then
				torches[safe_positions[5][1]]:light_up(true)
				torches[safe_positions[5][2]]:light_up(true)
				torches[safe_positions[5][3]]:light_up(true)
			elseif event_frames == 486 then
				torches[safe_positions[5][1]]:light_up(false)
				torches[safe_positions[5][2]]:light_up(false)
				torches[safe_positions[5][3]]:light_up(false)
				for i = 1,14 do
					if x0 - 2 + i ~= torches[safe_positions[1][1]].x and x0 - 2 + i ~= torches[safe_positions[1][2]].x and x0 - 2 + i ~= torches[safe_positions[1][3]].x then
						pushblocks1[#pushblocks1 + 1] = get_entity(spawn(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x0 - 2 + i, y0 + 15, 0, 0, 0))
						pushblocks1[#pushblocks1].flags = clr_flag(pushblocks1[#pushblocks1].flags, 14)
					end
				end
			elseif event_frames == 576 then
				for i = 1,14 do
					if x0 - 2 + i ~= torches[safe_positions[2][1]].x and x0 - 2 + i ~= torches[safe_positions[2][2]].x and x0 - 2 + i ~= torches[safe_positions[2][3]].x then
						pushblocks2[#pushblocks2 + 1] = get_entity(spawn(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x0 - 2 + i, y0 + 15, 0, 0, 0))
						pushblocks2[#pushblocks2].flags = clr_flag(pushblocks2[#pushblocks2].flags, 14)
					end
				end
			elseif event_frames == 666 then
				for i = 1,14 do
					if x0 - 2 + i ~= torches[safe_positions[3][1]].x and x0 - 2 + i ~= torches[safe_positions[3][2]].x and x0 - 2 + i ~= torches[safe_positions[3][3]].x then
						pushblocks3[#pushblocks3 + 1] = get_entity(spawn(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x0 - 2 + i, y0 + 15, 0, 0, 0))
						pushblocks3[#pushblocks3].flags = clr_flag(pushblocks3[#pushblocks3].flags, 14)
					end
				end
			elseif event_frames == 756 then
				for i = 1,14 do
					if x0 - 2 + i ~= torches[safe_positions[4][1]].x and x0 - 2 + i ~= torches[safe_positions[4][2]].x and x0 - 2 + i ~= torches[safe_positions[4][3]].x then
						pushblocks4[#pushblocks4 + 1] = get_entity(spawn(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x0 - 2 + i, y0 + 15, 0, 0, 0))
						pushblocks4[#pushblocks4].flags = clr_flag(pushblocks4[#pushblocks4].flags, 14)
					end
				end
			elseif event_frames == 846 then
				for i = 1,14 do
					if x0 - 2 + i ~= torches[safe_positions[5][1]].x and x0 - 2 + i ~= torches[safe_positions[5][2]].x and x0 - 2 + i ~= torches[safe_positions[5][3]].x then
						pushblocks5[#pushblocks5 + 1] = get_entity(spawn(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x0 - 2 + i, y0 + 15, 0, 0, 0))
						pushblocks5[#pushblocks5].flags = clr_flag(pushblocks5[#pushblocks5].flags, 14)
					end
				end
			end
			
			if event_frames == 560 then
				for i = 1,#pushblocks1 do
					pushblocks1[#pushblocks1 - i + 1]:kill(true,nil)
				end
				pushblocks1 = {}
			end
			
			if event_frames == 650 then
				for i = 1,#pushblocks2 do
					pushblocks2[#pushblocks2 - i + 1]:kill(true,nil)
				end
				pushblocks2 = {}
			end
			
			if event_frames == 740 then
				for i = 1,#pushblocks3 do
					pushblocks3[#pushblocks3 - i + 1]:kill(true,nil)
				end
				pushblocks3 = {}
			end

			if event_frames == 830 then
				for i = 1,#pushblocks4 do
					pushblocks4[#pushblocks4 - i + 1]:kill(true,nil)
				end
				pushblocks4 = {}
			end

			if event_frames == 920 then
				for i = 1,#pushblocks5 do
					pushblocks5[#pushblocks5 - i + 1]:kill(true,nil)
				end
				pushblocks5 = {}
				round = round + 1
				event_frames = -1
				safe_positions = {}
				
				random_event = math.random(8)
				
				torch_item[2]:kill(true, nil)
				torch_item[1]:kill(true, nil)
				torch_item = {}
			end

			event_frames = event_frames + 1
		elseif random_event == 8 then --Event 8: Memorize 3 Ushabti
			if event_frames == 0 then
				toast("Round " .. tostring(round))
				for i = 1,3 do
					safe_positions[#safe_positions + 1] = math.random(6)
				end
				
				torches[1].color.a = 0
				torches[2].color.a = 0
				torches[3].color.a = 0
				torches[4].color.a = 0
				torches[5].color.a = 0
				torches[6].color.a = 0
				
				--These show the safe ushabti
				ushabti[1] = get_entity(spawn(ENT_TYPE.ITEM_USHABTI, x0 - 3, y0, 0, 0, 0))
				ushabti[2] = get_entity(spawn(ENT_TYPE.ITEM_USHABTI, x0 + 14, y0, 0, 0, 0))
				
				safe_ushabti[1] = prng:random(0,9) + prng:random(0,9) * 12
				ushabti[1].animation_frame = safe_ushabti[1]
				ushabti[2].animation_frame = safe_ushabti[1]
				ushabti[1].flags = set_flag(ushabti[1].flags, 28)
				ushabti[2].flags = set_flag(ushabti[2].flags, 28)
				
				--These will replace the torches
				ushabti[3] = get_entity(spawn(ENT_TYPE.ITEM_USHABTI, x0, y0, 0, 0, 0))
				ushabti[4] = get_entity(spawn(ENT_TYPE.ITEM_USHABTI, x0 + 2, y0, 0, 0, 0))
				ushabti[5] = get_entity(spawn(ENT_TYPE.ITEM_USHABTI, x0 + 4, y0, 0, 0, 0))
				ushabti[6] = get_entity(spawn(ENT_TYPE.ITEM_USHABTI, x0 + 7, y0, 0, 0, 0))
				ushabti[7] = get_entity(spawn(ENT_TYPE.ITEM_USHABTI, x0 + 9, y0, 0, 0, 0))
				ushabti[8] = get_entity(spawn(ENT_TYPE.ITEM_USHABTI, x0 + 11, y0, 0, 0, 0))
				
				for i = 3,8 do
					ushabti[i].color.a = 0
					ushabti[i].flags = set_flag(ushabti[i].flags, 28)
				end
				
			elseif event_frames == 181 then
				--Nothing
			elseif event_frames == 221 then
				ushabti[1].color.a = 0
				ushabti[2].color.a = 0
			elseif event_frames == 241 then
				safe_ushabti[2] = prng:random(0,9) + prng:random(0,9) * 12
				ushabti[1].animation_frame = safe_ushabti[2]
				ushabti[2].animation_frame = safe_ushabti[2]
				ushabti[1].color.a = 1.0
				ushabti[2].color.a = 1.0
			elseif event_frames == 421 then
				ushabti[1].color.a = 0
				ushabti[2].color.a = 0
			elseif event_frames == 441 then
				safe_ushabti[3] = prng:random(0,9) + prng:random(0,9) * 12
				ushabti[1].animation_frame = safe_ushabti[3]
				ushabti[2].animation_frame = safe_ushabti[3]
				ushabti[1].color.a = 1.0
				ushabti[2].color.a = 1.0
			elseif event_frames == 621 then
				ushabti[1].color.a = 0
				ushabti[2].color.a = 0
				
				for i = 3,8 do
					local temp
					if ushabti[i].x == torches[safe_positions[1]].x then
						ushabti[i].animation_frame = safe_ushabti[1]
					else
						temp = prng:random(0,9) + prng:random(0,9) * 12
						while(temp == safe_ushabti[1])
						do
							temp = prng:random(0,9) + prng:random(0,9) * 12
						end
						ushabti[i].animation_frame = temp
					end
					ushabti[i].color.a = 1.0
				end
			elseif event_frames == 695 then
				for i = 1,14 do
					if x0 - 2 + i ~= torches[safe_positions[1]].x then
						pushblocks1[#pushblocks1 + 1] = get_entity(spawn(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x0 - 2 + i, y0 + 15, 0, 0, 0))
						pushblocks1[#pushblocks1].flags = clr_flag(pushblocks1[#pushblocks1].flags, 14)
					end
				end
			elseif event_frames == 770 then
			
				for i = 3,8 do
					local temp
					if ushabti[i].x == torches[safe_positions[2]].x then
						ushabti[i].animation_frame = safe_ushabti[2]
					else
						temp = prng:random(0,9) + prng:random(0,9) * 12
						while(temp == safe_ushabti[2])
						do
							temp = prng:random(0,9) + prng:random(0,9) * 12
						end
						ushabti[i].animation_frame = temp
					end
					ushabti[i].color.a = 1.0
				end
			elseif event_frames == 845 then
				for i = 1,14 do
					if x0 - 2 + i ~= torches[safe_positions[2]].x then
						pushblocks2[#pushblocks2 + 1] = get_entity(spawn(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x0 - 2 + i, y0 + 15, 0, 0, 0))
						pushblocks2[#pushblocks2].flags = clr_flag(pushblocks2[#pushblocks2].flags, 14)
					end
				end
			elseif event_frames == 920 then
			
				for i = 3,8 do
					local temp
					if ushabti[i].x == torches[safe_positions[3]].x then
						ushabti[i].animation_frame = safe_ushabti[3]
					else
						temp = prng:random(0,9) + prng:random(0,9) * 12
						while(temp == safe_ushabti[3])
						do
							temp = prng:random(0,9) + prng:random(0,9) * 12
						end
						ushabti[i].animation_frame = temp
					end
					ushabti[i].color.a = 1.0
				end
			elseif event_frames == 995 then
				for i = 1,14 do
					if x0 - 2 + i ~= torches[safe_positions[3]].x then
						pushblocks3[#pushblocks3 + 1] = get_entity(spawn(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x0 - 2 + i, y0 + 15, 0, 0, 0))
						pushblocks3[#pushblocks3].flags = clr_flag(pushblocks3[#pushblocks3].flags, 14)
					end
				end
			end
			
			if event_frames == 770 then
				for i = 1,#pushblocks1 do
					pushblocks1[#pushblocks1 - i + 1]:kill(true,nil)
				end
				pushblocks1 = {}
			end
			
			if event_frames == 920 then
				for i = 1,#pushblocks2 do
					pushblocks2[#pushblocks2 - i + 1]:kill(true,nil)
				end
				pushblocks2 = {}
			end
			
			if event_frames == 1070 then
				for i = 1,#pushblocks3 do
					pushblocks3[#pushblocks3 - i + 1]:kill(true,nil)
				end
				pushblocks3 = {}
				round = round + 1
				event_frames = -1
				safe_positions = {}
				
				random_event = math.random(8)
				
				for i = 1,#ushabti do
					ushabti[#ushabti - i + 1].flags = clr_flag(ushabti[#ushabti - i + 1].flags, 28)
					ushabti[#ushabti - i + 1]:kill(true, nil)
				end
				ushabti = {}
				safe_ushabti = {}
				
				if random_event == 3 then
					torches[3].color.a = 1.0
					torches[4].color.a = 1.0
				elseif random_event == 6 then
					torches[2].color.a = 1.0
					torches[3].color.a = 1.0
					torches[4].color.a = 1.0
					torches[5].color.a = 1.0
				elseif random_event == 8 then
					--Nothing
				else
					torches[1].color.a = 1.0
					torches[2].color.a = 1.0
					torches[3].color.a = 1.0
					torches[4].color.a = 1.0
					torches[5].color.a = 1.0
					torches[6].color.a = 1.0
				end
			end

			event_frames = event_frames + 1
		end
		
        total_frames = total_frames + 1
    end, ON.FRAME)
	
	toast("Round " .. tostring(round))
end

neobabylon1.unload_level = function()
    if not level_state.loaded then return end
    
    local callbacks_to_clear = level_state.callbacks
    level_state.loaded = false
    level_state.callbacks = {}
    for _, callback in pairs(callbacks_to_clear) do
        clear_callback(callback)
    end
end

return neobabylon1