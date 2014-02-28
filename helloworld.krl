ruleset b505218x0 {

  meta {
    name "Hello Joel"
    description << Lab 3 - Web Rule Exercises >>
    author "Joel Denning"
    logging on
  }
  
	global {
	  searchRT = function(title) {
			http:get("api.rottentomatoes.com/api/public/v1.0/movies.json",
				{"apikey": "e5nggrvdn9j839b98mjrex3k", "q": title} );
		};
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
		set ent:stored null;
	}
  }
  
  rule show_form is active {
    select when pageview ".*"
	pre 
	{
		html = (ent:stored == 1) => "<p>Hello "+ent:firstname+" "+ent:lastname+"</p>" | "<form id=\"myform\" action=\"\">"+
			"Title: <input type=\"text\" name=\"title\"><br>"+
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
		title = event:attr("title");
		returnedJSON = searchRT(title);
	}
	{
		notify("Submitted", "");
		replace_html("#main", returnedJSON);
	}
	always {
		set ent:stored 1;
	}
  }

}