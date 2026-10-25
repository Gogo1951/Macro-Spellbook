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
├── .pkgmeta                               Externals and ignore list; tools/ and Data/Wrath/ stay out of the zip
├── Bindings.xml                           The Toggle Macro Spellbook binding; auto-loaded, never in a TOC
├── MacroSpellbook_Vanilla.toc             Classic Era, Season of Discovery included
├── MacroSpellbook_TBC.toc                 TBC Anniversary
├── MacroSpellbook_Camelot.toc             WoW Forever
├── MacroSpellbook_Mists.toc               MoP Classic
├── MacroSpellbook_Mainline.toc            Retail
├── Data/
│   ├── Flavor.lua                         Canonical flavor identity
│   ├── Data.lua                           Macro limits, icons, section base rank, links, registry names, palette, ink colors
│   ├── Default-Settings.lua               The AceDB defaults, ns.DATABASE_DEFAULTS
│   ├── LICENSE-Trainer-Data               MIT notice that travels with the trainer tables
│   ├── Vanilla/
│   │   ├── Class-Spell-Lists-Vanilla.lua  Per class: option lists, pets, stances, extra spells, default custom macros
│   │   ├── Group-Versions-Vanilla.lua     Single-target spell to its group version; spell groups
│   │   └── Trainer-Spells-Vanilla.lua     Every class trainer rank, by level
│   ├── Discovery/                         Same three tables; paired with Vanilla/ in the Vanilla TOC
│   ├── TBC/                               Same three tables
│   ├── Camelot/                           Same three tables
│   ├── Mists/                             Same three tables; ns.TRAINER_SPELLS is empty
│   ├── Wrath/                             Same three tables, all empty; no TOC, kept out of the zip
│   └── Mainline/                          Same three tables, all empty
├── Diagnostics/                           Diagnostic Tools framework, copied from Magic Eraser
│   ├── Diagnostics-Core.lua
│   ├── Manifests.lua                      This add-on's manifests and the Page Context and Macro Context probes
│   ├── Event-Log.lua
│   ├── Code-Reports.lua
│   ├── Settings-Reports.lua               Display Context: screen scale and where the book, tab and page sit
│   ├── Validate-Data.lua
│   ├── Localization-Reports.lua           Message Length: every page macro with every offered option on
│   ├── Report-Runner.lua
│   └── Options-Diagnostics.lua
├── Features/
│   ├── Core.lua                           Version, AceDB init at PLAYER_LOGIN, ns:ApplyProfile, the event dispatcher
│   ├── Utilities.lua                      Colors, UTF-8-safe name trim, the spellbook walk, tooltip and trainer readers
│   ├── Announcements.lua                  Chat prints: ns:PrintMessage and ns.WarnOnce
│   ├── Migrations.lua                     MIGRATION (remove after 2026-11-23): pre-AceDB settings, Spammable, Buffs kind
│   ├── Macro-Options.lua                  Which options a macro offers and has on, kind defaults, combat check, rank
│   ├── Macro-Copies.lua                   Duplicate copies: numbering, copied settings, removal
│   ├── Macro-Body.lua                     Option state to macro text, the tag line, MacroSpellbookMute
│   ├── Custom-Macros.lua                  The player's custom macros: seeding, templates, problems
│   ├── Equipment-Macros.lua               One /use macro per equipped on-use slot
│   ├── Macro-Builder.lua                  Builds ns.macros from the spellbook and class lists: ranks, focus copies, order
│   ├── Unlearned-Spells.lua               Show Unlearned Spells source; Vanilla, TBC and Camelot TOCs only
│   ├── Trainer-Recording.lua              Records class trainer services; same TOCs as above
│   ├── Macro-Sync.lua                     Finds, creates and rewrites the WoW macros; scans the action bars
│   ├── Dynamic-Rank.lua                   Rewrites Dynamic Rank macros as the target and mouseover change
│   ├── Macro-Menu.lua                     A macro's right-click options menu
│   ├── Spellbook-Paging.lua               The page arrows, built by hand
│   ├── Macro-Button.lua                   One macro's cell: icon, note, glow, tooltip, click and drag
│   ├── Spellbook-Page.lua                 Sections and pages, the settings menu, slot counts, page events
│   ├── Spellbook-Host-Classic.lua         Classic-engine host: the book tab and MacroSpellbookFrame window
│   ├── Spellbook-Tabs.lua                 Retail-engine tab placement and parchment page (ns.SpellbookTabs)
│   ├── Spellbook-Host-Modern.lua          Retail-engine host: registers the page's tab
│   └── Key-Bindings.lua                   Binding globals and the Set Key route to the game's Key Bindings list
├── Includes/
│   └── Libraries/                         Vendored Ace3, CallbackHandler, LibStub; never edited
├── Locales/
│   ├── enUS.lua                           Source of truth
│   └── deDE.lua ... zhTW.lua              The other ten locales
├── Options/
│   ├── Options-Utilities.lua
│   ├── Options-General.lua                Welcome toggle, Key Bindings row, /Commands
│   ├── Options-Spellbook-Page.lua         The page-wide toggles
│   ├── Options-Macro-Defaults.lua         A box per macro kind: the options its spells start with
│   ├── Options-Custom-Macros.lua          One row per custom macro, Add and Restore Defaults
│   ├── Options-Profiles.lua
│   ├── Options-Feedback-Support.lua
│   └── Options.lua                        Registration, ns:OpenOptionsPanel, /msb
├── tools/
│   └── gen_trainer_data.py                Dev only: regenerates a Trainer-Spells file; never shipped
├── LICENSE                                MIT, original author kept; ships in the zip
├── README.md
├── README-Notes.md                        This add-on's exceptions to the Style Guide
├── README-Technical.md
└── README-Testing.md
```

**Gone on purpose; don't bring them back.** `Includes/Libraries/LibSpellBookTabs-1.0/` was replaced by `Features/Spellbook-Tabs.lua`, the add-on's own module on `ns.SpellbookTabs`, not a LibStub library: it has no packager external, and CI fails any `Includes/Libraries/` folder without one. `.github/workflows/lint.yml` and `release.yml` were replaced by the Common-Core `ci.yml` and `package.yml` callers. The unsuffixed `MacroSpellbook.toc` and the old `src/` tree are gone too: every flavor has its own TOC, and the code lives under `Data/`, `Features/` and `Options/`.

**Flavor split.** The Classic engine (Vanilla, TBC, Mists) loads `Spellbook-Host-Classic.lua`; the Retail engine (Camelot, Mainline) loads `Spellbook-Tabs.lua` and `Spellbook-Host-Modern.lua` instead. `Unlearned-Spells.lua` and `Trainer-Recording.lua` load only on Vanilla, TBC and Camelot, where class trainers teach the ranks the bundled trainer data lists. Otherwise the five TOCs match line for line apart from `## Interface`, `## X-Flavor` and their data folder.

## Architecture

### Event Loop

`Features/Core.lua` owns the only event frame. `ns.EVENT_NAMES` is the complete event surface, read by both the dispatcher and the Diagnostic Tools. `EVENT_HANDLERS` maps each event to an `ns:On<Event>` name that is looked up when the event fires, so feature files loading after Core supply their own handlers. The dispatcher taps `ns:LogEvent` first, behind a single `ns.diagnostics.logging` check, then calls the handler.

