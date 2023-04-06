import SwiftUI

struct TransactionTableViewCell: View {
    let transaction: Transaction
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(transaction.type.rawValue)
                .font(.headline)
            HStack {
                Text("Amount:")
                Spacer()
                Text(transaction.amount.description)
            }
            HStack {
                Text("Date:")
                Spacer()
                Text(transaction.date, style: .date)
            }
            if let fee = transaction.fee {
                HStack {
                    Text("Fee:")
                    Spacer()
                    Text(fee.description)
                }
            }
        }
    }
}
