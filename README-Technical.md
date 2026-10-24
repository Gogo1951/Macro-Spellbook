# Macro Spellbook // Technical Reference

This document combines architecture notes and contribution guidance for developers working on Macro Spellbook. For end-user documentation, see [README.md](https://github.com/Gogo1951/Macro-Spellbook/blob/main/README.md).

## File Map

```text
Macro-Spellbook/
├── .github/
│   ├── ISSUE_TEMPLATE/
│   │   ├── defect.yml                     Shared from Common-Core: the Defect form
│   │   └── request.yml                    Shared from Common-Core: the Request form
│   └── workflows/
│       ├── ci.yml                         Calls Common-Core: shared files, externals, Lua 5.1 syntax, luacheck, StyLua
│       ├── issue-labels.yml               Calls Common-Core: labels a new Defect by its Issue Type answer
│       └── package.yml                    Calls Common-Core: library refresh, then the CurseForge and Wago release
├── .gitattributes                         Shared from Common-Core
├── .gitignore                             Shared from Common-Core
├── .luacheckrc                            Lint config
├── .pkgmeta                               Externals and the packager ignore list (tools/ and Data/Wrath/ stay out of the zip)
├── Bindings.xml                           The Toggle Macro Spellbook key binding; auto-loaded, never in a TOC
├── MacroSpellbook_Vanilla.toc             Classic Era, Season of Discovery included
├── MacroSpellbook_TBC.toc                 TBC Anniversary
├── MacroSpellbook_Camelot.toc             WoW Forever
├── MacroSpellbook_Mists.toc               MoP Classic
├── MacroSpellbook_Mainline.toc            Retail
├── Data/
│   ├── Flavor.lua                         Canonical flavor identity (ns.FLAVOR, ns.EXPANSION, ns.IS_DISCOVERY)
│   ├── Data.lua                           Locale handle, macro limits, section base rank, links, registry names, palette
│   ├── Default-Settings.lua               ns.DATABASE_DEFAULTS
│   ├── LICENSE-Trainer-Data               MIT notice carried with the trainer tables
│   ├── Vanilla/
│   │   ├── Class-Spell-Lists-Vanilla.lua  ns.CLASS_SPELL_LISTS: which spells get which options, default custom macros
│   │   ├── Group-Versions-Vanilla.lua     ns.GROUP_VERSIONS: single spell to its group version
│   │   └── Trainer-Spells-Vanilla.lua     ns.TRAINER_SPELLS: every class trainer rank, by level
│   ├── Discovery/                         Same three tables; paired with Vanilla/ in the Vanilla TOC
│   ├── TBC/                               Same three tables
│   ├── Camelot/                           Same three tables
│   ├── Mists/                             Same three tables; ns.TRAINER_SPELLS is empty
│   ├── Wrath/                             Same three tables, all empty; forward-prep, no TOC
│   └── Mainline/                          Same three tables, all empty
├── Diagnostics/                           Diagnostic Tools framework, copied from Magic Eraser
│   ├── Diagnostics-Core.lua
│   ├── Manifests.lua                      This add-on's manifests and the Page Context and Macro Context probes
│   ├── Event-Log.lua
│   ├── Code-Reports.lua
│   ├── Settings-Reports.lua
│   ├── Validate-Data.lua
│   ├── Localization-Reports.lua           Includes Message Length: every page macro with every option on
│   ├── Report-Runner.lua
│   └── Options-Diagnostics.lua
├── Features/
│   ├── Core.lua                           Version, AceDB init at PLAYER_LOGIN, ns:ApplyProfile, the event dispatcher
│   ├── Utilities.lua                      Colors, UTF-8-safe macro name trim, spellbook and tooltip accessors
│   ├── Announcements.lua                  ns:PrintMessage and ns.WarnOnce (once-per-session config warnings)
│   ├── Migrations.lua                     MIGRATION (remove after 2026-11-23): pre-AceDB saved variables
│   ├── Macro-Options.lua                  Which options a macro offers, which are on, the page-wide defaults
│   ├── Macro-Body.lua                     Option state to macro text; MacroSpellbookMute
│   ├── Custom-Macros.lua                  The player's custom macros: seeding, templates, problems
│   ├── Equipment-Macros.lua               The Equipment section: one /use macro per on-use slot
│   ├── Macro-Builder.lua                  Builds ns.macros from the spellbook and class lists; Dynamic Rank rewrites
│   ├── Unlearned-Spells.lua               Show Unlearned Spells source; Vanilla, TBC and Camelot TOCs only
│   ├── Trainer-Recording.lua              Records class trainer services per character; same TOCs as above
│   ├── Macro-Sync.lua                     Ownership, create/edit/pickup of WoW macros, action bar scan
│   ├── Spellbook-Page.lua                 Draws the page: cells, glows, tooltips, menus, pagination, settings menu
│   ├── Spellbook-Host-Classic.lua         Classic-engine host: book tab and MacroSpellbookFrame window
│   ├── Spellbook-Tabs.lua                 LibSpellBookTabs-1.0, embedded here, not in Includes/
│   ├── Spellbook-Host-Modern.lua          Retail-engine host: registers the page with LibSpellBookTabs
│   └── Key-Bindings.lua                   Binding globals and the Set Key route to the game's Key Bindings list
├── Includes/
│   └── Libraries/                         Vendored Ace3, CallbackHandler, LibStub; never edited
├── Locales/
│   ├── enUS.lua                           Source of truth
│   └── deDE.lua ... zhTW.lua              The other ten locales
├── Options/
│   ├── Options-Utilities.lua
│   ├── Options-General.lua                Welcome toggle, Key Bindings row, /Commands
│   ├── Options-Spellbook-Page.lua         The page-wide settings and macro defaults
│   ├── Options-Custom-Macros.lua          One row per custom macro, Add and Restore Defaults
│   ├── Options-Profiles.lua
│   ├── Options-Feedback-Support.lua
│   └── Options.lua                        Registration, ns:OpenOptionsPanel, /msb
├── tools/
│   └── gen_trainer_data.py                Dev only: regenerates a Trainer-Spells file; never shipped
├── LICENSE                                MIT, original author kept (README-Notes.md)
├── README.md
├── README-Notes.md                        This add-on's exceptions to the Style Guide
└── README-Technical.md
```

Two files a contributor might expect and won't find. LibSpellBookTabs-1.0 lives in `Features/Spellbook-Tabs.lua`, not `Includes/Libraries/`: it has no packager external, and CI fails any `Includes/Libraries/` folder without one. And there is no shared `Data/Group-Versions.lua`: every flavor carries its own `Group-Versions-{Game}.lua`, like every other table.

**Flavor split.** The Classic engine (Vanilla, TBC, Mists) loads `Spellbook-Host-Classic.lua`; the Retail engine (Camelot, Mainline) loads `Spellbook-Tabs.lua` and `Spellbook-Host-Modern.lua` instead. `Unlearned-Spells.lua` and `Trainer-Recording.lua` load only on Vanilla, TBC and Camelot, where class trainers teach the ranks the bundled data lists. Otherwise the five TOCs match line for line apart from `## Interface`, `## X-Flavor` and their data folder.

## Architecture

### Event Loop

`Features/Core.lua` owns the only event frame. `ns.EVENT_NAMES` is the complete event surface, read by both the dispatcher and the Diagnostic Tools; `EVENT_HANDLERS` maps each event to an `ns:On<Event>` name, resolved when the event fires, so feature files that load after Core supply their own handlers. The dispatcher taps `ns:LogEvent` first, behind a single `ns.diagnostics.logging` check, then calls the handler.

Most events register at file load. `TRAINER_SHOW` and `TRAINER_UPDATE` are in `LOGIN_REGISTERED_EVENTS` instead: `ns:RegisterFeatureEvents()` registers them at `PLAYER_LOGIN` only if their handlers exist, because `Trainer-Recording.lua` is left out of the Mists and Mainline TOCs.

| Event | Handler does |
|---|---|
| `PLAYER_LOGIN` | Runs the pre-AceDB migration, creates `ns.db`, wires the profile callbacks, imports legacy settings, registers the options panels and the trainer events, prints the welcome. |
| `SPELLS_CHANGED` | Refreshes any open page; with none open, wipes `ns.macros` so the next Dynamic Rank rewrite rebuilds it with the new ranks. |
| `PLAYER_EQUIPMENT_CHANGED` | Drops the on-use slot cache, then refreshes any open page. |
| `SPELL_DATA_LOAD_RESULT` | With Show Unlearned Spells on, refreshes the open page once per burst (next frame). Can fire before `ns.db` exists, so it checks. |
| `ACTIONBAR_SLOT_CHANGED` | Redraws only the glows, once per burst. |
| `UPDATE_MACROS` | Redraws every visible button (block reasons, glows) and the slot counts, once per burst, since a sync fires one event per edited macro. |
| `PLAYER_TARGET_CHANGED` | Queues a rewrite of every Dynamic Rank macro. |
| `UPDATE_MOUSEOVER_UNIT` | Queues a rewrite of the Dynamic Rank macros that also cast on the mouseover. |
| `PLAYER_REGEN_ENABLED` | Replays a macro sync deferred by `ns:RefreshMacros`. |
| `UPDATE_BINDINGS` | Repaints the General panel so the Key Bindings row shows the new key. |
| `TRAINER_SHOW`, `TRAINER_UPDATE` | Record the class trainer's services. `TRAINER_UPDATE` also fires on filter changes. |

Every "once per burst" is the same pattern: a pending flag plus `C_Timer.After(0, ...)`, so a storm of events costs one redraw on the next frame.

### Combat Lockdown

`CreateMacro`, `EditMacro` and `PickupMacro` are protected in combat. Nothing queues a click; only the background rewrite path defers.

- **Refuses outright and says why:** `ns:OpenOptionsPanel` prints `CHAT_OPTIONS_IN_COMBAT` and returns (never queues). `ns:OpenKeyBindings` prints `CHAT_KEY_BINDINGS_IN_COMBAT`. `ns.PickupMacro` (a click or drag on a page cell) puts the client's own `ERR_NOT_IN_COMBAT` in red on `UIErrorsFrame`.
- **Skips the write, keeps the body:** a menu change (`ns.ToggleOption`, `ns.SetCombatCheck`, `ns.SetAbilityRank`, `ns.ToggleUseSlot`) recomputes `macro.body` in memory but doesn't call `ns.SyncMacro`, and `ns.SyncAllMacros` returns at once. The WoW macro catches up at the next pickup of that cell or the next page refresh out of combat.
- **Defers and replays:** `ns:RefreshMacros` (an options-panel change, a profile switch, reset or copy) sets `syncPending` when no page is open, and `ns:OnPlayerRegenEnabled` replays it. With a page open it refreshes the page instead, whose sync is skipped in combat and not queued.
- **Dynamic Rank rewrites** run out of combat only (`RanksRewritable`). In combat a macro keeps the ranks it last had; the next target or mouseover change after combat rewrites it.
- **Not guarded:** the Classic host's window (`MacroSpellbookFrame`) is an ordinary frame on `UIParent`, so opening and closing it, and drawing the page, have no combat check.

### Read → Build → Write → Draw

The page is rebuilt from scratch every time it is shown (`ns.RefreshSpellbookPage`, the page's `OnShow`) and after any change that touches its list.

1. **Read** (`Features/Utilities.lua`, `Features/Macro-Builder.lua`). `ns.ForEachClassSpell` walks every learned, castable, non-passive spell in skill line order, General included. It is resolved once at load: the Retail engine reads `C_SpellBook` skill lines (skipping hidden and off-spec lines), the Classic engine the spell tab globals. `ReadSpellbook` then collects each spell's learned ranks with their learn levels, and the set of learned names.
2. **Resolve** (`ResolveClassConfig`). The player's class entry in `ns.CLASS_SPELL_LISTS` is turned from spell IDs into this client's spell names: enemy, friend, cursor, channeled, stealth and toggle sets, pet abilities with their creature family names, stances and stance slots, group versions. Class tables in code (`PET_CLASSES`, `MELEE_CLASSES`, `FORM_CLASSES`, `AUTO_SHOTS`) gate which options exist at all. The stance bar's forms are marked as never glowing and, except Warrior stances and stealth, as toggles.
3. **Build** (`ns.CollectMacros`). One macro table per learned spell (`MakeMacro`), its focus copy when Focus is on, then the custom macros, the equipment macros and, with Show Unlearned Spells, the unlearned spells. Each table carries its option capabilities (`target`, `cursor`, `stances`, `ranks`, ...) and its `body` from `ns.MacroBody`. The list is then sorted (Page Sections and Order, below).
4. **Write** (`ns.SyncAllMacros`, `Features/Macro-Sync.lua`). Every page macro that already exists as a WoW macro the add-on owns gets `EditMacro` only when the stored body differs from the page's and fits in 255 bytes. Nothing is created here: creation waits for the player's first click or drag.
5. **Draw** (`Layout`, `Features/Spellbook-Page.lua`). `Paginate` flows the sorted list into page halves; each visible cell is a pooled button pointed at its macro by `SetMacro`, which also works out its block reason, glow and note.

A settings change made away from the page (options panel, profile change) goes through `ns:RefreshMacros`: refresh the open page if there is one, otherwise run steps 1 to 4 without drawing.

### Spell and Item Data Caching

- **Spell names load late.** `ns.SpellName` returns nil for a spell whose data isn't loaded and calls `C_Spell.RequestLoadSpellData` for it once per session (the `requested` set), so an ID that never loads can't keep the page redrawing. A list entry whose name is nil simply doesn't match, so that spell loses its options until the next rebuild. `SPELL_DATA_LOAD_RESULT` redraws the open page when Show Unlearned Spells is on, since that section skips unloaded spells outright.
- **Default custom macros wait for every name.** `ns.DefaultCustomMacros` returns nil while any `{spell:ID}` or `{family:ID}` in a template is unresolved, so seeding never writes a macro with a blank name in it.
- **On-use slots** (`ns.UsableSlots`, `Features/Equipment-Macros.lua`) are cached until `PLAYER_EQUIPMENT_CHANGED`, and each item link's answer is kept for the session, so the page and its menus don't rescan nineteen tooltips on every redraw.
- **Class config** is resolved on first use and again at the start of every `ns.CollectMacros`, so names that loaded since the last build are picked up.

## Macro Text

`ns.MacroBody` (`Features/Macro-Body.lua`) is the only writer of a spell macro's text. It reads every option through `ns.IsOptionOn`, so an option that isn't offered on a macro can never leak into its text. Lines are written in a fixed order:

```text
#showtooltip Shadow Bolt
/run MacroSpellbookMute(1)
/stopcasting
/targetenemy [noexists][dead][help]
/use 13
/petattack
/cast [combat,@mouseover,harm,nodead][combat] Shadow Bolt
/cast !Shoot
/run UIErrorsFrame:Clear()
/run MacroSpellbookMute()
```

That is a Warlock's Shadow Bolt with Mute Error Sounds, Stop Casting, Target Nearest Enemy, a trinket under Use Items First, Enable Pet Attack, Only In Combat, Cast On Mouseover, Start Wand and Hide Error Messages all on. The full order: mute, `/stopcasting`, `/stopattack`, `/cancelform`, `/targetenemy`, the Use Items slots in the order ticked, `/petattack`, the stance switch, the cast line, then Auto Shot or the wand, `/startattack [nostealth]`, the error clear, and the unmute.

- **The cast line is built from clauses.** Each clause is a condition, the unit it tries and the spell. Neighbouring clauses casting the same spell share it (`[@mouseover,help,nodead][help,nodead][@player] Flash Heal`), and a lone clause with nothing to check drops its brackets, so a macro with no options on is exactly `ns.BareBody(name)`: `#showtooltip` and `/cast Name`. Who it tries, in turn: the mouseover, the target, the target's target, then the player (Cast On Self) or the plain target. A cursor spell replaces all of that with `[@cursor]`.
- **Always-present conditions** join every clause, first: Spammable's `nochanneling:<spell>` (or `nostealth` for a stealth spell) and the combat check's `combat` or `nocombat`. Stop Casting carries the same spam condition so a press can't break the spell's own channel.
- **Cast Once Per Target and Cast Once Per Combat** turn the line into `/castsequence reset=target Name, NULL` (or `reset=combat/target`). Cast Once Per Combat also resets on a target change so a second pull mid-combat can take the cast. A cast sequence, a stance switch or Use Items First makes `#showtooltip` name the spell, because the button would otherwise show the next step.
- **Extra clauses go in front.** Downrank In Raids adds a `[group:raid]` copy of each clause casting `Name(Rank 1)`; Right-Click For adds a `[btn:2]` clause casting the learned group version (Prayer of Fortitude, Portal: Ironforge).
- **A summon macro** with Cast <ability> If Summoned is `/cast [pet:<family>] <ability>; <summon>`. `[pet:X]` matches the creature family, so another demon being out still summons this one.
- **Never Turn Off** casts `!Name`, which refreshes a form or aspect instead of cancelling it.
- **Focus copies** are separate page entries with their own WoW macro, casting `[@focus,<target>,nodead]` then the target. Most options rewrite the copy too; the ones that only shape the spell's own clauses (Cast On Mouseover, Cast On Self, Cast On Target's Target, Cast At Cursor, Cast <ability> If Summoned) don't, which is why the menu only redraws the cell after those (`OWN_CLAUSES_ONLY`).

### Ranks

`ReadSpellbook` returns each spell's learned ranks highest first, as `{ text = "Rank 4", level = 38 }`, and only where the learn level is known: the flavor's `ns.TRAINER_SPELLS`, then this character's recorded trainer spells, then `C_Spell.GetSpellLevelLearned` where the client has it. The Classic book lists only each spell's highest rank unless Show All Spell Ranks is ticked, so known trainer ranks the player has (`IsPlayerSpell`) are added from their IDs as well.

- **Spell Rank** is a choice of one: a fixed rank by its text, Max Rank (nil, the default, a plain cast), or Dynamic Rank (`targetRank`, friendly spells only). `ns.FixedRank` ignores a stored rank the player no longer knows.
- **Dynamic Rank** names, per clause, the highest known rank the clause's unit can take: a rank lands on a player at most `RANK_LEVEL_GAP` (10) levels below its learn level. An absent, unassistable or level-unknown unit gets the plain cast; a unit below every rank gets the lowest, which then fails with the game's own message. Because the text depends on the current target and mouseover, target and mouseover changes rewrite those macros on the next frame (`QueueRankRewrite`), the mouseover only rewriting macros that also cast on the mouseover.

### Stances

`ns.StancesOf` reads the class lists' `stances` first (spell ID to the stance IDs it can be cast in). Only for a spell they leave out does it fall back to the spell's tooltip, matching the client's `SPELL_REQUIRED_FORM` ("Requires %s") line against the known stance names. The class lists come first because the tooltip prints form names, which esES names differently from the stance spells on Classic Era and Forever. A stance's `[stance:n]` slot comes from the stance bar, or from `stanceSlots` (learn order) for a Warrior stance not learned yet; a first stance with no known slot writes no switch line at all.

### Mute Error Sounds

Mute Error Sounds is the one place the add-on writes CVars, and the one global a macro body reaches through `/run`. `MacroSpellbookMute(1)` reads `Sound_EnableSFX` and `Sound_EnableErrorSpeech`, sets only the ones that are on to `"0"`, and remembers what it read; `MacroSpellbookMute()` on the macro's last line puts back exactly those values. The error sound plays while the `/cast` line runs, so muting around it silences the "woosh" or the voice, while the spell's own sound still plays because the cast starts after the macro ends. A `C_Timer.After(1, ...)` restore covers a macro whose last line never runs. The write is momentary, so it prints nothing.

## Macro Ownership and Placement

`Features/Macro-Sync.lua` decides which WoW macro a page entry is, and edits only macros the add-on created. A player's own macro that happens to share a spell's name is never touched.

- **The record.** Character macros the add-on made are listed in `ns.db.char.ownedMacros` as `true`. General (account-wide) ones are in `ns.db.global.ownedMacros`: an equipment macro as `true`, since its body names only a slot and every character can share it, and any other as the AceDB key of the character that created it, the only character that rewrites it.
- **General or character** comes from the index alone: general macros are indexes `1..MAX_ACCOUNT_MACROS`, character ones follow. The slot limits are read from `Constants.MacroConsts` (Retail engine) or the `MAX_*_MACROS` globals (Classic engine), falling back to 120 and 30.
- **Lookup** (`ns.FindMacroIndex`): this character's macro of that name, else the general one unless another character created it. In that case the page treats the name as free and creates a character macro of its own, since a second general macro of the same name couldn't be told apart.
- **Creation** (`ns.PickupMacro`, first click or drag): a character macro while character slots are free, else a general one; equipment macros are always general. A spell or equipment macro's icon is the question mark (`134400`), which lets `#showtooltip` show the spell's own icon on the bar. Then `PickupMacro` puts it on the cursor.
- **Block reasons** (`ns.MacroBlockReason`) are shared by the page and the click so they never disagree: `"long"` when the body is over 255 bytes (never written, warned once per session), `"taken"` when the name belongs to the player's own macro, or to another character's general one while no character slot is free. A blocked cell says so in red in place of its note, and its tooltip says why.
- **Full lists** put the client-style red error on `UIErrorsFrame`, prefixed with the Short Name: `ERROR_NO_FREE_MACRO_SLOTS`, or `ERROR_NO_FREE_GENERAL_MACRO_SLOTS` for an equipment macro.

### Macro Names

A WoW macro name holds 16 bytes; `CreateMacro` truncates longer ones, so a lookup by the full name would miss. `ns.TrimMacroName` cuts to 16 bytes and backs up to the start of any UTF-8 character the cut would split. A focus copy trims to 13 and appends ` @F`. Equipment macros are named `Use Head`, `Use Trinket 1` and so on in English in every locale, because those names are identifiers players already have on their bars. While building, a `taken` set keeps custom, equipment and unlearned entries off a name already in use (a custom macro losing out is warned once and flagged on the Custom Macros panel).

## Page Sections and Order

Sections follow the spellbook's own tabs: General, then the class's trees or specs, each ranked by its skill line index. Each tab's name and rank are recorded in `categoryRankByName` as the book is read.

- **Custom macros** list under Custom, or with a spellbook tab's spells when their section names a tab. Custom sections take ranks from `ns.TAB_SECTION_BASE` (100) plus their first entry's index, so they follow the tabs in order of first use. A section that no longer names a tab still shows, under its own name.
- **Equipment** takes `ns.TAB_SECTION_BASE + #customMacros + 1`, after every custom section.
- **Unlearned** sorts last (`math.huge`).
- Within a section: spells before custom macros, then spellbook order (learn level for unlearned spells), then name, each focus copy straight after its spell.

`Paginate` flows the sorted list into page halves of `CELL_HEIGHT` (52) rows with a `CATEGORY_GAP` (12) between sections, repeating a section's header when it carries over. A spread is two halves, or one when the Retail book is minimized.

### Glows

A cell glows, pulsing like the native page's unassigned spells, when its macro is learned but not placed. `ns.ScanActionBars` reads slots 1 to 180 and matches macros by `GetActionText`, because a macro that shows a spell reports the spell's ID rather than its macro index. A spell macro also counts as placed when its plain spell is on a bar: always when the macro has no options on (the body is `ns.BareBody`), and for any spell macro with Count Spells On Bars As Placed on (the default). Custom macros, the stance bar's forms (`noGlow`) and macros marked by Mark All Spells As Placed never glow; a spell learned after the mark still glows.

### Notes Under the Name

`OptionSubText` names the one option that is on, or `N Options` when several are, in the priority order of `OPTION_SUBTEXTS`. Stop Casting and Start Auto Attack count only when ticked on that spell, since their page-wide default would otherwise put a note on every spell. With no option on, the note is the spell's own subtext ("Rank 4", "Racial").

## Macro Options

`Features/Macro-Options.lua` owns which options a macro offers (`ns.OffersOption`, the `OFFERED` predicates; an option not listed there is offered on any spell with a target) and which are on (`ns.IsOptionOn`). Every per-spell setting is a table on the profile keyed by the spell's name as this client gives it, so one setting covers every rank, and a focus copy shares its spell's settings.

- **Defaulted options.** Enable Pet Attack, Stop Casting and Start Auto Attack have page-wide defaults. A spell stores `true` or `false` only where it differs from the default, so changing the default moves every spell that never overrode it. `ns.ToggleOption` writes `nil` whenever the new value equals the default.
- **Class gates.** Enable Pet Attack needs a combat pet class (Hunter, Warlock) and an enemy spell. Melee classes (Warrior, Hunter, Rogue) get the Start Auto Attack default and no Stop Casting option; everyone else gets the Stop Casting default. Leave Form Before Casting needs a form class (Druid, Shaman, Priest). Start Auto Shot (Hunter) and Start Wand (Mage, Priest, Warlock) exist only before MoP (`ns.EXPANSION < 5`).
- **Choices of one** are stored as two keys cleared together: the combat check (`combatOnly`, `noCombat`) and the rank (`targetRank`, `fixedRank`).
- **Use Items First** stores a list of slots in tick order, not a flag. The menu also lists a slot already ticked whose item no longer has a Use: effect, so it can be unticked after a gear swap.
- **Custom and equipment macros have no options menu.** A focus copy's menu only removes it.

The menu (`ShowMacroMenu`, `Features/Spellbook-Page.lua`) groups options into submenus that appear with their first offered option, labels each group with what is on in it, and ends with a live preview of the macro text and its byte count, red when over 255. A change that adds or removes a line reopens the menu next frame so the preview gets the right number of lines.

## Spellbook Hosts

The page (`ns.BuildSpellbookPage`) is host-agnostic: a host hands it a frame, optionally with its own `page.geometry`, and calls `ns.RefreshSpellbookPage` on show. Each host also defines `ns.ToggleSpellbookPage` for the key binding.

- **Classic engine** (`Spellbook-Host-Classic.lua`): a tab under the class's skill line tabs on `SpellBookFrame`, shown only over the spell pages, toggles a window of its own (`MacroSpellbookFrame`, 1100 x 660, two two-column pages, scaled down to fit and never up). Laying the page over the book's spell pages lost to UI skins (ElvUI restyles and re-layers the book), so the window stays clear of it. Tab and window are parented to `UIParent`, only the tab is anchored to the book, and the book's updates are watched with `hooksecurefunc`, so nothing Blizzard owns is written to. The window is in `UISpecialFrames` for Escape, and sits on the HIGH strata, which is why the settings menu's Open Options closes it first.
- **Retail engine** (`Spellbook-Host-Modern.lua`): registers a tab with LibSpellBookTabs-1.0 (`Spellbook-Tabs.lua`), which lays the tab out right of the native tabs, owns the parchment page over `PlayerSpellsFrame.SpellBookFrame`, closes other add-ons' pages when ours opens (and vice versa) and writes nothing Blizzard owns. The library registers through LibStub, so when another add-on embeds a newer copy, that copy runs for both. The settings menu is a `SpellBookSettingsDropdownTemplate` cog laid over the native one in the toolbar.

Templates and atlases the page uses (`SpellBookHeaderTemplate`, the `spellbook-item-*` atlases, `PortraitFrameTemplate`) are checked with `C_XMLUtil.GetTemplateInfo` and `C_Texture.GetAtlasInfo` first, each with a fallback, and the paging arrows are built by hand because Blizzard's paging template reads a format string the Classic engine's clients don't define.

## Unlearned Spells and Trainer Recording

Show Unlearned Spells (off by default; Vanilla, TBC and Camelot only) lists, desaturated and never glowing, the rank 1 of every class trainer spell whose name isn't learned. `ns.ForEachUnlearnedSpell` merges the flavor's `ns.TRAINER_SPELLS` for the class with this character's recorded trainer spells, sorts by level so a spell's lowest-level row is its rank 1, then appends the class lists' `extraSpells` (quest-learned spells and talents without trainer ranks). It filters by faction and race, skips passives, and treats a row as a higher rank when its subtext says so or it requires its own previous rank.

Trainer lists live on the server, so the trainer window is the only place the game shows them. `Trainer-Recording.lua` records each service's spell ID and required level into the profile's `trainerSpells` on `TRAINER_SHOW` and `TRAINER_UPDATE`, at class trainers only (`IsTradeskillTrainer`, then `C_Trainer.GetTrainerType`, excluding pet trainers). It records whatever the window's filters show. The spell ID comes from `C_TooltipInfo.GetTrainerService` on the Retail engine and from a hidden scan tooltip's `GetSpell` on the Classic engine. Recorded levels also feed the rank list (Ranks, above).

## Custom Macros

Each class's lists can carry default custom macros, as a `nameKey` (one of our own words, such as `CUSTOM_SPAM_WAND`) or a `name` template, an optional icon and a body template. `ns.FillMacroTemplate` replaces `{spell:ID}` with the client's spell name and `{family:ID}` with its creature family name, so defaults read right in every locale. The player's list is seeded once into the profile (`customMacrosSeeded`), and only once every name in it has loaded. Restore Defaults wipes the list and clears the flag; it is hidden for a class with no defaults, where it could only delete the player's own.

A custom entry is listed as written, with no options. `ns.CustomMacroProblem` gives the one reason it can't be: `"needs"` (no name or text), `"long"` (over 255 bytes) or `"taken"` (its trimmed name is in use by a spell, a focus copy or an earlier custom entry). The page warns once per session in chat and the Custom Macros panel shows a red status line; both read the same function. Its cell icon is the entry's icon, else the icon of the spell a leading `#showtooltip <spell>` names.

## Equipment Macros

One macro per equipped slot with a Use: effect, with the body `#showtooltip` and `/use <slot>`, so it keeps working when the item is swapped. `HasUseEffect` asks `C_Item.GetItemSpell` first, then the slot's tooltip for a line starting with the client's `ITEM_SPELL_TRIGGER_ONUSE`, which catches effects added to the item, such as engineering tinkers. The cells' slot labels come from GlobalStrings (`HEADSLOT`, `TRINKET0SLOT_UNIQUE`, ...).

## Key Binding

`Bindings.xml` declares `MACROSPELLBOOK_TOGGLE`, which calls the global `MacroSpellbook_Toggle()`; the Key Bindings list labels it with `BINDING_NAME_MACROSPELLBOOK_TOGGLE`. The name attribute is what the client saves a player's key against, so it never changes: a renamed binding comes back unbound for everyone. The General panel can't set a key itself, so its row shows the bound key (or the client's `NOT_BOUND`) and a Set Key button. `ns:OpenKeyBindings` tries, at click time, `Settings.KEYBINDINGS_CATEGORY_ID`, then a protected search of the Settings category list for the Key Bindings title, then the standalone `KeyBindingFrame`, and finally prints where to find the list using the client's own menu labels.

## Saved Variables

One SavedVariables table, `MacroSpellbookDB`, managed by AceDB-3.0 and created at `PLAYER_LOGIN`. Its top-level scopes are `global` (the welcome toggle and the record of general macros the add-on created), `profile` (every page setting, every per-spell option table, the custom macros and their seeded flag, the marks from Mark All Spells As Placed, and the recorded trainer spells) and `char` (the record of character macros the add-on created). `Data/Default-Settings.lua` is the full shape.

**Model: Per-Character.** Recorded trainer spells genuinely differ per character, and the macro options ride the profile with them because which spells a page lists is per class. `AceDB:New` omits the third argument, so each character gets its own `Name - Realm` profile. **Reset Profile clears that character's profile only:** every option, page setting, custom macro and recorded trainer spell. The welcome toggle and both ownership records survive. The ownership record lives in `global` and `char` rather than the profile because it describes the account's and the character's actual macro lists, which no profile switch, copy or reset changes (`README-Notes.md` records the `char` scope as an exception). A new setting about how this character's page behaves goes in `profile`; presentation goes in `global`.

AceDB applies `ns.DATABASE_DEFAULTS` the first time each scope is read, and keeps an explicitly stored `false`, so code never merges defaults by hand. A profile switch, reset or copy fires `ns:ApplyProfile`, which re-runs `ns:RefreshMacros` (the open page redraws and the owned macros are rewritten to the new profile's options) and calls `NotifyChange` on every registered panel.

The only seeded list is the custom macros: seeded once, tracked by `customMacrosSeeded`, after every name in the class's defaults has loaded, and again on Restore Defaults (Custom Macros, above). A default added in a later release reaches only players who restore defaults, so note it in the release notes.

### Migration Chain

Everything below carries `MIGRATION (remove after 2026-11-23)`, as do the Migrations TOC lines, the `SavedVariablesPerCharacter: MacroSpellbookCharDB` TOC line and the `MacroSpellbookCharDB` luacheck global.

1. `ns:MigrateLegacySavedVariables` (before `AceDB:New`): on a pre-AceDB table, moves the old top-level setting keys under `legacySettings`, so AceDB doesn't read them as its own.
2. `ns:ImportLegacySettings` (right after `AceDB:New`, once per profile via `legacyImported`): copies `legacySettings` onto this character's profile and its `MacroSpellbookCharDB.trainerSpells` into `trainerSpells`, then nils `MacroSpellbookCharDB`, which stops it being saved.
3. Ownership claim (`IsOwned`, `Features/Macro-Sync.lua`): a general spell or custom macro recorded as `true` by a release before owners were recorded is claimed by the first character to find it.
4. Ownership adoption (same function): an unrecorded macro whose body is exactly the page's current body (or the bare body for a spell macro) is adopted and recorded.

## Adding a New X

### A New Per-Spell Macro Option

1. Add the key to `profile` in `Data/Default-Settings.lua` as an empty table.
2. In `Features/Macro-Options.lua`, add its offer rule to `OFFERED` (or rely on the default: any spell with a target), and add it to the option list comments at the top of the file and above `ns.OffersOption`.
3. In `Features/Macro-Body.lua`, write its line in `CastBody` or `ns.MacroBody` at the point in the fixed order where it must run, reading it through `ns.IsOptionOn`.
4. In `ShowMacroMenu` (`Features/Spellbook-Page.lua`), add it with `addOption` under the group whose lines it writes. If it only changes the spell's own clauses, add it to `OWN_CLAUSES_ONLY`.
5. Add it to `OPTION_SUBTEXTS` at its priority, with a `SUBTEXT_*` key.
6. Add the `MENU_*` and `SUBTEXT_*` strings to `Locales/enUS.lua` only.
7. Run the Diagnostic Tools' Message Length report under ruRU, the overflow canary. It builds every page macro with every offered option on, so the new line's worst case shows against the 255-byte ceiling (`#body`, bytes).

### A Spell in a Class List

1. Open `Data/{Game}/Class-Spell-Lists-{Game}.lua` for each flavor where it is true, and add the spell ID to the right list (`mouseoverEnemy`, `cursor`, `channeled`, ...). Use a table of every rank's ID only where some locale names the ranks differently.
2. Check the same ID in the other six folders and say in the PR which copies changed and why the rest didn't.
3. Never hand-edit the `How We Got the Data` block; the Data Review owns it.

### A Default Custom Macro

1. Add an entry to the class's `customMacros` in each flavor's class lists. Name it with `nameKey` (a new `enUS.lua` key) when the name is our own words, or a `name` template when it is a spell's name. Write spell and family names as `{spell:ID}` and `{family:ID}`, never as text.
2. Check the filled body in ruRU stays under 255 bytes.
3. Existing players only get it through Restore Defaults; say so in the release notes.

### A Group Version

Add `[singleSpellId] = groupSpellId` to `Data/{Game}/Group-Versions-{Game}.lua` for each flavor that has both spells. The Right-Click For option appears on the single spell's menu once the group spell is learned.

### A New Registered Event

1. Add it to `ns.EVENT_NAMES` in `Features/Core.lua`, so the dispatcher and the Diagnostic Tools pick it up together, and map it in `EVENT_HANDLERS` to its `On<Event>` name.
2. Define `ns:On<Event>` in the feature file that owns it.
3. If that file is left out of some TOCs, also add the event to `LOGIN_REGISTERED_EVENTS`, so it is registered only where its handler loaded. Registering an event a client lacks throws.

## Localization

WoW ships a fixed locale set and every supported locale file already exists, so localization here is maintenance, not expansion.

- **`enUS.lua` is the source of truth** and the only file that passes `true` to `NewLocale("MacroSpellbook", ...)`. The other ten translate its key set. The Localization Review (`07 - Localization Review.md`) owns them; ordinary work edits `enUS.lua` only, and a renamed key is never reused.
- **Placeholders** must match `enUS` per key in every locale, in count, type and order (`CHAT_MACRO_TOO_LONG` is `%s`, `%d`, `%d`), or the string throws when formatted. `StatusText` formats every `OPTIONS_CUSTOM_STATUS_*` key with the same `(length, max)` arguments, so only the `TOO_LONG` one may use them.
- **Game names never go in `Locales/`.** Spells are stored as IDs in `ns.CLASS_SPELL_LISTS`, `ns.TRAINER_SPELLS`, `ns.GROUP_VERSIONS` and `AUTO_SHOTS`, named by `C_Spell.GetSpellName` (rank text by `C_Spell.GetSpellSubtext`); pet families by ID through `C_CreatureInfo.GetCreatureFamilyInfo`; slot names and client labels (`SPELL_REQUIRED_FORM`, `ITEM_SPELL_TRIGGER_ONUSE`, `ERR_NOT_IN_COMBAT`, `SETTINGS`, `PAGE_NUMBER`, `NOT_BOUND`, `KEY_BINDINGS`, `SETTINGS_KEYBINDINGS_LABEL`, `GAMEMENU_OPTIONS`) are GlobalStrings read directly. The page's client strings, the slot names and every class-list, group-version and ranged-attack spell have a row in `ns.DIAGNOSTIC_NAME_LOOKUPS`.
- **Not localized on purpose:** equipment macros' WoW names (`Use Head`), which are identifiers on players' bars, and the ` @F` focus suffix.

Everything else (the Spanish file pairing, the overflow canary, the output ceilings) follows the Style Guide's LOCALIZATION and MESSAGES → Message Length.

## Common Pitfalls

- **Matching spells by name**: every option, list and setting is keyed by the name this client gives the spell, never by text we type. A list ID the client can't name yet silently loses its options, so new list entries are checked in the Diagnostic Tools' Page Context report and Game Names.
- **Writing macros in combat**: `EditMacro` and `CreateMacro` are blocked. Every write goes through `SyncAt` behind `InCombatLockdown` checks, and `ns:RefreshMacros` queues a replay on `PLAYER_REGEN_ENABLED`; a click in combat refuses with the client's own error.
- **Editing a macro the player made**: the add-on edits only names in its ownership record (`IsOwned`). Never sync or delete by name alone.
- **Two general macros of one name**: they can't be told apart, so a character finding another character's general spell macro makes its own character macro instead. Equipment macros are the one shared exception.
- **Macro names over 16 bytes**: `CreateMacro` truncates them and a full-name lookup then misses. Always compare `macro.macroName` (`ns.TrimMacroName`, UTF-8 safe), never `macro.name`.
- **Over 255 bytes**: a longer body would be cut off mid-line, so it is never written (`Fits`, `ns.MacroBlockReason`) and the player is warned once. Test option combinations under ruRU with the Message Length report, not enUS.
- **Seeding before names load**: a default custom macro filled while a spell name is nil would save a blank. `ns.DefaultCustomMacros` returns nil until every name resolves, and seeding waits.
- **Storing a defaulted option as a plain flag**: storing `false` where it equals the default pins that spell against later default changes. `ns.ToggleOption` stores only differences.
- **Picking an engine's code path by flavor**: the engines differ in APIs, not flavors. Each branch checks for the API (`C_SpellBook.GetNumSpellBookSkillLines`, `C_TooltipInfo`, `Constants.MacroConsts`) or the template it needs, resolved once at load, and the TOC chooses the host file.
- **Parenting the Classic window to the spellbook**: it would taint the book and lose to UI skins. The window and tab stay on `UIParent`, and `SpellBookFrame` is only hooked.
- **Start Auto Shot and Start Wand on MoP and later**: Auto Shot is automatic and wands are gone there, so `AUTO_SHOTS` applies only while `ns.EXPANSION < 5`.

## Contributing

Report bugs and suggestions on the [GitHub Issues tab](https://github.com/Gogo1951/Macro-Spellbook/issues), or talk them through on [Discord](https://discord.gg/eh8hKq992Q).

A useful bug report names the game version and locale, your class and level, the steps to reproduce it, and the macro text involved (hover the page cell, or right-click it for the options preview) or the chat line you saw. A Diagnostic Tools report (Options > AddOns > Macro Spellbook > Diagnostic Tools) settles most "nothing happens" reports.

PR guidelines:

- **One concern per PR.**
- **Match the house style**: StyLua default with `--syntax lua51`, clean `luacheck .` and `luac -p`, few comments.
- **Saved-data changes carry a migration**, tagged with its remove-after date, for the data players already have.
- **Output length**: any change to macro text or chat output is checked against the 255-byte macro ceiling and 16-byte name ceiling under ruRU (Style Guide → MESSAGES → Message Length).
- **Update this document** if the architecture or file map changes.
- **PR descriptions say what a player will notice**, in plain language, the way release notes do; commit messages carry the developer detail.
