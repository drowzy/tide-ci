[%bs.raw {|require('spectre.css/dist/spectre.min.css')|}];
[%bs.raw {|require('./index.css')|}];

ReactDOMRe.renderToElementWithId(<App message="Welcome to React and Reason" />, "root");
