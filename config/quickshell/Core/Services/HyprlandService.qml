import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import qs.Core
pragma Singleton

Item {
    id: hyprlandService

    property bool enableAnimations: true
    property real animationSpeedFactor: 1
    property bool nightLightActive: false
    property bool caffeineActive: false
    property bool gameModeActive: false
    property string keyboardLayout: "us"
    property bool wpAutoShuffle: false
    property int wpShuffleInterval: 10
    property bool wpEnableTransitions: true
    property string wpTransitionType: "grow"
    property string wpTransitionPos: "center"
    property int wpTransitionStep: 120
    property int wpTransitionFps: 60
    property int wpTransitionAngle: 30
    property bool hyprBlur: true
    property int hyprRounding: 16
    property int hyprActiveOpacity: 100
    property int hyprInactiveOpacity: 100
    property int hyprBlurSize: 6
    property int hyprBlurPasses: 4
    property int hyprGapsIn: 4
    property int hyprGapsOut: 8

    function applyNightLight(state) {
        if (state) {
            nightLightProc.command = ["hyprsunset", "-t", "4500"];
            nightLightProc.running = false;
            nightLightProc.running = true;
        } else {
            nightLightProc.running = false;
            pkillSunsetProc.running = false;
            pkillSunsetProc.running = true;
        }
    }

    function applyCaffeine(state) {
        caffeineProc.running = false;
        if (state)
            caffeineProc.running = true;

    }

    function applyHyprlandSettings() {
        applySettingsTimer.restart();
    }

    function setAnimationsEnabled(enabled, blur, dropShadow, rounding) {
        animationsProc.running = false;
        let luaStr = "hl.config({ animations = { enabled = " + (enabled ? "true" : "false") + " }, decoration = { blur = { enabled = " + (blur == "1" ? "true" : "false") + " }, shadow = { enabled = " + (dropShadow == "1" ? "true" : "false") + " }, rounding = " + rounding + " } })";
        animationsProc.command = ["hyprctl", "eval", luaStr];
        animationsProc.running = true;
    }

    function startupAnimations() {
        animationsProc.running = false;
        animationsProc.command = ["hyprctl", "eval", "hl.config({ animations = { enabled = " + (enableAnimations ? "true" : "false") + " } })"];
        animationsProc.running = true;
        applyHyprlandSettings();
    }

    function triggerStartupTimer() {
        startupApplyTimer.start();
    }

    onEnableAnimationsChanged: {
        if (SettingsService.settingsLoaded) {
            SettingsService.saveSettings();
            animationsProc.running = false;
            animationsProc.command = ["hyprctl", "eval", "hl.config({ animations = { enabled = " + (enableAnimations ? "true" : "false") + " } })"];
            animationsProc.running = true;
        }
    }
    onNightLightActiveChanged: {
        if (SettingsService.settingsLoaded)
            SettingsService.saveSettings();

        applyNightLight(nightLightActive);
    }
    onCaffeineActiveChanged: {
        if (SettingsService.settingsLoaded)
            SettingsService.saveSettings();

        applyCaffeine(caffeineActive);
    }
    onGameModeActiveChanged: {
        if (SettingsService.settingsLoaded)
            SettingsService.saveSettings();

        if (gameModeActive) {
            hyprlandService.enableAnimations = false;
            hyprlandService.hyprBlur = false;
            hyprlandService.caffeineActive = true;
        } else {
            hyprlandService.enableAnimations = true;
            hyprlandService.hyprBlur = true;
            hyprlandService.caffeineActive = false;
        }
    }
    onAnimationSpeedFactorChanged: {
        if (SettingsService.settingsLoaded)
            SettingsService.saveSettings();

    }
    onWpAutoShuffleChanged: {
        if (SettingsService.settingsLoaded)
            SettingsService.saveSettings();

    }
    onWpShuffleIntervalChanged: {
        if (SettingsService.settingsLoaded)
            SettingsService.saveSettings();

    }
    onWpEnableTransitionsChanged: {
        if (SettingsService.settingsLoaded)
            SettingsService.saveSettings();

    }
    onWpTransitionTypeChanged: {
        if (SettingsService.settingsLoaded)
            SettingsService.saveSettings();

    }
    onWpTransitionPosChanged: {
        if (SettingsService.settingsLoaded)
            SettingsService.saveSettings();

    }
    onWpTransitionStepChanged: {
        if (SettingsService.settingsLoaded)
            SettingsService.saveSettings();

    }
    onWpTransitionFpsChanged: {
        if (SettingsService.settingsLoaded)
            SettingsService.saveSettings();

    }
    onWpTransitionAngleChanged: {
        if (SettingsService.settingsLoaded)
            SettingsService.saveSettings();

    }
    onKeyboardLayoutChanged: {
        if (SettingsService.settingsLoaded) {
            SettingsService.saveSettings();
            changeLayoutProc.command = ["hyprctl", "eval", "hl.config({ input = { kb_layout = '" + keyboardLayout + "' } })"];
            changeLayoutProc.running = false;
            changeLayoutProc.running = true;
        }
    }
    onHyprBlurChanged: {
        if (SettingsService.settingsLoaded) {
            SettingsService.saveSettings();
            applyHyprlandSettings();
        }
    }
    onHyprRoundingChanged: {
        if (SettingsService.settingsLoaded) {
            SettingsService.saveSettings();
            applyHyprlandSettings();
        }
    }
    onHyprActiveOpacityChanged: {
        if (SettingsService.settingsLoaded) {
            SettingsService.saveSettings();
            applyHyprlandSettings();
        }
    }
    onHyprInactiveOpacityChanged: {
        if (SettingsService.settingsLoaded) {
            SettingsService.saveSettings();
            applyHyprlandSettings();
        }
    }
    onHyprBlurSizeChanged: {
        if (SettingsService.settingsLoaded) {
            SettingsService.saveSettings();
            applyHyprlandSettings();
        }
    }
    onHyprBlurPassesChanged: {
        if (SettingsService.settingsLoaded) {
            SettingsService.saveSettings();
            applyHyprlandSettings();
        }
    }
    onHyprGapsInChanged: {
        if (SettingsService.settingsLoaded) {
            SettingsService.saveSettings();
            applyHyprlandSettings();
        }
    }
    onHyprGapsOutChanged: {
        if (SettingsService.settingsLoaded) {
            SettingsService.saveSettings();
            applyHyprlandSettings();
        }
    }

    Timer {
        id: applySettingsTimer

        interval: 50
        repeat: false
        onTriggered: {
            let ao = (hyprActiveOpacity / 100).toFixed(2);
            let io = (hyprInactiveOpacity / 100).toFixed(2);
            let luaStr = "hl.config({ decoration = { blur = { enabled = " + (hyprBlur ? "true" : "false") + ", size = " + hyprBlurSize + ", passes = " + hyprBlurPasses + " }, rounding = " + hyprRounding + ", active_opacity = " + ao + ", inactive_opacity = " + io + " }, general = { gaps_in = " + hyprGapsIn + ", gaps_out = " + hyprGapsOut + " } })";
            setHyprlandOptionProc.command = ["sh", "-c", "hyprctl eval '" + luaStr + "'"];
            setHyprlandOptionProc.running = false;
            setHyprlandOptionProc.running = true;
            patchUserPrefsProc.command = ["sh", "-c", "sed -i 's/active_opacity = [0-9.]*/active_opacity = " + ao + "/' ~/.config/hypr/userprefs.lua && " + "sed -i 's/inactive_opacity = [0-9.]*/inactive_opacity = " + io + "/' ~/.config/hypr/userprefs.lua"];
            patchUserPrefsProc.running = false;
            patchUserPrefsProc.running = true;
        }
    }

    Timer {
        id: startupApplyTimer

        interval: 1000
        running: false
        repeat: false
        onTriggered: {
            startupAnimations();
            changeLayoutProc.command = ["hyprctl", "eval", "hl.config({ input = { kb_layout = '" + hyprlandService.keyboardLayout + "' } })"];
            changeLayoutProc.running = false;
            changeLayoutProc.running = true;
        }
    }

    Process {
        id: animationsProc
    }

    Process {
        id: changeLayoutProc
    }

    Process {
        id: nightLightProc
    }

    Process {
        id: pkillSunsetProc

        command: ["pkill", "hyprsunset"]
    }

    Process {
        id: caffeineProc

        command: ["systemd-inhibit", "--what=idle", "--who=quickshell", "--why=Keep screen active", "--mode=block", "sleep", "infinity"]
    }

    Process {
        id: setHyprlandOptionProc
    }

    Process {
        id: patchUserPrefsProc
    }

    Connections {
        function onRawEvent(event) {
            if (event.name === "activelayout")
                activeLayoutProc.running = true;

        }

        target: Hyprland
    }

    Process {
        id: activeLayoutProc

        command: ["sh", "-c", "hyprctl devices -j | jq -r '.keyboards[] | select(.main == true) | .active_keymap'"]

        stdout: SplitParser {
            onRead: (data) => {
                if (!data)
                    return ;

                let raw = data.trim();
                let code = "us";
                if (raw.includes("Spanish"))
                    code = "latam";
                else if (raw.includes("English"))
                    code = "us";
                else
                    code = raw;
                if (hyprlandService.keyboardLayout !== code)
                    hyprlandService.keyboardLayout = code;

            }
        }

    }

}
