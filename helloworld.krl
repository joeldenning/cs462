ruleset HelloWorldApp {
  meta {
    name "Hello Joel"
    description <<
      Hello World
    >>
    author "Joel Denning"
    logging off
  }
  dispatch {
  }
  global {
  }
  rule HelloWorld is active {
    select when pageview ".*"
    notify("Notification 1") with sticky = true;
    notify("Notification 2") with sticky = true;
  }
}