Most events register at file load. `TRAINER_SHOW` and `TRAINER_UPDATE` are in `LOGIN_REGISTERED_EVENTS` instead: `ns:RegisterFeatureEvents()` registers them at `PLAYER_LOGIN`, and only when their handlers exist, because the Mists and Mainline TOCs leave `Trainer-Recording.lua` out.

| Event | Handler does |
|---|---|
| `PLAYER_LOGIN` | Runs the pre-AceDB migration, creates `ns.db`, wires the profile callbacks, runs the other migrations, registers the options panels and the trainer events, prints the welcome. |
| `SPELLS_CHANGED` | Refreshes any open page, once per burst. With no page open, wipes `ns.macros`, so the next Dynamic Rank rewrite rebuilds it with the new ranks. |
| `PLAYER_EQUIPMENT_CHANGED` | Drops the on-use slot cache, then refreshes any open page. |
| `SPELL_DATA_LOAD_RESULT` | Refreshes the open page once per burst when the loaded spell is a rank the last read was missing (`ns.TakePendingRank`) or Show Unlearned Spells is on. Can fire before `ns.db` exists, so it checks. |
| `ACTIONBAR_SLOT_CHANGED` | Redraws only the glows, once per burst. |
| `UPDATE_MACROS` | Redraws every visible cell (block reasons, glows) and the slot counts, once per burst, since a sync fires one event per edited macro. |
| `PLAYER_TARGET_CHANGED` | Queues a rewrite of every Dynamic Rank macro. |
| `UPDATE_MOUSEOVER_UNIT` | Queues a rewrite of the Dynamic Rank macros that also cast on the mouseover. |
| `PLAYER_REGEN_DISABLED` | Rewrites every Dynamic Rank macro at once, the last moment before combat locks them. |
| `PLAYER_REGEN_ENABLED` | Replays a macro sync deferred during combat. |
| `UPDATE_BINDINGS` | Repaints the General panel so its Key Bindings row shows the new key. |
| `TRAINER_SHOW`, `TRAINER_UPDATE` | Record the class trainer's services. `TRAINER_UPDATE` also fires on filter changes. |

Every "once per burst" is the same pattern: a pending flag plus `C_Timer.After(0, ...)`, so a storm of events costs one redraw on the next frame.

### Combat Lockdown

`CreateMacro`, `EditMacro` and `PickupMacro` are protected in combat. Clicks refuse; background writes defer.

- **Refuses outright and says why.** `ns:OpenOptionsPanel` prints `CHAT_OPTIONS_IN_COMBAT` and returns; it never queues. `ns:OpenKeyBindings` prints `CHAT_KEY_BINDINGS_IN_COMBAT`. `ns.PickupMacro` (a click or drag on a cell) puts the client's own `ERR_NOT_IN_COMBAT` in red on `UIErrorsFrame`.
- **Defers and replays.** Every write path checks first. A menu change (`ns.ChangeMacro`, running one of the setters such as `ns.ToggleOption` or `ns.SetCombatCheck`) recomputes `macro.body` in memory, so the cell, tooltip and menu show the new text at once, then calls `ns.QueueMacroSync` instead of `ns.SyncMacro`. `ns.SyncAllMacros` does the same, which covers a page refresh and `ns:RefreshMacros` (an options-panel change, a profile switch, reset or copy). `ns:OnPlayerRegenEnabled` replays the queued sync once through `ns:RefreshMacros`.
- **Dynamic Rank rewrites** run out of combat only (`RanksRewritable`, `Features/Dynamic-Rank.lua`). `PLAYER_REGEN_DISABLED` rewrites them all one last time, so combat starts on the highest rank wherever no low-level unit is targeted or moused over. In combat a macro keeps the ranks it last had.
- **Not guarded.** The Classic host's window (`MacroSpellbookFrame`) is an ordinary frame on `UIParent`, and the Retail page's frames are parented to `UIParent` too, so opening, closing and drawing the page need no combat check.

### Read → Build → Write → Draw

