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
		set ent:firstname null;
		set ent:lastname null;
		set ent:stored null;
	}
  }
  
  rule show_form is active {
    select when pageview ".*"
	pre 
	{
		html = (ent:stored == 1) => "<p>Hello "+ent:firstname+" "+ent:lastname+"</p>" | "<form id=\"myform\">"+
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
		first = event:attr("firstname");
		last = event:attr("lastname");
	}
	{
		notify("Submitted", "");
	}
	always {
		set ent:stored 1;
		set ent:firstname first;
		set ent:lastname last;
	}
  }

}
