import Foundation

class UserManager {
    static let shared = UserManager()
    
    var investmentPlan: InvestmentPlan?
    var transactions: [Transaction] = []
    var portfolio: Portfolio?
    
    private init() {}
    
    func setInvestmentPlan(_ investmentPlan: InvestmentPlan) {
        self.investmentPlan = investmentPlan
    }
    
    func addTransaction(_ transaction: Transaction) {
        transactions.append(transaction)
    }
    
    func setPortfolio(_ portfolio: Portfolio) {
        self.portfolio = portfolio
    }
}
