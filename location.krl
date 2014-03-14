ruleset location_data {
  meta {
    name "Location Data"
    description <<
      Location Data
    >>
    author ""
    logging off
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
    pre {
      key = event:attr("key");
      value = event:attr("value");
      map = {};
      map = map.put([key], value);
    }
    {
      notify("Location Data ruleset received event!", "Woo hoo!") with sticky = true;
    }
    always {
      set ent:locationData map;
    }
  }
  
  
}
