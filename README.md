# Sudeki Widescreen Patch

Gameplay camera and HUD fixes for the supported GOG Windows release of **Sudeki**.

[Download the latest release](https://github.com/Vildiil/Sudeki-Widescreen-Patch/releases/latest)

## What it does

**Camera fix:** preserves the original vertical field of view and expands the horizontal view at widescreen resolutions. This replaces the game's default behavior of cropping the top and bottom of the view.

**HUD fix:** corrects horizontal stretching of the party panels, quick-item shortcuts and spirit-strike gauge, and positions those groups toward the right edge. It also makes the minimap circular and keeps it toward the left edge.

Scaling follows the current resolution. At 4:3 and narrower aspect ratios, these fixes retain the original camera field of view and HUD layout.

The patcher lets you install **both fixes**, install the **camera fix only**, or **restore the original executable**.

## Installation

1. Download **Sudeki-Widescreen-Fixes-v1.zip** from [Releases](https://github.com/Vildiil/Sudeki-Widescreen-Patch/releases).
2. Extract the ZIP into a folder and close Sudeki.
3. Double-click **Run-Patcher.cmd**.
4. Choose **1** for camera + HUD, **2** for camera only, or **3** to restore.
5. Enter your game folder, or press Enter to use `C:\GOG Games\Sudeki`.
6. Launch the game normally and choose your widescreen resolution.

Windows PowerShell is required; Python and additional downloads are **not** required.

If Windows denies write access to the game folder, right-click **Run-Patcher.cmd** and choose **Run as administrator**.

## Restore or switch fixes

Run the patcher again to switch between the two installation options or restore the original executable.

The patcher saves a verified original backup in the game folder as `SUDEKI.exe.pre-widescreen-fixes.bak`. Keep this file.

## Compatibility

The patcher supports one verified GOG executable and checks its SHA-256 before making changes. It also recognizes the camera-only and combined versions produced by this patch. Unknown or otherwise modified executables are rejected.

Supported original `SUDEKI.exe` SHA-256:

```text
8ceb1d3cf667ad906f13252cb5bdf762eb018ebbecb8bffeb92f3b27b0dfbb94
```

The downloadable ZIP contains the patcher and patch data. It does not contain a game executable, game assets or save files.

## Scope and testing

Both fixes were confirmed working in gameplay at **2560 × 1440**. Validation also included 672 emulated camera cases, 224 HUD/minimap cases executed twice each, and six installer/switch/restore transitions that reproduced the expected executable hashes.

The HUD correction currently covers gameplay party panels, quick items, the spirit gauge and minimap. Menus, dialogue, boss bars, targeting reticles, videos and other overlays are not corrected. Other party panels share the correction but were not individually visually tested. Perspective cutscenes using the shared camera routines may also receive the field-of-view change.

## Advanced usage

From the extracted folder:

```powershell
.\Patch-Sudeki.ps1 -GameDir 'D:\Games\Sudeki' -Mode Both
.\Patch-Sudeki.ps1 -GameDir 'D:\Games\Sudeki' -Mode Camera
.\Patch-Sudeki.ps1 -GameDir 'D:\Games\Sudeki' -Mode Restore
```

If you report an issue, include your game release, resolution, selected patch option, and the scene where it occurs.
