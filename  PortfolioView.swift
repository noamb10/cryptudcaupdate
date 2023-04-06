import SwiftUI

struct PortfolioView: View {
    @ObservedObject var portfolio: Portfolio
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Portfolio")
                    .font(.title)
                    .padding(.top, 10)
                if portfolio.totalValue > 0 {
                    Text("Total Value: \(portfolio.totalValue, specifier: "%.2f")")
                        .font(.headline)
                        .padding(.top, 10)
                    List(portfolio.transactions) { transaction in
                        TransactionTableViewCell(transaction: transaction)
                    }
                } else {
                    Text("No transactions yet.")
                }
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
        }
    }
}

struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioView(portfolio: Portfolio())
    }
}
