[%bs.raw {|require('./App.css')|}];

/* [@bs.module] external logo : string = "./logo.svg"; */

let component = ReasonReact.statelessComponent("App");

let make = (~message, _children) => {
  ...component,
  render: (_self) =>
    <div className="App">
      <header className="navbar Header__navigation">
        <section className="navbar-section">
          <a className="navbar-brand mr-2" style=(ReactDOMRe.Style.make(~fontWeight="600", ~textTransform="uppercase", ()))>
            (ReasonReact.stringToElement("TIDE CI"))
          </a>
        </section>
        <section className="navbar-section">
          <div className="input-group input-inline">
            <input className="form-input" />
            <button className="btn btn-primary input-group-btn">
              (ReasonReact.stringToElement("Search"))
            </button>
          </div>
        </section>
      </header>
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
              <ProjectList />
            </div>
          </div>
        </div>
      </div>
    </div>
};
