import Foundation

class CoinBaseAPI {
    
    private let baseURL = "https://api.coinbase.com/v2/"
    private let accessToken: String
    
    init(accessToken: String) {
        self.accessToken = accessToken
    }
    
    func getExchangeRates(completion: @escaping (Result<[String: Double], Error>) -> Void) {
        let endpoint = "exchange-rates"
        let url = URL(string: baseURL + endpoint)!
        var request = URLRequest(url: url)
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.failure(APIError.unknown))
                }
                return
            }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let exchangeRatesResponse = try decoder.decode(ExchangeRatesResponse.self, from: data)
                let rates = exchangeRatesResponse.data.rates
                completion(.success(rates))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func buyCrypto(amount: Double, currency: String, completion: @escaping (Result<Transaction, Error>) -> Void) {
        let endpoint = "accounts"
        let url = URL(string: baseURL + endpoint)!
        var request = URLRequest(url: url)
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.failure(APIError.unknown))
                }
                return
            }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let accountsResponse = try decoder.decode(AccountsResponse.self, from: data)
                guard let account = accountsResponse.data.first(where: { $0.currency.code == currency }) else {
                    completion(.failure(APIError.invalidCurrency))
                    return
                }
                let params: [String: Any] = [
                    "amount": String(format: "%.2f", amount),
                    "currency": currency,
                    "payment_method": account.paymentMethods.first!.id,
                    "commit": true
                ]
                let body = try JSONSerialization.data(withJSONObject: params, options: [])
                let buyEndpoint = "\(endpoint)/\(account.id)/buys"
                let buyURL = URL(string: baseURL + buyEndpoint)!
                var buyRequest = URLRequest(url: buyURL)
                buyRequest.httpMethod = "POST"
                buyRequest.httpBody = body
                buyRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
                buyRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                URLSession.shared.dataTask(with: buyRequest) { data, response, error in
                    guard let data = data else {
                        if let error = error {
                            completion(.failure(error))
                        } else {
                            completion(.failure(APIError.unknown))
                        }
                        return
                    }
                    do {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let buyResponse = try decoder.decode(BuyResponse.self, from: data)
                        let transaction = Transaction(
                            id: buyResponse.data.id,
                            amount: buyResponse.data.amount.amount,
                            currency: buyResponse.data.amount.currency,
                            date: buyResponse.data.updatedAt
                        )
                        completion(.success
