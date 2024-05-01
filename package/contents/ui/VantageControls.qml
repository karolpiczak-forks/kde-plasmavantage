import QtQuick

ListModel {
    ListElement {
        name: "Fn lock"
        desc: "Access multimedia keys without holding Fn"
        tip: "When enabled, the multimedia functions will be accessible without having to hold the Fn key."
        pIcon: "fnlock"
        param: "fn_lock"
        module: "ideapad"
        reboot: false
        busy: false
        value: -1
    }
    ListElement {
        name: "Super key"
        desc: "Enables the Super/Windows key"
        tip: "Whether to enable or not the Super (Windows) key."
        pIcon: "superkey"
        param: "winkey"
        module: "legion"
        reboot: false
        busy: false
        value: -1
    }
    ListElement {
        name: "Touchpad"
        desc: "Enables the laptop's touchpad"
        tip: "Whether to enable or not the laptop's touchpad."
        pIcon: "touchpad"
        param: "touchpad"
        module: "legion"
        reboot: false
        busy: false
        value: -1
    }
    ListElement {
        name: "Battery conservation mode"
        desc: "Limits the charge of the battery to extend its lifespan"
        tip: "When enabled, the battery will not charge above a certain value (usually around 50-70%) in order to extend its lifespan."
        pIcon: "batsave"
        param: "conservation_mode"
        module: "ideapad"
        reboot: false
        busy: false
        value: -1
    }
    ListElement {
        name: "Battery fast charge mode"
        desc: "Allows the battery to charge faster"
        tip: "When enabled, allows the battery to charge faster at the cost of its lifespan."
        pIcon: "fastcharge"
        param: "rapidcharge"
        module: "legion"
        reboot: false
        busy: false
        value: -1
    }
    ListElement {
        name: "Always On USB"
        desc: "Keeps the USB ports always powered on"
        tip: "Keeps the USB ports powered on even if the laptop is suspended."
        pIcon: "usbcharging"
        param: "usb_charging"
        module: "ideapad"
        reboot: false
        busy: false
        value: -1
    }
    ListElement {
        name: "Display Overdrive"
        desc: "Reduces the laptop's display latency"
        tip: "Reduces the display latency in order to limit ghosting and trailing images.\nIncreases power consumption and may introduce other graphical defects."
        pIcon: "overdrive"
        param: "overdrive"
        module: "legion"
        reboot: false
        busy: false
        value: -1
    }
    ListElement {
        name: "Hybrid graphics mode"
        desc: "Enables the laptop's integrated graphics"
        tip: "Enables the processor's integrated graphics.\nDecreases power consumption by allowing the dedicated GPU to power down and work only when necessary but slighty decreases performance.\nReboot is required to apply the change."
        pIcon: "hybrid"
        param: "gsync"
        module: "legion"
        reboot: true
        busy: false
        value: -1
    }
}

