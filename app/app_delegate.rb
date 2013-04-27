class AppDelegate

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    storyboard = UIStoryboard.storyboardWithName 'Storyboard', bundle: nil
    navController = storyboard.instantiateInitialViewController
    @window.rootViewController = navController
    @window.makeKeyAndVisible
    kiip = Kiip.alloc.initWithAppKey(ENV['KIIP_APP_KEY'], andSecret: ENV['KIIP_APP_SECRET'])
    kiip.delegate = self
    Kiip.setSharedInstance(kiip)
    true
  end

end
