[%bs.raw {|require('./App.css')|}];
/* [@bs.module] external logo : string = "./logo.svg"; */

let component = ReasonReact.statelessComponent("App");

let make = (~route, ~router, _children) => {
  ...component,
  render: (_self) => {
    let page = switch route {
      | Routing.Overview => <ProjectList router />
      | Routing.ProjectRoute(_id) => <ProjectDetails />
      | Routing.ProjectBuildsRoute(_id) => <ProjectList router />
      | Routing.ProjectBuildRoute(_projectId, _id) => <Build />
    };

    <div className="App">
      <Header />
      <div className="off-canvas">
        <a className="off-canvas-toggle btn btn-primary btn-action">
          <i className="icon icon-menu"></i>
        </a>
        <Sidebar />
        <a className="off-canvas-overlay" />
        <div className="off-canvas-content">
          <div className="container">
            <ul className="breadcrumb" style=(ReactDOMRe.Style.make(~paddingBottom="0.5rem", ()))>
              <li className="breadcrumb-item">
                <a href="#">(ReasonReact.stringToElement("Home"))</a>
              </li>
              <li className="breadcrumb-item">
                <a href="#">(ReasonReact.stringToElement("Projects"))</a>
              </li>
              <li className="breadcrumb-item">
                <a href="#">(ReasonReact.stringToElement("Builds"))</a>
              </li>
            </ul>
            <div className="columns">
              page
            </div>
          </div>
        </div>
      </div>
    </div>
  }
};
