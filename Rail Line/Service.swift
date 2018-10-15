import UIKit

class Service {
    var name = ""
    private var type = ""
    private var color = ""

    func nameAppend(_ string: String) {
        name.append(contentsOf: string)
    }

    func typeAppend(_ string: String) {
        type.append(contentsOf: string)
    }

    func colorAppend(_ string: String) {
        color.append(contentsOf: string)
    }

    func typeIsTrain() -> Bool {
        return type.contains("Train")
    }

    func getColor() -> UIColor {
        if color.count != 6 { return Colors.black }

        var rgbValue: UInt32 = 0
        Scanner(string: color).scanHexInt32(&rgbValue)

        let red = CGFloat((rgbValue & 0xFF0000) >> 16)
        let green = CGFloat((rgbValue & 0x00FF00) >> 8)
        let blue = CGFloat(rgbValue & 0x0000FF)

        return UIColor(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: 1.0)
    }
}
