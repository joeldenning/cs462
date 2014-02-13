ruleset b505218x0 {
  meta {
    name "Hello Joel"
    description << Hello World >>
    author "Joel Denning"
    logging on
  }
  rule notifications is active {
    select when pageview ".*"
    notify("Notification 1", "This is a notification") with sticky = true;
    notify("Notification 2", "This is also notification") with sticky = true;
  }
}