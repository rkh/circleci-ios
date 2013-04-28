class ProjectsTableViewController < UITableViewController

  attr_accessor :projects, :pullToRefreshView

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
      self.pullToRefreshView.finishLoading
      view.reloadData
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
    load_projects
   end

   def pullToRefreshViewDidStartLoading(view)
    self.refresh
  end

end
