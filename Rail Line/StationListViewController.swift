import UIKit
import SnapKit

class StationListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, SettingsChangedDelegate {
    private let tableView = UITableView()
    private let searchController = UISearchController(searchResultsController: nil)
    private var allStations: [Station] = []
    private var stations: [[Station]] = []
    private var sectionTitles: [String] = []
    private var filterText = ""

    private static let reuseIdentifier = "StationListViewControllerCell"

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Stations"
        definesPresentationContext = true

        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false

        view.backgroundColor = Colors.white
        searchController.searchBar.tintColor = Colors.cyan
        tableView.tintColor = Colors.cyan

        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(self.additionalSafeAreaInsets.bottom)
            make.width.equalTo(self.view.snp.width)
        }

        let mapButton = UIBarButtonItem(title: "Map", style: .plain, target: self, action: #selector(map(_:)))
        let alertsButton = UIBarButtonItem(title: "Alerts", style: .plain, target: self, action: #selector(alerts(_:)))
        navigationItem.setLeftBarButton(mapButton, animated: false)
        navigationItem.setRightBarButton(alertsButton, animated: false)

        searchController.searchResultsUpdater = self
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: StationListViewController.reuseIdentifier)

        allStations = Array(CTA.stations.values).sorted { $0.name.compare($1.name) == .orderedAscending }
        generateStationGroups()
    }

    @objc func map(_ sender: Any) {
        navigationController?.pushViewController(MapLineSelectionViewController(delegate: self), animated: true)
    }

    @objc func alerts(_ sender: Any) {
        navigationController?.pushViewController(AlertsListViewController(), animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let path = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: path, animated: true)
        }

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }

    func forceShow(_ stationId: Int) {
        if let station = CTA.stations[stationId] {
            navigationController?.popToRootViewController(animated: false)
            let etaList = ETAListViewController(station: station, delegate: self)
            navigationController?.pushViewController(etaList, animated: false)
        }
    }

    func updateSearchResults(for searchController: UISearchController) {
        filterText = searchController.searchBar.text!.lowercased()
        generateStationGroups()
        tableView.reloadData()
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchController.searchBar.resignFirstResponder()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return stations.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stations[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: StationListViewController.reuseIdentifier) {
            cell.textLabel?.text = stations[indexPath.section][indexPath.row].name
            return cell
        }
        fatalError()
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }

    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sectionTitles
    }

    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return sectionTitles.firstIndex(of: title)!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let station = stations[indexPath.section][indexPath.row]
        navigationController?.pushViewController(ETAListViewController(station: station, delegate: self), animated: true)
    }

    func settingsChanged() {
        generateStationGroups()
    }

    private func grouping(_ name: String) -> String {
        return name.first! >= "0" && name.first! <= "9" ? "#" : String(name.first!)
    }

    private func getFilteredStations() -> [Station] {
        if filterText.isEmpty { return allStations }
        let filterWords = filterText.split(separator: " ")
        return allStations.filter { station in
            filterWords.allSatisfy { word in
                station.name.lowercased().contains(word)
            }
        }
    }

    private func generateStationGroups() {
        var groupedList: [String: [Station]]
        groupedList = Dictionary(grouping: getFilteredStations(), by: { grouping($0.name) })
        stations = Array(groupedList.values).sorted { $0[0].name.compare($1[0].name) == .orderedAscending }
        sectionTitles = Array(groupedList.keys).sorted()

        let favorites = Settings.favorites()
        if filterText.isEmpty && !favorites.isEmpty {
            stations.insert(favorites.map { CTA.stations[$0]! }, at: 0)
            sectionTitles.insert("★", at: 0)
        }

        tableView.reloadData()
    }
}
