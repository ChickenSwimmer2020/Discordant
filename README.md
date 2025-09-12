# Discordant
Nothing **stays** in harmony

# TODO:
- [ ] Completely remake the controls system cause rn its overcomplicated and annoying to use
- [ ] Make a frontent for controls from `UserPrefs.hx` via a layerable abstract over FlxKey. (ZSDev)
- [ ] Compress levels into a single file which is more sophisticated than zip. (ZSDev)
- [ ] Move level update loop from `PlayState.hx` to `Level.hx:LVL`
- [ ] Instead of sending the whole level to `Player.hx`s update, send the level in the constructor and reference that in the players update.
- [ ] Change the `sprites` array in `CutsceneSubstate.hx` from array(spr, name) to map(string, spr) to reduce iteration
