using ScriptsAndPlots
using Bonito, Observables

stoppable_app = Ref{App}()

dd = App() do
    style = Styles(
        CSS("font-weight" => "500"),
        CSS(":hover", "background-color" => "silver"),
        CSS(":focus", "box-shadow" => "rgba(0, 0, 0, 0.5) 0px 0px 5px"),
    )
    dropdown = ColorDropdown(["First", "second", "third", "enough"]; index=1, style=style)
    on(dropdown.value) do value
        @info value
        if value == "enough" 
            close(stoppable_app[])
            println("genug ist genug")
        end
    end
    return dropdown
end

stoppable_app[] = dd

display(dd)
# close(dropdown)