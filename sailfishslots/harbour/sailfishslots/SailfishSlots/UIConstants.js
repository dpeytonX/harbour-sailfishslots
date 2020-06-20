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
var bets = [1, 2, 5, 10, 20, 30, 50, 100, 1000, 2000, 5000, 10000, 20000, 50000, 100000, 200000, 500000, 1000000]
var betThreshold = .25
var bonusMultiplier = 2
var bonusSpins = 10
var freeSpins = 5

var symbols = [ " 7","🍒", "🎲","🎰", "🍫","💰","🆓" ];
var ratios =  [0.1,  0.20, 0.25, 0.1,  0.145, 0.20, 0.005];
//var ratios =  [0, 0, 0, 1, 0, 0, 0 ]; //[0.14,  0.15, 0.30, 0.1,  0.1, 0.20, 0.01];
var sevenIndex = 0
var wildIndex = 3
var wildSymbol = "🎰"
var freeSpinIndex = 6
var freeSpinSymbol = "🆓"

var indicatorSymbol = "⇽"

var autoSpinTimer = 3000
var spinSpeedMs = 75
var spinDurationMs = 4000
var spinDuration1Ms = 4000
var spinDuration2Ms = 4500
var spinDuration3Ms = 5000
var specialStageNotificationMs = 6000
