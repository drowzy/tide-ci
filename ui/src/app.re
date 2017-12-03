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
      <div className="container">
        <div className="columns">
          <div className="column col-2">
            <ul className="menu">
              <li className="divider"/>
              <li className="menu-item">
                <a>
                  <i className="icon icon-link"/>
                  (ReasonReact.stringToElement("Slack"))
                </a>
              </li>
              <li className="divider"></li>
              <li className="menu-item">
                <div className="menu-badge">
                  <label className="label label-primary">(ReasonReact.stringToElement("2"))</label>
                </div>
                <a>
                  <i className="icon icon-link"></i>(ReasonReact.stringToElement("Settings"))
                </a>
              </li>
            </ul>
          </div>
          <div className="column col-14">
          </div>
        </div>
      </div>
    </div>
};
