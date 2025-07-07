using ScriptsAndPlots
using Bonito, Observables

dropdown = App() do
    style = Styles(
        CSS("font-weight" => "500"),
        CSS(":hover", "background-color" => "silver"),
        CSS(":focus", "box-shadow" => "rgba(0, 0, 0, 0.5) 0px 0px 5px"),
    )
    dropdown = ColorDropdown(["First", "second", "third"]; index=1, style=style)
    on(dropdown.value) do value
        @info value
    end
    return dropdown
end

display(dropdown)
# close(dropdown)