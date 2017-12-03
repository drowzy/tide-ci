[%bs.raw {|require('./sidebar.css')|}];

let component = ReasonReact.statelessComponent("Sidebar");

let make = (_children) => {
  ...component,
    render: (_self) =>
      <div id="sidebar-id" className="Sidebar off-canvas-sidebar">
        <div className="Sidebar__brand">
          <i className="devicon-docker-plain" />
        </div>
        <div className="divider" style=(ReactDOMRe.Style.make(~borderTop=".05rem solid #7270da87", ())) />
        <ul className="nav">
          <li className="Sidebar__Nav-Item">
            <a href="#">(ReasonReact.stringToElement("Projects"))</a>
            <i className="icon icon-arrow-right" />
          </li>
          <li className="Sidebar__Nav-Item">
            <a href="#">(ReasonReact.stringToElement("Machines"))</a>
            <i className="icon icon-arrow-right" />
          </li>
          <li className="Sidebar__Nav-Item">
            <a href="#">(ReasonReact.stringToElement("Jobs"))</a>
            <i className="icon icon-arrow-right" />
          </li>
          <li className="Sidebar__Nav-Item">
            <a href="#">(ReasonReact.stringToElement("Builds"))</a>
            <i className="icon icon-arrow-right" />
          </li>
        </ul>
      </div>
}
