Made possible thanks to SamuraiOndo's [.bgw unpacker/repacker](https://github.com/SamuraiOndo/tornado-outbreak-bgw) for Tornado Outbreak.

# Limitations
### Cutscenes playing incorrectly.
This is an issue with due to the level's main launcher file working. The current, albeit hacky workaround consists of redirecting the level specific cinematic to load within the referenced designated launcher file, i.e jb_intro, chickenfarm, and training_firesprite. In laymen's terms, you should therotically see the exact same cinematics related to the level, albeit in the incorrect order. i.e route66_outro playing upon the start of Roadside Destruction as opposed to completing the level.
### Chicken Con Carnage: Driver/Gunner (TPOT) mode
This is another issue that I have no clue how to solve. The game typically allows both tornadoes to roam freely but Chicken Con Carnage is an exception. Players in this level will have to share one tornado with the second player using the grab move to capture Fire Flyers.

# General FAQ
### Do I need to install this patch to enjoy the game's multiplayer?
Tornado Outbreak by itself offers eight playable levels that support multiplayer. Using the patch allows you to run Roadside Destruction, Training Campground, and Chicken Con Carnage all in multiplayer, bumping the total number of levels that support multiplayer from 8 to all 11 levels.
### How does the mod work?
The multiplayer patch works by taking the singleplayer's map launcher file and replacing it with the multiplayer supported one. This allows the level to run both in singleplayer and multiplayer. Additional tweaks are then implemented via Lua scripting.
