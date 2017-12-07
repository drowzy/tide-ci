[%bs.raw {|require('./Sidebar.css')|}];

type nav_link = {
  link: string,
  label: string
};

let links = [|
  { link: "#", label: "Repositories"},
  { link: "#", label: "Machines"},
  { link: "#", label: "Jobs"},
  { link: "#", label: "Builds"},
  { link: "#", label: "Settings"},
  { link: "#", label: "Shell"}
  |];

let component = ReasonReact.statelessComponent("Sidebar");

let make = (_children) => {
  ...component,
    render: (_self) =>
      <div className="Sidebar off-canvas-sidebar">
        <div className="Sidebar__brand">
          <i className="devicon-sequelize-plain" />
        </div>
        <div className="divider" style=(ReactDOMRe.Style.make(~borderTop=".05rem solid #7270da87", ())) />
        <ul className="nav">
          (Array.map(({ link, label }) =>
            <li className="Sidebar__Nav-Item">
              <a href=link>(ReasonReact.stringToElement(label))</a>
              <i className="icon icon-arrow-right" />
            </li>
          , links) |> ReasonReact.arrayToElement)
        </ul>
      </div>
};
