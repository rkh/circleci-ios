class ProjectViewCell < UITableViewCell

  extend IB

  outlet :name_label
  outlet :branch_label
  outlet :build1_view
  outlet :build2_view
  outlet :build3_view

  def setup_build_views(project)
    return unless project.branch_info and project.branch_info['recent_builds']
    project.branch_info['recent_builds'].each_with_index do |build, index|
      next if index >= 3
      color = Build.color_from_status(build['status'])
      view = self.send("build#{index+1}_view")
      view.backgroundColor = color if view
    end
  end

end
