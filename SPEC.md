# Quick Use Drugs (QUDrugs) - Technical Specification

## Project Overview

Project Zomboid mod providing quick-use keybinds and configurable options for consuming drug and aid items.

## Technical Stack

- Language: Lua (Project Zomboid modding API)
- Target: Project Zomboid Build 42
- Packaging: QuickUseDrugs/contents/mods/ExtraKeybinds structure
- Distribution: Local mod folder; compatible with Workshop packaging

## Functional Requirements

- Quick-use keybinds to consume designated items without inventory navigation
- Configurable options menu for behavior and preferences
- In-game API reference for mod options and usage

## Technical Architecture

- Application structure
  - media/lua/client: Client-side scripts (QUDrugs.lua, QUDrugsOptions.lua)
  - media/lua/shared/Translate/EN: English translation files
  - mod.info, icon.png, poster.png: Mod metadata and assets
- Data models
  - Configuration persisted via Project Zomboid mod options
  - Mappings from keybinds to item actions
- Implementation phases
  - Phase 1: Baseline keybinds and options UI
  - Phase 2: Extended item support and UX refinements
  - Phase 3: Translation expansion and documentation polish

## Success Criteria

- Performance: No noticeable frame impact during keypress handling
- Quality: Stable gameplay with no errors in console
- Testing: In-game verification of keybinds, options persistence, and translation loading
