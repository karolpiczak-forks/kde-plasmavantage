import QtQuick
import QtQuick.Layouts

import org.kde.plasma.plasmoid
import org.kde.kirigami as Kirigami
import org.kde.plasma.core as PlasmaCore

PlasmoidItem {
    id: root

    property var vantageModel: ListModel {}
    VantageManager { id: vantageMgr }

    compactRepresentation: CompactRepresentation {}
    fullRepresentation: FullRepresentation {}

    switchWidth: Kirigami.Units.gridUnit * 20
    switchHeight: Kirigami.Units.gridUnit * 10

    Plasmoid.icon: Qt.resolvedUrl("../../assets/plasmoid.svg")
    Plasmoid.status: PlasmaCore.Types.ActiveStatus

    //toolTipMainText: "PlasmaVantage"
    //toolTipSubText: "Take full control of your Lenovo laptop"

    Component.onCompleted: {
        vantageMgr.initialize()
    }

    onExpandedChanged: {
        if (root.expanded) vantageMgr.updateModel()
    }
}
