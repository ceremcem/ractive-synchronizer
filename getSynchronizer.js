export default getSynchronizer = function(loadingTpl){
  return Ractive.macro((handle, attrs) => {
    const obj = {
      observers: [],
      update(attrs) { handle.set('@local', attrs, { deep: true }); },
      teardown() {
        obj.observers.forEach( o => o.cancel() );
      }
    };
  
    var origTemplate = handle.template; 
    // Append ASYNC postfix to the component name
    origTemplate.e += 'ASYNC'
    delete origTemplate.p
    var orig = {v:4, t:[origTemplate], e:{}}
  
    obj.observers.push(handle.observe('@shared.deps._all', function(val){
      if(val){
        handle.setTemplate(orig);
      } else {
          handle.setTemplate(loadingTpl || `<p>We are fetching component foo</p>`)
      }
    }))
    
    return obj;
  })
}
