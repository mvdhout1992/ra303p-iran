;
; Copyright (c) 2012 Toni Spets <toni.spets@iki.fi>
;
; Permission to use, copy, modify, and distribute this software for any
; purpose with or without fee is hereby granted, provided that the above
; copyright notice and this permission notice appear in all copies.
;
; THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
; WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
; MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
; ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
; WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
; ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
; OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
;

;[org 0x006ED220]
[org 0x00711000]

;_str_version: db "3.03p4 B6 ",0
_str_version: db "3.03p-iB1v1",0

%include "config.inc"

%include "imports.inc"

%include "libc.inc"

%include "INIClass.inc"
%include "CCINIClass.inc"

%ifdef USE_HIRES
%include "src/hires.asm"
%include "src/fix_savegame_resolution_sidebar.asm"
%include "src/multiplayer_print_is_aftermath_game.asm"
%include "src/extended_sidebar.asm"
%endif

; Version
%include "src/version.asm"

; macros
%include "src/macros.asm"

; loading code
%include "src/loading.asm"

;map snapshot code
%include "src/map_snapshot.asm"

;spawner code
%include "src/spawn.asm"
%include "src/spawner_files.asm"
%include "src/spawner_tunnel.asm"

;extended classses
%include "src/ext/savegame_support.asm" ; this needs to go first before other extended classes

%include "src/ext/UnitTypeClass/extended_unittypeclass_loading.asm"
%include "src/ext/UnitTypeClass/extended_unittypeclass_additions.asm"
%include "src/ext/extended_houseclass.asm"
%include "src/ext/extended_buildingclass.asm"
%include "src/ext/extended_technoclass.asm"
%include "src/ext/extended_aircrafttypeclass.asm"
%include "src/ext/extended_footclass.asm"
%include "src/ext/extended_triggeraction.asm"

; Unhardcode
%include "src/ext/early_rules_ini_load.asm"

%include "src/ext/warheadtypeclass_unhardcode.asm"
%include "src/ext/bullettypeclass_unhardcode.asm"
%include "src/ext/weapontypeclass_unhardcode.asm"
%include "src/ext/soundeffectslist_unhardcode.asm"
%include "src/ext/animtypeclass_unhardcode.asm"
%include "src/ext/unittypeclass_unhardcode.asm"
%include "src/ext/infantrytypeclass_unhardcode.asm"
%include "src/ext/buildingtypeclass_unhardcode.asm"
%include "src/ext/vesseltypeclass_unhardcode.asm"
%include "src/ext/aircrafttypeclass_unhardcode.asm"

