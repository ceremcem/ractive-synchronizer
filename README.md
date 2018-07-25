# Description 

This HOWTO explains how to convert sync components into async components in Ractive. 

### How

1. Create a simple component.
2. Use it anywhere you like in your app.
3. When you need to remove it from your main bundle and load asynchronously: 
    1. Create a synchronizer proxy with your original component's name
    
            Ractive.partials.foo = getSynchronizer();

    2. Add `ASYNC` postfix to your original component name

            Ractive.components.fooASYNC = Ractive.extend(...)

    3. Remove `fooASYNC` (and its dependencies) from your bundle and load it any time in the future with any method you like (XHR, websockets, etc...)
    4. Send a signal to the synchronizer when your component is ready.


### Advantages 

1. No modifications needed in your production app.
2. Convert any sync component into async component with only 2 lines of modification. 
3. Control when, if and how you would load the component.

### Screenshot 

![async-fallback](https://user-images.githubusercontent.com/6639874/43196121-a5918686-900f-11e8-9718-793d49c9be34.gif)

# Example

### 1. Write a simple component 

Write a simple (sync) component:

```js
Ractive.components.foo = Ractive.extend({
  template: `<button on-click="bar" class="red {{class}}">{{yield}}</button>`
});
```

...and use it anywhere in your application ([Playground](https://ractive.js.org/playground/?env=docs#N4IgFiBcoE5SBTAJgcwSAvgGhAZ3gEoCGAxgC4CWAbggHQkD2AtgA4MB2C7ZutAZgwYACALxDi5anQQAPMlyQAKYAB12KsvNYAbIvMhCABmo0aAPACMArpo5COAWhLaKJANYiVIC0RhehzkS4uJ4gMMhCwMCBwRgYXgB8UQCeFAjaSHFmAPTWtuwJJmTG7BgAlADcJuycAO7ipJQ0ykXpBgDkFgxIye1YRVosuvpGRWZW2oXqZBpRAMQIpGBCAIIwMETJigDMZXFFpmRmLlOHh2YCwjEhXhbaVgj+jj4woQACKNoMPtq0RNoIGBkRTtMAIXpCADUQjeFHYSFkZUSBxmqI07CsTCEcyisPhsn20zOR2yl1OaJJJxRUWyixIYEJ5myE3JJXKmCAA)): 


```js
new Ractive({
  el: 'body',
  template: `
    <ul>
      {{#each Array(3)}}
        <li>
          <foo class="blue" on-bar="@global.alert('hey' + @index)">num #{{@index}}</foo>
        </li>
      {{/each}}
    </ul>
  `
})
```

### 2. Make it async 

[Playground](https://ractive.js.org/playground/?env=docs#N4IgFiBcoE5SBTAJgcwSANCAzlA2uAC6EAO2kA9BQMZIB2AdAFbZIIA2AlgG4wN0JCFFGBoIYCALbUpFGAENqhHggC02AJ51qYGAHs6nAF7iAAtwAMDAEwMAjMMEBlLTv2GTfFpiKlyVWkYWNi5efkFhURkJaVkFJRV1V10DYzNLGxtHQidqGE4SQmZcAF0AXyxcSBAqAAI8hHlCBFqAMz09Ws1tFI9xAB06ACVFZW4EBhJ5GGV5dmwGds6AXlq0HOT3NJgACgBKAG5B7mm2joBVGHZa1YByMGIyShp6YpCePgEhETEYmUk5KNEt03KlPOYrLYAMwUJYMeJjCYsW6DQYCADutRGCXGO2AqOa7EgtVuACM9EgNLcMATmpISOwmghiQADAkAHgAruwAHwE-qEYDAADEjR0tQAgjAFBodlC9mUyvzCAL2Vw+XQBVqVYR2Ut6ozsNhlv0QKT2JyEKbagZVKTpiaQKYUOw9Pb2Aw5uJCDt7ggqbUANS1UycOhsAAee1NGu1ccIdE5klqwqFofDCAjiuV2vZsI6sZ1qoo6uVQooYrA2c1uoo3MLLJpNYM1D09PYgmZbU52mUBn2+JrAvWuXyhR2S0u7AwtX2Nx5tUH8cIYE4C2wgl9pmwYGmyAYbDI1MXAH05kTaoQYJayodlbeCUq6LeQGUgA)

```js
// create foo synchronizer as a placeholder while we are loading fooASYNC component
Ractive.partials.foo = getSynchronizer();
var fooUrl = 'https://cdn.jsdelivr.net/gh/ceremcem/ractive-synchronizer@v0.2.3/foo.ractive.js'

new Ractive({
  el: 'body',
  template: `
  <ul>
    {{#each Array(3)}}
      <li>
        <foo class="blue" on-bar="@global.alert('hey' + @index)">
          num #{{@index}}
        </foo>
      </li>
    {{/each}}
  </ul>
  `,
  oncomplete: function(){
    getScript(fooUrl, () => {
      this.set('@shared.deps', {_all: true});
    })
  }
})

```

### 4. Optionally supply a custom "loading" template 

You may also want to supply a "loading state" template to provide a basic functionality (eg. a `textarea` while waiting `ace-editor`): 

```js
// create foo synchronizer
Ractive.partials.foo = getSynchronizer(`
  <div style="color: orange; display: inline;">
    Fetching foo... 
  </div>
`);
```




