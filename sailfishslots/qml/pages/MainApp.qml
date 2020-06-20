import QtQuick 2.6
import QtGraphicalEffects 1.0
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
    property int freeSpinActive: 0
    property int bonusActive: 0
    property bool specialStageActive: freeSpinActive > 0 || bonusActive > 0
    property int bonusCoins: 0
    property variant autoSpinTimer: new JsTimer.JsTimer(mainApp, spin, UIConstants.autoSpinTimer)

    property int reelWidth: isPortrait ? width / 2 : width / 6
    property int reelHeight: isPortrait ? height / 4 : height - infoColumn.height - betBox.height
    property int reelSizeCol: isPortrait ? UIConstants.PORTRAIT_SYMBOL : UIConstants.LANDSCAPE_SYMBOL

    property int _recalculating: 0
    property variant _fixedPullUpItems: []
    property int _bonusCounter: 0
    property int _freeCounter: 0


    property bool _lastSpinActive: false

    onActiveFocusChanged: autoSpinActive = activeFocus ? _lastSpinActive : false

    Component.onCompleted: _vegasModeInit()

    onHeightChanged: _vegasModeInit()

    onAutoSpinActiveChanged: { if(autoSpinActive && !spinningNow) autoSpinTimer.start() }

    onSpinningNowChanged: {
        if(!spinningNow) {
            var rules = new Rules.Rules(reel1, reel2, reel3)
            var tempCoins = 0
            if(rules.isWinner()) {
                var earning = rules.getEarnings(bet)
                Console.info("USER WON " + earning)

                if(rules.isFreeSpin()) {
                    tempCoins += earning
                    freeSpinMode(rules)
                } else if(rules.isBonus()) {
                    tempCoins += earning
                    bonusMode(rules)
                } else {
                    tempCoins += earning
                }
            }

            if(bonusActive == 0 && bonusCoins > 0) {
                bonusCoins += (tempCoins < bet? bet : tempCoins)
                tallyBonus(rules.getBonusCoins(bonusCoins))
            } else if(bonusActive) {
                bonusCoins += tempCoins
            } else {
                addCoins(tempCoins)
            }

            _freeCounter++
            _bonusCounter++

            if(autoSpinActive) {
                autoSpinTimer.start()
            }
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

    onSpecialStageActiveChanged: {
        if(specialStageActive) {
            if(bonusActive > 0)
                loader.create(specialStageDialog, this, {bonus: bonusActive})
            else
                loader.create(specialStageDialog, this, {freeSpin: freeSpinActive})
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
        SettingsPage {app: mainApp}
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

    Component { id: specialStageDialog; SpecialStage{}}

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
            onClicked: { autoSpinActive = !autoSpinActive; _lastSpinActive = autoSpinActive;  }
            enabled: _hasBareMinimumCoins()

            onEnabledChanged: if(!enabled) { _lastSpinActive = false; autoSpinActive = false }
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

        PageHeader {
            id: modeHeader

            title: {
                if(bonusActive) return qsTr("Bonus")
                else if (freeSpinActive) qsTr("Free Spin")
                else return ""
            }
            visible: specialStageActive
        }

        Label {
            id: spinRemainingText
            // Don't allow the label to extend over the page stack indicator
            visible: modeHeader.visible
            text: (bonusActive ? bonusActive : freeSpinActive) + " " + (mainApp.isPortrait ? qsTr("Spins") : qsTr("Spins Remaining"))

            truncationMode: TruncationMode.Fade
            color: modeHeader.palette.highlightColor

            y: modeHeader._titleItem.y

            anchors {
                left: parent.left
                leftMargin: modeHeader.rightMargin
            }
            font {
                pixelSize: Theme.fontSizeLarge
                family: Theme.fontFamilyHeading
            }
            TextMetrics {
                id: metrics
                font: spinRemainingText.font
                text: "X"
            }
        }

        InformationalLabel {
            id: plusHiddenLabel

            anchors.bottom: infoColumn.top
            anchors.right: parent.right
            anchors.rightMargin: Theme.horizontalPageMargin
            visible: false
            text: "  " + qsTr("Coins")
        }

        InformationalLabel {
            id: plusCoinsLabel

            anchors.bottom: infoColumn.top
            anchors.right: plusHiddenLabel.left
            visible: true
            text: ""

            scale: visible ? 1.0 : 0.1
            Behavior on scale {
                SequentialAnimation {
                    NumberAnimation  { duration: 500 ; easing.type: Easing.InOutBounce  }
                    PropertyAnimation {}
                    NumberAnimation  { target:plusCoinsLabel; property:"visible"; to: 0; duration: 500 ; easing.type: Easing.InOutBounce  }
                }
            }
        }

        InformationalLabel {
            id: infoColumn

            anchors.bottom: betBox.verticalCenter
            anchors.bottomMargin: -1 * betBox.height / 4
            anchors.right: parent.right
            anchors.rightMargin: Theme.horizontalPageMargin
            z: 1000

            text:  coins + "  " + qsTr("Coins")
        }

        ComboBox {
            id: betBox
            label: qsTr("Bet")
            anchors.bottom: parent.bottom
            anchors.bottomMargin: Theme.paddingMedium
            enabled: !specialStageActive

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

    Rectangle {
        id: reel1Rect
        z: -100
        opacity: 0
        width: reel1.width
        height: reel1.height
        color: "transparent"
        x: reel1.x
        y: reel1.y + (isLandscape ? Theme.paddingLarge : 0)
    }

    // https://doc.qt.io/qt-5/qml-qtgraphicaleffects-rectangularglow.html
    //Need rectangular glow
    // Glow works, with a rectangle, but the rectangle color overtakes the phone background
    Glow {
        id: glow
        anchors.fill: reel1Rect
        radius: reel1.state == "spinning" ? 20 : 0
        source: reel1Rect
        spread: 0.15
        color: Theme.highlightColor
        z: -1
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

    function freeSpinMode(rules) {
        if(bonusActive) {
            bonusActive += rules.getFreeSpins()
        } else {
            freeSpinActive += rules.getFreeSpins()
        }
        Console.info("Free Spins Happened in " + _freeCounter + " spins")
        _freeCounter = 0
    }

    function bonusMode(rules) {
        bonusActive += rules.getBonusSpins()
        Console.info("Bonus Spins Happened in " + _bonusCounter + " spins")
        _bonusCounter = 0
    }

    function recalculateReels (reel, id) {
        _recalculating++
        new JsTimer.JsTimer(mainApp, function() {
            reel.width = mainApp.reelWidth
            reel.height = mainApp.reelHeight
            reel.x = mainApp.isPortrait ? reel.width / 4 : reel.width * (id - 1) + Theme.paddingLarge
            reel.y = mainApp.isPortrait ? reel.height / 2 + (reel.height * (id - 1)) : Theme.paddingSmall
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
            if(bonusActive) {
                bonusActive--
            } else if(freeSpinActive) {
                freeSpinActive --
            } else
                addCoins(-1 * bet)

            reel1.spin(UIConstants.spinDuration1Ms)
            reel2.spin(UIConstants.spinDuration2Ms)
            reel3.spin(UIConstants.spinDuration3Ms)
        }
    }

    function addCoins(c) {
        if(c == 0)
            return

        coins += c
        plusCoinsLabel.text = (c < 0 ? "" : "+") + c
        plusCoinsLabel.visible = true
    }

    function tallyBonus(bc) {
        loader.create(specialStageDialog, this, {jackpot: bc})
        addCoins(bc)
        bonusCoins = 0
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
            var height = mainApp.height - (mainApp.isPortrait ? menuItemHeight * 8 : menuItemHeight * 6)
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
