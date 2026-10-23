# Skilling Coach

Skilling Coach shows a useful tip at the moment you can use it. For example, it can suggest an ore box when mining fills your backpack. You can pin a tip as a goal or dismiss it for good.

**Status:** Phase 4 engine implemented and checked; UI completion is next, with a narrow pinned-goals window and a read-only history of the latest 10 tips. The current demo includes one ore-box tip. Broader item, unlock, method and QoL tips are planned.

The ore-box tip waits for sustained Mining XP and a transition to a full backpack.
Other items, including geodes, count towards occupied slots. Open the bank once so
the coach can check its snapshot for an existing ore box. Owned, pinned, dismissed
and already-shown tips are skipped; cooldown and combat quiet time also apply.

The engine ranks tips for the skill being trained by priority and level relevance.
Method tips use the current bracket; reward level-ups wait for real training. The
current catalogue still contains only the ore-box demo.

Drag the card from its text or background. The pin saves a goal; Dismiss hides the
tip permanently, and Later closes it for now. Dismissal is permanent for players. The current development demo has a temporary
dismissal reset for testing; Phase 5 will restrict this to development tooling. See [docs/writing-tips.md](docs/writing-tips.md) before
adding new tips.

Tips are discovered through play; there is no planned browse-all-tips screen. Quest
goals highlighting valuable unlocks once skill requirements are met are planned next.

See [docs/implementation-plan.md](docs/implementation-plan.md) for the full design.

## Requirements

- [PrettyUI](https://prettyui.j3.gg/) from the Plugin Hub.
- No permissions. Skilling Coach doesn't use the internet or read chat.
