import QtQuick 2.2
import Sailfish.Silica 1.0
import harbour.sailfishslots.SailfishWidgets.Components 3.4
import harbour.sailfishslots.SailfishWidgets.JS 3.4
import harbour.sailfishslots.SailfishSlots 1.0

OrientationDialog {
    property int bonus: 0
    property int freeSpin: 0
    property int jackpot: 0

    onOpened: new JsTimer.JsTimer(this, accept, UIConstants.specialStageNotificationMs).start()

    Column {
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.alignWhenCentered: true

        Label {
            id: header
            text: {
                if(jackpot > 0)
                qsTr("Big Win")
                else if(bonus) qsTr("Bonus Mode")
                else qsTr("Free Spin Mode")
            }

            font.pixelSize: Theme.fontSizeExtraLarge
        }

        Paragraph {
            text: bonus ? qsTr("Winnings will be multiplied!") : ""
        }

        InformationalLabel {
            text: {
                if(jackpot > 0) qsTr("You won %1 coins").arg(jackpot)
                else if(bonus) qsTr("%1 free spins").arg(bonus)
                else if(freeSpin) qsTr("%1 free spins").arg(freeSpin)
            }
        }
    }
}
