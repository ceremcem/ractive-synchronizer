window.get-synchronizer = (placeholder) ->
    if placeholder and typeof! placeholder isnt \String
        throw new Error "placeholder MUST be the component's name"

    return Ractive.macro (handle, attrs) ~>
        actual-comp = "#{handle.name}ASYNC"
        loading-comp = placeholder or "#{handle.name}LOADING"

        obj =
            observers: []
            update: (attrs) ->
                # debugger

            teardown: ->
                obj.observers.forEach (.cancel!)

        _orig = handle.template
        delete _orig.p
        orig = {v: 4, t: [_orig], e: {}}

        mod-comp = (name) ->
            _orig.e = name
            return orig

        obj.observers.push handle.observe '@shared.deps._all', (val) !->
            if Ractive.components[actual-comp]
                # enable actual component
                handle.setTemplate mod-comp actual-comp
            else if Ractive.components[loading-comp]
                # enable loading state component
                handle.setTemplate mod-comp loading-comp
            else
                # show default message
                handle.setTemplate """
                    <div class='ui yellow message'>
                        We are fetching <i>#{handle.name}</i>
                    </div>
                    """
        return obj
