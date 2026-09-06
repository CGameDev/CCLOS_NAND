# Xbox 360 System Feature Parity Target

## Goal

A user moving from the retail Xbox 360 shell to CCLOS NAND Edition should not lose a locally functional console capability merely because CCLOS is now the primary shell.

The complete retail dashboard shell is not retained. Instead, CCLOS exposes the required capability through retained Xbox platform services or a CCLOS-native implementation.

## Classification

Every capability must be classified as one of:

- **BASELINE** — already implemented in locked CCLOS v0.35.2; preserve it.
- **SYSTEM-BRIDGE** — retained Xbox platform service is wrapped by XboxSystemBridge.
- **CCLOS-NATIVE** — feature must be implemented by CCLOS using validated platform capabilities.
- **OPTIONAL/LEGACY** — obsolete, server-retired or niche capability that is exposed only where still meaningful.
- **UNSUPPORTED** — not safely/technically available; report honestly rather than guessing.

## Profiles & identity

Target capabilities:

- local Xbox user detection;
- sign-in/sign-out/profile switching;
- XUID-linked identity;
- gamertag;
- gamer picture/tile where available;
- gamerscore;
- titles played;
- achievements earned;
- played-title history;
- gamercard details;
- avatar display/configuration where available;
- Xbox profile storage on HDD/MU/USB-supported storage;
- CCLOS Admin/Standard/Restricted/Guest policy layered on top of Xbox identity;
- CCLOS PIN/permissions and per-profile preferences preserved.

## Achievements

Preserve existing CCLOS achievement UI/data behavior from the baseline and extend only where required for parity:

- per-title achievements;
- unlocked/locked/secret state;
- gamerscore totals;
- achievement artwork/tile where available;
- achievement detail;
- played-title history integration;
- Guide/runtime access.

## Friends, messages & social system services

Where the Xbox platform/service environment makes the capability available:

- friends list;
- gamercards;
- messages;
- message composition;
- friend requests;
- recent players;
- game invites;
- party;
- party invites;
- private/voice chat settings;
- player review/related legacy functions if still useful.

These must not cause CCLOS to silently disable Xbox Live protection or assume Live availability on an RGH console.

## Storage & content

Target capabilities:

- enumerate storage devices;
- HDD;
- onboard/internal MU variants;
- supported Flash/eMMC MU variants;
- supported USB storage/MU;
- free/used capacity;
- Xbox 360 games;
- Original Xbox content;
- XBLA;
- saved games;
- profiles;
- DLC;
- title updates;
- themes/gamer pictures where applicable;
- music/video/pictures;
- CCLOS apps/emulators/media data;
- copy/move/delete content where safely supported;
- transfer-content workflows where safely supported;
- device rename where supported;
- format only through validated platform behavior and destructive-operation confirmation;
- clear system cache only when implementation is verified;
- device information.

No-storage mode must remain a first-class supported state.

## Network

Target capabilities:

- wired link state;
- wireless capability/network discovery where supported;
- SSID/security state where supported;
- DHCP/static configuration where safely supported;
- IPv4;
- subnet;
- gateway;
- primary/secondary DNS;
- local network test;
- Internet test;
- DNS test;
- CCLOS services test;
- Xbox-service connectivity shown separately;
- MAC address;
- network statistics/diagnostics;
- CCLOS network services/FTP/DLNA/CCMS status.

Ordinary Internet access must not imply Xbox Live access.

## Display

Target capabilities where the Xbox platform exposes them safely:

- active video mode;
- output/AV pack information;
- resolution;
- widescreen/normal aspect behavior;
- reference levels;
- HDMI color-space state/options;
- display discovery;
- overscan/safe-area handling where applicable;
- CCLOS screen-saver/display preferences.

Unverified low-level write paths remain read-only until proven.

## Audio & voice

Target capabilities:

- active audio output;
- stereo/digital/Dolby-related output options where platform support permits;
- HDMI/digital audio state;
- system/UI sounds;
- voice volume;
- game/voice balance;
- headset/speaker voice output;
- headset/microphone connection state where available;
- voice settings through the system layer where available.

## Controller & input

Preserve existing CCLOS UnifiedInput behavior and add system parity where supported:

