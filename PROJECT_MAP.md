# Project Map

## Directory Structure

. (project root)
| .gitignore
| .gitmodules
| CHANGELOG.md
| PROJECT_MAP.md
| README.md
|
+---QuickUseDrugs
| | preview.png
| | workshop.txt
| |
| \---contents
| \---mods
| \---ExtraKeybinds
| | icon.png
| | mod.info
| | poster.png
| |
| +---42
| | | icon.png
| | | mod.info
| | | poster.png
| | |
| | \---media
| | \---lua
| | +---client
| | | QUD_API_Ref.md
| | | QUDrugs.lua
| | | QUDrugsOptions.lua
| | |
| | \---shared
| | \---Translate
| | \---EN
| \---common
| .gitkeep

## Descriptions

- QuickUseDrugs: Mod packaging root containing preview and workshop metadata.
- QuickUseDrugs/contents/mods/ExtraKeybinds: Primary mod directory for distribution.
- ExtraKeybinds/42: Version-specific assets and config for supported PZ builds.
- 42/media/lua/client: Client-side Lua scripts and API reference.
- 42/media/lua/shared/Translate/EN: English translations.
- ExtraKeybinds/common: Shared assets placeholder.
