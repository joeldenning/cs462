ruleset location_data {
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
      ent:map.pick(key);
    }
  }
  
  rule debug is active {
    select when web cloudAppSelected
    notify("Location Data ruleset is alive", ent:locationData.as("str")) with sticky = true;
  }
  
  rule add_location_item is active {
    select when pds new_location_data
//    pre {
//      k = event:attr("key");
//      v = event:attr("value");
//      map = {};
//      map = map.put([k], v);
//    }
    {
//      send_directive('Directive sent from location') with key = k and value = v;
      notify("Location Data ruleset received event!", "Woo hoo!") with sticky = true;
    }
//    always {
//      set ent:locationData "Location Data set";
//   }
  }
  
  
}
