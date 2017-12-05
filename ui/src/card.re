type action =
  | ReceiveRepos(array(Repo.t));

type state = {
  repos: array(Repo.t)
};

let receive_repos = repos => ReceiveRepos(repos);
let initialState = () => { repos: [||] };

let component = ReasonReact.reducerComponent("Card");

let make = (_children) => {
  let renderCard = (repo : Repo.t) =>
    <div className="card">
      <div className="card-header">
        <div className="card-title h5">
            (ReasonReact.stringToElement(repo.slug))
            <i className="devicon-sequelize-plain" />
        </div>
        <div className="card-subtitle text-gray">(ReasonReact.stringToElement(repo.description))</div>
      </div>
      <div className="card-body">
        (ReasonReact.stringToElement(repo.vcs_url))
      </div>
      <div className="card-footer">
        <button className="btn btn-primary">(ReasonReact.stringToElement("Build"))</button>
      </div>
    </div>;
  {
    ...component,
    initialState,
    didMount: (self) => {
      Repo.fetch_repos(self.reduce(receive_repos));
      ReasonReact.NoUpdate;
    },
    reducer: (action, state) => {
      switch action {
        | ReceiveRepos(repos) => ReasonReact.Update({...state, repos: repos})
      };
    },
    render: ({ state }) => {
      switch state.repos {
        | [||] => (<div className="loading-lg" />)
        | repos => repos |> Array.map(repo => renderCard(repo)) |> ReasonReact.arrayToElement
      };
    }
  }
};
