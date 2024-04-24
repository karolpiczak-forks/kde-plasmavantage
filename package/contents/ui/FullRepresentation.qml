import QtQuick 2.15
import QtQuick.Layouts 1.15

import org.kde.plasma.plasmoid
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.extras as PlasmaExtras
import org.kde.kirigami 2.20 as Kirigami
import org.kde.notification

PlasmaExtras.Representation {

    implicitWidth: Kirigami.Units.gridUnit * 20
    implicitHeight: mainList.height + Kirigami.Units.largeSpacing

    Layout.preferredWidth: implicitWidth
    Layout.minimumWidth: implicitWidth
    Layout.preferredHeight: implicitHeight
    Layout.maximumHeight: implicitHeight
    Layout.minimumHeight: implicitHeight

    ListView {
        id: mainList
        model: vantageModel

        interactive: false
        spacing: Kirigami.Units.smallSpacing

        anchors.verticalCenter: parent.verticalCenter
        width: parent.width
        height: contentHeight

        focus: true
        delegate: PlasmaComponents.ItemDelegate {
            //enabled: value == 0 || value == 1
            width: parent ? parent.width : 0
            contentItem: RowLayout {
                Layout.fillWidth: true
                Kirigami.Icon {
                    scale: 0.8
                    source: Qt.resolvedUrl("../../assets/icons/" + pIcon + ".svg")
                    color: Kirigami.Theme.colorSet
                    smooth: true
                    isMask: true
                }
                /*Kirigami.Heading {
                    Layout.fillWidth: true
                    text: name
                }*/
                PlasmaComponents.Label {
                    Layout.fillWidth: true
                    text: name
                    elide: Text.ElideRight
                }

                PlasmaComponents.Switch {
                    Layout.alignment: Qt.AlignHCenter
                    checked: value
                    onToggled: {
                        console.log(Qt.resolvedUrl("../../assets/icons/" + pIcon + ".svg"))
                        //vantageMgr.toggleParam(module, param, 1-value)
                        //checked = Qt.binding(() => value)
                    }
                    HoverHandler { cursorShape: Qt.PointingHandCursor }
                }
            }
            HoverHandler { cursorShape: Qt.WhatsThisCursor}
            PlasmaComponents.ToolTip { text: desc }
        }
    }
}
