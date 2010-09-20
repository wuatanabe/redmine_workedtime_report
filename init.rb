require 'redmine'

Redmine::Plugin.register :redmine_workedtime_report do
  name 'Redmine WorkedTime Report plugin'
  author 'Paolo Freuli'
  description 'Another Time Report'
  version '0.0.1'
  #url 'http://example.com/path/to/plugin'
  author_url 'http://github.com/wuatanabe/redmine_workedtime_report'
  
  menu :top_menu, :workedtime_reports, { :controller => 'workedtime_reports', :action => 'index' }, :caption => 'WorkTime'
  permission :view_workedtime_reports, :workedtime_reports => :index
    if Group.find_by_lastname("workedtimeviewers") == nil
		group = Group.new
		group.lastname="workedtimeviewers"
		group.save
	end
  end

     

 
      