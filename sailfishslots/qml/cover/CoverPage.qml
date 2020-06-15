import QtQuick 2.1
import Sailfish.Silica 1.0
import harbour.sailfishslots.SailfishWidgets.Components 3.3
import harbour.sailfishslots.SailfishSlots 1.0

StandardCover {
    property string tip: ""
    property string total: ""
    label.font.pixelSize: Theme.fontSizeSmall


    coverTitle: qsTr("Sailfish Slots")
    //displayDefault: !info.visible
    imageSource: UIConstants.coverIcon

    Item {
        anchors.fill: parent
        anchors.top: parent.top
        anchors.topMargin: Theme.paddingLarge

        /*CalculationView {
            anchors.fill: parent
            anchors.left: parent.left
            anchors.leftMargin: Theme.paddingLarge
            finalText: total
            finalTitle: qsTr("Total")
            id: info
            tipText: tip
            tipTitle: qsTr("Tip")
            visible: !!tip && tip > 0 && !!total && total > 0
        }*/
    }

    Component.onCompleted: image.opacity = 1
}
