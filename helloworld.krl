ruleset b505218x0 {
  meta {
    name "Hello Joel"
    description << Hello World >>
    author "Joel Denning"
    logging on
  }
  
  rule notifications is active {
    select when pageview ".*"
    // notify("Notification 1", "This is a notification") with sticky = true and position="top-right";
    //notify("Notification 2", "This is also notification") with sticky = true and position="bottom-right";
  }
  rule hello is active {
	select when pageview ".*"
	pre {
		query = page:url("query");
		name = "Monkey";
	}
	notify("Hello", "#{name}") with sticky = true and position="bottom-left";
  }
}