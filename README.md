# Macro Spellbook

A World of Warcraft forever addon that allow players to easily configure macro's straight from the spellbook.

## Configuring your class

The page's sections follow your spellbook's own tabs: General, then your class's trees or specs. Your custom
macros and equipped items come after them, and, with Show Unlearned Spells on, the spells you haven't learned yet
come last.

Each flavor's class lists live in `Data/<Flavor>/Class-Spell-Lists-<Flavor>.lua`. They set which spells offer
mouseover or cursor casting and the default custom macros; the comment at the top of each file explains each
list. Edit your class's lists, then type `/reload` in game.
