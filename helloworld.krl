ruleset HelloWorldApp {
  meta {
    name "Hello Joel"
    description << Hello World >>
    author "Joel Denning"
    logging on
  }
  dispatch {
  }
  global {
  }
  rule notifications is active {
    select when pageview ".*"
    notify("Notification 1") with sticky = true;
  }
}