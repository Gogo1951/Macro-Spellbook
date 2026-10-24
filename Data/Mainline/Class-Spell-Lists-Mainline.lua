local _, ns = ...

-- [classToken] = { mouseoverEnemy, mouseoverFriend, buffs, cursor, channeled, stealth = { spellId }, noToggle = { spellId }, stanceSlots = { stanceSpellId }, stances = { [spellId] = { stanceSpellId } }, petAbilities = { [summonSpellId] = { abilityId, familyId } }, extraSpells = { spellId }, customMacros = { { name or nameKey, icon, body } }, autoShot = spellId }
ns.CLASS_SPELL_LISTS = {}
