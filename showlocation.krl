ruleset ShowLocation {
  meta {
      name "Show Location"
      description <<
        Checkin In With Foursquare
      >>
      author ""
      logging off
      use module a169x701 alias CloudRain
      use module a41x186 alias SquareTag
      
      use module b505218x1 alias LocationData

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
      <br/>
      >>;
    }
    CloudRain:createLoadPanel("Foursquare", {}, html);
  }

}
