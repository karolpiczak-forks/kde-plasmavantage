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

    enum ControlType {
        Readonly,
        Toggle
    }

    property var vantageControls: [{
        "name" : "Fn lock",
        "param" : "fn_lock",
        "type" : VantageManager.Toggle,
        "module" : ideapadMod,
        "value" : -1,
    },{
        "name" : "Super key",
        "param" : "winkey",
        "type" : VantageManager.Toggle,
        "module" : legionMod,
        "value" : -1,
    },{
        "name" : "Touchpad",
        "param" : "touchpad",
        "type" : VantageManager.Toggle,
        "module" : legionMod,
        "value" : -1,
    },{
        "name" : "Battery conservation mode",
        "param" : "conservation_mode",
        "type" : VantageManager.Toggle,
        "module" : ideapadMod,
        "value" : -1,
    },{
        "name" : "Rapid charge mode",
        "param" : "rapidcharge",
        "type" : VantageManager.Toggle,
        "module" : legionMod,
        "value" : -1,
    },{
        "name" : "USB always ON",
        "param" : "usb_charging",
        "type" : VantageManager.Toggle,
        "module" : ideapadMod,
        "value" : -1,
    },{
        "name" : "Display overdrive",
        "param" : "overdrive",
        "type" : VantageManager.Toggle,
        "module" : legionMod,
        "value" : -1,
    },{
        "name" : "Hybrid graphics",
        "param" : "gsync",
        "type" : VantageManager.Toggle,
        "module" : legionMod,
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
