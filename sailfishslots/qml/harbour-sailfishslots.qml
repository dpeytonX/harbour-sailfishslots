import QtQuick 2.1
import Sailfish.Silica 1.0
import harbour.sailfishslots.SailfishWidgets.JS 3.3
import "../harbour/sailfishslots/QmlLogger/Logger.js" as Console
import "pages"
import "cover"

ApplicationWindow
{
    initialPage: Component {
        id: mainApp
        MainApp {
            //onFinalAmountChanged: coverPage.total = amount
            //onTipAmountChanged: coverPage.tip = amount

            //Component.onCompleted: {
            //    Console.info("harbour-opentip: setting actions")
            //    resetAction.triggered.connect(reset)
            //}
        }
    }
    cover: CoverPage {
        id: coverPage

        CoverActionList {
            enabled: coverPage.total != 0 || coverPage.tip != 0

            /*
            CoverAction {
                id: resetAction
                iconSource: IconThemes.iconCoverRefresh
                onTriggered: Console.info("CoverAction: tip reset")
            }*/
        }

        //onTotalChanged: Console.debug("CoverPage: total changed " + total)

        //onTipChanged: Console.debug("CoverPage: tip changed " + tip)
    }

    Component.onCompleted: Console.LOG_PRIORITY = Console.TRACE
}


