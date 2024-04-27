import QtQuick 2.15
import QtQuick.Layouts 1.15

import org.kde.plasma.plasmoid
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.extras as PlasmaExtras
import org.kde.kirigami 2.20 as Kirigami
import org.kde.notification

PlasmaExtras.Representation {
    id: fullRep

    focus: true
    collapseMarginsHint: true

    //implicitWidth: Kirigami.Units.gridUnit * 30
    //implicitHeight: listView.implicitHeight + header.height + Kirigami.Units.largeSpacing
    Layout.preferredWidth: Kirigami.Units.gridUnit * 30
    Layout.preferredHeight: listView.implicitHeight + header.height + Kirigami.Units.largeSpacing

    header: PlasmaExtras.BasicPlasmoidHeading {}

    contentItem: PlasmaComponents.ScrollView {
        contentWidth: availableWidth - contentItem.leftMargin - contentItem.rightMargin
        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
        ListView {
            id: listView
            model: vantageModel

            implicitHeight: contentHeight

            topMargin: Kirigami.Units.smallSpacing
            bottomMargin: Kirigami.Units.smallSpacing
            leftMargin: Kirigami.Units.smallSpacing
            rightMargin: Kirigami.Units.smallSpacing
            spacing: Kirigami.Units.smallSpacing

            focus: true

            delegate: PlasmaComponents.ItemDelegate {
                width: parent ? parent.width : 0
                contentItem: RowLayout {
                    Kirigami.Icon {
                        scale: 0.8
                        source: Qt.resolvedUrl("../../assets/icons/" + pIcon + ".svg")
                        color: Kirigami.Theme.colorSet
                        smooth: true
                        isMask: true
                    }
                    Column {
                        Layout.fillWidth: true
                        Kirigami.Heading {
                            width: parent.width
                            level: 3
                            text: name
                            wrapMode: Text.WordWrap
                        }
                        PlasmaExtras.DescriptiveLabel {
                            width: parent.width
                            text: desc
                            wrapMode: Text.WordWrap
                            elide: Text.ElideRight
                        }
                    }
                    PlasmaComponents.Button {
                        enabled: value === 0 || value === 1
                        contentItem: PlasmaComponents.Label {
                            font.bold: true
                            color: {
                                if (value === 0) return Kirigami.Theme.negativeTextColor
                                else if (value === 1) return Kirigami.Theme.positiveTextColor
                                else return Kirigami.Theme.disabledTextColor
                            }
                            text: {
                                if (value === 0) return "INACTIVE"
                                else if (value === 1) return "ACTIVE"
                                else return "N/A"
                            }
                        }
                        onPressed: {
                            tooltip.hide()
                            vantageMgr.toggleParam(module, param, 1-value)
                        }
                        HoverHandler { cursorShape: Qt.PointingHandCursor }
                    }
                }
                HoverHandler { cursorShape: Qt.WhatsThisCursor }
                PlasmaComponents.ToolTip {
                    id: tooltip
                    text: tip
                }
            }
        }
        Component.onCompleted: {
            console.log(listView.height)
        }
    }
}
