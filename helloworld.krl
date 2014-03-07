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
  }
  
   rule process_fs_checkin{
    select when foursquare checkin
    
    pre{
    	data = event:attr("checkin").decode();
	venue = data.pick("$..venue");
	city = data.pick("$..city");
	shout = data.pick("$..shout");
	date = data.pick("$..createdAt");
    }
    
    fired{
	set ent:venue venue;
	set ent:city city;
 	set ent:shout shout;
        set ent:createdAt createdAt;
	set ent:data event:attr("checkin").as("str");
    }
  }
  
rule display_checkin{
    select when cloudAppSelected
	  pre {
		  v = ent:venue.pick("$.name").as("str");
		  c = ent:city.as("str");
		  s = ent:shout.as("str");
		  ca = ent:createdAt.as("str");
		  html = <<
			  <h1>Checkin Data:</h1>
			  <b>I Was At: </b> #{v}<br/>
			  <b>In: </b> #{c}<br/>
			  <b>Yelling: </b> #{s}<br/>
			  <b>On: </b> #{ca}<br/>
			  <b> AND NOW IM GONE </b>
			  <br/>
			  >>;
	  }
	  CloudRain:createLoadPanel("Foursquare", {}, html);
  
  }
}
