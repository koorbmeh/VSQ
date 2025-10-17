# VSQ - Vyris's Stormhalter QoL Improvements

## 🚀 Quick Start

### Prerequisites
- **AutoHotkey v2.0** - [Download here](https://www.autohotkey.com/download/ahk-v2.exe)
- **Stormhalter game** installed

### Installation
1. Download `VSQ.ahk` to your desired folder
2. **Either:** Place VSQ.ahk with `Kesmai.Client.exe`, OR update `GamePath` in `VSQ_Config.ini`
3. Run `VSQ.ahk` - it creates `VSQ_Config.ini` automatically
4. **Configure settings:** Press **Ctrl+Shift+~** to open the Configuration GUI for easy setup, or manually edit `VSQ_Config.ini`

### 🎯 **Important:** VSQ as Game Launcher
- **Run `VSQ.ahk` instead of launching the game directly** - VSQ can automatically launch the game for you
- **VSQ automatically closes when the game closes** - no need to manually close VSQ
- This ensures all automation features work properly and VSQ stays in sync with the game

## 🎮 Core Features

- **Health/Mana Monitoring** - Auto-drinks potions and uses abilities
- **Smart Combat** - Triggers attacks when creatures detected
- **Fumble Recovery** - Auto-recovers fumbled weapons (main hand/offhand)
- **Spell Casting** - Auto-warms and casts spells based on mana
- **MA Skills** - Martial Arts automation (fists/restock/auto/refill modes)
- **Knight Heal** - Mana-based healing
- **Coin Pickup** - One-click banker ring use
- **Active Spell Scrolling** - Auto-scrolls active spells left/right
- **9 Character Profiles** - Switch between configurations


## ⌨️ Hotkey Reference

### Core Controls
| Hotkey | Function |
|--------|----------|
| **Middle Click** | Toggle Auto Fight mode |
| **Ctrl+Shift+~** | Open Configuration GUI |
| **Alt+G** | Execute coin pickup |

### Profile Management
| Hotkey | Function |
|--------|----------|
| **Ctrl+Shift+1-9** | Switch profiles |

### Coordinate Setup
| Hotkey | Function |
|--------|----------|
| **Ctrl+Shift+L** | Set Login button coordinates |
| **Ctrl+Shift+H** | Set Health area (heals when not red) |
| **Ctrl+Shift+M** | Set Mana area (uses skills when blue) |
| **Ctrl+Shift+C** | Set Creature detection (black = no creatures) |
| **Ctrl+Shift+G** | Set Creature list verification coordinates (green arrows) |
| **Ctrl+Shift+P** | Toggle Creature list verification (on/off) |
| **Ctrl+Shift+U/I** | Set Coin search area (top-left/bottom-right) |
| **Ctrl+Shift+J/O** | Set Active Spell scrolling coordinates (left/right arrows) |
| **Ctrl+Shift+Q** | Set Active Spell Gone coordinates (dark when spell disappears) |
| **Ctrl+Shift+V** | Set Warmed spell coordinates (dark when no spell is warmed) |
| **Ctrl+Shift+F** | Set Main Hand coordinates (dark when fumbled) |
| **Ctrl+Shift+W** | Set Offhand coordinates (dark when fumbled) |

### Auto Combat Settings
| Hotkey | Function |
|--------|----------|
| **Ctrl+Shift+R** | Record ready cursor state |
| **Ctrl+Shift+S** | Toggle second attack |
| **Ctrl+Shift+E** | Swap attack keys |
| **Ctrl+Shift+A** | Toggle MA Skills |
| **Ctrl+Shift+T** | Toggle MA mode (fists/restock/auto/refill) |
| **Ctrl+Shift+K** | Toggle Knight Heal |
| **Ctrl+Shift+Z** | Toggle Active Spell Scrolling |
| **Ctrl+Shift+X** | Toggle Spell Casting |
| **Ctrl+Shift+B** | Toggle Main Hand Fumble Recovery |
| **Ctrl+Shift+Y** | Toggle Offhand Fumble Recovery |


## 🎯 How to Use

### ⚠️ **IMPORTANT: VSQ Requires Configuration!**
**VSQ will NOT work until you configure your keys and coordinates!** All keys start empty and all coordinates start at (0,0). You must set them up before automation will function.

**💡 Setup Help:** Use **Ctrl+Shift+~** to open the Configuration GUI and see all available hotkeys.  This is very helpful during setup!

### 1. Basic Setup
1. **Run `VSQ.ahk` instead of launching the game directly** - VSQ will launch the game automatically
2. Configure game path if needed
3. **Ctrl+Shift+L** - Click on login button (global setting)

### 2. Profile Configuration
1. Switch to desired profile: **Ctrl+Shift+1-9**
2. **REQUIRED: Configure attack keys and settings:**
   - Open Configuration GUI with **Ctrl+Shift+~**
   - Go to "Keys" tab to configure all attack keys and settings
   - Set AttackKey1 (e.g., "f" for fight)
   - Set AttackKey2 (e.g., "e" for throw) 
   - Set DrinkKey (e.g., "s" for drink)
   - Configure other keys as needed

### **Key Command Examples:**
| Key | Example Command | Purpose |
|-----|----------------|---------|
| **AttackKey1** | `fight` | Primary melee attack |
| **AttackKey2** | `jumpkick` or `throw hammer at all` | Ranged/secondary attack |
| **DrinkKey** | `drink` | Drink healing potions |
| **MAFistsKey** | `zhuna,fists` | Martial Arts fists mode |
| **MARestockKey** | `zhuna, restock 1` | Martial Arts restock mode |
| **KnightHealKey** | `cast cure at self` | Knight healing spell |
| **MoneyRingKey** | `use 1 ring from left` | Use money ring for coin pickup |
| **WarmSpellKey** | `WarmSpell(1)` or `warm ice spear` | Warm spell for casting |
| **CastSpellKey** | `cast at all` | Cast warmed spell |
| **RecoverMainKey** | `take longsword` | Pick up main hand weapon |
| **RecoverOffhandKey** | `take hammer` | Pick up offhand weapon |

3. **REQUIRED: Set coordinates using hotkeys:**
   - **Ctrl+Shift+H** - Click on insufficient health area
   - **Ctrl+Shift+M** - Click on sufficient mana area
   - **Ctrl+Shift+C** - Click on colored gem at the top of the creature list
   - **Ctrl+Shift+G** - Click on a green arrow at bottom of creature list (look for 3/3 green pixels)

4. Set active spell bar coordinates if using spell scrolling:
   - **Ctrl+Shift+J** - Click on left scroll button
   - **Ctrl+Shift+O** - Click on right scroll button  
   - **Ctrl+Shift+Q** - Click on spell empty detection area (suggested: near top right corner of the spell icon on the right side of the active spell bar, a spot that switches to a darker color if the spell disappears)
5. Rename profile: Use Configuration GUI (Ctrl+Shift+~)
6. Settings are automatically saved
7. **💡 Tip:** Use Configuration GUI (Ctrl+Shift+~) to verify your settings are correct!

### 3. Ready State Learning
1. Get in-game and ensure you're ready to act
2. Press **Ctrl+Shift+R** to record the "ready" cursor state
   - If you accidentally record a "busy" cursor state you will need to remove it from the ReadyCursorHashes in your config.
3. Repeat for different ready states (normal cursor, crosshair, etc.)
4. VSQ will only act when it detects these ready states

### 4. Using Automation
1. Press **Middle Click** to toggle Auto mode
2. After you have everything setup, VSQ will automatically:
   - Monitor health and drink when needed
   - Use Knight Heal when mana is available (if enabled and configured)
   - Use MA skills when mana is available (if enabled)
   - Attack with configured keys
   - Scroll right and left on the active spell bar (if enabled)
   - Cast spells when mana is available (if enabled)
   - Recover fumbled weapons when detected (if enabled)

## 🔧 Advanced Features

- **Pixel Detection** - Color analysis for health/mana/creatures/spells
- **Fumble Recovery** - Auto-recovers fumbled weapons using dark pixel detection
- **Spell Casting** - Auto-warms and casts spells based on mana and spell state
- **MA Skills** - Fists mode (fists + attack), Restock mode (smart restock + attacks), Auto mode (intelligent switching), or Refill mode (always restock + attacks)
- **Coin Pickup** - 8x8 grid scanning with precise timing
- **Active Spells** - Auto-scrolls based on color detection, respects user clicks (2s cooldown)
- **Creature Detection** - Prevents spam when no enemies present
- **Creature List Verification** - Optional additional check to ensure creature list is active before combat actions (green arrow detection)
- **Configuration GUI** - Visual interface for easy setup and configuration of all settings

## 🥊 MA Auto Mode - Intelligent Mode Switching

The new **MA Auto Mode** provides intelligent potion management for Martial Arts skills:

**MA Auto Mode only works when Auto Fight is activated** (Middle Mouse Button). The system must be in Auto mode to track potion usage and make intelligent MA decisions.

### **How It Works:**
1. **Tracks Potion Usage** - Counts each healing potion consumed via DrinkKey (only when Auto Fight is active)
2. **Smart Restocking** - Only restocks when you've used enough potions to justify the restock (applies to both Restock and Auto modes)
3. **Automatic Switching** - Uses Fists when potions are full, Restocks when potions are needed (Auto mode only)
4. **Potion Warning** - Alerts you when using potions faster than you can restock them
5. **Counter Reset** - Switching to Restock or Auto mode (Ctrl+Shift+T) resets the potion counter to 0 for a fresh start

### **Configuration:**
- **Set Potions per Restock** (1-3) in Configuration GUI → Keys tab → MA Skills group
- **Enable Auto Mode** via checkbox or Ctrl+Shift+T hotkey
- **Configure MA Keys** - Set your Fists and Restock command keys
- **Activate Auto Fight** - Press Middle Mouse Button to enable the automation system

## 🥊 MA Refill Mode - Always Restock

The **MA Refill Mode** provides the original "always restock" behavior

### **How It Works:**
- **Always Restocks** - Every time MA skill is triggered, it performs a restock action
- **No Potion Counting** - Ignores potion usage tracking completely
- **Immediate Action** - No delays or conditions, always executes restock + attacks

### **When to Use:**
- **Initial Bag Filling** - Perfect for refilling your bag with potions when starting with an empty bag

**💡 Pro Tip:** Use Refill mode when your bag is empty to quickly fill it with potions, then switch to Restock or Auto mode for smart potion management during combat.

## 🖥️ Configuration GUI

VSQ includes a comprehensive GUI for easy configuration:

### **Opening the GUI:**
- Press `Ctrl+Shift+~` to open the Configuration GUI
- Or use the menu: File → Configuration

### **GUI Features:**
- **Profile Management** - Switch between profiles and rename them
- **Tabbed Interface** - Organized into logical sections:
  - **Start** - Game path configuration, login settings, backup options
  - **Timing** - All timing delays and intervals (ShortDelay, LongDelay, etc.)
  - **Keys** - Attack keys, MA skills, Knight heal, spell casting, fumble recovery
  - **Monitoring** - Health/mana monitoring, creature detection, active spells, coin pickup
  - **Hotkeys** - Complete hotkey reference and legend

### **Tab Details:**

**Start Tab:**
- Game path configuration and browsing
- Auto-click login settings and coordinates
- Backup system configuration
- Debug logging options

**Timing Tab:**
- Short/Medium/Long delays
- Tooltip display time
- Auto loop intervals
- Game monitoring frequency
- Mouse click cooldown settings

**Keys Tab:**
- Attack key configuration (primary/secondary)
- MA skills settings (fists/restock/auto/refill modes with potion tracking)
- Knight heal configuration
- Spell casting keys (warm/cast)
- Fumble recovery keys (main hand/offhand)

**Monitoring Tab:**
- Health monitoring coordinates and settings
- Mana monitoring coordinates and settings
- Creature detection configuration
- Active spell scrolling coordinates
- Coin pickup area coordinates
- Creature list verification settings

**Hotkeys Tab:**
- Complete hotkey reference
- Core controls (GUI, auto mode, coin pickup)
- Combat toggles and settings
- Profile switching shortcuts

### **Easy Setup:**
- **"Set" buttons** - Click to capture mouse coordinates automatically
- **"Change" buttons** - Click to modify key bindings with input dialogs
- **Real-time preview** - See current values for all settings
- **Apply changes** - Save all modifications at once
- **Restore Defaults** - Reset current profile to default settings

### **Benefits:**
- **No hotkey memorization** - Visual interface for all settings
- **Bulk editing** - Change multiple settings quickly
- **Validation** - Prevents invalid configurations
- **Professional appearance** - Much easier than hotkeys

## 💾 Backup System

VSQ automatically creates backups to protect your configuration:

### **Backup Settings (in VSQ_Config.ini):**
```ini
[LOGGING SETTINGS]
EnableBackups=true          ; Enable/disable automatic backups
BackupConfigOnly=false      ; true = config only, false = script + config
```

### **How It Works:**
- **Full Backup Mode (default):** Backs up both `VSQ.ahk` and `VSQ_Config.ini` - provides complete protection for your setup
- **Config-Only Mode:** Only backs up `VSQ_Config.ini` - useful if you want to save space since config changes frequently
- **Backup Location:** `VSQ_Backups/` folder
- **Naming:** 
  - Script: `VSQ_Backup_YYYYMMDD_HHMMSS.ahk`
  - Config: `VSQ_Config_Backup_YYYYMMDD_HHMMSS.ini`
- **Automatic** - Happens every time you start VSQ
- **Timestamped** - Each backup includes date and time for easy identification

### **Benefits:**
- ✅ **Configuration Protection** - Never lose your carefully configured settings
- ✅ **Version History** - Keep multiple versions of your setup for comparison
- ✅ **Easy Recovery** - Restore from any previous backup if needed
- ✅ **Space Efficient** - Config-only mode saves space while still protecting settings
- ✅ **Zero Maintenance** - Completely automatic, no user intervention required

### **Usage Tips:**
- **Full backups recommended** - Protects both script and configuration changes
- **Check backup folder periodically** - Clean up old backups if disk space is limited
- **Restore from backup** - Simply copy a backup file over the current file to restore

## 🐛 Troubleshooting

### **Common Issues & Solutions**

#### **VSQ Won't Start**
- **AutoHotkey v2.0 not installed:** Download from [autohotkey.com](https://www.autohotkey.com/download/ahk-v2.exe)
- **Game path incorrect:** Check `GamePath` in `VSQ_Config.ini` points to your Stormhalter installation

#### **Automation Not Working**
- **Coordinates not set:** All coordinates start at (0,0) - you must configure them first
- **Ready states not recorded:** Press `Ctrl+Shift+R` when cursor is in "ready" state
- **Keys not configured:** Set attack keys, drink key, etc. in Configuration GUI
- **Auto mode disabled:** Press **Middle Click** to toggle auto mode on

#### **Coordinate Issues**
- **Coordinates showing as (0,0):** Use hotkeys like `Ctrl+Shift+H` to set coordinates
- **Wrong coordinates captured:** Re-set coordinates using the appropriate hotkeys
- **Negative coordinates:** Usually indicates GUI or other window interference - close the Configuration GUI and use hotkeys directly in the game window
- **Multi-monitor coordinate problems:** If you have the GUI open on a different monitor, close it and use hotkeys in the game window to avoid coordinate conflicts
- **Coordinates not working after moving window:** VSQ uses absolute coordinates - they should work across monitors
- **Multi-monitor problems:** Coordinates are screen-absolute, should work on any monitor
- **Clicking in wrong location:** Verify coordinates are set on actual UI elements, not empty space

#### **Detection Problems**
- **Health/Mana not detected:** Re-set coordinates with `Ctrl+Shift+H` and `Ctrl+Shift+M`
- **Creatures not detected:** Re-set creature area with `Ctrl+Shift+C` on the colored gem
- **Spells not detected:** Re-set spell coordinates with `Ctrl+Shift+J/O/Q`
- **Pixel detection failing:** Ensure coordinates are on actual UI elements with visible colors

#### **Feature-Specific Issues**

**Spell Scrolling:**
- **Not scrolling:** Enable with `Ctrl+Shift+Z`, set coordinates with `Ctrl+Shift+J/O/Q`
- **Scrolling too much:** Check that "spell gone" coordinates are set correctly
- **Not detecting active spells:** Re-set left/right coordinates on scroll arrows

**Spell Casting:**
- **Not casting:** Enable with `Ctrl+Shift+X`, set warmed spell coordinates with `Ctrl+Shift+V`
- **Casting wrong spells:** Check `WarmSpellKey` and `CastSpellKey` settings

**Fumble Recovery:**
- **Not recovering weapons:** Enable with `Ctrl+Shift+B/Y`, set weapon coordinates (dark when fumbled)
- **Recovering wrong weapons:** Check `RecoverMainKey` and `RecoverOffhandKey` settings

**Coin Pickup:**
- **Not finding coins:** Set coin area with `Ctrl+Shift+U/I` (top-left/bottom-right corners)
- **Clicking wrong location:** Ensure coin area coordinates cover the actual coin drop area

**Creature List Verification:**
- **Not working:** Set with `Ctrl+Shift+G` on green arrows, look for 3/3 green pixels in tooltip
- **Too restrictive:** Disable with `Ctrl+Shift+P` if causing issues

#### **Debug & Logging**
- **Check debug log:** Look in `VSQ_Debug.log` for error messages and detection results
- **Enable debug logging:** Set `EnableDebugLogging=true` in `VSQ_Config.ini`
- **Log file too large:** Delete `VSQ_Debug.log` to start fresh

#### **Configuration Issues**
- **Settings not saving:** Check file permissions, ensure VSQ can write to config file
- **Profile problems:** Switch profiles with `Ctrl+Shift+1-9`, verify correct profile is active
- **GUI not opening:** Use `Ctrl+Shift+~` to open Configuration GUI
- **Settings reset:** Use "Restore Defaults" button in GUI to reset current profile

#### **Performance Issues**
- **VSQ running slowly:** Check `GameMonitorInterval` setting, increase if needed
- **Too many clicks:** Adjust `MouseClickCooldown` setting
- **Detection too frequent:** Increase timing delays in Configuration GUI


## 📁 Files
- `VSQ.ahk` - Main script
- `VSQ_Config.ini` - Configuration (auto-generated)
- `VSQ_Debug.log` - Debug log
- `VSQ_Backups/` - Automatic backups

---

**Happy Gaming!** 🎮