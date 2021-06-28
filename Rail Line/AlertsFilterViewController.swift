import UIKit

protocol FilterChangedDelegate: AnyObject {
    func filterChanged(selectedRoutes: Set<String>)
}

class AlertsFilterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private weak var delegate: FilterChangedDelegate?
    private let tableView = UITableView()
    private var selected = Set<String>()

    private static let reuseIdentifier = "AlertsFilterViewControllerCell"

    override func viewDidLoad() {
        view.backgroundColor = Colors.white
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(self.additionalSafeAreaInsets.bottom)
            make.width.equalTo(self.view.snp.width)
        }

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: AlertsFilterViewController.reuseIdentifier)

        navigationItem.title = "Filter"
        let clearButton = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(clear(_:)))
        navigationItem.setLeftBarButton(clearButton, animated: false)
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(done(_:)))
        navigationItem.setRightBarButton(doneButton, animated: false)
    }

    @objc func clear(_ sender: Any) {
        selected.removeAll()
        tableView.reloadData()
    }

    @objc func done(_ sender: Any) {
        delegate?.filterChanged(selectedRoutes: selected)
    }

    func set(delegate: FilterChangedDelegate) {
        self.delegate = delegate
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Routes.names.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: AlertsFilterViewController.reuseIdentifier) {
            let route = Routes.names[indexPath.row]
            cell.textLabel?.text = route
            cell.textLabel?.textColor = Routes.colors[route]
            cell.accessoryType = selected.contains(route) ? .checkmark : .none
            return cell
        }
        fatalError()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let route = Routes.names[indexPath.row]
        if selected.contains(route) {
            selected.remove(route)
        } else {
            selected.insert(route)
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
