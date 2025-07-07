using Bonito, Observables

stoppable_app = Ref{App}()

app = App() do
    nmb_style = Styles(
        CSS("font-weight" => "500"),
        CSS(":hover", "background-color" => "silver"),
        CSS(":focus", "box-shadow" => "rgba(0, 0, 0, 0.5) 0px 0px 5px"),
    )
    numberinput = NumberInput(0.0; style=nmb_style)
    on(numberinput.value) do value # ::Float64
        @info value
    end

    btn_style = Styles(
        CSS("font-weight" => "500"),
        CSS(":hover", "background-color" => "silver"),
        CSS(":focus", "box-shadow" => "rgba(0, 0, 0, 0.5) 0px 0px 5px"),
    )
    stop_button = Button("Stop me!"; style=btn_style)
    on(stop_button.value) do click::Bool
        @info "Stopping!"
        stop_button.content[] = "Stopped"
        close(stoppable_app[])
        println("stopped")
    end

    return DOM.div(numberinput, stop_button)
end

stoppable_app[] = app

display(app)

# @show typeof(stoppable_app[])
# @show stoppable_app[] === app
# close(app)
# close(stoppable_app[])