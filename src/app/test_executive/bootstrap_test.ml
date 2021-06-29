open Core
open Integration_test_lib

module Make (Engine : Engine_intf) = struct
  open Engine

  (* TODO: find a way to avoid this type alias (first class module signatures restrictions make this tricky) *)
  type network = Network.t

  type log_engine = Log_engine.t

  let config =
    let open Test_config in
    let open Test_config.Block_producer in
    { default with
      block_producers=
        [{balance= "1000"; timing= Untimed}; {balance= "1000"; timing= Untimed}]
    ; num_snark_workers= 0 }

  let expected_error_event_reprs = []

  let run network log_engine =
    let open Network in
    let open Malleable_error.Let_syntax in
    let logger = Logger.create () in
    let node_a = List.nth_exn network.block_producers 0 in
    let node_b = List.nth_exn network.block_producers 1 in
    (* TODO: bulk wait for init *)
    let%bind () = Log_engine.wait_for_init node_a log_engine in
    let%bind () = Log_engine.wait_for_init node_b log_engine in
    let%bind _ =
      Log_engine.wait_for log_engine
        { hard_timeout= Slots 20
        ; soft_timeout= None
        ; predicate= (fun s -> s.blocks_generated >= 2) }
    in
    let%bind () = Node.stop node_b in
    let%bind _ =
      Log_engine.wait_for log_engine
        { hard_timeout= Slots 10
        ; soft_timeout= None
        ; predicate= (fun s -> s.blocks_generated >= 3) }
    in
    let%bind () = Node.start ~fresh_state:true node_b in
    let%bind () = Log_engine.wait_for_init node_b log_engine in
    let%map () =
      Log_engine.wait_for_sync [node_a; node_b]
        ~timeout:(Time.Span.of_ms (15. *. 60. *. 1000.))
        log_engine
    in
    [%log info] "bootstrap_test completed successfully"
end