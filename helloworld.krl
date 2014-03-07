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
		replace_html("#main", "<p>Sample text</p>")
	}
  }

}
