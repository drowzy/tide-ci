[%bs.raw {|require('./Sidebar.css')|}];

let component = ReasonReact.statelessComponent("Build");

let make = (_children) => {
  ...component,
    render: (_self) =>
      <div className="foo">
        (ReasonReact.stringToElement("hello"))
      </div>
};
