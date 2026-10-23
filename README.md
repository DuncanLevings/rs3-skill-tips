# Skilling Coach

Skilling Coach shows a useful tip at the moment you can use it. For example, it can suggest an ore box when mining fills your backpack. You can pin a tip as a tip or dismiss it for good.

**Status:** Phase 5 implemented; native UI check pending. Pinned tips and the latest-10 history each have a titled window. Recent tips defaults to 360x400, supports manual resizing and remembers its dimensions. Ribbon/settings provide launch buttons. The current demo includes one ore-box tip. Broader item, unlock, method and QoL tips are planned.

The ore-box tip waits for sustained Mining XP and a transition to a full backpack.
Other items, including geodes, count towards occupied slots. Open the bank once so
the coach can check its snapshot for an existing ore box. Owned, pinned, dismissed
and already-shown tips are skipped; cooldown and combat quiet time also apply.

The engine ranks tips for the skill being trained by priority and level relevance.
Method tips use the current bracket; reward level-ups wait for real training. The
current catalogue still contains only the ore-box demo.

Open pinned tips or Recent tips from the ribbon. It does not auto-open a window.
Assign an optional pinned-tips toggle shortcut in settings. The
side window shows each tip title and a subdued Unpin action; its X closes without removing tips.
Use native title-bar dragging for both windows. Recent tips can Pin a past tip, even
if dismissed; this does not make its popup eligible again.

Drag the card from its text or background. The pin saves a tip; Dismiss hides the
tip permanently, and Later closes it for now. Dismissal is permanent for players. A test reset is available only when explicitly enabling the local
development switch; it is absent from normal settings. See [docs/writing-tips.md](docs/writing-tips.md) before
adding new tips.

Tips are discovered through play; there is no browse-all-tips screen. Quest-tip support queues valuable unlocks
until a five-second quiet pause; actual quest content arrives with the pilot.

See [docs/implementation-plan.md](docs/implementation-plan.md) for the full design.

## Requirements

- [PrettyUI](https://prettyui.j3.gg/) from the Plugin Hub.
- No permissions. Skilling Coach doesn't use the internet or read chat.
