defmodule DndTracker.Adventures.Goals do
  use DndTracker.Constants

  constant(:wilderness, [
    "Locate a dungeon or other site of interest",
    "Assess the scope of a natural or unnatural disaster",
    "Escort an NPC to a destination",
    "Arrive at a destination without being seen by the villain’s forces",
    "Stop monsters from raiding caravans and farms",
    "Establish trade with a distant town",
    "Protect a caravan traveling to a distant town",
    "Map a new land",
    "Find a place to establish a colony",
    "Find a natural resource",
    "Hunt a specific monster",
    "Return home from a distant place",
    "Obtain information from a reclusive hermit",
    "Find an object that was lost in the wilds",
    "Discover the fate of a missing group of explorers",
    "Pursue fleeing foes",
    "Assess the size of an approaching army",
    "Escape the reign of a tyrant",
    "Protect a wilderness site from attackers"
  ])

  constant(:dungeon, [
    "Stop the dungeon’s monstrous inhabitants from raiding the surface world",
    "Foil a villain’s evil scheme",
    "Destroy a magical threat inside the dungeon",
    "Acquire treasure",
    "Find a particular item for a specific purpose",
    "Retrieve a stolen item hidden in the dungeon",
    "Find information needed for a special purpose",
    "Rescue a captive",
    "Discover the fate of a previous adventuring party",
    "Find an NPC who disappeared in the area",
    "Slay a dragon or some other challenging monster",
    "Discover the nature and origin of a strange location or phenomenon",
    "Pursue fleeing foes taking refuge in the dungeon",
    "Escape from captivity in the dungeon",
    "Clear a ruin so it can be rebuilt and reoccupied",
    "Discover why a villain is interested in the dungeon",
    "Win a bet or complete a rite of passage by surviving in the dungeon for a certain amount of time",
    "Parley with a villain in the dungeon",
    "Hide from a threat outside the dungeon"
  ])

  constant(:other, [
    "Seize control of a fortified location such as a fortress, town, or ship",
    "Defend a location from attackers",
    "Retrieve an object from inside a secure location in a settlement",
    "Retrieve an object from a caravan",
    "Salvage an object or goods from a lost vessel or caravan",
    "Break a prisoner out of a jail or prison camp",
    "Escape from a jail or prison camp",
    "Successfully travel through an obstacle course to gain recognition or reward",
    "Infiltrate a fortified location",
    "Find the source of strange occurrences in a haunted house or other location",
    "Interfere with the operation of a business",
    "Rescue a character, monster, or object from a natural or unnatural disaster"
  ])
end
