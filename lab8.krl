//b505970x0, b505971x0
ruleset catch_location {
  meta {
    logging off
    use module a169x701 alias CloudRain
    use module a41x186  alias SquareTag
  }

  rule location_catch {
    select when location notification
    pre {
      data = event:attr("fs_checkin").decode();
      venue = data.pick("$..venue").encode();
      city = data.pick("$..city").encode();
      shout = data.pick("$..shout").encode();
      date = data.pick("$..createdAt").encode();
      location = venue.pick("$..location").encode();
      lat = location.pick("$..lat").encode();
      lng = location.pick("$..lng").encode();
    } 
    fired {
      set ent:data data;
      set ent:venue venue;
      set ent:city city;
      set ent:shout shout;
      set ent:date date;
      set ent:lat lat;
      set ent:lng lng;
      set ent:alive "yes alive 2";
    }
  }
  
  
  rule display{
    select when web cloudAppSelected
    pre{
      data = ent:data.as("str");
      venue = ent:venue.pick("$.name").as("str");
      city = ent:city.as("str");
      shout = ent:shout.as("str");
      date = ent:date.as("str");
      lat = ent:lat.as("str");
      lng = ent:lng.as("str");
      alive = ent:alive;
      
      html = <<
      <h1>Checkin Data Lab 8: </h1>
      <b>I Was At: </b> #{venue}<br/>
      <b>In: </b> #{city}<br/>
      <b>Shouting: </b> #{shout}<br/>
      <b>On: </b> #{date}<br/>
      <b>latitude: </b> #{lat}<br/>
      <b>longitude: </b> #{lng}<br/>
      <br> #{alive}
      <br>
      <b>Data: </b> #{data} <br/>
      <br/>
      >>;
    }
      CloudRain:createLoadPanel("LAST CHECKIN", { },  html);
  }
}
