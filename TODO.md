# Quick Use Drugs (QUDrugs) - Development To-Do List

## Completed ✅

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

## In Progress 🔍

- [ ] Research moodle modification APIs for specific drug effects
- [ ] Implement moodle effect application after pill consumption
- [ ] Test and validate moodle changes in-game

## To-Do

- [ ] Add configurable moodle thresholds for treatment
- [ ] Implement medication cooldown system
- [ ] Add visual feedback for medication effects
- [ ] Create medication inventory management features
- [ ] Add support for additional medication types
- [ ] Implement medication effectiveness tracking

## Notes

- Maintain compatibility with PZ Build 42
- Keep documentation updated with changes
- All core drug consumption functionality is now working using ISTakePillAction
- Priority system ensures only one condition is treated per keypress
- Action prevention prevents overlapping medication consumption
