.pragma library

var coverIcon = "qrc:///images/cover.png"
var appIcon = "qrc:///images/desktop.png"
var appName = "harbour-sailfishslots"
var appTitle = "Sailfish Slots"
var appContrib = ["Dametrious Peyton"]
var appCopyrightHolder = "Dametrious Peyton"
var appCopyrightYear = "2020"
var appLicenses = ["GPL v3"]
var appVersion = "1.0"
var appLinks = ["https://github.com/prplmnky/harbour-sailfishslots"]

var PORTRAIT_SYMBOL = 1
var LANDSCAPE_SYMBOL = 3
var MAX_SYMBOL = 3

var defaultCoins = 200
var bets = [1, 2, 5, 10, 20, 30, 50, 100, 1000, 2000, 5000, 10000, 20000, 30000, 50000, 75000, 100000, 200000, 500000, 1000000, 2000000, 5000000, 10000000]
var betThreshold = .25
var bonusMultiplier = 10
var bonusSpins = 15
var freeSpins = 10

var symbols = [ " 7","🍒", "🎲","🎰", "🍫","💰","🆓" ];
var ratios =  [0.14,  0.15, 0.30, 0.1,  0.1, 0.20, 0.01];
//var ratios =  [0, 0, 0, 1, 0, 0, 0 ]; //[0.14,  0.15, 0.30, 0.1,  0.1, 0.20, 0.01];
var sevenIndex = 0
var wildIndex = 3
var wildSymbol = "🎰"
var freeSpinIndex = 6
var freeSpinSymbol = "🆓"

var indicatorSymbol = "⇽"

var spinSpeedMs = 50
var spinDurationMs = 1000
