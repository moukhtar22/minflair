import QtQuick
import Quickshell
import Quickshell.Io
import qs.Core.Services
pragma Singleton

QtObject {
    id: root

    property var themes: [{
        "name": "Default",
        "dark": {
            "name": "Default",
            "bg": '#030107',
            "bgSecondary": '#110b1a',
            "fg": '#d1d1d1',
            "muted": '#6a6c7e',
            "border": '#484d6980',
            "accent": '#a77ef5',
            "accentComplementary": '#f57eb6',
            "shadow": '#000000'
        },
        "light": {
            "name": "Default Light",
            "bg": '#e8dbff',
            "bgSecondary": '#d2bdf7',
            "fg": '#1e1a2e',
            "muted": '#6b6489',
            "border": '#6b648980',
            "accent": '#7040e8',
            "accentComplementary": '#e840a1',
            "shadow": '#000000'
        }
    }]
    property string currentScheme: "Default"
    property real bgOpacity: 1
    property color _rawBg: themes[0].dark.bg
    property color opaqueBg: _rawBg
    property color bg: Qt.rgba(_rawBg.r, _rawBg.g, _rawBg.b, bgOpacity)
    property color bgSecondary: Qt.rgba(accent.r, accent.g, accent.b, 0.05)
    property color bgTertiary: Qt.rgba(accent.r, accent.g, accent.b, 0.1)
    property color fg: themes[0].dark.fg
    property color muted: themes[0].dark.muted
    property color border: themes[0].dark.border
    property color accent: themes[0].dark.accent
    property color accentComplementary: themes[0].dark.accentComplementary
    property color _rawShadow: themes[0].dark.shadow
    property color shadow: Qt.rgba(_rawShadow.r, _rawShadow.g, _rawShadow.b, 0.45)
    property bool generateFromWallpaper: false
    property var wallpaperColors: null
    property Process saver
    property Process loader
    property Process wallpaperLoader
    property Process generatorProc
    property Process applyThemeProc
    property Connections wpConn

    signal themeApplied()

    function applyScheme(scheme) {
        currentScheme = scheme.name;
        _rawBg = scheme.bg;
        fg = scheme.fg;
        muted = scheme.muted;
        border = scheme.border || scheme.bg;
        accent = scheme.accent;
        accentComplementary = scheme.accentComplementary;
        _rawShadow = scheme.shadow || "#000000";
        saveScheme();
    }

    function saveScheme() {
        let obj = {
            "name": currentScheme,
            "generateFromWallpaper": generateFromWallpaper,
            "bgOpacity": bgOpacity,
            "bg": "" + _rawBg,
            "fg": "" + fg,
            "muted": "" + muted,
            "border": "" + border,
            "accent": "" + accent,
            "accentComplementary": "" + accentComplementary,
            "shadow": "" + _rawShadow
        };
        let json = JSON.stringify(obj);
        let home = Quickshell.env("HOME");
        saver.running = false;
        saver.command = ["bash", "-c", "mkdir -p '" + home + "/.cache/quickshell' && echo '" + json + "' > '" + home + "/.cache/quickshell/colorscheme.json'"];
        saver.running = true;
    }

    function generateTheme(wallpaperPath) {
        let home = Quickshell.env("HOME");
        generatorProc.running = false;
        generatorProc.command = ["python3", home + "/.config/quickshell/Scripts/generate_theme.py", wallpaperPath, generateFromWallpaper ? "True" : "False"];
        generatorProc.running = true;
    }

    function loadScheme() {
        loader.running = false;
        loader.running = true;
        wallpaperLoader.running = false;
        wallpaperLoader.running = true;
    }

    Component.onCompleted: loadScheme()

    wpConn: Connections {
        function onCurrentWallpaperPathChanged() {
            if (root.generateFromWallpaper && WallpaperManager.currentWallpaperPath !== "")
                root.generateTheme(WallpaperManager.currentWallpaperPath);

        }

        target: WallpaperManager
    }

    generatorProc: Process {
        id: generatorProc

        onExited: function(exitCode) {
            if (exitCode === 0) {
                let output = generatorOutput.text;
                let colorsLine = "";
                let lines = output.split("\n");
                for (let i = 0; i < lines.length; i++) {
                    if (lines[i].startsWith("COLORS:")) {
                        colorsLine = lines[i].substring(7);
                        break;
                    }
                }
                if (colorsLine) {
                    try {
                        let colors = JSON.parse(colorsLine);
                        let scheme = {
                            "name": colors.name || "Wallpaper Theme",
                            "bg": colors.bg,
                            "fg": colors.fg,
                            "muted": colors.muted,
                            "border": colors.border,
                            "accent": colors.accent,
                            "accentComplementary": colors.accentComplementary,
                            "shadow": colors.shadow || "#000000"
                        };
                        root.wallpaperColors = colors;
                        if (root.generateFromWallpaper)
                            root.applyScheme(scheme);

                    } catch (e) {
                        root.loadScheme();
                    }
                } else {
                    root.loadScheme();
                }
            }
        }

        stderr: StdioCollector {
            id: generatorError
        }

        stdout: StdioCollector {
            id: generatorOutput
        }

    }

    saver: Process {
        onExited: function(exitCode) {
            if (exitCode === 0) {
                applyThemeProc.running = false;
                applyThemeProc.command = ["python3", Quickshell.env("HOME") + "/.config/quickshell/Scripts/apply_theme.py"];
                applyThemeProc.running = true;
            }
        }
    }

    loader: Process {
        command: ["cat", Quickshell.env("HOME") + "/.cache/quickshell/colorscheme.json"]
        onExited: function(exitCode) {
            if (exitCode === 0) {
                try {
                    let colors = JSON.parse(loaderOutput.text);
                    if (colors.generateFromWallpaper !== undefined)
                        root.generateFromWallpaper = colors.generateFromWallpaper;

                    if (colors.name)
                        root.currentScheme = colors.name;

                    if (colors.bgOpacity !== undefined)
                        root.bgOpacity = colors.bgOpacity;

                    if (colors.bg)
                        root._rawBg = colors.bg;

                    if (colors.fg)
                        root.fg = colors.fg;

                    if (colors.muted)
                        root.muted = colors.muted;

                    if (colors.border)
                        root.border = colors.border;

                    if (colors.accent)
                        root.accent = colors.accent;

                    if (colors.accentComplementary)
                        root.accentComplementary = colors.accentComplementary;

                    if (colors.shadow)
                        root._rawShadow = colors.shadow;

                    applyThemeProc.running = false;
                    applyThemeProc.command = ["python3", Quickshell.env("HOME") + "/.config/quickshell/Scripts/apply_theme.py"];
                    applyThemeProc.running = true;
                } catch (e) {
                    root.applyScheme(root.themes[0].dark);
                }
            } else {
                root.applyScheme(root.themes[0].dark);
            }
        }

        stdout: StdioCollector {
            id: loaderOutput
        }

    }

    wallpaperLoader: Process {
        command: ["cat", Quickshell.env("HOME") + "/.cache/quickshell/wallpaper_colorscheme.json"]
        onExited: function(exitCode) {
            if (exitCode === 0) {
                try {
                    root.wallpaperColors = JSON.parse(wallpaperLoaderOutput.text);
                } catch (e) {
                }
            }
        }

        stdout: StdioCollector {
            id: wallpaperLoaderOutput
        }

    }

    applyThemeProc: Process {
        onExited: function(exitCode) {
            if (exitCode === 0)
                root.themeApplied();

        }
    }

}
