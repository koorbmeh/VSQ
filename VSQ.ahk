#Requires AutoHotkey v2.0
; Download here: https://www.autohotkey.com/download/ahk-v2.exe

; ========================================
; VSQ.ahk - Vyris's Stormhalter QoL Improvement Mod - v1.3.1
; ========================================
; All user-configurable settings are in VSQ_Config.ini
; The VSQ_Config.ini is created after running the script the first time.
; ========================================

; ========================================
; 1. GLOBAL VARIABLES
; ========================================
; These variables are managed by the script and should not be edited manually

ConfigFile := "VSQ_Config.ini"
LogFile := "VSQ_Debug.log"
GameWindowTitle := "ahk_exe Kesmai.Client.exe"
GameRunning := false

; ========================================
; GAME SETTINGS
; ========================================
GamePath := "C:\Program Files\Stormhalter\"
GameExecutable := "Kesmai.Client.exe"
AutoClickLogin := true
LoginButtonX := 0
LoginButtonY := 0
UseSecondaryMonitor := true
SecondaryMonitorNumber := 3
AutoMaximizeWindow := true
BackupFolder := "VSQ_Backups"

; ========================================
; TIMING SETTINGS
; ========================================
ShortDelay := 32
MediumDelay := 64
LongDelay := 128
TooltipDisplayTime := 2048
AutoLoopInterval := 100
CoinRoundTimerDelay := 1064
LoginDelay := 200
MouseClickCooldown := 2000
GameMonitorInterval := 2000

; ========================================
; LOGGING SETTINGS
; ========================================
EnableDebugLogging := false
EnableBackups := false
BackupConfigOnly := true

; ========================================
; CHARACTER PROFILES
; ========================================
MaxProfiles := 9
CurrentProfile := 1
Profile1Name := "Profile 1"
Profile2Name := "Profile 2"
Profile3Name := "Profile 3"
Profile4Name := "Profile 4"
Profile5Name := "Profile 5"
Profile6Name := "Profile 6"
Profile7Name := "Profile 7"
Profile8Name := "Profile 8"
Profile9Name := "Profile 9"

; ========================================
; PROFILE-SPECIFIC SETTINGS (PROFILE X sections)
; ========================================
; Note: These are loaded/saved per profile, but stored as global variables for current profile

; Auto settings
EnableAuto := false  ; Script-only variable, controlled by Middle Click
EnableHealthMonitoring := true
EnableManaMonitoring := true
AttackKey1 := ""
AttackKey2 := ""
EnableAttackKey2 := true
AttackSpamReduction := true
DrinkKey := ""
HealthAreaX := 0
HealthAreaY := 0
ManaAreaX := 0
ManaAreaY := 0
CreatureAreaX := 0
CreatureAreaY := 0

; MASkill settings
EnableMASkill := false
MAFistsKey := ""
MARestockKey := ""
CurrentMASkill := "restock"
PotionsPerRestock := 1
UsedPotionsCount := 0

; Knight Heal settings
EnableKnightHeal := false
KnightHealKey := ""

; Coin pickup settings
MoneyRingKey := ""
CoinAreaTopLeftX := 0
CoinAreaTopLeftY := 0
CoinAreaBottomRightX := 0
CoinAreaBottomRightY := 0

; Active spell scrolling settings
EnableActiveSpellScrolling := false
ActiveSpellsLeftX := 0
ActiveSpellsLeftY := 0
ActiveSpellsRightX := 0
ActiveSpellsRightY := 0
ActiveSpellGoneX := 0
ActiveSpellGoneY := 0
LastMouseClickTime := A_TickCount  ; Track when mouse was last clicked

; Spell casting settings
EnableSpellCasting := false
SpellCastingDelay := 5000  ; Delay in milliseconds between spell casts
EnableSpellCreatureCheck := true  ; Check for creatures before casting spells
LastSpellCastTime := 0  ; Track when spell was last cast
WarmSpellKey := ""
CastSpellKey := ""
WarmedSpellX := 0
WarmedSpellY := 0

; Fumble recovery settings
RecoverFumbleMain := false
RecoverFumbleOffhand := false
RecoverMainKey := ""
RecoverOffhandKey := ""
MainHandX := 0
MainHandY := 0
OffHandX := 0
OffHandY := 0

; Creature list verification settings
EnableCreatureListVerification := false
CritListVerifyX := 0
CritListVerifyY := 0

ReadyCursorHashes := []  ; Array of hashes for "ready" cursors (populate via hotkey)

; ========================================
; 2. CONFIGURATION FUNCTIONS
; ========================================

; Function to load configuration from file
LoadConfig(profileToLoad := "") {
    global ConfigFile
    global GamePath, GameExecutable, AutoClickLogin, LoginButtonX, LoginButtonY, UseSecondaryMonitor, SecondaryMonitorNumber, AutoMaximizeWindow, BackupFolder
    global ShortDelay, MediumDelay, LongDelay, TooltipDisplayTime, AutoLoopInterval, CoinRoundTimerDelay, LoginDelay, MouseClickCooldown, GameMonitorInterval, EnableDebugLogging, EnableBackups, BackupConfigOnly
    global MaxProfiles, CurrentProfile, Profile1Name, Profile2Name, Profile3Name, Profile4Name, Profile5Name, Profile6Name, Profile7Name, Profile8Name, Profile9Name
    global EnableAuto, EnableHealthMonitoring, EnableManaMonitoring, AttackKey1, AttackKey2, EnableAttackKey2, AttackSpamReduction, DrinkKey, HealthAreaX, HealthAreaY, ManaAreaX, ManaAreaY, CreatureAreaX, CreatureAreaY, EnableMASkill, MAFistsKey, MARestockKey, CurrentMASkill, EnableKnightHeal, KnightHealKey, CoinAreaTopLeftX, CoinAreaTopLeftY, CoinAreaBottomRightX, CoinAreaBottomRightY, CoinRoundTimerDelay, EnableActiveSpellScrolling, ActiveSpellsLeftX, ActiveSpellsLeftY, ActiveSpellsRightX, ActiveSpellsRightY, ActiveSpellGoneX, ActiveSpellGoneY, EnableSpellCasting, SpellCastingDelay, EnableSpellCreatureCheck, LastSpellCastTime, WarmSpellKey, CastSpellKey, WarmedSpellX, WarmedSpellY, RecoverFumbleMain, RecoverFumbleOffhand, RecoverMainKey, RecoverOffhandKey, MainHandX, MainHandY, OffHandX, OffHandY, EnableCreatureListVerification, CritListVerifyX, CritListVerifyY, PotionsPerRestock, UsedPotionsCount
    global ReadyCursorHashes
    static hashString

    ; Create default config if it doesn't exist
    if (!FileExist(ConfigFile)) {
        CreateDefaultConfig()
        LogMessage("Created default configuration file: " . ConfigFile)
        return
    }

    try {
        ; Load settings from config file using IniRead
        GamePath := IniRead(ConfigFile, "GAME SETTINGS", "GamePath", GamePath)
        GameExecutable := IniRead(ConfigFile, "GAME SETTINGS", "GameExecutable", GameExecutable)
        AutoClickLogin := (IniRead(ConfigFile, "GAME SETTINGS", "AutoClickLogin", AutoClickLogin ? "true" : "false") = "true")
        LoginButtonX := IniRead(ConfigFile, "GAME SETTINGS", "LoginButtonX", LoginButtonX)
        LoginButtonY := IniRead(ConfigFile, "GAME SETTINGS", "LoginButtonY", LoginButtonY)
        UseSecondaryMonitor := (IniRead(ConfigFile, "GAME SETTINGS", "UseSecondaryMonitor", UseSecondaryMonitor ? "true" : "false") = "true")
        SecondaryMonitorNumber := IniRead(ConfigFile, "GAME SETTINGS", "SecondaryMonitorNumber", SecondaryMonitorNumber)
        AutoMaximizeWindow := (IniRead(ConfigFile, "GAME SETTINGS", "AutoMaximizeWindow", AutoMaximizeWindow ? "true" : "false") = "true")
        BackupFolder := IniRead(ConfigFile, "GAME SETTINGS", "BackupFolder", BackupFolder)

        ShortDelay := IniRead(ConfigFile, "TIMING SETTINGS", "ShortDelay", ShortDelay)
        MediumDelay := IniRead(ConfigFile, "TIMING SETTINGS", "MediumDelay", MediumDelay)
        LongDelay := IniRead(ConfigFile, "TIMING SETTINGS", "LongDelay", LongDelay)
        TooltipDisplayTime := IniRead(ConfigFile, "TIMING SETTINGS", "TooltipDisplayTime", TooltipDisplayTime)
        AutoLoopInterval := IniRead(ConfigFile, "TIMING SETTINGS", "AutoLoopInterval", AutoLoopInterval)
        CoinRoundTimerDelay := IniRead(ConfigFile, "TIMING SETTINGS", "CoinRoundTimerDelay", CoinRoundTimerDelay)
        LoginDelay := IniRead(ConfigFile, "TIMING SETTINGS", "LoginDelay", LoginDelay)
        MouseClickCooldown := IniRead(ConfigFile, "TIMING SETTINGS", "MouseClickCooldown", MouseClickCooldown)
        GameMonitorInterval := IniRead(ConfigFile, "TIMING SETTINGS", "GameMonitorInterval", GameMonitorInterval)

        EnableDebugLogging := (IniRead(ConfigFile, "LOGGING SETTINGS", "EnableDebugLogging", EnableDebugLogging ? "true" : "false") = "true")
        EnableBackups := (IniRead(ConfigFile, "LOGGING SETTINGS", "EnableBackups", EnableBackups ? "true" : "false") = "true")
        BackupConfigOnly := (IniRead(ConfigFile, "LOGGING SETTINGS", "BackupConfigOnly", BackupConfigOnly ? "true" : "false") = "true")


        ; Coin pickup settings are now handled elsewhere (CoinRoundTimerDelay in TIMING SETTINGS)

        ; Load character profile settings
        MaxProfiles := IniRead(ConfigFile, "CHARACTER PROFILES", "MaxProfiles", MaxProfiles)
        if (profileToLoad != "") {
            CurrentProfile := profileToLoad
        } else {
            CurrentProfile := IniRead(ConfigFile, "CHARACTER PROFILES", "CurrentProfile", CurrentProfile)
        }
        Profile1Name := IniRead(ConfigFile, "CHARACTER PROFILES", "Profile1Name", Profile1Name)
        Profile2Name := IniRead(ConfigFile, "CHARACTER PROFILES", "Profile2Name", Profile2Name)
        Profile3Name := IniRead(ConfigFile, "CHARACTER PROFILES", "Profile3Name", Profile3Name)
        Profile4Name := IniRead(ConfigFile, "CHARACTER PROFILES", "Profile4Name", Profile4Name)
        Profile5Name := IniRead(ConfigFile, "CHARACTER PROFILES", "Profile5Name", Profile5Name)
        Profile6Name := IniRead(ConfigFile, "CHARACTER PROFILES", "Profile6Name", Profile6Name)
        Profile7Name := IniRead(ConfigFile, "CHARACTER PROFILES", "Profile7Name", Profile7Name)
        Profile8Name := IniRead(ConfigFile, "CHARACTER PROFILES", "Profile8Name", Profile8Name)
        Profile9Name := IniRead(ConfigFile, "CHARACTER PROFILES", "Profile9Name", Profile9Name)

        ; Load current profile's auto settings
        LoadProfileAutoSettings(CurrentProfile)

        ; Load cursor hashes
        hashString := IniRead(ConfigFile, "CURSOR SETTINGS", "ReadyCursorHashes", "")
        if (hashString != "") {
            ReadyCursorHashes := StrSplit(hashString, ",")
        }
        LogMessage("Loaded " . ReadyCursorHashes.Length . " ready cursor hashes")

        LogMessage("Configuration loaded successfully")
        LogMessage("GamePath loaded as: " . GamePath)
        LogMessage("Current profile: " . CurrentProfile . " - " . GetProfileName(CurrentProfile))
        return true

    } catch Error as e {
        LogMessage("Error loading configuration: " . e.Message)
        return false
    }
}

; Function to save hotkey settings to config file

; Function to create default configuration file
CreateDefaultConfig() {
    global ConfigFile
    
    defaultConfig := "; VSQ Configuration File`n"
    defaultConfig .= "; Edit these settings as needed - do not edit the main script`n"
    defaultConfig .= "; *** IMPORTANT SETUP INSTRUCTIONS ***`n"
    defaultConfig .= "; You MUST either:`n"
    defaultConfig .= "; 1) Update the GamePath below to point to your Stormhalter folder, OR`n"
    defaultConfig .= "; 2) Place this script in the same folder as Kesmai.Client.exe`n"
    defaultConfig .= "; The script will automatically check both locations`n`n"
    
    defaultConfig .= "[GAME SETTINGS]`n"
    defaultConfig .= "GamePath=C:\Program Files\Stormhalter\`n"
    defaultConfig .= "GameExecutable=Kesmai.Client.exe`n"
    defaultConfig .= "AutoClickLogin=true`n"
    defaultConfig .= "LoginButtonX=0`n"
    defaultConfig .= "LoginButtonY=0`n"
    defaultConfig .= "UseSecondaryMonitor=true`n"
    defaultConfig .= "SecondaryMonitorNumber=3`n"
    defaultConfig .= "AutoMaximizeWindow=true`n"
    defaultConfig .= "BackupFolder=VSQ_Backups`n`n"
    
    defaultConfig .= "[TIMING SETTINGS]`n"
    defaultConfig .= "ShortDelay=32`n"
    defaultConfig .= "MediumDelay=64`n"
    defaultConfig .= "LongDelay=128`n"
    defaultConfig .= "TooltipDisplayTime=2048`n"
    defaultConfig .= "AutoLoopInterval=128`n"
    defaultConfig .= "CoinRoundTimerDelay=1064`n"
    defaultConfig .= "LoginDelay=200`n"
    defaultConfig .= "MouseClickCooldown=2000`n"
    defaultConfig .= "GameMonitorInterval=2000`n"
    
    defaultConfig .= "[LOGGING SETTINGS]`n"
    defaultConfig .= "EnableDebugLogging=false`n"
    defaultConfig .= "EnableBackups=false`n"
    defaultConfig .= "BackupConfigOnly=true`n"
    defaultConfig .= "`n"
    
    
    defaultConfig .= "[CHARACTER PROFILES]`n"
    defaultConfig .= "MaxProfiles=9`n"
    defaultConfig .= "CurrentProfile=1`n"
    defaultConfig .= "Profile1Name=Profile 1`n"
    defaultConfig .= "Profile2Name=Profile 2`n"
    defaultConfig .= "Profile3Name=Profile 3`n"
    defaultConfig .= "Profile4Name=Profile 4`n"
    defaultConfig .= "Profile5Name=Profile 5`n"
    defaultConfig .= "Profile6Name=Profile 6`n"
    defaultConfig .= "Profile7Name=Profile 7`n"
    defaultConfig .= "Profile8Name=Profile 8`n"
    defaultConfig .= "Profile9Name=Profile 9`n`n"
    
    ; Add profile-specific auto settings for all 9 profiles
    Loop 9 {
        profileNum := A_Index
        defaultConfig .= "[PROFILE " . profileNum . "]`n"
        defaultConfig .= "EnableHealthMonitoring=true`n"
        defaultConfig .= "EnableManaMonitoring=true`n"
        defaultConfig .= "AttackKey1=`n"
        defaultConfig .= "AttackKey2=`n"
        defaultConfig .= "EnableAttackKey2=true`n"
        defaultConfig .= "AttackSpamReduction=false`n"
        defaultConfig .= "DrinkKey=`n"
        defaultConfig .= "HealthAreaX=0`n"
        defaultConfig .= "HealthAreaY=0`n"
        defaultConfig .= "ManaAreaX=0`n"
        defaultConfig .= "ManaAreaY=0`n"
        defaultConfig .= "CreatureAreaX=0`n"
        defaultConfig .= "CreatureAreaY=0`n"
        defaultConfig .= "EnableMASkill=false`n"
        defaultConfig .= "MAFistsKey=`n"
        defaultConfig .= "MARestockKey=`n"
        defaultConfig .= "CurrentMASkill=restock`n"
        defaultConfig .= "EnableKnightHeal=false`n"
        defaultConfig .= "KnightHealKey=`n"
        defaultConfig .= "MoneyRingKey=`n"
        defaultConfig .= "EnableActiveSpellScrolling=false`n"
        defaultConfig .= "ActiveSpellsLeftX=0`n"
        defaultConfig .= "ActiveSpellsLeftY=0`n"
        defaultConfig .= "ActiveSpellsRightX=0`n"
        defaultConfig .= "ActiveSpellsRightY=0`n"
        defaultConfig .= "ActiveSpellGoneX=0`n"
        defaultConfig .= "ActiveSpellGoneY=0`n"
        defaultConfig .= "EnableSpellCasting=false`n"
        defaultConfig .= "SpellCastingDelay=5000`n"
        defaultConfig .= "EnableSpellCreatureCheck=true`n"
        defaultConfig .= "WarmSpellKey=`n"
        defaultConfig .= "CastSpellKey=`n"
        defaultConfig .= "WarmedSpellX=0`n"
        defaultConfig .= "WarmedSpellY=0`n"
        defaultConfig .= "RecoverFumbleMain=false`n"
        defaultConfig .= "RecoverFumbleOffhand=false`n"
        defaultConfig .= "RecoverMainKey=`n"
        defaultConfig .= "RecoverOffhandKey=`n"
        defaultConfig .= "MainHandX=0`n"
        defaultConfig .= "MainHandY=0`n"
        defaultConfig .= "OffHandX=0`n"
        defaultConfig .= "OffHandY=0`n"
        defaultConfig .= "EnableCreatureListVerification=false`n"
        defaultConfig .= "CritListVerifyX=0`n"
        defaultConfig .= "CritListVerifyY=0`n"
        defaultConfig .= "CoinAreaTopLeftX=0`n"
        defaultConfig .= "CoinAreaTopLeftY=0`n"
        defaultConfig .= "CoinAreaBottomRightX=0`n"
        defaultConfig .= "CoinAreaBottomRightY=0`n`n"
    }
    

    defaultConfig .= "[CURSOR SETTINGS]`n"
    defaultConfig .= "; Comma-separated hashes, e.g., abc123,def456"
    defaultConfig .= "ReadyCursorHashes=76eec8d1,3b61f171,77acfae0`n`n"  
    try {
        FileAppend(defaultConfig, ConfigFile)
        return true
    } catch Error as e {
        LogMessage("Error creating default config: " . e.Message)
        return false
    }
}

; ========================================
; 3. UTILITY FUNCTIONS
; ========================================

; Function to log messages with timestamp
LogMessage(message) {
    global LogFile, EnableDebugLogging
    
    if (!EnableDebugLogging) {
        return
    }
    
    ; Create timestamp with milliseconds
    timestamp := FormatTime(A_Now, "yyyy-MM-dd HH:mm:ss.") . A_MSec
    
    ; Format log entry
    logEntry := "[" . timestamp . "] " . message . "`n"
    
    try {
        FileAppend(logEntry, LogFile)
    } catch Error as e {
        ; If logging fails, show in tooltip as fallback
        ToolTip("Log Error: " . e.Message)
        SetTimer(() => ToolTip(), -TooltipDisplayTime)
    }
}

; ========================================
; 3.2 BACKUP FUNCTIONS
; ========================================

; Function to create backup of script and/or config
CreateBackup() {
    global BackupFolder, ConfigFile, EnableBackups, BackupConfigOnly
    
    if (!EnableBackups) {
        return true
    }
    
    try {
        ; Create backup folder if it doesn't exist
        if (!DirExist(BackupFolder)) {
            DirCreate(BackupFolder)
        }
        
        ; Generate timestamp
        timestamp := FormatTime(A_Now, "yyyyMMdd_HHmmss")
        
        backupFiles := []
        
        ; Backup script file (unless config-only mode)
        if (!BackupConfigOnly) {
            scriptBackup := BackupFolder . "\VSQ_Backup_" . timestamp . ".ahk"
            FileCopy(A_ScriptFullPath, scriptBackup)
            backupFiles.Push(scriptBackup)
        }
        
        ; Backup config file if it exists
        if (FileExist(ConfigFile)) {
            configBackup := BackupFolder . "\VSQ_Config_Backup_" . timestamp . ".ini"
            FileCopy(ConfigFile, configBackup)
            backupFiles.Push(configBackup)
        }
        
        ; Log what was backed up
        if (backupFiles.Length > 0) {
            LogMessage("Backup created: " . backupFiles[1] . (backupFiles.Length > 1 ? " and " . backupFiles[2] : ""))
        }
        
        return true
        
    } catch Error as e {
        LogMessage("Error creating backup: " . e.Message)
        return false
    }
}

; ========================================
; 3.3 GAME MANAGEMENT FUNCTIONS
; ========================================

