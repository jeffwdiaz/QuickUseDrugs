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
| \---QuickUseDrugs
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
- **QuickUseDrugs/contents/mods/QuickUseDrugs**: Current mod directory structure (contains QuickUseDrugs mod files)
- **QuickUseDrugs/42**: Version-specific assets and config for PZ Build 42
- **42/media/lua/client**: Client-side Lua scripts implementing complete drug consumption system
  - **QUDrugs.lua**: Core mod logic with all three drug types (Beta Blockers, Painkillers, Antidepressants)
  - **QUDrugsOptions.lua**: Mod options and keybind configuration
- **42/media/lua/shared/Translate/EN**: English translation files directory (currently empty)
- **QuickUseDrugs/common**: Shared assets directory (contains .gitkeep placeholder)
