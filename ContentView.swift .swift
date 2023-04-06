import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: ContentViewModel

    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Text("Welcome to DCA Platform")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding()
                
                VStack {
                    Text("Investment Plan:")
                        .font(.title)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.leading)
                        .padding()
                    
                    InvestmentPlanView(viewModel: viewModel.investmentPlanViewModel)
                        .padding(.horizontal)
                }
                
                Spacer()
                
                VStack {
                    Text("Portfolio:")
                        .font(.title)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.leading)
                        .padding()
                    
                    PortfolioView(viewModel: viewModel.portfolioViewModel)
                        .padding(.horizontal)
                }
                
                Spacer()
            }
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarItems(
                trailing:
                    Button(action: {
                        viewModel.showSettingsView.toggle()
                    }) {
                        Image(systemName: "gear")
                    }
            )
            .sheet(isPresented: $viewModel.showSettingsView) {
                SettingsView(viewModel: viewModel.settingsViewModel)
            }
        }
    }
}
