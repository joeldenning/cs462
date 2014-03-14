ruleset examine_location {
  meta {  
    name "Show Location"
    description <<
      Show locations
    >>
    author ""
    logging off
	use module a169x701 alias CloudRain
	use module a41x186  alias SquareTag
	
	use module b505218x1 alias LocationData

  }
  
  dispatch {
	}
	
  rule access_location_cloud {
    select when cloudAppSelected
	  pre
		{
			checkin = LocationData:getLocation("fs_checkin");

			venue = checkin.pick("$.venue").encode();
			city = checkin.pick("$.city").encode(); 
			shout = checkin.pick("$.shout").encode();
			date = checkin.pick("$.date").encode();
			html_output = <<
					<p>We Here: #{venue} </p>
					<p>In: #{city} <br /></p>
					<p>Shout: #{shout} <br /></p>
					<p>Date: #{date} <br /></p>
					>>;
			squareTagHeader = << <div id="main">Checkin: </div><br />
 						 <div id="checkinInfo"/> >>;
		}
		{
			CloudRain:createLoadPanel("View Checkins From Cloud",{},squareTagHeader);
			append("#main", html_output);
		}
  
  
   }
}
