//b505218x15
//twilio account number: AC5b745cf6b2fd4c0036541da07611921e
//twilio auth token: 6eead8d6bc0cd85f7fcd91220566e1ff 
ruleset TextMessageSender{ 
  meta {
    logging off
    use module a169x701 alias CloudRain
    use module a41x186  alias SquareTag
    
    key twilio {
      "account_sid" : "AC60e0dcd4d3a1cd0d2a7a2f928948ed3d",
      "auth_token"  : "2d1231266fd6f7722030389690e5fd6e"
    }
    
    use module a8x115 alias twilio with twiliokeys = keys:twilio()
    
  }
  
  rule near {
    select when explicit location_near
    pre {
      distance = event:attr("distance");
      message = "Event Fired from " + distance.as("str") + " miles away.";
    }
    {
      send_directive(message) with dist = distance;
      twilio:send_sms("18015560842", "13852357224" , message);
    }
    
  }
  
  rule far {
    select when explicit location_far
    pre {
      distance = event:attr("distance");
      message = "Very Far away: Event Fired from " + distance.as("str") + " miles away.";
    }
    {
      send_directive(message) with dist = distance;
    }
  }
 
  rule sms {
    select when pageview ".*"
    {
    twilio:send_sms("18015560842", "13852357224" , "This is a test text");
    notify("Text Sent Update", "Yay, Your message has been sent");
    }
  }
    
}
