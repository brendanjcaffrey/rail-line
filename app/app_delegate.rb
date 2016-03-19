class AppDelegate
  attr_reader :window

  def application(application, didFinishLaunchingWithOptions: launch_options)
    @station_list_view_controller = StationListViewController.alloc.init
    navigation_controller = UINavigationController.alloc.initWithRootViewController(@station_list_view_controller)

    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.rootViewController = navigation_controller
    @window.makeKeyAndVisible

    UINavigationBar.appearance.tintColor = Colors.cyan # make nav bar buttons cyan
    UINavigationBar.appearance.titleTextAttributes = {
      NSForegroundColorAttributeName => Colors.cyan # make nav bar title cyan
    }
    # make text color of table section headers cyan
    UILabel.appearanceWhenContainedInInstancesOfClasses([UITableViewHeaderFooterView]).setTextColor(Colors.cyan)

    Motion::LaunchImages.take!

    if launch_options && launch_options.has_key?(UIApplicationLaunchOptionsShortcutItemKey)
       @launched_item = launch_options[UIApplicationLaunchOptionsShortcutItemKey]

       # prevent performActionForShortcutItem:completionHandler: from firing
       return false
    end

    return true
  end

  def applicationDidBecomeActive(app)
    return if !@launched_item

    handle_shortcut_item(@launched_item)
    @launched_item = nil
  end

  def application(app, performActionForShortcutItem: item, completionHandler: handler)
    handler.call(handle_shortcut_item(item))
  end

  def handle_shortcut_item(item)
    @station_list_view_controller.force_show(item.type)
    # only do this if it's a type we know
    return true
  end
end
