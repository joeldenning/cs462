ruleset location_data {
  meta {
    name "Four Square Checkin"
    description <<
      Four Square Check in
    >>
    author ""
    logging off
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
