import UIKit

class Alert {
    var description = ""
    var url = ""
    var services: [Service] = []

    private var start = ""
    private var end = ""
    private var cachedStartDate: Date?
    private var cachedEndDate: Date?

    private static let dateOnlyParser: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        formatter.timeZone = NSTimeZone.local
        return formatter
    }()
    private static let dateTimeParser: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd HH:mm"
        formatter.timeZone = NSTimeZone.local
        return formatter
    }()
    private static let dateTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "M/d ha"
        formatter.timeZone = NSTimeZone.local
        return formatter
    }()
    private static let dateOnlyFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "M/d"
        formatter.timeZone = NSTimeZone.local
        return formatter
    }()

    func descriptionAppend(_ string: String) {
        description.append(contentsOf: string)
    }

    func urlAppend(_ string: String) {
        url.append(contentsOf: string)
    }

    func startAppend(_ string: String) {
        start.append(contentsOf: string)
    }

    func endAppend(_ string: String) {
        end.append(contentsOf: string)
    }

    func addService(_ service: Service) {
        services.append(service)
    }

    func affectsTrains() -> Bool {
        return services.contains { $0.typeIsTrain() }
    }

    func startString() -> String {
        let now = Date()
        if startDate() <= now && endDate() >= now { return "Now" }

        return dateToString(startDate(), strLength: start.count, forEmpty: "Now")
    }

    func endString() -> String {
        return dateToString(endDate(), strLength: end.count, forEmpty: "TBD")
    }

    private func convertDate(_ dateStr: String) -> Date {
        if dateStr.count == "YYYYMMDD".count {
            return Alert.dateOnlyParser.date(from: dateStr) ?? Date()
        } else if dateStr.count == "YYYYMMDD HH:MM".count {
            return Alert.dateTimeParser.date(from: dateStr) ?? Date()
        } else {
            return Date()
        }
    }

    private func dateToString(_ date: Date, strLength: Int, forEmpty: String) -> String {
        if strLength == "YYYYMMDD".count {
            return Alert.dateOnlyFormatter.string(from: date)
        } else if strLength == "YYYYMMDD HH:MM".count {
            return Alert.dateTimeFormatter.string(from: date)
        } else {
            return forEmpty
        }
    }

    private func startDate() -> Date {
        if cachedStartDate == nil { cachedStartDate = convertDate(start) }
        return cachedStartDate ?? Date()
    }

    private func endDate() -> Date {
        if cachedEndDate == nil { cachedEndDate = convertDate(end) }
        return cachedEndDate ?? Date()
    }
}