The page is rebuilt from scratch every time it is shown (`ns.RefreshSpellbookPage`, the page's `OnShow`) and after any change that touches its list.

1. **Read** (`Features/Utilities.lua`). `ns.ForEachClassSpell` walks every learned, castable, non-passive spell in skill line order, General included, and is chosen once at load by whether `C_SpellBook.GetNumSpellBookSkillLines` exists. The Retail engine reads `C_SpellBook` skill lines, skipping hidden and off-spec lines and off-spec items; the Classic engine reads the spell tab globals. The name is always the spell's own by ID (`CastName`), because the book shows some spells under a name `/cast` can't use, such as Call Pet as "Call" plus the pet's name. On Classic Era outside Season of Discovery, IDs of 300000 and up are skipped: the client shares its book with SoD and can list rune abilities Era can't cast. On MoP Classic the Call Pet flyout (flyout 9) becomes one macro under its book name, using its first known spell for the icon and tooltip, and the flyout's own spells are left out.
2. **Resolve** (`ResolveClassConfig`, `Features/Macro-Builder.lua`). The player's class entry in `ns.CLASS_SPELL_LISTS` is turned from spell IDs into this client's names: enemy, friend, buff, cursor, stealth and toggle sets, pet abilities with their creature family names, stances and stance slots, group versions both ways, spell groups, the ranged attack. The stance bar's forms are marked as never glowing and, except Warrior stances and stealth, as toggles.
3. **Build** (`ns.CollectMacros`). `ReadSpellbook` collects each spell's ranks with their learn levels. Then one macro table per learned spell (`MakeMacro`), its focus copy when Focus is on, its Duplicate copies, then the custom macros, the equipment macros and, with Show Unlearned Spells, the unlearned spells. Each table carries its capabilities (`target`, `buff`, `cursor`, `stances`, `ranks`, `petAbility`, ...), its `kind` (`ns.MacroKind`) and its `body` from `ns.MacroBody`. The list is then sorted (Page Sections and Order, below). A build also marks the Dynamic Rank bodies stale, so the next rank rewrite writes every one.
4. **Write** (`ns.SyncAllMacros`, `Features/Macro-Sync.lua`). Every page macro that already has a WoW macro gets `EditMacro` only when the stored body differs from the page's and fits in 255 bytes. Nothing is created here: creation waits for the player's first click or drag.
5. **Draw** (`Layout`, `Features/Spellbook-Page.lua`). `Paginate` flows the sorted list into page halves; each visible cell is a pooled button pointed at its macro by `ns.SetMacroButton` (`Features/Macro-Button.lua`), which also works out its block reason, glow and note.

A change made away from the page (options panel, profile change) goes through `ns:RefreshMacros`: refresh the open page if there is one, otherwise run steps 1 to 4 without drawing. Callers that need the list with no page open (`ns.MacrosOfKind`, `ns.CustomMacroTakenNames`, the Custom Macros section picker, the Dynamic Rank rewrite) build it first when `ns.macros` is empty.

### Spell and Item Data Caching

- **Spell names load late.** `ns.SpellName` returns nil for a spell whose data isn't loaded and calls `C_Spell.RequestLoadSpellData` for it once per session (the `requested` set), so an ID that never loads can't keep the page redrawing. A list entry whose name is nil simply doesn't match, so that spell loses its options until the next build, and the class config is resolved again at the start of every `ns.CollectMacros` to pick up names that loaded since.
- **Ranks wait for their names.** A trainer rank whose name wasn't loaded when the book was read goes into `pendingRanks`; when its `SPELL_DATA_LOAD_RESULT` arrives, `ns.TakePendingRank` clears it and the open page redraws once.
- **Default custom macros wait for every name.** `ns.DefaultCustomMacros` returns nil while any `{spell:ID}` or `{family:ID}` in a template is unresolved, so seeding never writes a blank name into a macro.
- **On-use slots** (`ns.UsableSlots`, `Features/Equipment-Macros.lua`) are cached until `PLAYER_EQUIPMENT_CHANGED`, and each item link's answer is kept for the session, so the page and its menus don't rescan nineteen tooltips on every redraw. Item names come from the link text, so there is no `C_Item.GetItemInfo` cold-call to wait on.

## Macro Kinds and Defaults

Every spell macro has a kind (`ns.MacroKind`, `Features/Macro-Options.lua`), decided in this order: `ground` (a cursor spell), `buff` (in the class lists' `buffs` and cast on a friend), `enemy`, `friendly` or `anyone` (by its target), `form` (a stance-bar form or a spell that cancels when cast again), else `self`. Custom and equipment macros have no kind.

Each kind has its own defaults, `ns.db.profile.kindDefaults[kind]`, for the options in `ns.DEFAULTABLE_OPTIONS`. A macro's own setting is stored only where it differs from its kind's default (`SetOption` writes `nil` otherwise), so changing a default moves every macro that never overrode it. `ns.SetKindDefault` stores `true` or `false`, never `nil`, so turning off a default the add-on ships on (Buffs start on Dynamic Rank) sticks against AceDB's defaults.

The Macro Defaults panel (`Options/Options-Macro-Defaults.lua`) shows a box per kind the class has spells of, naming the first six, then the combat check and how often it casts, and the options under the menu's group names, hiding any option none of that kind's spells offers. A macro menu's **Make Default For <Kind>** reads every offered option's current value first, then writes them all as the kind's defaults and clears the macro's own settings, since changing a default moves everything that follows it.

What a macro offers is `ns.OffersOption`: the `OFFERED` predicates, and for a key not listed there, any spell with a target. Highlights:

- Start Pet Attack: every enemy spell, whatever the class (a Shadowfiend or a mind-controlled enemy counts).
- Stop Casting: every spell and equipment macro. Start Auto Attack: every spell but a stealth spell's, a Friendly Spell's or a Buff's, unless that macro already has it on, so it can be turned off.
- Focus: any spell with a target, except on the Vanilla TOC (the Classic Era client has no focus) and on a Duplicate copy.
- Start Auto Shot or Start Wand: a ranged enemy spell other than the ranged attack itself, when the class lists carry an `autoShot` spell. Mists carries none, since Auto Shot is automatic and wands are gone there.
- Leave Form Before Casting: any spell but a form, a toggle or stealth.
- Rank: any spell with more than one rank. Dynamic Rank only on a spell that can go on a friend, with more than one known rank.
- Choices of one are two keys cleared together: the combat check (`combatOnly`, `noCombat`), how often it casts (`oncePerTarget`, `oncePerCombat`) and the rank (`targetRank`, `fixedRank`).
- Use Items First stores a list of slots in tick order, not a flag.

## Macro Text

`ns.MacroBody` (`Features/Macro-Body.lua`) is the only writer of a spell or equipment macro's text. It reads every option through `ns.IsOptionOn`, so an option that isn't offered on a macro can never leak into its text. Lines are written in a fixed order:

```text
#showtooltip Shadow Bolt
/stopmacro [nocombat]
/run MacroSpellbookMute(1)
/stopcasting
/targetenemy [noexists][dead][help]
/use 13
/cast [@mouseover,harm,nodead][] Shadow Bolt
/cast !Shoot
/petattack
/run UIErrorsFrame:Clear()
/run MacroSpellbookMute()
#4K
```

That is a Warlock's Shadow Bolt with Mute Error Sounds, Stop Casting, Target Nearest Enemy, a trinket under Use Items First, Only In Combat, Cast On Mouseover, Start Wand, Start Pet Attack and Hide Error Messages on. The full order: one `/stopmacro` carrying `[channeling]`, `[stealth]` and the combat check's `[nocombat]` or `[combat]` (Stop Macro If Channeling, Stop Macro If Stealthed, In Combat, Out Of Combat), ahead of the mute so a stopped press never leaves the sounds muted; the mute; `/stopattack`; `/stopcasting`; `/cancelform`; `/targetenemy` and `/targetfriend`; the Use Items slots in the order ticked; the stance switch; the cast line; Auto Shot or the wand; `/startattack [nostealth]`; `/petattack`; the error clear; the unmute; and the tag line.

- **The cast line is built from clauses.** Each clause is a condition, the unit it tries and the spell. Neighbouring clauses casting the same spell share it (`[@mouseover,help,nodead][help,nodead][@player] Flash Heal`), and a lone clause with nothing to check drops its brackets, so a macro with no options on is `ns.BareBody(name)` (`#showtooltip` and `/cast Name`) plus its tag line. Who it tries, in turn, is its target priority (`ns.TargetPriority`): up to three of Target, Self, Pet, Focus, Target of Target and Mouse Over, each as `[@unit,<help|harm|exists>,nodead]`, then the plain cast; the target last is that plain cast, and nothing after Self is ever tried. A spell follows its kind's priority until given its own; one nobody set comes from the old Cast On Mouseover, Cast On Self and Cast On Target's Target settings (mouseover, target, target's target, player), so older profiles cast as they did with no migration. An enemy spell can't pick Self or Pet, and Classic Era, with no focus, can't pick Focus. Cast At Cursor replaces all of that with `[@cursor]`.
- **The combat check** stops the whole macro on the wrong side of combat through the `/stopmacro` line, so an item, Auto Attack, the pet or the wand never fires there either, and the cast line keeps no combat condition, so the button still shows the spell.
- **Cast Once Per Target and Cast Once Per Combat** turn the line into `/castsequence reset=target Name, NULL` (or `reset=combat/target`). Once Per Combat also resets on a target change, so a new pull mid-combat can take the cast again.
- **`#showtooltip` names the spell** whenever there is a stance switch, a Use Items line or a cast sequence, because the button would otherwise show the wrong step. A summon macro with Cast <ability> If Summoned names both, as its cast line does (`#showtooltip [pet:Felhunter] Spell Lock; Summon Felhunter`).
- **Right-Click For** puts `[btn:2]` clauses casting the learned group version (Prayer of Fortitude, Portal: Ironforge) in front of every other clause, one per unit the left-click tries; on a group spell it casts the learned single version (Arcane Intellect, Teleport: Ironforge). With Dynamic Rank the right-click takes its own spell's ranks by each unit's level too, so a right-click Power Word: Fortitude on a low-level player doesn't fail as too low level. A long priority with a right-click can run past 255 bytes, which the page warns about.
- **Grouped Spells** casts, of the spells ticked in the macro's `SPELL_GROUPS` group, the last one learned (`ns.CastSpellName`): Demon Armor on a Demon Skin macro with both ticked. The spell cast in another's place takes its highest rank, since the macro's ranks are its own spell's.
- **A summon macro** with Cast <ability> If Summoned is `/cast [pet:<family>] <ability>; <summon>`. `[pet:X]` matches the creature family, so another demon being out still summons this one.
- **Never Turn Off** casts `!Name`, which refreshes a form or aspect instead of cancelling it.
- **Equipment macros** go through the same builder with `/use <slot>` in place of `/cast Name` and a target of `exists`, since the item may go on a friend or an enemy.

### Ranks

`ReadSpellbook` lists each spell's ranks highest first, as `{ text = "Rank 4", level = 38 }`, and only where the learn level is known: the flavor's `ns.TRAINER_SPELLS` (rows for this faction and race), then this character's recorded trainer spells, then `C_Spell.GetSpellLevelLearned` where the client has it. The Classic book lists only each spell's highest rank unless Show All Spell Ranks is ticked, so the trainer ranks the player knows (`IsPlayerSpell`) are added from their IDs, and then the ones not learned yet as `unknown`, after the known ones so an unknown ID never takes a known rank's text.

- **Spell Rank** is a choice of one: a fixed rank by its text, Max Rank (nil, the default, a plain cast), or Dynamic Rank (`targetRank`). The menu's Rank submenu lists every rank from Rank 1 up, the unknown ones in red with their learn level and disabled. `ns.FixedRank` ignores a stored rank the player no longer knows.
- **Dynamic Rank** names, per clause, the highest known rank the clause's unit can take: a rank lands on a player at most `RANK_LEVEL_GAP` (10) levels below its learn level. An absent, unassistable or level-unknown unit gets the plain cast; a unit below every rank gets the lowest, which then fails with the game's own message.
- **Rewrites follow the units** (`Features/Dynamic-Rank.lua`). A target change rewrites every Dynamic Rank macro on the next frame (`QueueRankRewrite`), a mouseover change only those that also cast on the mouseover. The game says when a unit comes under the cursor but not when it leaves, so while a mouseover exists `PollMouseover` checks every 0.2 seconds and rewrites back to the highest rank once it's gone. After a rebuild (`rankBodiesSynced` false, set by `ns.MarkRankBodiesStale`) the next rewrite writes every Dynamic Rank body once; after that only a body that changed is written, so most mouseovers never read the macro list. Nothing runs at all unless some macro or kind default has Dynamic Rank on (`ns.AnyTargetRank`).

### Stances

`ns.StancesOf` reads only the class lists' `stances` (spell ID to the stance IDs it can be cast in). The spell's tooltip is never matched: it prints the forms' names, which esES names differently from the stance spells. A stance's `[stance:n]` slot comes from the stance bar, or from `stanceSlots` (learn order) for a Warrior stance not learned yet; a first stance with no known slot writes no switch line at all. The line is `/cast [nostance:1/3] Battle Stance`.

### Mute Error Sounds

Mute Error Sounds is the one place the add-on writes CVars, and `MacroSpellbookMute` is the one global a macro body reaches through `/run`. `MacroSpellbookMute(1)` reads `Sound_EnableSFX` and `Sound_EnableErrorSpeech`, sets only the ones that are on to `"0"`, and remembers what it read; `MacroSpellbookMute()` on the macro's last line puts back exactly those values. The error sound plays while the `/cast` line runs, so muting around it silences the "woosh" or the voice, while the spell's own sound still plays because the cast starts after the macro ends. A `C_Timer.After(1, ...)` restore covers a macro whose last line never runs. The write is momentary, so it prints nothing.

## Macro Ownership and Tags

`Features/Macro-Sync.lua` decides which WoW macro a page entry is, and edits only macros the add-on created. A player's own macro that happens to share a spell's name is never touched.

- **The tag line.** Every body the add-on writes ends in `#<tag>`, such as `#4K` (`ns.TaggedBody`, `Features/Macro-Body.lua`). WoW runs only the `#` lines it knows, so the line does nothing; it is how the page finds its macros, whatever they are called. Only the body's last line is read as a tag, so a short `#` line higher up in a player's custom macro is never taken for one. The tag lives in the body, not the name, because the name has only 16 bytes, shows on the action bar, and a translated name fills it sooner. A tag is two base-62 digits handed out in turn from an account-wide register (`ns.db.global.macroTags`, counter `macroTagCount`), so no two macros ever share one, which a hash this short couldn't promise; past 3,843 tags they run to three. A page macro gets its tag only when a WoW macro is written for it (`ns.AssignMacroTag`); until then its body carries `00`, which is never handed out, so its length is already right. The line costs `ns.MACRO_TAG_LENGTH` (4) bytes toward the 255, and the tooltip and the menu's preview leave it out (`ns.UntaggedBody`).
- **Register keys.** An equipment macro registers as `slot:<n>`, which every character shares like the general macro itself. Everything else registers as `<character key>:<kind>:<name>`, with kind `spell`, `focus`, `copy<n>` or `custom`, so a character only ever finds its own. The `slot:` prefix can't collide with a character key, which always holds ` - ` between name and realm.
- **The ownership record.** Character macros the add-on made are listed in `ns.db.char.ownedMacros` as `true`. General ones are in `ns.db.global.ownedMacros`: an equipment macro as `true`, and any other as the AceDB key of the character that created it, the only character that rewrites it. Records are still written on creation, so a macro whose tag line the player deletes is found by name again.
- **General or character** comes from the index alone: general macros are indexes `1..MAX_ACCOUNT_MACROS`, character ones follow. The slot limits come from `Constants.MacroConsts` (Retail engine) or the `MAX_*_MACROS` globals (Classic engine), falling back to 120 and 30.
- **Lookup** (`ns.FindMacroIndex`, over one `ns.ReadMacroIndexes` pass): the macro carrying the page macro's tag, else an untagged one of its name that `ns.LegacyOwnership` says is the add-on's, character macros first. A tagged macro is indexed by its tag only, never by name. The next `ns.SyncMacro` records the one it found by name and writes its tag, and updates the pass's index so a second page macro of the same name can't take it too.
- **Creation** (`ns.PickupMacro`, first click or drag): a character macro while character slots are free, else a general one; equipment macros are always general. A spell or equipment macro's icon is the question mark (`134400`), which lets `#showtooltip` show the spell's own icon on the bar. Then `PickupMacro` puts it on the cursor. A full list puts a red error on `UIErrorsFrame`, prefixed with the Short Name: `ERROR_MACRO_SLOTS_FULL`, or `ERROR_GENERAL_MACRO_SLOTS_FULL` for an equipment macro.
- **Deleting** (`ns.DeleteAddonMacros`, the General panel's Delete Character Macros and Delete General Macros buttons): deletes the add-on's macros from this character's list or from the General list, which every character shares; another character's own list can't be reached from here. A macro counts as the add-on's only when its tag is one the register handed out and its name has an ownership record, so a player's macro whose last line reads like a tag (`#end`) is never deleted. A sync runs first, so macros from before the tags are tagged and go too. The deleted names' records are cleared, so a player's own macro later given one of those names is never adopted. The register keeps the tags, so a macro placed again gets its old tag back. Blocked in combat; each button is behind a confirm and greyed out while its list holds none (`ns.CountAddonMacros`).
- **Block reasons** (`ns.MacroBlockReason`) are shared by the cell and the click so they never disagree. The only one is `"long"`, a body over 255 bytes with its tag line: it is never written, the player is warned once per session (`CHAT_MACRO_TOO_LONG`), and the cell says so in red in place of its note. A macro of the same name never blocks one: WoW allows two macros of one name, and the tags tell them apart.

### Macro Names

A WoW macro name holds 16 bytes, and `CreateMacro` truncates longer ones, so a lookup by the full name would miss. Every WoW macro the add-on makes is named `ns.MACRO_NAME_PREFIX` (`~`) plus the page macro's `macroName` (`ns.WowMacroName`, so `~Divine Spirit`), which keeps them together in `/macro`, after the player's own. That leaves `ns.MACRO_NAME_MAX_LENGTH` (15) for `macroName`: `ns.TrimMacroName` cuts to it and backs up to the start of any UTF-8 character the cut would split. `macroName` itself, without the prefix, is what the page compares and keys settings by. A focus copy trims to 12 and appends ` @F`; a Duplicate copy trims to make room for ` <n>`. Equipment macros are named `Use Head`, `Use Trinket 1` and so on, in English in every locale, because those names tie macros already on players' bars to the add-on (`README-Notes.md`). While building, a `taken` set keeps custom, equipment and unlearned entries off a name already in use, in that order of precedence after the spells.

Macros from before the prefix (MIGRATION, remove after 2026-11-23) are found under their old 16-byte name when neither the tag nor the new name finds them, and `SyncAt` renames them, moving their ownership record; the game keeps them on the bars. Only a macro still under its old name is renamed, so a name the player gave a tagged macro stays. A rename can move a macro within its list, so `ns.SyncMacro` returns the index it ends up at and reads the pass's indexes again.

### Focus and Duplicate Copies

- **A focus copy** (`MakeFocusMacro`, `Features/Macro-Builder.lua`) is a separate page entry with its own WoW macro, casting `[@focus,<target>,nodead]` then the target. It shares its spell's settings, and its menu only removes it. Most options rewrite the copy too; the ones that only shape the spell's own clauses (the target priority, Cast At Cursor, Cast <ability> If Summoned) don't. The menu rebuilds the page after every change either way.
- **A Duplicate copy** (`ns.DuplicateMacro`, `Features/Macro-Copies.lua`) lists the spell again as "Drain Soul 2", with its own WoW macro and its own settings under the key `Drain Soul #2`, which no spell is called. It starts with a copy of the source macro's settings (`COPIED_SETTINGS`: every defaultable option plus pet, stance, group version, fixed rank, Use Items and Grouped Spells). `ns.db.profile.macroCopies` holds each spell's copy numbers in the order made, starting at 2; a number is never reused while a later one stands, so a copy keeps its name. Removing a copy drops its settings and leaves its WoW macro where it is, so nothing the player placed stops working; the add-on just stops rewriting it.

## Page Sections and Order

Sections follow the spellbook's own tabs: General, then the class's trees or specs, each ranked by its skill line index, recorded in `categoryRankByName` as the book is read.

- **Custom macros** list under Custom, or with a tab's spells when their section names a tab. Other custom sections take ranks from `ns.TAB_SECTION_BASE` (100) plus their first entry's index, so they follow the tabs in order of first use. A section that no longer names a tab still shows, under its own name.
- **Equipment** takes `ns.TAB_SECTION_BASE + #customMacros + 1`, after every custom section.
- **Unlearned** sorts last (`math.huge`).
- Within a section: spells before custom macros, then spellbook order (learn level for unlearned spells), then name, then copy number, each focus copy straight after its spell.

`Paginate` flows the sorted list into page halves of `CELL_HEIGHT` (52) rows with a `CATEGORY_GAP` (12) between sections, repeating a section's header when it carries over. A spread is two halves, or one when the Retail book is minimized. The Retail book has three columns per half, the Classic window two.

### Glows

A cell glows, pulsing like the native page's unassigned spells, when its macro is learned but not placed. `ns.ScanActionBars` reads slots 1 to 180 and matches macros by `GetActionText`, because a macro that shows a spell reports the spell's ID rather than its macro index, and spells by name, because a bar can hold any rank's ID. A spell's own macro also counts as placed when its plain spell is on a bar: always when its body is the bare body, and whatever its options while Count Spells On Bars As Placed is on (the default). Focus copies, Duplicate copies and equipment macros count only by macro name. Custom macros, the stance bar's forms (`noGlow`) and macros marked by Mark All Spells As Placed never glow; a spell learned after the mark still glows. Mark All Spells As Placed is a button under the footer, and the settings menu's Highlight Unplaced Spells checkbox shows whether any mark stands: unticking it marks every macro placed, ticking it clears the marks. The slot counts sit left of the page count, or where the arrows go on a single page.

### Notes and Tooltips

`OptionSubText` names the one option that is on, or `N Options` when several are, in the priority order of `OPTION_SUBTEXTS` (`Features/Macro-Button.lua`). With none on, the note is the spell's own subtext ("Rank 4", "Racial"), an equipment macro's slot, or an unlearned spell's learn level or "Talent". A focus copy's note is always Focus and a custom macro's Custom, and a blocked macro's says so in red. The tooltip shows the spell's or item's own tooltip first, then an "Options On:" line naming every option that is on by its full label, the macro text, why it's blocked or unlearned or not on the bars, and the click hints. No tooltip opens over a cell while any menu is open.

### Options Menu

`ns.ShowMacroMenu` (`Features/Macro-Menu.lua`) builds the right-click menu with `MenuUtil.CreateContextMenu`, under a title of the macro's icon and its name in gold.

- **The kind's own options come first**, as checkboxes (`FeaturedOptions`): Cast At Cursor where offered, then the spell's own Cast <ability> If Summoned, Switch To <stance> and Never Turn Off, and on an enemy spell the wand or Auto Shot and, for a Hunter or Warlock, Start Pet Attack.
- **Target** is a submenu of up to three priorities, First, Second and Third Priority, each a submenu of radios: the units its kind can pick, less those a higher priority took, with None below First, and no priority after None or Self. The menu can't drop an entry once it is drawn, so a pick closes it and opens it again, drawn afresh. Make Default copies the priority to the kind, and the kind's Macro Defaults panel has the same three dropdowns.
- **Grouped Spells** is a submenu holding Right-Click For <the other version> and, below it, a checkbox for each spell of the macro's spell group, the ones not learned yet in gray so they can be ticked ahead of training.
- **Rank** is a submenu of radios: Highest, Dynamic (Dynamic Rank) where offered, then every rank from Rank 1 up, the unknown ones in red with their learn level and disabled.
- **When** holds the combat check (Any Time, In Combat, Out Of Combat), how often it casts (Every Press, Cast Once Per Target, Cast Once Per Combat) and the two Stop Macro If options. **First** holds Stop Casting, Stop Attack, Leave Form Before Casting, the Target Nearest options and the on-use items, each with its icon and its place in the order; a slot already ticked whose item lost its Use: effect stays, so it can be unticked. **Then** holds whatever after-cast option isn't at the top already. **Error Messages** holds the two error options.
- A group's button names what is on in it in blue on its right, against the submenu arrow, so every value lines up ("When … In Combat", "First … 2 Options", "Grouped Spells … Enabled"), redrawn whenever the menu redraws, and nothing when it's left alone. A group the macro offers nothing in leaves no entry.
- Every option explains itself in its tooltip, the Macro Defaults panel's own words, with the Stop Casting and Dynamic Rank notes as a silver line under theirs.
- Macro Text follows, with its byte count (red over 255) as its value, opening the text in a submenu sized to its lines. Then the actions: Make Default For <Kind>, which prints where to change the defaults, Duplicate, Add or Remove Focus Copy, and Delete, which names how many action bar slots hold the macro ("Delete (Used On 2 Bars)"), asks first when any do, and deletes its WoW macro (`ns.DeletePageMacro`), taking a Duplicate copy off the page too.

Every change runs through `ns.ChangeMacro` and rebuilds the page. The menu stays open while options change: checkboxes refresh it by default, and the radio choices return `MenuResponse.Refresh`. Custom macros have no menu.

## Spellbook Hosts

The page (`ns.BuildSpellbookPage`) is host-agnostic: a host hands it a frame, optionally with its own `page.geometry`, and calls `ns.RefreshSpellbookPage` on show. Each host also defines `ns.ToggleSpellbookPage` for the key binding.

- **Classic engine** (`Spellbook-Host-Classic.lua`). A tab under the class's last skill line tab of `SpellBookFrame` (not the last shown one, since add-ons like WhatsTraining show tabs in the spare slots below), shown only over the spell pages, toggles a window of its own (`MacroSpellbookFrame`, 1100 x 660, two two-column pages, scaled down to fit with a 40-point margin and never up). Laying the page over the book's spell pages lost to UI skins (ElvUI restyles and re-layers the book), so the window stays clear of it. Tab and window are parented to `UIParent`, only the tab is anchored to the book, and the book is watched with `HookScript` and `hooksecurefunc(book, "Update", ...)`, so nothing Blizzard owns is written to. The window is in `UISpecialFrames` for Escape and sits on the HIGH strata, which is why the page's links to the options panels close it first (`ns.HideSpellbookWindow`). Without a settings cog on these books, a gear button at the page's top right opens the page's settings menu: the gear item icon (`INV_Misc_Gear_01`), lit under the mouse and nudged when pressed. Newer clients' cog atlases can't be used: Classic Era lists `QuestLog-icon-setting` but has no art for it, so it draws as the missing-texture green.
- **Retail engine** (`Spellbook-Tabs.lua`, `Spellbook-Host-Modern.lua`). `ns.SpellbookTabs` attaches once `Blizzard_PlayerSpells` loads. It lays the tab out right of the native tabs, skipping other add-ons' tab-sized launchers and stacking down the book's right edge once the row reaches the search box. It owns a parchment page clipped below the book's 60-pixel toolbar, plus an unclipped `page.header` over the toolbar, where the page lays a `SpellBookSettingsDropdownTemplate` cog over the native one. Every frame is parented to `UIParent` and only anchored over the book, because a frame parented to a Blizzard panel stays protected. Opening our tab closes any other add-on's page (a shown frame exactly the size of the book, closed through its own return button where it has one), and clicking another add-on's launcher closes ours. The page hides under the gamepad UI and when a native tab or the spell search takes over.

The page and cells check the templates and atlases they use (`SpellBookHeaderTemplate`, `SpellBookSettingsDropdownTemplate`, `PortraitFrameTemplate`, the `spellbook-item-*` and `spellbook-Page-*-C60` atlases) with `C_XMLUtil.GetTemplateInfo` and `C_Texture.GetAtlasInfo` first, each with a fallback, since the Classic engine's clients lack most of them. `Spellbook-Tabs.lua` uses its tab and parchment atlases directly: it loads only on the Retail engine, which ships them. The paging arrows (`Spellbook-Paging.lua`) are built by hand because Blizzard's paging template reads a format string the Classic engine's clients don't define.

## Unlearned Spells and Trainer Recording

Show Unlearned Spells (off by default; Vanilla, TBC and Camelot only) lists, desaturated and never glowing, the rank 1 of every class trainer spell whose name isn't learned. `ns.ForEachUnlearnedSpell` merges the flavor's `ns.TRAINER_SPELLS` for the class with this character's recorded trainer spells, sorts by level so a spell's lowest-level row is its rank 1, then appends the class lists' `extraSpells` (quest-learned spells and talents without trainer ranks). It filters by faction and race, skips passives and spells whose names haven't loaded, and treats a row as a higher rank when its subtext says so or it requires its own previous rank. Where the TOC leaves the file out, the settings menu and the Spellbook Page panel hide the toggle.

Trainer lists live on the server, so the trainer window is the only place the game shows them. `Trainer-Recording.lua` records each service's spell ID and required level into the profile's `trainerSpells` on `TRAINER_SHOW` and `TRAINER_UPDATE`, at class trainers only (`IsTradeskillTrainer`, then `C_Trainer.GetTrainerType`, excluding pet trainers). It records whatever the window's filters show. The spell ID comes from `C_TooltipInfo.GetTrainerService` on the Retail engine and from a hidden scan tooltip's `GetSpell` on the Classic engine. Recorded levels also feed the rank list (Ranks, above).

## Custom Macros

Each class's lists can carry default custom macros, as a `nameKey` (one of our own words, such as `CUSTOM_SPAM_WAND`) or a `name` template, an optional icon and a body template. `ns.FillMacroTemplate` replaces `{spell:ID}` with the client's spell name and `{family:ID}` with its creature family name, so defaults read right in every locale. The player's list is seeded once into the profile (`customMacrosSeeded`), and only once every name in it has loaded. Restore Defaults wipes the list and clears the flag; it is hidden for a class with no defaults, where it could only delete the player's own.

A custom entry is listed as written, with no options and no kind. `ns.CustomMacroProblem` gives the one reason it can't be: `"needs"` (no name or text), `"long"` (over 255 bytes with the tag line) or `"taken"` (its trimmed name is in use by a learned spell's macro, a copy, or an earlier valid custom entry). The page warns once per session in chat, and the Custom Macros panel shows a red status line; both read the same function. Its cell icon is the entry's icon, else the icon of the spell a leading `#showtooltip <spell>` names.

## Equipment Macros

One macro per equipped slot with a Use: effect, writing `/use <slot>` so it keeps working when the item is swapped. `HasUseEffect` asks `C_Item.GetItemSpell` first, then the slot's tooltip for a line starting with the client's `ITEM_SPELL_TRIGGER_ONUSE`, which catches effects added to the item, such as engineering tinkers. Equipment macros offer the combat check, Stop Casting, the target priority, the Stop Macro If options and the error options. Their settings are account-wide, in `ns.db.global.equipmentOptions` keyed by macro name, because every character shares the general macro, and per-character options would have each character rewrite it in turn. The cells' slot labels come from GlobalStrings (`HEADSLOT`, `TRINKET0SLOT_UNIQUE`, ...).

## Key Binding

`Bindings.xml` declares `MACROSPELLBOOK_TOGGLE`, which calls the global `MacroSpellbook_Toggle()`; the Key Bindings list labels it with `BINDING_NAME_MACROSPELLBOOK_TOGGLE`. The name attribute is what the client saves a player's key against, so it never changes: a renamed binding comes back unbound for everyone. The General panel can't set a key itself, so its row shows the bound key (or the client's `NOT_BOUND`) and a Set Key button. `ns:OpenKeyBindings` tries, at click time, `Settings.KEYBINDINGS_CATEGORY_ID`, then a search of the Settings panel's category list for the Key Bindings title (`KEY_BINDINGS` or `SETTINGS_KEYBINDINGS_LABEL`), then the standalone `KeyBindingFrame`, and finally prints where to find the list using the client's own menu labels. On the Classic engine the toggle opens or closes the window like a click on the tab. On the Retail engine it closes the book when the page is showing, else opens the spellbook (`PlayerSpellsUtil.OpenToSpellBookTab`) and turns to the page.

## Saved Variables

One SavedVariables table, `MacroSpellbookDB`, managed by AceDB-3.0 and created at `PLAYER_LOGIN`. Its scopes are `global` (the welcome toggle, the general-macro ownership record, the equipment macros' options and the tag register), `profile` (the page settings, the kind defaults, every per-spell option table, the Duplicate copies, the custom macros and their seeded flag, the Mark All Spells As Placed marks and the recorded trainer spells) and `char` (the character-macro ownership record). `Data/Default-Settings.lua` is the full shape; the migrations' done flags (`char.legacyImported`, `profile.buffKindCopied`) are written without a default.

**Model: Per-Character.** Recorded trainer spells genuinely differ per character, and the macro options ride the profile with them because which spells a page lists is per class. `AceDB:New` omits the third argument, so each character gets its own `Name - Realm` profile. **Reset Profile clears that character's profile only:** every option, kind default, page setting, copy, custom macro, mark and recorded trainer spell. The welcome toggle, the equipment options, the tag register and both ownership records survive. Those last three describe the account's and the character's actual macro lists, which no profile switch, copy or reset changes, so they live outside the profile (`README-Notes.md` records the `char` scope as an exception). A new setting about how this character's page behaves goes in `profile`; presentation, and anything whose effect lands in a macro every character shares, goes in `global`.

AceDB applies `ns.DATABASE_DEFAULTS` the first time each scope is read and keeps an explicitly stored `false`, so nothing merges defaults by hand. A profile switch, reset or copy fires `ns:ApplyProfile`, which runs the profile migrations, then `ns:RefreshMacros` (the open page redraws and the owned macros are rewritten to the new profile's options), then `NotifyChange` on every registered panel.

The only seeded list is the custom macros: seeded once, tracked by `customMacrosSeeded`, after every name in the class's defaults has loaded, and again on Restore Defaults. A default added in a later release reaches only players who restore defaults, so note it in the release notes. The kind defaults are a settings map, not a seeded list: a new entry in `kindDefaults` reaches every profile that never stored that key.

### Migration Chain

Everything below carries `MIGRATION (remove after 2026-11-23)`, as do the `Features/Migrations.lua` TOC line, the `SavedVariablesPerCharacter: MacroSpellbookCharDB` TOC line and the `MacroSpellbookCharDB` luacheck global.

1. `ns:MigrateLegacySavedVariables` (before `AceDB:New`): on a pre-AceDB table, moves the old top-level setting keys under `legacySettings`, so AceDB doesn't read them as its own.
2. `ns:ImportLegacySettings` (right after `AceDB:New`, once per character via `ns.db.char.legacyImported`): copies `legacySettings` onto this character's profile and its `MacroSpellbookCharDB.trainerSpells` into `trainerSpells`, then nils `MacroSpellbookCharDB`, which stops it being saved. A retired setting with no profile table (`raidRank1`) is dropped.
3. `ns:MigrateSpammable` (at login and on every profile change): moves each spell's retired Spammable setting to Stop Macro If Stealthed for a stealth spell, else Stop Macro If Channeling, and a kind's Spammable default to Stop Macro If Channeling. A moved profile has no `spam` table left, so it runs once per profile.
4. `ns:MigrateBuffKind` (at login and on every profile change, after Spammable): copies a profile's Friendly defaults to the Buffs kind where Buffs has no setting of its own, once per profile (`buffKindCopied`).
5. Ownership claim (`ns.LegacyOwnership`): a general spell or custom macro recorded as `true` by a release before owners were recorded is claimed by the first character to find it.
6. Ownership adoption (same function): an unrecorded macro whose body is exactly the page's current body before its tag line (or the bare body, for a spell macro) is adopted and recorded.

## Adding a New X

### A New Per-Spell Macro Option

1. Add the key to `profile` in `Data/Default-Settings.lua` as an empty table.
2. In `Features/Macro-Options.lua`, add its offer rule to `OFFERED` (or rely on the default: any spell with a target) and to the option lists in the comments above `SpellSettings` and `ns.OffersOption`. If a kind can turn it on, add it to `ns.DEFAULTABLE_OPTIONS`, which also puts it in Duplicate's `COPIED_SETTINGS`; if not, add it to `COPIED_SETTINGS` in `Features/Macro-Copies.lua` by hand, or Duplicate drops it and removing a copy leaves it behind.
3. In `Features/Macro-Body.lua`, write its line in `CastBody` or `ns.MacroBody` at the point in the fixed order where it must run, reading it through `ns.IsOptionOn`.
4. In `ns.ShowMacroMenu` (`Features/Macro-Menu.lua`), add it to the group whose lines it writes (or to `FeaturedOptions`, for an option a kind is for), with its tooltip in `DESCRIPTIONS`.
5. Add it to `OPTION_SUBTEXTS` (`Features/Macro-Button.lua`) at its priority, with its `SUBTEXT_*` and `MENU_*` keys.
6. If it is defaultable, add it to `MENU_GROUPS` and `OPTION_STRINGS` in `Options/Options-Macro-Defaults.lua`, which mirror the menu by hand.
7. Add the `MENU_*`, `SUBTEXT_*` and `OPTIONS_DEFAULT_*_DESCRIPTION` strings to `Locales/enUS.lua` only.
8. Run the Diagnostic Tools' Message Length report under ruRU, the overflow canary. It builds every page macro with every offered option on and every on-use slot ticked, so the new line's worst case shows against the 255-byte ceiling (`#body`, bytes, tag line included).

### A Spell in a Class List

1. Open `Data/{Game}/Class-Spell-Lists-{Game}.lua` for each flavor where it is true, and add the spell ID to the right list (`mouseoverEnemy`, `mouseoverFriend`, `buffs`, `cursor`, `stealth`, `noToggle`, ...). Use a table of every rank's ID wherever some locale names the ranks differently. The `channeled` lists still ship and Validate Data checks them, but no feature reads them: Stop Macro If Channeling is offered on every spell.
2. A new list key also goes in `LIST_KEYS` in `Diagnostics/Manifests.lua`, so Validate Data and the Game Names report cover it.
3. Check the same ID in the other six folders, and say in the PR which copies changed and why the rest didn't.
4. Never hand-edit the `How We Got the Data` block; the Data Review owns it.

### A Default Custom Macro

1. Add an entry to the class's `customMacros` in each flavor's class lists. Name it with `nameKey` (a new `enUS.lua` key) when the name is our own words, or a `name` template when it is a spell's name. Write spell and family names as `{spell:ID}` and `{family:ID}`, never as text.
2. Check the filled body in ruRU stays under 255 bytes with its 6-byte tag line.
3. Existing players only get it through Restore Defaults; say so in the release notes.

### A Group Version

Add `[singleSpellId] = groupSpellId` to `Data/{Game}/Group-Versions-{Game}.lua` for each flavor that has both spells. Right-Click For appears in the single spell's Grouped Spells submenu once the group spell is learned, and the converse in the group spell's once the single spell is.

### A Spell Group

Add `{ spellId, ... }` under the class in `ns.SPELL_GROUPS`, in the same file, listing spells that replace one another as the player trains (Demon Skin, Demon Armor, Fel Armor) in the order they are learned. Each spell in it gets the group's checkboxes in its Grouped Spells submenu. It is keyed by class because two classes can share a spell's name (Cure Poison, Cure Disease). When a spell leaves the spellbook because a later one in its group replaced it (Bear Form once Dire Bear Form is learned), the new spell takes over the old one's WoW macro, its tag and settings (`ns.HandOverMacro`), unless it has a macro of its own already: the sync rewrites that macro to cast the new spell and renames it from the old spell's name, so it keeps working where the player placed it. A spell learned with no page open does this straight away (`ns.HandOverDue`).

### A New Registered Event

1. Add it to `ns.EVENT_NAMES` in `Features/Core.lua`, so the dispatcher and the Diagnostic Tools pick it up together, and map it in `EVENT_HANDLERS` to its `On<Event>` name.
2. Define `ns:On<Event>` in the feature file that owns it.
3. If that file is left out of some TOCs, also add the event to `LOGIN_REGISTERED_EVENTS`, so it is registered only where its handler loaded. Registering an event a client lacks throws.

## Localization

WoW ships a fixed locale set and every supported locale file already exists, so localization here is maintenance, not expansion.

- **`enUS.lua` is the source of truth** and the only file that passes `true` to `NewLocale("MacroSpellbook", ...)`. The other ten translate its key set. The Localization Review (`07 - Localization Review.md`) owns them; ordinary work edits `enUS.lua` only, and a retired key name is never reused.
- **Placeholders** must match `enUS` per key in every locale, in count, type and order (`CHAT_MACRO_TOO_LONG` is `%s`, `%d`, `%d`), or the string throws when formatted. `StatusText` formats only `OPTIONS_CUSTOM_STATUS_TOO_LONG` (`%d`, `%d`); the other `OPTIONS_CUSTOM_STATUS_*` keys are shown as written, so a placeholder in them would print literally. `MENU_GROUP_VALUE` (`%s: %s`) carries its own separator so a locale can use a full-width colon.
- **Game names never go in `Locales/`.** Spells are stored as IDs in `ns.CLASS_SPELL_LISTS` (its `autoShot` included), `ns.TRAINER_SPELLS` and `ns.GROUP_VERSIONS`, and named by `C_Spell.GetSpellName` (rank text by `C_Spell.GetSpellSubtext`); pet families by ID through `C_CreatureInfo.GetCreatureFamilyInfo`; section names are the client's own spellbook tab names. Slot names and client labels (`ITEM_SPELL_TRIGGER_ONUSE`, `ERR_NOT_IN_COMBAT`, `SETTINGS`, `PAGE_NUMBER`, `NOT_BOUND`, `KEY_BINDINGS`, `SETTINGS_KEYBINDINGS_LABEL`, `GAMEMENU_OPTIONS`) are GlobalStrings read directly. The class-list, ranged-attack, trainer, group-version and custom-macro template spells, the pet families, the slot names and those labels each have a row in `ns.DIAGNOSTIC_NAME_LOOKUPS`, so the Game Names report checks them.
- **Not localized on purpose:** the equipment macros' WoW names (`Use Head`), which are identifiers on players' bars, the ` @F` focus suffix and the `#4K` tag line.

Everything else (the Spanish file pairing, the overflow canary, the output ceilings) follows the Style Guide's LOCALIZATION and MESSAGES → Message Length.

## Common Pitfalls

- **Writing macros in combat**: `EditMacro` and `CreateMacro` are blocked. Every write path checks `InCombatLockdown` and calls `ns.QueueMacroSync`, which `PLAYER_REGEN_ENABLED` replays; a click in combat refuses with the client's own error.
- **Editing a macro the player made**: the add-on edits only macros carrying a tag from its register, or untagged ones its ownership record covers (`ns.LegacyOwnership`). Never sync or delete by name alone.
- **Moving or resetting the tag register**: `macroTags` and `macroTagCount` live in `global` because a tagged WoW macro is indexed by its tag alone. A register that loses an entry leaves the old macro unfound, so the next click makes a second one beside it; one that hands a tag out twice makes two page macros rewrite the same WoW macro.
- **Macro names over 16 bytes**: `CreateMacro` truncates them, and a full-name lookup then misses. Always compare `macro.macroName` (`ns.TrimMacroName`, UTF-8 safe), never `macro.name`, and `ns.WowMacroName(macro)` against what the game returns (`GetMacroInfo`, `GetActionText`), since the WoW name carries the `~`.
- **Over 255 bytes**: a longer body would be cut off mid-line, so it is never written (`Fits`, `ns.MacroBlockReason`) and the player is warned once. Count the 6-byte tag line, and test option combinations under ruRU with the Message Length report, not enUS.
- **Seeding before names load**: a default custom macro filled while a spell name is nil would save a blank. `ns.DefaultCustomMacros` returns nil until every name resolves, and seeding waits.
- **Storing an option equal to its kind's default**: that pins the macro against later default changes. `SetOption` stores only differences, and Use These Options For All <Kind> reads every value before it changes any default.
- **Adding an option in one place**: the Macro Defaults panel's `MENU_GROUPS` mirrors the menu by hand, and `COPIED_SETTINGS` decides what Duplicate carries. Miss either and the option silently drops off the panel or out of copies.
- **Matching stances by tooltip**: the tooltip prints form names, which esES names differently from the stance spells. Stances come from the class lists only.
- **Trusting the book's spell name**: the book shows some spells under a name `/cast` can't use (Call Pet as "Call" plus the pet's name), and on Classic Era it can list Season of Discovery rune abilities. `ns.ForEachClassSpell` names every spell by ID and drops IDs of 300000 and up outside SoD.
- **Assuming the mouseover leaving fires an event**: it doesn't. `PollMouseover` watches for it, or a Dynamic Rank macro would keep a low rank after the cursor moved on.
- **Picking an engine's code path by flavor**: the engines differ in APIs, not flavors. Each branch checks for the API (`C_SpellBook.GetNumSpellBookSkillLines`, `C_TooltipInfo`, `Constants.MacroConsts`) or the template it needs, resolved once at load, and the TOC chooses the host file.
- **Parenting page frames to Blizzard's book**: they would stay protected, taint the book and lose to UI skins. Both hosts keep every frame on `UIParent`, anchored to the book, and only hook it.
- **Opening an options panel over the Classic window**: the window sits on the HIGH strata and would cover the Options Interface. Every page link to a panel calls `ns.HideSpellbookWindow` first.

## Contributing

Report bugs and suggestions on the [GitHub Issues tab](https://github.com/Gogo1951/Macro-Spellbook/issues), using the Defect or Request form, or talk them through on [Discord](https://discord.gg/eh8hKq992Q).

A useful bug report names the game version and locale, your class and level, the steps to reproduce it, and the macro text involved (hover the page cell, or right-click it for the options preview) or the chat line you saw. A Diagnostic Tools report (Options > AddOns > Macro Spellbook > Diagnostic Tools) settles most "nothing happens" reports.

PR guidelines:

- **One concern per PR.**
- **Match the house style**: StyLua default with `--syntax lua51`, clean `luacheck .` and `luac -p`, few comments.
- **Saved-data changes carry a migration**, tagged with its remove-after date, for the data players already have.
- **Output length**: any change to macro text or chat output is checked against the 255-byte macro ceiling and the 16-byte name ceiling under ruRU (Style Guide → MESSAGES → Message Length).
- **Update this document** if the architecture or file map changes.
- **PR descriptions say what a player will notice**, in plain language, the way release notes do; commit messages carry the developer detail.
