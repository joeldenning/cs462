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
		doClear = page:url("query").match(re/.*clear.*/);
	}
	if doClear then {
		notify("Clearing", "Clearing stored variables") with sticky = false;
	}
	fired {
		clear ent:var;
	}
  }
  
  rule show_form is active {
    select when pageview ".*"
	pre {
		entityVar = ent:var;
		myHTML = "entityVar = "+entityVar;
	}
	{
		replace_html("#main", myHTML);
	}
	always {
		set ent:var "string";
	}
  }

}
