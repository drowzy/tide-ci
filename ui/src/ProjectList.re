[%bs.raw {|require('./ProjectList.css')|}];

type action =
  | ReceiveRepos(array(Repo.t))
  | Build(Repo.t);

type state = {
  repos: array(Repo.t)
};

let receive_repos = repos => ReceiveRepos(repos);
let initialState = () => { repos: [||] };

let component = ReasonReact.reducerComponent("ProjectList");

let make = (_children) => {
  let renderProjectEntry = (repo : Repo.t, ~handleClick) =>
    <div className="tile tile-centered project-list">
      <div className="tile-icon">
        <div className="project-icon">
          <i className="devicon-nodejs-plain centered" />
        </div>
      </div>
      <div className="tile-content">
        <div className="tile-title">(ReasonReact.stringToElement(repo.slug))</div>
          <div className="tile-subtitle text-gray centered">
            (ReasonReact.stringToElement(repo.description))
          </div>
      </div>
      <div className="tile-action">
        <button className="btn btn-link" onClick={handleClick}>(ReasonReact.stringToElement("Build"))</button>
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
        | repos => repos |> Array.map(repo => renderProjectEntry(repo, ~handleClick=(_event) => Repo.build_repo(repo.id, ignore))) |> ReasonReact.arrayToElement
      };
    }
  }
};
