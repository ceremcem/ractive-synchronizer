# Description 

This HOWTO explains how to convert sync components into async components in Ractive. 

# Steps 

### 1. Write a simple sync component 

Write a simple component:

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

3. TEST: Set `@shared.deps._all` to `true` immediately to test if your `foo` synchronizer works correctly: [Playground](https://ractive.js.org/playground/?env=docs#N4IgFiBcoE5SBTAJgcwSAvgGhAZ3mgC4DKAngHYDGYMA9uQJYBeCMABALxsBmArlYQb0AFABtaAQyQNyKACoAHUQEpgAHXJrCMBIV4xybAEoTKggG4IAdAFtTdYcLATySUQixsJhbbmWcAPjZ1TUI2Nkp6XDDaACMAK05gjS1w8LjcVksYXEg2AG0AXSwUsLTeBSRvBGFvX39gNmdXdytMwmEAcgABcUoJUU7POpzPRqQEBAU87V4ENgxlAG4FktC0tkIECRgkWgB3cmEG0o30hKsMrNZcK25aGABRUzBhNlpA96t+qgRRY7Yy1OaQwwIwS1KkMI5h27xgDHkCBsSmqSWabmsW2RomqKyhAHp8WwAIIKBQIVwk4gATQAcgBhNgKWjRbgMAAemw+hDA80iyPoFLC5AkNgQUIeCLkSJRWys8wA1FxOsSaQzOlCJu4tnCpTKcXKFFCYexJSgksBzJAACyeQiQfJm6XY6rFNgIaAYUGhYFxeKXWKZGDZW4KXi4V7o1pXYM1HoRnbIKwTBS3AD6A0Gnj4AiERxhKhCqTYWgY3GEBdUwK0Wij1naztlNTNQPWJcIGHdokyyTbNcItZcGLaukbBpq4ikMnkSjYAB852wAAYAHgUAQA6vNEzxdNRpxFaALyEKeLRaCv8eul8pqx2wcpb32fdpdPpDH6IaFFhpvRpCREOiovcHy4BQ1B0IwLAwBoJhmAwlhWAoOyCAMtwgUkRBkFQND0MwrDHF+-5EjoIpime3IfCBqp0vSsGmBY1j8syJ7kIQ6HnjRDJJHBjHyuyWyuMIRY+Pq1R5EuUIrrEvA+PQ7zkAAtJQogMJQADWHBqCAsQ7NpEQ4rguBaSAOhIMEwAqRIRletpATAMApAMH8SBepeMlyeQASlJJ5CLERmjkCe+zGAxCE1CJfx5J0sS0EgpBDKUWJNhJpQrrwojeS+DkAMTbNQJIwDAEikMIADMyi2S+WgrqpWX9v2K4YVZRkmbEohzPp9CKbpMAmd0KDiLpohWAMrAdJ0vIJWwCpsN0MgTOyt4gPVA5rf25C8DYbA5Q582uAg7JVQ1a2XiBq2NfidVQg5+L5WAx2EJeGWrUuaxaPQzHah6PD8PBIhVi+PIMLc7RdN0CZmcmUy4EMwQZqIogzDAczYMEExTMjqNPlo3qLJgQA)

### 3. Load your component asynchronously 

1. Remove `fooASYNC` component from your bundle. Load it at any time (preferably sometime after `Ractive.oncomplete`) by any transport (`<script src=` method, XHR, websockets, manually uploading, etc.) you like.
2. Set `@shared.deps._all` flag to `true` when your ASYNC component is available. 

[Playground](https://ractive.js.org/playground/?env=docs#N4IgFiBcoE5SBTAJgcwSAvgGhAZ3mgC4DKAngHYDGYMA9uQJYBeCMABALxsBmArlYQb0AFABtaAQyQNyKACoAHUQEpgAHXJrCMBIV4xybAEoTKggG4IAdAFtTdYcLATySUQixsJhbbmWcAPjZ1TUI2Nkp6XDDaACMAK05gjS1w8LjcVksYXEg2AG0AXSwUsLTeBSRvBGFvX39gNmdXdytMwmEAcgABcUoJUU7POpzPRqQEBAU87V4ENgxlAG4FktC0tkIECRgkWgB3cmEG0o30hKsMrNZcK25aGABRUzBhNlpA96t+qgRRY7Yy1OaQwwIwS1KkMI5h27xgDHkCBsSmqSWabmsW2RomqKyhAHp8WwAIIKBQIVwk4gATQAcgBhNgKWjRbgMAAemw+hDA80iyPoFLC5AkNgQUIeCLkSJRWys8wA1FxOsSaQzOlCJu4tnCpTKcXKFFCYexJSgksBzJAACyeQiQfJm6XY6rFNgIaAYUGhYFxeKXWKZGDZW4KXi4V7o1pXYM1HoRnbIKwTBS3AD6A0Gnj4AiERxhKhCqTYWgY3GEBdUwK0Wij1naztlNTNQPWJcIGHdokyyTbNcItZcGLaukbBpq4ikMnkSjYAB852wAAYAHgUAQA6vNEzxdNRp2wVwwAgASYB1qwisUYFf44+39dL5TVjtg5TPvs+7S6fSGP0Q0JFg0b0NEJCIdFRe4PlwChqDoRgWBgDQTDMBhLCsBQdkEAZbigpIiDIKgaHoZhWGOACNHIBB9mMUwLBqIstlEPJOliWgkFIIZSixJs8iXUoV14UQAihYBgAAYm2agSRgGAJFIYQAGZlC9KEtBXURjzUgdCBXPDKBxXBcA4NQQFiUQ5lM95yAAWliHYTJAboUHEezRCsAZWA6TpeU4tgFTYboZAmdlnxAESv37LRyF4Gw2HEsSgtcBB2VUyKdNvKCIqi3T8U07KdLE-EpLANL1PxISCqXNYtHofklF0D0eH4VCRCrL8GwYMVaF4DoAQ4IJGP7MCdCveY8MID4oNVOl6W0lD6O+WgBSo8hCFw2haBmhkkgWtDrBSrZXGEIadK0Hjxz4ldYl6ya-1sgyGEoABrRz7KQkAIkM4zTJ0JBgmAAyJCM1TwrE0gGD+JAvVvG6fHoAJ+PSxYKLOnwwAYW52i6boEz+5MplwIZggzURmM2GA5hRqFsDYABGABWAAGJmPy0b1FkwIA)

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




