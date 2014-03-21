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
    	set app:data event:attr("checkin").as("str");
    	set app:venue venue;
	set app:city city;
 	set app:shout shout;
        set app:date date;
        set app:lat lat;
        set app:lng lng;
        
        raise pds event new_location_data for b505218x13
		with key = "fs_checkin"
		//and value = {"venue" : venue.pick("$.name"), "city" : city, "shout" : shout, "date" : date, "lat" : lat, "lng" : lng};
		and value = "a value";
    }

  }

  rule display{
    select when web cloudAppSelected
    pre{
        data = app:data;
        venue = app:venue.pick("$.name").as("str");
	city = app:city.as("str");
	shout = app:shout.as("str");
	date = app:date.as("str");
	lat = app:lat.as("str");
	lng = app:lng.as("str");
         
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
