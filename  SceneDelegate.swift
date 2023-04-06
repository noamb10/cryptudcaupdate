import UIKit

class AuthenticationManager: ObservableObject {
    // your code here
}

    var window: UIWindow?
    let authenticationManager = AuthenticationManager()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Create a new window and set it as the root view controller
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        self.window = window

        let contentView = ContentView().environmentObject(authenticationManager)
        window.rootViewController = UIHostingController(rootView: contentView)
        window.makeKeyAndVisible()

        // Check if the user is already authenticated
        if authenticationManager.isAuthenticated {
            authenticationManager.refreshAccessToken()
        }
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        // Handle the redirect URI from Coinbase OAuth
        if let url = URLContexts.first?.url {
            authenticationManager.handleRedirectURI(url: url)
        }
    }
}
