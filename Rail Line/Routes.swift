import UIKit

class Routes {
    static let codes = [
        "Blue": "Blue",
        "Brn": "Brown",
        "G": "Green",
        "Org": "Orange",
        "Pink": "Pink",
        "P": "Purple",
        "Pexp": "Purple Express",
        "Red": "Red",
        "Y": "Yellow"
    ]

    static let colors = [
        "Blue": UIColor(red: 0.0 / 255.0, green: 161.0 / 255.0, blue: 223.0 / 255.0, alpha: 1.0),
        "Brown": UIColor(red: 98.0 / 255.0, green: 54.0 / 255.0, blue: 27.0 / 255.0, alpha: 1.0),
        "Green": UIColor(red: 0.0 / 255.0, green: 155.0 / 255.0, blue: 58.0 / 255.0, alpha: 1.0),
        "Orange": UIColor(red: 249.0 / 255.0, green: 71.0 / 255.0, blue: 28.0 / 255.0, alpha: 1.0),
        "Pink": UIColor(red: 226.0 / 255.0, green: 126.0 / 255.0, blue: 166.0 / 255.0, alpha: 1.0),
        "Purple": UIColor(red: 82.0 / 255.0, green: 35.0 / 255.0, blue: 152.0 / 255.0, alpha: 1.0),
        "Purple Express": UIColor(red: 82.0 / 255.0, green: 35.0 / 255.0, blue: 152.0 / 255.0, alpha: 1.0),
        "Red": UIColor(red: 198.0 / 255.0, green: 12.0 / 255.0, blue: 48.0 / 255.0, alpha: 1.0),
        "Yellow": UIColor(red: 249.0 / 255.0, green: 227.0 / 255.0, blue: 0.0 / 255.0, alpha: 1.0)
    ]

    static let names = Array(Routes.colors.keys).sorted()

    static func mapCode(_ code: String) -> String {
        if let val = codes[code] { return val }
        return code // just in case
    }

    static func mapColor(_ code: String) -> UIColor {
        if let val = colors[mapCode(code)] { return val }
        return UIColor.black // just in case
    }

    static func getRouteStations(_ name: String) -> [Int] {
        switch name {
        case "Blue": return CTA.blueLineStations
        case "Brown": return CTA.brownLineStations
        case "Green": return CTA.greenLineStations
        case "Orange": return CTA.orangeLineStations
        case "Pink": return CTA.pinkLineStations
        case "Purple": return CTA.purpleLineStations
        case "Red": return CTA.redLineStations
        case "Yellow": return CTA.yellowLineStations
        case "Purple Express": return CTA.purpleExpressLineStations
        default: return Array(CTA.stations.keys)
        }
    }
}
