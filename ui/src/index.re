[%bs.raw {|require('spectre.css/dist/spectre.min.css')|}];
[%bs.raw {|require('spectre.css/dist/spectre-exp.min.css')|}];
[%bs.raw {|require('spectre.css/dist/spectre-icons.css')|}];
[%bs.raw {|require('./index.css')|}];

ReactDOMRe.renderToElementWithId(<App message="Welcome to React and Reason" />, "root");
