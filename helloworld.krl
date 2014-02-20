ruleset b505218x0 {
  meta {
    name "Hello Joel"
    description << Lab 3 - Web Rule Exercises >>
    author "Joel Denning"
    logging on
  }
  
  rule show_form is active {
    select when pageview ".*"
	pre {
		firstName = ent:firstname;
		lastName = "Denning";
		html_form = 
			"<form id=\"myform\" onsubmit=\"return false;\">"+
			"First Name: <input type=\"text\" name=\"firstname\" value=\"" + firstName + "\"><br>"+
			"Last Name: <input type=\"text\" name=\"lastname\" value=\"Denning\"><br>"+
			"<input type=\"submit\">";
	}
	{
		replace_html("#main", html_form);
		watch("#myform", "submit");
	}
  }
  
  rule form_submitted is active {
	select when web submit "#myform"
	{
		notify("submitted", "") with sticky = false;
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
