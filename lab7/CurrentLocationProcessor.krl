//b505218x14
ruleset CurrentLocationProcessor {
  meta {  
    name "Current Location Processor"
    description <<
      Current Location Processor
    >>
    author ""
    logging off
	use module a169x701 alias CloudRain
	use module a41x186  alias SquareTag

  }
  
   rule process_fs_checkin{
    select when current_location
    
    pre{
    	data = "data";
    }
    {
     	notify("Hello", "world");
    }
    fired{
  	raise pds event location_nearby for b505218x10
  		with key = "location"
  		and value = "Current Location Processor";
    }
  }
}