; generic
;%include "src/ore_lasts_longer.asm" ; ONLY ENABLE FOR TESTING
%include "src/attract.asm"
%include "src/atom_damage_custom.asm"
%include "src/ingame_display_messages_from_yourself.asm"
%include "src/naval_exploits_fixes.asm"
%include "src/coop.asm"
%include "src/no_digest.asm"
%include "src/remove_C&C_text_references.asm"
%include "src/modem_menu_remove.asm"
%include "src/spectator.asm"
%include "src/radar_spectator.asm"
%include "src/forced_alliances.asm"
%include "src/mcvundeploy.asm"
;%include "src/south_advantage_fix.asm" ; test fix
%include "src/game_difficulty_speed_modifier_remove.asm"
%include "src/magic_build_fix.asm"
%include "src/infantry_range_check.asm"
%include "src/no_tesla_zap_effect_delay.asm"
%include "src/short_game.asm"
%include "src/no_screenshake.asm"
%include "src/shorter_multiplayer_reconnect_timer.asm"
;%include "src/ai_vessels.asm" probably desyncs online with 3.03
;%include "src/harvester_harvest_closest_ore.asm" ; same thing what pressing S on harvesters does, desyncs online and keeps mining new ore spawned by ore mines
%include "src/building_crew_impassable_terrain_fix.asm"
%include "src/predetermined_alliances.asm"
%include "src/build_off_ally.asm"
%include "src/selectable_spawn_locations.asm"
%include "src/tech_center_bug_fix.asm"
%include "src/special_colourscheme.asm"
%include "src/arguments.asm"
%include "src/image_keyword_fix.asm"
%include "src/strip_cameos_glitch_bug.asm"
%include "src/internet_cncnet.asm"
%include "src/singleplayer_custom_colours_countries.asm"
%include "src/sidebar_special_houses.asm"
%include "src/video_stretching_helpers.asm"
%include "src/load_more_mix_files.asm"
%include "src/spawner_house_colours_countries_handicaps.asm"
%include "src/spawner_stats.asm"
;%include "src/debug_printing.asm" ; Seems to cause crashes
%include "src/hotkeys.asm"
%include "src/extra_theaters.asm"
%include "src/extra_sounds.asm"
%include "src/evac_in_mp.asm"
;%include "src/custom_paradrop_superweapon.asm"
%include "src/pkt_loading.asm"
%include "src/expansions.asm"
%include "src/music_loading.asm"
%include "src/movie_loading.asm"
%include "src/custom_missions.asm"
%include "src/ally_shroud_reveal.asm"
%include "src/ingame_chat_improvments.asm"
%include "src/extra_multiplayer_countries.asm"
%include "src/aftermath_fast_buildspeed_option.asm"
%include "src/optional_scorescreen.asm"
%include "src/zoom_out_radar_by_default.asm"
;%include "src/load_ai_ini.asm" ; Changing AI settings desyncs online...
%include "src/ai_fixes.asm"
%include "src/fix_formation_glitch.asm"
%include "src/parabombs_multiplayer.asm"
%include "src/mousewheel_scrolling.asm"
%include "src/skirmish_savegames.asm"
%include "src/sidebar_cameo_icons_remap_colours.asm"
%include "src/more_colour_remaps.asm" ; not done yet and needs a fix for a crash

%ifdef USE_NOCD
%include "src/nocd.asm"
%endif

%ifdef USE_EXCEPTIONS
%include "src/exception.asm"
%endif

%ifdef USE_BUGFIXES
;%include "src/invisible_explosions_fix.asm" ; Causes desync with 3.03
%include "src/ore_truck_ore_patch_minimap_cursor_bug_fix.asm"
%include "src/allies_NCO_helipad_airfield_bug.asm"
%include "src/engi_q_freeze_fix.asm"
%include "src/gnrl_ukraine_voices_fix.asm"
%include "src/score_screen_print_colour_fix.asm"
%include "src/animate_score_objects_crash_fix.asm"
%include "src/submarine_decloak_skip_campaign.asm"
%include "src/what_weapon_should_i_use_crash_fix.asm"
%include "src/radar_dome_crash_fix.asm"
%include "src/fix_toinherit_keyword.asm"
%include "src/localise_draw_strings.asm"
%include "src/mouse_fixes.asm"
%include "src/cpu_affinity_freeze_crash.asm"
%include "src/max_units_bug.asm"
%include "src/fence_bug.asm"
%include "src/tags_bug.asm"
%include "src/savegame_bug.asm"
%include "src/credits_screen_cncddraw_fix.asm"
%include "src/fix_multiplayer_settings_saving.asm"
%include "src/cancel_network_join_menu_lag_fix.asm"
%include "src/skip_deleting_conquer_eng.asm"
%include "src/green_shadow_on_cloaked_units_fix.asm"
%include "src/always_load_building_icons.asm"
%include "src/movies2_loading_bug.asm"
%endif


%ifdef USE_NEW_MULTIPLAYER_DEFAULTS
%include "src/multiplayer_defaults.asm"
%endif

%ifdef USE_LOAD_MORE_MIX_FILES
%endif

%ifdef FOCUS_LOSS_KEEP_PLAYING_SOUND
%include "src/focus_loss_keep_playing_sound.asm"
%endif

%ifdef LOAD_FIX_OOS_INI
%include "src/fix_rules_oos.asm"
%endif
