class AlertListViewController < UIViewController
  include ControllerConstraintHelper

  def loadView
    @alerts = []
    @reuse = 'AlertCell'

    @layout = AlertListLayout.new
    self.view = @layout.view

    @table = @layout.table
    @table.delegate = @table.dataSource = self
    self.automaticallyAdjustsScrollViewInsets = false
    navigationItem.setTitle('Train Alerts')

    table_vc = UITableViewController.alloc.init
    table_vc.tableView = @table

    @refresh = UIRefreshControl.alloc.init
    @refresh.addTarget(self, action: 'refresh:', forControlEvents: UIControlEventValueChanged)
    table_vc.refreshControl = @refresh

    @first_load = true
    refresh(nil)
    Dispatch::Queue.main.async { @layout.update_constraint(self) }

    @normal_font = UIFont.systemFontOfSize(UIFont.systemFontSize)
    @small_font = UIFont.systemFontOfSize(UIFont.smallSystemFontSize)
  end

  def viewWillAppear(animated)
    path = @table.indexPathForSelectedRow
    @table.deselectRowAtIndexPath(path, animated: true) if path
  end

  def refresh(sender)
    UIApplication.sharedApplication.networkActivityIndicatorVisible = true

    Dispatch::Queue.concurrent.async do
      @alerts = APIClient.get_alerts
      if @alerts.nil?
        alert = UIAlertController.alertControllerWithTitle('Error',
          message: 'Unable to load alerts, please check your internet connection.',
          preferredStyle: UIAlertControllerStyleAlert)
        alert.addAction(UIAlertAction.actionWithTitle('Okay', style: UIAlertActionStyleCancel, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
        @alerts = []
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
    [1, @alerts.count].max
  end

  def tableView(table, cellForRowAtIndexPath: path)
    cell = table.dequeueReusableCellWithIdentifier(@empty_reuse)
    cell = UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier: @empty_reuse) if cell.nil?
    cell.textLabel.numberOfLines = 0
    cell.textLabel.color = UIColor.blackColor

    if @alerts.count == 0
      text = mutable_attr_string('No alerts')
      cell.selectionStyle = UITableViewCellSelectionStyleNone
    else
      alert = @alerts[path.row]
      text = mutable_attr_string(alert.description.strip)
      text.appendAttributedString(attr_string("\n\nWhen: " + alert.start_string + ' - ' + alert.end_string))
      text.appendAttributedString(attr_string("\nAffects:"))

      alert.services.each_with_index do |service, index|
        text.appendAttributedString(attr_string(connector_text(index, alert.services.size)))
        text.appendAttributedString(attr_string(service.name, service.uicolor))
      end

      cell.selectionStyle = UITableViewCellSelectionStyleDefault
    end

    cell.textLabel.attributedText = text
    cell
  end

  def tableView(table, didSelectRowAtIndexPath: path)
    url = NSURL.URLWithString(@alerts[path.row].url)
    safari = SFSafariViewController.alloc.initWithURL(url)
    presentViewController(safari, animated: true, completion: nil)
  end

  private

  def attr_string(text, color = UIColor.blackColor)
    NSAttributedString.alloc.initWithString(text, attributes: {
      NSForegroundColorAttributeName => color,
      NSFontAttributeName => @small_font
    })
  end

  def mutable_attr_string(text)
    NSMutableAttributedString.alloc.initWithString(text, attributes: {
      NSForegroundColorAttributeName => UIColor.blackColor,
      NSFontAttributeName => @normal_font
    })
  end

  def connector_text(index, total)
    return ' ' if index == 0
    return ' and ' if index == total - 1
    return ', '
  end
end
