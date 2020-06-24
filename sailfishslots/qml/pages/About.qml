import QtQuick 2.2
import Sailfish.Silica 1.0
import harbour.sailfishslots.SailfishWidgets.Components 3.3
import harbour.sailfishslots.SailfishSlots 1.0

AboutDialog {
    application: UIConstants.appTitle + " " + UIConstants.appVersion
    contributors: UIConstants.appContrib
    copyrightHolder: UIConstants.appCopyrightHolder
    copyrightYear: UIConstants.appCopyrightYear
    description: qsTr("Slot machine") + "<br>Please consider donating to help development efforts!" +
                 "<br>BTC: " + UIConstants.btc +
                 "<br>Paypal: " + UIConstants.paypal
    icon: Screen.Large ? UIConstants.appIconLarge : UIConstants.appIcon
    licenses: UIConstants.appLicenses
    pageTitle: UIConstants.appTitle
    projectLinks: UIConstants.appLinks
    attributions: UIConstants.appAttributions
}
