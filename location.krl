ruleset location_data {
  meta {
    name "Location Data"
    description <<
      Location Data
    >>
    author ""
    logging off
    provide get_location_data
  }
  
  rule add_location_item {
    select when pds:new_location_data
    pre {
      key = event:attr("key");
      value = event:attr("value");
    }
    fired {
      ent:map.put( [ key ], value );
    }
  
  }
  
  
}
