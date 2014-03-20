ruleset b505218x0 {
  meta {
    name "Hello Joel"
    description << Hello World >>
    author "Joel Denning"
    logging on
  }
  
  rule notifications is active {
    select when pageview ".*"
	{
		notify("Notification 1", "This is a notification") with sticky = true;
		notify("Notification 2", "This is also notification") with sticky = true;
	}
  }
  rule hello is active {
		select when pageview ".*"
		pre {
			query = (page:url("query") like re/.+/) => page:url("query") | "name=Monkey";
			parseQuery = function(s) {
				array = s.split(re/=|&/);
				nameIndex = array.index("name");
				nameIndex = (nameIndex >= 0) => nameIndex | array.index("&name");
				(nameIndex >= 0) => array[nameIndex+1].split(re/&/).head() | "Monkey";
			};
			output = parseQuery(query);
		
		}
		notify("Hello", "#{output}") with sticky = true;
  }
   
  rule clearVisits is active {
	select when pageview ".*"
	pre {
		doClear = page:url("query").match(re/.*clear.*/);
	}
	if doClear then {
		notify("Clearing", "Clearing the count") with sticky = false;
	}
	fired {
		clear ent:visits;
	}
  }
  
  rule visits is active {
		select when pageview ".*"
		pre {
			times = ent:visits;
		}
		if times <= 5 then {
			notify("You've been here", "#{times} times") with sticky = true;
		}
		always {
			ent:visits += 1 from 0;
		}
  }

}
