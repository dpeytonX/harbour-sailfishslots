import QtQuick 2.1
import Sailfish.Silica 1.0
import harbour.sailfishslots.SailfishWidgets.Components 3.3
import harbour.sailfishslots.SailfishWidgets.Settings 3.3
import harbour.sailfishslots.SailfishWidgets.Language 3.3
import harbour.sailfishslots.SailfishSlots 1.0
import harbour.sailfishslots.QmlLogger 2.0

OrientationPage {
    id: settingsPage

    property int cheatChecks: 0
    property bool cheatMode: false
    property variant app

    ApplicationSettings {
        applicationName: UIConstants.appName
        fileName: "settings"
        id:settings

        property string locale: "app"
        property bool bgm: false
        property bool sfx: false
        property int lastCoins: UIConstants.defaultCoins
        property bool vegasMode: false
    }

    InstalledLocales {
        id: installedLocales
        includeAppDefault: true
        appName: UIConstants.appName
        applicationDefaultText: qsTr("Application Default");
    }

    SilicaFlickable {
        id: aboutTaskList
        anchors.fill: parent
        anchors.leftMargin: Theme.paddingLarge
        contentHeight: aboutRectangle.height
        VerticalScrollDecorator { flickable: aboutTaskList }

        PageColumn {
            id: aboutRectangle
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width
            spacing: Theme.paddingSmall

            title: qsTr("Settings")

            Subtext {text: qsTr("Sound")}

            TextSwitch {
                checked: settings.bgm
                id: bgmText
                text: qsTr("Enable background music")

                onCheckedChanged: {
                    settings.bgm = checked
                    cheatChecks++
                    if(cheatChecks == 4) {
                        cheatMode = true
                    }
                }
            }

            TextSwitch {
                checked: settings.sfx
                id: sfxText
                text: qsTr("Enable sound effects")

                onCheckedChanged: {
                    settings.sfx = checked
                    cheatChecks = 0
                }
            }

            Subtext {text: qsTr("Miscellaneous")}

            ComboBox {
                id: languageCombo
                description: qsTr("Switching languages requires an application restart")
                label: qsTr("Language")
                width: settingsPage.width

                currentIndex: installedLocales.findLocale(settings.locale) == -1 ?
                                  0 : installedLocales.findLocale(settings.locale)

                menu: ContextMenu {
                    Repeater {
                        model: installedLocales.locales
                        StandardMenuItem {
                            text: modelData.pretty
                            onClicked: settings.locale = modelData.locale
                        }
                    }
                }

                onCurrentIndexChanged: {
                    cheatChecks = 0
                }
            }

            Heading { visible: cheatMode; text: qsTr("Cheat Mode")}

            Subtext { visible: cheatMode; text: qsTr("Set coins")}

            TextField {
                id: cheatText
                visible: cheatMode
                placeholderText: qsTr("Enter coin value")
                validator: IntValidator { bottom: 1; top: 10000000 }
                text: settings.lastCoins

                onTextChanged: settings.lastCoins = text
                EnterKey.onClicked: focus = false
            }

            Subtext { visible: cheatMode; text: qsTr("Special")}

            TextSwitch {
                property bool lastValue: settings.vegasMode

                checked: settings.vegasMode
                id: vegasText
                text: qsTr("Vegas")
                description: qsTr("Simulate a lever using the pull down menu")
                visible: lastValue || settings.vegasMode || cheatMode

                onCheckedChanged: {
                    settings.vegasMode = checked
                    lastValue = !checked
                }
            }

            ButtonLayout {
                Button {
                    visible: cheatMode
                    text: qsTr("Bonus Spins")
                    enabled: !app.bonusActive
                    onClicked: {app.bonusActive += 5; app.bonusCoins = app.bet}
                }

                Button {
                    visible: cheatMode
                    text: qsTr("Free Spins")
                    enabled: !app.freeSpinActive
                    onClicked: app.freeSpinActive += 5
                }
            }

        }}

    OrientationHelper {}

    Component.onCompleted: {
        console.log(settings.locale)
        console.log(installedLocales.findLocale(settings.locale))
        console.log(installedLocales.locales.length)
        for(var i = 0; i < installedLocales.locales.length; i++)
            console.log(installedLocales.locales[i].locale)
    }
}
