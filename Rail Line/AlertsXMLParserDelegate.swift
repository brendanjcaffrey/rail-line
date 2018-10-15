import UIKit

class AlertsXMLParserDelegate: UIViewController, XMLParserDelegate {
    var last = ""
    var alert = Alert()
    var service = Service()
    var alerts: [Alert] = []

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String] = [:]) {
        last = elementName

        switch elementName {
        case "Alert":   alert = Alert()
        case "Service": service = Service()
        default:        break
        }
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        switch elementName {
        case "Alert":   alerts.append(alert)
        case "Service": alert.addService(service)
        default:        break
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch last {
        case "ShortDescription":       alert.descriptionAppend(string)
        case "AlertURL":               alert.urlAppend(string)
        case "EventStart":             alert.startAppend(string)
        case "EventEnd":               alert.endAppend(string)
        case "ServiceName":            service.nameAppend(string)
        case "ServiceTypeDescription": service.typeAppend(string)
        case "ServiceBackColor":       service.colorAppend(string)
        default:                       break
        }
    }
}
