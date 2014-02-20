ruleset b505218x0 {
  meta {
    name "Hello Joel"
    description << Lab 3 - Web Rule Exercises >>
    author "Joel Denning"
    logging on
  }
  
  rule show_form is active {
    select when pageview ".*"
	{
		replace_html("#main", "<form id=\"myform\">First Name: <input type=\"text\" name=\"firstname\"><br>Last Name: <input type=\"text\" name=\"lastname\"><br><input type=\"submit\">");
	}
  }
  
  rule clearVisits is active {
	select when pageview ".*"
	pre {
		doClear = page:url("query").match(re/.*clear=1.*/);
	}
	if doClear then {
		notify("Clearing", "Clearing the count") with sticky = false;
	}
	fired {
		clear ent:visits;
	}
  }

}
