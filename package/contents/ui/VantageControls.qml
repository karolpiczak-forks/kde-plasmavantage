import QtQuick

ListModel {
    ListElement {
        name: "On power supply"
        cmd: "on-power-supply"
        type: 0
    }
    ListElement {
        name: "Camera power"
        cmd: "camera-power"
        type: 0
    }
    ListElement {
        name: "Touchpad"
        cmd: "touchpad"
        type: 1
    }
    ListElement {
        name: "Hybrid mode"
        cmd: "hybrid-mode"
        type: 1
    }
    ListElement {
        name: "Rapid charging"
        cmd: "rapid-charging"
        type: 1
    }
    ListElement {
        name: "Always on USB charging"
        cmd: "always-on-usb-charging"
        type: 1
    }
    ListElement {
        name: "Fn lock"
        cmd: "fnlock"
        type: 1
    }
    ListElement {
        name: "Touchpad"
        cmd: "touchpad"
        type: 1
    }
}
