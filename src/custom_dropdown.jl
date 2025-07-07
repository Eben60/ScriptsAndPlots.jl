import Bonito: jsrender
using Bonito: BUTTON_STYLE

struct ColorDropdown
    options::Observable{Vector{Any}}
    value::Observable{Any}
    option_to_string::Function
    option_index::Observable{Int}
    attributes::Dict{Symbol,Any}
    style::Styles
end
export ColorDropdown

function ColorDropdown(options; index=1, option_to_string=string, style=Styles(), attributes...)
    option_index = convert(Observable{Int}, index)
    options = convert(Observable{Vector{Any}}, options)
    option = Observable{Any}(options[][option_index[]])
    onany(option_index, options) do index, options
        option[] = options[index]
        return nothing
    end
    css = Styles(style, BUTTON_STYLE)
    return ColorDropdown(
        options, option, option_to_string, option_index, Dict{Symbol,Any}(attributes), css
    )
end

function Bonito.jsrender(session::Session, dropdown::ColorDropdown)
    string_options = map(x-> map(dropdown.option_to_string, x), session, dropdown.options)
    onchange = js"""
    function onload(element) {
        function onchange(e) {
            if (element === e.srcElement) {
                ($(dropdown.option_index)).notify(element.selectedIndex + 1);
            }
        }
        element.addEventListener("change", onchange);
        element.selectedIndex = $(dropdown.option_index[] - 1)
        function set_option_index(index) {
            if (element.selectedIndex === index - 1) {
                return
            }
            element.selectedIndex = index - 1;
        }
        $(dropdown.option_index).on(set_option_index);
        function set_options(opts) {
            element.selectedIndex = 0;
            // https://stackoverflow.com/questions/3364493/how-do-i-clear-all-options-in-a-dropdown-box
            element.options.length = 0;
            opts.forEach((opt, i) => element.options.add(new Option(opts[i], i)));
        }
        $(string_options).on(set_options);
    }
    """
    option2div(x) = DOM.option(x)
    dom = map(options -> map(option2div, options), session, string_options)[]

    select = DOM.select(dom; style=dropdown.style, dropdown.attributes...)
    Bonito.onload(session, select, onchange)
    return jsrender(session, select)
end