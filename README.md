# Tide

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `tide_ci` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:tide_ci, "~> 0.1.0"}
  ]
end
```
## Enteties

* Accounts (users)
```
{
  "id": "ecf08eea-9a10-47ab-aef4-16aaf158d414",
  "name": "Simon",
  "email": "simon@simon.com",
  "password_hash": "a2psa2phc2xmamxha2pzZmxh"
}
```
* Projects / Pipeline
```json
{
  "id": "7374759f-e504-4d72-8adf-845514ba8ff8",
  "name": "tide",
  "repository": <repository>,
  "jobs": [<job>]
}
```
* Jobs
```json
{
  "id": "3d44c531-beab-4025-896e-592a57a15de0",
  "status": "started | failed | finished",
  "timestamp": 1508616202,
  "project_id": "f4baff84-4932-4f28-a943-0ec0b3146d87",
  "finished": 1508616235,
  "executor": ""
}
```
* Repository
```json
{
  "id": "aab7fb98-851f-45bc-b6ce-ee9a0d18e67c",
  "type": "https | ssh",
  "uri": "git@github.com/simon/tide",
}
```
* Credentials
```json
{
  "id": "6b260080-2292-4648-898c-a23aed79f8d8",
  "type": "certs | pass",
  "private_key": "<public_key>"
  "public_key": "<private_key>"
}
```
* Hosts
```json
{
  "id": "024ffe00-43c2-4d3f-a1a9-6387e38b1dcb",
  "name": "hostname",
  "hostname": "hostname",
  "ip": "127.0.0.1",
  "docker_port"
}
```
Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/tide_ci](https://hexdocs.pm/tide_ci).
