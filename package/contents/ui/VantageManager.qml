import QtQuick

import org.kde.plasma.private.sessions
import org.kde.plasma.plasma5support as Plasma5Support

// "/sys/module/legion_laptop/drivers/platform:legion/PNP0C09:00/"
// "/sys/module/ideapad_laptop/drivers/platform:ideapad_acpi/VPC2004:00/)"
// "/sys/class/leds/platform::ylogo/brightness"

Item {
    readonly property string sudoPrefix: "pkexec sh -c "
    readonly property string ideapadModPath: "/sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/"
    readonly property string legionModPath: "/sys/bus/platform/drivers/legion/PNP0C09:00/"
    readonly property string ylogoLedPath: "/sys/class/leds/platform::ylogo/brightness/"
    readonly property string ioportLedPath: "/sys/class/leds/platform::ioport/brightness/"

    SessionManagement {
        id: session
    }

    function initialize() {
        alog("Initialization...")
        for (let i=0; i < vantageModel; i++) {
            let control = vantageModel.get(i)
            readParam(control.module, control.param)
        }
    }

    function readParam(module, param) {
        alog("Read request: Module=" + module + ", Param=" + param)
        let sysfsPath
        if (module == "legion") sysfsPath = legionModPath
        else if (module == "ideapad") sysfsPath = ideapadModPath
        else return
        executable.exec("cat " + sysfsPath + param)
    }

    function toggleParam(module, param, value) {
        alog("Toggle request: Module=" + module + ", Param=" + param + ", Value=" + value)
        let sysfsPath
        if (module == "legion") sysfsPath = legionModPath
        else if (module == "ideapad") sysfsPath = ideapadModPath
        else return
        executable.exec("LANG=C echo "+ value + " > " + sysfsPath + param, false)
    }

    // TODO: Give each control its own Datasource object
    Plasma5Support.DataSource {
        id: executable

        engine: "executable"
        connectedSources: []

        onNewData: (cmd, data) => {
            const stdout = data["stdout"]
            const stderr = data["stderr"]

            alog("Exec: " + cmd)
            if (stderr) alog("ERROR: " + stderr)

            disconnectSource(cmd)

            let index
            for (index = 0; index < vantageModel.count; index++) {
                if (cmd.includes(vantageModel.get(index).param)) break
            }

            if (index >= vantageModel.count) return

            let control = vantageModel.get(index)
            if (cmd.startsWith("cat") && !stderr) {
                let newValue = parseInt(stdout)
                if (newValue == 0 || newValue == 1 && control.value != newValue) {
                    alog("Element update: " + control.param + " from " + control.value + " to " + newValue)
                    control.value = newValue
                }
            }
            else if (cmd.includes("echo")) {
                if (stderr.includes("Permission")) {
                    alog("Permission denied, retrying as root...")
                    exec(cmd, true)
                    return
                }
                else if (!stderr) {
                    ready(control.param, control.reboot)
                    // Read again after successful writing
                    readParam(control.module, control.param)
                }
                else {
                    ready(control.param, false)
                }
            }
        }

        function exec(cmd, root) {
            if (!root) connectSource(cmd)
            else connectSource(sudoPrefix + '"' + cmd + '"')
        }

    }

    function updateModel() {
        alog("Model update...")
        for (let i = 0; i < vantageModel.count; i++) {
            let control = vantageModel.get(i)
            readParam(control.module, control.param)
        }
    }

    function reboot() {
        session["requestReboot"](0)
    }

    function alog(msg) {
        console.log("PlasmaVantage: " + msg)
    }

    signal ready(string param, bool rebootFlag)
}
