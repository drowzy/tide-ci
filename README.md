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

## Examples

```
POST http://localhost:4000/api/v1/hosts
Content-Type: application/json
{
  "name": "my.vm.host",
  "is_active": true,
  "hostname": "192.168.90.15",
  "description": "coolest host ever built",
  "credentials": {
    "user": "ubuntu"
  }
}
```
```
PUT http://localhost:4000/api/v1/hosts/8ea76b34-b53c-4ba1-8058-e66ccedda701/connect
Content-Type: application/json
Accept: application/json
{
  "user": "ubuntu"
}
```
* Add project
```
POST http://localhost:4000/api/v1/projects
Content-Type: application/json
Accept: application/json
{
  "vcs_url": "git@github.com:drowzy/tide-ci.git",
  "owner": "drowzy",
  "name": "tide-ci",
  "description": "Agent less CI"
}
```
* Start job
```
POST http://localhost:4000/api/v1/projects/<id>/jobs
```
