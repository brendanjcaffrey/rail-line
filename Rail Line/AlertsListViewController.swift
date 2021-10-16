import UIKit
import SafariServices

class AlertsListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FilterChangedDelegate {
    private let tableView = UITableView()
    private let refreshControl = UIRefreshControl()
    private let filterButton = UIBarButtonItem(title: "Filter", style: .plain, target: nil, action: nil)
    private let filterViewController = AlertsFilterViewController()

    private var firstLoad = true
    private var selectedRoutes = Set<String>()
    private var alerts: [Alert] = []
    private var filteredAlerts: [Alert] = []

    private static let emptyIdentifier = "AlertsListViewControllerCellEmpty"
    private static let reuseIdentifier = "AlertsListViewControllerCell"
    private static let normalFont = UIFont.systemFont(ofSize: UIFont.systemFontSize)
    private static let smallFont = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Alerts"

        view.backgroundColor = UIColor.systemBackground
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(self.additionalSafeAreaInsets.bottom)
            make.width.equalTo(self.view.snp.width)
        }

        tableView.dataSource = self
        tableView.delegate = self
        tableView.refreshControl = refreshControl
        filterViewController.set(delegate: self)

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: AlertsListViewController.emptyIdentifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: AlertsListViewController.reuseIdentifier)

        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        refreshControl.tintColor = Colors.cyan

        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .never

        filterButton.target = self
        filterButton.action = #selector(filter(_:))
        navigationItem.setRightBarButton(filterButton, animated: false)

        refresh()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let path = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: path, animated: true)
        }
    }

    @objc func refresh(_ sender: Any) {
        refresh()
    }

    @objc func filter(_ sender: Any) {
        filter()
    }

    func filterChanged(selectedRoutes: Set<String>) {
        self.selectedRoutes = selectedRoutes
        applyFilter()
        tableView.reloadData()

        var buttonString = "Filter"
        if !selectedRoutes.isEmpty { buttonString += " (\(selectedRoutes.count))" }
        filterButton.title = buttonString

        dismiss(animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if firstLoad { return 0 }
        return [1, filteredAlerts.count].max()!
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if filteredAlerts.isEmpty {
            if let cell = tableView.dequeueReusableCell(withIdentifier: AlertsListViewController.emptyIdentifier) {
                cell.textLabel?.text = "No alerts"
                return cell
            }
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: AlertsListViewController.reuseIdentifier) {
                cell.textLabel?.numberOfLines = 0
                cell.textLabel?.attributedText = getAlertText(filteredAlerts[indexPath.row])
                return cell
            }
        }
        fatalError()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let url = URL(string: filteredAlerts[indexPath.row].url)!
        let safari = SFSafariViewController(url: url)
        present(safari, animated: true, completion: nil)
    }

    private func refresh() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }

            self.alerts = APIClient.getAlerts()
            self.applyFilter()

            DispatchQueue.main.async { [weak self] in
                self?.firstLoad = false
                self?.tableView.reloadData()
                self?.refreshControl.endRefreshing()
            }
        }
    }

    private func filter() {
        present(UINavigationController(rootViewController: filterViewController), animated: true, completion: nil)
    }

    private func applyFilter() {
        if selectedRoutes.isEmpty {
            filteredAlerts = alerts
            return
        }

        filteredAlerts = alerts.filter { (alert) in
            selectedRoutes.contains(where: { (routeName) -> Bool in
                alert.services.contains(where: { (service) -> Bool in
                    service.name.contains(routeName)
                })
            })
        }
    }

    private func getAlertText(_ alert: Alert) -> NSAttributedString {
        let text = NSMutableAttributedString(string: alert.description, attributes: [
            NSAttributedString.Key.font: AlertsListViewController.normalFont
        ])

        let smallText = "\n\n\(alert.startString()) - \(alert.endString())\nAffects:"
        text.append(NSAttributedString(string: smallText, attributes: [
            NSAttributedString.Key.font: AlertsListViewController.smallFont
        ]))

        for (index, service) in alert.services.enumerated() {
            text.append(NSAttributedString(string: connectorText(index: index, total: alert.services.count), attributes: [
                NSAttributedString.Key.font: AlertsListViewController.smallFont
            ]))
            text.append(NSAttributedString(string: service.name, attributes: [
                NSAttributedString.Key.font: AlertsListViewController.smallFont,
                NSAttributedString.Key.foregroundColor: service.getColor()
            ]))
        }

        return text
    }

    private func connectorText(index: Int, total: Int) -> String {
        if index == 0 { return " " }
        if index == total - 1 { return " and " }
        return ", "
    }
}
