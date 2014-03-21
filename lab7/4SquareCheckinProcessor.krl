//b505218x12
ruleset FourSquare {
  meta {
    name "FourSquare"
    description <<
      Foursquare Checkin
    >>
    logging off
    use module a169x701 alias CloudRain
    use module a41x186  alias SquareTag
    
    use module b505218x13 alias LocationData

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
	
    fired {
    	set ent:data event:attr("checkin").as("str");
    	set ent:venue venue;
	set ent:city city;
 	set ent:shout shout;
        set ent:date date;
        set ent:lat lat;
        set ent:lng lng;
        
        raise pds event new_location_data for LocationData
		with key = "fs_checkin"
		and value = {"venue" : venue.pick("$.name"), "city" : city, "shout" : shout, "date" : date, "lat" : lat, "lng" : lng};
    }

  }

  rule display{
    select when web cloudAppSelected
    pre{
        data = ent:data;
        venue = ent:venue.pick("$.name").as("str");
	city = ent:city.as("str");
	shout = ent:shout.as("str");
	date = ent:date.as("str");
	lat = ent:lat.as("str");
	lng = ent:lng.as("str");
         
        html = <<
		  <h1>Checkin Data: </h1>
		  <b>I Was At: </b> #{venue}<br/>
		  <b>In: </b> #{city}<br/>
		  <b>Yelling: </b> #{shout}<br/>
		  <b>On: </b> #{date}<br/>
		  <b>lat </b> #{lat}<br/>
		  <b>lng </b> #{lng}<br/>
		  <br>
		  <b>Data: </b> #{data} <br/>
		  <br/>
		   >>;
    }
       CloudRain:createLoadPanel("Hello World!", { },  html);
       
    }
   
}