- controller connection;
- player/controller assignment;
- battery level/state;
- controller capabilities;
- vibration preferences;
- headset/accessory state;
- keyboard input;
- native Xbox virtual keyboard fallback where useful;
- CCLOS keyboard;
- CCLOS pointer/mouse enhancements.

## Console settings

Target capabilities:

- Xbox system language/locale;
- CCLOS language remains separate from Xbox platform locale where necessary;
- date/time/time-zone state and supported configuration;
- console name where supported;
- startup behavior;
- disc autoplay behavior;
- system information;
- motherboard/NAND/exploit information added by CCLOS;
- kernel/build information;
- CCLOS firmware/system version;
- storage/network/system health.

## Family, restrictions & privacy

Preserve and expand the existing CCLOS permission model rather than blindly cloning the old retail family UI.

Candidate controls:

- protected settings PIN;
- profile management permission;
- download/Marketplace permission;
- destructive storage permission;
- update permission;
- power permission;
- task cancellation permission;
- content/rating restrictions where reliable metadata exists;
- play-time restrictions/timers if implemented;
- network/social/FTP/remote-management permissions;
- Xbox Live/privacy controls only through validated system capabilities.

## Quick Guide / runtime shell

The CCLOS Guide must remain available during titles where technically supported by CCLOSRuntime.

Target destinations:

- profile/sign-in;
- achievements;
- friends;
- messages;
- recent players;
- party/voice;
- notifications;
- music/Now Playing;
- downloads/tasks;
- controller status;
- Quick Settings;
- Return to Game;
- Return to CCLOS;
- power/restart actions subject to permission.

The existing baseline Quick Guide appearance is locked; feature expansion must use the same design system.

## Media

Preserve existing CCLOS/CCMS/Watch TV capabilities and cover useful retail-media functions:

- local video;
- USB video;
- network video;
- music;
- pictures;
- CCMS;
- DLNA;
- SMB/HTTP where baseline already supports them;
- Now Playing;
- physical video/data disc handling where feasible;
- connected-media-server status.

Do not rebuild obsolete Windows Media Center Extender merely for a parity checkbox.

## Connected devices

Where useful:

- connected controller count;
- keyboard/pointer state;
- USB device/storage state;
- DLNA/Play To-related state where supported;
- CCMS server discovery/status;
- Kinect status;
- Xbox Live Vision may remain a legacy/optional bridge if support is viable.

Do not rebuild obsolete SmartGlass server infrastructure solely for historical parity.

## Kinect / NUI

Where a console has Kinect hardware and the retained platform supports the capability:

- sensor presence/status;
- enable/disable state where supported;
- tracking/calibration entry points;
- audio/microphone calibration where supported;
- diagnostics;
- native/system troubleshooting UI bridge only if validated and necessary.

## Physical media

Preserve/extend the existing CCLOS disc service:

- tray state;
- eject/close;
- Xbox 360 game detection;
- Original Xbox detection;
- video/data media classification;
- game metadata;
- normal launch;
- CCLOS Disc-to-GOD/copy workflow when user storage exists;
- no-storage normal disc launch;
- trainer integration remains governed by existing CCLOS safety/session rules.

## System updates

Separate these concepts:

- CCLOS content/catalog updates;
- CCLOS user-space/service updates;
- CCLOS flash-system/firmware updates;
- Xbox platform/kernel build inputs used locally by the NAND builder.

Normal catalog/artwork/media changes must not force a NAND rewrite.

## Retired/obsolete retail services

Do not recreate a dead service and pretend it is functional.

Examples include:

- closed Xbox 360 Marketplace purchasing;
- retired/obsolete media applications whose backend no longer exists;
- obsolete Windows Media Center/SmartGlass functionality unless a specific modern CCLOS equivalent provides value.

CCLOS Marketplace/CCMS/Social services may replace the useful product role while retaining genuine Xbox system services where available.

## Acceptance rule

Before NAND Edition can be called a full shell replacement, the parity matrix must contain a disposition for every relevant retail system capability:

```text
Capability -> BASELINE / SYSTEM-BRIDGE / CCLOS-NATIVE / OPTIONAL-LEGACY / UNSUPPORTED
```

No blank rows and no guessed implementations.