import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let authManager = AuthenticationManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Set up authentication manager with Coinbase API credentials
        authManager.setCoinbaseAPICredentials(apiKey: "Ba6DEkGrqrB4M8uY",
                                              apiSecret: "ICVK2n2Kl5WBQCFMzZONp2NzGG5hdcBg",
                                              redirectURI: "myapp://auth/callback")
        
        // Check if user is already authenticated, and show appropriate screen
        let isUserAuthenticated = authManager.isUserAuthenticated()
        let rootVC = isUserAuthenticated ? InvestmentPlanView() : AuthenticationView()
        let navigationController = UINavigationController(rootViewController: rootVC)
        
        // Set up window and root view controller
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }
}
