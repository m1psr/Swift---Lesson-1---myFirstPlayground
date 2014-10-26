// Playground - noun: a place where people can play

import Foundation

enum ProductType: Int {
    case Food = 0, Pets, Slaves, Guns, Drugs, Balls, Clothes, Devices, Vehicles
    
    static let allValues = [Food, Pets, Slaves, Guns, Drugs, Balls, Clothes, Devices, Vehicles]
    var description : String {
        get {
            switch self {
            case Food:
                return "Еда"
            case Pets:
                return "Домашние животные"
            case Slaves:
                return "Рабы"
            case Guns:
                return "Оружие"
            case Drugs:
                return "Наркотики"
            case Balls:
                return "Мячи"
            case Clothes:
                return "Одежда"
            case Devices:
                return "Девайсы"
            case Vehicles:
                return "Транспортные стредства"
            default:
                return "Ошибка"
            }
        }
    }
}

let someProductsByProductType = [
    "🍕🍷🍸🍺🍔🍗🍞🍧🍎🍭🍏🍊🍋🍒🍇🍉🍓🍑🍈🍌🍐🍍🍠🍆🍅🌽",
    "🐶🐺🐱🐭🐹🐰🐸🐨🐻🐷🐮🐗🐵🐼🐘👻🐍🐢🐊🐓🐕",
    "👲👳👦👧👩👸👽",
    "💣🔫🔪🔨",
    "💉🚬",
    "🏈🏉🏀⚽️⚾️🎾🎱",
    "👟👞👡👠👢🎩👑👒👕👔👚👗👙👖👓🌂",
    "🎮🎸🔭🔬🔦💻📱☎️📟📼📹📷🎥",
    "🚙🚗🚕🚛🚚🚲🚐🚑🚒🚓🚜🚁🚂🚀✈️⛵️🚤"
]

struct Product {
    var type: ProductType
    var name: String
    var price: Int
    
    func description() -> String {
        return "\(type.description): \(name) 💲\(price)"
    }
    
    static func randomProduct() -> Product {
        let productType = ProductType(rawValue: randomIntValue(until: ProductType.allValues.count))
        let productName = Array(someProductsByProductType[productType!.rawValue])[randomIntValue(until: countElements(someProductsByProductType[productType!.rawValue]))]
        let productPrice = randomIntValue(from: 10, until: 1000)
        
        return Product(type: productType!, name: String(productName), price: productPrice)
    }
    
    // return random Int [lowerBound, upperBound)
    static func randomIntValue(from lowerBound:Int = 0, until upperBound: Int) -> Int {
        return Int(arc4random_uniform(UInt32(upperBound)))
    }
}

class CheckCalculator {
    
    var sumTotal: Int = 0
    var products:[Product] = []
    
    func addProduct(product: Product) {
        sumTotal += product.price
        products.append(product)
    }
    
    // 2. Сделать метод возвращающий % каждого типа товаров от суммы
    func sumPercentByProductTypes() -> [ProductType: Double] {
        sortProducts()
    
        var r = Dictionary<ProductType, Double>()
        var curProductType:ProductType? = nil
        var sumByType = 0
        for p in products {
            if (curProductType != p.type) {
                if (curProductType != nil) {
                    r[curProductType!] = Double(sumByType) * 100.0 / Double(sumTotal)
                }
                curProductType = p.type
                sumByType = 0
            }
            sumByType += p.price
        }
        r[curProductType!] = Double(sumByType) * 100.0 / Double(sumTotal)
        
        return r
    }
    
    // 3. Добавить сортировку по типу продукта
    func sortProducts() {
        products.sort { (a: Product, b: Product) -> Bool in
            if a.type.description < b.type.description {
                return true
            } else if a.type.description == b.type.description {
                if a.price < b.price {
                    return true
                }
                return false
            }
            return false
        }
    }
}

//

var calc = CheckCalculator()

println("Заходим в магазин и кладем следующие товары в корзину:\n")

// 1. Сделать цикл который случайно добавляет товары по типам (можно добавить и самих типов)
for _ in 1...20 {
    let p = Product.randomProduct()
    println("➕ \(p.description()) (1 шт.)")
    calc.addProduct(p)
}

println("\n= Всего получилось на сумму: 💲\(calc.sumTotal)\n")

println("🔃 Сортируем список покупок по русским названиям типов продуктов и цене по возрастанию внутри каждой категории\n")
calc.sortProducts()

println("⭐️ Отсортированный список покупок:\n")

for p in calc.products {
    println("☑️ " + p.description())
}

println("\n🌟 Cписок покупок еще раз (теперь c разбивкой по категориям):\n")

var curProductType:ProductType? = nil
var sumByType = 0
for p in calc.products {
    if (curProductType != p.type) {
        if (curProductType != nil) {
            println(" 💲" + String(sumByType))
        }
        print("✔️ \(p.type.description): ")
        curProductType = p.type
        sumByType = 0
    }
    print(p.name)
    sumByType += p.price
}
println(" 💲" + String(sumByType))

println("\n🏁 Частотное распределение потраченных средств по типам продуктов:\n")

for pt in calc.sumPercentByProductTypes() {
    println("✔️ \(pt.0.description): " + String(format: "%.2f", pt.1) + "%")
}
