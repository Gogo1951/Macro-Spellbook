# Macro Spellbook // Notes

> Where Macro Spellbook departs from the Gogo1951 add-on Style Guide, kept so no review raises it again.

## Exceptions

### Created character macros recorded in the char scope

- **Departs from:** SAVED VARIABLES → The Two Models, per-character state in `ns.db.profile`.
- **Instead:** The record of which character macros the add-on created lives in AceDB's `char` scope, outside every profile.
- **Why:** That record describes the character's own macro list, which a profile switch, copy or reset never changes, so it must survive all three.

### LICENSE names the original author

- **Departs from:** `References/Canonical Files/LICENSE.txt`, holder `Gogo1951`.
- **Instead:** The LICENSE keeps the original author of the forked code as its copyright holder.
- **Why:** An add-on built on another author's MIT code must keep that author's copyright notice in every copy.
