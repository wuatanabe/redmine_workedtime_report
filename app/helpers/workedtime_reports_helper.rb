module WorkedtimeReportsHelper

def get_user(u)
	return [["all", 0]] if u == nil
	r=[ User.find_by_id(u.to_i).login, u.to_i] if u != 0 and u != "0" 
	return  [r] +[["all", 0]] if r!= nil 
	return [["all", 0]]
end

def get_project(u)
	return [["all", 0]] if u == nil	
	r=[ Project.find_by_id(u.to_i).name, u.to_i] if u != 0 and u != "0" 
	return  [r] +[["all", 0]] if r!= nil 	
	return [["all", 0]]
end

def get_issue(u)
return "" if u == nil	
    return u if u != nil
    return  ""	
end

def get_start_date(u)
    return u 
end

def get_end_date(u)
    return u
end

end