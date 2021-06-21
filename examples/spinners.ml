open Progress

let apply_color color s = Ansi.(code color) ^ s ^ Ansi.(code none)

let unlimited_bar =
  let frames =
    let width = 6 in
    List.init width (fun i ->
        String.concat ""
          (List.init width (fun x ->
               if x = i then apply_color (Ansi.fg @@ Color.of_ansi `Cyan) ">"
               else apply_color Ansi.faint "-")))
  in
  let spin = Line.spinner ~frames () in
  Line.(const "[" ++ spin ++ spin ++ spin ++ spin ++ spin ++ const "]")

(** Examples taken from: https://github.com/sindresorhus/cli-spinners/ *)

include struct
  let dots1     = Line.spinner ~frames:[ "⠋"; "⠙"; "⠹"; "⠸"; "⠼"; "⠴"; "⠦"; "⠧"; "⠇"; "⠏" ] ()
  let dots2     = Line.spinner ~frames:[ "⣾"; "⣽"; "⣻"; "⢿"; "⡿"; "⣟"; "⣯"; "⣷" ] ()
  let dots3     = Line.spinner ~frames:[ "⠋"; "⠙"; "⠚"; "⠞"; "⠖"; "⠦"; "⠴"; "⠲"; "⠳"; "⠓" ] ()
  let dots4     = Line.spinner ~frames:[ "⠄"; "⠆"; "⠇"; "⠋"; "⠙"; "⠸"; "⠰"; "⠠"; "⠰"; "⠸"; "⠙"; "⠋"; "⠇"; "⠆" ] ()
  let dots5     = Line.spinner ~frames:[ "⠋"; "⠙"; "⠚"; "⠒"; "⠂"; "⠂"; "⠒"; "⠲"; "⠴"; "⠦"; "⠖"; "⠒"; "⠐"; "⠐"; "⠒"; "⠓"; "⠋" ] ()
  let dots6     = Line.spinner ~frames:[ "⠁"; "⠉"; "⠙"; "⠚"; "⠒"; "⠂"; "⠂"; "⠒"; "⠲"; "⠴"; "⠤"; "⠄"; "⠄"; "⠤"; "⠴"; "⠲"; "⠒"; "⠂"; "⠂"; "⠒"; "⠚"; "⠙"; "⠉"; "⠁" ] ()
  let dots7     = Line.spinner ~frames:[ "⠈"; "⠉"; "⠋"; "⠓"; "⠒"; "⠐"; "⠐"; "⠒"; "⠖"; "⠦"; "⠤"; "⠠"; "⠠"; "⠤"; "⠦"; "⠖"; "⠒"; "⠐"; "⠐"; "⠒"; "⠓"; "⠋"; "⠉"; "⠈" ] ()
  let dots8     = Line.spinner ~frames:[ "⢹"; "⢺"; "⢼"; "⣸"; "⣇"; "⡧"; "⡗"; "⡏" ] ()
  let dots9     = Line.spinner ~frames:[ "⠁"; "⠂"; "⠄"; "⡀"; "⢀"; "⠠"; "⠐"; "⠈" ] ()
  let pointer   = Line.spinner ~frames:[ "←"; "↖"; "↑"; "↗"; "→"; "↘"; "↓"; "↙" ] ()
  let chevron   = Line.spinner ~frames:[ "▹▹▹▹▹"; "▸▹▹▹▹"; "▹▸▹▹▹"; "▹▹▸▹▹"; "▹▹▹▸▹"; "▹▹▹▹▸" ] ()
  let hamburger = Line.spinner ~frames:[ "☱"; "☲"; "☴" ] ()
  let grow_vert = Line.spinner ~frames:[ " "; "▁"; "▂"; "▃"; "▄"; "▅"; "▆"; "▇"; "█"; "▇"; "▆"; "▅"; "▄"; "▃"; "▂"; "▁" ] ()
  let grow_hori = Line.spinner ~frames:[ "▏"; "▎"; "▍"; "▌"; "▋"; "▊"; "▉"; "▊"; "▋"; "▌"; "▍"; "▎" ] ()
  let moon      = Line.spinner ~frames:[ "🌑"; "🌒"; "🌓"; "🌔"; "🌕"; "🌖"; "🌗"; "🌘"; "🌑"; "🌒"; "🌓"; "🌔"; "🌕"; "🌖"; "🌗"; "🌘" ] ()
  let earth     = Line.spinner ~frames:[ "🌍 "; "🌎 "; "🌏 " ] ()
  let clock     = Line.spinner ~frames:[ "🕛"; "🕚"; "🕙"; "🕘"; "🕗"; "🕖"; "🕕"; "🕔"; "🕓"; "🕒"; "🕑"; "🕐"] ()
  let toggle    = Line.spinner ~frames:[ "⊶"; "⊷" ] ()
  let triangle  = Line.spinner ~frames:[ "◢"; "◣"; "◤"; "◥" ] ()

  let bouncing_bar =
    Line.spinner
      ~frames:
        [ "[    ]"
        ; "[=   ]"
        ; "[==  ]"
        ; "[=== ]"
        ; "[ ===]"
        ; "[  ==]"
        ; "[   =]"
        ; "[    ]"
        ; "[   =]"
        ; "[  ==]"
        ; "[ ===]"
        ; "[====]"
        ; "[=== ]"
        ; "[==  ]"
        ; "[=   ]"
        ]
      ()
end
[@@ocamlformat "disable"]

let run () =
  print_endline "";

  let spinners =
    [ ("dots1", dots1, 80)
    ; ("dots2", dots2, 80)
    ; ("dots3", dots3, 80)
    ; ("dots4", dots4, 80)
    ; ("dots5", dots5, 80)
    ; ("dots6", dots6, 80)
    ; ("dots7", dots7, 80)
    ; ("dots8", dots8, 80)
    ; ("dots9", dots9, 80)
    ; ("pointer", pointer, 80)
    ; ("chevron", chevron, 80)
    ; ("hamburger", hamburger, 100)
    ; ("grow vertical", grow_vert, 80)
    ; ("grow horizontal", grow_hori, 120)
    ; ("earth", earth, 180)
    ; ("moon", moon, 100)
    ; ("clock", clock, 80)
    ; ("bouncing bar", bouncing_bar, 80)
    ; ("toggle", toggle, 250)
    ; ("triangle", triangle, 50)
    ; ("unlimited bar", unlimited_bar, 80)
    ]
    |> List.map (fun (name, elt, interval) ->
           let open Line in
           lpad 25 (constf "%s  :  " name)
           ++ debounce (Duration.of_int_ms interval) elt)
  in

  with_reporters
    (Multi.v_list (spinners @ [ Line.noop () ]))
    (fun reporters ->
      let timer = Mtime_clock.counter () in
      let render_time = Duration.of_sec 10. in
      while Duration.(Mtime_clock.count timer < render_time) do
        List.iter (fun f -> f ()) reporters
      done)
