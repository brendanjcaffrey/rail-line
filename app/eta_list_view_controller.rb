class ETAListViewController < UIViewController
  include ControllerConstraintHelper

  def init_with_stop_name(name)
    @stop_name = name
    @etas = []

    @empty_reuse = 'PlainCell'
    @reuse = 'ETACell'

    init
  end

  def loadView
    @layout = ETAListLayout.new
    self.view = @layout.view

    @table = @layout.table
    @table.delegate = @table.dataSource = self
    self.automaticallyAdjustsScrollViewInsets = false
    navigationItem.setTitle(@stop_name)

    table_vc = UITableViewController.alloc.init
    table_vc.tableView = @table

    @refresh = UIRefreshControl.alloc.init
    @refresh.addTarget(self, action: 'refresh:', forControlEvents: UIControlEventValueChanged)
    table_vc.refreshControl = @refresh

    @first_load = true
    refresh(nil)
    Dispatch::Queue.main.async { @layout.update_constraint(self) }
  end

  def refresh(sender)
    UIApplication.sharedApplication.networkActivityIndicatorVisible = true

    Dispatch::Queue.concurrent.async do
      @etas = APIClient.get_etas(@stop_name)
      if @etas.nil?
        alert = UIAlertController.alertControllerWithTitle('Error',
          message: 'Unable to load arrivals, please check your internet connection.',
          preferredStyle: UIAlertControllerStyleAlert)
        alert.addAction(UIAlertAction.actionWithTitle('Okay', style: UIAlertActionStyleCancel, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
        @etas = []
      end

      Dispatch::Queue.main.async do
        @first_load = false
        UIApplication.sharedApplication.networkActivityIndicatorVisible = false
        @refresh.endRefreshing
        @table.reloadData
      end
    end
  end

  def numberOfSectionsInTableView(table)
    1
  end

  def tableView(table, numberOfRowsInSection: section)
    return 0 if @first_load
    [1, @etas.count].max
  end

  def tableView(table, cellForRowAtIndexPath: path)
    if @etas.count == 0
      cell = table.dequeueReusableCellWithIdentifier(@empty_reuse)
      cell = UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier: @empty_reuse) if cell.nil?
      cell.textLabel.text = 'No upcoming arrivals'
    else
      cell = table.dequeueReusableCellWithIdentifier(@reuse)
      cell = ETACellView.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier: @reuse) if cell.nil?
      cell.update(@etas[path.row])
    end

    cell
  end
end
