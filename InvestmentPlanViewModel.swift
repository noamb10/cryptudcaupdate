import Foundation

class InvestmentPlanViewModel: ObservableObject {
    @Published var amount: String = ""
    @Published var frequency: String = ""
    
    var isFormValid: Bool {
        return !amount.isEmpty && !frequency.isEmpty
    }
    
    func createPlan() {
        print("Creating plan with amount: \(amount) and frequency: \(frequency)")
    }
}
