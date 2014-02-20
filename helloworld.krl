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
		html_form = <<
			<form id="myform" onsubmit="return false;">
			First Name: <input type="text" name="firstname" value="#{ent:firstname}"><br>
			Last Name: <input type="text" name="lastname" value="#{ent:lastname}"><br>
			<input type="submit">
		>> ;
	}
	{
		replace_html("#main", "");
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
