class WorkedtimeReportsController < ApplicationController
  unloadable

  #before_filter :require_admin
    before_filter :require_login
    before_filter :require_user_in_group_workedtimeviewers
  
  def index 
    @time_entries
    @params = {} if @params == nil
    @params[:issue] ={"issue_id" => "", "project_id" => 0, "user_id" => 0, "start_date" => "", "end_date"=> ""}      
    render :action => 'index' 
  end
  
  def create

     puts "*"*20
     
     puts params.inspect.to_s   
     @params=params
     @lim=1000
     @project_id = all_or params[:issue][:project_id]    
     @user_id =all_or params[:issue][:user_id]   
     @issue_id =all_or params[:issue][:issue_id]         
     @start_date =all_or params[:issue][:start_date]    
     @end_date =all_or params[:issue][:end_date]    
     @sql  =" 1=1"
     @sql  += "  and project_id like #{@project_id}" unless @project_id == "0"
     @sql  +="  and user_id like #{@user_id}" unless @user_id == "0"
     @sql  += " and issue_id like #{@issue_id}" unless @issue_id.to_s  == ""
     @sql  += " and spent_on >= '#{@start_date.to_s}'" unless @start_date == nil or @start_date.to_s  == "" 
     @sql  += " and spent_on <= '#{@end_date.to_s}'"   unless @end_date == nil or  @end_date.to_s  == ""   
     puts "sql="+@sql     
     @time_entries = TimeEntry.find(:all, :conditions => @sql , :limit => @lim)
     @time_entries_sums = TimeEntry.sum(:hours, :conditions => @sql, :limit => @lim)
     sql2="SELECT user_id, issue_id, SUM(hours) FROM time_entries  WHERE #{@sql } GROUP BY user_id, issue_id  LIMIT "+ @lim.to_s
     a=ActiveRecord::Base
     adapter= a.configurations[RAILS_ENV]['adapter']
     @sum_field= sum_field_name(adapter)
     @time_entries_dsums = a.connection.select_all(sql2)
     render :action => 'index' 
  end
  
  private

def all_or(n)
   return '%'if  n == nil   
   return n
end


def require_user_in_group_workedtimeviewers
#is_in = User. User.current.allowed_to?({:controller => ctrl, :action => action},  nil, :global => true)
 wtv_group= Group.find_by_lastname("workedtimeviewers")
 is_in =false
 is_in = User.current.groups.include? wtv_group  if  wtv_group != nil
 is_in ? true : deny_access
end

def sum_field_name(adapter)
return "sum" if adapter == "postgresql"
return "SUM(hours)" if adapter =="sqlite3"
end

end
