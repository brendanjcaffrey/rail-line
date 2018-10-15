import UIKit
import MapKit

class MapLineSelectionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private weak var delegate: SettingsChangedDelegate?
    private let manager = CLLocationManager()
    private let tableView = UITableView()

    private static let reuseIdentifier = "MapLineSelectionViewCell"

    init(delegate: SettingsChangedDelegate) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        title = "Select Line"

        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(self.additionalSafeAreaInsets.bottom)
            make.width.equalTo(self.view.snp.width)
        }

        manager.requestWhenInUseAuthorization()

        navigationController!.view.backgroundColor = Colors.white
        navigationController!.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .never

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: MapLineSelectionViewController.reuseIdentifier)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let path = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: path, animated: true)
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : Routes.names.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: MapLineSelectionViewController.reuseIdentifier) {
            if indexPath.section == 0 {
                cell.textLabel?.text = "All"
                cell.textLabel?.textColor = Colors.black
            } else {
                cell.textLabel?.text = Routes.names[indexPath.row]
                cell.textLabel?.textColor = Routes.colors[Routes.names[indexPath.row]]
            }
            return cell
        }
        fatalError()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let route = indexPath.section == 0 ? "All" : Routes.names[indexPath.row]
        navigationController?.pushViewController(MapViewController(route: route, delegate: delegate!), animated: true)
    }
}
