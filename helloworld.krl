ruleset FourSquareCheckin {
  meta {
    name "Four Square Checkin"
    description <<
      Four Square Check in
    >>
    author ""
    logging off
    use module a169x701 alias CloudRain
    use module a41x186  alias SquareTag
  }
  
  rule process_fs_checkin {
    select when foursquare checkin
    pre {
      data = event:attr("checkin").decode();
      venue = data.pick("$..venue");
      shout = data.pick("$..shout");
      c = data.pick("$..city");
      createdAt = data.pick("$..createdAt");
    }
    fired {
      set ent:venue venue;
      set ent:shout shout;
      set ent:c c;
      set ent:createdAt createdAt;
      set ent:data event:attr("checkin").as("str");
    	raise pds event new_location_data for b505218x1
        with key = "fs_checkin"
        and value = {"venue" : venue.pick("$.name"), "city" : c, "shout" : shout, "date" : createdAt};
    }
  }
  
  rule display {
    select when cloudAppSelected
    pre {
      venue = ent:venue.pick("$.name").as("str");
      shout = ent:shout.as("str");
      c = ent:c.as("str");
      createdAt = ent:createdAt.as("str");
      //data = ent:data.as("str");
      
      html = <<
        <b>I Was At: </b> #{venue}<br/>
        <b>Shout: </b> #{shout}<br/>
        <b>City: </b> #{c}<br/>
        <b>Created At: </b> #{createdAt}<br/>
        #{data}
      >>
    }
    CloudRain:createLoadPanel("Foursquare", {}, html);
    
  }
}
