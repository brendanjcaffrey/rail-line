class StationListViewController < UIViewController
  include ControllerConstraintHelper

  def loadView
    @layout = StationListLayout.new
    self.view = @layout.view

    @table = @layout.table
    @table.delegate = @table.dataSource = self
    setAutomaticallyAdjustsScrollViewInsets(false)

    @filtered = @stations = CTAInfo.stations.keys.sort
    @reuse = 'StationCell'
    navigationItem.setTitle('Stations')

    @search = UISearchBar.alloc.initWithFrame(CGRectMake(0, 0, 320, 44))
    @search.delegate = self
    @search.placeholder = 'Search'
    @table.tableHeaderView = @search

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
      @filtered = @stations
    else
      split = text.downcase.split(' ')
      @filtered = @stations.select do |station|
        split.all? { |word| station.downcase.include?(word) }
      end
    end

    @table.reloadData
  end

  def numberOfSectionsInTableView(table)
    1
  end

  def tableView(table, numberOfRowsInSection: section)
    return 0 if Motion::LaunchImages.taking?
    @filtered.count
  end

  def tableView(table, cellForRowAtIndexPath: path)
    cell = table.dequeueReusableCellWithIdentifier(@reuse)

    if cell.nil?
      cell = UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault,
                                                 reuseIdentifier: @reuse)
      cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator
    end

    cell.textLabel.text = @filtered[path.row]
    cell
  end

  def tableView(table, didSelectRowAtIndexPath: path)
    train_list = ETAListViewController.alloc.init_with_stop_name(@filtered[path.row])
    navigationController.pushViewController(train_list, animated: true)
  end

  def alerts(sender)
    navigationController.pushViewController(AlertListViewController.alloc.init, animated: true)
  end
end
