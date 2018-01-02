[%bs.raw {|require('./ProjectDetails.css')|}];


type log = List(string);

type result =
  | Ok(Repo.t)
  | Loading;

type action =
  | ReceiveRepo(Repo.t)
  | ReceiveBuilds(array(Repo.Build.t));

type state = {
  repo: result,
  builds: array(Repo.Build.t)
};

let initialState = () => { repo: Loading, builds: [||] };
let receive_repo = repo => ReceiveRepo(repo);
let receive_builds = builds => ReceiveBuilds(builds);

let component = ReasonReact.reducerComponent("ProjectDetails");

let make = (~id, _children) => {
  let renderCodeBlock = (build: Repo.Build.t) =>
    <div>
      (switch build.status {
        | Success => <span className="label label-success">(ReasonReact.stringToElement("Success"))</span>
        | Failure => <span className="label label-error">(ReasonReact.stringToElement("Failed"))</span>
        | _ => <span className="label">(ReasonReact.stringToElement("N/A"))</span>
      })
      <pre className="code">
        <code className="build-log">
          (ReasonReact.stringToElement(String.concat("", Array.to_list(build.log))))
        </code>
      </pre>
    </div>;

  let renderProject = (repo: Repo.t, builds) =>
    <div className="test">
      <div className="project-title ">
          <h2>
            (ReasonReact.stringToElement(repo.owner ++ " / " ++ repo.name ))
            <i className="devicon-github-plain-wordmark" style=(ReactDOMRe.Style.make(~marginLeft="1rem", ~fontSize="1.5rem", ~verticalAlign="middle", ())) />
          </h2>
      </div>
      (builds |> Array.map(renderCodeBlock) |> ReasonReact.arrayToElement)
    </div>;
  {
    ...component,
    initialState,
    didMount: (self) => {
      Repo.fetch_repos_by_id(id, self.reduce(receive_repo));
      Repo.fetch_repo_builds(id, self.reduce(receive_builds));
      ReasonReact.NoUpdate
    },
    reducer: (action, state) => {
      switch action {
        | ReceiveRepo(repo) => ReasonReact.Update({...state, repo: Ok(repo)})
        | ReceiveBuilds(builds) => ReasonReact.Update({...state, builds: builds})
      };
    },
    render: ({ state }) => {
      switch state.repo {
        | Ok(repo) => renderProject(repo, state.builds)
        | Loading => (<div className="loading-lg" />)
      };
    }
  }
};
