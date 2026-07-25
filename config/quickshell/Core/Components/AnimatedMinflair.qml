import QtQuick
import QtQuick.Shapes
import qs.Core
import qs.Core.Services

Item {
    id: root

    property int iconSize: 32
    property color iconColor: Theme.fg
    property bool extraAnimated: false
    property string starPath: "M 12 2 C 14 8, 15 12, 22 12 C 16 14, 12 15, 12 22 C 10 16, 9 12, 2 12 C 8 10, 12 9, 12 2 Z"

    width: iconSize
    height: iconSize
    implicitWidth: iconSize
    implicitHeight: iconSize

    Item {
        width: 24
        height: 24
        scale: root.iconSize / 24
        anchors.centerIn: parent
        enabled: false

        Shape {
            id: mainStarShape

            width: 24
            height: 24
            transformOrigin: Item.Center
            preferredRendererType: Shape.CurveRenderer

            ShapePath {
                fillColor: root.iconColor
                strokeColor: "transparent"

                PathSvg {
                    path: root.starPath
                }

            }

        }

        Shape {
            id: cyanStarShape

            width: 24
            height: 24
            x: 7
            y: -7
            scale: 0.4
            transformOrigin: Item.Center
            opacity: 0
            preferredRendererType: Shape.CurveRenderer

            ShapePath {
                strokeColor: "transparent"

                PathSvg {
                    path: root.starPath
                }

                fillGradient: LinearGradient {
                    x1: 0
                    y1: 0
                    x2: 24
                    y2: 24

                    GradientStop {
                        position: 0
                        color: Theme.accent
                    }

                    GradientStop {
                        position: 1
                        color: Theme.accentComplementary
                    }

                }

            }

        }

        Shape {
            id: tinyStarShape

            width: 24
            height: 24
            x: -6
            y: 6
            scale: 0.2
            transformOrigin: Item.Center
            opacity: 0
            preferredRendererType: Shape.CurveRenderer

            ShapePath {
                fillColor: root.iconColor
                strokeColor: "transparent"

                PathSvg {
                    path: root.starPath
                }

            }

        }

        SequentialAnimation {
            loops: Animation.Infinite
            running: HyprlandService.enableAnimations

            NumberAnimation {
                target: cyanStarShape
                property: "opacity"
                from: 0
                to: 1
                duration: 600
                easing.type: Easing.InOutSine
            }

            NumberAnimation {
                target: cyanStarShape
                property: "opacity"
                from: 1
                to: 0
                duration: 600
                easing.type: Easing.InOutSine
            }

            NumberAnimation {
                target: tinyStarShape
                property: "opacity"
                from: 0
                to: 1
                duration: 700
                easing.type: Easing.InOutSine
            }

            NumberAnimation {
                target: tinyStarShape
                property: "opacity"
                from: 1
                to: 0
                duration: 700
                easing.type: Easing.InOutSine
            }

        }

        SequentialAnimation {
            id: introAnim

            running: HyprlandService.enableAnimations

            ParallelAnimation {
                NumberAnimation {
                    target: mainStarShape
                    property: "scale"
                    from: 0
                    to: 1.2
                    duration: 800
                    easing.type: Easing.OutQuart
                }

                NumberAnimation {
                    target: mainStarShape
                    property: "rotation"
                    from: -180
                    to: 10
                    duration: 800
                    easing.type: Easing.OutQuart
                }

            }

            ParallelAnimation {
                NumberAnimation {
                    target: mainStarShape
                    property: "scale"
                    from: 1.2
                    to: 1
                    duration: 600
                    easing.type: Easing.OutBack
                }

                NumberAnimation {
                    target: mainStarShape
                    property: "rotation"
                    from: 10
                    to: 0
                    duration: 600
                    easing.type: Easing.OutBack
                }

            }

        }

        SequentialAnimation {
            id: extraIdleAnim

            running: HyprlandService.enableAnimations && root.extraAnimated && !introAnim.running
            loops: Animation.Infinite

            ParallelAnimation {
                SequentialAnimation {
                    loops: Animation.Infinite

                    NumberAnimation {
                        target: mainStarShape
                        property: "scale"
                        from: 1
                        to: 1.05
                        duration: 2500
                        easing.type: Easing.InOutQuad
                    }

                    NumberAnimation {
                        target: mainStarShape
                        property: "scale"
                        from: 1.05
                        to: 1
                        duration: 2500
                        easing.type: Easing.InOutQuad
                    }

                }

                SequentialAnimation {
                    loops: Animation.Infinite

                    NumberAnimation {
                        target: mainStarShape
                        property: "rotation"
                        from: 0
                        to: 3
                        duration: 2500
                        easing.type: Easing.InOutQuad
                    }

                    NumberAnimation {
                        target: mainStarShape
                        property: "rotation"
                        from: 3
                        to: 0
                        duration: 2500
                        easing.type: Easing.InOutQuad
                    }

                }

                SequentialAnimation {
                    loops: Animation.Infinite

                    NumberAnimation {
                        target: cyanStarShape
                        property: "y"
                        from: -7
                        to: -8.5
                        duration: 2000
                        easing.type: Easing.InOutQuad
                    }

                    NumberAnimation {
                        target: cyanStarShape
                        property: "y"
                        from: -8.5
                        to: -7
                        duration: 2000
                        easing.type: Easing.InOutQuad
                    }

                }

                SequentialAnimation {
                    loops: Animation.Infinite

                    NumberAnimation {
                        target: cyanStarShape
                        property: "scale"
                        from: 0.4
                        to: 0.46
                        duration: 2000
                        easing.type: Easing.InOutQuad
                    }

                    NumberAnimation {
                        target: cyanStarShape
                        property: "scale"
                        from: 0.46
                        to: 0.4
                        duration: 2000
                        easing.type: Easing.InOutQuad
                    }

                }

                SequentialAnimation {
                    loops: Animation.Infinite

                    NumberAnimation {
                        target: tinyStarShape
                        property: "y"
                        from: 6
                        to: 8
                        duration: 2800
                        easing.type: Easing.InOutQuad
                    }

                    NumberAnimation {
                        target: tinyStarShape
                        property: "y"
                        from: 8
                        to: 6
                        duration: 2800
                        easing.type: Easing.InOutQuad
                    }

                }

                SequentialAnimation {
                    loops: Animation.Infinite

                    NumberAnimation {
                        target: tinyStarShape
                        property: "scale"
                        from: 0.2
                        to: 0.22
                        duration: 2800
                        easing.type: Easing.InOutQuad
                    }

                    NumberAnimation {
                        target: tinyStarShape
                        property: "scale"
                        from: 0.22
                        to: 0.2
                        duration: 2800
                        easing.type: Easing.InOutQuad
                    }

                }

            }

        }

    }

}
