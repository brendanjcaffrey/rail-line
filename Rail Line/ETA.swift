import Foundation

class ETA {
    private var destination = ""
    private var route = ""
    private var approaching = ""
    private var arrival = ""
    private var generated = ""
    private var time: Double?
    private static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd HH:mm:ss"
        formatter.timeZone = NSTimeZone.local
        return formatter
    }()

    func destAppend(_ val: String) {
        destination.append(contentsOf: val)

        if destination == "O'Hare" || destination == "Midway" {
            destination.append(contentsOf: " ✈️")
        }
    }

    func rtAppend(_ val: String) {
        route.append(contentsOf: val)
    }
    func appAppend(_ val: String) {
        approaching.append(contentsOf: val)
    }

    func arrAppend(_ val: String) {
        arrival.append(contentsOf: val)
    }

    func prdAppend(_ val: String) {
        generated.append(contentsOf: val)
    }

    func getRoute() -> String {
        return Routes.mapCode(route)
    }

    func getDestination() -> String {
        return destination
    }

    func getTime() -> Double {
        if time == nil {
            if approaching == "1" {
                time = 0.0
            } else {
                let arrivalDate = ETA.formatter.date(from: arrival)
                let generatedDate = ETA.formatter.date(from: generated)
                time = arrivalDate!.timeIntervalSince(generatedDate!)
            }
        }
        return time!
    }

    func getTimeString() -> String {
        let minutes = Int(getTime() / 60.0)
        if approaching == "1" || minutes < 1 { return "Due" }
        return "\(minutes) min\(minutes == 1 ? "" : "s")"
    }
}

func < (lhs: ETA, rhs: ETA) -> Bool {
    return lhs.getTime() < rhs.getTime()
}

func == (lhs: ETA, rhs: ETA) -> Bool {
    return lhs.getTime() == rhs.getTime()
}
