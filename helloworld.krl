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
      city = data.pick("$..city");
      createdAt = data.pick("$..createdAt");
    }
    fired {
      set ent:venue venue;
      set ent:shout shout;
      set ent:city city;
      set ent:createdAt createdAt;
      set ent:data event:attr("checkin").as("str");
    }
  }
  
  rule display {
    select when cloudAppSelected
    pre {
      venue = ent:venue.pick("$.name").as("str");
      shout = ent:name.as("str");
      city = ent:city.as("str");
      createdAt = ent:createdAt.as("str");
      data = ent:data.as("str");
      
      html = <<
        <b>I Was At: </b> #{venue}<br/>
        <b>Shout: </b> #{shout}<br/>
        <b>City: </b> #{city}<br/>
        <b>Created At: </b> #{createdAt}<br/>
        #{data}
      >>
    }
    CloudRain:createLoadPanel("Foursquare", {}, html);
    
  }
}
