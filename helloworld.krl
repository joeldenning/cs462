ruleset b505218x0 {
  meta {
    name "Hello Joel"
    description << Lab 3 - Web Rule Exercises >>
    author "Joel Denning"
    logging on
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
  
  rule show_form is active {
    select when pageview ".*"
	pre {
		html = (ent:firstname != 0) => "<p>Hello "+ent:firstname+" "+ent:lastname+"</p>" | "<form id=\"myform\">"+
			"First Name: <input type=\"text\" name=\"firstname\"><br>"+
			"Last Name: <input type=\"text\" name=\"lastname\"><br>"+
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
		notify("submitted", "1") with sticky = false;	
	}
	fired {
		ent:firstname += 1 from 1;
		ent:lastname +=1 from 1;
		replace_html("#main", "<p>Hello "+ent:firstname+" "+ent:lastname+"</p>");
	}
  }

}
