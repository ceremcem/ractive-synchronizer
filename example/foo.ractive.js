// rename foo to fooASYNC
Ractive.components.fooASYNC = Ractive.extend({
  template: `<button on-click="bar" class="red {{class}}">{{yield}}</button>`
});
