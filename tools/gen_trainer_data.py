"""Regenerates src/Data/<Class>.lua from a source folder of Camelot trainer data (one <Class>.lua per class).

Usage (from anywhere): python tools/gen_trainer_data.py <source dir> [output dir]
The output dir defaults to this addon's src/Data/ folder. Then restart the client if the class list changed, or
/reload otherwise.
"""
import re, sys, os
here = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if len(sys.argv) < 2: sys.exit(__doc__)
src = sys.argv[1]
out = sys.argv[2] if len(sys.argv) > 2 else os.path.join(here, "src", "Data")
classes = ["Druid","Hunter","Mage","Paladin","Priest","Rogue","Shaman","Warlock","Warrior"]
entry_re = re.compile(r"\{id = (\d+)((?:[^{}]|\{[^{}]*\})*)\}")
level_re = re.compile(r"\[(\d+)\] = \{")
os.makedirs(out, exist_ok=True)
for cls in classes:
    text = open(os.path.join(src, cls + ".lua"), encoding="utf-8").read()
    text = text[text.index("wt.SpellsByLevel"):]
    levels = [(m.start(), int(m.group(1))) for m in level_re.finditer(text)]
    rows, dropped, talents = [], 0, set()
    for m in entry_re.finditer(text):
        level = max(l for pos, l in levels if pos < m.start())
        rest = m.group(2)
        talent = re.search(r"requiredTalentId = (\d+)", rest)
        if talent:
            # A talent's higher ranks come from the trainer; rank 1 (the talent itself) isn't listed, so add it
            # in their place, at the level of its first trainer rank (the talent's own level isn't in the data).
            dropped += 1
            if talent.group(1) not in talents:
                talents.add(talent.group(1))
                rows.append(f"    {{level = {level}, id = {talent.group(1)}, talent = true}},")
            continue
        fields = [f"level = {level}", f"id = {m.group(1)}"]
        req = re.search(r"requiredIds = \{([^}]*)\}", rest)
        if req: fields.append("requires = {" + req.group(1).strip() + "}")
        fac = re.search(r'faction = "(\w+)"', rest)
        if fac: fields.append(f'faction = "{fac.group(1)}"')
        race = re.search(r"race = (\d+)", rest)
        if race: fields.append(f"race = {race.group(1)}")
        unknown = set(re.findall(r"(\w+) =", rest)) - {"cost","requiredIds","faction","race"}
        assert not unknown, (cls, m.group(0))
        rows.append("    {" + ", ".join(fields) + "},")
    rows.sort(key=lambda r: int(re.search(r"level = (\d+)", r).group(1)))  # stable: keeps file order within a level
    with open(os.path.join(out, cls + ".lua"), "w", encoding="utf-8", newline="\n") as f:
        f.write("local _, smb = ...\n\n")
        f.write("-- Class trainer spells (MIT, see src/Data/LICENSE). Do not edit by hand: run tools/gen_trainer_data.py instead.\n")
        f.write("smb.trainerSpells." + cls.upper() + " = {\n" + "\n".join(rows) + "\n}\n")
    print(cls, len(rows), "kept,", dropped, "talent ranks dropped,", len(talents), "talents added")
