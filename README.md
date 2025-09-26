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
- **MA Skills** - Martial Arts automation (fists/restock modes)
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
| **Ctrl+Shift+J/O** | Set Active spell scrolling arrow coordinates (left/right) |
| **Ctrl+Shift+Q** | Set Active spell gone detection (right most spell spot on active spell bar) |
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
| **Ctrl+Shift+T** | Toggle MA mode (fists/restock) |
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
   - **Ctrl+Shift+K** - Click on right scroll button  
   - **Ctrl+Shift+Z** - Click on spell empty detection area (suggested: near top right corner of the spell icon on the right side of the active spell bar, a spot that switches to a darker color if the spell disappears)
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
- **MA Skills** - Fists mode (fists + attack) or Restock mode (restock + attacks)
- **Coin Pickup** - 8x8 grid scanning with precise timing
- **Active Spells** - Auto-scrolls based on color detection, respects user clicks (2s cooldown)
- **Creature Detection** - Prevents spam when no enemies present
- **Creature List Verification** - Optional additional check to ensure creature list is active before combat actions (green arrow detection)
- **Configuration GUI** - Visual interface for easy setup and configuration of all settings

## 🖥️ Configuration GUI

VSQ includes a comprehensive GUI for easy configuration:

### **Opening the GUI:**
- Press `Ctrl+Shift+~` to open the Configuration GUI
- Or use the menu: File → Configuration

### **GUI Features:**
- **Profile Management** - Switch between profiles and rename them
- **Tabbed Interface** - Organized into logical sections:
  - **Basic** - Health, Mana, Creature detection, Login button
  - **Attack** - Attack keys, MA skills, Knight heal
  - **Advanced** - Active spells, Spell casting, Fumble recovery
  - **Coin Pickup** - Coin area coordinates and settings
  - **Verification** - Creature list verification settings

### **Easy Setup:**
- **"Set" buttons** - Click to capture mouse coordinates automatically
- **"Change" buttons** - Click to modify key bindings with input dialogs
- **Real-time preview** - See current values for all settings
- **Apply changes** - Save all modifications at once

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
BackupConfigOnly=true       ; true = config only, false = script + config
```

### **How It Works:**
- **Config-Only Mode (default):** Only backs up `VSQ_Config.ini` - perfect for most users since config changes frequently but VSQ.ahk rarely does
- **Full Backup Mode:** Backs up both VSQ.ahk and config files
- **Backup Location:** `VSQ_Backups/` folder
- **Naming:** `VSQ_Config_Backup_YYYYMMDD_HHMMSS.ini`
- **Automatic** - Happens every time you start VSQ

## 🐛 Troubleshooting

**VSQ won't start:** Check AutoHotkey v2.0 installed, verify game path
**Automation not working:** Check coordinates set, ready states recorded
**Nothing happens when enabled:** Keys and coordinates not configured - use hotkeys to set them up
**Need help with setup:** Use Configuration GUI (Ctrl+Shift+~) to check current settings and see all hotkeys
**Detection issues:** Re-set coordinates, ensure areas are on actual UI elements
**Spell scrolling:** Enable with Ctrl+Shift+Z, set all three coordinates
**Spell casting:** Enable with Ctrl+Shift+X, set warmed spell coordinates
**Fumble recovery:** Enable with Ctrl+Shift+B/Y, set weapon coordinates (dark when fumbled)
**Creature list verification:** Set with Ctrl+Shift+G on green arrows, look for 3/3 green pixels in tooltip


## 📁 Files
- `VSQ.ahk` - Main script
- `VSQ_Config.ini` - Configuration (auto-generated)
- `VSQ_Debug.log` - Debug log
- `VSQ_Backups/` - Automatic backups

---

**Happy Gaming!** 🎮