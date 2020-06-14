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

    ApplicationSettings {
        applicationName: UIConstants.appName
        fileName: "settings"
        id:settings

        property string locale: "app"
        property bool bgm: false
        property bool sfx: false
        property int lastCoins: UIConstants.defaultCoins
    }

    InstalledLocales {
        id: installedLocales
        includeAppDefault: true
        appName: UIConstants.appName
        applicationDefaultText: qsTr("Application Default");
    }

    PageColumn {
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
    }

    OrientationHelper {}

    Component.onCompleted: {
        console.log(settings.locale)
        console.log(installedLocales.findLocale(settings.locale))
        console.log(installedLocales.locales.length)
        for(var i = 0; i < installedLocales.locales.length; i++)
            console.log(installedLocales.locales[i].locale)
    }
}
