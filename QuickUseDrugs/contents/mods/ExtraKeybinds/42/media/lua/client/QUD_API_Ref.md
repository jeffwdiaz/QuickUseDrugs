### QuickUseDrugs API reference (Project Zomboid Build 42)

Purpose: concise reference of the core APIs used by this mod with brief notes and pointers to documentation. Values and availability can differ between builds; verify against your installed version.

---

## Events

- **Events.OnGameStart.Add(function fn)**: Register a callback that runs after the game starts and Lua is initialized.

  - Used in `QUDrugs.lua` to report the configured keybind.
  - Docs: PZwiki Modding hub (search for "Events"), official JavaDocs for event types vary by build.

- **Events.OnKeyPressed.Add(function(keyCode))**: Registers a callback for keyboard input; receives an integer key code.
  - Used in `QUDrugs.lua` to trigger quick-use logic when the configured key is pressed.
  - Note: Compare `key` against your configured key code.

## Player and moodles

- **getPlayer() -> IsoPlayer**: Returns the local player instance.

  - Used throughout to access inventory, moodles, speech, and worn gear.

- **IsoPlayer:getMoodles() -> Moodles** and **Moodles:getMoodleLevel(MoodleType)**: Read current moodle levels as integers 0–4.

  - Moodle scale: 0=0%, 1=25%, 2=50%, 3=75%, 4=100%.
  - Used to detect high Panic, Pain, and Unhappy levels.

- **MoodleType.[Pain|Panic|Unhappy]**: Enum entries selecting which moodle to query.

- **IsoPlayer:Say(string)**: Displays a speech bubble and logs character speech.

## Inventory and containers

- **IsoPlayer:getInventory() -> ItemContainer**: Player main inventory.

- **ItemContainer:getItems() -> ArrayList<InventoryItem>**: Java list of items.

  - Common operations: `:size()` and `:get(index)` for iteration from 0 to size-1.

- **InventoryItem:getDisplayName() -> string** and **InventoryItem:getType() -> string**: Item identity helpers.

- **InventoryItem:getContainer() -> ItemContainer|nil**: Returns nested container if the item is itself a container (e.g., bags). Enables recursive searches.

- **IsoPlayer:getClothingItem_Back() -> InventoryItem|nil**: Currently worn back item (e.g., backpack). Use `:getContainer()` to inspect contents.

## Debugging

- **print(any)**: Logs to the console for tracing mod behavior.

## Mod options (built-in in Build 42)

- `require "PZAPI/ModOptions"` and **PZAPI.ModOptions:create(mod_id, display_name)**: Creates a mod options group.

- **:addDescription(text)**: Adds section text in the options UI.

- **:addKeyBind(option_id, label, default_keycode, description)**: Declares a configurable key binding; default `0` means unbound.

- **group:getOption(option_id):getValue() -> integer**: Read the configured key code at runtime.

Note: In Build 42, `PZAPI/ModOptions` ships with the game (media/lua/client/PZAPI/ModOptions.lua). On older builds or certain modpacks it may be provided externally. You can verify by locating ModOptions.lua in your ProjectZomboid install. In this mod, access helpers are exposed via `QUDrugsSettings.getQuickUseDrugsKeybind()`.

---

## Where these appear in this mod

- `media/lua/client/QUDrugs.lua`

  - Events.OnGameStart.Add, Events.OnKeyPressed.Add
  - getPlayer, IsoPlayer:getMoodles, Moodles:getMoodleLevel, MoodleType
  - IsoPlayer:getInventory, ItemContainer:getItems, size/get iteration
  - InventoryItem:getDisplayName, getType, getContainer
  - IsoPlayer:getClothingItem_Back, IsoPlayer:Say, print

- `media/lua/client/QUDrugsOptions.lua`
  - PZAPI.ModOptions:create, :addDescription, :addKeyBind
  - :getOption(...):getValue()

---

## Useful references

- PZwiki Modding hub (Lua API, events, guides): `https://pzwiki.net/wiki/Modding`
- PZwiki Mod Options page: `https://pzwiki.net/wiki/Mod_Options`
- JavaDocs index (search classes like IsoPlayer, ItemContainer, InventoryItem): `https://zomboid-javadoc.com/` (unofficial; pick your build)
- Build‑specific behavior can change; confirm against your game version and console output.
