/*import QtQuick

import org.kde.plasma.plasma5support as Plasma5Support

Plasma5Support.DataSource {
    id: executable
    property var model

    engine: "executable"
    connectedSources: []

    onNewData: (cmd, data) => {
        const stdout = data["stdout"]
        const stderr = data["stderr"]

        console.log(cmd)
        console.log(model)
        console.log("OUT: " + stdout)
        console.log("ERR: " + stderr)
        console.log("###")

        disconnectSource(cmd)
    }

    function exec(cmd, nmodel) {
        model = nmodel
        if (cmd) connectSource(cmd)
    }
}
*/
