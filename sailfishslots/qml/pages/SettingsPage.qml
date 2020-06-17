import QtQuick 2.1
import Sailfish.Silica 1.0
import harbour.sailfishslots.SailfishWidgets.Components 3.3
import harbour.sailfishslots.SailfishWidgets.Settings 3.3
import harbour.sailfishslots.SailfishWidgets.Language 3.3
import harbour.sailfishslots.SailfishSlots 1.0
import harbour.sailfishslots.QmlLogger 2.0

//TODO: Fix scrolling on Settings and Help pages. See About page
//TODO: test bonus mode
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

            Subtext { visible: cheatMode; text: qsTr("Cheat Mode")}

            Label { visible:  cheatMode; text: qsTr("Enter coin value");}

            TextField {
                id: cheatText
                visible: cheatMode
                placeholderText: qsTr("Enter coin value")
                validator: IntValidator { bottom: 1; top: 10000000 }

                onTextChanged: settings.lastCoins = text
            }

            LabelButton {
                visible: cheatMode
                text: qsTr("Enable Bonus Mode")
                onClicked: app.bonusActive += 5
            }

            LabelButton {
                visible: cheatMode
                text: qsTr("Enable Free Spin Mode")
                onClicked: app.freeSpinActive += 5
            }

            TextSwitch {
                property bool lastValue: settings.vegasMode

                checked: settings.vegasMode
                id: vegasText
                text: qsTr("Vegas Mode")
                visible: lastValue || settings.vegasMode || cheatMode

                onCheckedChanged: {
                    settings.vegasMode = checked
                    lastValue = !checked
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
