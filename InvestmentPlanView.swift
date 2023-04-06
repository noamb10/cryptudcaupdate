import SwiftUI

struct InvestmentPlanView: View {
    @StateObject var viewModel: InvestmentPlanViewModel = InvestmentPlanViewModel()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Investment Details")) {
                    TextField("Enter investment amount", text: $viewModel.amount)
                        .keyboardType(.decimalPad)
                    TextField("Enter investment frequency", text: $viewModel.frequency)
                        .keyboardType(.decimalPad)
                }
                
                Section {
                    Button(action: viewModel.createPlan) {
                        Text("Create Plan")
                    }
                    .disabled(!viewModel.isFormValid)
                }
            }
            .navigationBarTitle("Investment Plan")
        }
    }
}

struct InvestmentPlanView_Previews: PreviewProvider {
    static var previews: some View {
        InvestmentPlanView()
    }
}
