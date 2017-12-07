[%bs.raw {|require('./JobList.css')|}];

let component = ReasonReact.statelessComponent("JobList");

let make = (_children) => {
  ...component,
    render: (_self) =>
    <div className="tile tile-centered">
      <div className="tile-icon">
        <div className="JobList-icon">
          <i className="devicon-nodejs-plain centered" />
        </div>
      </div>
      <div className="tile-content">
        <div className="tile-title">(ReasonReact.stringToElement("drowzy/live.js"))</div>
          <div className="tile-subtitle text-gray centered">
            (ReasonReact.stringToElement("1 Jan, 2017 f56de64 "))
             <span className="label label-success">(ReasonReact.stringToElement("Success"))</span>
          </div>
      </div>
      <div className="tile-action">
        <button className="btn btn-link">
        </button>
      </div>
    </div>
};
