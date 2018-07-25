# Description 

This HOWTO explains how to convert sync components into async components in Ractive. 

# Steps 

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

### 2. Create a synchronizer proxy 

1. Create a synchronizer proxy with your original component's name 

        Ractive.partials.foo = getSynchronizer();

2. Rename your original component with `ASYNC` postfix (`foo` to `fooASYNC`)

3. TEST: Set `@shared.deps._all` to `true` immediately to test if your `foo` synchronizer works correctly: 
[Playground](https://ractive.js.org/playground/?env=docs#N4IgFiBcoE5SBTAJgcwSANCAzlA2uAC6EAO2kA9BQMZIB2AdAFbZIIA2AlgG4wN0JCFFGBoIYCALbUpFGAENqhHggC02AJ51qYGAHs6nAF7iAAtwAMDAEzDBAZS079hk3xYgAugF8suSCBUAATUEvKECEEAZnp6QZraugbG4gA6dABKisrcCAwk8jDK8uzYDDFxALxBaISOiS4pMAAUAJQA3OnpwRJ08pKRFUGEcRUAgvYAmgByAMLpWUoqDNR6kiQGCHSEZeNTc0HVizl5CAAeEXRIzcBdxFIk7OEIkEEABnephAA8AEYArsQDEEDKpqFxqABrSqpEC-QqwkJPbDYGEgCRIILAYDg+Qo7zeWEAPmxGk4HCQBO+FABQLoRLuHzo3g6XTo6QEAHcgscVDc7hxXgByX56JAaIUYO4RdZPCKvJlfb7-dgM9mEL7YgDECEUYCCYxgCg0zQAzK0CZ8NT8uGqvvbrd8hriUWjfux-ghEaD4TA0aYUOw9PD2AwSuJCM0hWAEBKggBqIKmThXc6tYlWh1fOj-SRBLXY5Ops6W9VZn4UCp261Kii2q3Yii6nSl2sq6tvKXqgyrWWCF7Rf7aZQGNq3MvEMCcMrYQRR0zYMCFZAMNhkSVYgD6JXYr0IME9vixbAQJD3B4QLLuhOZrRA3iAA)

### 3. Load your component asynchronously 

1. Remove `fooASYNC` component from your bundle. Load it at any time (preferably sometime after `Ractive.oncomplete`) by any transport (`<script src=` method, XHR, websockets, manually uploading, etc.) you like.
2. Set `@shared.deps._all` flag to `true` when your ASYNC component is available. 

[Playground](https://ractive.js.org/playground/?env=docs#N4IgFiBcoE5SBTAJgcwSANCAzlA2uAC6EAO2kA9BQMZIB2AdDAIYDuKAloQ9QPYC2NBDAT9qoii2qEOANwQBabAE861MDF50OAL2EUAzABZmRgJwBWAIwB2CmkIBlVes3a9MBgCtcAXQC+WLiQIFQABNQizIQIYQBmvLxhKmoaWrrCADp0AErM0nIIDCTMMDLMADbYDAlJALxhDs6pbhkwABQAlADc2dl0CKxheQXy7cB9MRWQYQDkAEa8SMqzGJMx-CQV0QgzAAaTADwArhUAfJOZhMDAAMQI+WBhAIIwLMrtBp3+-peEV4cKhwLnQrmD-oRDrUIttsNg6pkQPMKscEIiwloFPNSgiQAABFAVXjYioMSrCQjtWZgBArMIAajCeI4dCQCAAHp1ESDwbzCHRjvwwrcbszWRyfn9wYcKLUeRCARQgfKrjcKA91JLQZCKKd5Xs1tqtHxNhUEDEZnFjmoZFouhNtVdsOaACocfgIXjHSldMJ1M5hB188IiOjMD3xRJhQhJWrPRwATQAcgBhKWEEYyeQ8AQkLQIOiEapxxOpv3DfJZoocmKs8bpq4bLY7faHebemN0DF0BTUIHUADWuOxMHRfeYcNxIiQgeA47hkpAZxuyg4CAqSB+MvbxC0ZwOjoh-h66cIYA41WdlNmeOwYFKyAYbLIq0DAH1KtNozBUcfeofAjCKwLAABhArltV+OhjxAfwgA)

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




