type t = {
  id: string,
  vcs_url: string,
  slug: string,
  owner: string,
  name: string,
  description: string
};

module Build = {
  type status =
  | Pending
  | Started
  | Cancelled
  | Success
  | Failure;

  type t = {
    id: string,
    status: status,
    log: array(string)
  };

  let str_to_status = str => {
    switch str {
      | "pending" => Pending
      | "started" => Started
      | "cancelled" => Cancelled
      | "success" => Success
      | "failure" => Failure
      | _ => raise(Not_found)
    };
  }
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

  let build = (json) : Build.t => {
    id: json |> field("id", string),
    status: json |> field("status", string) |> Build.str_to_status,
    log: json |> field("log", array(string))
  };

  let builds = json => json |> array(repo)
};

let headers = Fetch.HeadersInit.makeWithArray([|("Content-type", "application/json"), ("Accept", "application/json")|]);

let fetch_repos = (callback) =>
  Js.Promise.(
    Fetch.fetchWithInit("/api/v1/projects", Fetch.RequestInit.make(~headers=headers,()))
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

let build_repo = (id, callback) =>
  Js.Promise.(
    Fetch.fetchWithInit("/api/v1/projects/" ++ id ++ "/jobs", Fetch.RequestInit.make(~method_=Post, ~headers=headers, ()))
    |> then_(Fetch.Response.json)
    |> then_(json => json |> Decode.repo |> resolve)
    |> then_((job) => callback(job) |> resolve)
    |> ignore
  );

let fetch_repo_builds = (id, callback) =>
  Js.Promise.(
    Fetch.fetchWithInit("/api/v1/projects/" ++ id ++ "/jobs", Fetch.RequestInit.make(~headers=headers, ()))
    |> then_(Fetch.Response.json)
    |> then_(json => json |> Decode.builds |> resolve)
    |> then_((builds) => callback(builds) |> resolve)
    |> ignore
  );

let build_repo = (id, callback) =>
  Js.Promise.(
    Fetch.fetchWithInit("/api/v1/projects/" ++ id ++ "/jobs", Fetch.RequestInit.make(~method_=Post, ~headers=headers, ()))
    |> then_(Fetch.Response.json)
    |> then_(json => json |> Decode.repo |> resolve)
    |> then_((job) => callback(job) |> resolve)
    |> ignore
  );
