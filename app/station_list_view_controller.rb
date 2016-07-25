class StationListViewController < UIViewController
  include ControllerConstraintHelper

  def loadView
    @layout = StationListLayout.new
    self.view = @layout.view

    @table = @layout.table
    @table.delegate = @table.dataSource = self
    setAutomaticallyAdjustsScrollViewInsets(false)

    @filter_text = ''
    @numbers = ('0'..'9')
    # sort puts numbers at the top, so we have to do this to replicate the ios default sort
    @stations = CTAInfo.stations.values.
      # split into two groups - not numbers and numbers
      partition { |station| !@numbers.include?(station.name[0]) }.
      # sort those groups by name then join together
      map { |group| group.sort_by!(&:name) }.flatten

    @reuse = 'StationCell'
    navigationItem.setTitle('Stations')
    generate_station_groups

    @search = @layout.search
    @search.delegate = self

    button = UIBarButtonItem.alloc.initWithTitle('Alerts', style: UIBarButtonItemStylePlain,
      target: self, action: 'alerts:')
    navigationItem.setRightBarButtonItem(button, animated: false)
    button = UIBarButtonItem.alloc.initWithTitle('Map', style: UIBarButtonItemStylePlain,
      target: self, action: 'map:')
    navigationItem.setLeftBarButtonItem(button, animated: false)
  end

  def viewDidLoad
    super

    if traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable
      @previewing_context = registerForPreviewingWithDelegate(self, sourceView: self.view)
    else
      @previewing_context = nil
    end
  end

  def viewWillAppear(animated)
    path = @table.indexPathForSelectedRow
    @table.deselectRowAtIndexPath(path, animated: true) if path

    setup_keyboard_listeners
    super
  end

  def viewWillDisappear(animated)
    remove_keyboard_listeners
  end

  def searchBarTextDidBeginEditing(search)
    @search.setShowsCancelButton(true, animated: true)
  end

  def searchBarTextDidEndEditing(search)
    @search.setShowsCancelButton(false, animated: true)
  end

  def searchBarCancelButtonClicked(search)
    @search.text = ''
    searchBarTextDidEndEditing(@search)
    searchBar(@search, textDidChange: '')
    @search.resignFirstResponder
  end

  def searchBar(search, textDidChange: text)
    @filter_text = text
    generate_station_groups
  end

  def numberOfSectionsInTableView(table)
    return 0 if Motion::LaunchImages.taking?
    @filtered.count
  end

  def tableView(table, numberOfRowsInSection: section)
    @filtered[section].count
  end

  def tableView(table, cellForRowAtIndexPath: path)
    cell = table.dequeueReusableCellWithIdentifier(@reuse)

    if cell.nil?
      cell = UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault,
                                                 reuseIdentifier: @reuse)
      cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator
    end

    cell.textLabel.text = @filtered[path.section][path.row].name
    cell
  end

  def tableView(table, didSelectRowAtIndexPath: path)
    station = @filtered[path.section][path.row]
    train_list = ETAListViewController.alloc.init_with_station(station, self)
    navigationController.pushViewController(train_list, animated: true)
  end

  def tableView(table, titleForHeaderInSection: section)
    @section_titles[section]
  end

  def sectionIndexTitlesForTableView(table)
    @section_titles
  end

  def sectionForSectionIndexTitle(table, sectionForSectionIndexTitle: title)
    @section_titles.index(title)
  end

  def favorites_updated
    generate_station_groups
  end

  def alerts(sender)
    alert = AlertListViewController.alloc.init
    navigationController.pushViewController(alert, animated: true)
  end

  def map(sender)
    map = MapLineSelectionController.alloc.init_with_eta_delegate(self)
    navigationController.pushViewController(map, animated: true)
  end

  def force_show(stop_id)
    station = CTAInfo.stations[stop_id.to_i]
    return unless station

    navigationController.popToRootViewControllerAnimated(false)
    train_list = ETAListViewController.alloc.init_with_station(station, self)
    navigationController.pushViewController(train_list, animated: false)
  end

  def previewingContext(context, viewControllerForLocation: location)
    return if presentedViewController.is_a?(ETAListViewController)

    position = @layout.table.convertPoint(location, fromView: view)
    path = @layout.table.indexPathForRowAtPoint(position)
    return nil unless path

    cell = @layout.table.cellForRowAtIndexPath(path)
    context.sourceRect = self.view.convertRect(cell.frame, fromView: @layout.table)

    station = @filtered[path.section][path.row]
    ETAListViewController.alloc.init_with_station(station, self)
  end

  def previewingContext(context, commitViewController: controller)
    self.navigationController.showViewController(controller, sender: nil)
  end

  def traitCollectionDidChange(collection)
    super

    if traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable
      return if @previewing_context
      @previewing_context = registerForPreviewingWithDelegate(self, sourceView: self.view)
    else
      return unless @previewing_context
      unregisterForPreviewingWithContext(@previewing_context)
      @previewing_context = nil
    end
  end

  private

  def generate_station_groups
    if @filter_text == ''
      filtered = @stations
    else
      split = @filter_text.downcase.split(' ')
      filtered = @stations.select do |station|
        # make sure the station name includes all words entered
        split.all? { |word| station.name.downcase.include?(word) }
      end
    end

    groups = filtered.group_by do |station|
      char = station.name[0].upcase
      @numbers.include?(char) ? '#' : char
    end

    @section_titles = groups.keys
    @filtered = groups.values

    # only show favorites when there isn't a search filter
    favorites = Settings.favorites
    if @filter_text == '' && !favorites.empty?
      @section_titles = ['★'] + @section_titles
      @filtered = [favorites.map { |id| CTAInfo.stations[id] }] + @filtered
    end

    @table.reloadData
  end
end
