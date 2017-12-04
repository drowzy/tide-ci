type t = {
  id: string,
  vcs_url: string,
  slug: string,
  owner: string,
  name: string,
  description: string
};

module Decode = {
  open! Json.Decode;
  let repo = json => {
    id: json |> field("id", string),
    vcs_url: json |> field("vcs_url", string),
    slug: json |> field("slug", string),
    owner: json |> field("owner", string),
    name: json |> field("name", string),
    description: json |> field("description", string)
  };

  let repos = json => {
    json |> array(repo)
  };
};

let fetch_repos = (callback) =>
  Js.Promise.(
    Fetch.fetch("http://localhost:4000/api/v1/projects")
    |> then_(Fetch.Response.json)
    |> then_(json => json |> Decode.repos |> resolve)
    |> then_((repos) => callback(repos) |> resolve)
    |> ignore
  );

let fetch_repos_by_id = (id, callback) =>
  Js.Promise.(
    Fetch.fetch("/api/v1/projects/" ++ id)
    |> then_(Fetch.Response.json)
    |> then_(json => json |> Decode.repo |> resolve)
    |> then_((repo) => callback(repo) |> resolve)
    |> ignore
  );

