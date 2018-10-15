import Foundation

class APIClient {
    static func getETAs(stationId: Int) -> [ETA] {
        let url = "http://lapi.transitchicago.com/api/1.0/ttarrivals.aspx?key=\(Secrets.apiKey)&mapid=\(stationId)"
        let delegate = ArrivalXMLParserDelegate()
        let parser = XMLParser(contentsOf: URL(string: url)!)
        parser!.delegate = delegate
        parser!.parse()

        return delegate.etas.sorted(by: { $0 < $1 })
    }

    static func getAlerts() -> [Alert] {
        let url = "http://www.transitchicago.com/api/1.0/alerts.aspx"
        let delegate = AlertsXMLParserDelegate()
        let parser = XMLParser(contentsOf: URL(string: url)!)
        parser!.delegate = delegate
        parser!.parse()

        // only show alerts that affect trains and don't show ones with identical descriptions
        var descriptions: Set<String> = Set()
        return delegate.alerts.filter { $0.affectsTrains() }.filter {
            if descriptions.contains($0.description) { return false }
            descriptions.insert($0.description)
            return true
        }
    }
}
