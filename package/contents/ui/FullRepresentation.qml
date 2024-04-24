import QtQuick 2.15
import QtQuick.Layouts 1.15

import org.kde.plasma.plasmoid
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.extras as PlasmaExtras
import org.kde.kirigami 2.20 as Kirigami
import org.kde.notification

Item {
    GridView {
        id: grid
        anchors.fill: parent
        model: vantageModel

        highlight: PlasmaExtras.Highlight {}
        highlightFollowsCurrentItem: true
        currentIndex: -1

        cellWidth: 150
        cellHeight: 100

        focus: true
        delegate: PlasmaComponents.ItemDelegate {
            width: grid.cellWidth
            height: grid.cellHeight
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: Kirigami.Units.smallSpacing
                spacing: Kirigami.Units.smallSpacing
                Kirigami.Icon {
                    Layout.fillWidth: true
                    opacity: 1
                    source: plasmoid.icon
                    color: Kirigami.Theme.colorSet
                    smooth: true
                    isMask: true
                }
                PlasmaComponents.Label {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    horizontalAlignment: Text.AlignHCenter
                    text: name
                    //elide: Text.ElideRight
                    wrapMode: Text.WordWrap
                }
                PlasmaComponents.Switch {
                    Layout.alignment: Qt.AlignHCenter
                    checked: value
                    onToggled: {
                        vantageMgr.toggleParam(module, param, 1-value)
                        checked = Qt.binding(() => value)
                    }
                }
            }
        }
    }

    Connections {
        target: vantageMgr

        function onParamUpdate(index, value) {
            console.log("SIGNAL : " + index + " / " + value)
            vantageModel.setProperty(index, "value", value)
        }
    }
}
