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
  
//  global {
//      distanceBetweenTwoPoints = function(lat1, lng1, lat2, lng2) {
//	  		r90   = math:pi()/2;      
//	      rEm   = 3963.1676;         // radius of the Earth in mi
//	       
//	      rlata = math:deg2rad(lata);
//	      rlnga = math:deg2rad(lnga);
//	      rlatb = math:deg2rad(latb);
//	      rlngb = math:deg2rad(lngb);
//	      math:great_circle_distance(rlnga,r90 - rlata, rlngb,r90 - rlatb, rEm);
//      }
  	
//      calculateDistance = function(curLat, curLng) {
//  	      lastCheckin = Location:getLocation("fs_checkin");
//	      checkinLat = lastCheckin.pick("$.lat");
//	      checkinLong = lastCheckin.pick("$.lng");
//	      distanceBetweenTwoPoints(curLat, curLng, checkinLat, checkingLong);
// 	}
//}
  
  rule hello {
  	select when pageview ".*"
  	notify("hello", "world");
  }	
  
//  rule listenHelloWorld {
//  	select when update_to_location new_location
//  	notify("update to location", "received") with sticky = true;
// }
  
//   rule listenForNewLocation {
//    select when update_to_location new_location
//    pre{
//    	lat = event:attr("lat");
//    	lng = event:attr("lng");
//    	dist = calculateDistance(122, 134);
//    }
//   if dist < 50 then  {
//   	send_directive("location") with latitude = lat and longitude = lng;
//    }
//    fired{
//    	raise explicit event location_near with distance = dist;
//    }
//   else {
//    	raise explicit event location_far with distance = dist;
//    }
//  }
//}
