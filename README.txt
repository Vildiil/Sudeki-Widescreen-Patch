SUDEKI WIDESCREEN FIXES - v1

For the GOG Windows release. Both fixes were confirmed working in gameplay
by the original tester at 2560x1440. Other executable versions are rejected.

INSTALL
1. Extract this ZIP to a folder. Close Sudeki.
2. Double-click Run-Patcher.cmd.
3. Choose 1 for both fixes (recommended), 2 for camera only, or 3 to restore.
4. Enter your Sudeki installation folder, or press Enter for C:\GOG Games\Sudeki.
5. Launch the game normally and select your widescreen resolution.

If Windows denies access to your game folder, right-click Run-Patcher.cmd
and choose Run as administrator. No downloads or Python are required.

WHAT THE FIXES DO
Camera: preserves the original vertical view and adds horizontal view for
widescreen, instead of cropping the top and bottom.
HUD: corrects horizontal stretching of party panels, quick-item shortcuts,
and the spirit gauge, keeping them on the right. Makes the minimap circular
and keeps it near the left edge. Includes the camera fix.
Scaling follows your resolution; 4:3 and narrower keep the original layout.

RESTORE / SWITCH
Run the patcher again to switch between both fixes and camera only, or restore
the original executable. A verified original backup is kept in the game folder
as SUDEKI.exe.pre-widescreen-fixes.bak. Keep that file.

COMPATIBILITY AND LIMITS
Requires the exact supported GOG executable. The patcher checks SHA-256 before
writing and also accepts our camera-only and combined versions. It refuses
unknown executables, including other modifications. No game data or saves
are included or changed.
This is a gameplay HUD prototype. Menus, dialogue, boss bars, targeting
reticles, videos and other overlays are not corrected. Other party panels
share the correction but were not individually visually tested. Perspective
cutscenes using the shared camera routines may also receive the FOV change.

Technical checks: 672 emulated camera cases plus 224 HUD/minimap cases, each
HUD case executed twice. Original executable SHA-256:
8ceb1d3cf667ad906f13252cb5bdf762eb018ebbecb8bffeb92f3b27b0dfbb94

Advanced usage from PowerShell:
  .\Patch-Sudeki.ps1 -GameDir 'D:\Games\Sudeki' -Mode Both
  .\Patch-Sudeki.ps1 -GameDir 'D:\Games\Sudeki' -Mode Camera
  .\Patch-Sudeki.ps1 -GameDir 'D:\Games\Sudeki' -Mode Restore
