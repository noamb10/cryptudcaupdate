import UIKit

class CustomTableViewCell: UITableViewCell {
    
    let symbolLabel = UILabel()
    let amountLabel = UILabel()
    let valueLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews() {
        // Set up the symbol label
        symbolLabel.font = UIFont.boldSystemFont(ofSize: 18)
        symbolLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(symbolLabel)
        NSLayoutConstraint.activate([
            symbolLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            symbolLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        // Set up the amount label
        amountLabel.font = UIFont.systemFont(ofSize: 16)
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(amountLabel)
        NSLayoutConstraint.activate([
            amountLabel.leadingAnchor.constraint(equalTo: symbolLabel.trailingAnchor, constant: 8),
            amountLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        // Set up the value label
        valueLabel.font = UIFont.systemFont(ofSize: 16)
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(valueLabel)
        NSLayoutConstraint.activate([
            valueLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            valueLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func configure(with holding: Holding) {
        symbolLabel.text = holding.symbol.uppercased()
        amountLabel.text = "\(holding.amount) \(holding.symbol)"
        valueLabel.text = "\(holding.value.usdFormatted) USD"
    }
    
}

extension Double {
    var usdFormatted: String {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.numberStyle = .currency
        return formatter.string(from: NSNumber(value: self)) ?? ""
    }
}
