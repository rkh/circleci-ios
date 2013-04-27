class ProjectsTableViewController < UITableViewController

  attr_accessor :projects, :pullToRefreshView

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
    if user and user['token']
      pullToRefreshView.startLoadingAndExpand(true)
      refresh
    end
  end

  def viewDidUnload
    super

    # Release any retained subviews of the main view.
    # e.g. self.myOutlet = nil
  end

  def load_projects
    defaults = NSUserDefaults.standardUserDefaults
    user = defaults['user']
    circle = Circle.shared_instance
    circle.token ||= user['token']
    circle.all_projects do |projects|
      @projects = projects.dup.map do |proj|
        proj.all_branches.map do |b|
          branch_info = proj.branches[b]
          next if branch_info['recent_builds'].to_a.empty?
          branch_info.merge!('name' => b)
          attrs = Project::PROJ_ATTRS.inject({}) { |hash, attr| hash[attr] = proj.send(attr); hash }
          Project.new attrs.merge('branch_info' => branch_info)
        end
      end.flatten.compact
      # self.performSelectorInBackground('check_for_rewards:', withObject:@builds)
      self.pullToRefreshView.finishLoading
      view.reloadData
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
    @projects.to_a.size
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    cellIdentifier = 'ProjectCell'
    cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) || begin
      cell = ProjectViewCell.alloc.initWithStyle UITableViewCellStyleDefault, reuseIdentifier: cellIdentifier
      cell
    end

    project = @projects[indexPath.row]
    cell.name_label.text = project.repo_name
    cell.branch_label.text = project.branch_name
    cell.setup_build_views(project)
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
    load_projects
   end

   def pullToRefreshViewDidStartLoading(view)
    self.refresh
  end

end
