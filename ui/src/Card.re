type action =
  | ReceiveRepos(array(Repo.t))
  | Build(Repo.t);

type state = {
  repos: array(Repo.t)
};

let receive_repos = repos => ReceiveRepos(repos);
let initialState = () => { repos: [||] };

let component = ReasonReact.reducerComponent("Card");

let make = (_children) => {
  let renderCard = (repo : Repo.t, ~handleClick) =>
    <div className="column col-4">
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
          <button className="btn btn-primary" onClick={handleClick}>(ReasonReact.stringToElement("Build"))</button>
        </div>
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
        | Build(_repo) => ReasonReact.SilentUpdate(state)
      };
    },
    render: ({ state }) => {
      switch state.repos {
        | [||] => (<div className="loading-lg" />)
        | repos => repos |> Array.map(repo => renderCard(repo, ~handleClick=(_event) => Repo.build_repo(repo.id, ignore))) |> ReasonReact.arrayToElement
      };
    }
  }
};
