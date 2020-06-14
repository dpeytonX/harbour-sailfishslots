import QtQuick 2.2
import Sailfish.Silica 1.0
import harbour.sailfishslots.SailfishWidgets.Components 3.3
import harbour.sailfishslots.SailfishWidgets.Settings 3.3
import harbour.sailfishslots.SailfishWidgets.Utilities 3.3
import harbour.sailfishslots.SailfishSlots 1.0
import "../../harbour/sailfishslots/QmlLogger/Logger.js" as Console

OrientationPage {
    id: mainApp

    property alias coins: settings.lastCoins

    ApplicationSettings {
        applicationName: "harbour-sailfishslots"
        fileName: "settings"
        id:settings

        property int lastCoins: UIConstants.defaultCoins
        property bool bgm: false
        property bool sfx: false
    }

    //Lazy loading for pages
    Component {
        id: settingsPage
        SettingsPage {}
    }

    Component {
        id: aboutPage
        AboutDialog {
            application: UIConstants.appTitle + " " + UIConstants.appVersion
            contributors: UIConstants.appContrib
            copyrightHolder: UIConstants.appCopyrightHolder
            copyrightYear: UIConstants.appCopyrightYear
            description: qsTr("Slot machine")
            icon: UIConstants.appIcon
            licenses: UIConstants.appLicenses
            pageTitle: UIConstants.appTitle
            projectLinks: UIConstants.appLinks
        }
    }

    Component {
        id: helpPage
        Help {}
    }

    DynamicLoader {
        id: loader
        onObjectCompleted: pageStack.push(object)
    }

    // ------- Start UI ----------

    SilicaFlickable {
        anchors.fill: parent

        PullDownMenu {

            StandardMenuItem {
                text: qsTr("Spin")
                onClicked: spin()
            }
        }

        PushUpMenu {

            StandardMenuItem {
                text: qsTr("Help")
                onClicked: loader.create(helpPage, this, {})
            }

            StandardMenuItem {
                text: qsTr("Reset")
                onClicked: coins = settings.lastCoins
            }

            StandardMenuItem {
                text: qsTr("About")
                onClicked: loader.create(aboutPage, this, {})
            }

            StandardMenuItem {
                text: qsTr("Settings")
                onClicked: loader.create(settingsPage, this, {})
            }
        }

        Column {
            id: infoColumn
            width: parent.width - Theme.paddingLarge * 2
            y: Theme.paddingLarge
            x: Theme.paddingLarge
            z: 1000

            InformationalLabel {
                anchors.right: parent.right
                text:  coins + "  " + qsTr("Coins")
            }
        }

        Column {
            id: reelColumn
            width: parent.width - Theme.paddingLarge * 2
            x: Screen.width / 4
            y: Screen.height / 12
            spacing: Theme.paddingMedium

            property int reelWidth: Orientation.Portrait ? Screen.width / 2 : Screen.height / 3
            property int reelHeight: Orientation.Portrait ? Screen.height / 4 : Screen.height / 3

            Reel {
                id: reel1
                width: parent.reelWidth
                height: parent.reelHeight
            }

            Reel {
                id: reel2
                width: parent.reelWidth
                height: parent.reelHeight
            }

            Reel {
                id: reel3
                width: parent.reelWidth
                height: parent.reelHeight
            }
        }

        VerticalScrollDecorator {}
    }

    function spin() {
        reel1.spin(UIConstants.spinDurationMs * 1)
        reel2.spin(UIConstants.spinDurationMs * 2)
        reel3.spin(UIConstants.spinDurationMs * 3)
    }
}
