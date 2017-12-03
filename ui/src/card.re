let component = ReasonReact.statelessComponent("Card");

let to_elem = ReasonReact.stringToElement;
let make = (_children) => {
  ...component,
    render: (_self) =>
    <div className="card">
      <div className="card-header">
        <div className="card-title h5">
            (ReasonReact.stringToElement("dev.tide.ci"))
            <i className="devicon-sequelize-plain" />
        </div>
        <div className="card-subtitle text-gray">(ReasonReact.stringToElement("Deployment server located in the woods"))</div>
      </div>
      <div className="card-body">
        (ReasonReact.stringToElement("Software and hardware"))
      </div>
      <div className="card-footer">
        <button className="btn btn-primary">(to_elem("Do"))</button>
      </div>
    </div>
};
