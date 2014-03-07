ruleset HelloWorldApp {
  meta {
    name "Hello World"
    description <<
      Hello World
    >>
    author ""
    logging off
    use module a169x701 alias CloudRain
    use module a41x186  alias SquareTag
  }
  dispatch {
  }
  global {
  }
  
  rule process_fs_checkin is active {
    select when foursquare checkin
    pre {
      data = event:attr("checkin").decode()
      venue = data.pick("$..venue");
    }
    fired {
      set ent:venue venue;
    }
  }
  
  rule display is active {
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
