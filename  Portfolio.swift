import Foundation

struct Portfolio {
    var assets: [Asset]
    var totalValue: Double {
        assets.reduce(0) { $0 + $1.value }
    }
    var formattedTotalValue: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: NSNumber(value: totalValue)) ?? "$0.00"
    }

    init(assets: [Asset]) {
        self.assets = assets
    }

    func asset(at index: Int) -> Asset? {
        guard index >= 0 && index < assets.count else {
            return nil
        }
        return assets[index]
    }
}

struct Asset {
    let name: String
    let value: Double
    let formattedValue: String

    init(name: String, value: Double) {
        self.name = name
        self.value = value
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formattedValue = formatter.string(from: NSNumber(value: value)) ?? "$0.00"
    }
}
