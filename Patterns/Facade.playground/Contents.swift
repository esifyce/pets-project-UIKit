import Foundation

class FruitShop {
    
    func buyFruits() -> String {
        return "fruits"
    }
}

class MeatShop {
    
    func buyMeat() -> String {
        return "meat"
    }
}

class MilkShop {
    
    func buyMilk() -> String {
        return "milk"
    }
}

class SweetShop {
    
    func buySweets() -> String {
        return "sweets"
    }
}

class BreadShop {
    
    func buyBread() -> String {
        return "bread"
    }
}

// Facade
class Supermarket {
    
    let fruitShop = FruitShop()
    let meatShop = MeatShop()
    let milkShop = MilkShop()
    let sweetShop = SweetShop()
    let breadShop = BreadShop()
    
    func buyProducts() -> String {
        
        var products = ""
        products += fruitShop.buyFruits() + ", "
        products += meatShop.buyMeat() + ", "
        products += milkShop.buyMilk() + ", "
        products += sweetShop.buySweets() + ", "
        products += breadShop.buyBread()
        
        return "I bought: " + products
    }
}

let sm = Supermarket()
sm.buyProducts()
sm.breadShop
