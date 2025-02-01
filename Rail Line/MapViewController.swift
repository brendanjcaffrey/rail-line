import UIKit
import MapKit

class StationAnnotation: MKPointAnnotation {
    var stationId: Int = 0
}

class MapViewController: UIViewController, MKMapViewDelegate {
    private weak var delegate: SettingsChangedDelegate?
    private let route: String
    private let stations: [Station]
    private let color: UIColor
    private let mapView = MKMapView()

    private static let reuseIdentifier = "MapViewAnnotationView"

    init(route: String, delegate: SettingsChangedDelegate) {
        self.route = route
        self.stations = Routes.getRouteStations(route).map { CTA.stations[$0]! }
        self.color = Routes.colors[route] ?? UIColor.systemGray
        self.delegate = delegate

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: MapViewController.reuseIdentifier)

        title = route + (Routes.colors[route] != nil ? " Line" : " Lines")
        view.addSubview(mapView)
        mapView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(self.additionalSafeAreaInsets.bottom)
            make.width.equalTo(self.view.snp.width)
        }

        setCenterPoint()
        addAnnotations()
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !annotation.isMember(of: StationAnnotation.self) { return nil }

        if let pinView = mapView.dequeueReusableAnnotationView(withIdentifier: MapViewController.reuseIdentifier) {
            pinView.annotation = annotation
            (pinView as? MKMarkerAnnotationView)?.markerTintColor = color
            pinView.canShowCallout = true
            pinView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            return pinView
        }
        fatalError()
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let stationId = (view.annotation as? StationAnnotation)?.stationId, let station = CTA.stations[stationId] {
            let etaList = ETAListViewController(station: station, delegate: delegate!)
            navigationController!.pushViewController(etaList, animated: true)
        }
    }

    private func setCenterPoint() {
        let (latCenter, latScale) = findCenterAndScale(stations.map { $0.latitude })
        let (lonCenter, lonScale) = findCenterAndScale(stations.map { $0.longitude })

        let center = CLLocationCoordinate2DMake(latCenter, lonCenter)
        let scale = MKCoordinateSpan(latitudeDelta: latScale, longitudeDelta: lonScale)
        mapView.setRegion(MKCoordinateRegion(center: center, span: scale), animated: false)
    }

    private func findCenterAndScale(_ points: [Double]) -> (Double, Double) {
        let min = points.min()!
        let max = points.max()!

        let center = (min + max) / 2.0
        let scale  = (max - min) * 1.25

        return (center, scale)
    }

    private func addAnnotations() {
        for station in stations {
            let annotation = StationAnnotation()
            annotation.coordinate = CLLocationCoordinate2DMake(station.latitude, station.longitude)
            annotation.title = station.title
            annotation.subtitle = station.subtitle
            annotation.stationId = station.id
            mapView.addAnnotation(annotation)
        }
    }
}
