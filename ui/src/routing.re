type routes =
  | Overview
  | ProjectRoute(string)
  | ProjectBuildsRoute(string)
  | ProjectBuildRoute(string, string)
