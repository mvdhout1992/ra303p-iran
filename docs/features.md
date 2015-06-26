Features
====================================================================================================

1.   Added support for playing the game at higher resolutions. The resolution settings are read from
     REDALERT.INI's [Options] section. The following two keywords are read:

     ```ini
     Width=
     Height=
     ```
     Hires improvements over hifi's original code for this:
      - The invisible Ant Missions stereo and Westwood Logo credits selection areas are now adjusted
        for hi-res, meaning if you click their area on the main menu graphics they'll be activated,
        like they should.
      - Fixes for the border around the main menu graphics glitching after playing a game, graphical
        glitching when showing the "restate briefing" screen and some other graphical
        glitches. Thanks to Nyerguds for practically writing this for me!
      - If a TITLE.PCX is found that doesn't have the same dimensions as the original TITLE.PCX
        file, it will be displayed on the screen in the top left, this allows people to create their
        own custom main menu title graphics and have them work with hi-res.
      - The timer tab for maps that use them (e.g. the second Allies mission) has its width
        adjusted.
      - The expansion missions dialogs are now adjusted for hires, instead of appearing in the top
        left of the screen.
      - Screenshake should be adjusted for high res now. (Thanks to Arda.dll.inj by AlexB)
      - The "Mission Accomplished", "Mission Failed" and "The Game is a Draw" red text now have
        their height and width adjusted for high res (Thanks to Arda.dll.inj by AlexB)
      - The score screen is now fully displayed in the top left, instead of showing the score
        background in the middle
      - Fixed the power indicator displaying glitched when there's no power and in certain other
        scenarios
      - Added extended sidebar (using graphics and memory addresses taken from Arda, by AlexB)
      - 640x480 does not show black bars on the top and bottom of the screen anymore.
      - You no longer need to scroll the map and open the options menu to fix glitching with maps
        smaller than your resolution.

     The original code for this high resolution feature was written by hifi.

2.   VQA640 files are now centered, only the intro sequence with a Longbow helicopter hitting a
     Mammoth Tank is a VQA640 file though.

