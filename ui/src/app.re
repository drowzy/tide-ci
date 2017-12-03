[%bs.raw {|require('./app.css')|}];

[@bs.module] external logo : string = "./logo.svg";

let component = ReasonReact.statelessComponent("App");

let make = (~message, _children) => {
  ...component,
  render: (_self) =>
    <div className="App">
      <header className="navbar Header__navigation">
        <section className="navbar-section">
          <a className="navbar-brand mr-2">
            (ReasonReact.stringToElement("Spectre.css"))
          </a>
          <a className="btn btn-link">
            (ReasonReact.stringToElement("Docs"))
          </a>
          <a className="btn btn-link">
            (ReasonReact.stringToElement("GitHub"))
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
        <div id="sidebar-id" className="off-canvas-sidebar">
          <ul className="nav">
            <li className="nav-item">
              <a href="#">(ReasonReact.stringToElement("Projects"))</a>
            </li>
            <li className="nav-item active">
              <a href="#">(ReasonReact.stringToElement("Builds"))</a>
              <ul className="nav">
                <li className="nav-item">
                  <a>(ReasonReact.stringToElement("Builds"))</a>
                </li>
                <li className="nav-item">
                  <a>(ReasonReact.stringToElement("Builds"))</a>
                </li>
                <li className="nav-item">
                  <a>(ReasonReact.stringToElement("Builds"))</a>
                </li>
                <li className="nav-item">
                  <a>(ReasonReact.stringToElement("Builds"))</a>
                </li>
              </ul>
            </li>
            <li className="nav-item">
              <a>(ReasonReact.stringToElement("Builds"))</a>
            </li>
            <li className="nav-item">
              <a>(ReasonReact.stringToElement("Shell"))</a>
            </li>
          </ul>
        </div>

        <a className="off-canvas-overlay" />

        <div className="off-canvas-content">
          <p>(ReasonReact.stringToElement(message))</p>
        </div>
      </div>
    </div>
};
