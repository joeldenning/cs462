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
		stored = (ent:firstname == 0) => false | true;
		firstName = (ent:firstname == 0) => "" | ent:firstname;
		lastName = (ent:lastname == 0) => "" | ent:lastname;
		html = (stored) => "<p>Hello "+firstName+" "+lastName | "<form id=\"myform\">"+
			"First Name: <input type=\"text\" name=\"firstname\" value=\"\"><br>"+
			"Last Name: <input type=\"text\" name=\"lastname\" value=\"\"><br>"+
			"<input type=\"submit\">";
	}
	{
		replace_html("#main", html);
		watch("#myform", "submit");
	}
  }
  
  rule form_submitted is active {
	select when web submit "#myform"
	pre {
		performDebugging = true;
	}
	if performDebugging then {
		notify("submitted", "") with sticky = false;	
	}
	always {
		set ent:firstname "J";
		set ent:lastname "D";
	}
  }
  
  rule clearVisits is active {
	select when pageview ".*"
	pre {
		doClear = page:url("query").match(re/.*clear=1.*/);
	}
	if doClear then {
		notify("Clearing", "Clearing stored variables") with sticky = false;
	}
	fired {
		clear ent:firstname;
		clear ent:lastname;
	}
  }

}
