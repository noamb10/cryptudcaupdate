import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = "https://api.coinbase.com/v2/"
    private let session = URLSession.shared
    
    func getAccount(completion: @escaping (Result<Account, Error>) -> Void) {
        guard let url = URL(string: baseURL + "accounts") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        let task = session.dataTask(with: url) { data, response, error in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  response.statusCode == 200,
                  let data = data else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let accountResponse = try decoder.decode(AccountResponse.self, from: data)
                let account = accountResponse.data[0]
                completion(.success(account))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func buyCrypto(amount: String, currency: String, completion: @escaping (Result<Transaction, Error>) -> Void) {
        guard let url = URL(string: baseURL + "accounts/" + Constants.accountID + "/buys") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer " + AuthenticationManager.shared.accessToken, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["amount": amount, "currency": currency]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        let task = session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  response.statusCode == 201,
                  let data = data else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let transactionResponse = try decoder.decode(TransactionResponse.self, from: data)
                let transaction = transactionResponse.data
                completion(.success(transaction))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
}
