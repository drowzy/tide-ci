[%bs.raw {|require('./Header.css')|}];

let component = ReasonReact.statelessComponent("Header");

let make = (_children) => {
  ...component,
    render: (_self) =>
      <header className="navbar Header__navigation">
        <section className="navbar-section">
          <a className="navbar-brand mr-2" style=(ReactDOMRe.Style.make(~fontWeight="600", ~textTransform="uppercase", ()))>
            (ReasonReact.stringToElement("TIDE CI"))
          </a>
        </section>
        <section className="navbar-section">
        </section>
      </header>
};
