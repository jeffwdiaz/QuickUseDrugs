# Changelog

## 2025-08-28 - Thursday

[Added]

- PZAPI reference sub-module containing comprehensive Project Zomboid API research
- Project_Zomboid_API_Reference.md with core APIs and implementation examples for Build 42
- pzApiRef/README.md documenting the API reference collection
- Updated project documentation structure and formatting
- Complete implementation of all three drug types using ISTakePillAction
- Panic treatment with beta blockers (working implementation)
- Pain treatment with painkillers (working implementation)
- Unhappiness treatment with antidepressants (working implementation)
- Priority-based moodle treatment system (Panic → Pain → Unhappiness)
- Action prevention system to avoid overlapping medication consumption

[Changed]

- Cleaned up PROJECT_MAP.md to remove outdated ExtraKeybinds references
- Updated project map to reflect current directory structure
- Removed .cursor, .git, and archive folders from project documentation
- Updated Project_Zomboid_API_Reference.md with ISTakePillAction findings and troubleshooting
- Replaced custom ISBetaBlockerAction with built-in ISTakePillAction for reliability
- Enhanced moodle detection functions to actually consume medications instead of just searching

[Fixed]

- Corrected workshop upload script paths to use QuickUseDrugs instead of ExtraKeybinds
- Resolved "bugged action" errors by using built-in ISTakePillAction instead of custom actions
- Fixed drug consumption not working by implementing proper ISTimedActionQueue integration
- Corrected inheritance from ISBaseTimedAction to ISBaseObject for custom action creation

[Removed]

- Outdated references to ExtraKeybinds as primary mod directory
- Shared assets placeholder descriptions from project map
- Custom ISBetaBlockerAction class that was causing console errors
- Fallback and debug code that was cluttering the implementation
