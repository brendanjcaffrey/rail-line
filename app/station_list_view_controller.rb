class StationListViewController < UIViewController
  include ControllerConstraintHelper

  def loadView
    @layout = StationListLayout.new
    self.view = @layout.view

    @table = @layout.table
    @table.delegate = @table.dataSource = self
    setAutomaticallyAdjustsScrollViewInsets(false)

    @stations = CTAInfo.stations.keys.sort
    generate_station_groups(@stations)
    @reuse = 'StationCell'
    navigationItem.setTitle('Stations')

    @search = @layout.search
    @search.delegate = self

    button = UIBarButtonItem.alloc.initWithTitle('Alerts', style: UIBarButtonItemStylePlain,
      target: self, action: 'alerts:')
    navigationItem.setRightBarButtonItem(button, animated: false)
  end

  def viewWillAppear(animated)
    path = @table.indexPathForSelectedRow
    @table.deselectRowAtIndexPath(path, animated: true) if path
    super
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
        split.all? { |word| station.downcase.include?(word) }
      end
    end

    generate_station_groups(filtered)
    @table.reloadData
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

    cell.textLabel.text = @filtered[path.section][path.row]
    cell
  end

  def tableView(table, didSelectRowAtIndexPath: path)
    train_list = ETAListViewController.alloc.init_with_stop_name(@filtered[path.section][path.row])
    navigationController.pushViewController(train_list, animated: true)
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

  private

  def generate_station_groups(list)
    groups = list.group_by { |name| name[0].upcase }
    @section_titles = groups.keys
    @filtered = groups.values
  end
end
