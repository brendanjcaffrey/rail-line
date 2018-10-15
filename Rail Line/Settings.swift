import UIKit

class Settings {
    private static let key = "favorites"
    private static var list = { () -> [Int] in
        if let list = UserDefaults.standard.object(forKey: key) {
            return list as? [Int] ?? []
        } else {
            return []
        }
    }()

    static func verifyOnStartup() {
        list = list.filter { CTA.stations[$0] != nil }
        persistList()
    }

    static func isFavorited(_ stationId: Int) -> Bool {
        return list.contains(stationId)
    }

    static func favorites() -> [Int] {
        return list
    }

    static func toggle(_ stationId: Int) {
        if isFavorited(stationId) {
            list.remove(at: list.firstIndex(of: stationId)!)
        } else {
            list.append(stationId)
        }
        persistList()
    }

    private static func persistList() {
        UserDefaults.standard.setValue(list, forKey: key)
        let shortcuts = list.prefix(4).map {
            let station = CTA.stations[$0]!
            let icon = UIApplicationShortcutIcon(type: .favorite)
            return UIApplicationShortcutItem(type: String($0), localizedTitle: station.name, localizedSubtitle: "", icon: icon, userInfo: [:])
        } as [UIApplicationShortcutItem]
        UIApplication.shared.shortcutItems = shortcuts
    }
}
