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

    readonly property var vantageControls: [{
        "name" : i18n("Fn lock"),
        "desc" : i18n("Access multimedia keys without holding Fn"),
        "tip" : i18n("When enabled, the multimedia functions will be accessible without having to hold the Fn key."),
        "pIcon" : "fnlock",
        "param" : "fn_lock",
        "module" : "ideapad"
    },{
        "name" : i18n("Super key"),
        "desc" : i18n("Enables the Super/Windows key"),
        "tip" : i18n("Whether to enable or not the Super (Windows) key."),
        "pIcon" : "superkey",
        "param" : "winkey",
        "module" : "legion"
    },{
        "name" : i18n("Touchpad"),
        "desc" : i18n("Enables the laptop's touchpad"),
        "tip" : i18n("Whether to enable or not the laptop's touchpad."),
        "pIcon" : "touchpad",
        "param" : "touchpad",
        "module" : "legion"
    },{
        "name" : i18n("Battery conservation mode"),
        "desc" : i18n("Limits the charge of the battery to extend its lifespan"),
        "tip" : i18n("When enabled, the battery will not charge above a certain value (usually around 50-70%) in order to extend its lifespan."),
        "pIcon" : "batsave",
        "param" : "conservation_mode",
        "module" : "ideapad"
    },{
        "name" : i18n("Battery fast charge mode"),
        "desc" : i18n("Allows the battery to charge faster"),
        "tip" : i18n("When enabled, allows the battery to charge faster at the cost of its lifespan."),
        "pIcon" : "fastcharge",
        "param" : "rapidcharge",
        "module" : "legion"
    },{
        "name" : i18n("Always On USB"),
        "desc" : i18n("Keeps the USB ports always powered on"),
        "tip" : i18n("Keeps the USB ports powered on even if the laptop is suspended."),
        "pIcon" : "usbcharging",
        "param" : "usb_charging",
        "module" : "ideapad"
    },{
        "name" : i18n("Display Overdrive"),
        "desc" : i18n("Reduces the laptop's display latency"),
        "tip" : i18n("Reduces the display latency in order to limit ghosting and trailing images.\nIncreases power consumption and may introduce other graphical defects."),
        "pIcon" : "overdrive",
        "param" : "overdrive",
        "module" : "legion"
    },{
        "name" : i18n("Hybrid graphics mode"),
        "desc" : i18n("Enables the laptop's integrated graphics"),
        "tip" : i18n("Enables the processor's integrated graphics.\nDecreases power consumption by allowing the dedicated GPU to power down and work only when necessary but slighty decreases performance.\nReboot is required to apply the change."),
        "pIcon" : "hybrid",
        "param" : "gsync",
        "module" : "legion",
        "reboot" : true
    }]

    SessionManagement {
        id: session
    }

    function initialize() {
        // TODO: Check for module path existing and skip if they aren't loaded'
        alog("Initialization...")
        for (let c of vantageControls) {
            vantageModel.append({
                "name" : c.name,
                "desc" : c.desc,
                "tip" : c.tip,
                "pIcon" : c.pIcon,
                "param" : c.param,
                "module" : c.module,
                "reboot" : "reboot" in c ? c.reboot : false,
                "busy" : false,
                "value" : -1,
            })
            readParam(c.module, c.param)
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
                control.busy = false
            }
            else if (cmd.includes("echo")) {
                if (stderr.includes("Permission")) {
                    alog("Permission denied, retrying as root...")
                    exec(cmd, true)
                    return
                }
                else if (!stderr) {
                    readParam(control.module, control.param)
                    ready(control.param, true)
                }
                else {
                    control.busy = false
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

    signal ready(string param, bool success)
}
