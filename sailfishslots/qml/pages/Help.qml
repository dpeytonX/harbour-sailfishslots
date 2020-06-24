import QtQuick 2.2
import Sailfish.Silica 1.0
import harbour.sailfishslots.SailfishWidgets.Components 3.3
import harbour.sailfishslots.SailfishSlots 1.0

OrientationDialog {

    SilicaFlickable {
        id: aboutTaskList
        anchors.fill: parent
        contentHeight: aboutRectangle.height
        VerticalScrollDecorator { flickable: aboutTaskList }

        PageColumn {
            id: aboutRectangle
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.leftMargin: Theme.paddingSmall
            width: parent.width
            spacing: Theme.paddingSmall

            title: qsTr("Help")

            Heading {
                text: qsTr("How to play")
            }

            Paragraph {
                text: qsTr("Use the %1 or %2 feature to start the slot reel. Using %2 will allow you to spin as long as your total coins is greater than the minimum bet.").arg(qsTr("Spin")).arg(qsTr("Auto Spin"))
            }

            Paragraph {
                text: qsTr("You may increase your bet to multiply your earnings on a winning combination. However, a high bet may also drain your coins faster.")
            }

            Paragraph {
                text: qsTr("This slot has two special modes %1 and %2. %1 will grant you free plays. %2 will also grant you free plays with an additional jackpot upon completion.").arg(qsTr("Free Spin")).arg(qsTr("Bonus"))
            }

            Heading {
                text: qsTr("Winning Combinations")
            }

            Grid {
                columns: 1
                spacing: Theme.paddingSmall

                InformationalLabel {
                    text: qsTr("Three of a kind")
                }

                InformationalLabel {
                    text: qsTr("Two of a kind and %1 symbol").arg(UIConstants.symbols[UIConstants.wildIndex])
                }

                InformationalLabel {
                    text: qsTr("One of a kind and two %1 symbols").arg(UIConstants.symbols[UIConstants.wildIndex])
                }
            }

            Heading {
                text: qsTr("Bonus")
            }

            InformationalLabel {
                text: qsTr("Any combination of %1 and %2").arg(UIConstants.symbols[UIConstants.sevenIndex]).arg(UIConstants.symbols[UIConstants.wildIndex])
            }

            Heading {
                text: qsTr("Free Spin")
            }

            InformationalLabel {
                text: qsTr("At least one %1 present").arg(UIConstants.symbols[UIConstants.freeSpinIndex])
            }
        }
    }
}
