import harbour.sailfishslots.SailfishSlots 1.0
import harbour.sailfishslots.SailfishWidgets.Utilities 3.3
import "../QmlLogger/Logger.js" as Console
import QtQuick 2.2
import Sailfish.Silica 1.0

Column  {
    id: reelColumn
    signal spin(int duration)
    signal spinOver

    property variant symbols: []
    property variant reelSize: UIConstants.PORTRAIT_SYMBOL
    property bool spinning: false

    onReelSizeChanged: {
        if(!spinning)
           organizeSymbols()
    }

    onSpin: {
        Console.debug("Duration " + duration)
        spinTimer.duration = duration
        spinTimer.start()
    }

    onSpinOver: {
        _cleanUp()
    }

    Component {
        id: symbolTemplate
        Text {
            property int duration
            property int symbolIndex

            id: txt
            width: reelColumn.width
            height: reelColumn.height / reelSize
            x: reelColumn.x
            y: reelColumn.y
            text: UIConstants.symbols[0]
            font.pixelSize: reelSize == UIConstants.PORTRAIT_SYMBOL ? parent.width : parent.height / UIConstants.LANDSCAPE_SYMBOL
            color: Theme.highlightColor
        }
    }

    DynamicLoader {
        id: loader
        onObjectCompleted: {
            symbols.push(object)
            organizeSymbols()
            Console.trace("Pushing symbol on stack. Size: " + symbols.length)
        }
    }

    Timer {
        id: spinTimer
        triggeredOnStart: true
        interval: UIConstants.spinSpeedMs
        repeat: true

        property int cur: 0
        property int duration

        onTriggered: {
            spinning = true
            createSymbols()

            cur += interval
            if(cur >= duration) {
                cur = 0
                spinning = false
                stop()
                spinOver()
            } else {
                _cleanUp()
            }
        }
    }

    function createSymbols() {
        var t=""
        var randSymbolIndex = 0
        var curSymbol = 0
        var randSymbol = Math.random()

        for (var i = 0; i < UIConstants.ratios.length; i++) {
            Console.trace("curSymbol: " + curSymbol + " Rand Symbol " + randSymbol)
            curSymbol += UIConstants.ratios[i];
            if(curSymbol >= randSymbol) {
                randSymbolIndex = i
                break;
            }
        }

        t = UIConstants.symbols[randSymbolIndex]


        Console.trace("current symbol: " + randSymbolIndex + " " + t)

        loader.create(symbolTemplate, reelColumn, {text: t, symbolIndex: randSymbolIndex })
    }

    function organizeSymbols() {
        var selectedIndex = getSelectedComponent()

        Console.trace("Reel size: " + reelSize + ", selected Index: " + selectedIndex + ", size: " + symbols.length)
        for(var i = 0; i < symbols.length; i++) {
            if(reelSize == UIConstants.LANDSCAPE_SYMBOL)
                symbols[i].visible = selectedIndex - 1 <= i && i <= selectedIndex + 1
            else
                symbols[i].visible = (i == selectedIndex)

            Console.trace("Symbol: " + symbols[i].text + ", " + i + ", is visible: " + (symbols[i].visible))
        }
    }


    function getSelectedComponent() {
        return Math.floor(symbols.length / 2)
    }

    function _cleanUp() {
        var upper = UIConstants.MAX_SYMBOL + getSelectedComponent()
        Console.debug("Clean up: " + symbols.length + ", initiate at: " + upper )

        if(symbols.length > upper) {
            var componentArray = []
            for(var i = 0; i < symbols.length; i++) {
                if(i < getSelectedComponent() - UIConstants.MAX_SYMBOL || i > getSelectedComponent() + UIConstants.MAX_SYMBOL)
                    symbols[i].destroy()
                else
                    componentArray.push(symbols[i])
            }
            symbols = componentArray
            Console.debug("New component size: " + symbols.length)
        }
    }

    Component.onCompleted: {
        Console.info("Creating initial components")
        Console.trace("Reel size: " + reelSize + ", Max symbols: " + UIConstants.MAX_SYMBOL)
        for(var i = 0; i < UIConstants.MAX_SYMBOL; i++)
            createSymbols()
    }
}
