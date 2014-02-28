ruleset b505218x0 {

  meta {
    name "Hello Joel"
    description << Lab 3 - Web Rule Exercises >>
    author "Joel Denning"
    logging on
  }
  
	global {
	  searchRT = function(title) {
			result = http:get("http://api.rottentomatoes.com/api/public/v1.0/movies.json", {"apikey": "e5nggrvdn9j839b98mjrex3k", "q": title, "page_limit": 1} );
			json = result.pick("$.content").decode();
			movieArray = body.pick("$.movies");
			movie = movieArray[0];
			movie;
		};
	}
  
  rule show_form is active {
    select when pageview ".*"
	pre 
	{
		html = "<form id=\"myform\" action=\"\">"+
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
	pre 
	{
		returnedJSON = searchRT(event:attr("title"));
	}
	{
		notify("Submitted", "hello");
		replace_inner("#main", returnedJSON.as("str"));
	}
  }

}