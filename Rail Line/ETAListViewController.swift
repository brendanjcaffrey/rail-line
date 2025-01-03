import UIKit
import IoniconsKit

protocol SettingsChangedDelegate: AnyObject {
    func settingsChanged()
}

class ETAListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private let station: Station
    private weak var delegate: SettingsChangedDelegate?
    private var notification: NSObjectProtocol?
    private let tableView = UITableView()
    private let refreshControl = UIRefreshControl()
    private var firstLoad = true
    private var etas: [ETA] = []

    private static let emptyIdentifier = "ETAListViewControllerCellEmpty"
    private static let reuseIdentifier = "ETAListViewControllerCell"

    init(station: Station, delegate: SettingsChangedDelegate) {
        self.station = station
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = station.name

        view.backgroundColor = UIColor.systemBackground
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(self.additionalSafeAreaInsets.bottom)
            make.width.equalTo(self.view.snp.width)
        }

        tableView.dataSource = self
        tableView.delegate = self
        tableView.refreshControl = refreshControl
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: ETAListViewController.emptyIdentifier)
        tableView.register(ETACell.classForCoder(), forCellReuseIdentifier: ETAListViewController.reuseIdentifier)

        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        refreshControl.tintColor = Colors.cyan

        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .never

        updateStarButton()
        refresh()
    }

    override func viewDidAppear(_ animated: Bool) {
        notification = NotificationCenter.default.addObserver(forName:
            UIApplication.willEnterForegroundNotification, object: nil, queue: .main) { _ in self.refresh() }
    }

    override func viewWillDisappear(_ animated: Bool) {
        if let notification = notification {
            NotificationCenter.default.removeObserver(notification)
        }
        notification = nil
    }

    @objc func refresh(_ sender: Any) {
        refresh()
    }

    @objc func toggle(_ sender: Any) {
        toggle()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if firstLoad { return 0 }
        return [1, etas.count].max()!
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if etas.isEmpty {
            if let cell = tableView.dequeueReusableCell(withIdentifier: ETAListViewController.emptyIdentifier) {
                cell.textLabel?.text = "No upcoming arrivals"
                cell.selectionStyle = .none
                return cell
            }
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: ETAListViewController.reuseIdentifier) as? ETACell {
                cell.update(eta: etas[indexPath.row])
                return cell
            }
        }
        fatalError()
    }

    private func updateStarButton() {
        let icon = Settings.isFavorited(station.id) ? Ionicons.iosStar : Ionicons.iosStarOutline
        let sizeDim = 25
        let size = CGSize(width: sizeDim, height: sizeDim)
        let image = UIImage.ionicon(with: icon, textColor: Colors.cyan, size: size)
        let highlightImage = UIImage.ionicon(with: icon, textColor: Colors.fadedCyan, size: size)

        let button = UIButton(type: .custom)
        button.setImage(image, for: .normal)
        button.setImage(highlightImage, for: .highlighted)
        button.addTarget(self, action: #selector(toggle(_:)), for: .touchUpInside)

        let barButton = UIBarButtonItem(customView: button)
        navigationItem.setRightBarButton(barButton, animated: true)
    }

    private func toggle() {
        Settings.toggle(station.id)
        updateStarButton()
        delegate?.settingsChanged()
    }

    private func refresh() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }

            self.etas = APIClient.getETAs(stationId: self.station.id)

            DispatchQueue.main.async { [weak self] in
                self?.firstLoad = false
                self?.tableView.reloadData()
                self?.refreshControl.endRefreshing()
            }
        }
    }
}
