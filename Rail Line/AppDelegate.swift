import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    private var launchItem: UIApplicationShortcutItem?
    private var stationListController: StationListViewController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Settings.verifyOnStartup()

        stationListController = StationListViewController()
        let navController = UINavigationController(rootViewController: stationListController!)

        window = UIWindow(frame: UIScreen.main.bounds)
        window!.rootViewController = navController
        window!.makeKeyAndVisible()

        UINavigationBar.appearance().tintColor = Colors.cyan // nav bar buttons color
        UILabel.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self]).textColor = Colors.cyan // table section headers color

        launchItem = launchOptions?[UIApplication.LaunchOptionsKey.shortcutItem] as? UIApplicationShortcutItem

        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        if launchItem == nil { return }

        handleShortcutItem(launchItem!)
        launchItem = nil
    }

    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        completionHandler(handleShortcutItem(shortcutItem))
    }

    @discardableResult func handleShortcutItem(_ item: UIApplicationShortcutItem) -> Bool {
        stationListController?.forceShow(Int(item.type)!)
        return true
    }
}
