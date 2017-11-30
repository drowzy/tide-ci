defmodule TideWeb.ProjectControllerTest do
  use TideWeb.ConnCase

  alias Tide.Schemas.Project

  @create_attrs %{
    name: "super project",
    owner: "drowzy",
    vcs_url: "https://github.com/drowzy/tide-ci",
    description: ""
  }

  @update_attrs %{description: "A new description"}
  @invalid_attrs %{vsc_url: nil, owner: nil, name: nil}

  setup [:fixture]

  describe "index" do
    test "lists all projects", %{conn: conn} do
      conn = get(conn, project_path(conn, :index))

      resp =
        conn
        |> json_response(200)
        |> length > 0
    end
  end

  describe "show" do
    test "should return project with :id", %{conn: conn, project: project} do
      conn = get(conn, project_path(conn, :show, project.id))
      resp = json_response(conn, 200)

      assert resp["id"] == project.id
    end
  end

  describe "create project" do
    test "can create a project with valid params" do
      conn = post(conn, project_path(conn, :create), @create_attrs)
      assert json_response(conn, 201)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, project_path(conn, :create), @invalid_attrs)
      assert json_response(conn, 422)
    end
  end

  describe "update project" do
    test "renders project when data is valid", %{
      conn: conn,
      project: %Project{id: id} = project
    } do
      description = @update_attrs.description
      conn = put(conn, project_path(conn, :update, project), @update_attrs)
      assert %{"id" => ^id, "description" => ^description} = json_response(conn, 200)
    end
  end

  describe "delete project" do
    test "deletes chosen project", %{conn: conn, project: project} do
      conn = delete(conn, project_path(conn, :delete, project))
      assert response(conn, 204)
    end
  end

  defp fixture(_) do
    {:ok, project} = Project.create(@create_attrs)

    {:ok, project: project}
  end
end
