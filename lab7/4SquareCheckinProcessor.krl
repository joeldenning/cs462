//b505218x3
ruleset FourSquareCheckin {
  meta {  
    name "FourSquare CheckIn"
    description <<
      Checkin In With Foursquare
    >>
    author ""
    logging off
	use module a169x701 alias CloudRain
	use module a41x186  alias SquareTag

	use module b505218x1 alias LocationData


  }
  
   rule process_fs_checkin{
    select when foursquare checkin
    
    pre{
    	data = event:attr("checkin").decode();
	venue = data.pick("$..venue");
	city = data.pick("$..city");
	shout = data.pick("$..shout");
	date = data.pick("$..createdAt");
	location = venue.pick("$..location");
	lat = location.pick("$..lat");
	lng = location.pick("$..lng");
    }
    {
   	send_directive("A FS Checkin") with checkin = "Im Here";
    }
    fired{
	set ent:venue venue;
	set ent:city city;
 	set ent:shout shout;
        set ent:createdAt createdAt;
	set ent:data event:attr("checkin").as("str");
	set ent:lat lat;
	set ent:lng lng;

	raise pds event new_location_data for b505218x1
		with key = "fs_checkin"
		and value = {"venue" : venue.pick("$.name"), "city" : city, "shout" : shout, "date" : createdAt, "lat": lat, "lng": lng};
    }
  }
  
rule display_checkin{
    select when cloudAppSelected
	  pre {
		  v = ent:venue.pick("$.name").as("str");
		  c = ent:city.as("str");
		  s = ent:shout.as("str");
		  ca = ent:createdAt.as("str");
		  lat = ent:lat.as("str");
		  lng = ent:lng.as("str");
		  
		  html = <<
			  <h1>Checkin Data:</h1>
			  <b>I Was At: </b> #{v}<br/>
			  <b>In: </b> #{c}<br/>
			  <b>Yelling: </b> #{s}<br/>
			  <b>On: </b> #{ca}<br/>
			  <b>Lat: </b> #{lat}<br/>
			  <b>Lng: </b> #{lng}
			  >>;
	  }
	  CloudRain:createLoadPanel("Foursquare", {}, html);
  
  }
}
