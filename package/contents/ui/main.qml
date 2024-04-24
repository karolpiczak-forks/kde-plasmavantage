import QtQuick
import QtQuick.Layouts

import org.kde.plasma.plasmoid
import org.kde.kirigami as Kirigami
import org.kde.plasma.core as PlasmaCore

PlasmoidItem {
    id: root

    property var vantageModel: ListModel { }
    VantageManager { id: vantageMgr }

    compactRepresentation: CompactRepresentation {}
    fullRepresentation: FullRepresentation { }

    preferredRepresentation: compactRepresentation

    Plasmoid.icon: "computer-laptop-symbolic"
    Plasmoid.status: PlasmaCore.Types.ActiveStatus

    toolTipMainText: "PlasmaVantage"
    toolTipSubText: "Take full control of your Lenovo laptop"

    Component.onCompleted: {
        vantageMgr.initialize()
    }

    onExpandedChanged: {
        if (root.expanded) vantageMgr.updateModel()
    }
}
