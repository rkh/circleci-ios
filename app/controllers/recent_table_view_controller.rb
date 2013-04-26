class RecentTableViewController < UITableViewController

  attr_accessor :builds, :pullToRefreshView

  def viewDidLoad
    super
    # Uncomment the following line to preserve selection between presentations.

    # self.clearsSelectionOnViewWillAppear = false

    # Uncomment the following line to display an Edit button in the navigation
    # bar for this view controller.

    # self.navigationItem.rightBarButtonItem = self.editButtonItem
    self.pullToRefreshView = SSPullToRefreshView.alloc.initWithScrollView self.tableView, delegate:self
    defaults = NSUserDefaults.standardUserDefaults
    user = defaults['user']
    load_recent_builds if user and user['token']
  end

  def viewDidUnload
    super

    # Release any retained subviews of the main view.
    # e.g. self.myOutlet = nil
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
    # Return the number of sections.
    1
  end

  def tableView(tableView, numberOfRowsInSection:section)
    # Return the number of rows in the section.
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

=begin
  # Override to support conditional editing of the table view.
  def tableView(tableView, canEditRowAtIndexPath:indexPath)
    # Return false if you do not want the specified item to be editable.
    true
  end
=end

=begin
  # Override to support editing the table view.
  def tableView(tableView, commitEditingStyle:editingStyle forRowAtIndexPath:indexPath)
    if editingStyle == UITableViewCellEditingStyleDelete
      # Delete the row from the data source
      tableView.deleteRowsAtIndexPaths(indexPath, withRowAnimation:UITableViewRowAnimationFade)
    elsif editingStyle == UITableViewCellEditingStyleInsert
      # Create a new instance of the appropriate class, insert it into the
      # array, and add a new row to the table view
    end
  end
=end

=begin
  # Override to support rearranging the table view.
  def tableView(tableView, moveRowAtIndexPath:fromIndexPath, toIndexPath:toIndexPath)
  end
=end

=begin
  # Override to support conditional rearranging of the table view.
  def tableView(tableView, canMoveRowAtIndexPath:indexPath)
    # Return false if you do not want the item to be re-orderable.
    true
  end
=end

## Table view delegate

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    # Navigation logic may go here. Create and push another view controller.
    # detailViewController = DetailViewController.alloc.initWithNibName("Nib name", bundle:nil)
    # Pass the selected object to the new view controller.
    # self.navigationController.pushViewController(detailViewController, animated:true)
  end

  def refresh
   self.pullToRefreshView.startLoading
   load_recent_builds
  end

  def pullToRefreshViewDidStartLoading(view)
   self.refresh
 end

end
