ruleset LocationData {
  meta {
    name "Location Data"
    description <<
      Location Data
    >>
    author ""
    logging off
    use module a169x701 alias CloudRain
    use module a41x186  alias SquareTag
    provides get_location_data
  }
  
  global {
    get_location_data = function(key) {
      ent:locationData{key} || {};
    }
  }
  
  rule display_checkin {
    select when cloudAppSelected
    	pre
      {
        checkin = getLocation("fs_checkin");
        
        venue = checkin.pick("$.venue").encode().as("str");
        city = checkin.pick("$.city").encode();
        shout = checkin.pick("$.shout").encode();
        date = checkin.pick("$.date").encode();
        html_output = <<
        <p>We Here: #{venue} </p>
        <p>In: #{city} <br /></p>
        <p>Shout: #{shout} <br /></p>
        <p>Date: #{date} <br /></p>
        >>;
        checkin_header = << <div id="main">Checkin: </div><br />
        <div id="checkinInfo"/> >>;
      }
      {
        CloudRain:createLoadPanel("Foursquare Checkin info",{},checkin_header);
        append("#main", html_output);
      }
  }
  
  rule add_location_item is active {
    select when pds new_location_data
    pre {
      k = event:attr("key");
      v = event:attr("value");
      map = {};
      map = map.put([k], v);
    }
    {
      send_directive('Directive sent from location') with key = k and value = v;
    }
    always {
      set ent:locationData map;
    }
  }
  
  
}
