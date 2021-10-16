import UIKit

class ArrivalXMLParserDelegate: UIViewController, XMLParserDelegate {
    private var last: String = ""
    private var eta: ETA?
    private var etas: [ETA] = []

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String] = [:]) {
        last = elementName

        if last == "eta" {
            if eta != nil { etas.append(eta!) }
            eta = ETA()
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch last {
        case "destNm": eta?.destAppend(string)
        case "rt":     eta?.rtAppend(string)
        case "isApp":  eta?.appAppend(string)
        case "arrT":   eta?.arrAppend(string)
        case "prdt":   eta?.prdAppend(string)
        default:       break
        }
    }

    func getAllETAs() -> [ETA] {
        if let eta = eta { etas.append(eta) }
        eta = nil
        return etas
    }
}