; Function to launch the game
LaunchGame() {
    global GamePath, GameExecutable, AutoClickLogin, AutoMaximizeWindow, UseSecondaryMonitor, SecondaryMonitorNumber
    
    LogMessage("Starting game launch sequence")
    
    ; Check if game is already running
    if (IsGameRunning()) {
        LogMessage("Game is already running")
        return true
    }
    
    try {
        ; First, try the configured path
        ; Ensure GamePath ends with backslash
        if (!InStr(GamePath, "\", , -1)) {
            GamePath := GamePath . "\"
        }
        
        fullPath := GamePath . GameExecutable
        LogMessage("Attempting to launch: " . fullPath)
        
        ; Check if the executable exists at the configured path
        if (!FileExist(fullPath)) {
            LogMessage("Game executable not found at configured path: " . fullPath)
            
            ; Check if the executable is in the same folder as the script
            scriptDir := A_ScriptDir . "\"
            scriptPath := scriptDir . GameExecutable
            LogMessage("Checking script directory: " . scriptPath)
            
            if (FileExist(scriptPath)) {
                LogMessage("Found game executable in script directory, using that instead")
                fullPath := scriptPath
                GamePath := scriptDir
            } else {
                LogMessage("Error: Game executable not found at either location")
                LogMessage("Checked paths: " . fullPath . " and " . scriptPath)
                return false
            }
        }
        
        ; Launch the game
        Run(fullPath, GamePath)
        LogMessage("Game executable launched from: " . GamePath)
        
        ; Wait for game window to appear
        if (WaitForGameWindow()) {
            LogMessage("Game window detected")
            
            ; Move to secondary monitor first if configured
            if (UseSecondaryMonitor) {
                MoveToSecondaryMonitor()
            }
            
            ; Then maximize window if configured
            if (AutoMaximizeWindow) {
                WinMaximize(GameWindowTitle)
                LogMessage("Game window maximized")
            }
            
            ; Auto-click login if configured
            if (AutoClickLogin) {
                ClickLoginButton()
            }
            
            
            LogMessage("Game launch sequence completed successfully")
            return true
        } else {
            LogMessage("Error: Game window not detected within timeout")
            return false
        }
        
    } catch Error as e {
        LogMessage("Error launching game: " . e.Message)
        return false
    }
}

; Function to wait for game window to appear
WaitForGameWindow() {
    global GameWindowTitle
    
    ; Wait up to 15 seconds for game window
    startTime := A_TickCount
    timeout := 15000
    
    while ((A_TickCount - startTime) < timeout) {
        if (WinExist(GameWindowTitle)) {
            ; Check if window is actually visible and reasonably sized
            WinGetPos(&x, &y, &width, &height, GameWindowTitle)
            if (width > 200 && height > 200) {
                return true
            }
        }
        Sleep(LongDelay)  ; Check every LongDelay
    }
    
    return false
}

; Function to move game to secondary monitor
MoveToSecondaryMonitor() {
    global GameWindowTitle, SecondaryMonitorNumber
    
    try {
        ; Get secondary monitor info
        MonitorGet(SecondaryMonitorNumber, &Left, &Top, &Right, &Bottom)
        
        ; Get current window size to preserve it
        WinGetPos(&currentX, &currentY, &currentWidth, &currentHeight, GameWindowTitle)
        
        ; Move window to secondary monitor without changing size
        WinMove(Left, Top, currentWidth, currentHeight, GameWindowTitle)
        LogMessage("Game moved to secondary monitor " . SecondaryMonitorNumber . " at " . Left . "," . Top)
        
    } catch Error as e {
        LogMessage("Error moving to secondary monitor: " . e.Message)
    }
}

; Function to click login button
ClickLoginButton() {
    global LoginButtonX, LoginButtonY, GameWindowTitle, LongDelay
    
    if (LoginButtonX = 0 && LoginButtonY = 0) {
        LogMessage("Login button coordinates not set - use Ctrl+Shift+L to set them")
        return
    }
    
    ; Click relative to the game window using button down/up events
    if (WinExist(GameWindowTitle)) {
        LogMessage("Clicking login button at relative coordinates " . LoginButtonX . "," . LoginButtonY . " within game window")
        
        ; Move mouse to coordinates first, then click (login screen needs this approach)
        
        WinActivate(GameWindowTitle)
        MouseMove(LoginButtonX, LoginButtonY)
        Sleep(LongDelay)  ; Brief delay to ensure UI registers mouse position
        SendClick("Left", 0, LoginButtonX, LoginButtonY)  ; Click at current mouse position
        LogMessage("Login button click sequence completed")
    } else {
        LogMessage("Game window not found - cannot click login button")
    }
}


; Function to check mouse button states
CheckMouseButtons() {
    global LastMouseClickTime
    static lastLeftState := 0, lastRightState := 0, lastMiddleState := 0
    
    ; Check current mouse button states
    currentLeftState := GetKeyState("LButton")
    currentRightState := GetKeyState("RButton") 
    currentMiddleState := GetKeyState("MButton")
    
    ; Detect button press (state changed from 0 to 1)
    if (currentLeftState && !lastLeftState) {
        LastMouseClickTime := A_TickCount
        LogMessage("Left mouse click detected - LastMouseClickTime updated")
    }
    if (currentRightState && !lastRightState) {
        LastMouseClickTime := A_TickCount
        LogMessage("Right mouse click detected - LastMouseClickTime updated")
    }
    if (currentMiddleState && !lastMiddleState) {
        LastMouseClickTime := A_TickCount
        LogMessage("Middle mouse click detected - LastMouseClickTime updated")
    }
    
    ; Update states for next check
    lastLeftState := currentLeftState
    lastRightState := currentRightState
    lastMiddleState := currentMiddleState
}

; Function to monitor game window and exit script if game closes
MonitorGameWindow() {
    global GameRunning, GameWindowTitle, EnableActiveSpellScrolling, LastMouseClickTime, GUIOpen
    
    if (WinExist(GameWindowTitle)) {
        if (!GameRunning) {
            GameRunning := true
            LogMessage("Game window detected - script ready")
        }
        
        ; Check active spell scrolling if enabled
        if (EnableActiveSpellScrolling) {
            ; Check if enough time has passed since last click (2 seconds)
            currentTime := A_TickCount
            if ((currentTime - LastMouseClickTime) >= MouseClickCooldown) {
                LogMessage("Executing active spell scrolling - no recent clicks")
                ExecuteActiveSpellScrolling()
            } else {
                LogMessage("Skipping active spell scrolling - recent click detected")
            }
        }
    } else {
        if (GameRunning) {
            GameRunning := false
            ; Only exit if GUI is not open
            if (!GUIOpen) {
                LogMessage("Game window closed - exiting script")
                ExitApp()
            } else {
                LogMessage("Game window closed - but GUI is open, script continues running")
            }
        }
    }
}

; ========================================
; 3.4 PROFILE MANAGEMENT FUNCTIONS
; ========================================

; Function to get profile name by number
GetProfileName(profileNumber) {
    global Profile1Name, Profile2Name, Profile3Name, Profile4Name, Profile5Name, Profile6Name, Profile7Name, Profile8Name, Profile9Name
    
    switch profileNumber {
        case 1: return Profile1Name
        case 2: return Profile2Name
        case 3: return Profile3Name
        case 4: return Profile4Name
        case 5: return Profile5Name
        case 6: return Profile6Name
        case 7: return Profile7Name
        case 8: return Profile8Name
        case 9: return Profile9Name
        default: return "Unknown Profile"
    }
}

; Function to save profile name
SaveProfileName(profileNumber, profileName) {
    global Profile1Name, Profile2Name, Profile3Name, Profile4Name, Profile5Name, Profile6Name, Profile7Name, Profile8Name, Profile9Name
    global ConfigFile
    
    try {
        ; Update the global variable
        switch profileNumber {
            case 1: Profile1Name := profileName
            case 2: Profile2Name := profileName
            case 3: Profile3Name := profileName
            case 4: Profile4Name := profileName
            case 5: Profile5Name := profileName
            case 6: Profile6Name := profileName
            case 7: Profile7Name := profileName
            case 8: Profile8Name := profileName
            case 9: Profile9Name := profileName
            default: return false
        }
        
        ; Save to config file
        IniWrite(profileName, ConfigFile, "CHARACTER PROFILES", "Profile" . profileNumber . "Name")
        
        LogMessage("Profile " . profileNumber . " name saved as: " . profileName)
        return true
    } catch Error as e {
        LogMessage("Error saving profile name: " . e.Message)
        return false
    }
}

; Function to load auto settings for a specific profile
LoadProfileAutoSettings(profileNumber) {
    global ConfigFile
    global EnableAuto, EnableHealthMonitoring, EnableManaMonitoring, AttackKey1, AttackKey2, EnableAttackKey2, AttackSpamReduction, DrinkKey, HealthAreaX, HealthAreaY, ManaAreaX, ManaAreaY, CreatureAreaX, CreatureAreaY, EnableMASkill, MAFistsKey, MARestockKey, CurrentMASkill, EnableKnightHeal, KnightHealKey, MoneyRingKey, EnableActiveSpellScrolling, ActiveSpellsLeftX, ActiveSpellsLeftY, ActiveSpellsRightX, ActiveSpellsRightY, ActiveSpellGoneX, ActiveSpellGoneY, EnableSpellCasting, SpellCastingDelay, EnableSpellCreatureCheck, LastSpellCastTime, WarmSpellKey, CastSpellKey, WarmedSpellX, WarmedSpellY, RecoverFumbleMain, RecoverFumbleOffhand, RecoverMainKey, RecoverOffhandKey, MainHandX, MainHandY, OffHandX, OffHandY, CritListVerifyX, CritListVerifyY, AutoClickLogin, LoginButtonX, LoginButtonY, CoinAreaTopLeftX, CoinAreaTopLeftY, CoinAreaBottomRightX, CoinAreaBottomRightY, EnableCreatureListVerification, PotionsPerRestock, UsedPotionsCount
    
    sectionName := "PROFILE " . profileNumber
    
    try {
        EnableHealthMonitoring := (IniRead(ConfigFile, sectionName, "EnableHealthMonitoring", EnableHealthMonitoring ? "true" : "false") = "true")
        EnableManaMonitoring := (IniRead(ConfigFile, sectionName, "EnableManaMonitoring", EnableManaMonitoring ? "true" : "false") = "true")
        AttackKey1 := IniRead(ConfigFile, sectionName, "AttackKey1", AttackKey1)
        AttackKey2 := IniRead(ConfigFile, sectionName, "AttackKey2", AttackKey2)
        EnableAttackKey2 := (IniRead(ConfigFile, sectionName, "EnableAttackKey2", EnableAttackKey2 ? "true" : "false") = "true")
        AttackSpamReduction := (IniRead(ConfigFile, sectionName, "AttackSpamReduction", AttackSpamReduction ? "true" : "false") = "true")
        DrinkKey := IniRead(ConfigFile, sectionName, "DrinkKey", DrinkKey)
        HealthAreaX := IniRead(ConfigFile, sectionName, "HealthAreaX", HealthAreaX)
        HealthAreaY := IniRead(ConfigFile, sectionName, "HealthAreaY", HealthAreaY)
        ManaAreaX := IniRead(ConfigFile, sectionName, "ManaAreaX", ManaAreaX)
        ManaAreaY := IniRead(ConfigFile, sectionName, "ManaAreaY", ManaAreaY)
        CreatureAreaX := IniRead(ConfigFile, sectionName, "CreatureAreaX", CreatureAreaX)
        CreatureAreaY := IniRead(ConfigFile, sectionName, "CreatureAreaY", CreatureAreaY)
        EnableMASkill := (IniRead(ConfigFile, sectionName, "EnableMASkill", EnableMASkill ? "true" : "false") = "true")
        MAFistsKey := IniRead(ConfigFile, sectionName, "MAFistsKey", MAFistsKey)
        MARestockKey := IniRead(ConfigFile, sectionName, "MARestockKey", MARestockKey)
        CurrentMASkill := IniRead(ConfigFile, sectionName, "CurrentMASkill", CurrentMASkill)
        PotionsPerRestock := IniRead(ConfigFile, sectionName, "PotionsPerRestock", PotionsPerRestock)
        UsedPotionsCount := IniRead(ConfigFile, sectionName, "UsedPotionsCount", UsedPotionsCount)
        EnableKnightHeal := (IniRead(ConfigFile, sectionName, "EnableKnightHeal", EnableKnightHeal ? "true" : "false") = "true")
        KnightHealKey := IniRead(ConfigFile, sectionName, "KnightHealKey", KnightHealKey)
        MoneyRingKey := IniRead(ConfigFile, sectionName, "MoneyRingKey", MoneyRingKey)
        EnableActiveSpellScrolling := (IniRead(ConfigFile, sectionName, "EnableActiveSpellScrolling", EnableActiveSpellScrolling ? "true" : "false") = "true")
        ActiveSpellsLeftX := IniRead(ConfigFile, sectionName, "ActiveSpellsLeftX", ActiveSpellsLeftX)
        ActiveSpellsLeftY := IniRead(ConfigFile, sectionName, "ActiveSpellsLeftY", ActiveSpellsLeftY)
        ActiveSpellsRightX := IniRead(ConfigFile, sectionName, "ActiveSpellsRightX", ActiveSpellsRightX)
        ActiveSpellsRightY := IniRead(ConfigFile, sectionName, "ActiveSpellsRightY", ActiveSpellsRightY)
        ActiveSpellGoneX := IniRead(ConfigFile, sectionName, "ActiveSpellGoneX", ActiveSpellGoneX)
        ActiveSpellGoneY := IniRead(ConfigFile, sectionName, "ActiveSpellGoneY", ActiveSpellGoneY)
        EnableSpellCasting := (IniRead(ConfigFile, sectionName, "EnableSpellCasting", EnableSpellCasting ? "true" : "false") = "true")
        SpellCastingDelay := IniRead(ConfigFile, sectionName, "SpellCastingDelay", SpellCastingDelay)
        EnableSpellCreatureCheck := (IniRead(ConfigFile, sectionName, "EnableSpellCreatureCheck", EnableSpellCreatureCheck ? "true" : "false") = "true")
        WarmSpellKey := IniRead(ConfigFile, sectionName, "WarmSpellKey", WarmSpellKey)
        CastSpellKey := IniRead(ConfigFile, sectionName, "CastSpellKey", CastSpellKey)
        WarmedSpellX := IniRead(ConfigFile, sectionName, "WarmedSpellX", WarmedSpellX)
        WarmedSpellY := IniRead(ConfigFile, sectionName, "WarmedSpellY", WarmedSpellY)
        RecoverFumbleMain := (IniRead(ConfigFile, sectionName, "RecoverFumbleMain", RecoverFumbleMain ? "true" : "false") = "true")
        RecoverFumbleOffhand := (IniRead(ConfigFile, sectionName, "RecoverFumbleOffhand", RecoverFumbleOffhand ? "true" : "false") = "true")
        RecoverMainKey := IniRead(ConfigFile, sectionName, "RecoverMainKey", RecoverMainKey)
        RecoverOffhandKey := IniRead(ConfigFile, sectionName, "RecoverOffhandKey", RecoverOffhandKey)
        MainHandX := IniRead(ConfigFile, sectionName, "MainHandX", MainHandX)
        MainHandY := IniRead(ConfigFile, sectionName, "MainHandY", MainHandY)
        OffHandX := IniRead(ConfigFile, sectionName, "OffHandX", OffHandX)
        OffHandY := IniRead(ConfigFile, sectionName, "OffHandY", OffHandY)
        EnableCreatureListVerification := (IniRead(ConfigFile, sectionName, "EnableCreatureListVerification", EnableCreatureListVerification ? "true" : "false") = "true")
        CritListVerifyX := IniRead(ConfigFile, sectionName, "CritListVerifyX", CritListVerifyX)
        CritListVerifyY := IniRead(ConfigFile, sectionName, "CritListVerifyY", CritListVerifyY)
        CoinAreaTopLeftX := IniRead(ConfigFile, sectionName, "CoinAreaTopLeftX", CoinAreaTopLeftX)
        CoinAreaTopLeftY := IniRead(ConfigFile, sectionName, "CoinAreaTopLeftY", CoinAreaTopLeftY)
        CoinAreaBottomRightX := IniRead(ConfigFile, sectionName, "CoinAreaBottomRightX", CoinAreaBottomRightX)
        CoinAreaBottomRightY := IniRead(ConfigFile, sectionName, "CoinAreaBottomRightY", CoinAreaBottomRightY)
        
        LogMessage("Loaded auto settings for profile " . profileNumber . " - " . GetProfileName(profileNumber))
        return true
    } catch Error as e {
        LogMessage("Error loading auto settings for profile " . profileNumber . ": " . e.Message)
        return false
    }
}

; Function to save auto settings for a specific profile
SaveProfileAutoSettings(profileNumber) {
    global ConfigFile
    global EnableAuto, EnableHealthMonitoring, EnableManaMonitoring, AttackKey1, AttackKey2, EnableAttackKey2, AttackSpamReduction, DrinkKey, HealthAreaX, HealthAreaY, ManaAreaX, ManaAreaY, CreatureAreaX, CreatureAreaY, EnableMASkill, MAFistsKey, MARestockKey, CurrentMASkill, EnableKnightHeal, KnightHealKey, MoneyRingKey, EnableActiveSpellScrolling, ActiveSpellsLeftX, ActiveSpellsLeftY, ActiveSpellsRightX, ActiveSpellsRightY, ActiveSpellGoneX, ActiveSpellGoneY, EnableSpellCasting, SpellCastingDelay, EnableSpellCreatureCheck, LastSpellCastTime, WarmSpellKey, CastSpellKey, WarmedSpellX, WarmedSpellY, RecoverFumbleMain, RecoverFumbleOffhand, RecoverMainKey, RecoverOffhandKey, MainHandX, MainHandY, OffHandX, OffHandY, CritListVerifyX, CritListVerifyY, CoinAreaTopLeftX, CoinAreaTopLeftY, CoinAreaBottomRightX, CoinAreaBottomRightY, EnableCreatureListVerification, PotionsPerRestock, UsedPotionsCount
    
    sectionName := "PROFILE " . profileNumber
    
    try {
        IniWrite(EnableHealthMonitoring ? "true" : "false", ConfigFile, sectionName, "EnableHealthMonitoring")
        IniWrite(EnableManaMonitoring ? "true" : "false", ConfigFile, sectionName, "EnableManaMonitoring")
        IniWrite(AttackKey1, ConfigFile, sectionName, "AttackKey1")
        IniWrite(AttackKey2, ConfigFile, sectionName, "AttackKey2")
        IniWrite(EnableAttackKey2 ? "true" : "false", ConfigFile, sectionName, "EnableAttackKey2")
        IniWrite(AttackSpamReduction ? "true" : "false", ConfigFile, sectionName, "AttackSpamReduction")
        IniWrite(DrinkKey, ConfigFile, sectionName, "DrinkKey")
        IniWrite(HealthAreaX, ConfigFile, sectionName, "HealthAreaX")
        IniWrite(HealthAreaY, ConfigFile, sectionName, "HealthAreaY")
        IniWrite(ManaAreaX, ConfigFile, sectionName, "ManaAreaX")
        IniWrite(ManaAreaY, ConfigFile, sectionName, "ManaAreaY")
        IniWrite(CreatureAreaX, ConfigFile, sectionName, "CreatureAreaX")
        IniWrite(CreatureAreaY, ConfigFile, sectionName, "CreatureAreaY")
        IniWrite(EnableMASkill ? "true" : "false", ConfigFile, sectionName, "EnableMASkill")
        IniWrite(MAFistsKey, ConfigFile, sectionName, "MAFistsKey")
        IniWrite(MARestockKey, ConfigFile, sectionName, "MARestockKey")
        IniWrite(CurrentMASkill, ConfigFile, sectionName, "CurrentMASkill")
        IniWrite(PotionsPerRestock, ConfigFile, sectionName, "PotionsPerRestock")
        IniWrite(UsedPotionsCount, ConfigFile, sectionName, "UsedPotionsCount")
        IniWrite(EnableKnightHeal ? "true" : "false", ConfigFile, sectionName, "EnableKnightHeal")
        IniWrite(KnightHealKey, ConfigFile, sectionName, "KnightHealKey")
        IniWrite(MoneyRingKey, ConfigFile, sectionName, "MoneyRingKey")
        IniWrite(EnableActiveSpellScrolling ? "true" : "false", ConfigFile, sectionName, "EnableActiveSpellScrolling")
        IniWrite(ActiveSpellsLeftX, ConfigFile, sectionName, "ActiveSpellsLeftX")
        IniWrite(ActiveSpellsLeftY, ConfigFile, sectionName, "ActiveSpellsLeftY")
        IniWrite(ActiveSpellsRightX, ConfigFile, sectionName, "ActiveSpellsRightX")
        IniWrite(ActiveSpellsRightY, ConfigFile, sectionName, "ActiveSpellsRightY")
        IniWrite(ActiveSpellGoneX, ConfigFile, sectionName, "ActiveSpellGoneX")
        IniWrite(ActiveSpellGoneY, ConfigFile, sectionName, "ActiveSpellGoneY")
        IniWrite(EnableSpellCasting ? "true" : "false", ConfigFile, sectionName, "EnableSpellCasting")
        IniWrite(SpellCastingDelay, ConfigFile, sectionName, "SpellCastingDelay")
        IniWrite(EnableSpellCreatureCheck ? "true" : "false", ConfigFile, sectionName, "EnableSpellCreatureCheck")
        IniWrite(WarmSpellKey, ConfigFile, sectionName, "WarmSpellKey")
        IniWrite(CastSpellKey, ConfigFile, sectionName, "CastSpellKey")
        IniWrite(WarmedSpellX, ConfigFile, sectionName, "WarmedSpellX")
        IniWrite(WarmedSpellY, ConfigFile, sectionName, "WarmedSpellY")
        IniWrite(RecoverFumbleMain ? "true" : "false", ConfigFile, sectionName, "RecoverFumbleMain")
        IniWrite(RecoverFumbleOffhand ? "true" : "false", ConfigFile, sectionName, "RecoverFumbleOffhand")
        IniWrite(RecoverMainKey, ConfigFile, sectionName, "RecoverMainKey")
        IniWrite(RecoverOffhandKey, ConfigFile, sectionName, "RecoverOffhandKey")
        IniWrite(MainHandX, ConfigFile, sectionName, "MainHandX")
        IniWrite(MainHandY, ConfigFile, sectionName, "MainHandY")
        IniWrite(OffHandX, ConfigFile, sectionName, "OffHandX")
        IniWrite(OffHandY, ConfigFile, sectionName, "OffHandY")
        IniWrite(EnableCreatureListVerification ? "true" : "false", ConfigFile, sectionName, "EnableCreatureListVerification")
        IniWrite(CritListVerifyX, ConfigFile, sectionName, "CritListVerifyX")
        IniWrite(CritListVerifyY, ConfigFile, sectionName, "CritListVerifyY")
        IniWrite(CoinAreaTopLeftX, ConfigFile, sectionName, "CoinAreaTopLeftX")
        IniWrite(CoinAreaTopLeftY, ConfigFile, sectionName, "CoinAreaTopLeftY")
        IniWrite(CoinAreaBottomRightX, ConfigFile, sectionName, "CoinAreaBottomRightX")
        IniWrite(CoinAreaBottomRightY, ConfigFile, sectionName, "CoinAreaBottomRightY")
        
        LogMessage("Saved auto settings for profile " . profileNumber . " - " . GetProfileName(profileNumber))
        return true
    } catch Error as e {
        LogMessage("Error saving auto settings for profile " . profileNumber . ": " . e.Message)
        return false
    }
}

; Function to restore default settings for a specific profile
RestoreProfileDefaults(profileNumber) {
    global ConfigFile
    
    sectionName := "PROFILE " . profileNumber
    
    try {
        ; Set all profile settings to their default values
        IniWrite("true", ConfigFile, sectionName, "EnableHealthMonitoring")
        IniWrite("true", ConfigFile, sectionName, "EnableManaMonitoring")
        IniWrite("", ConfigFile, sectionName, "AttackKey1")
        IniWrite("", ConfigFile, sectionName, "AttackKey2")
        IniWrite("true", ConfigFile, sectionName, "EnableAttackKey2")
        IniWrite("false", ConfigFile, sectionName, "AttackSpamReduction")
        IniWrite("", ConfigFile, sectionName, "DrinkKey")
        IniWrite("0", ConfigFile, sectionName, "HealthAreaX")
        IniWrite("0", ConfigFile, sectionName, "HealthAreaY")
        IniWrite("0", ConfigFile, sectionName, "ManaAreaX")
        IniWrite("0", ConfigFile, sectionName, "ManaAreaY")
        IniWrite("0", ConfigFile, sectionName, "CreatureAreaX")
        IniWrite("0", ConfigFile, sectionName, "CreatureAreaY")
        IniWrite("false", ConfigFile, sectionName, "EnableMASkill")
        IniWrite("", ConfigFile, sectionName, "MAFistsKey")
        IniWrite("", ConfigFile, sectionName, "MARestockKey")
        IniWrite("restock", ConfigFile, sectionName, "CurrentMASkill")
        IniWrite("1", ConfigFile, sectionName, "PotionsPerRestock")
        IniWrite("0", ConfigFile, sectionName, "UsedPotionsCount")
        IniWrite("false", ConfigFile, sectionName, "EnableKnightHeal")
        IniWrite("", ConfigFile, sectionName, "KnightHealKey")
        IniWrite("", ConfigFile, sectionName, "MoneyRingKey")
        IniWrite("false", ConfigFile, sectionName, "EnableActiveSpellScrolling")
        IniWrite("0", ConfigFile, sectionName, "ActiveSpellsLeftX")
        IniWrite("0", ConfigFile, sectionName, "ActiveSpellsLeftY")
        IniWrite("0", ConfigFile, sectionName, "ActiveSpellsRightX")
        IniWrite("0", ConfigFile, sectionName, "ActiveSpellsRightY")
        IniWrite("0", ConfigFile, sectionName, "ActiveSpellGoneX")
        IniWrite("0", ConfigFile, sectionName, "ActiveSpellGoneY")
        IniWrite("false", ConfigFile, sectionName, "EnableSpellCasting")
        IniWrite("5000", ConfigFile, sectionName, "SpellCastingDelay")
        IniWrite("true", ConfigFile, sectionName, "EnableSpellCreatureCheck")
        IniWrite("", ConfigFile, sectionName, "WarmSpellKey")
        IniWrite("", ConfigFile, sectionName, "CastSpellKey")
        IniWrite("0", ConfigFile, sectionName, "WarmedSpellX")
        IniWrite("0", ConfigFile, sectionName, "WarmedSpellY")
        IniWrite("false", ConfigFile, sectionName, "RecoverFumbleMain")
        IniWrite("false", ConfigFile, sectionName, "RecoverFumbleOffhand")
        IniWrite("", ConfigFile, sectionName, "RecoverMainKey")
        IniWrite("", ConfigFile, sectionName, "RecoverOffhandKey")
        IniWrite("0", ConfigFile, sectionName, "MainHandX")
        IniWrite("0", ConfigFile, sectionName, "MainHandY")
        IniWrite("0", ConfigFile, sectionName, "OffHandX")
        IniWrite("0", ConfigFile, sectionName, "OffHandY")
        IniWrite("false", ConfigFile, sectionName, "EnableCreatureListVerification")
        IniWrite("0", ConfigFile, sectionName, "CritListVerifyX")
        IniWrite("0", ConfigFile, sectionName, "CritListVerifyY")
        IniWrite("0", ConfigFile, sectionName, "CoinAreaTopLeftX")
        IniWrite("0", ConfigFile, sectionName, "CoinAreaTopLeftY")
        IniWrite("0", ConfigFile, sectionName, "CoinAreaBottomRightX")
        IniWrite("0", ConfigFile, sectionName, "CoinAreaBottomRightY")
        
        ; Restore timing settings to defaults
        IniWrite("32", ConfigFile, "TIMING SETTINGS", "ShortDelay")
        IniWrite("64", ConfigFile, "TIMING SETTINGS", "MediumDelay")
        IniWrite("128", ConfigFile, "TIMING SETTINGS", "LongDelay")
        IniWrite("2048", ConfigFile, "TIMING SETTINGS", "TooltipDisplayTime")
        IniWrite("128", ConfigFile, "TIMING SETTINGS", "AutoLoopInterval")
        IniWrite("1064", ConfigFile, "TIMING SETTINGS", "CoinRoundTimerDelay")
        IniWrite("200", ConfigFile, "TIMING SETTINGS", "LoginDelay")
        IniWrite("2000", ConfigFile, "TIMING SETTINGS", "MouseClickCooldown")
        IniWrite("2000", ConfigFile, "TIMING SETTINGS", "GameMonitorInterval")
        
        LogMessage("Restored default settings for profile " . profileNumber . " - " . GetProfileName(profileNumber))
        return true
    } catch Error as e {
        LogMessage("Error restoring default settings for profile " . profileNumber . ": " . e.Message)
        return false
    }
}

; Function to switch to a different profile
SwitchProfile(newProfileNumber) {
    global CurrentProfile, MaxProfiles, ConfigFile
    
    if (newProfileNumber < 1 || newProfileNumber > MaxProfiles) {
        LogMessage("Invalid profile number: " . newProfileNumber . " (must be 1-" . MaxProfiles . ")")
        return false
    }
    
    ; Save current profile's settings before switching
    SaveProfileAutoSettings(CurrentProfile)
    
    ; Switch to new profile
    CurrentProfile := newProfileNumber
    
    ; Load new profile's settings
    LoadProfileAutoSettings(CurrentProfile)
    
    ; Save the current profile to config
    IniWrite(CurrentProfile, ConfigFile, "CHARACTER PROFILES", "CurrentProfile")
    
    ; Update GUI if it's open
    if (GUIOpen && ConfigGUI && ConfigGUI.Hwnd) {
        try {
            ; Update profile dropdown to show new selection
            ConfigGUI["ProfileDropdown"].Choose(CurrentProfile)
            ; Update all GUI fields with new profile data
            LoadProfileToGUI()
        } catch Error as e {
            LogMessage("Error updating GUI for profile switch: " . e.Message)
        }
    }
    
    LogMessage("Switched to profile " . CurrentProfile . " - " . GetProfileName(CurrentProfile))
    return true
}

; Function to rename a profile
RenameProfile(profileNumber, newName) {
    global ConfigFile, MaxProfiles
    global Profile1Name, Profile2Name, Profile3Name, Profile4Name, Profile5Name, Profile6Name, Profile7Name, Profile8Name, Profile9Name
    
    if (profileNumber < 1 || profileNumber > MaxProfiles) {
        LogMessage("Invalid profile number: " . profileNumber . " (must be 1-" . MaxProfiles . ")")
        return false
    }
    
    try {
        IniWrite(newName, ConfigFile, "CHARACTER PROFILES", "Profile" . profileNumber . "Name")
        
        ; Update the global variable
        switch profileNumber {
            case 1: Profile1Name := newName
            case 2: Profile2Name := newName
            case 3: Profile3Name := newName
            case 4: Profile4Name := newName
            case 5: Profile5Name := newName
            case 6: Profile6Name := newName
            case 7: Profile7Name := newName
            case 8: Profile8Name := newName
            case 9: Profile9Name := newName
        }
        
        LogMessage("Renamed profile " . profileNumber . " to: " . newName)
        return true
    } catch Error as e {
        LogMessage("Error renaming profile " . profileNumber . ": " . e.Message)
        return false
    }
}

; Function to switch to a profile (hotkey helper)
SwitchToProfile(profileNumber) {
    global CurrentProfile
    
    if (SwitchProfile(profileNumber)) {
        ToolTip("Switched to Profile " . profileNumber . " - " . GetProfileName(profileNumber), , , 11)
        SetTimer(() => ToolTip(, , , 11), -TooltipDisplayTime)
    } else {
        ToolTip("Failed to switch to Profile " . profileNumber, , , 11)
        SetTimer(() => ToolTip(, , , 11), -TooltipDisplayTime)
    }
}



; ========================================
; 3.5 INPUT FUNCTIONS
; ========================================

; SendKey - Sends key down/up events with delay
SendKey(key, delay := 0) {
    global ShortDelay, GameWindowTitle
    try {
        ; Check if game window is active before sending key
        if (!WinExist(GameWindowTitle)) {
            LogMessage("SendKey: Game window not found - key send cancelled")
            return false
        }
        
        ; Activate game window to ensure keys are sent to the game
        WinActivate(GameWindowTitle)
        
        SendInput("{" . key . " down}")
        if (delay > 0) {
            Sleep(delay)
        } else {
            Sleep(ShortDelay)
        }
        SendInput("{" . key . " up}")
        LogMessage("SendKey: Sent key " . key . " with delay " . (delay > 0 ? delay : ShortDelay) . "ms")
        return true
    } catch Error as e {
        LogMessage("SendKey: Error sending key " . key . ": " . e.Message)
        return false
    }
}

; SendClick - Sends mouse button down/up events with delay and optional coordinates
SendClick(button := "Left", delay := 0, x := "", y := "") {
    global ShortDelay, GameWindowTitle
    try {
        ; Check if game window is active before clicking
        if (!WinExist(GameWindowTitle)) {
            LogMessage("SendClick: Game window not found - click cancelled")
            return false
        }
        
        ; Activate game window to ensure clicks are sent to the game
        WinActivate(GameWindowTitle)
        
        if (x != "" && y != "") {
            ; Click at specific coordinates
            Click(button . " Down", x, y)
            if (delay > 0) {
                Sleep(delay)
            } else {
                Sleep(ShortDelay)
            }
            Click(button . " Up", x, y)
            LogMessage("SendClick: Sent " . button . " click at " . x . "," . y . " with delay " . (delay > 0 ? delay : ShortDelay) . "ms")
        } else {
            ; Click at current mouse position
            Click(button . " Down")
            if (delay > 0) {
                Sleep(delay)
            } else {
                Sleep(ShortDelay)
            }
            Click(button . " Up")
            LogMessage("SendClick: Sent " . button . " click with delay " . (delay > 0 ? delay : ShortDelay) . "ms")
        }
        return true
    } catch Error as e {
        LogMessage("SendClick: Error sending " . button . " click: " . e.Message)
        return false
    }
}

; Function to check if game is running
IsGameRunning() {
    global GameWindowTitle
    return WinExist(GameWindowTitle)
}

; ========================================
; 3.6 PIXEL DETECTION FUNCTIONS
; ========================================

; Function to count pixels of a specific color at given coordinates
CountPixels(x, y, colorType) {
    pixelCount := 0
    for offset in [-1, 0, 1] {
        pixelX := x + offset
        pixelY := y
        color := PixelGetColor(pixelX, pixelY, "RGB")
        red := (color >> 16) & 0xFF
        green := (color >> 8) & 0xFF
        blue := color & 0xFF
        
        if (colorType = "red") {
            if (red > 100 && green < 50 && blue < 50) {
                pixelCount++
            }
        } else if (colorType = "blue") {
            if (blue > 100 && red < 50 && green < 50) {
                pixelCount++
            }
        } else if (colorType = "orange") {
            ; Check if pixel is bright orange/yellow (high red and green, lower blue)
            ; More sensitive thresholds for vibrant warm colors
            if (red > 100 && green > 80 && blue < 100 && (red + green) > (blue * 1.5)) {
                pixelCount++
            }
        } else if (colorType = "dark") {
            ; Check if pixel is very dark (very low RGB values, almost black) but not completely black
            if (red < 50 && green < 50 && blue < 50) {
                pixelCount++
            }
        } else if (colorType = "black") {
            ; Check if pixel is black (all RGB values close to 0)
            if (red < 50 && green < 50 && blue < 50) {
                pixelCount++
            }
        } else if (colorType = "gold") {
            ; Check if pixel matches coin color criteria (hardcoded values)
            if (red >= 159 && red <= 251 && 
                green >= 123 && green <= 234 && 
                blue >= 30 && blue <= 123) {
                pixelCount++
            }
        } else if (colorType = "green") {
            ; Check if pixel is bright green (high green, lower red and blue)
            ; Based on the vibrant green colors in the creature list
            if (green > 150 && red < 100 && blue < 100) {
                pixelCount++
            }
        }
    }
    return pixelCount
}

; Function to count red pixels at given coordinates (for health)
CountRedPixels(x, y) {
    return CountPixels(x, y, "red")
}

; Function to count blue pixels at given coordinates (for mana)
CountBluePixels(x, y) {
    return CountPixels(x, y, "blue")
}

; Function to count orange pixels at given coordinates (for active spells)
CountOrangePixels(x, y) {
    return CountPixels(x, y, "orange")
}

; Function to count dark pixels at given coordinates (for active spell gone)
CountDarkPixels(x, y) {
    return CountPixels(x, y, "dark")
}

; Function to count black pixels at given coordinates (for creature detection)
CountBlackPixels(x, y) {
    return CountPixels(x, y, "black")
}

; Function to count gold pixels at given coordinates (for coin detection)
CountGoldPixels(x, y) {
    return CountPixels(x, y, "gold")
}

; Function to count green pixels at given coordinates (for creature list verification)
CountGreenPixels(x, y) {
    return CountPixels(x, y, "green")
}

; Function to check health status by examining red pixels
CheckHealth() {
    global HealthAreaX, HealthAreaY
    
    try {
        redPixelCount := CountRedPixels(HealthAreaX, HealthAreaY)
        
        ; Consider healthy if at least 2 out of 3 pixels are red
        isHealthy := redPixelCount >= 2
        
        LogMessage("Health check - Red pixels: " . redPixelCount . "/3, Healthy: " . (isHealthy ? "Yes" : "No"))
        
        return isHealthy
        
    } catch Error as e {
        LogMessage("Error checking health: " . e.Message)
        return false
    }
}

; Function to check mana status by examining blue pixels
CheckMana() {
    global ManaAreaX, ManaAreaY
    
    try {
        bluePixelCount := CountBluePixels(ManaAreaX, ManaAreaY)
        
        ; Consider sufficient mana if at least 2 out of 3 pixels are blue
        hasMana := bluePixelCount >= 2
        
        LogMessage("Mana check - Blue pixels: " . bluePixelCount . "/3, Has Mana: " . (hasMana ? "Yes" : "No"))
        
        return hasMana
        
    } catch Error as e {
        LogMessage("Error checking mana: " . e.Message)
        return false
    }
}

; Check if creatures are present (black pixels = no creatures)
CheckCreatures() {
    global CreatureAreaX, CreatureAreaY, CritListVerifyX, CritListVerifyY
    
    if (CreatureAreaX = 0 && CreatureAreaY = 0) {
        LogMessage("CreatureCheck: Coordinates not set - assuming creatures present")
        return true  ; Default to true if coordinates not set
    }
    
    try {
        blackPixelCount := CountBlackPixels(CreatureAreaX, CreatureAreaY)
        
        ; Consider creatures present if at least 2 out of 3 pixels are NOT black
        creaturesPresent := blackPixelCount < 2
        
        ; Additional verification: check if we're actually on the creature list (if enabled)
        if (creaturesPresent && EnableCreatureListVerification && CritListVerifyX != 0 && CritListVerifyY != 0) {
            greenPixelCount := CountGreenPixels(CritListVerifyX, CritListVerifyY)
            ; Only consider creatures present if we also see green pixels (creature list is active)
            creaturesPresent := greenPixelCount >= 3
            LogMessage("CreatureCheck: Black pixels: " . blackPixelCount . "/3, Green pixels: " . greenPixelCount . "/3, Creatures: " . (creaturesPresent ? "YES" : "NO"))
        } else {
            LogMessage("CreatureCheck: Black pixels: " . blackPixelCount . "/3, Creatures: " . (creaturesPresent ? "YES" : "NO"))
        }
        
        return creaturesPresent
        
    } catch Error as e {
        LogMessage("CreatureCheck: Error checking creatures: " . e.Message)
        return true  ; Default to true on error
    }
}

; Function to check if enough time has passed since last spell cast
CheckSpellDelay() {
    global LastSpellCastTime, SpellCastingDelay
    
    ; If no spell has been cast yet, allow casting
    if (LastSpellCastTime = 0) {
        return true
    }
    
    currentTime := A_TickCount
    if ((currentTime - LastSpellCastTime) < SpellCastingDelay) {
        LogMessage("Auto: Spell casting delay not yet exceeded - skipping cast")
        return false
    }
    
    return true
}

; Function to check if a spell is currently warmed
CheckWarmed() {
    global WarmedSpellX, WarmedSpellY
    
    ; Check if warmed spell coordinates are set
    if (WarmedSpellX = 0 && WarmedSpellY = 0) {
        return false
    }
    
    ; Check if spell is warmed by looking for dark pixels (spell is NOT warmed when dark)
    darkPixelCount := CountDarkPixels(WarmedSpellX, WarmedSpellY)
    isSpellWarmed := darkPixelCount < 2
    
    if (isSpellWarmed) {
        LogMessage("Auto: Spell is currently warmed")
    }
    
    return isSpellWarmed
}

; Function to check if player is ready to act based on cursor hash
CheckReady(reset := false) {
    global ReadyCursorHashes
    
    static lastHash := ""
    static lastLogTime := 0
    
    ; Reset if requested (for debugging)
    if (reset) {
        lastHash := ""
        lastLogTime := 0
        LogMessage("CheckReady: Resetting state")
    }
    
    ; Get current hash
    currentHash := GetCursorHash()
    if (currentHash = "") {
        LogMessage("CheckReady: Failed to get cursor hash")
        return true  ; Default to ready on error
    }
    
    ; Check if it matches any ready hash
    isReady := false
    for hash in ReadyCursorHashes {
        if (currentHash = hash) {
            isReady := true
            break
        }
    }
    
    ; Log only on state change
    if (currentHash != lastHash) {
        LogMessage("CheckReady: Hash " . currentHash . " - " . (isReady ? "READY" : "BUSY"))
        lastHash := currentHash
    }
    
    return isReady
}

; Function to get current cursor hash (visual fingerprint)
GetCursorHash() {
    ; Get cursor info
    ci := Buffer(8 + 2 * A_PtrSize, 0)  ; sizeof(CURSORINFO) = 8 + 2*Ptr (cbSize, flags, hCursor, ptScreenPos)
    NumPut("UInt", ci.Size, ci, 0)
    if !DllCall("user32\GetCursorInfo", "Ptr", ci)
        return ""
    
    hCursor := NumGet(ci, 8, "Ptr")
    if !hCursor
        return ""
    
    ; Get icon info
    ii := Buffer(8 + 3 * A_PtrSize, 0)  ; sizeof(ICONINFO) = 8 + 3*Ptr (fIcon, xHotspot, yHotspot, hbmMask, hbmColor)
    if !DllCall("user32\GetIconInfo", "Ptr", hCursor, "Ptr", ii)
        return ""
    
    hbmMask := NumGet(ii, 8 + A_PtrSize, "Ptr")
    hbmColor := NumGet(ii, 8 + 2 * A_PtrSize, "Ptr")
    
    ; Get cursor dimensions from hbmMask bitmap
    bm := Buffer(4*7 + 2*A_PtrSize, 0)  ; sizeof(BITMAP)
    DllCall("GetObject", "Ptr", hbmMask, "Int", bm.Size, "Ptr", bm)
    width := NumGet(bm, 4, "Int")
    height := Abs(NumGet(bm, 8, "Int"))  ; Height can be negative for top-down
    
    ; Handle monochrome cursors (height is doubled)
    if (!hbmColor)
        height //= 2
    
    ; Create bitmap and draw cursor on it
    pBitmap := Gdip_CreateBitmap(width, height)
    G := Gdip_GraphicsFromImage(pBitmap)
    hdc := Gdip_GetDC(G)
    DllCall("user32\DrawIconEx", "Ptr", hdc, "Int", 0, "Int", 0, "Ptr", hCursor, "Int", width, "Int", height, "UInt", 0, "Ptr", 0, "UInt", 3)  ; DI_NORMAL
    Gdip_ReleaseDC(G, hdc)
    Gdip_DeleteGraphics(G)
    
    ; Compute simple hash from pixel data (rolling hash for exact match detection)
    if (Gdip_LockBits(pBitmap, 0, 0, width, height, &Stride, &Scan0, &BitmapData) != 0) {
        ; Error locking bits, cleanup and return empty hash
        Gdip_DisposeImage(pBitmap)
        DllCall("DeleteObject", "Ptr", hbmMask)
        DllCall("DeleteObject", "Ptr", hbmColor)
        return ""
    }
    
    hash := 0
    Loop height
    {
        y := A_Index - 1
        Ptr := Scan0 + y * Stride
        Loop width
        {
            argb := NumGet(Ptr, 0, "UInt")
            hash := Mod((hash * 31 + argb), 0xFFFFFFFF)
            Ptr += 4
        }
    }
    
    ; Cleanup
    Gdip_UnlockBits(pBitmap, &BitmapData)
    Gdip_DisposeImage(pBitmap)
    DllCall("DeleteObject", "Ptr", hbmMask)
    DllCall("DeleteObject", "Ptr", hbmColor)
    
    return Format("{:08x}", hash)  ; 8-char hex hash (adjust if collisions occur)
}

SaveCursorHashes() {
    global ConfigFile, ReadyCursorHashes
    hashString := ""
    for hash in ReadyCursorHashes {
        hashString .= (hashString ? "," : "") . hash
    }
    IniWrite(hashString, ConfigFile, "CURSOR SETTINGS", "ReadyCursorHashes")
    LogMessage("Saved " . ReadyCursorHashes.Length . " ready cursor hashes")
}

; ========================================
; 3.7 GDI+ FUNCTIONS (MINIMAL SET)
; ========================================
; Only the functions actually used by the script are included below

; Helper function for Gdip_LockBits
CreateRect(&Rect, x, y, w, h)
{
	Rect := Buffer(16)
	NumPut("UInt", x, "UInt", y, "UInt", w, "UInt", h, Rect)
}

; GDI+ Core Functions
Gdip_Startup()
{
	if (!DllCall("LoadLibrary", "str", "gdiplus", "UPtr")) {
		throw Error("Could not load GDI+ library")
	}

	si := Buffer(A_PtrSize = 4 ? 20:32, 0) ; sizeof(GdiplusStartupInputEx) = 20, 32
	NumPut("uint", 0x2, si)
	NumPut("uint", 0x4, si, A_PtrSize = 4 ? 16:24)
	DllCall("gdiplus\GdiplusStartup", "UPtr*", &pToken:=0, "Ptr", si, "UPtr", 0)
	if (!pToken) {
		throw Error("Gdiplus failed to start. Please ensure you have gdiplus on your system")
	}

	return pToken
}

Gdip_Shutdown(pToken)
{
	DllCall("gdiplus\GdiplusShutdown", "UPtr", pToken)
	hModule := DllCall("GetModuleHandle", "str", "gdiplus", "UPtr")
	if (!hModule) {
		throw Error("GDI+ library was unloaded before shutdown")
	}
	if (!DllCall("FreeLibrary", "UPtr", hModule)) {
		throw Error("Could not free GDI+ library")
	}

	return 0
}

Gdip_CreateBitmap(Width, Height, Format:=0x26200A)
{
	DllCall("gdiplus\GdipCreateBitmapFromScan0", "Int", Width, "Int", Height, "Int", 0, "Int", Format, "UPtr", 0, "UPtr*", &pBitmap:=0)
	return pBitmap
}

Gdip_GraphicsFromImage(pBitmap)
{
	DllCall("gdiplus\GdipGetImageGraphicsContext", "UPtr", pBitmap, "UPtr*", &pGraphics:=0)
	return pGraphics
}

Gdip_GetDC(pGraphics)
{
	DllCall("gdiplus\GdipGetDC", "UPtr", pGraphics, "UPtr*", &hdc:=0)
	return hdc
}

Gdip_ReleaseDC(pGraphics, hdc)
{
	return DllCall("gdiplus\GdipReleaseDC", "UPtr", pGraphics, "UPtr", hdc)
}

Gdip_DeleteGraphics(pGraphics)
{
	return DllCall("gdiplus\GdipDeleteGraphics", "UPtr", pGraphics)
}

Gdip_DisposeImage(pBitmap)
{
	return DllCall("gdiplus\GdipDisposeImage", "UPtr", pBitmap)
}

Gdip_LockBits(pBitmap, x, y, w, h, &Stride, &Scan0, &BitmapData, LockMode := 3, PixelFormat := 0x26200a)
{
	CreateRect(&_Rect:="", x, y, w, h)
	BitmapData := Buffer(16+2*(A_PtrSize ? A_PtrSize : 4), 0)
	_E := DllCall("Gdiplus\GdipBitmapLockBits", "UPtr", pBitmap, "UPtr", _Rect.Ptr, "UInt", LockMode, "Int", PixelFormat, "UPtr", BitmapData.Ptr)
	Stride := NumGet(BitmapData, 8, "Int")
	Scan0 := NumGet(BitmapData, 16, "UPtr")
	return _E
}

Gdip_UnlockBits(pBitmap, &BitmapData)
{
	return DllCall("Gdiplus\GdipBitmapUnlockBits", "UPtr", pBitmap, "UPtr", BitmapData.Ptr)
}

Gdip_BrushCreateSolid(ARGB:=0xff000000)
{
	DllCall("gdiplus\GdipCreateSolidFill", "UInt", ARGB, "UPtr*", &pBrush:=0)
	return pBrush
}

Gdip_FillRectangle(pGraphics, pBrush, x, y, w, h)
{
	return DllCall("gdiplus\GdipFillRectangle"
					, "UPtr", pGraphics
					, "UPtr", pBrush
					, "Float", x
					, "Float", y
					, "Float", w
					, "Float", h)
}

Gdip_CreateHBITMAPFromBitmap(pBitmap, Background:=0xffffffff)
{
	DllCall("gdiplus\GdipCreateHBITMAPFromBitmap", "UPtr", pBitmap, "UPtr*", &hbm:=0, "Int", Background)
	return hbm
}

Gdip_DeleteBrush(pBrush)
{
	return DllCall("gdiplus\GdipDeleteBrush", "UPtr", pBrush)
}

; ========================================
; 4. AUTOMATION FUNCTIONS
; ========================================

; Main automation loop - runs continuously when Auto mode is enabled
AutoLoop() {
    global EnableAuto, GameRunning, GameWindowTitle
    
    ; Only run if Auto mode is enabled and game is running
    if (!EnableAuto || !GameRunning) {
        return
    }
    
    ; Only run if game window is active/focused
    if (!WinActive(GameWindowTitle)) {
        return
    }
    
    ; Continuously determine the next action (regardless of ready state)
    static lastAction := ""
    currentAction := GetNextAction()
    
    ; If action changed, log it
    if (currentAction != lastAction) {
        if (currentAction != "") {
            LogMessage("Auto: Next action determined: " . currentAction)
        } else {
            LogMessage("Auto: No action needed")
        }
        lastAction := currentAction
    }
    
    ; Only execute if we have an action and player is ready
    if (currentAction != "" && CheckReady()) {
        ExecuteAction(currentAction)
    }
}

; Determine the next action based on priority
GetNextAction() {
    global EnableHealthMonitoring, EnableManaMonitoring, EnableMASkill, AttackKey1, AttackKey2, EnableAttackKey2, AttackSpamReduction, EnableKnightHeal, KnightHealKey, DrinkKey, EnableSpellCasting, SpellCastingDelay, EnableSpellCreatureCheck, LastSpellCastTime, RecoverFumbleMain, RecoverFumbleOffhand, MainHandX, MainHandY, OffHandX, OffHandY
    
    ; Priority 1: Fumble recovery - highest priority
    if (RecoverFumbleMain && MainHandX != 0 && MainHandY != 0) {
        darkPixelCount := CountDarkPixels(MainHandX, MainHandY)
        if (darkPixelCount >= 3) {
            return "RECOVER-MAIN"
        }
    }
    if (RecoverFumbleOffhand && OffHandX != 0 && OffHandY != 0) {
        darkPixelCount := CountDarkPixels(OffHandX, OffHandY)
        if (darkPixelCount >= 3) {
            return "RECOVER-OFFHAND"
        }
    }
    
    ; Priority 2: Health is low - heal immediately
    if (EnableHealthMonitoring && !CheckHealth()) {
        return "HEAL"
    }
    
    ; Priority 3: Cast warmed spell - if spell casting is enabled and spell is already warmed
    if (EnableSpellCasting && CheckWarmed()) {
        return "CAST"
    }
    
    ; Priority 4: MASkill - if enabled and has mana
    if (EnableMASkill && EnableManaMonitoring && CheckMana()) {
        return "MASKILL"
    }
    
    ; Priority 5: Cast - if spell casting is enabled and has mana
    if (EnableSpellCasting && EnableManaMonitoring && CheckMana() && CheckSpellDelay()) {
        ; Only check for creatures if creature checking is enabled for spells
        if (EnableSpellCreatureCheck) {
            if (AttackSpamReduction && !CheckCreatures()) {
                LogMessage("Auto: No creatures detected - skipping cast")
                return ""  ; No action if no creatures
            }
        }
        
        return "CAST"
    }
    
    ; Priority 6: Attack - if we have attack keys configured
    if (AttackKey1 != "" || (EnableAttackKey2 && AttackKey2 != "")) {
        ; Check if AttackSpamReduction is enabled and creatures are present
        if (AttackSpamReduction && !CheckCreatures()) {
            LogMessage("Auto: No creatures detected - skipping attack")
            return ""  ; No action if no creatures
        }
        return "ATTACK"
    }
    
    ; No action needed
    return ""
}

; Execute the determined action
ExecuteAction(action) {
    global AttackKey1, AttackKey2, EnableAttackKey2, DrinkKey, MAFistsKey, MARestockKey, CurrentMASkill, EnableKnightHeal, KnightHealKey, WarmSpellKey, CastSpellKey, WarmedSpellX, WarmedSpellY, RecoverMainKey, RecoverOffhandKey, LastSpellCastTime, PotionsPerRestock, UsedPotionsCount, EnableMASkill, TooltipDisplayTime
    
    switch action {
        case "RECOVER-MAIN":
            if (RecoverMainKey != "") {
                SendKey(RecoverMainKey)
                LogMessage("Auto: Recovering main hand weapon")
            }
        case "RECOVER-OFFHAND":
            if (RecoverOffhandKey != "") {
                SendKey(RecoverOffhandKey)
                LogMessage("Auto: Recovering offhand weapon")
            }
        case "HEAL":
            ; Check if Knight Heal is enabled and we have mana
            if (EnableKnightHeal && CheckMana()) {
                if (KnightHealKey != "") {
                    SendKey(KnightHealKey)
                    LogMessage("Auto: Executed Knight Heal (mana-based heal)")
                }
            } else if (DrinkKey != "") {
                SendKey(DrinkKey)
                ; Track drink usage for MA Auto and Restock modes (only if MA Skills are enabled)
                if (EnableMASkill && (CurrentMASkill = "auto" || CurrentMASkill = "restock")) {
                    UsedPotionsCount++
                    LogMessage("Auto: Used potion #" . UsedPotionsCount . " (total used: " . UsedPotionsCount . "/" . PotionsPerRestock . ")")
                    
                    ; Warn if using potions faster than restocking
                    if (UsedPotionsCount >= 6) {
                        ToolTip("WARNING: Using potions faster than restocking! Used: " . UsedPotionsCount . " (Restock: " . PotionsPerRestock . ")", , , 20)
                        SetTimer(() => ToolTip(, , , 20), -TooltipDisplayTime)
                    }
                }
                LogMessage("Auto: Executed drink action" . (EnableKnightHeal ? " (no mana for Knight Heal)" : ""))
            }
        case "MASKILL":
            if (CurrentMASkill = "fists") {
                ; Check if AttackSpamReduction is enabled and creatures are present
                if (AttackSpamReduction && !CheckCreatures()) {
                    LogMessage("Auto: No creatures detected - skipping MA Fists action")
                    return
                }
                ; Send MAFistsKey then AttackKey2 (if enabled)
                if (MAFistsKey != "") {
                    SendKey(MAFistsKey)
                }
                if (EnableAttackKey2 && AttackKey2 != "") {
                    Sleep(ShortDelay)  ; Delay between keys
                    SendKey(AttackKey2)
                }
                LogMessage("Auto: Executed MA Fists action")
            } else if (CurrentMASkill = "restock") {
                ; Restock mode: only restock if we've used enough potions
                if (UsedPotionsCount >= PotionsPerRestock) {
                    ; We've used potions, restock to replace them
                    if (MARestockKey != "") {
                        SendKey(MARestockKey)
                    }
                    
                    ; Reduce the used potions count by the amount restocked
                    UsedPotionsCount := UsedPotionsCount - PotionsPerRestock
                    LogMessage("Auto: MA Restock mode - Restocking to replace " . PotionsPerRestock . " potions (remaining used: " . UsedPotionsCount . ")")
                    
                    ; Check if AttackSpamReduction is enabled and creatures are present before attacking
                    if (AttackSpamReduction && !CheckCreatures()) {
                        LogMessage("Auto: No creatures detected - skipping MA Restock attacks")
                        return
                    }
                    
                    ; Send AttackKey1 and AttackKey2 (if enabled)
                    if (AttackKey1 != "") {
                        Sleep(ShortDelay)  ; Delay between keys
                        SendKey(AttackKey1)
                    }
                    if (EnableAttackKey2 && AttackKey2 != "") {
                        Sleep(ShortDelay)  ; Delay between keys
                        SendKey(AttackKey2)
                    }
                    LogMessage("Auto: Executed MA Restock action")
                } else {
                    ; No potions used, skip restock to avoid "not enough room" errors
                    LogMessage("Auto: MA Restock mode - Skipping restock (only " . UsedPotionsCount . " potions used, need " . PotionsPerRestock . ")")
                    
                    ; Still attack even if we're not restocking
                    ; Check if AttackSpamReduction is enabled and creatures are present before attacking
                    if (AttackSpamReduction && !CheckCreatures()) {
                        LogMessage("Auto: No creatures detected - skipping MA Restock attacks")
                        return
                    }
                    
                    ; Send AttackKey1 and AttackKey2 (if enabled)
                    if (AttackKey1 != "") {
                        Sleep(ShortDelay)  ; Delay between keys
                        SendKey(AttackKey1)
                    }
                    if (EnableAttackKey2 && AttackKey2 != "") {
                        Sleep(ShortDelay)  ; Delay between keys
                        SendKey(AttackKey2)
                    }
                    LogMessage("Auto: Executed MA Restock attacks (no restock needed)")
                }
            } else if (CurrentMASkill = "auto") {
                ; Auto mode: restock if we've used enough potions, otherwise do fists
                if (UsedPotionsCount >= PotionsPerRestock) {
                    ; We've used potions, restock to replace them
                    if (MARestockKey != "") {
                        SendKey(MARestockKey)
                    }
                    
                    ; Reduce the used potions count by the amount restocked
                    UsedPotionsCount := UsedPotionsCount - PotionsPerRestock
                    LogMessage("Auto: MA Auto mode - Restocking to replace " . PotionsPerRestock . " potions (remaining used: " . UsedPotionsCount . ")")
                    
                    ; Check if AttackSpamReduction is enabled and creatures are present before attacking
                    if (AttackSpamReduction && !CheckCreatures()) {
                        LogMessage("Auto: No creatures detected - skipping MA Auto Restock attacks")
                        return
                    }
                    
                    ; Send AttackKey1 and AttackKey2 (if enabled)
                    if (AttackKey1 != "") {
                        Sleep(ShortDelay)  ; Delay between keys
                        SendKey(AttackKey1)
                    }
                    if (EnableAttackKey2 && AttackKey2 != "") {
                        Sleep(ShortDelay)  ; Delay between keys
                        SendKey(AttackKey2)
                    }
                    LogMessage("Auto: Executed MA Auto Restock action")
                } else {
                    ; No potions used, do fists
                    ; Check if AttackSpamReduction is enabled and creatures are present
                    if (AttackSpamReduction && !CheckCreatures()) {
                        LogMessage("Auto: No creatures detected - skipping MA Auto Fists action")
                        return
                    }
                    ; Send MAFistsKey then AttackKey2 (if enabled)
                    if (MAFistsKey != "") {
                        SendKey(MAFistsKey)
                    }
                    if (EnableAttackKey2 && AttackKey2 != "") {
                        Sleep(ShortDelay)  ; Delay between keys
                        SendKey(AttackKey2)
                    }
                    LogMessage("Auto: Executed MA Auto Fists action")
                }
            } else if (CurrentMASkill = "refill") {
                ; Refill mode: always restock (like old restock mode behavior)
                if (MARestockKey != "") {
                    SendKey(MARestockKey)
                }
                
                ; Check if AttackSpamReduction is enabled and creatures are present before attacking
                if (AttackSpamReduction && !CheckCreatures()) {
                    LogMessage("Auto: No creatures detected - skipping MA Refill attacks")
                    return
                }
                
                ; Send AttackKey1 and AttackKey2 (if enabled)
                if (AttackKey1 != "") {
                    Sleep(ShortDelay)  ; Delay between keys
                    SendKey(AttackKey1)
                }
                if (EnableAttackKey2 && AttackKey2 != "") {
                    Sleep(ShortDelay)  ; Delay between keys
                    SendKey(AttackKey2)
                }
                LogMessage("Auto: Executed MA Refill action")
            }
        case "CAST":
            ; Check if spell is warmed using the CheckWarmed function
            if (CheckWarmed()) {
                ; Spell is warmed, cast it
                if (CastSpellKey != "") {
                    SendKey(CastSpellKey)
                    LastSpellCastTime := A_TickCount  ; Record when spell was cast
                    LogMessage("Auto: Casting warmed spell")
                }
            } else {
                ; Spell is not warmed, warm it first
                if (WarmSpellKey != "") {
                    SendKey(WarmSpellKey)
                    LogMessage("Auto: Warming spell")
                }
            }
        case "ATTACK":
            ; Send both attack keys in sequence (e.g. melee & ranged)
            if (AttackKey1 != "") {
                LogMessage("Auto: Sending AttackKey1: " . AttackKey1)
                SendKey(AttackKey1)
            }
            if (EnableAttackKey2 && AttackKey2 != "") {
                Sleep(ShortDelay)  ; Delay between keys
                LogMessage("Auto: Sending AttackKey2: " . AttackKey2)
                SendKey(AttackKey2)
            }
            LogMessage("Auto: Completed attack sequence")
    }
}

; ========================================
; 4.1 COIN PICKUP FUNCTIONS
; ========================================

; Function to detect coins in the search area using color detection
DetectCoins(&coinCoordinates) {
    global CoinAreaTopLeftX, CoinAreaTopLeftY, CoinAreaBottomRightX, CoinAreaBottomRightY
    
    ; Check if coin area is set
    if (CoinAreaTopLeftX = 0 && CoinAreaTopLeftY = 0 && CoinAreaBottomRightX = 0 && CoinAreaBottomRightY = 0) {
        return false
    }
    
    ; Sample pixels in the search area looking for gold/yellow coin colors
    coinCoordinates := []  ; Initialize array to store coin coordinates
    
    ; Scan 8x8 grid pattern (optimized for item grid layout)
    areaWidth := CoinAreaBottomRightX - CoinAreaTopLeftX
    areaHeight := CoinAreaBottomRightY - CoinAreaTopLeftY
    cellWidth := areaWidth // 8
    cellHeight := areaHeight // 8
    
    ; Scan all cells to cover possible coin locations anywhere
    for row in [0, 1, 2, 3, 4, 5, 6, 7] {
        for col in [0, 1, 2, 3, 4, 5, 6, 7] {
            ; Calculate grid cell boundaries
            cellLeft := CoinAreaTopLeftX + (col * cellWidth)
            cellTop := CoinAreaTopLeftY + (row * cellHeight)
            
            ; Check center point of each cell using pixel counting (3 pixels)
            ; Use center point offset 10 pixels left (avoid transparent center)
            x := cellLeft + (cellWidth // 2) - 10   ; Center horizontally - 10 pixels left
            y := cellTop + (cellHeight // 2)   ; Center vertically
            
            ; Use CountGoldPixels to check for 3 gold pixels at this location
            goldPixelCount := CountGoldPixels(x, y)
            if (goldPixelCount >= 2) {
                coinCoordinates.Push([x, y])  ; Store the coordinates for clicking
                LogMessage("Found coin at (" . x . "," . y . ") with " . goldPixelCount . "/3 gold pixels")
                
                ; Stop scanning as soon as we find a coin
                return true
            }
        }
    }
    
    ; No coins found
    return false
}

; Function to execute coin pickup sequence when cursor is ready
ExecuteCoinPickupSequence() {
    ; Check if action is ready using cursor-based timing
    if (!CheckReady()) {
        ; Action not ready yet, start checking with timer
        global CoinPickupStartTime := A_TickCount
        SetTimer(CheckCoinPickupReady, LongDelay)
        return
    }
    
    ; Action is ready - execute coin pickup sequence immediately
    ExecuteCoinPickupNow()
}

; Timer function to check if cursor is ready for coin pickup
CheckCoinPickupReady() {
    global CoinPickupStartTime, CoinRoundTimerDelay
    
    ; Check if we've exceeded the timeout
    if ((A_TickCount - CoinPickupStartTime) >= CoinRoundTimerDelay) {
        SetTimer(CheckCoinPickupReady, 0)  ; Stop the timer
        LogMessage("Coin pickup: Timeout waiting for cursor to be ready")
        return
    }
    
    ; Check if cursor is ready now
    if (CheckReady()) {
        SetTimer(CheckCoinPickupReady, 0)  ; Stop the timer
        ExecuteCoinPickupNow()
    }
    ; If not ready, timer will continue checking
}

; Execute the actual coin pickup sequence
ExecuteCoinPickupNow() {
    global MoneyRingKey, LongDelay, CoinRoundTimerDelay
    
    ; Step 1: Press money ring key (first time - drops coins from ring)
    SendKey(MoneyRingKey)
    
    ; Step 2: Wait for initial delay
    Sleep(LongDelay)
    
    ; Step 3: Start coin detection
    global coinCoordinates := []
    global coinsFound := DetectCoins(&coinCoordinates)
    LogMessage("Coin detection completed. Found: " . (coinsFound ? "Yes" : "No") . ", Count: " . coinCoordinates.Length)
    
    ; Start the readiness checking process
    global CoinPickupRoundStartTime := A_TickCount
    SetTimer(CheckCoinPickupRoundReady, LongDelay)
}

; Timer function to check if coin pickup round is ready for next steps
CheckCoinPickupRoundReady() {
    global CoinPickupRoundStartTime, CoinRoundTimerDelay, coinsFound
    
    ; Check if we've exceeded 2x the round timer delay (timeout)
    if ((A_TickCount - CoinPickupRoundStartTime) >= (2 * CoinRoundTimerDelay)) {
        SetTimer(CheckCoinPickupRoundReady, 0)  ; Stop the timer
        LogMessage("Coin pickup: Timeout waiting for cursor and coins to be ready")
        return
    }
    
    ; Check if both cursor is ready
    if (CheckReady()) {
        SetTimer(CheckCoinPickupRoundReady, 0)  ; Stop the timer
        ExecuteCoinPickupStep3()
    }
    ; Timer continues until conditions are met or timeout
}

; Execute Step 3: Press money ring key again and wait for targeting
ExecuteCoinPickupStep3() {
    global MoneyRingKey, coinsFound, coinCoordinates
    
    ; Step 3: Press money ring key again (second time - enables targeting)
    SendKey(MoneyRingKey)
    Sleep(LongDelay)

    ; Step 4: Click on coins if they were found
    LogMessage("ExecuteCoinPickupStep3: coinsFound=" . coinsFound . ", coinCoordinates.Length=" . coinCoordinates.Length)
    
    if (coinsFound && coinCoordinates.Length > 0) {
        LogMessage("Starting to click on " . coinCoordinates.Length . " coins")
        ; Store current mouse position to restore later
        MouseGetPos(&originalMouseX, &originalMouseY)
        
        ; Click on the exact coordinates where coins were detected
        for coin in coinCoordinates {
            x := coin[1]
            y := coin[2]
            LogMessage("Clicking coin at (" . x . "," . y . ")")
            SendClick("Left", 0, x, y)
        }
        
        ; Return mouse to original position after clicking
        MouseMove(originalMouseX, originalMouseY)
        
        LogMessage("Coin pickup completed. Clicked " . coinCoordinates.Length . " coins.")
    } else {
        LogMessage("Coin pickup completed. No coins found to click. coinsFound=" . coinsFound . ", Length=" . coinCoordinates.Length)
    }
}

; ========================================
; 4.2 ACTIVE SPELL BAR FUNCTIONS
; ========================================

; Function to check active spells for the presence of a right arrow
CheckActiveSpellsRight() {
    global ActiveSpellsRightX, ActiveSpellsRightY
    
    if (ActiveSpellsRightX = 0 && ActiveSpellsRightY = 0) {
        LogMessage("ActiveSpellsRight: Coordinates not set")
        return false
    }
    
    try {
        orangePixelCount := CountOrangePixels(ActiveSpellsRightX, ActiveSpellsRightY)
        
        ; Consider active spells present if at least 2 out of 3 pixels are orange
        hasActiveSpells := orangePixelCount >= 2
        
        LogMessage("ActiveSpellsRight: Orange pixels: " . orangePixelCount . "/3, Has Active Spells: " . (hasActiveSpells ? "Yes" : "No"))
        
        return hasActiveSpells
        
    } catch Error as e {
        LogMessage("ActiveSpellsRight: Error checking active spells: " . e.Message)
        return false
    }
}

; Function to check if active spell is gone (darker color)
CheckActiveSpellGone() {
    global ActiveSpellGoneX, ActiveSpellGoneY, ActiveSpellsLeftX, ActiveSpellsLeftY
    
    if (ActiveSpellGoneX = 0 && ActiveSpellGoneY = 0) {
        LogMessage("ActiveSpellGone: Coordinates not set")
        return false
    }
    
    if (ActiveSpellsLeftX = 0 && ActiveSpellsLeftY = 0) {
        LogMessage("ActiveSpellGone: Left coordinates not set")
        return false
    }
    
    try {
        ; First check scroll left button is present
        orangePixelCount := CountOrangePixels(ActiveSpellsLeftX, ActiveSpellsLeftY)
        hasActiveSpells := orangePixelCount >= 2
        
        if (!hasActiveSpells) {
            LogMessage("ActiveSpellGone: No active spells detected at left coordinates - skipping")
            return false
        }
        
        ; Only check for dark pixels if there are active spells present
        darkPixelCount := CountDarkPixels(ActiveSpellGoneX, ActiveSpellGoneY)
        
        ; Consider spell gone if at least 2 out of 3 pixels are dark
        isSpellGone := darkPixelCount >= 2
        
        LogMessage("ActiveSpellGone: Dark pixels: " . darkPixelCount . "/3, Spell Gone: " . (isSpellGone ? "Yes" : "No"))
        
        return isSpellGone
        
    } catch Error as e {
        LogMessage("ActiveSpellGone: Error checking spell gone: " . e.Message)
        return false
    }
}

; Function to execute active spell scrolling
ExecuteActiveSpellScrolling() {
    global ActiveSpellsLeftX, ActiveSpellsLeftY, ActiveSpellsRightX, ActiveSpellsRightY, ShortDelay, GameWindowTitle
    
    ; Check if game window is active before proceeding
    if (!WinActive(GameWindowTitle)) {
        return  ; Don't interfere if game window is not active
    }
    
    ; Check if active spells are present at right coordinates
    if (CheckActiveSpellsRight()) {
        ; Store current mouse position
        MouseGetPos(&originalMouseX, &originalMouseY)
        
        ; Click at right coordinates until spells are gone
        clickCount := 0
        maxClicks := 10  ; Safety limit
        
        while (CheckActiveSpellsRight() && clickCount < maxClicks) {
            SendClick("Left", 0, ActiveSpellsRightX, ActiveSpellsRightY)
            Sleep(ShortDelay)  ; Delay between clicks
            clickCount++
        }
        
        ; Return mouse to original position
        MouseMove(originalMouseX, originalMouseY)
        
        LogMessage("ActiveSpellScrolling: Clicked right " . clickCount . " times")
    }
    
    ; Check if active spell is gone (darker color)
    if (CheckActiveSpellGone()) {
        ; Store current mouse position
        MouseGetPos(&originalMouseX, &originalMouseY)
        
        ; Click at left coordinates until color returns to bright
        clickCount := 0
        maxClicks := 5  ; Safety limit
        
        while (CheckActiveSpellGone() && clickCount < maxClicks) {
            SendClick("Left", 0, ActiveSpellsLeftX, ActiveSpellsLeftY)
            Sleep(ShortDelay)  ; Delay between clicks
            clickCount++
        }
        
        ; Return mouse to original position
        MouseMove(originalMouseX, originalMouseY)
        
        LogMessage("ActiveSpellScrolling: Clicked left " . clickCount . " times")
    }
    
}

; Function to set active spell coordinates
SetActiveSpellCoordinates(areaType) {
    global ActiveSpellsLeftX, ActiveSpellsLeftY, ActiveSpellsRightX, ActiveSpellsRightY, ActiveSpellGoneX, ActiveSpellGoneY, CurrentProfile, GUIOpen, ConfigGUI
    
    MouseGetPos(&mouseX, &mouseY)
    
    ; Update coordinates based on area type
    switch areaType {
        case "left":
            ActiveSpellsLeftX := mouseX
            ActiveSpellsLeftY := mouseY
            areaName := "Active Spells Left"
            tooltipId := 3
            ; Check pixel count for left area (should be orange when active)
            pixelCount := CountOrangePixels(mouseX, mouseY)
            pixelInfo := "Orange pixels detected: " . pixelCount . "/3"
        case "right":
            ActiveSpellsRightX := mouseX
            ActiveSpellsRightY := mouseY
            areaName := "Active Spells Right"
            tooltipId := 4
            ; Check pixel count for right area (should be orange when active)
            pixelCount := CountOrangePixels(mouseX, mouseY)
            pixelInfo := "Orange pixels detected: " . pixelCount . "/3"
        case "gone":
            ActiveSpellGoneX := mouseX
            ActiveSpellGoneY := mouseY
            areaName := "Active Spell Gone"
            tooltipId := 5
            ; Check pixel count for gone area (should be dark when gone)
            pixelCount := CountDarkPixels(mouseX, mouseY)
            pixelInfo := "Dark pixels detected: " . pixelCount . "/3"
        default:
            return
    }
    
    ; Save to current profile
    SaveProfileAutoSettings(CurrentProfile)
    
    ; Update GUI if it's open
    if (GUIOpen && ConfigGUI && ConfigGUI.Hwnd) {
        try {
            switch areaType {
                case "left":
                    ConfigGUI["ActiveSpellsLeftX"].Text := ActiveSpellsLeftX
                    ConfigGUI["ActiveSpellsLeftY"].Text := ActiveSpellsLeftY
                case "right":
                    ConfigGUI["ActiveSpellsRightX"].Text := ActiveSpellsRightX
                    ConfigGUI["ActiveSpellsRightY"].Text := ActiveSpellsRightY
                case "gone":
                    ConfigGUI["ActiveSpellGoneX"].Text := ActiveSpellGoneX
                    ConfigGUI["ActiveSpellGoneY"].Text := ActiveSpellGoneY
            }
        } catch Error as e {
            LogMessage("Error updating GUI active spell coordinates: " . e.Message)
        }
    }
    
    ToolTip(areaName . " coordinates set! Profile " . CurrentProfile . "`nCoords: " . mouseX . "," . mouseY . "`n" . pixelInfo, , , tooltipId)
    SetTimer(() => ToolTip(, , , tooltipId), -TooltipDisplayTime)
}

; ========================================
; 5. HOTKEYS
; ========================================

; ========================================
; 5.1 CORE CONTROLS
; ========================================


;Ctrl+Shift+R - Store Ready cursor hashes
^+r::{
    global ReadyCursorHashes
    
    currentHash := GetCursorHash()
    if (currentHash = "") {
        ToolTip("Failed to capture cursor hash", , , 21)
        SetTimer(() => ToolTip(, , , 21), -TooltipDisplayTime)
        return
    }
    
    ; Add if not already present (avoid duplicates)
    alreadyExists := false
    for hash in ReadyCursorHashes {
        if (hash = currentHash) {
            alreadyExists := true
            break
        }
    }
    
    if (!alreadyExists) {
        ReadyCursorHashes.Push(currentHash)
        SaveCursorHashes()  ; Save to config
        ToolTip("Added ready cursor hash: " . currentHash . "`nTotal ready hashes: " . ReadyCursorHashes.Length)
        LogMessage("Added ready cursor hash: " . currentHash)
    } else {
        ToolTip("Hash already recorded as ready: " . currentHash)
    }
    
    SetTimer(() => ToolTip(), -TooltipDisplayTime)
}

; Ctrl+Shift+` - GUI opening hotkey
^+`::CreateConfigGUI()

; Alt+G - Execute coin pickup sequence
!g::{
    LogMessage("Hotkey: Alt+G pressed - Starting coin pickup sequence")
    ExecuteCoinPickupSequence()
}

; Ctrl+Shift+1-9 - Switch to profile 1-9
^+1::SwitchToProfile(1)
^+2::SwitchToProfile(2)
^+3::SwitchToProfile(3)
^+4::SwitchToProfile(4)
^+5::SwitchToProfile(5)
^+6::SwitchToProfile(6)
^+7::SwitchToProfile(7)
^+8::SwitchToProfile(8)
^+9::SwitchToProfile(9)

; Ctrl+Shift+Z - Toggle Active Spell Scrolling
^+z::{
    global EnableActiveSpellScrolling, CurrentProfile, GUIOpen, ConfigGUI
    
    EnableActiveSpellScrolling := !EnableActiveSpellScrolling
    status := EnableActiveSpellScrolling ? "ENABLED" : "DISABLED"
    
    ; Save to current profile
    SaveProfileAutoSettings(CurrentProfile)
    
    ; Update GUI if it's open
    if (GUIOpen && ConfigGUI && ConfigGUI.Hwnd) {
        try {
            ConfigGUI["EnableActiveSpellScrollingMonitoring"].Value := EnableActiveSpellScrolling
        } catch Error as e {
            LogMessage("Error updating GUI EnableActiveSpellScrolling: " . e.Message)
        }
    }
    
    ToolTip("Active Spell Scrolling " . status . " for " . GetProfileName(CurrentProfile))
    SetTimer(() => ToolTip(), -TooltipDisplayTime)
    
    LogMessage("Active Spell Scrolling " . status . " for profile " . CurrentProfile . " - " . GetProfileName(CurrentProfile))
}



; ========================================
; 5.3 COORDINATE SETUP
; ========================================

; Ctrl+Shift+L - Set login button coordinates
^+l::{
    global GUIOpen, ConfigGUI
    
    MouseGetPos(&mouseX, &mouseY)
    LoginButtonX := mouseX
    LoginButtonY := mouseY
    
    ; Save to config file
    IniWrite(LoginButtonX, ConfigFile, "GAME SETTINGS", "LoginButtonX")
    IniWrite(LoginButtonY, ConfigFile, "GAME SETTINGS", "LoginButtonY")
    
    ; Update GUI if it's open
    if (GUIOpen && ConfigGUI && ConfigGUI.Hwnd) {
        try {
            ConfigGUI["LoginButtonXEdit"].Text := LoginButtonX
            ConfigGUI["LoginButtonYEdit"].Text := LoginButtonY
        } catch Error as e {
            LogMessage("Error updating GUI login coordinates: " . e.Message)
        }
    }
    
    ToolTip("Login button coordinates set to " . LoginButtonX . "," . LoginButtonY, , , 10)
    SetTimer(() => ToolTip(, , , 10), -TooltipDisplayTime)
    LogMessage("Login button coordinates set to " . LoginButtonX . "," . LoginButtonY)
}

; Ctrl+Shift+H - Set health area coordinates for current profile
^+h::{
    global HealthAreaX, HealthAreaY, CurrentProfile, GUIOpen, ConfigGUI
    
    MouseGetPos(&mouseX, &mouseY)
    HealthAreaX := mouseX
    HealthAreaY := mouseY
    
    ; Check how many pixels are red at this location
    redPixelCount := CountRedPixels(HealthAreaX, HealthAreaY)
    
    ; Save to current profile (after updating global variables)
    SaveProfileAutoSettings(CurrentProfile)
    
    ; Update GUI if it's open
    if (GUIOpen && ConfigGUI && ConfigGUI.Hwnd) {
        try {
            ConfigGUI["HealthX"].Text := HealthAreaX
            ConfigGUI["HealthY"].Text := HealthAreaY
        } catch Error as e {
            LogMessage("Error updating GUI health coordinates: " . e.Message)
        }
    }
    
    ToolTip("Health area coordinates set to " . HealthAreaX . "," . HealthAreaY . " for " . GetProfileName(CurrentProfile) . "`nRed pixels detected: " . redPixelCount . "/3", , , 12)
    SetTimer(() => ToolTip(, , , 12), -TooltipDisplayTime)
    LogMessage("Health area coordinates set to " . HealthAreaX . "," . HealthAreaY . " for profile " . CurrentProfile . " - Red pixels: " . redPixelCount . "/3")
}

; Ctrl+Shift+M - Set mana area coordinates for current profile
^+m::{
    global ManaAreaX, ManaAreaY, CurrentProfile, GUIOpen, ConfigGUI
    
    MouseGetPos(&mouseX, &mouseY)
    ManaAreaX := mouseX
    ManaAreaY := mouseY
    
    ; Check how many pixels are blue at this location
    bluePixelCount := CountBluePixels(ManaAreaX, ManaAreaY)
    
    ; Save to current profile
    SaveProfileAutoSettings(CurrentProfile)
    
    ; Update GUI if it's open
    if (GUIOpen && ConfigGUI && ConfigGUI.Hwnd) {
        try {
            ConfigGUI["ManaX"].Text := ManaAreaX
            ConfigGUI["ManaY"].Text := ManaAreaY
        } catch Error as e {
            LogMessage("Error updating GUI mana coordinates: " . e.Message)
        }
    }
    
    ToolTip("Mana area coordinates set to " . ManaAreaX . "," . ManaAreaY . " for " . GetProfileName(CurrentProfile) . "`nBlue pixels detected: " . bluePixelCount . "/3", , , 14)
    SetTimer(() => ToolTip(, , , 14), -TooltipDisplayTime)
    LogMessage("Mana area coordinates set to " . ManaAreaX . "," . ManaAreaY . " for profile " . CurrentProfile . " - Blue pixels: " . bluePixelCount . "/3")
}

; Ctrl+Shift+C - Set creature area coordinates for current profile
^+c::{
    global CreatureAreaX, CreatureAreaY, CurrentProfile, GUIOpen, ConfigGUI
    
    MouseGetPos(&mouseX, &mouseY)
    CreatureAreaX := mouseX
    CreatureAreaY := mouseY
    
    ; Save to current profile
    SaveProfileAutoSettings(CurrentProfile)
    
    ; Update GUI if it's open
    if (GUIOpen && ConfigGUI && ConfigGUI.Hwnd) {
        try {
            ConfigGUI["CreatureX"].Text := CreatureAreaX
            ConfigGUI["CreatureY"].Text := CreatureAreaY
        } catch Error as e {
            LogMessage("Error updating GUI creature coordinates: " . e.Message)
        }
    }
    
    ToolTip("Creature area coordinates set to " . CreatureAreaX . "," . CreatureAreaY . " for " . GetProfileName(CurrentProfile), , , 17)
    SetTimer(() => ToolTip(, , , 17), -TooltipDisplayTime)
    LogMessage("Creature area coordinates set to " . CreatureAreaX . "," . CreatureAreaY . " for profile " . CurrentProfile)
}

; Ctrl+Shift+U - Set coin area top-left coordinates
^+u::{
    global CoinAreaTopLeftX, CoinAreaTopLeftY, CurrentProfile, GameRunning, GUIOpen, ConfigGUI
    MouseGetPos(&mouseX, &mouseY)
    
    ; Check if game is running
    if (!GameRunning) {
        ToolTip("Game not running!", , , 3)
        SetTimer(() => ToolTip(, , , 3), -TooltipDisplayTime)
        return
    }
    
    ; Update coordinates
    CoinAreaTopLeftX := mouseX
    CoinAreaTopLeftY := mouseY
    
    ; Save to current profile
    SaveProfileAutoSettings(CurrentProfile)
    
    ; Update GUI if it's open
    if (GUIOpen && ConfigGUI && ConfigGUI.Hwnd) {
        try {
            ConfigGUI["CoinAreaTopLeftX"].Text := CoinAreaTopLeftX
            ConfigGUI["CoinAreaTopLeftY"].Text := CoinAreaTopLeftY
        } catch Error as e {
            LogMessage("Error updating GUI coin area top-left coordinates: " . e.Message)
        }
    }
    
    ToolTip("Coin area top-left set! Profile " . CurrentProfile . "`nCoords: " . mouseX . "," . mouseY, , , 3)
    SetTimer(() => ToolTip(, , , 3), -TooltipDisplayTime)
}

; Ctrl+Shift+I - Set coin area bottom-right coordinates  
^+i::{
    global CoinAreaBottomRightX, CoinAreaBottomRightY, CurrentProfile, GameRunning, GUIOpen, ConfigGUI
    MouseGetPos(&mouseX, &mouseY)
    
    ; Check if game is running
    if (!GameRunning) {
        ToolTip("Game not running!", , , 4)
        SetTimer(() => ToolTip(, , , 4), -TooltipDisplayTime)
        return
    }
    
    ; Update coordinates
    CoinAreaBottomRightX := mouseX
    CoinAreaBottomRightY := mouseY
    
    ; Save to current profile
    SaveProfileAutoSettings(CurrentProfile)
    
    ; Update GUI if it's open
    if (GUIOpen && ConfigGUI && ConfigGUI.Hwnd) {
        try {
            ConfigGUI["CoinAreaBottomRightX"].Text := CoinAreaBottomRightX
            ConfigGUI["CoinAreaBottomRightY"].Text := CoinAreaBottomRightY
        } catch Error as e {
            LogMessage("Error updating GUI coin area bottom-right coordinates: " . e.Message)
        }
    }
    
    ToolTip("Coin area bottom-right set! Profile " . CurrentProfile . "`nCoords: " . mouseX . "," . mouseY, , , 4)
    SetTimer(() => ToolTip(, , , 4), -TooltipDisplayTime)
}

; Ctrl+Shift+J - Set Active Spells Left coordinates
^+j::SetActiveSpellCoordinates("left")

; Ctrl+Shift+O - Set Active Spells Right coordinates
^+o::SetActiveSpellCoordinates("right")

; Ctrl+Shift+Q - Set Active Spell Gone coordinates
^+q::SetActiveSpellCoordinates("gone")



; Ctrl+Shift+V - Set Warmed Spell coordinates
^+v::{
    global WarmedSpellX, WarmedSpellY, CurrentProfile, GameRunning, GUIOpen, ConfigGUI
    MouseGetPos(&mouseX, &mouseY)
    
    ; Check if game is running
    if (!GameRunning) {
        ToolTip("Game not running!", , , 22)
        SetTimer(() => ToolTip(, , , 22), -TooltipDisplayTime)
        return
    }
    
    ; Update coordinates
    WarmedSpellX := mouseX
    WarmedSpellY := mouseY
    
    ; Save to current profile
    SaveProfileAutoSettings(CurrentProfile)
    
    ; Update GUI if it's open
    if (GUIOpen && ConfigGUI && ConfigGUI.Hwnd) {
        try {
            ConfigGUI["WarmedSpellX"].Text := WarmedSpellX
            ConfigGUI["WarmedSpellY"].Text := WarmedSpellY
        } catch Error as e {
            LogMessage("Error updating GUI warmed spell coordinates: " . e.Message)
        }
    }
    
    ; Get pixel count for tooltip
    darkPixelCount := CountDarkPixels(mouseX, mouseY)
    pixelInfo := "Dark pixels: " . darkPixelCount . "/3"
    
    ToolTip("Warmed Spell coordinates set! Profile " . CurrentProfile . "`nCoords: " . mouseX . "," . mouseY . "`n" . pixelInfo)
    SetTimer(() => ToolTip(), -TooltipDisplayTime)
}

; Ctrl+Shift+F - Set Main Hand coordinates
^+f::{
    global MainHandX, MainHandY, CurrentProfile, GameRunning, GUIOpen, ConfigGUI
    MouseGetPos(&mouseX, &mouseY)
    
    ; Check if game is running
    if (!GameRunning) {
        ToolTip("Game not running!", , , 23)
        SetTimer(() => ToolTip(, , , 23), -TooltipDisplayTime)
        return
    }
    
    ; Update coordinates
    MainHandX := mouseX
    MainHandY := mouseY
    
    ; Save to current profile
    SaveProfileAutoSettings(CurrentProfile)
    
    ; Update GUI if it's open
    if (GUIOpen && ConfigGUI && ConfigGUI.Hwnd) {
        try {
            ConfigGUI["MainHandXKeys"].Text := MainHandX
            ConfigGUI["MainHandYKeys"].Text := MainHandY
        } catch Error as e {
            LogMessage("Error updating GUI main hand coordinates: " . e.Message)
        }
    }
    
    ; Get pixel count for tooltip
    darkPixelCount := CountDarkPixels(mouseX, mouseY)
    pixelInfo := "Dark pixels: " . darkPixelCount . "/3"
    
    ToolTip("Main Hand coordinates set! Profile " . CurrentProfile . "`nCoords: " . mouseX . "," . mouseY . "`n" . pixelInfo)
    SetTimer(() => ToolTip(), -TooltipDisplayTime)
}

; Ctrl+Shift+W - Set Offhand coordinates
^+w::{
    global OffHandX, OffHandY, CurrentProfile, GameRunning, GUIOpen, ConfigGUI
    MouseGetPos(&mouseX, &mouseY)
    
    ; Check if game is running
    if (!GameRunning) {
        ToolTip("Game not running!", , , 24)
        SetTimer(() => ToolTip(, , , 24), -TooltipDisplayTime)
        return
    }
    
    ; Update coordinates
    OffHandX := mouseX
    OffHandY := mouseY
    
    ; Save to current profile
    SaveProfileAutoSettings(CurrentProfile)
    
    ; Update GUI if it's open
    if (GUIOpen && ConfigGUI && ConfigGUI.Hwnd) {
        try {
            ConfigGUI["OffHandXKeys"].Text := OffHandX
            ConfigGUI["OffHandYKeys"].Text := OffHandY
        } catch Error as e {
            LogMessage("Error updating GUI offhand coordinates: " . e.Message)
        }
    }
    
    ; Get pixel count for tooltip
    darkPixelCount := CountDarkPixels(mouseX, mouseY)
    pixelInfo := "Dark pixels: " . darkPixelCount . "/3"
    
    ToolTip("Offhand coordinates set! Profile " . CurrentProfile . "`nCoords: " . mouseX . "," . mouseY . "`n" . pixelInfo)
    SetTimer(() => ToolTip(), -TooltipDisplayTime)
}

; Ctrl+Shift+G - Set Creature List Verification coordinates
^+g::{
    global CritListVerifyX, CritListVerifyY, CurrentProfile, GameRunning, GUIOpen, ConfigGUI
    MouseGetPos(&mouseX, &mouseY)
    
    ; Check if game is running
    if (!GameRunning) {
        ToolTip("Game not running!", , , 25)
        SetTimer(() => ToolTip(, , , 25), -TooltipDisplayTime)
        return
    }
    
    ; Update coordinates
    CritListVerifyX := mouseX
    CritListVerifyY := mouseY
    
    ; Save to current profile
    SaveProfileAutoSettings(CurrentProfile)
    
    ; Update GUI if it's open
    if (GUIOpen && ConfigGUI && ConfigGUI.Hwnd) {
        try {
            ConfigGUI["CritListVerifyX"].Text := CritListVerifyX
            ConfigGUI["CritListVerifyY"].Text := CritListVerifyY
        } catch Error as e {
            LogMessage("Error updating GUI creature verification coordinates: " . e.Message)
        }
    }
    
    ; Get pixel count for tooltip
    greenPixelCount := CountGreenPixels(mouseX, mouseY)
    pixelInfo := "Green pixels: " . greenPixelCount . "/3"
    
    ToolTip("Creature List Verification coordinates set! Profile " . CurrentProfile . "`nCoords: " . mouseX . "," . mouseY . "`n" . pixelInfo)
    SetTimer(() => ToolTip(), -TooltipDisplayTime)
}

; ========================================
; 5.4 COMBAT SETTINGS
; ========================================

; Middle Click - Toggle Auto mode
MButton::{
    global EnableAuto, AutoLoopInterval, AttackSpamReduction
    
    EnableAuto := !EnableAuto
    status := EnableAuto ? "ENABLED" : "DISABLED"
    
    if (EnableAuto) {
        ; Switch to creature list first if AttackSpamReduction is enabled
        if (AttackSpamReduction) {
            ; Send Alt+L to switch to creature list
            SendInput("{Alt down}")
            Sleep(ShortDelay)
            SendInput("{l down}")
            Sleep(ShortDelay)
            SendInput("{l up}")
            Sleep(ShortDelay)
            SendInput("{Alt up}")
            LogMessage("Auto mode: Switched to creature list for creature detection")
            Sleep(LongDelay)  ; Wait for creature list to load
        }
        
        ; Start the automation timer after creature list switch
        SetTimer(AutoLoop, AutoLoopInterval)
        LogMessage("Auto mode ENABLED - starting automation loop (interval: " . AutoLoopInterval . "ms)")
    } else {
        ; Stop the automation timer
        SetTimer(AutoLoop, 0)
        LogMessage("Auto mode DISABLED - stopping automation loop")
    }
    
    ToolTip("Auto mode " . status, , , 14)
    SetTimer(() => ToolTip(, , , 14), -TooltipDisplayTime)
}

; Ctrl+Shift+S - Toggle second attack key
^+s::{
    global EnableAttackKey2, CurrentProfile, GUIOpen, ConfigGUI
    
    EnableAttackKey2 := !EnableAttackKey2
    status := EnableAttackKey2 ? "ENABLED" : "DISABLED"
    
    ; Save to current profile
    SaveProfileAutoSettings(CurrentProfile)
    
    ; Update GUI if it's open
    if (GUIOpen && ConfigGUI && ConfigGUI.Hwnd) {
        try {
            ConfigGUI["EnableAttackKey2Checkbox"].Value := EnableAttackKey2
        } catch Error as e {
            LogMessage("Error updating GUI EnableAttackKey2: " . e.Message)
        }
    }
    
    ToolTip("Second attack " . status . " for " . GetProfileName(CurrentProfile), , , 15)
    SetTimer(() => ToolTip(, , , 15), -TooltipDisplayTime)
    
    LogMessage("Second attack " . status . " for profile " . CurrentProfile . " - " . GetProfileName(CurrentProfile))
}

; Ctrl+Shift+E - Swap attack keys
^+e::{
    global AttackKey1, AttackKey2, CurrentProfile, GUIOpen, ConfigGUI
    
    ; Swap the keys
    tempKey := AttackKey1
    AttackKey1 := AttackKey2
    AttackKey2 := tempKey
    
    ; Save to current profile
    SaveProfileAutoSettings(CurrentProfile)
    
    ; Update GUI if it's open
    if (GUIOpen && ConfigGUI && ConfigGUI.Hwnd) {
        try {
            ConfigGUI["AttackKey1"].Text := AttackKey1
            ConfigGUI["AttackKey2"].Text := AttackKey2
        } catch Error as e {
            LogMessage("Error updating GUI attack keys: " . e.Message)
        }
    }
    
    ToolTip("Attack keys swapped for " . GetProfileName(CurrentProfile) . "`nPrimary: " . AttackKey1 . " | Secondary: " . AttackKey2, , , 16)
    SetTimer(() => ToolTip(, , , 16), -TooltipDisplayTime)
    
    LogMessage("Attack keys swapped for profile " . CurrentProfile . " - Primary: " . AttackKey1 . ", Secondary: " . AttackKey2)
}

; Ctrl+Shift+A - Toggle EnableMASkill
^+a::{
    global EnableMASkill, CurrentProfile, GUIOpen, ConfigGUI
    
    EnableMASkill := !EnableMASkill
    status := EnableMASkill ? "ENABLED" : "DISABLED"
    
    ; Save to current profile
    SaveProfileAutoSettings(CurrentProfile)
    
    ; Update GUI if it's open
    if (GUIOpen && ConfigGUI && ConfigGUI.Hwnd) {
        try {
            ConfigGUI["EnableMASkillCheckbox"].Value := EnableMASkill
        } catch Error as e {
            LogMessage("Error updating GUI EnableMASkill: " . e.Message)
        }
    }
    
    ToolTip("MA Skill " . status . " for " . GetProfileName(CurrentProfile), , , 18)
    SetTimer(() => ToolTip(, , , 18), -TooltipDisplayTime)
    
    LogMessage("MA Skill " . status . " for profile " . CurrentProfile . " - " . GetProfileName(CurrentProfile))
}

; Ctrl+Shift+T - Toggle CurrentMASkill between fists, restock, auto, and refill
^+t::{
    global CurrentMASkill, CurrentProfile, GUIOpen, ConfigGUI, UsedPotionsCount
    
    if (CurrentMASkill = "fists") {
        CurrentMASkill := "restock"
        UsedPotionsCount := 0  ; Reset potion counter when switching to Restock mode
    } else if (CurrentMASkill = "restock") {
        CurrentMASkill := "auto"
        UsedPotionsCount := 0  ; Reset potion counter when switching to Auto mode
    } else if (CurrentMASkill = "auto") {
        CurrentMASkill := "refill"
        UsedPotionsCount := 0  ; Reset potion counter when switching to Refill mode
    } else {
        CurrentMASkill := "fists"
    }
    
    ; Save to current profile
    SaveProfileAutoSettings(CurrentProfile)
    
    ; Update GUI if it's open
    if (GUIOpen && ConfigGUI && ConfigGUI.Hwnd) {
        try {
            if (CurrentMASkill = "fists") {
                ConfigGUI["MAFistsMode"].Value := 1
                ConfigGUI["MARestockMode"].Value := 0
                ConfigGUI["MAAutoMode"].Value := 0
                ConfigGUI["MARefillMode"].Value := 0
            } else if (CurrentMASkill = "restock") {
                ConfigGUI["MAFistsMode"].Value := 0
                ConfigGUI["MARestockMode"].Value := 1
                ConfigGUI["MAAutoMode"].Value := 0
                ConfigGUI["MARefillMode"].Value := 0
            } else if (CurrentMASkill = "auto") {
                ConfigGUI["MAFistsMode"].Value := 0
                ConfigGUI["MARestockMode"].Value := 0
                ConfigGUI["MAAutoMode"].Value := 1
                ConfigGUI["MARefillMode"].Value := 0
            } else if (CurrentMASkill = "refill") {
                ConfigGUI["MAFistsMode"].Value := 0
                ConfigGUI["MARestockMode"].Value := 0
                ConfigGUI["MAAutoMode"].Value := 0
                ConfigGUI["MARefillMode"].Value := 1
            }
        } catch Error as e {
            LogMessage("Error updating GUI MA mode: " . e.Message)
        }
    }
    
    ToolTip("MA Skill mode: " . CurrentMASkill . " for " . GetProfileName(CurrentProfile), , , 19)
    SetTimer(() => ToolTip(, , , 19), -TooltipDisplayTime)
    
    LogMessage("MA Skill mode changed to " . CurrentMASkill . " for profile " . CurrentProfile . " - " . GetProfileName(CurrentProfile))
}

; Ctrl+Shift+K - Toggle EnableKnightHeal
^+k::{
    global EnableKnightHeal, CurrentProfile, GUIOpen, ConfigGUI
    
    EnableKnightHeal := !EnableKnightHeal
    status := EnableKnightHeal ? "ENABLED" : "DISABLED"
    
    ; Save to current profile
    SaveProfileAutoSettings(CurrentProfile)
    
    ; Update GUI if it's open
    if (GUIOpen && ConfigGUI && ConfigGUI.Hwnd) {
        try {
            ConfigGUI["EnableKnightHealCheckbox"].Value := EnableKnightHeal
        } catch Error as e {
            LogMessage("Error updating GUI EnableKnightHeal: " . e.Message)
        }
    }
    
    ToolTip("Knight Heal " . status . " for " . GetProfileName(CurrentProfile), , , 20)
    SetTimer(() => ToolTip(, , , 20), -TooltipDisplayTime)
    
    LogMessage("Knight Heal " . status . " for profile " . CurrentProfile . " - " . GetProfileName(CurrentProfile))
}

; Ctrl+Shift+X - Toggle Spell Casting
^+x::{
    global EnableSpellCasting, CurrentProfile, GUIOpen, ConfigGUI
    
    EnableSpellCasting := !EnableSpellCasting
    status := EnableSpellCasting ? "ENABLED" : "DISABLED"
    
    ; Save to current profile
    SaveProfileAutoSettings(CurrentProfile)
    
    ; Update GUI if it's open
    if (GUIOpen && ConfigGUI && ConfigGUI.Hwnd) {
        try {
            ConfigGUI["EnableSpellCastingCheckbox"].Value := EnableSpellCasting
        } catch Error as e {
            LogMessage("Error updating GUI EnableSpellCasting: " . e.Message)
        }
    }
    
    ToolTip("Spell Casting " . status . " for profile " . CurrentProfile . " - " . GetProfileName(CurrentProfile))
    SetTimer(() => ToolTip(), -TooltipDisplayTime)
    
    LogMessage("Spell Casting " . status . " for profile " . CurrentProfile . " - " . GetProfileName(CurrentProfile))
}

; Ctrl+Shift+B - Toggle Main Hand Fumble Recovery
^+b::{
    global RecoverFumbleMain, CurrentProfile, GUIOpen, ConfigGUI
    
    RecoverFumbleMain := !RecoverFumbleMain
    status := RecoverFumbleMain ? "ENABLED" : "DISABLED"
    
    ; Save to current profile
    SaveProfileAutoSettings(CurrentProfile)
    
    ; Update GUI if it's open
    if (GUIOpen && ConfigGUI && ConfigGUI.Hwnd) {
        try {
            ConfigGUI["RecoverFumbleMainCheckbox"].Value := RecoverFumbleMain
        } catch Error as e {
            LogMessage("Error updating GUI RecoverFumbleMain: " . e.Message)
        }
    }
    
    ToolTip("Main Hand Fumble Recovery " . status . " for profile " . CurrentProfile . " - " . GetProfileName(CurrentProfile))
    SetTimer(() => ToolTip(), -TooltipDisplayTime)
    
    LogMessage("Main Hand Fumble Recovery " . status . " for profile " . CurrentProfile . " - " . GetProfileName(CurrentProfile))
}

; Ctrl+Shift+Y - Toggle Offhand Fumble Recovery
^+y::{
    global RecoverFumbleOffhand, CurrentProfile, GUIOpen, ConfigGUI
    
    RecoverFumbleOffhand := !RecoverFumbleOffhand
    status := RecoverFumbleOffhand ? "ENABLED" : "DISABLED"
    
    ; Save to current profile
    SaveProfileAutoSettings(CurrentProfile)
    
    ; Update GUI if it's open
    if (GUIOpen && ConfigGUI && ConfigGUI.Hwnd) {
        try {
            ConfigGUI["RecoverFumbleOffhandCheckbox"].Value := RecoverFumbleOffhand
        } catch Error as e {
            LogMessage("Error updating GUI RecoverFumbleOffhand: " . e.Message)
        }
    }
    
    ToolTip("Offhand Fumble Recovery " . status . " for profile " . CurrentProfile . " - " . GetProfileName(CurrentProfile))
    SetTimer(() => ToolTip(), -TooltipDisplayTime)
    
    LogMessage("Offhand Fumble Recovery " . status . " for profile " . CurrentProfile . " - " . GetProfileName(CurrentProfile))
}

; Ctrl+Shift+P - Toggle Creature List Verification
^+p::{
    global EnableCreatureListVerification, CurrentProfile, GUIOpen, ConfigGUI
    EnableCreatureListVerification := !EnableCreatureListVerification
    SaveProfileAutoSettings(CurrentProfile)
    
    ; Update GUI if it's open
    if (GUIOpen && ConfigGUI && ConfigGUI.Hwnd) {
        try {
            ConfigGUI["EnableCreatureListVerificationCheckbox"].Value := EnableCreatureListVerification
        } catch Error as e {
            LogMessage("Error updating GUI EnableCreatureListVerification: " . e.Message)
        }
    }
    
    ToolTip("Creature List Verification: " . (EnableCreatureListVerification ? "ENABLED" : "DISABLED") . "`nProfile: " . CurrentProfile)
    SetTimer(() => ToolTip(), -TooltipDisplayTime)
}


; ========================================
; 6. GUI
; ========================================

; Global GUI variables
ConfigGUI := ""
TabControl := ""
ProfileDropdown := ""
CurrentTab := ""
GUIOpen := false

; Create the main configuration GUI
CreateConfigGUI() {
    global ConfigGUI, TabControl, CurrentTab, GUIOpen
    
    ; Check if GUI is already open and valid
    try {
        if (ConfigGUI && ConfigGUI.Hwnd && WinExist("ahk_id " . ConfigGUI.Hwnd)) {
            ConfigGUI.Show()
            return
        }
    } catch {
        ; GUI object exists but is invalid, we'll create a new one
    }
    
    ; Create main window
    ConfigGUI := Gui("+Resize +MinSize600x720", "Vyris's Stormhalter QoL - Configuration")
    
    ; Set window icon (if available)
    try {
        ConfigGUI.SetIcon("shell32.dll", 1)
    }
    
    ; Handle GUI close event (X button)
    ConfigGUI.OnEvent("Close", CloseConfigGUI)
    
    ; Create global profile selection above tabs
    CreateGlobalProfileSelection()

    ; Create global buttons at the bottom
    ConfigGUI.AddButton("x20 y670 w100 h30", "Restore Defaults").OnEvent("Click", RestoreDefaults)
    ConfigGUI.AddButton("x520 y670 w60 h30", "SAVE").OnEvent("Click", SaveAllSettings)
    
    ; Create tab control
    TabControl := ConfigGUI.Add("Tab3", "x10 y35 w580 h615", ["Start", "Timing", "Keys", "Monitoring", "Hotkeys"])
    TabControl.OnEvent("Change", OnTabChange)
    
    ; Create all tab sections
    CreateStartTab()
    CreateTimingTab()
    CreateKeysTab()
    CreateMonitoringTab()
    CreateHotkeysTab()
    
    ; Load current profile data
    LoadProfileToGUI()
    
    ; Show the GUI
    ConfigGUI.Show()
    CurrentTab := "Start"
    GUIOpen := true
}

; Create global profile selection above tabs
CreateGlobalProfileSelection() {
    global ConfigGUI, CurrentProfile
    
    ; Profile Selection - no group box, cleaner look
    ConfigGUI.AddText("x20 y13 w120 h20", "Select Profile:")
    ; Create a proper dropdown list showing all profiles
    ProfileDropdown := ConfigGUI.AddDropDownList("x140 y10 w80 h160", ["Profile 1", "Profile 2", "Profile 3", "Profile 4", "Profile 5", "Profile 6", "Profile 7", "Profile 8", "Profile 9"])
    ProfileDropdown.OnEvent("Change", OnProfileChange)
    
    ; Set initial selection
    try {
        ProfileDropdown.Choose(CurrentProfile)
    } catch {
        ; Fallback: set the selection directly
        ProfileDropdown.Text := "Profile " . CurrentProfile
    }
    
    ; Profile Name on the right side
    ConfigGUI.AddText("x280 y10 w120 h20", "Profile Name:")
    ConfigGUI.AddEdit("x350 y7 w120 h20 vProfileNameEdit")
    
    return ProfileDropdown
}

; Create Start tab
CreateStartTab() {
    global ConfigGUI, TabControl
    
    ; Switch to Start tab
    TabControl.UseTab(1)
    
    ; Game Path Configuration
    ConfigGUI.AddGroupBox("x20 y65 w560 h95", "Game Path Configuration")
    ConfigGUI.AddText("x30 y85 w200 h20", "Current Game Path:")
    ConfigGUI.AddEdit("x30 y105 w400 h20 vGamePathEdit ReadOnly", "")
    ConfigGUI.AddButton("x440 y103 w120 h25", "Browse for Game").OnEvent("Click", BrowseForGame)
    ConfigGUI.AddText("x30 y135 w200 h20", "Browse to the ")
    ConfigGUI.AddText("x98 y135 w150 h20 cBlue", "Kesmai.Client.exe")
    ConfigGUI.AddText("x182 y135 w200 h20", " file to set the correct game path.")
    
    ; Auto Click Login section
    ConfigGUI.AddGroupBox("x20 y170 w560 h73", "Login Settings")
    ConfigGUI.AddCheckBox("x30 y190 w200 h20 vAutoClickLoginCheckbox", "Automatically Click Login")
    ConfigGUI.AddText("x30 y215 w100 h20", "Login Button X:")
    ConfigGUI.AddEdit("x105 y212 w30 h20 vLoginButtonXEdit")
    ConfigGUI.AddText("x137 y215 w100 h20", "Y:")
    ConfigGUI.AddEdit("x150 y212 w30 h20 vLoginButtonYEdit")
    ConfigGUI.AddText("x185 y215 w100 h20", "Press ")
    ConfigGUI.AddText("x215 y215 w100 h20 cBlue", "Ctrl+Shift+L")
    ConfigGUI.AddText("x270 y215 w300 h20", " while hovering over the Login button to set coordinates.")
    
    ; Window Settings
    ConfigGUI.AddGroupBox("x20 y253 w560 h119", "Window Settings")
    ConfigGUI.AddCheckBox("x30 y273 w200 h20 vAutoMaximizeWindowCheckbox", "Auto Maximize Window")
    ConfigGUI.AddText("x30 y298 w500 h20", "Automatically maximize the game window when it starts.")
    
    ConfigGUI.AddCheckBox("x30 y320 w200 h20 vUseSecondaryMonitorCheckbox", "Use Secondary Monitor")
    ConfigGUI.AddText("x30 y345 w120 h20", "Monitor Number:")
    ConfigGUI.AddEdit("x109 y342 w30 h20 vSecondaryMonitorNumberEdit")
    
    ; Backup Settings
    ConfigGUI.AddGroupBox("x20 y382 w560 h173", "Backup Settings")
    ConfigGUI.AddCheckBox("x30 y402 w200 h20 vEnableBackupsCheckbox", "Enable Backups").OnEvent("Click", OnEnableBackupsChange)
    ConfigGUI.AddText("x30 y427 w500 h20", "Automatically create backups of the script and config files.")
    
    ConfigGUI.AddCheckBox("x30 y452 w200 h20 vBackupConfigOnlyCheckbox", "Backup Config Only")
    ConfigGUI.AddText("x30 y477 w500 h20", "When enabled, only backup the config file (not the script).")
    
    ConfigGUI.AddText("x30 y502 w200 h20", "Backup Folder:")
    ConfigGUI.AddEdit("x30 y522 w400 h20 vBackupFolderEdit", "")
    ConfigGUI.AddButton("x440 y520 w120 h25", "Browse for Folder").OnEvent("Click", BrowseForBackupFolder)
    
    ; Debug Settings
    ConfigGUI.AddGroupBox("x20 y565 w560 h73", "Debug Settings")
    ConfigGUI.AddCheckBox("x30 y585 w200 h20 vEnableDebugLoggingCheckbox", "Enable Debug Logging")
    ConfigGUI.AddText("x30 y610 w500 h20", "Enable detailed debug logging to help troubleshoot issues.")
    
    ; Save button for all Start tab settings
}

; Create Timing tab
CreateTimingTab() {
    global ConfigGUI, TabControl
    
    ; Switch to Timing tab
    TabControl.UseTab(2)
    
    ; Timing Settings
    ConfigGUI.AddGroupBox("x20 y65 w560 h295", "Timing Settings")
    ConfigGUI.AddText("x30 y90 w200 h20", "Short Delay (ms):")
    ConfigGUI.AddEdit("x200 y87 w80 h20 vShortDelay")
    ConfigGUI.AddText("x290 y90 w250 h20", "Short delay for local actions")
    
    ConfigGUI.AddText("x30 y120 w200 h20", "Medium Delay (ms):")
    ConfigGUI.AddEdit("x200 y117 w80 h20 vMediumDelay")
    ConfigGUI.AddText("x290 y120 w250 h20", "Medium delay for server based actions")
    
    ConfigGUI.AddText("x30 y150 w200 h20", "Long Delay (ms):")
    ConfigGUI.AddEdit("x200 y147 w80 h20 vLongDelay")
    ConfigGUI.AddText("x290 y150 w250 h20", "Relaxed delay for out of combat actions")
    
    ConfigGUI.AddText("x30 y180 w200 h20", "Tooltip Display Time (ms):")
    ConfigGUI.AddEdit("x200 y177 w80 h20 vTooltipDisplayTime")
    ConfigGUI.AddText("x290 y180 w250 h20", "Standard tooltop display")
    
    
    ConfigGUI.AddText("x30 y210 w200 h20", "Auto Loop Interval (ms):")
    ConfigGUI.AddEdit("x200 y207 w80 h20 vAutoLoopInterval")
    ConfigGUI.AddText("x290 y210 w250 h20", "Auto loop repeat interval")
    
    ConfigGUI.AddText("x30 y240 w200 h20", "Round Timer Delay (ms):")
    ConfigGUI.AddEdit("x200 y237 w80 h20 vCoinRoundTimerDelay")
    ConfigGUI.AddText("x290 y240 w250 h20", "One round")
    
    ConfigGUI.AddText("x30 y270 w200 h20", "Login Delay (ms):")
    ConfigGUI.AddEdit("x200 y267 w80 h20 vLoginDelay")
    ConfigGUI.AddText("x290 y270 w250 h20", "Delay before auto-clicking login button")
    
    ConfigGUI.AddText("x30 y300 w200 h20", "Mouse Click Cooldown (ms):")
    ConfigGUI.AddEdit("x200 y297 w80 h20 vMouseClickCooldown")
    ConfigGUI.AddText("x290 y300 w250 h20", "Delay after click before spell bar auto-scroll starts")
    
    ConfigGUI.AddText("x30 y330 w200 h20", "Game Monitor Interval (ms):")
    ConfigGUI.AddEdit("x200 y327 w80 h20 vGameMonitorInterval")
    ConfigGUI.AddText("x290 y330 w250 h20", "Game window check frequency")
    
}

; Create Keys tab
CreateKeysTab() {
    global ConfigGUI, TabControl
    
    ; Switch to Keys tab
    TabControl.UseTab(3)
    
    ; Key Configuration
    ConfigGUI.AddGroupBox("x20 y65 w560 h570", "Key Configuration")
    
    ; Left Column
    ; Standalone Keys at top
    ConfigGUI.AddText("x30 y90 w120 h20", "Drink Key:")
    ConfigGUI.AddEdit("x160 y87 w40 h20 vDrinkKey")
    
    ; Attack Keys Section
    ConfigGUI.AddText("x30 y120 w120 h20", "Attack Key 1:")
    ConfigGUI.AddEdit("x160 y117 w40 h20 vAttackKey1")
    
    ; Attack Key 2 Group
    ConfigGUI.AddGroupBox("x30 y145 w220 h70", "Attack Key 2")
    ConfigGUI.AddCheckBox("x40 y165 w150 h20 vEnableAttackKey2", "Enable Attack Key 2")
    ConfigGUI.AddText("x40 y190 w40 h20", "Key:")
    ConfigGUI.AddEdit("x160 y187 w40 h20 vAttackKey2")
    
    ; Recover Main Hand Group (moved to left column)
    ConfigGUI.AddGroupBox("x30 y225 w220 h105", "Recover Main Hand")
    ConfigGUI.AddCheckBox("x40 y245 w150 h20 vRecoverFumbleMain", "Enable Recover Main Hand")
    ConfigGUI.AddText("x40 y270 w80 h20", "Key:")
    ConfigGUI.AddEdit("x160 y267 w40 h20 vRecoverMainKey")
    ConfigGUI.AddText("x40 y300 w60 h20", "Coordinates:")
    ConfigGUI.AddEdit("x100 y297 w30 h20 vMainHandXKeys")
    ConfigGUI.AddEdit("x135 y297 w30 h20 vMainHandYKeys")
    ConfigGUI.AddText("x170 y300 w60 h20 cBlue", "Ctrl+Shift+F")
    
    ; Recover Offhand Group (moved to left column)
    ConfigGUI.AddGroupBox("x30 y340 w220 h105", "Recover Offhand")
    ConfigGUI.AddCheckBox("x40 y360 w150 h20 vRecoverFumbleOffhand", "Enable Recover Offhand")
    ConfigGUI.AddText("x40 y385 w80 h20", "Key:")
    ConfigGUI.AddEdit("x160 y382 w40 h20 vRecoverOffhandKey")
    ConfigGUI.AddText("x40 y415 w60 h20", "Coordinates:")
    ConfigGUI.AddEdit("x100 y412 w30 h20 vOffHandXKeys")
    ConfigGUI.AddEdit("x135 y412 w30 h20 vOffHandYKeys")
    ConfigGUI.AddText("x170 y415 w60 h20 cBlue", "Ctrl+Shift+W")
    
    ; Money Ring Key Group (moved to bottom with coordinates)
    ConfigGUI.AddGroupBox("x30 y455 w220 h120", "Money Ring Key")
    ConfigGUI.AddText("x40 y475 w100 h20", "Key:")
    ConfigGUI.AddEdit("x160 y472 w40 h20 vMoneyRingKey")
    ConfigGUI.AddGroupBox("x40 y495 w200 h70","Coin Search Area")
    ConfigGUI.AddText("x45 y515 w60 h20", "Top-Left:")
    ConfigGUI.AddEdit("x110 y512 w30 h20 vCoinAreaTopLeftX")
    ConfigGUI.AddEdit("x145 y512 w30 h20 vCoinAreaTopLeftY")
    ConfigGUI.AddText("x180 y515 w55 h20 cBlue", "Ctrl+Shift+U")
    ConfigGUI.AddText("x45 y540 w70 h20", "Bottom-Right:")
    ConfigGUI.AddEdit("x110 y537 w30 h20 vCoinAreaBottomRightX")
    ConfigGUI.AddEdit("x145 y537 w30 h20 vCoinAreaBottomRightY")
    ConfigGUI.AddText("x180 y540 w55 h20 cBlue","Ctrl+Shift+I")
    
    ; Right Column
    ; MA Skills Group (moved to right column)
    ConfigGUI.AddGroupBox("x300 y90 w220 h170", "MA Skills")
    ConfigGUI.AddCheckBox("x310 y110 w150 h20 vEnableMASkill", "Enable MA Skills")
    
    ; MA Mode Selection (mutually exclusive checkboxes)
    ConfigGUI.AddText("x310 y135 w80 h20", "Mode:")
    ConfigGUI.AddCheckBox("x310 y155 w43 h20 vMAFistsMode", "Fists").OnEvent("Click", OnMAFistsModeChange)
    ConfigGUI.AddCheckBox("x355 y155 w60 h20 vMARestockMode", "Restock").OnEvent("Click", OnMARestockModeChange)
    ConfigGUI.AddCheckBox("x420 y155 w40 h20 vMAAutoMode", "Auto").OnEvent("Click", OnMAAutoModeChange)
    ConfigGUI.AddCheckBox("x462 y155 w50 h20 vMARefillMode", "Refill").OnEvent("Click", OnMARefillModeChange)
    
    ConfigGUI.AddText("x310 y180 w100 h20", "MA Fists Key:")
    ConfigGUI.AddEdit("x430 y177 w40 h20 vMAFistsKey")
    ConfigGUI.AddText("x310 y205 w100 h20", "MA Restock Key:")
    ConfigGUI.AddEdit("x430 y202 w40 h20 vMARestockKey")
    ConfigGUI.AddText("x310 y230 w100 h20", "Potions per Restock:")
    ConfigGUI.AddEdit("x430 y227 w20 h20 vPotionsPerRestock")
    
    ; Knight Heal Group (moved to right column)
    ConfigGUI.AddGroupBox("x300 y270 w220 h70", "Knight Heal")
    ConfigGUI.AddCheckBox("x310 y290 w150 h20 vEnableKnightHeal", "Enable Knight Heal")
    ConfigGUI.AddText("x310 y315 w80 h20", "Key:")
    ConfigGUI.AddEdit("x430 y312 w40 h20 vKnightHealKey")

    ; Spell Casting Group
    ConfigGUI.AddGroupBox("x300 y350 w220 h170", "Spell Casting")
    ConfigGUI.AddCheckBox("x310 y370 w150 h20 vEnableSpellCasting", "Enable Spell Casting")
    ConfigGUI.AddCheckBox("x310 y395 w200 h20 vEnableSpellCreatureCheck", "Require creatures present")
    ConfigGUI.AddText("x310 y420 w80 h20", "Warm Key:")
    ConfigGUI.AddEdit("x430 y417 w40 h20 vWarmSpellKey")
    ConfigGUI.AddText("x310 y445 w80 h20", "Cast Key:")
    ConfigGUI.AddEdit("x430 y442 w40 h20 vCastSpellKey")
    ConfigGUI.AddText("x310 y470 w100 h20", "Delay (ms):")
    ConfigGUI.AddEdit("x430 y467 w60 h20 vSpellCastingDelay")
    ConfigGUI.AddText("x310 y495 w100 h20", "Warmed Spell:")
    ConfigGUI.AddEdit("x385 y492 w30 h20 vWarmedSpellX")
    ConfigGUI.AddEdit("x420 y492 w30 h20 vWarmedSpellY")
    ConfigGUI.AddText("x455 y495 w60 h20 cBlue", "Ctrl+Shift+V")
    
}

; Create Monitoring tab
CreateMonitoringTab() {
    global ConfigGUI, TabControl
    
    ; Switch to Monitoring tab
    TabControl.UseTab(4)
    
    ; Health Monitoring
    ConfigGUI.AddGroupBox("x20 y65 w260 h115", "Health Monitoring")
    ConfigGUI.AddCheckBox("x30 y90 w150 h20 vEnableHealth", "Enable Health Monitoring")
    ConfigGUI.AddText("x30 y120 w60 h20 cBlue", "Ctrl+Shift+H")
    ConfigGUI.AddText("x90 y120 w100 h20", "to set auto-heal level")
    ConfigGUI.AddText("x30 y150 w60 h20", "Coordinates:")
    ConfigGUI.AddEdit("x100 y147 w60 h20 vHealthX")
    ConfigGUI.AddEdit("x170 y147 w60 h20 vHealthY")
    
    ; Mana Monitoring
    ConfigGUI.AddGroupBox("x300 y65 w260 h115", "Mana Monitoring")
    ConfigGUI.AddCheckBox("x310 y90 w150 h20 vEnableMana", "Enable Mana Monitoring")
    ConfigGUI.AddText("x310 y120 w60 h20 cBlue", "Ctrl+Shift+M")
    ConfigGUI.AddText("x370 y120 w100 h20", "to set auto-cast level")
    ConfigGUI.AddText("x310 y150 w60 h20", "Coordinates:")
    ConfigGUI.AddEdit("x380 y147 w60 h20 vManaX")
    ConfigGUI.AddEdit("x450 y147 w60 h20 vManaY")
    
    ; Creature Detection
    ConfigGUI.AddGroupBox("x20 y190 w540 h115", "Creature Detection")

    ConfigGUI.AddCheckBox("x30 y215 w150 h20 vEnableAttackSpamReduction", "Enable Creature Detection").OnEvent("Click", OnCreatureDetectionChange)
    ConfigGUI.AddText("x30 y245 w200 h20 cBlue", "Ctrl+Shift+C")
    ConfigGUI.AddText("x90 y245 w140 h20", "on top health gem on crit list")
    ConfigGUI.AddText("x30 y275 w60 h20", "Coordinates:")
    ConfigGUI.AddEdit("x100 y272 w60 h20 vCreatureX")
    ConfigGUI.AddEdit("x170 y272 w60 h20 vCreatureY")
    
    ; Enhanced Creature Verification (Right side)
    ConfigGUI.AddCheckBox("x300 y215 w200 h20 vEnableCreatureListVerification", "Enable Crit List Verification").OnEvent("Click", OnCreatureDetectionChange)
    ConfigGUI.AddText("x300 y245 w200 h20 cBlue", "Ctrl+Shift+G")
    ConfigGUI.AddText("x360 y245 w140 h20", "on a crit list green arrow")
    ConfigGUI.AddText("x300 y275 w60 h20", "Coordinates:")
    ConfigGUI.AddEdit("x370 y272 w60 h20 vCritListVerifyX")
    ConfigGUI.AddEdit("x440 y272 w60 h20 vCritListVerifyY")
    
    ; Active Spell Bar Scrolling
    ConfigGUI.AddGroupBox("x20 y315 w540 h115", "Active Spell Bar Scrolling")
    ConfigGUI.AddCheckBox("x30 y340 w200 h20 vEnableActiveSpellScrollingMonitoring", "Enable Active Spell Bar Scrolling")
    
    ; Left Arrow coordinates
    ConfigGUI.AddText("x30 y370 w200 h20 cBlue", "Ctrl+Shift+J")
    ConfigGUI.AddText("x30 y395 w60 h20", "Left Arrow:")
    ConfigGUI.AddEdit("x100 y392 w30 h20 vActiveSpellsLeftX")
    ConfigGUI.AddEdit("x140 y392 w30 h20 vActiveSpellsLeftY")
    
    ; Right Arrow coordinates
    ConfigGUI.AddText("x200 y370 w200 h20 cBlue", "Ctrl+Shift+O")
    ConfigGUI.AddText("x200 y395 w60 h20", "Right Arrow:")
    ConfigGUI.AddEdit("x270 y392 w30 h20 vActiveSpellsRightX")
    ConfigGUI.AddEdit("x310 y392 w30 h20 vActiveSpellsRightY")
    
    ; Empty Spot coordinates
    ConfigGUI.AddText("x370 y370 w100 h20 cBlue", "Ctrl+Shift+Q")
    ConfigGUI.AddText("x430 y370 w160 h20","(after spell wears off)")
    ConfigGUI.AddText("x370 y395 w60 h20", "Empty Spot:")
    ConfigGUI.AddEdit("x440 y392 w30 h20 vActiveSpellGoneX")
    ConfigGUI.AddEdit("x480 y392 w30 h20 vActiveSpellGoneY")
    
    ; Cursor Ready Hashes
    ConfigGUI.AddGroupBox("x20 y440 w540 h105", "Cursor Ready Hashes")
    ConfigGUI.AddText("x30 y465 w250 h20", "Press")
        ConfigGUI.AddText("x60 y465 w200 h20 cBlue", "Ctrl+Shift+R")
            ConfigGUI.AddText("x115 y465 w400 h20", " when curtsor shows ready (pointer or crosshairs)")
    ConfigGUI.AddText("x30 y490 w200 h20", "Ready Hashes (comma-separated):")
    ConfigGUI.AddEdit("x30 y510 w480 h20 vReadyCursorHashesEdit", "")
    
}

; Create Hotkeys tab
CreateHotkeysTab() {
    global ConfigGUI, TabControl
    
    ; Switch to Hotkeys tab
    TabControl.UseTab(5)
    
    ; Hotkey Legend
    ConfigGUI.AddGroupBox("x20 y65 w540 h140", "Core Controls")
    ConfigGUI.AddText("x30 y90 w400 h20", "Ctrl+Shift+~ - Open Configuration GUI")
    ConfigGUI.AddText("x30 y120 w400 h20", "Middle Click - Toggle Auto Fight mode")
    ConfigGUI.AddText("x30 y150 w400 h20", "Alt+G - Execute coin pickup")
    ConfigGUI.AddText("x30 y180 w400 h20", "Ctrl+Shift+1-9 - Switch to profile 1-9")

    
    ConfigGUI.AddGroupBox("x20 y215 w540 h110", "Combat Toggles")
    ConfigGUI.AddText("x30 y240 w400 h20", "Ctrl+Shift+S - Toggle second attack key")
    ConfigGUI.AddText("x30 y270 w400 h20", "Ctrl+Shift+E - Swap attack keys")
    ConfigGUI.AddText("x30 y300 w400 h20", "Ctrl+Shift+T - Toggle MA mode (fists/restock/auto/refill)")
    
    ; Note about hotkey customization
    ConfigGUI.AddText("x20 y335 w540 h20", "Note: Hotkeys are hardcoded and cannot be customized through the GUI.")
    ConfigGUI.AddText("x20 y365 w540 h20", "To change hotkeys, edit the script file directly.")
}


; GUI Event Handlers

; Save all settings from all tabs
RestoreDefaults(*) {
    global ConfigGUI, CurrentProfile, ConfigFile, GetProfileName, TooltipDisplayTime
    
    if (!ConfigGUI || !ConfigGUI.Hwnd) {
        return
    }
    
    ; Ask for confirmation
    profileName := GetProfileName(CurrentProfile)
    result := MsgBox("Are you sure you want to restore settings to default values for the current profile?`n`nProfile: " . profileName . "`n`nThis will reset all settings (including timing settings) for this profile only. Other profiles will remain unchanged.`n`nThis action cannot be undone!", "Restore Defaults", "YesNo")
    if (result != "Yes") {
        return
    }
    
    try {
        ; Create a backup before restoring defaults
        CreateBackup()
        
        ; Restore defaults for current profile only
        RestoreProfileDefaults(CurrentProfile)
        
        ; Update timing global variables to match the restored defaults
        ShortDelay := 32
        MediumDelay := 64
        LongDelay := 128
        TooltipDisplayTime := 2048
        AutoLoopInterval := 128
        CoinRoundTimerDelay := 1064
        LoginDelay := 200
        MouseClickCooldown := 2000
        GameMonitorInterval := 2000
        
        ; Reload the configuration to update global variables
        LoadConfig(CurrentProfile)
        
        ; Update the GUI with default values
        LoadProfileToGUI()
        
        ; Show success message
        ToolTip("Profile " . profileName . " restored to defaults successfully!", , , 20)
        SetTimer(() => ToolTip(, , , 20), -TooltipDisplayTime)
        
        LogMessage("Profile " . profileName . " restored to defaults")
        
    } catch Error as e {
        ToolTip("Error restoring defaults: " . e.Message, , , 21)
        SetTimer(() => ToolTip(, , , 21), -TooltipDisplayTime)
        LogMessage("Error restoring defaults: " . e.Message)
    }
}

SaveAllSettings(*) {
    global ConfigGUI, CurrentProfile, ConfigFile
    
    if (!ConfigGUI || !ConfigGUI.Hwnd) {
        return
    }
    
    try {
        ; Save profile name
        profileName := ConfigGUI["ProfileNameEdit"].Text
        if (profileName != "") {
            SaveProfileName(CurrentProfile, profileName)
            LogMessage("Profile name saved as: " . profileName)
        }
        
        ; Save all settings from all tabs
        SaveStartTabSettings()
        SaveTimingTabSettings()
        SaveKeysTabSettings()
        SaveMonitoringTabSettings()
        
        ; Show success message
        ToolTip("All settings saved successfully!", 100, 100, 18)
        SetTimer(() => ToolTip(, , , 18), -TooltipDisplayTime)
        
        LogMessage("All settings saved successfully for profile " . CurrentProfile)
        
    } catch Error as e {
        LogMessage("Error saving all settings: " . e.Message)
        MsgBox("Error saving settings: " . e.Message, "Error", "OK")
    }
}

; Handle EnableBackups checkbox change
OnEnableBackupsChange(Ctrl, *) {
    global ConfigGUI
    
    ; Enable/disable BackupConfigOnly checkbox based on EnableBackups state
    if (Ctrl.Value = 0) {
        ; If EnableBackups is unchecked, disable and uncheck BackupConfigOnly
        ConfigGUI["BackupConfigOnlyCheckbox"].Enabled := false
        ConfigGUI["BackupConfigOnlyCheckbox"].Value := 0
    } else {
        ; If EnableBackups is checked, enable BackupConfigOnly checkbox
        ConfigGUI["BackupConfigOnlyCheckbox"].Enabled := true
    }
}

OnTabChange(Ctrl, *) {
    global CurrentTab
    CurrentTab := Ctrl.Text
    ; Tab change doesn't need to reload data since all tabs are created at once
}

; Load current profile data into GUI
LoadProfileToGUI() {
    global ConfigGUI, CurrentProfile, ProfileDropdown
    global HealthAreaX, HealthAreaY, ManaAreaX, ManaAreaY, CreatureAreaX, CreatureAreaY
    global LoginButtonX, LoginButtonY, DrinkKey, AttackKey1, AttackKey2, EnableAttackKey2
    global EnableMASkill, CurrentMASkill, MAFistsKey, MARestockKey, PotionsPerRestock, UsedPotionsCount, EnableKnightHeal, KnightHealKey
    global EnableActiveSpellScrolling, ActiveSpellsLeftX, ActiveSpellsLeftY, ActiveSpellsRightX, ActiveSpellsRightY
    global ActiveSpellGoneX, ActiveSpellGoneY, EnableSpellCasting, SpellCastingDelay, EnableSpellCreatureCheck, WarmSpellKey, CastSpellKey, WarmedSpellX, WarmedSpellY
    global RecoverFumbleMain, RecoverFumbleOffhand, RecoverMainKey, RecoverOffhandKey
    global MainHandX, MainHandY, OffHandX, OffHandY, CoinAreaTopLeftX, CoinAreaTopLeftY
    global CoinAreaBottomRightX, CoinAreaBottomRightY, MoneyRingKey, EnableCreatureListVerification
    global CritListVerifyX, CritListVerifyY, EnableHealthMonitoring, EnableManaMonitoring, AttackSpamReduction
    global AutoClickLogin, GamePath, BackupFolder, EnableBackups, BackupConfigOnly, EnableDebugLogging
    global ShortDelay, MediumDelay, LongDelay, TooltipDisplayTime, AutoLoopInterval, CoinRoundTimerDelay, LoginDelay, MouseClickCooldown, GameMonitorInterval
    
    if (!ConfigGUI || !ConfigGUI.Hwnd) {
        return
    }
    
    
    ; Load all the current values into the GUI fields
        ; Game Path Settings
        ConfigGUI["GamePathEdit"].Text := GamePath
        ConfigGUI["AutoClickLoginCheckbox"].Value := AutoClickLogin ? 1 : 0
        ConfigGUI["LoginButtonXEdit"].Text := LoginButtonX
        ConfigGUI["LoginButtonYEdit"].Text := LoginButtonY
        ConfigGUI["AutoMaximizeWindowCheckbox"].Value := AutoMaximizeWindow ? 1 : 0
        ConfigGUI["UseSecondaryMonitorCheckbox"].Value := UseSecondaryMonitor ? 1 : 0
        ConfigGUI["SecondaryMonitorNumberEdit"].Text := SecondaryMonitorNumber
        ConfigGUI["BackupFolderEdit"].Text := BackupFolder
        ConfigGUI["EnableBackupsCheckbox"].Value := EnableBackups ? 1 : 0
        ConfigGUI["BackupConfigOnlyCheckbox"].Value := BackupConfigOnly ? 1 : 0
        ConfigGUI["BackupConfigOnlyCheckbox"].Enabled := EnableBackups
        ConfigGUI["EnableDebugLoggingCheckbox"].Value := EnableDebugLogging ? 1 : 0
        
        ; Keys Tab Settings - Profile selection is now handled by individual tabs
        ; Load profile name (single control used across all tabs)
        ConfigGUI["ProfileNameEdit"].Text := GetProfileName(CurrentProfile)
        
        ; Timing Settings
        ConfigGUI["ShortDelay"].Text := ShortDelay
        ConfigGUI["MediumDelay"].Text := MediumDelay
        ConfigGUI["LongDelay"].Text := LongDelay
        ConfigGUI["TooltipDisplayTime"].Text := TooltipDisplayTime
        ConfigGUI["AutoLoopInterval"].Text := AutoLoopInterval
        ConfigGUI["CoinRoundTimerDelay"].Text := CoinRoundTimerDelay
        ConfigGUI["LoginDelay"].Text := LoginDelay
        ConfigGUI["MouseClickCooldown"].Text := MouseClickCooldown
        ConfigGUI["GameMonitorInterval"].Text := GameMonitorInterval
        
        ; Basic Settings (Monitoring tab coordinates)
        ConfigGUI["HealthX"].Text := HealthAreaX
        ConfigGUI["HealthY"].Text := HealthAreaY
        ConfigGUI["ManaX"].Text := ManaAreaX
        ConfigGUI["ManaY"].Text := ManaAreaY
        ConfigGUI["CreatureX"].Text := CreatureAreaX
        ConfigGUI["CreatureY"].Text := CreatureAreaY
        
        ; Checkboxes (Monitoring tab)
        LogMessage("Loading Monitoring tab - EnableHealth: " . EnableHealthMonitoring . ", EnableCreatureListVerification: " . EnableCreatureListVerification)
        ConfigGUI["EnableHealth"].Value := EnableHealthMonitoring ? 1 : 0
        ConfigGUI["EnableMana"].Value := EnableManaMonitoring ? 1 : 0
        ConfigGUI["EnableAttackSpamReduction"].Value := AttackSpamReduction ? 1 : 0
        ConfigGUI["EnableCreatureListVerification"].Value := EnableCreatureListVerification ? 1 : 0
        ConfigGUI["AutoClickLoginCheckbox"].Value := AutoClickLogin ? 1 : 0
        
        ; Attack Settings (Keys tab)
        LogMessage("Loading Keys tab - DrinkKey: " . DrinkKey . ", AttackKey1: " . AttackKey1 . ", EnableMASkill: " . EnableMASkill)
        ConfigGUI["DrinkKey"].Text := DrinkKey
        ConfigGUI["AttackKey1"].Text := AttackKey1
        ConfigGUI["AttackKey2"].Text := AttackKey2
        ConfigGUI["EnableAttackKey2"].Value := EnableAttackKey2 ? 1 : 0
        ConfigGUI["EnableMASkill"].Value := EnableMASkill ? 1 : 0
        
        ; Load MA mode selection (mutually exclusive checkboxes)
        if (CurrentMASkill = "fists") {
            ConfigGUI["MAFistsMode"].Value := 1
            ConfigGUI["MARestockMode"].Value := 0
            ConfigGUI["MAAutoMode"].Value := 0
            ConfigGUI["MARefillMode"].Value := 0
        } else if (CurrentMASkill = "restock") {
            ConfigGUI["MAFistsMode"].Value := 0
            ConfigGUI["MARestockMode"].Value := 1
            ConfigGUI["MAAutoMode"].Value := 0
            ConfigGUI["MARefillMode"].Value := 0
        } else if (CurrentMASkill = "auto") {
            ConfigGUI["MAFistsMode"].Value := 0
            ConfigGUI["MARestockMode"].Value := 0
            ConfigGUI["MAAutoMode"].Value := 1
            ConfigGUI["MARefillMode"].Value := 0
        } else if (CurrentMASkill = "refill") {
            ConfigGUI["MAFistsMode"].Value := 0
            ConfigGUI["MARestockMode"].Value := 0
            ConfigGUI["MAAutoMode"].Value := 0
            ConfigGUI["MARefillMode"].Value := 1
        } else {
            ; Default to restock if none is set
            ConfigGUI["MAFistsMode"].Value := 0
            ConfigGUI["MARestockMode"].Value := 1
            ConfigGUI["MAAutoMode"].Value := 0
            ConfigGUI["MARefillMode"].Value := 0
        }
        
        ConfigGUI["MAFistsKey"].Text := MAFistsKey
        ConfigGUI["MARestockKey"].Text := MARestockKey
        ConfigGUI["PotionsPerRestock"].Text := PotionsPerRestock
        ConfigGUI["EnableKnightHeal"].Value := EnableKnightHeal ? 1 : 0
        ConfigGUI["KnightHealKey"].Text := KnightHealKey
        
        ; Advanced Settings (Keys tab remaining controls)
        ConfigGUI["EnableSpellCasting"].Value := EnableSpellCasting ? 1 : 0
        ConfigGUI["SpellCastingDelay"].Text := SpellCastingDelay
        ConfigGUI["EnableSpellCreatureCheck"].Value := EnableSpellCreatureCheck ? 1 : 0
        ConfigGUI["WarmSpellKey"].Text := WarmSpellKey
        ConfigGUI["CastSpellKey"].Text := CastSpellKey
        ConfigGUI["WarmedSpellX"].Text := WarmedSpellX
        ConfigGUI["WarmedSpellY"].Text := WarmedSpellY
        ConfigGUI["RecoverFumbleMain"].Value := RecoverFumbleMain ? 1 : 0
        ConfigGUI["RecoverFumbleOffhand"].Value := RecoverFumbleOffhand ? 1 : 0
        ConfigGUI["RecoverMainKey"].Text := RecoverMainKey
        ConfigGUI["RecoverOffhandKey"].Text := RecoverOffhandKey
        ConfigGUI["MoneyRingKey"].Text := MoneyRingKey
        
        ; Load Monitoring tab Active Spell Bar controls
        ConfigGUI["EnableActiveSpellScrollingMonitoring"].Value := EnableActiveSpellScrolling ? 1 : 0
        ConfigGUI["ActiveSpellsLeftX"].Text := ActiveSpellsLeftX
        ConfigGUI["ActiveSpellsLeftY"].Text := ActiveSpellsLeftY
        ConfigGUI["ActiveSpellsRightX"].Text := ActiveSpellsRightX
        ConfigGUI["ActiveSpellsRightY"].Text := ActiveSpellsRightY
        ConfigGUI["ActiveSpellGoneX"].Text := ActiveSpellGoneX
        ConfigGUI["ActiveSpellGoneY"].Text := ActiveSpellGoneY
        ConfigGUI["CritListVerifyX"].Text := CritListVerifyX
        ConfigGUI["CritListVerifyY"].Text := CritListVerifyY
        
        ; Load Cursor Ready Hashes
        hashString := ""
        for hash in ReadyCursorHashes {
            hashString .= (hashString ? ", " : "") . hash
        }
        ConfigGUI["ReadyCursorHashesEdit"].Text := hashString
        
        
        
        ; Load Keys tab coordinate controls
        ConfigGUI["MainHandXKeys"].Text := MainHandX
        ConfigGUI["MainHandYKeys"].Text := MainHandY
        ConfigGUI["OffHandXKeys"].Text := OffHandX
        ConfigGUI["OffHandYKeys"].Text := OffHandY
        ConfigGUI["CoinAreaTopLeftX"].Text := CoinAreaTopLeftX
        ConfigGUI["CoinAreaTopLeftY"].Text := CoinAreaTopLeftY
        ConfigGUI["CoinAreaBottomRightX"].Text := CoinAreaBottomRightX
        ConfigGUI["CoinAreaBottomRightY"].Text := CoinAreaBottomRightY

}

; Browse for game executable
BrowseForGame(*) {
    global ConfigGUI, GamePath, GameExecutable, ConfigFile
    
    ; Open file dialog to select Kesmai.Client.exe
    selectedFile := FileSelect(1, , "Select Kesmai.Client.exe", "Executable Files (*.exe)")
    
    if (selectedFile != "") {
        ; Extract directory path and filename
        gamePath := RegExReplace(selectedFile, "\\[^\\]+$", "")
        gameExecutable := RegExReplace(selectedFile, ".*\\", "")
        
        ; Update global variables
        GamePath := gamePath
        GameExecutable := gameExecutable
        
        ; Update GUI display
        ConfigGUI["GamePathEdit"].Text := gamePath
        
        ; Show message that user needs to save
        ToolTip("Game path selected. Click 'Save Start Tab Settings' to save to config.", 100, 100, 18)
        SetTimer(() => ToolTip("", 100, 100, 18), -TooltipDisplayTime)
    }
}

; Function to browse for backup folder
BrowseForBackupFolder(*) {
    global ConfigGUI, BackupFolder, ConfigFile
    
    ; Open folder dialog to select backup folder
    selectedFolder := DirSelect(, 3, "Select Backup Folder")
    
    if (selectedFolder != "") {
        ; Update global variable
        BackupFolder := selectedFolder
        
        ; Update GUI display
        ConfigGUI["BackupFolderEdit"].Text := BackupFolder
        
        ; Show message that user needs to save
        ToolTip("Backup folder selected. Click 'Save Start Tab Settings' to save to config.", 100, 100, 18)
        SetTimer(() => ToolTip("", 100, 100, 18), -TooltipDisplayTime)
    }
}

; Save all Start tab settings to config
SaveStartTabSettings(*) {
    global ConfigGUI, GamePath, GameExecutable, AutoClickLogin, LoginButtonX, LoginButtonY, AutoMaximizeWindow, UseSecondaryMonitor, SecondaryMonitorNumber, BackupFolder, EnableBackups, BackupConfigOnly, EnableDebugLogging, ConfigFile
    
    if (!ConfigGUI || !ConfigGUI.Hwnd) {
        return
    }
    
    try {
        ; Get current path from GUI
        currentPath := ConfigGUI["GamePathEdit"].Text
        
        ; Save game path if one is selected
        if (currentPath != "") {
            ; Ensure path ends with backslash
            if (SubStr(currentPath, -1) != "\") {
                currentPath := currentPath . "\"
            }
            
            ; Update global variables
            GamePath := currentPath
            GameExecutable := "Kesmai.Client.exe"
            
            ; Update GUI display with trailing backslash
            ConfigGUI["GamePathEdit"].Text := currentPath
            
            ; Save to config file
            IniWrite(GamePath, ConfigFile, "GAME SETTINGS", "GamePath")
            IniWrite(GameExecutable, ConfigFile, "GAME SETTINGS", "GameExecutable")
            LogMessage("Game path saved to: " . GamePath)
        }
        
        ; Get and save AutoClickLogin setting
        AutoClickLogin := ConfigGUI["AutoClickLoginCheckbox"].Value = 1
        IniWrite(AutoClickLogin ? "true" : "false", ConfigFile, "GAME SETTINGS", "AutoClickLogin")
        LogMessage("AutoClickLogin setting saved as: " . (AutoClickLogin ? "true" : "false"))
        
        ; Get and save Login Button coordinates
        LoginButtonX := ConfigGUI["LoginButtonXEdit"].Text
        LoginButtonY := ConfigGUI["LoginButtonYEdit"].Text
        IniWrite(LoginButtonX, ConfigFile, "GAME SETTINGS", "LoginButtonX")
        IniWrite(LoginButtonY, ConfigFile, "GAME SETTINGS", "LoginButtonY")
        LogMessage("Login Button coordinates saved as: X=" . LoginButtonX . ", Y=" . LoginButtonY)
        
        ; Get and save AutoMaximizeWindow setting
        AutoMaximizeWindow := ConfigGUI["AutoMaximizeWindowCheckbox"].Value = 1
        IniWrite(AutoMaximizeWindow ? "true" : "false", ConfigFile, "GAME SETTINGS", "AutoMaximizeWindow")
        LogMessage("AutoMaximizeWindow setting saved as: " . (AutoMaximizeWindow ? "true" : "false"))
        
        ; Get and save UseSecondaryMonitor setting
        UseSecondaryMonitor := ConfigGUI["UseSecondaryMonitorCheckbox"].Value = 1
        IniWrite(UseSecondaryMonitor ? "true" : "false", ConfigFile, "GAME SETTINGS", "UseSecondaryMonitor")
        LogMessage("UseSecondaryMonitor setting saved as: " . (UseSecondaryMonitor ? "true" : "false"))
        
        ; Get and save SecondaryMonitorNumber
        SecondaryMonitorNumber := ConfigGUI["SecondaryMonitorNumberEdit"].Text
        IniWrite(SecondaryMonitorNumber, ConfigFile, "GAME SETTINGS", "SecondaryMonitorNumber")
        LogMessage("SecondaryMonitorNumber saved as: " . SecondaryMonitorNumber)
        
        ; Get and save BackupFolder
        BackupFolder := ConfigGUI["BackupFolderEdit"].Text
        IniWrite(BackupFolder, ConfigFile, "GAME SETTINGS", "BackupFolder")
        LogMessage("BackupFolder saved as: " . BackupFolder)
        
        ; Get and save EnableBackups setting
        EnableBackups := ConfigGUI["EnableBackupsCheckbox"].Value = 1
        IniWrite(EnableBackups ? "true" : "false", ConfigFile, "LOGGING SETTINGS", "EnableBackups")
        LogMessage("EnableBackups setting saved as: " . (EnableBackups ? "true" : "false"))
        
        ; Get and save BackupConfigOnly setting
        BackupConfigOnly := ConfigGUI["BackupConfigOnlyCheckbox"].Value = 1
        IniWrite(BackupConfigOnly ? "true" : "false", ConfigFile, "LOGGING SETTINGS", "BackupConfigOnly")
        LogMessage("BackupConfigOnly setting saved as: " . (BackupConfigOnly ? "true" : "false"))
        
        ; Get and save EnableDebugLogging setting
        EnableDebugLogging := ConfigGUI["EnableDebugLoggingCheckbox"].Value = 1
        IniWrite(EnableDebugLogging ? "true" : "false", ConfigFile, "LOGGING SETTINGS", "EnableDebugLogging")
        LogMessage("EnableDebugLogging setting saved as: " . (EnableDebugLogging ? "true" : "false"))
        
    } catch Error as e {
        LogMessage("Error saving Start tab settings: " . e.Message)
        MsgBox("Error saving Start tab settings: " . e.Message, "Error", "OK")
    }
}

SaveKeysTabSettings(*) {
    global ConfigGUI, CurrentProfile, AttackKey1, AttackKey2, EnableAttackKey2, DrinkKey, EnableMASkill, MAFistsKey, MARestockKey, EnableKnightHeal, KnightHealKey, EnableSpellCasting, SpellCastingDelay, EnableSpellCreatureCheck, WarmSpellKey, CastSpellKey, WarmedSpellX, WarmedSpellY, RecoverFumbleMain, RecoverMainKey, RecoverFumbleOffhand, RecoverOffhandKey, MoneyRingKey, MainHandX, MainHandY, OffHandX, OffHandY, CoinAreaTopLeftX, CoinAreaTopLeftY, CoinAreaBottomRightX, CoinAreaBottomRightY, ConfigFile
    
    if (!ConfigGUI || !ConfigGUI.Hwnd) {
        return
    }
    
    try {
        ; Get and save profile name
        profileName := ConfigGUI["ProfileNameEdit"].Text
        if (profileName != "") {
            SaveProfileName(CurrentProfile, profileName)
            LogMessage("Profile name saved as: " . profileName)
        }
        
        ; Get and save all key settings
        AttackKey1 := ConfigGUI["AttackKey1"].Text
        AttackKey2 := ConfigGUI["AttackKey2"].Text
        EnableAttackKey2 := ConfigGUI["EnableAttackKey2"].Value = 1
        DrinkKey := ConfigGUI["DrinkKey"].Text
        EnableMASkill := ConfigGUI["EnableMASkill"].Value = 1
        
        ; Handle MA mode selection (mutually exclusive checkboxes)
        if (ConfigGUI["MAFistsMode"].Value = 1) {
            CurrentMASkill := "fists"
        } else if (ConfigGUI["MARestockMode"].Value = 1) {
            CurrentMASkill := "restock"
        } else if (ConfigGUI["MAAutoMode"].Value = 1) {
            CurrentMASkill := "auto"
        } else if (ConfigGUI["MARefillMode"].Value = 1) {
            CurrentMASkill := "refill"
        }
        
        MAFistsKey := ConfigGUI["MAFistsKey"].Text
        MARestockKey := ConfigGUI["MARestockKey"].Text
        PotionsPerRestock := ConfigGUI["PotionsPerRestock"].Text
        EnableKnightHeal := ConfigGUI["EnableKnightHeal"].Value = 1
        KnightHealKey := ConfigGUI["KnightHealKey"].Text
        EnableSpellCasting := ConfigGUI["EnableSpellCasting"].Value = 1
        SpellCastingDelay := ConfigGUI["SpellCastingDelay"].Text
        EnableSpellCreatureCheck := ConfigGUI["EnableSpellCreatureCheck"].Value = 1
        WarmSpellKey := ConfigGUI["WarmSpellKey"].Text
        CastSpellKey := ConfigGUI["CastSpellKey"].Text
        WarmedSpellX := ConfigGUI["WarmedSpellX"].Text
        WarmedSpellY := ConfigGUI["WarmedSpellY"].Text
        RecoverFumbleMain := ConfigGUI["RecoverFumbleMain"].Value = 1
        RecoverMainKey := ConfigGUI["RecoverMainKey"].Text
        RecoverFumbleOffhand := ConfigGUI["RecoverFumbleOffhand"].Value = 1
        RecoverOffhandKey := ConfigGUI["RecoverOffhandKey"].Text
        MoneyRingKey := ConfigGUI["MoneyRingKey"].Text
        
        ; Get and save coordinate settings
        MainHandX := ConfigGUI["MainHandXKeys"].Text
        MainHandY := ConfigGUI["MainHandYKeys"].Text
        OffHandX := ConfigGUI["OffHandXKeys"].Text
        OffHandY := ConfigGUI["OffHandYKeys"].Text
        CoinAreaTopLeftX := ConfigGUI["CoinAreaTopLeftX"].Text
        CoinAreaTopLeftY := ConfigGUI["CoinAreaTopLeftY"].Text
        CoinAreaBottomRightX := ConfigGUI["CoinAreaBottomRightX"].Text
        CoinAreaBottomRightY := ConfigGUI["CoinAreaBottomRightY"].Text
        
        ; Save to config file
        SaveProfileAutoSettings(CurrentProfile)
        
    } catch Error as e {
        LogMessage("Error saving Keys tab settings: " . e.Message)
        MsgBox("Error saving Keys tab settings: " . e.Message, "Error", "OK")
    }
}

SaveMonitoringTabSettings(*) {
    global ConfigGUI, CurrentProfile, EnableHealthMonitoring, HealthAreaX, HealthAreaY, EnableManaMonitoring, ManaAreaX, ManaAreaY, AttackSpamReduction, CreatureAreaX, CreatureAreaY, EnableCreatureListVerification, CritListVerifyX, CritListVerifyY, ReadyCursorHashes, ConfigFile, EnableActiveSpellScrolling, ActiveSpellsLeftX, ActiveSpellsLeftY, ActiveSpellsRightX, ActiveSpellsRightY, ActiveSpellGoneX, ActiveSpellGoneY
    
    if (!ConfigGUI || !ConfigGUI.Hwnd) {
        return
    }
    
    try {
        ; Get and save profile name
        profileName := ConfigGUI["ProfileNameEdit"].Text
        if (profileName != "") {
            SaveProfileName(CurrentProfile, profileName)
            LogMessage("Profile name saved as: " . profileName)
        }
        
        ; Get and save all monitoring settings
        EnableHealthMonitoring := ConfigGUI["EnableHealth"].Value = 1
        HealthAreaX := ConfigGUI["HealthX"].Text
        HealthAreaY := ConfigGUI["HealthY"].Text
        EnableManaMonitoring := ConfigGUI["EnableMana"].Value = 1
        ManaAreaX := ConfigGUI["ManaX"].Text
        ManaAreaY := ConfigGUI["ManaY"].Text
        AttackSpamReduction := ConfigGUI["EnableAttackSpamReduction"].Value = 1
        CreatureAreaX := ConfigGUI["CreatureX"].Text
        CreatureAreaY := ConfigGUI["CreatureY"].Text
        EnableCreatureListVerification := ConfigGUI["EnableCreatureListVerification"].Value = 1
        CritListVerifyX := ConfigGUI["CritListVerifyX"].Text
        CritListVerifyY := ConfigGUI["CritListVerifyY"].Text
        
        ; Get and save Active Spell Bar Monitoring settings
        EnableActiveSpellScrolling := ConfigGUI["EnableActiveSpellScrollingMonitoring"].Value = 1
        ActiveSpellsLeftX := ConfigGUI["ActiveSpellsLeftX"].Text
        ActiveSpellsLeftY := ConfigGUI["ActiveSpellsLeftY"].Text
        ActiveSpellsRightX := ConfigGUI["ActiveSpellsRightX"].Text
        ActiveSpellsRightY := ConfigGUI["ActiveSpellsRightY"].Text
        ActiveSpellGoneX := ConfigGUI["ActiveSpellGoneX"].Text
        ActiveSpellGoneY := ConfigGUI["ActiveSpellGoneY"].Text
        
        ; Get and save Cursor Ready Hashes
        hashString := ConfigGUI["ReadyCursorHashesEdit"].Text
        if (hashString != "") {
            ReadyCursorHashes := StrSplit(hashString, ",")
            ; Trim whitespace from each hash
            for i, hash in ReadyCursorHashes {
                ReadyCursorHashes[i] := Trim(hash)
            }
        } else {
            ReadyCursorHashes := []
        }
        
        ; Save to config file
        SaveProfileAutoSettings(CurrentProfile)
        SaveCursorHashes()  ; Save cursor hashes to their own section
        
    } catch Error as e {
        LogMessage("Error saving Monitoring tab settings: " . e.Message)
        MsgBox("Error saving Monitoring tab settings: " . e.Message, "Error", "OK")
    }
}


OnProfileChange(Ctrl, *) {
    global ConfigGUI, CurrentProfile
    
    ; Extract profile number from dropdown text (e.g., "Profile 3" -> 3)
    profileText := Ctrl.Text
    if (RegExMatch(profileText, "Profile (\d+)", &match)) {
        newProfile := Integer(match[1])
        LogMessage("Profile changed to: " . newProfile)
        
        try {
            ; Update current profile
            CurrentProfile := newProfile
            
            ; Save the new current profile to config file
            IniWrite(CurrentProfile, ConfigFile, "CHARACTER PROFILES", "CurrentProfile")
            
            ; Load the new profile's settings from config file
            LoadConfig(newProfile)
            
            ; Debug logging
            LogMessage("After LoadConfig - DrinkKey: " . DrinkKey . ", AttackKey1: " . AttackKey1 . ", EnableMASkill: " . EnableMASkill)
            
            ; Load the new profile's settings into the GUI
            LoadProfileToGUI()
            
            
            LogMessage("Successfully switched to profile " . newProfile)
        } catch Error as e {
            LogMessage("Error switching to profile " . newProfile . ": " . e.Message)
            MsgBox("Error switching to profile " . newProfile . ": " . e.Message, "Error", "OK")
        }
    }
}

OnCreatureDetectionChange(Ctrl, *) {
    global ConfigGUI
    
    if (!ConfigGUI || !ConfigGUI.Hwnd) {
        return
    }
    
    try {
        ; If creature detection is unchecked, uncheck and disable enhanced verification
        if (Ctrl.Name = "EnableAttackSpamReduction" && Ctrl.Value = 0) {
            ConfigGUI["EnableCreatureListVerification"].Value := 0
            ConfigGUI["EnableCreatureListVerification"].Enabled := false
        } else if (Ctrl.Name = "EnableAttackSpamReduction" && Ctrl.Value = 1) {
            ; If creature detection is checked, enable enhanced verification
            ConfigGUI["EnableCreatureListVerification"].Enabled := true
        }
    } catch Error as e {
        LogMessage("Error in OnCreatureDetectionChange: " . e.Message)
    }
}

OnMAFistsModeChange(Ctrl, *) {
    global ConfigGUI
    
    if (!ConfigGUI || !ConfigGUI.Hwnd) {
        return
    }
    
    try {
        ; If Fists mode is checked, uncheck Restock, Auto, and Refill modes
        if (Ctrl.Value = 1) {
            ConfigGUI["MARestockMode"].Value := 0
            ConfigGUI["MAAutoMode"].Value := 0
            ConfigGUI["MARefillMode"].Value := 0
        }
    } catch Error as e {
        LogMessage("Error in OnMAFistsModeChange: " . e.Message)
    }
}

OnMARestockModeChange(Ctrl, *) {
    global ConfigGUI
    
    if (!ConfigGUI || !ConfigGUI.Hwnd) {
        return
    }
    
    try {
        ; If Restock mode is checked, uncheck Fists, Auto, and Refill modes
        if (Ctrl.Value = 1) {
            ConfigGUI["MAFistsMode"].Value := 0
            ConfigGUI["MAAutoMode"].Value := 0
            ConfigGUI["MARefillMode"].Value := 0
        }
    } catch Error as e {
        LogMessage("Error in OnMARestockModeChange: " . e.Message)
    }
}

OnMAAutoModeChange(Ctrl, *) {
    global ConfigGUI
    
    if (!ConfigGUI || !ConfigGUI.Hwnd) {
        return
    }
    
    try {
        ; If Auto mode is checked, uncheck Fists, Restock, and Refill modes
        if (Ctrl.Value = 1) {
            ConfigGUI["MAFistsMode"].Value := 0
            ConfigGUI["MARestockMode"].Value := 0
            ConfigGUI["MARefillMode"].Value := 0
        }
    } catch Error as e {
        LogMessage("Error in OnMAAutoModeChange: " . e.Message)
    }
}

OnMARefillModeChange(Ctrl, *) {
    global ConfigGUI
    
    if (!ConfigGUI || !ConfigGUI.Hwnd) {
        return
    }
    
    try {
        ; If Refill mode is checked, uncheck Fists, Restock, and Auto modes
        if (Ctrl.Value = 1) {
            ConfigGUI["MAFistsMode"].Value := 0
            ConfigGUI["MARestockMode"].Value := 0
            ConfigGUI["MAAutoMode"].Value := 0
        }
    } catch Error as e {
        LogMessage("Error in OnMARefillModeChange: " . e.Message)
    }
}

SaveTimingTabSettings(*) {
    global ConfigGUI, ShortDelay, MediumDelay, LongDelay, TooltipDisplayTime, AutoLoopInterval, CoinRoundTimerDelay, LoginDelay, MouseClickCooldown, GameMonitorInterval, ConfigFile
    
    if (!ConfigGUI || !ConfigGUI.Hwnd) {
        return
    }
    
    try {
        ; Get and save ShortDelay
        ShortDelay := ConfigGUI["ShortDelay"].Text
        IniWrite(ShortDelay, ConfigFile, "TIMING SETTINGS", "ShortDelay")
        LogMessage("ShortDelay saved as: " . ShortDelay)
        
        ; Get and save MediumDelay
        MediumDelay := ConfigGUI["MediumDelay"].Text
        IniWrite(MediumDelay, ConfigFile, "TIMING SETTINGS", "MediumDelay")
        LogMessage("MediumDelay saved as: " . MediumDelay)
        
        ; Get and save LongDelay
        LongDelay := ConfigGUI["LongDelay"].Text
        IniWrite(LongDelay, ConfigFile, "TIMING SETTINGS", "LongDelay")
        LogMessage("LongDelay saved as: " . LongDelay)
        
        ; Get and save TooltipDisplayTime
        TooltipDisplayTime := ConfigGUI["TooltipDisplayTime"].Text
        IniWrite(TooltipDisplayTime, ConfigFile, "TIMING SETTINGS", "TooltipDisplayTime")
        LogMessage("TooltipDisplayTime saved as: " . TooltipDisplayTime)
        
        
        ; Get and save AutoLoopInterval
        AutoLoopInterval := ConfigGUI["AutoLoopInterval"].Text
        IniWrite(AutoLoopInterval, ConfigFile, "TIMING SETTINGS", "AutoLoopInterval")
        LogMessage("AutoLoopInterval saved as: " . AutoLoopInterval)
        
        ; Get and save CoinRoundTimerDelay
        CoinRoundTimerDelay := ConfigGUI["CoinRoundTimerDelay"].Text
        IniWrite(CoinRoundTimerDelay, ConfigFile, "TIMING SETTINGS", "CoinRoundTimerDelay")
        LogMessage("CoinRoundTimerDelay saved as: " . CoinRoundTimerDelay)
        
        ; Get and save LoginDelay
        LoginDelay := ConfigGUI["LoginDelay"].Text
        IniWrite(LoginDelay, ConfigFile, "TIMING SETTINGS", "LoginDelay")
        LogMessage("LoginDelay saved as: " . LoginDelay)
        
        ; Get and save MouseClickCooldown
        MouseClickCooldown := ConfigGUI["MouseClickCooldown"].Text
        IniWrite(MouseClickCooldown, ConfigFile, "TIMING SETTINGS", "MouseClickCooldown")
        LogMessage("MouseClickCooldown saved as: " . MouseClickCooldown)
        
        ; Get and save GameMonitorInterval
        GameMonitorInterval := ConfigGUI["GameMonitorInterval"].Text
        IniWrite(GameMonitorInterval, ConfigFile, "TIMING SETTINGS", "GameMonitorInterval")
        LogMessage("GameMonitorInterval saved as: " . GameMonitorInterval)
        
        ; Settings saved (tooltip shown by SaveAllSettings)
        
    } catch Error as e {
        LogMessage("Error saving Timing settings: " . e.Message)
        MsgBox("Error saving Timing settings: " . e.Message, "Error", "OK")
    }
}

; Close GUI
CloseConfigGUI(*) {
    global ConfigGUI, GUIOpen, GameRunning, GameWindowTitle
    if (ConfigGUI && ConfigGUI.Hwnd) {
        ConfigGUI.Destroy()
        GUIOpen := false
        
        ; Check if game is running, if not, exit the script
        if (!IsGameRunning()) {
            LogMessage("GUI closed and game not running - exiting script")
            ExitApp()
        } else {
            ; Show a brief message that the script is still running
            ToolTip("Configuration GUI closed. Script continues running in background.`nPress Ctrl+Shift+~ to reopen GUI.", 100, 100, 20)
            SetTimer(() => ToolTip("", 100, 100, 20), -TooltipDisplayTime)  ; Show for configured time
        }
    }
}

; ========================================
; 7. SCRIPT INITIALIZATION
; ========================================

; Load configuration first
if (!LoadConfig()) {
    LogMessage("No configuration file detected, using default configuration.")
    MsgBox("No configuration file found, using default configuration.`n`nThis is normal on first run - the config file will be created automatically.`n`nCheck the VSQ_Config.ini for additional instructions.", "Configuration Notice", "OK")
}


; Create backup after config is loaded (so debug logging setting is respected)
CreateBackup()

; Log script startup
LogMessage("VSQ started")

pToken := Gdip_Startup()  ; Start GDI+
if (!pToken) {
    LogMessage("Failed to start GDI+ - cursor detection disabled")
}

; Show startup tooltip
ToolTip("Starting VSQ", , , 9)
SetTimer(() => ToolTip(, , , 9), -TooltipDisplayTime)

; Check if game is already running
if (IsGameRunning()) {
    GameRunning := true
    LogMessage("Game already running - script ready")
} else {
    LogMessage("Game not running - attempting to launch")
    if (LaunchGame()) {
        GameRunning := true
        LogMessage("Game launched successfully")
    } else {
        LogMessage("Failed to launch game - opening configuration GUI")
        CreateConfigGUI()
    }
}

; Start monitoring game window
SetTimer(MonitorGameWindow, GameMonitorInterval)

; Set up mouse click tracking using timer
SetTimer(CheckMouseButtons, ShortDelay)  ; Check every ShortDelay

OnExit(*) => Gdip_Shutdown(pToken)
