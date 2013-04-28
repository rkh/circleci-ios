class AppDelegate

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    storyboard = UIStoryboard.storyboardWithName 'Storyboard', bundle: nil
    navController = storyboard.instantiateInitialViewController
    @window.rootViewController = navController
    @window.makeKeyAndVisible
    true
  end

end
