# Description

This HOWTO explains how to convert sync components into async components in Ractive.

### How

1. Create a simple component.
2. Use it anywhere you like in your app.
3. When you need to remove it from your main bundle and load asynchronously:
    1. Create a synchronizer proxy with your original component's name

            Ractive.partials.foo = getSynchronizer();

    2. Add `ASYNC` postfix to your original component name

          ```patch
          - Ractive.components.foo = Ractive.extend(...)
          + Ractive.components.fooASYNC = Ractive.extend(...)
          ```

    3. Remove `fooASYNC` (and its dependencies) from your bundle and load it any time in the future with any method you like (XHR, websockets, etc...)
    4. Send a signal to the synchronizer when your component is ready.


### Advantages

1. No modifications needed in your production app.
2. Convert any sync component into async component with only 2 lines of modification.
3. Control when, if and how you would load the component.

### Live Demo

https://aktos.io/st/#/showcase/async-comp

![async-fallback2](https://user-images.githubusercontent.com/6639874/43233515-f7f8ca5a-907e-11e8-80f5-759a2cf86dba.gif)

# Bare Example

### 1. Write a simple component

Write a simple (sync) component and use it in many places in your application:

```js
Ractive.components.foo = Ractive.extend({
  template: `<button on-click="bar" class="red {{class}}">{{yield}}</button>`
});

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

[Playground](https://ractive.js.org/playground/?env=docs#N4IgFiBcoE5SBTAJgcwSANCAzlA2uAC6EAO2kA9BQMZIB2AdAFbZIIA2AlgG4wN0JCFFGBoIYCALbUpFGAENqhHggC02AJ51qYGAHs6nAF7iAAtwAMDAMwUknbELSEAylp37DJvi0xFS5FS0jCxsXLz8gsKiMhLSsgpKKuruugbGZpY2FAgAHvKSJOwIwoIu1DCcJITMuAC6AL5YuJAgVAAEFQjyhAjtAGZ6eu2a2mle4gA6dABKisrcCAwk8jDK8uzYDIPDALztzm5jnhkwABQAlADc09yrA0MAqjDs7fsA5GDEZJQ09LVhHh8AROGLiKQySRyebJUYedLecxWWx5ApFEo7BiJBZLFjvabTDqPbB9SYgAAyAHkAIIAEQAkgA5ADiZPaJD0jn6nFyyE6ekKBgQdEI7QA7mBOMUBoIdJw6Ch2mSdmzqAKOQIRUrZjDFgw1YLNYQtjsqXSmcy3u05kk9XlenQkGdgATiFIij0EJB2gADAA89m4I0IGmKuzJACM9DA2DBvQBGEi5EZ6LhIdoR9iKADWV3a9mwHo03vlXAEqkzemoubZBlU1C41fDIAjqzJAD4XPSALKPcnUgAqAFF2gAhR4DgeUxl+uw8ds+6YNC4EugCMXW3UIZ2ujje95RpAad4YV29QpZ3rexd0SaEP0AV3Y7ddd+AwAAxN0dO1qTAFBoZzWBcDQNK+hB3n6XAvreEFwZBOydFm2DYM2mYPggtZ0BWqzNqYKDsHorbsAwGziIQZyfAgx7tAA1O0pjymwuQriAMF3hx8GEHQD6SO0H7voxjp5KB4GcbOOzsVxs7QeB745IoYCibBs5PlJPqnrBBgGuiV4DA+2jKAYlwurBd4koQA6cJICB6A+FGXG87btKZnF3ocFRVBROzPOwGDtI5uzOa5XF3oQkpbBZlGmNgYCrMgDBsGQJ4uQA+hs7DeoQMAYcuNxmXBy7gU07TWBY5UrrBYF0MuIANEAA)

```js
// create foo synchronizer as a placeholder while we are loading fooASYNC component
Ractive.partials.foo = getSynchronizer();
var fooUrl = 'https://url/to/foo.ractive.js'

new Ractive({
  ...
  oncomplete: function(){
    getScript(fooUrl, () => {
      this.set('@shared.deps', {_all: true});
    })
  }
})
```

### 4. [OPTIONAL] Supply a "loading" time component

You may also want to supply a "loading state" version of the async component to
provide a basic functionality to the user (eg. providing a `textarea` while waiting for
`ace-editor` might be a good idea):

1. Create a component as usual:

            Ractive.components.fooLOADING = Ractive.extend(...)

2. Pass this component name to `getSynchronizer()`:

            Ractive.partials.foo = getSynchronizer('fooLOADING');

