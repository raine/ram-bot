// Description:
//   Support scripts written in ES6

require('babel-register')({
  // TODO: compile hubot-ramda-docs and hubot-eval-js to ES5
  only: /((hubot-ramda-docs|hubot-eval-js)\/src)|\/scripts/
})
module.exports = () => {}
