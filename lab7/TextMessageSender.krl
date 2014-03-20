//b505218x10
//twilio account number: AC5b745cf6b2fd4c0036541da07611921e
//twilio auth token: 6eead8d6bc0cd85f7fcd91220566e1ff
ruleset b505218x5 {
  meta {
         
        key twilio {"account_sid" : "AC5b745cf6b2fd4c0036541da07611921e",
                    "auth_token"  : "6eead8d6bc0cd85f7fcd91220566e1ff"
        }
         
        use module a8x115 alias twilio with twiliokeys = keys:twilio()
        
  } 
    rule sms {
      select when pageview ".*"
      twilio:send_sms("18015560842", "13852357284", "test message");
    }
   
}
