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
    # calling sort puts numbers at the top, so we have to partition, then sort, then flatten to replicate the ios default sort
    @stations = CTAInfo.stations.values.partition { |station| !@numbers.include?(station.name[0]) }.map { |group| group.sort_by!(&:name) }.flatten
    @reuse = 'StationCell'
    navigationItem.setTitle('Stations')

    @search = @layout.search
    @search.delegate = self

    button = UIBarButtonItem.alloc.initWithTitle('Alerts', style: UIBarButtonItemStylePlain,
      target: self, action: 'alerts:')
    navigationItem.setRightBarButtonItem(button, animated: false)

    generate_station_groups(@stations)
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
    if text == ''
      filtered = @stations
    else
      split = text.downcase.split(' ')
      filtered = @stations.select do |station|
        split.all? { |word| station.name.downcase.include?(word) }
      end
    end

    @filter_text = text
    generate_station_groups(filtered)
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
    train_list = ETAListViewController.alloc.init_with_station(@filtered[path.section][path.row])
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

  def alerts(sender)
    navigationController.pushViewController(AlertListViewController.alloc.init, animated: true)
  end

  def force_show(stop_id)
    station = CTAInfo.stations[stop_id.to_i]
    return unless station

    navigationController.popToRootViewControllerAnimated(false)
    train_list = ETAListViewController.alloc.init_with_station(station)
    navigationController.pushViewController(train_list, animated: false)
  end

  private

  def generate_station_groups(list)
    groups = list.group_by do |station|
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
