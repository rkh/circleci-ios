class RecentTableViewController < UITableViewController

  attr_accessor :builds, :pullToRefreshView

  def viewDidLoad
    super
    self.pullToRefreshView = SSPullToRefreshView.alloc.initWithScrollView self.tableView, delegate:self
    defaults = NSUserDefaults.standardUserDefaults
    user = defaults['user']
    if user and user['token']
      pullToRefreshView.startLoadingAndExpand(true)
      refresh
    end
  end

  def viewDidUnload
    super
  end

  def load_recent_builds
    defaults = NSUserDefaults.standardUserDefaults
    user = defaults['user']
    circle = Circle.shared_instance
    circle.token ||= user['token']
    circle.recent_builds do |builds|
      @builds = builds.dup
      self.pullToRefreshView.finishLoading
      view.reloadData
    end
  end

  def viewDidAppear(animated)
    defaults = NSUserDefaults.standardUserDefaults
    user = defaults['user']
    unless user and user['token']
      loginView = LoginViewController.new.initWithNibName 'LoginView', bundle: nil
      loginView.delegate = self
      self.tabBarController.presentViewController(loginView, animated:false, completion:nil)
    end
  end

  def shouldAutorotateToInterfaceOrientation(interfaceOrientation)
    interfaceOrientation == UIInterfaceOrientationPortrait
  end

## Table view data source

  def numberOfSectionsInTableView(tableView)
    1
  end

  def tableView(tableView, numberOfRowsInSection:section)
    @builds.to_a.size
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    cellIdentifier = 'BuildCell'
    cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) || begin
      cell = BuildViewCell.alloc.initWithStyle UITableViewCellStyleDefault, reuseIdentifier: cellIdentifier
      cell
    end

    build = @builds[indexPath.row]
    cell.build_label.text = "##{build.build_num} [#{build.branch}]"
    cell.status_view.backgroundColor = build.status_color
    cell.subject_label.text = build.subject.to_s
    cell.committer_label.text = build.username
    cell.selectionStyle = UITableViewCellSelectionStyleNone
    cell
  end


## Table view delegate

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    # Navigation logic may go here. Create and push another view controller.
    # detailViewController = DetailViewController.alloc.initWithNibName("Nib name", bundle:nil)
    # Pass the selected object to the new view controller.
    # self.navigationController.pushViewController(detailViewController, animated:true)
  end

## Pull to refresh delegate

  def refresh
   self.pullToRefreshView.startLoading
   load_recent_builds
  end

  def pullToRefreshViewDidStartLoading(view)
   self.refresh
 end

end
