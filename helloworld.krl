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
			body = result.pick("$.content").decode();
			movieArray = body.pick("$.movies");
			movie = movieArray[0];
			movie;
		}
	}
  
  rule show_form is active {
    select when pageview ".*"
	pre 
	{
		html = "<div id=\"main\"><form id=\"myform\" action=\"\">"+
			"Title: <input type=\"text\" name=\"title\"><br>"+
			"<input type=\"submit\"></div>";
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
		movie = searchRT(event:attr("title"));
		thumbnail = movie.pick("$.posters").pick("$.thumbnail");
		title = movie.pick("$.title");
		releaseYear = movie.pick("$.year");
		synopsis = movie.pick("$.synopsis");
		score = movie.pick("$.ratings").pick("$.critics_score");
		rating = movie.pick("$.ratings").pick("$.critics_rating");
		
		html = (title == 0) => "<div id=\"main\"><img src=\""+thumbnail+"\"></img><br>Title: "+title+"<br>"+releaseYear+"<br>"+
			"Synopsis: "+synopsis+"<br>Critics rating: "+score+"   "+rating+"<br><br><br><form id=\"myform\" action=\"\">"+
			"Title: <input type=\"text\" name=\"title\"><br>"+
			"Enter another title: <input type=\"submit\"></div>" | "<div id=\"myform\">No Movie Found</div>"+
			"<form id=\"myform\" action=\"\">"+
			"Title: <input type=\"text\" name=\"title\"><br>"+
			"Enter another title: <input type=\"submit\"></div>";
	}
	{
		notify("Submitted", "");
		replace_inner("#main", html);
	}
  }

}