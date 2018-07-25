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

1. Create a synchronizer proxy with your original component's name

        Ractive.partials.foo = getSynchronizer();


2. Add `ASYNC` postfix to your original component name

        Ractive.components.fooASYNC = Ractive.extend(...)

3. Remove `fooASYNC` component from your bundle. Load it at any time (preferably sometime after `Ractive.oncomplete`) by any transport method (`<script>`, XHR, websockets, etc.) you like.
4. Set `@shared.deps._all` flag to `true` when your ASYNC component is available. 

[Playground](https://ractive.js.org/playground/?env=docs#N4IgFiBcoE5SBTAJgcwSANCAzlA2uAC6EAO2kA9BQMZIB2AdAFbZIIA2AlgG4wN0JCFFGBoIYCALbUpFGAENqhHggC02AJ51qYGAHs6nAF7iAAtwAMDAEwMAjMMEBlLTv2GTfFiAC6AXyxcSBAqAAJqCXlCBFCAMz09UM1tXQNjcQAdOgAlRWVuBAYSeRhleXZsBnjEgF5QtEIXFPd0mAAKAEoAbiysgQB3UNylFTbgXuj2SFCAcgAjPSQNGYwJ6MkSdiiEaYADCYAeAFd2AD4JjMJgYABiBEUwUIBBGAUNNoBmDr8-C8JLg5cc50S6g-6EA7VcJbbDYGoZEBzdhHBAI0IGVRzErwkCmFDsPRY9gMcriQhtGZgBDLUIAalCpk4dDYAA8OgjgWCuYQ6EdJKEbtdGcyECyfn8wQcKNVOeCARQgX9rhR7jpxSCIRQTrLdqsNQZqHoNuxBDs4kdtMoDJ1xhrLthBAAVTiSBB6I7kzqhGqnUK27lhCR0eSuuIJUKERLVJ5OACaADkAMISwjDfKFQ0bAwIOiESrRuNJ71DPIqBii6LMsYpy7rTbbPYHOYeyN0dF0VTULjUADWOKxMDRXfksJxEiQfuAw9h4pAp2uGk4HCQPylzeIBlO+zt4L83RThDAnEqDvJM1M2DAJWQDDYZBWfoA+uUphGYCi9z0dwFQnYAKwWBY7Iar8dB7iAfhAA)

```js
// create foo synchronizer
Ractive.partials.foo = getSynchronizer();

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
    setTimeout(() => {
      // rename foo to fooASYNC
      Ractive.components.fooASYNC = Ractive.extend({
        template: `<button on-click="bar" class="red {{class}}">{{yield}}</button>`
      });
      this.set('@shared.deps', {_all: true});
    }, 1500)
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




