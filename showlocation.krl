 
ruleset ShowLocation {
  meta {  
//b505289x5.prod
    name "Show Location"
    description <<
      Checkin In With Foursquare
    >>
    author ""
    logging off
	use module a169x701 alias CloudRain
	use module a41x186  alias SquareTag
	
	use module b505218x1 alias LocationData

  }
  
  dispatch {
	}


  rule show_fs_location is active {
		select when pageview ".*" 
		pre {
			checkin = LocationData:getLocation();
		//	checkin = LocationData:getConstant();
		}
		{
	  	notify(checkin.decode(), "I can make a Notify") with sticky = true;
	  	notify("doing Something I Hope" , "I can make a Notify") with sticky = true;
	  	
		}
	}
	
  rule display_checkin{
    select when cloudAppSelected
	  pre
		{
			checkin = LocationData:getLocation("fs_checkin");

			venue = checkin.pick("$.venue").encode().as("str");
			city = checkin.pick("$.city").encode(); 
			shout = checkin.pick("$.shout").encode();
			date = checkin.pick("$.date").encode();
			html_output = <<
					<p>We Here: #{venue} </p>
					<p>In: #{city} <br /></p>
					<p>Shout: #{shout} <br /></p>
					<p>Date: #{date} <br /></p>
					>>;
			checkin_header = << <div id="main">Checkin: </div><br />
						 <div id="checkinInfo"/> >>;
		}
		{
			CloudRain:createLoadPanel("Foursquare Checkin info",{},checkin_header);
			append("#main", html_output);
		}
  
  
   }
}
