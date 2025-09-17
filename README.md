# Discordant

Nothing **stays** in harmony

## TODO

- [x] Completely remake the controls system cause rn its overcomplicated and annoying to use (how is it hard to use?? look in Player.hx near the bottom. --CS2020)
- [ ] Make a frontent for controls from `UserPrefs.hx` via a layerable abstract over FlxKey. (ZSDev)
- [x] Compress levels into a single file which is more sophisticated than zip. (ZSDev) //which is already done through the json file.
- [x] Move level update loop from `PlayState.hx` to `Level.hx:LVL` //did this --CS2020
- [x] Instead of sending the whole level to `Player.hx`s update, send the level in the constructor and reference that in the players update. //did this --CS2020
- [ ] Change the `sprites` array in `CutsceneSubstate.hx` from array(spr, name) to map(string, spr) to reduce iteration
- [ ] Make custom physics instead of `FlxG.collide()` to maximize support for custom physics objects
- [x] Reading user preferences from `uPrefs.json`. //done --CS2020
