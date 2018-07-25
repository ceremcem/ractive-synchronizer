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

3. Set `@shared.deps._all` to `true` immediately 

4. Test your `foo` synchronizer works correctly: [Playground](https://ractive.js.org/playground/?env=docs#N4IgFiBcoE5SBTAJgcwSAvgGhAZ3mgC4DKAngHYDGYMA9uQJYBeCMABALxsBmArlYQb0AFABtaAQyQNyKACoAHUQEpgAHXJrCMBIV4xybAEoTKggG4IAdAFtTdYcLATySUQixsJhbbmWcAPjZ1TUI2Nkp6XDDaACMAK05gjS1w8LjcVksYXEg2AG0AXSwUsLTeBSRvBGFvX39gNmdXdytMwmEAcgABcUoJUU7POpzPRqQEBAU87V4ENgxlAG4FktC0tkIECRgkWgB3cmEG0o30hKsMrNZcK25aGABRUzBhNlpA96t+qgRRY7Yy1OaQwwIwS1KkMI5h27xgDHkCBsSmqSWabmsW2RomqKyhAHp8WwAIIKBQIVwk4gATQAcgBhNgKWjRbgMAAemw+hDA80iyPoFLC5AkNgQUIeCLkSJRWys8wA1FxOsSaQzOlCJu4tnCpTKcXKFFCYexJSgksBzJAACyeQiQfJm6XY6rFNgIaAYUGhYFxeKXWKZGDZW4KXi4V7o1pXYM1HoRnbIKwTBS3AD6A0Gnj4AiERxhKhCqTYWgY3GEBdUwK0Wij1naztlNTNQPWJcIGHdokyyTbNcItZcGLaukbBpq4ikMnkSjYAB852wAAYAHgUAQA6vNEzxdNRpxFaALyEKeLRaCv8eul8pqx2wcpb32fdpdPpDH6IaFFhpvRpCREOiovcHy4BQ1B0IwLAwBoJhmAwlhWAoOyCAMtwgUkRBkFQND0MwrDHF+-5EjoIpime3IfCBqp0vSsGmBY1j8syJ7kIQ6HnjRDJJHBjHyuyWyuMIRY+Pq1R5EuUIrrEvA+PQ7zkAAtJQogMJQADWHBqCAsQ7NpEQ4rguBaSAOhIMEwAqRIRletpATAMApAMH8SBepeMlyeQASlJJ5CLERmjkCe+zGAxCE1CJfx5J0sS0EgpBDKUWJNhJpQrrwojeS+DkAMTbNQJIwDAEikMIADMyi2S+WgrqpWX9v2K4YVZRkmbEohzPp9CKbpMAmd0KDiLpohWAMrAdJ0vIJWwCpsN0MgTOyt4gPVA5rf25C8DYbA5Q582uAg7JVQ1a2XiBq2NfidVQg5+L5WAx2EJeGWrUuaxaPQzHah6PD8PBIhVi+PIMLc7RdN0CZmcmUy4EMwQZqIogzDAczYMEExTMjqNPlo3qLJgQA)

### 3. Load your component asynchronously 

1. Remove `fooASYNC` component from your bundle. Load it at any time (preferably sometime after `Ractive.oncomplete`) by any transport (XHR, websockets, manually uploading, etc.) you like
2. Set `@shared.deps._all` flag to `true` when your ASYNC component is available. 

[Playground](https://ractive.js.org/playground/?env=docs#N4IgFiBcoE5SBTAJgcwSAvgGhAZ3mgC4DKAngHYDGYMA9uQJYBeCMABALxsBmArlYQb0AFABtaAQyQNyKACoAHUQEpgAHXJrCMBIV4xybAEoTKggG4IAdAFtTdYcLATySUQixsJhbbmWcAPjZ1TUI2Nkp6XDDaACMAK05gjS1w8LjcVksYXEg2AG0AXSwUsLTeBSRvBGFvX39gNmdXdytMwmEAcgABcUoJUU7POpzPRqQEBAU87V4ENgxlAG4FktC0tkIECRgkWgB3cmEG0o30hKsMrNZcK25aGABRUzBhNlpA96t+qgRRY7Yy1OaQwwIwS1KkMI5h27xgDHkCBsSmqSWabmsW2RomqKyhAHp8WwAIIKBQIVwk4gATQAcgBhNgKWjRbgMAAemw+hDA80iyPoFLC5AkNgQUIeCLkSJRWys8wA1FxOsSaQzOlCJu4tnCpTKcXKFFCYexJSgksBzJAACyeQiQfJm6XY6rFNgIaAYUGhYFxeKXWKZGDZW4KXi4V7o1pXYM1HoRnbIKwTBS3AD6A0Gnj4AiERxhKhCqTYWgY3GEBdUwK0Wij1naztlNTNQPWJcIGHdokyyTbNcItZcGLaukbBpq4ikMnkSjYAB852wAAYAHgUAQA6vNEzxdNRpxFaALyEKeLRaCv8eul8pqx2wcpb32fdpdPpDH6IaFFhpvRpCREOiovcHy4BQ1B0IwLAwBoJhmAwlhWAoOyCAMtwgUkRBkFQND0MwrDHF+GgnvsximBYNRFlsoh5J0sS0EgpBDKUWJNnkS6lCuvCiAEULAMAADE2zUCSMAwBIpDCAAzMoXpQloK6iAwvEvv2K4YZQOK4LgHBqCAsSiHMenvOQAC0sQ7LpIDdCg4gWaIVgDKwHSdLyTFsAqbDdDIEzsreIAqf2QWEOQvA2GwAn8d5rgIOycmqQOhCXiBgWJQp+JKalWj8fiwlgPF6XcalS5rFo9D8kougejw-DwSIVYvg2DBirQvAdACHBBFR-YAToIpime3IfCBqp0vS8mEHBFHfEezInuQhDoeeo0MkkU0IdYsVbK4wjdWlPj6tU7ErrEbWEPQJmmZpDCUAA1lZFkwSAERaTpek6EgwTAJpEjaXJAX8aQDB-EgXqXqdPj0AEHEJYsRH7TyDC3O0XTdAmH3JlMuBDMEGaiDRmwwHMcNQtgbAAIwAKwAAzU0+WjeosmBAA)

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



