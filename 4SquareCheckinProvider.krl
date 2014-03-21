//b505218x13
ruleset Location { 
  meta {
    name "Location"
    description <<
      Location
    >>
    author "Ketih Halterman"
    logging off
    use module a169x701 alias CloudRain
    use module a41x186  alias SquareTag
    
    provides getLocation, getTest

  }
  
 dispatch {
 }

global {

	getLocation = function(key){
    		ent:locationData{key} || {};
    		};


	getTest = "Test Succeeded!";

}

rule showData {
    	select when cloudAppSelected
	pre {
		checkin = getLocation("fs_checkin");

		venue = checkin.pick("$.venue").encode().as("str");
		city = checkin.pick("$.city").encode(); 
		shout = checkin.pick("$.shout").encode();
		date = checkin.pick("$.date").encode();
		html_output = <<
				<p>Venue: #{venue} </p>
				<p>City: #{city} <br /></p>
				<p>Shout: #{shout} <br /></p>
				<p>Date: #{date} <br /></p>
				>>;
	}
	{
		CloudRain:createLoadPanel("Foursquare Checkin info",{}, html_output);
	}

   }

rule add_location_item{
    	select when pds new_location_data
	    pre {
	        k = event:attr("key");
	        v = event:attr("value");
	        map = {};
	        map = map.put([k], v);
	    }
	    	{
	    	send_directive('Set_Directive:Add_Location Works') with key = k and value = v;
	    	}
	    always {
	        set ent:locationData map; 
	    }
 }

}
