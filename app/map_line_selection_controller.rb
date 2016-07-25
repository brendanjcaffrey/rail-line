class MapLineSelectionController < UIViewController
  include ControllerConstraintHelper

  def init_with_eta_delegate(eta_delegate)
    @eta_delegate = WeakRef.new(eta_delegate)
    init
  end

  def loadView
    @routes = Colors.route_colors.keys
    @reuse = 'MapLineSelectionCell'

    @layout = TableLayout.new
    self.view = @layout.view
    @table = @layout.table
    @table.delegate = @table.dataSource = self
    self.automaticallyAdjustsScrollViewInsets = false

    navigationItem.setTitle('Select Line')
    @manager = CLLocationManager.new
    @manager.requestWhenInUseAuthorization
  end

  def viewWillAppear(animated)
    path = @table.indexPathForSelectedRow
    @table.deselectRowAtIndexPath(path, animated: true) if path

    # no idea why this is needed but ¯\_(ツ)_/¯
    Dispatch::Queue.main.async { @layout.update_constraint(self) }
  end

  def numberOfSectionsInTableView(table)
    2
  end

  def tableView(table, numberOfRowsInSection: section)
    section == 0 ? 1 : @routes.count
  end

  def tableView(table, cellForRowAtIndexPath: path)
    cell = table.dequeueReusableCellWithIdentifier(@reuse)
    cell = UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier: @reuse) if cell.nil?

    if path.section == 0
      cell.textLabel.text = 'All'
      cell.textLabel.color = UIColor.blackColor
    else
      route = @routes[path.row]
      cell.textLabel.text = route
      cell.textLabel.color = Colors.route_colors[route]
    end

    cell
  end

  def tableView(table, didSelectRowAtIndexPath: path)
    stations = CTAInfo.stations.values
    line = 'All'

    if path.section == 1
      line = @routes[path.row]
      filter = line.downcase.to_sym # Blue => :blue
      stations = stations.select { |station| station.send(filter) }
    end

    map = MapController.alloc.init_with_stations(stations, line, @eta_delegate)
    navigationController.pushViewController(map, animated: true)
  end
end
