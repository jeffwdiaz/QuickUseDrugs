# Quick Use Drugs (QUDrugs) - Technical Specification

## Project Overview

Project Zomboid mod providing quick-use keybinds and configurable options for consuming drug and aid items. The mod automatically detects high moodle levels and consumes appropriate medications based on priority.

## Technical Stack

- Language: Lua (Project Zomboid modding API)
- Target: Project Zomboid Build 42
- Packaging: QuickUseDrugs/contents/mods structure
- Distribution: Local mod folder; compatible with Workshop packaging

## Functional Requirements

- Quick-use keybinds to consume designated items without inventory navigation
- Automatic moodle detection and priority-based medication treatment
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
  - Priority-based moodle treatment system (Panic → Pain → Unhappiness)
- Implementation phases
  - ✅ Phase 1: Baseline keybinds and options UI (COMPLETED)
  - ✅ Phase 2: Core drug consumption system using ISTakePillAction (COMPLETED)
  - 🔍 Phase 3: Moodle effect application and advanced features (IN PROGRESS)

## Core Features

- **Moodle Detection**: Automatically detects high Panic, Pain, and Unhappiness levels
- **Priority Treatment**: Treats one condition at a time based on priority order
- **Medication Types**: Supports Beta Blockers (Panic), Painkillers (Pain), Antidepressants (Unhappiness)
- **Action Prevention**: Prevents overlapping medication consumption
- **Build 42 Compatibility**: Full server-side action execution using ISTimedActionQueue

## Success Criteria

- ✅ Performance: No noticeable frame impact during keypress handling (COMPLETED)
- ✅ Quality: Stable gameplay with no errors in console (COMPLETED)
- ✅ Testing: In-game verification of drug consumption using ISTakePillAction (COMPLETED)
- 🔍 User Experience: Smooth drug consumption with clear visual feedback and moodle improvements (IN PROGRESS)
- ✅ Build 42 Compatibility: Full server-side action execution working correctly with built-in actions (COMPLETED)
