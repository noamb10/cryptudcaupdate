import SwiftUI

struct ContentView: View {
    var body: some View {
        InvestmentPlanView(viewModel: InvestmentPlanViewModel())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
