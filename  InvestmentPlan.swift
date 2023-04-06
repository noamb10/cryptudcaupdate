import Foundation

struct InvestmentPlan {
    let amount: Double
    let frequency: InvestmentFrequency
    
    var totalInvestment: Double {
        switch frequency {
        case .daily:
            return amount * 365
        case .weekly:
            return amount * 52
        case .biweekly:
            return amount * 26
        case .monthly:
            return amount * 12
        }
    }
    
    enum InvestmentFrequency: String, CaseIterable {
        case daily = "Daily"
        case weekly = "Weekly"
        case biweekly = "Bi-Weekly"
        case monthly = "Monthly"
    }
}
