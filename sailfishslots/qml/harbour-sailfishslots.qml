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
            Component.onCompleted: coverPage.app = this
        }
    }

    cover: CoverPage {
        id: coverPage
    }

    Component.onCompleted: Console.LOG_PRIORITY = Console.INFO
}


