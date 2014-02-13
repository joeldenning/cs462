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
    notify("Hello World", "This is a sample rule.") with sticky = true;
  }
}