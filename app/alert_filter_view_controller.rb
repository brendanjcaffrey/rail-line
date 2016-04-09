class AlertFilterViewController < UIViewController
  include ControllerConstraintHelper

  def init_with_delegate(delegate)
    @delegate = WeakRef.new(delegate)
    init
  end

  def loadView
    @routes = Colors.route_colors.keys
    @selected = [false] * @routes.size
    @reuse = 'AlertFilterCell'

    @layout = AlertFilterLayout.new
    self.view = @layout.view
    @table = @layout.table
    @table.delegate = @table.dataSource = self
    self.automaticallyAdjustsScrollViewInsets = false

    if navigationItem
      navigationItem.setTitle('Filter')
      button = UIBarButtonItem.alloc.initWithTitle('Done', style: UIBarButtonItemStylePlain,
        target: self, action: 'done:')
      navigationItem.setRightBarButtonItem(button, animated: false)
    end
  end

  def done(target)
    @delegate.done_filtering
  end

  def numberOfSectionsInTableView(table)
    1
  end

  def tableView(table, numberOfRowsInSection: section)
    @routes.count
  end

  def tableView(table, cellForRowAtIndexPath: path)
    cell = table.dequeueReusableCellWithIdentifier(@reuse)
    cell = UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier: @reuse) if cell.nil?

    route = @routes[path.row]
    cell.textLabel.text = route
    cell.textLabel.color = Colors.route_colors[route]
    cell.accessoryType = accessory_type_for_path(path)

    cell
  end

  def tableView(table, didSelectRowAtIndexPath: path)
    @selected[path.row] = !@selected[path.row]
    table.cellForRowAtIndexPath(path).accessoryType = accessory_type_for_path(path)
    table.deselectRowAtIndexPath(path, animated: true)

    selected = []
    (0..@selected.count).each do |index|
      selected << @routes[index] if @selected[index]
    end

    selected = selected.empty? ? @routes : selected
    @delegate.filter_updated(selected)
  end

  private

  def accessory_type_for_path(path)
    @selected[path.row] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone
  end
end
