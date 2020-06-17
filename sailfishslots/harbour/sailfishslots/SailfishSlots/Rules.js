function Rules(reelObj1, reelObj2, reelObj3) {

    var sym1 = reelObj1.symbols[reelObj1.getSelectedComponent()].symbolIndex
    var sym2 = reelObj2.symbols[reelObj2.getSelectedComponent()].symbolIndex
    var sym3 = reelObj3.symbols[reelObj3.getSelectedComponent()].symbolIndex

    var wi = UIConstants.wildIndex

    this.threeOfAKind = sym1 == sym2 && sym2 == sym3
    this.twoOfAKindWild = (sym1 == wi && (sym2 == sym3)) ||
         (sym2 == wi && (sym1 == sym3)) ||
         (sym3 == wi && (sym1 == sym2))
    this.oneOfAKindWilds = (sym1 == wi && (sym1 == sym2 || sym1 == sym3)) ||
         (sym2 == wi && (sym2 == sym1 || sym2 == sym3)) ||
         (sym3 == wi && (sym3 == sym1 || sym3 == sym2))
    this.freeSpin = sym1 == UIConstants.freeSpinIndex ||
         sym2 == UIConstants.freeSpinIndex ||
         sym3 == UIConstants.freeSpinIndex

    this.isWinner = function() {
        console.debug("sym1: " + sym1 + ", sym2: " + sym2 + ", sym3: " + sym3)
        console.debug("3 of a kind: " + this.threeOfAKind + ", 2 of a kind: " + this.twoOfAKindWild + ", 1 of a kind: " + this.oneOfAKindWilds + ", free spin: " + this.freeSpin)
        return this.threeOfAKind || this.twoOfAKindWild || this.oneOfAKindWilds || this.freeSpin
    }

    this.isFreeSpin = function(id) { return this.freeSpin;}

    this.getFreeSpins = function()  {
        var count = 0
        count += sym1 == UIConstants.freeSpinIndex ? UIConstants.freeSpins : 0
        count += sym2 == UIConstants.freeSpinIndex ? UIConstants.freeSpins : 0
        count += sym3 == UIConstants.freeSpinIndex ? UIConstants.freeSpins : 0
        return count
    }

    this.getBonusSpins = function()  { return UIConstants.bonusSpins; }

    this.getBonusCoins = function(coin) { return coin * UIConstants.bonusMultiplier; }

    this.isBonus = function() { return this.threeOfAKind && sym1 == wi; }

    this.getEarnings = function(bet) {
        if(!this.isWinner())
            return 0

        var _calculate = function(i) {
            var ratio = 1 - UIConstants.ratios[i]

            if(ratio <= 0.8)
                return ratio * 2
            else if (ratio > 0.8 && ratio <= 0.9)
                return ratio * 5
            else
                return ratio * 10
        }

        var earn1 = _calculate(sym1)
        var earn2 = _calculate(sym2)
        var earn3 = _calculate(sym3)

        var total = Math.ceil(bet * (earn1 + earn2 + earn3))

        if(this.threeOfAKind) {
            if(sym1 == UIConstants.sevenIndex) {
                return total * 20
            } else if(sym1 == UIConstants.wildIndex) {
                return total * 10
            } else {
                return total * 5
            }
        }

        return total
    }
}
