# Skilling Coach

Skilling Coach shows a useful tip at the moment you can use it. For example, it can suggest an ore box when mining fills your backpack. You can pin a tip as a goal or dismiss it for good.

**Status:** Phase 2 complete; game-adapter hardening is next. The current demo includes one ore-box tip. Broader item, unlock, method and QoL tips are planned.

The ore-box tip waits for sustained Mining XP and a transition to a full backpack.
Other items, including geodes, count towards occupied slots. Open the bank once so
the coach can check its snapshot for an existing ore box. Owned, pinned, dismissed
and already-shown tips are skipped; cooldown and combat quiet time also apply.

Drag the card from its text or background. The pin saves a goal; Dismiss hides the
tip permanently, and Later closes it for now. The plugin settings can bring back
dismissed tips for testing. See [docs/writing-tips.md](docs/writing-tips.md) before
adding new tips.

See [docs/implementation-plan.md](docs/implementation-plan.md) for the full design.

## Requirements

- [PrettyUI](https://prettyui.j3.gg/) from the Plugin Hub.
- No permissions. Skilling Coach doesn't use the internet or read chat.
