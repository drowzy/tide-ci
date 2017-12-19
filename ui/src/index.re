[%bs.raw {|require('spectre.css/dist/spectre.min.css')|}];
[%bs.raw {|require('spectre.css/dist/spectre-exp.min.css')|}];
[%bs.raw {|require('spectre.css/dist/spectre-icons.css')|}];
[%bs.raw {|require('./index.css')|}];

let router = DirectorRe.makeRouter({
  "/": "overview",
  "/projects/:id": "project",
  "/projects/:projectId/builds": "projectBuilds",
  "/projects/:projectId/builds/:id": "build"
});

let renderForRoute = (route, router) =>
  ReactDOMRe.renderToElementWithId(<App route router />, "root");

let handlers = {
  "overview": () => renderForRoute(Routing.Overview, router),
  "project": (id: string) => renderForRoute(Routing.ProjectRoute(id), router),
  "projectBuilds": (id: string) => renderForRoute(Routing.ProjectBuildsRoute(id), router),
  "build": (projectId: string, id: string) => renderForRoute(Routing.ProjectBuildRoute(projectId, id), router)
};

DirectorRe.configure(router, {
  "html5history": true,
  "resource": handlers
});

DirectorRe.init(router, "/")
/* ReactDOMRe.renderToElementWithId(<App message="Welcome to React and Reason" />, "root"); */
