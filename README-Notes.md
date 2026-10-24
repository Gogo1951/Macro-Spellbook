# Macro Spellbook // Notes

> Where Macro Spellbook departs from the Gogo1951 add-on Style Guide, kept so no review raises it again.

## Exceptions

### Created character macros recorded in the char scope

- **Departs from:** SAVED VARIABLES → The Two Models, per-character state in `ns.db.profile`.
- **Instead:** The record of which character macros the add-on created lives in AceDB's `char` scope, outside every profile.
- **Why:** That record describes the character's own macro list, which a profile switch, copy or reset never changes, so it must survive all three.

### Equipment macro names stay English

- **Departs from:** LOCALIZATION, all user-facing strings go through `L["KEY"]`.
- **Instead:** The WoW macro names of the equipment macros are the same English names in every locale.
- **Why:** The macro name is what ties a macro already on a player's bars to the add-on, so a translated name would orphan every copy placed before it.

### Macro Defaults toggles two to a line

- **Departs from:** OPTIONS PANEL → Widget Conventions, primary toggles at `width = "full"`.
- **Instead:** The Macro Defaults panel's option toggles sit two to a line under their group captions.
- **Why:** Each kind's box lists about twenty options, which one to a line would stretch to twice the height.

### LICENSE names the original author

- **Departs from:** `References/Canonical Files/LICENSE.txt`, holder `Gogo1951`.
- **Instead:** The LICENSE keeps the original author of the forked code as its copyright holder.
- **Why:** An add-on built on another author's MIT code must keep that author's copyright notice in every copy.

### LICENSE ships in the player zip

- **Departs from:** REQUIRED LIBRARIES → .pkgmeta, `LICENSE` in the `ignore:` list.
- **Instead:** `.pkgmeta` leaves `LICENSE` off its `ignore:` list, so the zip players download carries it.
- **Why:** The forked code's MIT license requires its copyright notice in every copy, the downloaded one included.

### TOC icon is the game's macro icon

- **Departs from:** TOC FILE FORMAT, `IconTexture` points into `Includes/Images/`.
- **Instead:** Every TOC's `## IconTexture:` points at the game's own macro-window icon, the art the add-on's spellbook tab already shows.
- **Why:** The add-on ships no icon art of its own, so the game's macro icon stands in.
