import QtQuick

import org.kde.plasma.private.sessions
import org.kde.plasma.plasma5support as Plasma5Support

// "/sys/module/legion_laptop/drivers/platform:legion/PNP0C09:00/"
// "/sys/module/ideapad_laptop/drivers/platform:ideapad_acpi/VPC2004:00/)"
// "/sys/class/leds/platform::ylogo/brightness"

Item {
    readonly property string sudoPrefix: "pkexec sh -c "
    readonly property string sysfsPrefix: "/sys/bus/platform/drivers/"
    readonly property string ideapadMod: "ideapad_acpi/VPC2004:00/"
    readonly property string legionMod: "legion/PNP0C09:00/"

    property var vantageControls: [{
        "name" : "Fn lock",
        "desc" : "Access multimedia keys without holding Fn",
        "tip" : "When enabled, the multimedia functions will be accessible without having to hold the Fn key.",
        "pIcon" : "fnlock",
        "param" : "fn_lock",
        "module" : ideapadMod,
        "needsReboot" : false,
        "value" : -1,
    },{
        "name" : "Super key",
        "desc" : "Enables the Super/Windows key",
        "tip" : "Whether to enable or not the Super/Windows key.",
        "pIcon" : "superkey",
        "param" : "winkey",
        "module" : legionMod,
        "needsReboot" : false,
        "value" : -1,
    },{
        "name" : "Touchpad",
        "desc" : "Enables the laptop's touchpad",
        "tip" : "Whether to enable or not the laptop's touchpad.",
        "pIcon" : "touchpad",
        "param" : "touchpad",
        "module" : legionMod,
        "needsReboot" : false,
        "value" : -1,
    },{
        "name" : "Battery conservation mode",
        "desc" : "Limits the charge of the battery to extend its lifespan",
        "tip" : "When enabled, the battery will not charge above a certain value (usually around 50-70%) in order to extend its lifespan.",
        "pIcon" : "batsave",
        "param" : "conservation_mode",
        "module" : ideapadMod,
        "needsReboot" : false,
        "value" : -1,
    },{
        "name" : "Rapid charge mode",
        "desc" : "Allows the battery to charge faster",
        "tip" : "When enabled, allows the battery to charge faster at the cost of its lifespan.",
        "pIcon" : "fastcharge",
        "param" : "rapidcharge",
        "module" : legionMod,
        "needsReboot" : false,
        "value" : -1,
    },{
        "name" : "USB always ON",
        "desc" : "Keeps the USB ports always powered on",
        "tip" : "Keeps the USB ports powered on even if the laptop is suspended.",
        "pIcon" : "usbcharging",
        "param" : "usb_charging",
        "module" : ideapadMod,
        "needsReboot" : false,
        "value" : -1,
    },{
        "name" : "Display overdrive",
        "desc" : "Reduces the laptop's display latency",
        "tip" : "Reduces the display latency in order to limit ghosting and trailing images.\nIncreases power consumption and may introduce other graphical defects.",
        "pIcon" : "overdrive",
        "param" : "overdrive",
        "module" : legionMod,
        "needsReboot" : false,
        "value" : -1,
    },{
        "name" : "Hybrid graphics mode",
        "desc" : "Enables the laptop's integrated graphics",
        "tip" : "Enables the processor's integrated graphics.\nDecreases power consumption by allowing the dedicated GPU to power down and work only when necessary but slighty decreases performance.\nReboot is required to apply the change.",
        "pIcon" : "hybrid",
        "param" : "gsync",
        "module" : legionMod,
        "needsReboot" : true,
        "value" : -1,
    }]

    SessionManagement {
        id: session
    }

    function initialize() {
        console.log("INIT")
        for (let control of vantageControls) {
            vantageModel.append(control)
            readParam(control.module, control.param)
        }
    }

    function readParam(module, param) {
        console.log("READ " + param)
        executable.exec("cat " + sysfsPrefix + module + param)
    }

    function toggleParam(module, param, value) {
        console.log("TOGGLE " + param)
        executable.exec(sudoPrefix + '"echo '+ value + " > " + sysfsPrefix + module + param + '"')
    }

    // TODO: Give each control its own Datasource object
    Plasma5Support.DataSource {
        id: executable

        engine: "executable"
        connectedSources: []

        onNewData: (cmd, data) => {
            const stdout = data["stdout"]
            const stderr = data["stderr"]

            disconnectSource(cmd)

            if (stderr) console.warn("ERROR: " + stderr)

            let index
            for (index = 0; index < vantageModel.count; index++) {
                if (cmd.includes(vantageModel.get(index).param)) break
            }

            if (index >= vantageModel.count) return

            if (cmd.startsWith("cat")) {
                let value = parseInt(stdout)
                if (value == 0 || value == 1) vantageModel.get(index).value = value
                return
            }

            readParam(vantageModel.get(index).module, vantageModel.get(index).param)
        }

        function exec(cmd) {
            if (cmd) connectSource(cmd)
        }
    }

    function updateModel() {
        console.log("UPDATE MODEL")
        for (let i = 0; i < vantageModel.count; i++) {
            let control = vantageModel.get(i)
            readParam(control.module, control.param)
        }
    }
}
