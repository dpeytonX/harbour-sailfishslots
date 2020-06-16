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
    property alias bet: settings.bet
    property bool autoSpinActive: false
    property bool spinningNow:  reel1.spinning || reel2.spinning || reel3.spinning
    property variant autoSpinTimer: new JsTimer.JsTimer(mainApp, spin, UIConstants.spinDurationMs * 2)
    property variant _fixedPullUpItems: []

    property int reelWidth: orientation == Orientation.Portrait ? width / 2 : width / 6
    property int reelHeight: orientation == Orientation.Portrait ? height / 4 : height - infoColumn.height - betBox.height
    property int reelSizeCol: orientation == Orientation.Portrait ? UIConstants.PORTRAIT_SYMBOL : UIConstants.LANDSCAPE_SYMBOL

    property int _recalculating: 0

    onActiveFocusChanged: autoSpinActive = activeFocus ? autoSpinActive : false

    Component.onCompleted: _vegasModeInit()

    onHeightChanged: _vegasModeInit()

    onAutoSpinActiveChanged: if(autoSpinActive && !spinningNow) autoSpinTimer.start()

    onSpinningNowChanged: {
        if(!spinningNow) {
            var rules = new Rules.Rules(reel1, reel2, reel3)
            if(rules.isWinner()) {
                var earning = rules.getEarnings(bet)
                Console.info("USER WON " + earning)
                coins += earning
            }

            if(autoSpinActive) autoSpinTimer.start()
        }
    }

    onVegasModeChanged: _vegasModeInit()

    onCoinsChanged: {
        Console.debug("Current coin count: " + coins)
        if(_hasBareMinimumCoins() && coins * UIConstants.betThreshold < betBox.currentItem.text) {
            betBox.currentIndex = betBox.currentIndex - 1
            bet = UIConstants.bets[betBox.currentIndex]
        }
    }

    ApplicationSettings {
        applicationName: "harbour-sailfishslots"
        fileName: "settings"
        id:settings

        property int lastCoins: UIConstants.defaultCoins
        property bool bgm: false
        property bool sfx: false
        property int bet: UIConstants.bets[0]
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
        MenuItem {
            enabled: false
        }
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

            enabled: !spinningNow && _hasBareMinimumCoins()
        }
    }

    Component {
        id: autoSpinMenuItem
        StandardMenuItem {
            text: autoSpinActive ? qsTr("Stop Auto Spin") : qsTr("Auto Spin")
            onClicked: autoSpinActive = !autoSpinActive
            enabled: _hasBareMinimumCoins()

            onEnabledChanged: if(!enabled) autoSpinActive = false
        }
    }

    // ------- Start UI ----------

    // Show busy indicator while we repaint the reels between transitions
    PageBusyIndicator {
        running: _recalculating != 0
    }

    SilicaFlickable {
        anchors.fill: parent

        PullDownMenu {
            id: leverMenu

            StandardMenuItem {
                text: qsTr("Give me coins!")
                onClicked: coins = UIConstants.defaultCoins
                visible: coins <= (coins * UIConstants.betThreshold < UIConstants.bets[0] || UIConstants.defaultCoins / 2)
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

        ComboBox {
            id: betBox
            label: qsTr("Bet")
            anchors.bottom: parent.bottom
            anchors.bottomMargin: Theme.paddingMedium

            currentIndex: UIConstants.bets.indexOf(settings.bet)

            onCurrentIndexChanged: bet = UIConstants.bets[currentIndex]

            menu: ContextMenu {
                Repeater {
                    model: UIConstants.bets
                    StandardMenuItem {
                        text: modelData
                        enabled: coins * UIConstants.betThreshold >= modelData
                        visible: enabled
                        onClicked: bet = text
                    }
                }
            }
        }
    }


    Reel {
        id: reel1
        reelSize: mainApp.reelSizeCol
        onReelSizeChanged: recalculateReels(this, 1)

        Component.onCompleted: recalculateReels(this, 1)
    }

    Reel {
        id: reel2
        reelSize: mainApp.reelSizeCol
        onReelSizeChanged: recalculateReels(this, 2)

        Component.onCompleted: recalculateReels(this, 2)
    }

    Reel {
        id: reel3
        reelSize: mainApp.reelSizeCol
        onReelSizeChanged: recalculateReels(this, 3)

        Component.onCompleted: recalculateReels(this, 3)
    }

    Text {
        id: indicatorLabel

        text: UIConstants.indicatorSymbol
        font.pixelSize: mainApp.reelWidth
        color: Theme.highlightColor

        visible: reelSizeCol == UIConstants.LANDSCAPE_SYMBOL

        width: mainApp.reelWidth
        height: mainApp.reelWidth
        x: Theme.paddingLarge + mainApp.reelWidth * 4 + width
        y: mainApp.reelHeight / 3 - betBox.height / 2
    }

    function recalculateReels (reel, id) {
        _recalculating++
        new JsTimer.JsTimer(mainApp, function() {
            reel.width = mainApp.reelWidth
            reel.height = mainApp.reelHeight
            reel.x = mainApp.orientation == Orientation.Portrait ? reel.width / 4 : reel.width * (id - 1) + Theme.paddingLarge
            reel.y = mainApp.orientation == Orientation.Portrait ? reel.height / 2 + (reel.height * (id - 1)) : Theme.paddingSmall
            Console.debug("orientation: " + mainApp.orientation + ", id: " + id +
                          ", x: " + reel.x +
                          ", y: " + reel.y +
                          ", width: " + reel.width +
                          ", height: " + reel.height)
            _recalculating--
        }, 200).start()
    }

    function spin() {
        Console.info("Spinning, coin: " + coins + ", bet: " + bet)
        if(_hasBareMinimumCoins()) {
            coins -= bet
            reel1.spin(UIConstants.spinDurationMs * 1)
            reel2.spin(UIConstants.spinDurationMs * 2)
            reel3.spin(UIConstants.spinDurationMs * 3)
        }
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
            var height = mainApp.height - (mainApp.orientation == Orientation.Portrait ? menuItemHeight * 8 : menuItemHeight * 6)
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

    function _hasBareMinimumCoins() {
        return coins * UIConstants.betThreshold >= UIConstants.bets[0]
    }
}
