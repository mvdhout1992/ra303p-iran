Red Alert 3.03 "p" series
================================================================================

This represents the culmination of many years work at modding and patching the
Windows 95 edition of Command & Conquer: Red Alert. See `features.txt` for a
list of added features. The complete feature list also includes the following
separate software:

 - http://cncnet.org/ (Online multiplayer service used by the RA1 community)
 - https://github.com/Iran/cnc-ddraw (hifi's cnc-ddraw patched with fixed videos,
   score screen and map selection screen patching and better frame limiter.
 - https://github.com/Iran/RedAlertConfig
 - https://github.com/Iran/RedAlertLauncher
 - https://github.com/Iran/RAED-Standalone (Old map editors with patches and
   working stand-alone, including hacked support for desert and winter theaters
   added by this patch)

The complete patch also includes game data files fixes and additions. These aren't
included in this repository yet but will be added in the future once a command
line tool to build MIX files is finished. (MIX files are files archives loaded
by the game.)

Building
--------------------------------------------------------------------------------

Windows binaries of the tools to modify `ra95.dat` are in `tools/`. Users of
other OSes can find the tools' source at in the
[`nasm-patcher`](https://github.com/cnc-patch/nasm-patcher) repo.  RA-specific
patches are in `src/`. Just run `build.cmd` from the root directory with
`ra95.dat` present to compile the tools and apply the patches.

### Instructions

1. `git clone git@github.com:cnc-patch/ra303p.git`
2. `cd ra303p`
3. `build.cmd`

The PE section insert tool, "extpe" might not be production quality for anything
else than Red Alert. I hope it can be perfected to add a section to any image
without causing problems for the running program.

Authors
--------------------------------------------------------------------------------

*In alphabetical order*

 - hifi
 - iran
 - sonarpulse

Acknowledgments
--------------------------------------------------------------------------------

This patch couldn't have been made without the help of the following persons:

 - *CCHyper*: Sharing his vast analysed Red Alert engine database with me and
   code contributions.  Also extended the excutable with a game icon.
 - *FunkyFr3sh*: Lots of testing, suggestions, game knowledge, language packs,
   expansion maps converted to .MPR and much more. You're awesome, dude!
 - *Nyerguds*: Contributions to the patch and sharing C&C95 engine knowledge.
 - *AlexB*: Various ideas and addresses used for Arda's fixes taken from his
   Arda project. In Additional lots of information taken from the Arda manual.
 - *Allen262*: C&C95 desert and winter theater conversions, testing, map fixes,
   DOS graphics conversions, beta unit recreations, generic cameos for units
   which don't have cameos.
 - *Merri*: Started work on the desert theater conversion which Allen262
   based his finished conversion on, also made the game strings editor used
   by Iran and FunkyFr3sh for language packs and strings fixes
 - *ehy*: Suggestions and bug reporting.
 - *Lovehandles*: Testing high resolution patches for in-game LAN dialogs.
   Which took about 4 hours or so. ;-) And more helpful testing.
 - *r34ch*: Reporting map bugs and game bugs.
 - *Plotkite_Wolf*: RedAlertLauncher background image.
 - *djohe*: Making useful test maps and reporting game bugs, testing too.

If your work is used by this patch and you're not listed here, our apologies in
advance. Please send one of the authors a message and we'll rectify the issue.

Issues
--------------------------------------------------------------------------------

The following known issues exist:

 - The 'credits slideshow' screen has slight visual glitching and doesn't show or
   rotate background images anymore. This was needed to prevent multiple crashes
   when this screen is shown.
 - When playing windowed on Windows Vista and later Windows operating systems, if
   Windows Aero is enabled the game might be laggy sometimes. To prevent this enable
   the 'Disable desktop composition' compatibility option on ra95.exe.
