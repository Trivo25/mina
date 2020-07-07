(*
 * This file has been generated by the OCamlClientCodegen generator for openapi-generator.
 *
 * Generated by: https://openapi-generator.tech
 *
 * Schema Allow.t : Allow specifies supported Operation status, Operation types, and all possible error statuses. This Allow object is used by clients to validate the correctness of a Rosetta Server implementation. It is expected that these clients will error if they receive some response that contains any of the above information that is not specified here.
 *)

type t =
  { (* All Operation.Status this implementation supports. Any status that is returned during parsing that is not listed here will cause client validation to error. *)
    operation_statuses: Operation_status.t list
  ; (* All Operation.Type this implementation supports. Any type that is returned during parsing that is not listed here will cause client validation to error. *)
    operation_types: string list
  ; (* All Errors that this implementation could return. Any error that is returned during parsing that is not listed here will cause client validation to error. *)
    errors: Error.t list }
[@@deriving yojson {strict= false}, show]

(** Allow specifies supported Operation status, Operation types, and all possible error statuses. This Allow object is used by clients to validate the correctness of a Rosetta Server implementation. It is expected that these clients will error if they receive some response that contains any of the above information that is not specified here. *)
let create (operation_statuses : Operation_status.t list)
    (operation_types : string list) (errors : Error.t list) : t =
  {operation_statuses; operation_types; errors}
