class AppDelegate
  attr_reader :window

  def application(application, didFinishLaunchingWithOptions: launchOptions)
    rootViewController = StationListViewController.alloc.init
    navigationController = UINavigationController.alloc.initWithRootViewController(rootViewController)

    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.rootViewController = navigationController
    @window.makeKeyAndVisible

    true
  end
end
