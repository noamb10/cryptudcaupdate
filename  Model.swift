import Foundation

class Model {
    
    static let shared = Model()
    
    var investmentPlan: InvestmentPlan?
    var transactions: [Transaction] = []
    var portfolio: Portfolio?
    
    // MARK: - Investment Plan
    
    func saveInvestmentPlan(_ investmentPlan: InvestmentPlan) {
        self.investmentPlan = investmentPlan
    }
    
    func clearInvestmentPlan() {
        investmentPlan = nil
    }
    
    // MARK: - Transactions
    
    func addTransaction(_ transaction: Transaction) {
        transactions.append(transaction)
    }
    
    func clearTransactions() {
        transactions = []
    }
    
    // MARK: - Portfolio
    
    func savePortfolio(_ portfolio: Portfolio) {
        self.portfolio = portfolio
    }
    
    func clearPortfolio() {
        portfolio = nil
    }
}
