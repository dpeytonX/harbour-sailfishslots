import QtQuick 2.2
import Sailfish.Silica 1.0
import harbour.sailfishslots.SailfishWidgets.Components 3.4
import harbour.sailfishslots.SailfishWidgets.Settings 3.4
import harbour.sailfishslots.SailfishWidgets.Utilities 3.4
import harbour.sailfishslots.SailfishWidgets.JS 3.3
import harbour.sailfishslots.SailfishSlots 1.0
import "../../harbour/sailfishslots/QmlLogger/Logger.js" as Console

OrientationPage {
    id: mainApp

    property alias coins: settings.lastCoins
    property alias vegasMode: settings.vegasMode
    property bool autoSpinActive: false
    property bool spinningNow:  reel1.spinning || reel2.spinning || reel3.spinning
    property variant timer: new JsTimer.JsTimer(mainApp)
    property variant _fixedPullUpItems: []

    property int reelWidth: mainApp.orientation == Orientation.Portrait ? mainApp.width / 2 : mainApp.width / 3
    property int reelHeight: mainApp.orientation == Orientation.Portrait ? mainApp.height / 4 : mainApp.height
    property int reelSizeCol: mainApp.orientation == Orientation.Portrait ? UIConstants.PORTRAIT_SYMBOL : UIConstants.LANDSCAPE_SYMBOL

    Component.onCompleted: _vegasModeInit()

    onHeightChanged: _vegasModeInit()

    onSpinningNowChanged: {
        if(autoSpinActive && !spinningNow)
            JsTimer.setTimeout(timer, spin, UIConstants.spinDurationMs)
    }

    onVegasModeChanged: _vegasModeInit()

    ApplicationSettings {
        applicationName: "harbour-sailfishslots"
        fileName: "settings"
        id:settings

        property int lastCoins: UIConstants.defaultCoins
        property bool bgm: false
        property bool sfx: false
        property bool vegasMode: false
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

    Component {
        id: vegusMenuItem
        MenuItem {}
    }

    DynamicLoader {
        id: vegasLoader
        onObjectCompleted: {
            Console.debug("Adding vegas menu item")
            _fixedPullUpItems.push(object)
        }
    }

    DynamicLoader {
        id: loader
        onObjectCompleted: pageStack.push(object)
    }

    Component {
        id: spinMenuItem
        StandardMenuItem {

            text: qsTr("Spin!")
            onClicked: spin()

            enabled: !spinningNow
        }
    }

    Component {
        id: autoSpinMenuItem
        StandardMenuItem {

            text: autoSpinActive ? qsTr("Stop Auto Spin") : qsTr("Auto Spin")
            onClicked: {
                autoSpinActive = !autoSpinActive
                JsTimer.setTimeout(timer, spin, UIConstants.spinDurationMs)
            }
        }
    }

    // ------- Start UI ----------

    SilicaFlickable {
        anchors.fill: parent

        PullDownMenu {
            id: leverMenu

            StandardMenuItem {
                text: qsTr("Give me coins!")
                onClicked: coins = UIConstants.defaultCoins
                visible: coins <= UIConstants.defaultCoins / 2
            }
        }

        PushUpMenu {

            StandardMenuItem {
                id: helpMenuItem
                text: qsTr("Help")
                onClicked: loader.create(helpPage, this, {})
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
    }


    Reel {
        id: reel1
        width: mainApp.reelWidth
        height: mainApp.reelHeight
        reelSize: mainApp.reelSizeCol
        x: mainApp.orientation == Orientation.Portrait ? width / 4 : mainApp.reelWidth
        y: mainApp.orientation == Orientation.Portrait ? height / 2 : Theme.paddingLarge

        Component.onCompleted: {
            Console.debug("x: " + x + ",y: " + y + ",width: " + width +",height: " + height)
        }
    }

    Reel {
        id: reel2
        width: mainApp.reelWidth
        height: mainApp.reelHeight
        reelSize: mainApp.reelSizeCol
        x: mainApp.orientation == Orientation.Portrait ? width / 4 : (mainApp.reelWidth * 2 + Theme.paddingLarge)
        y: mainApp.orientation == Orientation.Portrait ? height / 2 + height: Theme.paddingLarge

        Component.onCompleted: {
            Console.debug("x: " + x + ",y: " + y + ",width: " + width +",height: " + height)
        }
    }

    Reel {
        id: reel3
        width: mainApp.reelWidth
        height: mainApp.reelHeight
        reelSize: mainApp.reelSizeCol
        x: mainApp.orientation == Orientation.Portrait ? width / 4 : (mainApp.reelWidth * 3 + Theme.paddingLarge)
        y: mainApp.orientation == Orientation.Portrait ? height / 2 + height * 2 : Theme.paddingLarge

        Component.onCompleted: {
            Console.debug("x: " + x + ",y: " + y + ",width: " + width +",height: " + height)
        }
    }

    function spin() {
        reel1.spin(UIConstants.spinDurationMs * 1)
        reel2.spin(UIConstants.spinDurationMs * 2)
        reel3.spin(UIConstants.spinDurationMs * 3)
    }

    function _vegasModeInit() {
        Console.debug("Current pulley items: " + _fixedPullUpItems.length)
        for(var i in _fixedPullUpItems) {
            Console.debug("Found child: " + _fixedPullUpItems[i])
            _fixedPullUpItems[i].visible = false
            _fixedPullUpItems[i].destroy()
        }
        _fixedPullUpItems = []
        leverMenu._content.children = []

        vegasLoader.createObj(spinMenuItem, leverMenu._contentColumn)

        if(vegasMode) {
            var menuItemHeight = helpMenuItem.height
            var height = mainApp.height - (menuItemHeight * 8)
            Console.debug("Screen height: " + mainApp.height + ", spinMenu Height: " + menuItemHeight + ", result height: " + height)
            var i = 0
            while(height / (menuItemHeight * i++) > 1) {
                Console.debug("Creating vegas mode menu items")
                var txt=""
                for(var x = 0; x < i; x++)
                    txt += " " //"♩"
                vegasLoader.create(vegusMenuItem, leverMenu._contentColumn, {text: txt, id: "vegas" + i})
            }
        }

        vegasLoader.createObj(autoSpinMenuItem, leverMenu._contentColumn)
    }
}
