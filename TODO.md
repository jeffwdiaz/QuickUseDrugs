# QuickUse Drugs (QUDrugs) - Development To-Do List

## Current task

- [ ] Test medication cooldown system implementation
  - [ ] Test beta blocker cooldown (10 in-game minutes)
  - [ ] Test painkiller cooldown (10 in-game minutes)
  - [ ] Test antidepressant cooldown (10 in-game minutes)
  - [ ] Verify cooldown persists across different drug types
  - [ ] Test cooldown message: "I just took [medication name]."
  - [ ] Verify cooldown timing accuracy (10 in-game minutes)

## Future tasks

## Completed tasks

- [x] Implement basic moodle detection system
- [x] Create medication search functions for all three drug types
- [x] Implement beta blocker consumption using ISTakePillAction
- [x] Implement painkiller consumption using ISTakePillAction
- [x] Implement antidepressant consumption using ISTakePillAction
- [x] Create priority-based treatment system (Panic → Pain → Unhappiness)
- [x] Add action prevention to avoid overlapping medication consumption
- [x] Integrate with ISTimedActionQueue for Build 42 compatibility
- [x] Research and document Project Zomboid APIs for mod development
- [x] Resolve "bugged action" errors by using built-in actions
- [x] Create comprehensive API reference documentation
- [x] Implement recursive container search for ALL equipped containers
- [x] Add Move → Consume → Move Back pattern for items in bags
- [x] Use ISInventoryTransferAction for reliable container operations
- [x] Solve consumption issues with items in different container types
- [x] Implement medication cooldown system using game time tracking
  - [x] Add static variable to track last medication time when mod loads
  - [x] Implement game time comparison function
  - [x] Prevent medication consumption during cooldown period
  - [x] Set cooldown duration to 10 in-game minutes
  - [x] Add player feedback message during cooldown
  - [x] Integrate cooldown check into medication treatment functions

## Notes

- Maintain compatibility with PZ Build 42
- Keep documentation updated with changes
- All core drug consumption functionality is now working using ISTakePillAction
- Priority system ensures only one condition is treated per keypress
- Action prevention prevents overlapping medication consumption
- Recursive container search now covers ALL equipped containers (back, hands, waist, shoulder, etc.)
- Items are automatically moved to main inventory for consumption and returned to original location
- Medication cooldown system implemented with 10 in-game minute duration
- Cooldown system prevents rapid medication consumption for gameplay balance
- Player receives clear feedback when cooldown is active