3.   Fixed a crash with fences placed on the northern border of the map that are destroyed. (from
     hifi's p-series, thanks to AlexB)

4.   No-CD mode can be enabled/disabled with the NoCD= (yes/no) keyword under the [Options] section
     of REDALERT.INI. (from hifi's p-series)

5.   The Counterstrike expansion can be enabled/disabled with the CounterstrikeEnabled= (yes/no)
     keyword under the [Options] section of REDALERT.INI. Likewise there's a AftermathEnabled=
     (yes/no) keyword to enable/disable the Aftermath expansion.

6.   A crash relating to the a max limit being reached (e.g. that of airplanes) has been
     fixed. (from hifi's p-series). When a max unit limit has been reached the game will play the
     "unable to build more sound".

7.   FunkyFr3sh's OOS-FIX.INI file will be loaded (if it's found) while still being compatible
     online with 3.03 players not using this fix. This fix prevents desyncing after playing certain
     (most?) modded maps online and then playing another map. It also fixes the cause of the desync
     itself, namely that after playing certain modded maps/missions certain memory used by the game
     for its settings (e.g. unit cost) won't be reset when playing a normal map/mission. This has to
     do with some really terrible programming but is a bit technical to explain. Suffice to say this
     fixes things like the Mobile Radar Jammer gaining a Tesla weapon after playing certain
     Counterstrike expansion missions, etc.

8.  Messages sent by other players during a match now appear for 15 seconds in the top left corner
     now, instead of the previous 9 seconds.

9.  Added an REDALERT.INI keyword ShowAllMusic= (yes/no) under the [Options] section to
     enable/disable showing ALL the game's music, normally the game only shows some music depending
     on what side you're playing as. With this option enabled it always shows all music except for
     the score, map and main menu music.

10.  Capture the flag has been enabled for skirmish. Westwood added specific checks to disable this
     game mode for skirmish, but I don't know why. Be warned.

11.  All multiplayer settings are now configurable, inside redalert.ini add:

     ```ini
     [MultiplayerDefaults]
     Money=10000
     ShroudRegrows=false
     CaptureTheFlag=false
     Crates=false
     Bases=true
     OreRegenerates=true
     UnitCount=0
     TechLevel=10
     AIDifficulty=2 ; 0 = easy, 1 = Medium, 2 = Hard
     AIPlayers=1
     ```

     Note the following:
      - You can start a skirmish game with no AI players by setting AIPlayers to 0, note that after
        playing a game like this the game will automatically set the AI players slider to 1.
      - You can start a game with a max of 2.7 billion credits, this works online too even if other
        players don't run my patch.
      - If UnitCount multiplied by players is too high, the game will crash.
      - Setting AIPlayers to higher than 7 causes the game to freeze.

12.  Extra songs can be added to the game by adding them to a MUSIC.INI control file, it should look
     like:

     ```ini
     ; music.ini file for extra music addon
     [Fullnames]
     1=The Second Hand (Retaliation)
     [Filenames]
     1=2nd_hand.AUD
     [Tracklength]
     1=283 ; in seconds
     ```

     Etc for every new song. Make sure there's an empty (blank) line at the end of the file or the
     last entry won't be read properly.

13.  The game now supports loading The Lost Files movies compiled by Nyerguds.

14.  The game will now load and play sizzle3.vqa, sizzle4.vqa and introx.vqa in the sneak preview
     menu if found.

15.  Playing the ENGLISH.VQA intro is now optional. a new REDALERT.INI boolean option
     PlayEnglishIntro= under the "Options" section controls this.

16.  Fixed the in-game displayed name of various songs, Twin Cannon misnamed as "Twin" and most
     Counterstrike songs.

17.  Fix for a rare issue where the game would report there is barely any free disk space left when
     there's plenty. The game now always thinks there is enough free disk space left.

18.  Greece, Spain and Turkey are now all selectable in multiplayer.

19.  Fix added for cnc-ddraw crash in the credits slide show screen once the first text reaches the
     top of the screen. This fix causes slight graphical glitching sadly and as a result I removed
     the loading of background images for the credits screen.

20.  New RULES.INI AftermathFastBuildSpeed= yes/no keyword under the section [Aftermath], with this
     enabled there won't be a cap for build speed increase when you buy additional production
     facilities of the same type (e.g. more than two Barracks)and the Aftermath expansion is
     installed. If you want to use this online you need to play versus other players running this
     patch and the "Force AM fast build speed" RULES.INI file (this is also available as a
     RedAlertConfig.exe option).

21.  New command-line arguments (Thanks to CCHyper):
      - `-ANTMISSIONS`: Starts the hidden ant missions campaign.
      - `-SKIRMISH`:    Loads the skirmish menu.
      - `-LAN`:         Loads the LAN menu.

22.  Optional deinterlacing of videos, this is controlled by the VideoInterlaceMode= keyword in
     REDALERT.INI under the [Options] section, if set to 2 videos are deinterlaced, if set to 0
     they're horizontally interlaced and when set to 1 they're supposed to be vertically interlaced
     (though the vertical interlacing doesn't seem to work). The game's previously unknown
     deinterlacing feature was discovered by AlexB, he also wrote a fix for a bit of graphical
     glitching at the bottom of the screen.

23.  The game no longer requires mpgdll.dll. This DLL was never used and contains MPEG-2 video
     loading code for a never released Red Alert 1 DVD with higher quality movies.

24.  Added a SkipScoreScreen= (yes/no) keyword under [Options] in REDALERT.INI, when set to 'yes'
     the single player and multiplayer score screens won't be shown.

25.  It's now possible to have a random starting song start after a map is loaded, the keyword
     RandomStartingSong= (yes/no) under [Options] in REDALERT.INI controls this.

26.  More MIX files are loaded now:

     1. `campaign.MIX`
     2. `aftermath.MIX`
     3. `counterstrike.MIX`
     4. `smallinfantry.MIX`
     5. `oos-fix.MIX`
     6. `movies-tlf.MIX`
     7. `germanlanguagepack.MIX`
     8. `germancensoredlanguagepack.MIX`
     9. `germanuncensoredlanguagepack.MIX`
     10. `spanishlanguagepack.MIX`
     11. `frenchlanguagepack.MIX`
     12. `italianlanguagepack.MIX`
     13 `expand3.MIX` until `expand10.MIX` (in addition to expand.MIX and expand2.MIX)
     14. `movies-1.MIX` until `movies-10.MIX`

27.  Fixed a bug where Skirmish menu nick name/color/side settings aren't saved when you modify
     them, unless you also modify your nick name. (Thanks to Arda.dll.inj by AlexB)

28.  Fixed a bug where LAN menu nick name/color/side settings aren't saved. You still need to create
     a new game or join an existing one for these settings to be saved though.

29.  Fixed lag when leaving the Network/LAN menu when there are many players in the menu, for
     example while playing on CnCNet.

30.  When first buying a Radar Dome the top of the sidebar will now show the zoomed out map, instead
     of the zoomed in one. Thanks to Nyerguds for showing me how he did this for his C&C95 patch and
     giving me pointers for Red Alert.

31.  The game will now tell you if you're hosting Aftermath or not when you have the aftermath
     expansion enabled. If someone without Aftermath joins your online Aftermath game (effectively
     changing your game into a non-Aftermath game) text will appear making it clear Aftermath is
     turned "off". This doesn't apply to joining games, as the needed info is only send once the
     game is started by the host, sadly..

32.  Added a new RULES.INI keyword RemoveAITechupCheck= (yes/no) under the [AI] section, when set to
     yes the AI will tech up to Radar Dome and beyond even when there are no Helipads or Airfields
     on the map. This fix is always enabled in skirmish.

33.  Added a keyword FixAIParanoid= (yes/no) under the [AI] section of RULES.INI, when set to yes
     the Paranoid= setting will be fixed. This Paranoid= setting controls whether all the AI should
     ally among themselves to fight you when one player is defeated. Paranoid=yes enables this, but
     this was broken in patch 3.03. This fix is always enabled in skirmish.

34.  Added a keyword FixAIAlly= (yes/no) under the [AI] section of RULES.INI, when set to yes you
     can ally with AI players. This fix is always enabled in skirmish.

35.  Optional fix for the formation exploit, the slowest unit speed is used now as formation speed
     when this fix is enabled. The RULES.INI keyword FixFormationSpeed= (yes/no) keyword under the
     [General] section controls whether this fix is on or off, it's off when this keyword is
     missing. This fix is applied by default for skirmish and single player, but not online to stay
     compatible with 3.03 online. (Taken from Arda.dll.inj by AlexB)

36.  The game will no longer delete conquer.eng if it's inside the game folder. (Thanks to
     Arda.dll.inj by AlexB)

37.  Fix for green shadow issue on units like the Phase Transport. (Taken from Arda.dll.inj by
     AlexB)

38.  Fix for projectile off map crash (code from hifi, original fix by AlexB)

39.  Fix for savegame loading with high resolution, when you save a game the positioning info of a
     bunch of sidebar elements is saved and they are loaded when you load the save game. I have no
     idea why Westwood made the game save and load the positioning of sidebar elements. This is
     fixed now. (Thanks to Nyerguds for giving an explanation how he did this for C&C95)

40.  Support for a language pack system, the game's language is decided by the GameLanguage= keyword
     under the [Options] section of redalert.ini. This option determines whether a corresponding mix
     file for the language should be loaded, there's these following values:

     1. (English)           - No additional `.MIX` file is loaded
     2. (German)            - `germanlanguagepack.MIX` is loaded
     3. (German censored)   - `germancensoredlanguagepack.MIX` is loaded
     4. (German uncensored) - `germanuncensoredlanguagepack.MIX` is loaded
     5. (French)            - `frenchlanguagepack.MIX` is loaded
     6. (Spanish)           - `spanishlanguagepack.MIX` is loaded
     7. (Russian)           - `russianlanguagepack.MIX` is loaded

     E.g.: `GameLanguage=6` to load a Spanish language pack.

41.  The game will now try to display maps from the expansions even when the expansions aren't
     enabled.

42.  Official non-expansion, Counterstrike, and Aftermath maps display in the multiplayer menus can
     be enabled/disabled with the following boolean (yes/no) REDALERT.INI [Options] section
     keywords:

     ```ini
     DisplayOriginalMultiplayerMaps=       ; Whether to display the original 24 multiplayer maps (Load MISSIONS.PKT or not)
     DisplayCounterstrikeMultiplayerMaps=  ; Whether to display Counterstrike multiplayer maps (Load CSTRIKE.PKT or not)
     DisplayAftermathMultiplayerMaps=      ; Whether to display Aftermath multiplayer maps (Load AFTMATH.PKT or not)
     ```

43.  Added a new RULES.INI keyword ParabombsInMultiplayer= (yes/no) under the [General] section,
     when enabled it will make parabombs available in multiplayer (by default after an Airfield is
     bought).

44.  It is now possible to scroll the sidebar with the mouse wheel. (code written by CCHyper)

45.  The Image= keyword now works in a map file, instead of just globally in RULES.INI.

46.  Added a new global RULES.INI keyword EvacInMP= (yes/no) under the [General] section , when
     enabled GNRL and Einstein get evacuated if they enter a Chinook in multiplayer. If disabled
     this doesn't happen. Enabled by default to stay compatible with 3.03 online.

47.  Building icons/cameos are now loaded even when a building is TechLevel -1 in RULES.INI under
     [General]. This fixes an issue where enabling building buildings like the Construction Yard
     with a map mod still caused the icon/cameo graphics not to be loaded for the structure in the
     sidebar. This was fixed by patching out a specific check that didn't load these graphics if
     TechLevel was equal to -1 on the building. Other objects in the game like infantry use the same
     loading logic, but without this extra check.

48.  Added REDALERT.INI keyword AlternativeRifleSound= (yes/no) under [Options]. If enabled the
     Rifle Infantry will use an alternative firing sound. MGUNINF1 will be used as firing
     sound. This overwrites the M1Carbine's Report= setting in RULES.INI.

49.  Added REDALERT.INI keyword UseGrenadeThrowingSound= (yes/no) under [Options]. If enabled the
     Grenadier will have a throwing sound when throwing his grenades. This overrides the Grenade's
     Report= setting in RULES.INI.

50.  Added REDALERT.INI keyword UseBetaTeslaTank= (yes/no) under [Options]. If enabled
     betateslatank.MIX will be loaded by the game. Likewise UseBetaDestroyer= to load
     betadestroyer.MIX, UseBetaSubmarine= to load betasubmarine.MIX, UseBetaCruiser= to load
     betacruiser.MIX, UseBetaGunboat= to load betagunboat.MIX. These options load recreations of
     beta graphics, the recreation for the beta Tesla Tank was made by Nyerguds, the recreations of
     naval units were made by Allen262.

51.  Fixed a bug with loading movies2.mix. If movies1.mix is found this file wasn't loaded. Now it
     always is loaded. This affects The First Decade where the Soviet campaign movies (stored in
     movies2.mix) would never play because TFD Red Alert 1 comes with both MIX files.

52.  The game will now try to read ARAZOID.AUD and ARAZIOD.AUD. The game originally would only load
     ARAZOID.AUD but because the file name is misspelled as 'ARAZIOD.AUD' in the game's data files
     it was never read and the song didn't work inside the game because of this.

53.  The resign hotkey now actually works. There wasn't any code to do anything when the resign
     hotkey was pressed, even though the game read this hotkey from REDALERT.INI and also put it
     back in REDALERT.INI.

54.  Added a new hotkey to toggle the sidebar on/off. This works like pressing the TAB keyboard key
     in C&C95. This key can be set with KeySidebarToggle= under [WinHotkeys] in REDALERT.INI.

55.  Un-hardcoded the 1-0 keys on the keyboard. The hotkey checking code for handling teams checked
     both the REDALERT.INI key for the corresponding team and a hard-coded keyboard key for some
     reason. The checks for hard-coded keyboard keys have been patched out. This essentially allows
     you to change what the 1-0 keyboard keys are assigned to do, like is possible with the other
     keyboard keys.

56.  Fixed a bug that caused the multiplayer AI to sometimes send tanks to the top left corner of
     the map. Because this fix desyncs online with 3.03 players it's added as a RULES.INI
     keyword. The fix is controlled by the keyword FixAISendingTanksTopLeft= (yes/no) under the [AI]
     section of RULES.INI. This fix is applied by default in skirmish mode.

57.  The name of the side the player plays as is no longer prepended to the names of missions in the
     mission dialogs. Thanks to Arda.dll.inj by AlexB for showing me where this prepending is done.

58.  Converted the "Counterstrike Missions" menu into a "Custom Missions" one. The "Aftermath
     Missions" menu has been converted into an "Expansions missions" one. The expansion missions
     will be displayed in this menu. The custom missions menu displays map files CMU01EA.INI up to
     CMU999EA.INI. Make sure the custom mission has OneTimeOnly= set to 'Yes' or the game will crash
     after showing the score screen or glitch up. Make sure the [Basic] section of the map is at the
     top, or the game might not read it (this happens with all maps).

59.  Added a new map keyword UseCustomTutorialText= (Yes/No) under the [BASIC] section. This keyword
     can be used to load custom tutorial text strings for your map. If enabled the map file will be
     used as TUTORIAL.INI file, meaning text strings are read from the [TUTORIAL] section of the map
     in the same format as in TUTORIAL.INI. If the keyword is missing TUTORIAL.INI tutorial text
     strings are loaded.

60.  When the game crashes it will now generate a crashdump file with more possibly useful info that
     might help determine what caused the crash. (Code by hifi)

61.  The game now is forced to run under single CPU affinity set, this is to prevent freezing and
     random crashes on certain CPUs.

62.  Fixed movies and audio lag on certain processors when single CPU affinity is enabled.

63.  Fixed ToInherit= map keyword, this keyword will no longer be read in non-single player games.

64.  Localization strings have been changed and applied to the game to help in translation. The
     following strings have been changed:

     ```
     CONQUER.ENG string: 121            Value:    Custom Missions
     CONQUER.ENG string: 120            Value:    Expansions Missions
     CONQUER.ENG string: 119            Value:    The Game is a Draw
     CONQUER.ENG string: 118            Value:    %s has retracted the offer of a draw.
     CONQUER.ENG string: 116            Value:    You have retracted your offer of a draw.
     CONQUER.ENG string: 115            Value:    %s has proposed that the game be declared a draw.
     CONQUER.ENG string: 114            Value:    You have proposed that the game be declared a draw.
     CONQUER.ENG string: 113            Value:    Are you sure you want to accept a draw?
     CONQUER.ENG string: 112            Value:    Are you sure you want to propose a draw
     CONQUER.ENG string: 111            Value:    Accept Proposed Draw
     CONQUER.ENG string: 110            Value:    Retract Draw Proposal
     CONQUER.ENG string: 109            Value:    Propose a Draw
     ```

65.  Added support for winter and desert theaters. To use set Theater= to DESERT or WINTER under the
     [Basic] section of the map. The game will try to load DESERT.MIX and WINTER.MIX. These theaters
     are converted from C&C95 by Allen262, he also had to adapt them to Red Alert 1. The Desert
     conversion was based on work by Merri.

66.  Changed the "V2 Rocket" string to "V2 Rocket Launcher" when mousing over a V2 Rocket Launcher.

67.  Changed the "Invulnerability Device" string to "Invulnerability", to match the icon text and to
     make more sense.

68.  Replaced the "RA Setup" tool with a custom written, open-source configuration tool
     (RedAlertConfig.exe). This tool requires the .Net 2.0 framework.

69.  Added an open-source launcher program (RedAlertLauncher.exe), This program requires the .Net
     2.0 framework.

70.  Included CnC-DDraw ( http://hifi.iki.fi/cnc-ddraw/ ) by hifi, which modernizes the game's
     rendering engine and allows for windowed mode.

71.  Included CnCNet 5 ( http://cncnet.org/ ), which is the de facto standard for playing Red Alert 1
     online. As of 2013 there are regularly 150+ people online. The launcher has a button to launch
     the online lobby for CnCNet. Alternatively to play online you can run 'cncnet.exe'.

72.  The files for the game's expansions (excluding music and movies) are included in this patch.

73.  Added fixed graphic files for some tiles that would turn into beach tiles when damaged by
     certain warheads. ("smudge fix")

74.  Fixed the automatic sonar pulse (submarine decloak) when a team doesn't have any non-submarines
     left. This logic was applied to singleplayer too which broke a few missions and added weird
     behavior on some. The logic is now multiplayer only. (Thanks to Arda.dll.inj by AlexB for
     showing me where to patch this)

75.  The correct bmap.vqa and bmap.vqp files are loaded and included with this patch. The original
     game and expansions came with different versions of this file and sometimes this would cause
     the video to play with a glitched palette. This is the "dagger falling on a map of Europe"
     animation video.

76.  Fixed misspelled Missile Silo text on the icon for the building. It was misspelled as "Missle
     Silo". Fix made by Nyerguds.

77.  Added an option to play with smaller sized infantry. The infantry will be sized like in C&C95.

78.  Added an option to play with a re-creation of the beta Tesla Tank shown in some old magazine
     screenshots. The beta Tesla Tank recreation graphics was made by Nyerguds.

79.  Fixed the missing shadow for the Demo Truck. (Fix made by AlexB)

80.  The sandbags and chainlink fence crush sounds were switched. The chainlink fence now uses the
     correct crush sound. Because the sandbags crush sound wasn't that fitting it has been replaced
     with a more fitting unused sound from the game data files.

81.  Fixed small graphical glitch on the chainlink fence. (Fix by Nyerguds)

82.  Added a fix for the cnc-ddraw bug where the mouse randomly disappears.

83.  If you're not running the Aftermath expansion the Supply Truck/Cargo Truck would not have a
     shadow. The correct graphics with shadows is now always loaded.

84.  Fixed a crash while the game is determine what weapon a unit should use against another
     unit. The game would get an object reference from an object ID for the target unit, but this
     reference could be invalid (NULL) and the game didn't check for that, which causes a
     crash. Added a check.

85.  Sometimes the causalities number printed for the first side shown in the score screen would use
     the wrong side's color. This has been fixed.

86.  Fixed a crash while trying to animate part of the score screen.

87.  Sometimes the music would stop playing after loading multiple savegames, this has been fixed.

88.  Added a fix for a bug where using the Q hotkey with a tank group that includes engineers would
     sometimes cause the game to freeze. Note that instead of when this bug would normally happen
     engineers will start moving to the top left of the map unless giving a new move order.

89.  Game difficulty will no longer affect game speed in offline games (on top of the normal game
     speed slider setting).

90.  Included a fixed version of Soviet mission 13 variant A (there's two map choices for this
     mission). The original mission is bugged in that capturing the Chronosphere (which is supposed
     to be required to win the mission) causes you to lose the game. The B variant of the map works
     properly. The mission fix was made by Allen262, issue reported by r34ch.

91.  The Allies on Soviet Mission 8 variant B produce Flamethrower infantry, even though the Allies
     can't build them (this is because building perquisites for mission autocreate teams are
     ignored). This has been fixed and the Allies no longer produce Flamethrower infantry on this
     map. Fix made by Allen262, issue reported by r34ch.

92.  Fixed a glaringly misplaced tile just to the west of where the Soviets start in the final
     Soviet mission (mission 14). Issue reported by r34ch.

93.  Added a fix for the Ore Mine foundation. This fix is only applied in single player and
     skirmish. The problem is that the Ore Mine doesn't spread ore on the cell directly below it
     because it uses the foundation of the Blossom Tree from C&C1, which has a height of two cells,
     while the Ore Mine is only one cell. This fix was taken from Arda by AlexB.

94.  Added the option to save/load/delete games while playing skirmish. This allows you to save
     skirmish games.

95. Fixed Soviet mission 6 variants A and B so you no longer get APCs at the start of the
     mission. Fix made by Allen262.

96. Any previous active chrono vortex is now destroyed while loading a map or savegame. Previously
     chrono vortex would persist in single player missions after (re)starting one. Thanks to djohe
     for reporting the bug.

97. Added a REDALERT.INI options called "ForceAMUnitsInMissions" under the [Options] section. When
     enabled missions will always have Aftermath units enabled.

98. The game will now end in skirmish if you have allied AI players. Note that all players you've
     allied with have to be allied with each other, when allying more than one other player in game
     this doesn't happen, players you ally will only ally you. So this only works if you ally only
     one player in skirmish.

99. The "computer paranoid" setting has been forced off in skirmish. To disable this, under the
     [AI] section of RULES.INI set ComputerParanoidForceDisabledSkirmish=no. This keyword is only
     read at startup from RULES.INI (aka globally).

100. Added a fix for building crew from certain buildings like the Tesla Coil getting stuck one cell
     above the buildings foundations. This fix is applied to single player and skirmish, but to
     remain online compatible with 3.03 it isn't applied online and in LAN. (Fix made with help from
     CCHyper and code reverse engineered from Arda by AlexB)

101. Fix for an exploit dubbed "magic build". When you're selecting a spot to place a building and
     white rectangles for the building foundations are showing, indicating that the building is
     place-able at that spot, even if every close by building of you dies the rectangles for the
     building foundation stay white, allowing you to still build at that location. In practice when
     a player is base crawling really quickly and you destroy any of his buildings close to where he
     wants to place, if the white rectangles are shown he can still place the building
     (unexpectedly) at that location. If he doesn't yet place the building but moves the mouse
     instead the rectangles will be red.

     This fix is applied to single player and skirmish by default, but not online by default to stay
     compatible with 3.03 online.

102. Added a fix for an infantry range exploit that allows you to have infantry fire across the
     map. This fix is applied to skirmish and single player by default, but not online to stay
     compatible with 3.03. (Fix reverse engineered from Arda by AlexB)

103. Added a fix for certain invisible explosions that affects certain warheads when shooting
     buildings. For example this affects the Chrono Tank shooting its missiles at a Construction
     Yard, the missiles are invisible from most angles. This fix is applied to single player and
     skirmish, but disabled online to remain 3.03 online compatible. (Fix made by AlexB)

104. When loading a scenario, the game would not reset the current amount of credits shown on the
     credits tab in the top right of the screen. So if you have 1.4 billion credits then start
     another scenario, the game would start decrementing the credits count on the top right of the
     screen back to the actual amount (starting with the previous 1.4 billion credits), usually 10
     000 when playing skirmish games. This process could take up to one hour if you start with 1.4
     billion credits. This has been fixed and the amount of credits to display will be reset to 0
     when a scenario is loaded. This does not affect the actual money you have, just what is
     displayed.

105. Added the ability to decide what color and country a house plays at in single player
     missions. Under the house specific section of the map INI (e.g. [USSR]) the new Country= and
     color= keywords are valid. They take a number. Country= takes a HouseType and color= takes a
     PlayerColorType. For more info see the documentation for these data types. An example would be:

     ```ini
     [USSR]
     color=1 ; play with blue color
     Country=0 ; play as Spain country
     ```

106. The game has been patched so the single player score screen will decide whether a house is
     Soviet or Allies by checking what country the house plays as, instead of by the house
     itself. The game needs to decide this to calculate buildings destroyed and casualties for a
     side. With the added ability to change what country a house plays at (say USSR can play as
     France) this is needed.

107. When playing as a country higher than the internal number of 9 (e.g. plying as "Special") the
     game would crash because sidebar graphics couldn't be loaded. The Allies sidebar is loaded
     now. This affects the following countries: Neutral, Special and Multi1-8. Note that these
     "countries" are different from houses. In multiplayer your house is either multi1 to multi8 and
     the country you play as is USSR, Greece etc.

108. The GNRL unit (Volkov for Soviets, Stavros for Allies) had Stavros' voice when playing as
     Ukraine. For no clear reason. He has the generic Soviet voice now, like he has when playing as
     USSR or BadGuy.

109. Allies mission 11 variant B had a bunch of Soviet units and buildings that were counted as
     Allies casualties in the score screen. This has been fixed. (Fix made by Allen262)

110. Allies mission 14 had a bunch of Soviet units and building that were counted as Allies
     casualties in the score screen. This has been fixed. (Fix made by Allen262)

111. The Counterstrike expansion Siberian Conflict 2: Trapped mission had a bunch of Soviet units
     and building that were counted as Allies casualties in the score screen. This has been
     fixed. (Fix made by Allen262)

112. The Counterstrike expansion Sarin Gas 1: Crackdown mission had a bunch of Soviet units and
     building that were counted as Allies casualties in the score screen. This has been fixed. (Fix
     made by Allen262)

113. In The Aftermath expansion Brothers in Arms mission all buildings of the orange "arms dealer"
     faction were counted as Soviet casualties in the score screen, even though they were bunch of
     dirty traitors. This has been fixed and they get counted as Allies casualties now. (Fix made by
     Allen262)

114. Added a new AllyTheNeutralHouse= (yes/no) keyword under the house specific section of a map
     INI. This allows you to disable the hard-coded logic for a house to ally the neutral house. An
     example:

     ```ini
     [USSR]
     AllyTheNeutralHouse=no  ; Don't ally the Neutral house
     ```

115. Changed the cameo text for the Construction Yard and its fake equivalent icons; previously it
     said "Construction" and now it says "Con. Yard". Both Allen262 and EchoLocation made versions
     of these fixed cameo icons about the same time.

116. Added "missing cameo" icons for infantry units so they can be used probably when made
     buildable. These generic cameos were made by Allen262.

117. Added a cameo icon for the Einstein infantry unit, this icon is made from an ingame FMV and
     features Red Alert 1's Einstein. This cameo was made by EchoLocation.

118. Added fan made cameos for the ant units, I got these from the C&C Wikia but I have no idea who
     made them, apparently they're from a mod. Thanks to Plotkite_Wolf for linking them.

119. Added code by hifi to make the in-game "Internet" button launch the CnCNet.org site. You can
     disable this by adding "EnableWOL=yes" under the "[Options]" section in REDALERT.INI, it will
     then run the normal 3.03 code for Westwood Online.

120. Fixed an issue where the sidebar will very rarely show multiple units being built at the same
     completion stage in the sidebar while only one unit was being built. NOTE that there still
     might be at least one other glitched sidebar bug out there. Bug reported and reproduced in a
     savegame by Ehy.

121. Added a shadow to the Mobile Gap Generator vehicle. (Fix made by reaperrr)

122. Added support for a DOS interface mod. This will make the interface look like the DOS one, the
     sidebar, cameo icons, radar graphics and tabs all look like they do in the DOS version of the
     game. The game's menu hasn't been changed though. The REDALERT.INI option UseDOSInterfaceMod=
     (yes/no) under the [Options] section controls loading DOSINTERFACEMOD.MIX, which contain the
     graphics.

     There's another keyword under the same section of the INI file; ColorRemapSidebarIcons=
     (yes/no) to make the DOS interface cameo icons use the remap color of the color the player is
     playing as to change the color of parts of the cameo icon that would normally be yellow.

123. Multiple fixes have been applied to the Aftermath mission Let's Make a Steal. You can no longer
     infiltrate the Power Plant in the mission. Your infantry will no longer shoot the stolen Phase
     Transport. There are Demo Truck reinforcements which clear the way to the exit but they would
     work only very rarely before, this has been fixed. Not all Allies units would attack the stolen
     Phase Transport, this has been fixed too. (Fixes by Allen262, some bugs reported by r34ch)

124. In the Aftermath mission Time Flies you would hear a Tanya death scream at the start of the
     mission while later on you need to use Tanya to clear some buildings. The Tanya death scream
     has been removed. There was also an issue where the Soviets would spam Ore Trucks quite
     comically, this has been fixed too. (Fixes by Allen262, bugs reported by r34ch)

125. In the Aftermath mission Harbor Reclamation if you let the civilian spying on your base escape
     the minor Soviet bases would build APCs. This has been fixed. (Fix by Allen262, bug reported by
     r34ch)

126. In the Aftermath mission Monster Tank Madness the reinforcements you'd get when escorting
     Dr. Demitri before sending a spy into the Radar Dome were buggy and would not properly
     reinforce onto the map. They now reinforce properly from off the map above and a bit to the
     right of the War Factory. As part of this fix the civilians that flee into your base will now
     move to another part of the base, close to the beach you transport your units onto before
     reaching the Allies outpost at the start of the mission. (Fix made by Allen262, bug reported by
     r34ch)

127. Added a code change that should fix the rare crash when building a Radar Dome.

128. Lowered the time out wait period for online games to 30 seconds both at the start of the game
     and midway through the game. The old wait period for the start of the game was 120 seconds and
     the old wait period for midway through the game was 180 seconds.

129. Made clicking the "Serial/Modem" button (to open the menu for modem games) do nothing, as the
     modem menus weren't adjusted for the high resolution patch. This made them appear incorrectly
     on higher resolutions. The button has been disabled as no one uses modem anymore.

130. Some audio related error message message boxes had "Command & Conquer" as their title. This has
     been fixed and their title is now "Red Alert", like the other error messsage boxes.

131. When selecting an ore patch in the radar minimap with an Ore Truck selected the cursor would
     turn into a "Can't move there" cursor instead of an "Attack" cursor. This has been fixed.

132. Added support for new house specific setting 'BuildingsGetInstantlyCaptured=' (yes/no) read
     from map files ONLY which will make it so all the house's buildings are instantly captured by
     other players. Example:

     ```ini
     [BadGuy]
     BuildingsGetInstantlyCaptured=yes
     ```

133. A new 'NoBuildingCrew=' (yes/no) setting has been added, it's read from the house specific
     section of ONLY map files. Like so:

     ```ini
     [BadGuy]
     NoBuildingCrew=yes
     ```

     Combined with the 'BuildingsGetInstantlyCaptured=' (yes/no) and 'color=' settings you can
     emulate the white colored team buildings from Red Alert 2, like so:

     ```ini
     [BadGuy]
     Color=8 ; color = white
     BuildingsGetInstantlyCaptured=yes
     NoBuildingCrew=yes
     ```

134. Added 'SecondaryColorScheme=' setting under the house specific section of a map file. When you
     use this option every objects except buildings will be remapped into this secondary color
     scheme, for example:

     ```ini
     [France]
     Color=1 ; normal Allies blue color for MCV, Ore Truck and buildings
     SecondaryColorScheme=10 ; flaming blue color for every other game object
     ```

135. Added a minor change so aircrafts will only show the amount of maximum ammo they can carry
     instead of always showing 5. For example the MIG has a max ammo count of 3 but would always
     show 5 pips. Fix taken from Arda by AlexB.

136. Fixed selling vehicles on Service depot so you can sell them without having them first be
     repaired by the Service Depot.

137. Added support for mini campaigns. This feature can be used in conjunction with the custom
     missions dialog feature. The following new keywords have been added that will be read from the
     [BASIC] section of a map:

     ```ini
     NextMissionInCampaign= ; next mission filename (WITH file extension)
     ScenarioNumber=        ; The scenario number to set this mission to, this is used for internal stuff
                            ; like default map selection animation, but also as DEFAULT next mission in map selection screen
     MapSelectionAnimation= ; Map selection animation filename for this mission (WITH file extension)
     MapSelectA=            ; map selection choice A mission filename (WITH file extension)
     MapSelectB=            ; map selection choice B mission filename (WITH file extension)
     MapSelectC=            ; map selection choice C mission filename (WITH file extension)
     ```

     Use it with the following keywords already recognized by the game in the [BASIC] section of a
     map:

     ```ini
     EndOfGame=no
     SkipScore=no
     OneTimeOnly=no
     SkipMapSelect=No
     ```

     Example:

     ```ini
     [Basic]
     ScenarioNumber=3 ; Set to level 3 internally
     MapSelectionAnimation=MSAB.WSA
     MapSelectA=scg02ea.ini
     EndOfGame=no ; Not end of campaign
     SkipScore=no ; Don't skip score screen (note the REDALERT.INI SkipScoreScreen= setting overwrites this)
     OneTimeOnly=no ; This is used for the standalone missions, e.g. by all the expansions missions
     SkipMapSelect=No
     NextMissionInCampaign=scg01ea.ini ; because map select is used and it only
                                       ; has choice 'A' this isn't used, STILL NEEDED THOUGH
     ```


138. Added new IsCoopMode= option to the [Basic] section of a map, this enabled some single player
     logic like single player AI logic and allows you to make coop maps with working AI
     production/teamtypes/auto-create/triggers etc and working win/lose triggers. Additional
     documentation forthcoming.

139. Added the option ForceSingleCPU=(Yes/No) to the [Options] section of REDALERT.INI. This forces
     single CPU affinity like cnc-ddraw does. This might be needed if you experience crashes or
     freezes.

140. You can now configure the gem and ore values for Ore Truck dumping for AI players and at
     various difficulty settings. This overwrites the GemValue= and OreValue= RULES.INI
     settings. The new added keywords are:

     ```ini
     [AI]
     ; Easy/Normal/Hard here refers to the handicap set on
     ; the AI player, handicap 'easy' makes thing easier for
     ; the AI player and he is harder to beat than with 'hard'
     ; handicap
     EasyAIGoldValue=300
     EasyAIGemValue=350
     NormalAIGoldValue=200
     NormalAIGemValue=250
     HardAIGoldValue=50
     HardAIGemValue=150
     ```

     If a keyword is missing -1 is used as value. If -1 is used as value the game uses the RULES.INI
     GemValue= setting for gems and OreValue= for ore. These keywords work in anything that
     functions as a RULES.INI kind of file, e.g. map files. So you can use these values in a map
     mod.

141. Added ReenableAITechUpCheck=(Yes/No) under the [AI] section of files that act like RULES.INI
     files (e.g. RULES.INI, AFTMATH.INI and map files). This re-enables the check the game does
     before allowing the AI to build a Radar Dome. This option has been added as this patch breaks
     some special (coop) maps which rely on this logic.

142. Added fixes for two naval exploits: repairing on the move and repairing on enemy naval
     yards. These fixes are applied by default in single player and skirmish and during spawner
     games. (Fix taken from AlexB's Arda, many thanks for also explaining the fix)

143. Messages typed by yourself ingame are now displayed just like messages from other players.

144. Added fixed version of the Counterstrike mission "Soviet Soldier Volkov and Chitzkoi". Even
     though the briefing says the mission is completed when the alloy facility and control center
     are destroyed you would win if destroyed all blue colored Allies units and left those two
     buildings standing. That has been fixed now. (Fix made by Echo)

145. Added two map keywords related to atom bomb damage:

     ```ini
     [Basic]
     UseAtomWhiteScreenEffectInMP=Yes
     UseSinglePlayerAtomDamage=Yes
     ```
146. Added new map trigger actions which can be used in both multiplayer and singleplayer maps/missions. 
    You'll have to manually edit the [Trigs] section of the map to use them as no map editor supports them yet. 
    See the [Trigs] section chapter in the Red Alert Single Player Mission Creation Guide for more info. A quick 
    summary for a trigger in the [Trigs section]:

    ```ini
    name=1,2,h,i,T1,p1,p2,T2,p1,p2,R1,p1,p2,p3,R2,p1,p2,p3
    ```
    
    R1 is trigger action one and p1, p2 and p3 are its parameters. R2 is trigger action two and it also 
    has three paramters. You need to edit those parts of the trigger line to use these new triggers. 

    Here's the list of new triggers:

        Give_Credits_Action: ID = 40, parameter 1 = HouseType of the house to give credits, parameter 2 = 
        amount of credits to give (negative amounts work)
    
        Add_Vehicle_To_Sidebar_Action: ID = 41, parameter = Vehicle internal ID number to add to sidebar 
        (Trigger owner is used for which house to add to sidebar for)
    
        Add_Infantry_To_Sidebar_Action: ID = 42, parameter = Infantry internal ID number to add to sidebar 
        (Trigger owner is used for which house to add to sidebar for)
    
        Add_Building_To_Sidebar_Action: ID = 43, parameter = Building internal ID number to add to sidebar 
        (Trigger owner is used for which house to add to sidebar for)
    
        Add_Aircraft_To_Sidebar_Action: ID = 44, parameter = Aircraft internal ID number to add to sidebar 
        (Trigger owner is used for which house to add to sidebar for)
    
        Add_Vessel_To_Sidebar_Action: ID = 45, parameter = Vessel internal ID number to add to sidebar 
        (Trigger owner is used for which house to add to sidebar for)
    
        Set_View_Port_Location: ID = 50, parameter 1 = Waypoint to center viewport around (Trigger owner is 
        used for which house to set view port location for)
    
        Set_Player_Control: ID = 51, parameter 1 = HouseType to set PlayerControl, parameter 2 = turn player 
        control on/off (1/0) (Trigger owner is used for which house to give player control)
    
        Set_House_Primary_Color_Scheme: ID = 52, parameter 1 = HouseType to set primary color for, 
        parameter 2 = PlayerColorType to set to
    
        Set_House_Secondary_Color_Scheme: ID = 53, parameter 1 = HouseType to set secondary color for, 
        parameter 2 = PlayerColorType to set to
    
        Set_House_Build_Level:  ID = 54, parameter 1 = HouseType to set tech level for, parameter 2 = 
        desired tech level
    
        Set_House_lQ:  ID = 55, parameter 1 = HouseType to set IQ, parameter 2 = desired IQ level
    
        House_Make_Ally:  ID = 56, parameter 1 = HouseType to force make ally another house, 
        parameter 2 = HouseType of the house that will be allied
    
        House_Make_Enemy:  ID = 57, parameter 1 = HouseType to force make enemy another house, 
        parameter 2 = HouseType of the house that will be enemied  
    
        Create_Chronal_Vortex: ID = 58, parameter 1 = waypoint to create chrono vortex at
    
        Nuke_Strike_On_Waypoint: ID = 59, parameter 1 = waypoint to drop nuke on
    
        Capture_Attached_Objects: ID = 60, parameter 1 = HouseType that will capture the attached 
        objects ( you need to attach the trigger to the objects to capture)
    
        Iron_Curtain_Attached_Objects: ID = 61, parameter 1 = Amount of frames the Iron Curtain effect 
        will be active for or -1 to use the duration defined in RULES.INI, can be used to remove the Iron 
        Curtain effect to by using 0 as parameter (you'll need to attach the trigger to the objects to Iron Curtain)
    
        Create_Building_At_Waypoint: ID = 62, parameter 1 = StructType to build, Parameter 2 = waypoint to 
        create, Parameter 3 = HouseType that will be the owner
    
        Set_Mission_Attached_Objects: ID 63, parameter 1 = MissionType to set (Setting buildings to mission 
        "Selling" will sell them, mission "Repair" DOES NOT repair buildings)
    
        Repair_Attached_Buildings: ID 64, no parameters
    
        New_Chrono_Shift_Attached_Objects: ID = 65, parameter 1 = waypoint to chronoshift attached objects to
    
        Chrono_Shift_Trigger_Object: ID = 66, parameter 1 = waypoint to chronoshift trigger object 
        to (chronoshifts the object that triggered this trigger event, e.g. "Entered By..")
    
        Iron_Curtain_Trigger_Object: ID = 67, parameter 1 = frames duration for Iron Curtain 
        effect (Iron Curtains the object that triggered this trigger event, e.g. "Entered by..")
    
147.	It's now possible to use BuildingTypes in TeamTypes/taskforces. So you can for example now have buildings paradropped in.