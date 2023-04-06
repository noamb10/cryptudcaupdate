import Foundation
import CryptoKit
import SwiftUI

class AuthenticationManager: ObservableObject {
    static let shared = AuthenticationManager()
    private let keychain = Keychain()
    
    private let baseURL = "https://api.coinbase.com/v2"
    private let clientID = "Ba6DEkGrqrB4M8uY"
    private let clientSecret = "ICVK2n2Kl5WBQCFMzZONp2NzGG5hdcBg"
    private let redirectURI = "myapp://auth/callback"
    private let scopes = ["wallet:accounts:read", "wallet:buys:read", "wallet:buys:create", "wallet:sells:read", "wallet:sells:create", "wallet:transactions:read", "wallet:transactions:send", "wallet:payment-methods:read", "wallet:user:read"]
    
    @Published var isAuthenticated: Bool {
        didSet {
            // When the authentication status changes, clear the keychain if necessary
            if !isAuthenticated {
                accessToken = nil
            }
        }
    }
    
    private var accessToken: String? {
        get {
            return keychain["access_token"]
        }
        set {
            keychain["access_token"] = newValue
        }
    }
    
    init() {
        isAuthenticated = accessToken != nil
    }
    
    func authenticate(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/oauth/authorize?response_type=code&client_id=\(clientID)&redirect_uri=\(redirectURI)&scope=\(scopes.joined(separator: ","))") else {
            completion(.failure(AuthenticationError.invalidURL))
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    func handleRedirectURL(_ url: URL, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let code = extractCode(from: url) else {
            completion(.failure(AuthenticationError.missingCode))
            return
        }
        exchangeCodeForAccessToken(code: code, completion: completion)
    }
    
    private func extractCode(from url: URL) -> String? {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
              let queryItems = components.queryItems,
              let codeItem = queryItems.first(where: { $0.name == "code" }),
              let code = codeItem.value else {
            return nil
        }
        return code
    }
    
    private func exchangeCodeForAccessToken(code: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let body = [
            "grant_type": "authorization_code",
            "code": code,
            "client_id": clientID,
            "client_secret": clientSecret,
            "redirect_uri": redirectURI
        ]
        makeRequest(path: "/oauth/token", method: .post, body: body) { result in
            switch result {
            case .success(let data):
                guard let token = try? JSONDecoder().decode(AccessTokenResponse.self, from: data) else {
                    completion(.failure(AuthenticationError.invalidResponse))
                    return
                }
                self.accessToken = token.accessToken
                self.isAuthenticated = true
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func makeRequest(path: String, method: HttpMethod, body:
