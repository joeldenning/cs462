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
      data = event:attr("checkin").decode()
      venue = data.pick("$..venue");
    }
    fired {
      set ent:venue venue;
    }
  }
  
  rule display {
    select when cloudAppSelected
    pre {
      v = ent:venue.pick("$.name").as("str");
      html = <<
        <b>I Was At: </b> #{v}<br/>
      >>
    }
    CloudRain:createLoadPanel("Foursquare", {}, html);
    
  }
}
