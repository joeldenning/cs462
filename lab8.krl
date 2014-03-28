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
      data = event:attr("fs_checkin").decode();
      venue = data.pick("$..venue").encode();
      city = data.pick("$..city").encode();
      shout = data.pick("$..shout").encode();
      date = data.pick("$..createdAt").encode();
  	}
  	{
  		send_directive("app here");
  	}
  	fired {
  	  set ent:alive "yes alive";
  	  set ent:venue venue;
  	  set ent:city city;
  	  set ent:shout shout;
  	  set ent:date date;
  	}
  }
  
  rule location_display {
    select when web cloudAppSelected
    pre {
        alive = ent:alive;
    		venue = ent:venue.pick("$.name").as("str");
      	city = ent:city.as("str");
      	shout = ent:shout.as("str");
      	date = ent:date.as("str");
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
