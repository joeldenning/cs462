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
	use module b505218x13 alias CheckinProvider
  }
  
  global {
    distance_calc = function(lata,lnga,latb,lngb){
      r90   = math:pi()/2;      
      rEm   = 3963.1676;         // radius of the Earth in mi
       
      rlata = math:deg2rad(lata);
      rlnga = math:deg2rad(lnga);
      rlatb = math:deg2rad(latb);
      rlngb = math:deg2rad(lngb);
      distance = math:great_circle_distance(rlnga,r90 - rlata, rlngb,r90 - rlatb, rEm);
      distance;
    }

    distance_from_current = function(lat,long){
      last_checkin = CheckinProvider:getLocation("fs_checkin");
      latb = last_checkin.pick("$.lat");
      longb = last_checkin.pick("$.lng");
      d = distance_calc(lat, long, latb, longb);
      d;
    }
  }
  
  rule hello {
  	select when pageview ".*"
  	notify("hello", "world");
  }	
  
//  rule listenHelloWorld {
//  	select when update_to_location new_location
//  	send_directive("location") with latitude = 15 and longitude = lng;
// }
  
   rule listenForNewLocation {
    select when update_to_location new_location
    pre{
    	lat = event:attr("lat");
    	lng = event:attr("lng");
    	dist = distance_from_current(lat, lng);
    }
   if dist < 50 then  {
   	send_directive("location") with distance = dist and latitude = lat and longitude = lng;
    }
    fired{
    	raise explicit event location_near with distance = dist;
    }
   else {
    	raise explicit event location_far with distance = dist;
    }
  }
}
