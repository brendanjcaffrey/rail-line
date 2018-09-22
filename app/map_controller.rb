class StationAnnotation < MKPointAnnotation
  attr_accessor :station_id
end

class MapController < UIViewController
  include ManualConstraintHelper

  def init_with_stations(stations, line, eta_delegate)
    @stations     = stations
    @reuse        = 'CustomPinAnnotationView'
    @eta_delegate = eta_delegate

    if Colors.route_colors.has_key?(line)
      @color = Colors.route_colors[line]
    else
      @color = UIColor.lightGrayColor
    end

    setTitle(line)

    init
  end

  def loadView
    super

    @map = MKMapView.new
    @map.delegate = self
    @map.translatesAutoresizingMaskIntoConstraints = false
    @map.showsUserLocation = true
    view.addSubview(@map)
    view.backgroundColor = UIColor.whiteColor

    @top_constraint = build_constraint(NSLayoutAttributeTop, @map)
    @height_constraint = build_constraint(NSLayoutAttributeHeight, @map)
    left_constraint = build_constraint(NSLayoutAttributeLeft, @map)
    width_constraint = build_constraint(NSLayoutAttributeWidth, @map)
    NSLayoutConstraint.activateConstraints([
      @top_constraint, @height_constraint, left_constraint, width_constraint
    ])

    set_center_point
    add_annotations
  end

  def mapView(map, viewForAnnotation: annotation)
    return nil unless annotation.is_a?(StationAnnotation)

    pin_view = map.dequeueReusableAnnotationViewWithIdentifier(@reuse)
    if pin_view.nil?
      pin_view = ZSPinAnnotation.alloc.initWithAnnotation(annotation, reuseIdentifier: @reuse)
      pin_view.annotationType = ZSPinAnnotationTypeDisc
      pin_view.annotationColor = @color
      pin_view.canShowCallout = true
      button = UIButton.buttonWithType(UIButtonTypeDetailDisclosure)
      pin_view.rightCalloutAccessoryView = button
    else
      pin_view.annotation = annotation
    end

    pin_view
  end

  def mapView(map, annotationView: view, calloutAccessoryControlTapped: control)
    station = CTAInfo.stations[view.annotation.station_id]
    eta_list = ETAListViewController.alloc.init_with_station(station, @eta_delegate)
    navigationController.pushViewController(eta_list, animated: true)
  end

  private

  def set_center_point
    lat_center, lat_scale = find_center_and_scale(@stations.map(&:latitude))
    lon_center, lon_scale = find_center_and_scale(@stations.map(&:longitude))

    center = CLLocationCoordinate2DMake(lat_center, lon_center)
    scale  = MKCoordinateSpanMake(lat_scale, lon_scale)
    @map.setRegion(MKCoordinateRegionMake(center, scale))
  end

  def find_center_and_scale(points)
    min = points.min
    max = points.max

    center = (min + max) / 2.0
    scale  = (max - min) * 1.25

    [center, scale]
  end

  def add_annotations
    @stations.each do |station|
      annotation = StationAnnotation.alloc.init
      annotation.coordinate = CLLocationCoordinate2DMake(station.latitude, station.longitude)
      annotation.title = station.title
      annotation.subtitle = station.subtitle
      annotation.station_id = station.id
      @map.addAnnotation(annotation)
    end
  end
end
