# Project Map

## Directory Structure

. (project root)
| .gitignore
| .gitmodules
| CHANGELOG.md
| PROJECT_MAP.md
| README.md
| SPEC.md
| TODO.md
|
+---docs
| | deploy_mod.bat
| | upload_to_workshop.ps1
|
+---pzApiRef
| | .git
| | README.md
| | Project_Zomboid_API_Reference.md
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
| | | | QUDrugs.lua
| | | | QUDrugsOptions.lua
| | |
| | \---shared
| | \---Translate
| | \---EN
| \---common
| .gitkeep

## Descriptions

- **docs**: Project documentation and deployment scripts
  - **deploy_mod.bat**: Windows batch script for mod deployment
  - **upload_to_workshop.ps1**: PowerShell script for Steam Workshop uploads
- **pzApiRef**: Comprehensive API reference sub-module containing Project Zomboid modding API research, core APIs, and implementation examples for Build 42 development
- **QuickUseDrugs**: Mod packaging root containing preview and workshop metadata
- **QuickUseDrugs/contents/mods/ExtraKeybinds**: Current mod directory structure (contains QuickUseDrugs mod files)
- **ExtraKeybinds/42**: Version-specific assets and config for PZ Build 42
- **42/media/lua/client**: Client-side Lua scripts (QUDrugs.lua, QUDrugsOptions.lua)
- **42/media/lua/shared/Translate/EN**: English translation files directory (currently empty)
- **ExtraKeybinds/common**: Shared assets directory (contains .gitkeep placeholder)
