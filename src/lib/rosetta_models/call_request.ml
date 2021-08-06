(*
 * This file has been generated by the OCamlClientCodegen generator for openapi-generator.
 *
 * Generated by: https://openapi-generator.tech
 *
 * Schema Call_request.t : CallRequest is the input to the `/call` endpoint.
 *)

type t =
  { network_identifier : Network_identifier.t
  ; (* Method is some network-specific procedure call. This method could map to a network-specific RPC endpoint, a method in an SDK generated from a smart contract, or some hybrid of the two. The implementation must define all available methods in the Allow object. However, it is up to the caller to determine which parameters to provide when invoking `/call`. *)
    _method : string
  ; (* Parameters is some network-specific argument for a method. It is up to the caller to determine which parameters to provide when invoking `/call`. *)
    parameters : Yojson.Safe.t
  }
[@@deriving yojson { strict = false }, show, eq]

(** CallRequest is the input to the `/call` endpoint. *)
let create (network_identifier : Network_identifier.t) (_method : string)
    (parameters : Yojson.Safe.t) : t =
  { network_identifier; _method; parameters }
