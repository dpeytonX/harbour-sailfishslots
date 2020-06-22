import QtQuick 2.1
import Sailfish.Silica 1.0
import harbour.sailfishslots.SailfishWidgets.Components 3.4
import harbour.sailfishslots.SailfishWidgets.JS 3.4
import harbour.sailfishslots.SailfishSlots 1.0
import "../../harbour/sailfishslots/QmlLogger/Logger.js" as Console

StandardCover {
    property variant app
    label.font.pixelSize: Theme.fontSizeSmall

    displayDefault: false
    coverTitle: qsTr("Sailfish Slots")


    Column {
        anchors.fill: parent
        anchors.top: parent.top
        anchors.topMargin: Theme.paddingLarge
        anchors.leftMargin: Theme.paddingMedium
        InformationalLabel {
            id: infoColumn
            text:  app.coins + "  " + qsTr("Coins")
        }
/*
        InformationalLabel {
            id: winColumn
            text:  (app.wonCoins == "" ? 0 : app.wonCoins) + "  " + (app.wonCoins < 0 ? qsTr("Bet") : qsTr("Won"))
        }*/

        TextField {
            text: app.reelSym1
            font.pixelSize: parent.width / 6
            x: (parent.width - width) / 2
        }

        TextField {
            text: app.reelSym2
            font.pixelSize: parent.width / 6
            x: (parent.width - width) / 2
        }

        TextField {
            text: app.reelSym3
            font.pixelSize: parent.width / 6
            x: (parent.width - width) / 2
        }
    }
}
