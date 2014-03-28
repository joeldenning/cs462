//b505970x0, b505971x0
ruleset catch_location {
  meta {
    logging off
    use module a169x701 alias CloudRain
    use module a41x186  alias SquareTag
  }

  rule location_catch {
    select when location notification
    pre {
  		checkin = event:attr("fs_checkin").decode();
  	}
  	{
  		send_directive("app here");
  	}
  	fired {
  	  set ent:fs_checkin checkin;
  	  set ent:alive "event fired";
  	}
  }
  
  rule location_display {
    select when web cloudAppSelected
    pre {
        alive = ent:alive;
        checkin = ent:fs_checkin;
    		venue = checkin.pick("$.venue").encode().as("str");
    		city = checkin.pick("$.city").encode(); 
    		shout = checkin.pick("$.shout").encode();
    		date = checkin.pick("$.date").encode();
    	  html = <<
    	      Alive: #{alive} <br>
    				<p>Venue: #{venue} </p>
    				<p>City: #{city} <br /></p>
    				<p>Shout: #{shout} <br /></p>
    				<p>Date: #{date} <br /></p>
    				>>;
    }
    {
      CloudRain:createLoadPanel("Foursquare Checkin info",{}, html);
    }
  }
}
