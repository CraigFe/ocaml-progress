open Progress

let stopwatch () =
  Segment.stateful (fun () ->
      let start_time = Mtime_clock.counter () in
      Units.seconds (fun ~width pp_time ->
          let pp ppf = pp_time ppf (Mtime_clock.count start_time) in
          Segment.const_fmt ~width pp))

let counter_prebar = stopwatch ()

let counter ~total ?style ?message ?pp ?width ?sampling_interval =
  Internal.counter ~prebar:counter_prebar ~total ?style ?message ?pp ?width
    ?sampling_interval

let stderr_if_tty =
  if Unix.(isatty stderr) then Format.err_formatter
  else Format.make_formatter (fun _ _ _ -> ()) (fun () -> ())

let default_config = Config.create ~ppf:stderr_if_tty ()

let with_reporters ?(config = Config.create ()) x =
  with_reporters ~config:Config.(config || default_config) x

let start ?(config = Config.create ()) x =
  start ~config:Config.(config || default_config) x

let finalize = finalize
let ( / ) = ( / )