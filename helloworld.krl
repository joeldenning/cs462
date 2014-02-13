ruleset b505218x0 {
  meta {
    name "Hello Joel"
    description << Hello World >>
    author "Joel Denning"
    logging on
  }
  
  rule notifications is active {
    select when pageview ".*"
    notify("Notification 1", "This is a notification") with sticky = true and position="top-right";
    // notify("Notification 2", "This is also notification") with sticky = true and position="bottom-right";
  }
  rule hello is active {
	select when pageview ".*"
	pre {
		query = (page:url("query") like re/.+/) => page:url("query") | "name=Monkey";
		parseQuery = function(s) {
			array = s.split(re/=/);
			nameIndex = array.index("name");
			(nameIndex >= 0) => array[nameIndex+1] | "Monkey";
		};
		output = parseQuery(query);
		
	}
	notify("Hello", "#{output}") with sticky = true and position="bottom-left";
  }
  
  rule counter is active {
	select when pageview ".*" and (ent:runs <= 5)
	pre {
		ent:runs = ent:runs + 1;
	}
	notify("You've been here", "#{ent:runs} times") with sticky = true and position="top-left";
  }
}