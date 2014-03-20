//b505218x5
//twilio account number: AC5b745cf6b2fd4c0036541da07611921e
//twilio auth token: 6eead8d6bc0cd85f7fcd91220566e1ff
ruleset b505218x5 {
  meta {
    name "Text Message Sender"
    description <<
        Sends texts through twilio
    >>
    key twilio{
        "account_sid" : "AC5b745cf6b2fd4c0036541da07611921e",
        "auth_token"  : "6eead8d6bc0cd85f7fcd91220566e1ff"
    }
    use module a8x115 alias twilio with twiliokeys = keys:twilio()
    logging off
  }
   
  // create a rule that is fired on an inbound call
  rule answer {
    select when twilio inbound_call   
    pre{
        // find out who is calling
        callerid = event:attr("from");
        // set up a directory
        dir = {
                "+911": "The Man",
                "+8015552311": "Big Bird",
                "+8029875634": "Scam Artist"
            };
        dir_match = dir.pick("$.#{callerid}");
    name = dir_match.length() != 0 => dir_match | "Monkey";
    }
    {
        // Give Formal Greeting
        twilio:say("Hello #{name}");
        twilio:hangup();
    }
  }
