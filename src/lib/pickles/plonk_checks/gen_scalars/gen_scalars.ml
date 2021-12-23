open Core_kernel

let output_file = Out_channel.create Sys.argv.(1)

let output_string str = Out_channel.output_string output_file str

let () =
  output_string
    {ocaml|
type curr_or_next = Curr | Next

module Gate_type = struct
  module T = struct
    type t = Poseidon | Vbmul | Endomul | CompleteAdd | EndomulScalar
    [@@deriving hash, eq, compare, sexp]
  end

  include Core_kernel.Hashable.Make (T)
  include T
end

module Column = struct
  open Core_kernel

  module T = struct
    type t = Witness of int | Index of Gate_type.t | Coefficient of int
    [@@deriving hash, eq, compare, sexp]
  end

  include Hashable.Make (T)
  include T
end

open Gate_type
open Column

module Env = struct
  type 'a t =
    { add : 'a -> 'a -> 'a
    ; sub : 'a -> 'a -> 'a
    ; mul : 'a -> 'a -> 'a
    ; pow : 'a * int -> 'a
    ; square : 'a -> 'a
    ; zk_polynomial : 'a
    ; omega_to_minus_3 : 'a
    ; zeta_to_n_minus_1 : 'a
    ; var : Column.t * curr_or_next -> 'a
    ; field : string -> 'a
    ; cell : 'a -> 'a
    ; alpha_pow : int -> 'a
    ; double : 'a -> 'a
    ; endo_coefficient : 'a
    ; mds : int * int -> 'a
    ; srs_length_log2 : int
    }
end

module type S = sig
  val constant_term : 'a Env.t -> 'a

  val index_terms : 'a Env.t -> 'a Lazy.t Column.Table.t
end

(* The constraints are basically the same, but the literals in them differ. *)
module Tick : S = struct
  let constant_term (type a)
      ({ add = ( + )
       ; sub = ( - )
       ; mul = ( * )
       ; square = _
       ; mds
       ; endo_coefficient = _
       ; pow
       ; var
       ; field = _
       ; cell
       ; alpha_pow
       ; double = _
       ; zk_polynomial = _
       ; omega_to_minus_3 = _
       ; zeta_to_n_minus_1 = _
       ; srs_length_log2 = _
       } :
        a Env.t) =
|ocaml}

external fp_linearization : unit -> string * (string * string) array
  = "fp_linearization_strings"

let fp_constant_term, fp_index_terms = fp_linearization ()

let () = output_string fp_constant_term

let () =
  output_string
    {ocaml|

  let index_terms (type a)
      ({ add = ( + )
       ; sub = ( - )
       ; mul = ( * )
       ; square
       ; pow = _
       ; var
       ; field
       ; cell
       ; alpha_pow
       ; double
       ; zk_polynomial = _
       ; omega_to_minus_3 = _
       ; zeta_to_n_minus_1 = _
       ; mds = _
       ; endo_coefficient
       ; srs_length_log2 = _
       } :
        a Env.t) =
    Column.Table.of_alist_exn
    [
|ocaml}

let is_first = ref true

let () =
  Array.iter fp_index_terms ~f:(fun (col, expr) ->
      if !is_first then is_first := false else output_string " ;\n" ;
      output_string "(" ;
      output_string col ;
      output_string ", lazy (" ;
      output_string expr ;
      output_string "))")

let () = output_string {ocaml|
      ]
end
|ocaml}

let () =
  output_string
    {ocaml|
module Tock : S = struct
  let constant_term (type a)
      ({ add = ( + )
       ; sub = ( - )
       ; mul = ( * )
       ; square = _
       ; mds
       ; endo_coefficient = _
       ; pow
       ; var
       ; field = _
       ; cell
       ; alpha_pow
       ; double = _
       ; zk_polynomial = _
       ; omega_to_minus_3 = _
       ; zeta_to_n_minus_1 = _
       ; srs_length_log2 = _
       } :
        a Env.t) =
|ocaml}

external fq_linearization : unit -> string * (string * string) array
  = "fq_linearization_strings"

let fq_constant_term, fq_index_terms = fq_linearization ()

let () = output_string fq_constant_term

let () =
  output_string
    {ocaml|

  let index_terms (type a)
      ({ add = ( + )
       ; sub = ( - )
       ; mul = ( * )
       ; square
       ; pow = _
       ; var
       ; field
       ; cell
       ; alpha_pow
       ; double
       ; zk_polynomial = _
       ; omega_to_minus_3 = _
       ; zeta_to_n_minus_1 = _
       ; mds = _
       ; endo_coefficient
       ; srs_length_log2 = _
       } :
        a Env.t) =
    Column.Table.of_alist_exn
    [
|ocaml}

let is_first = ref true

let () =
  Array.iter fq_index_terms ~f:(fun (col, expr) ->
      if !is_first then is_first := false else output_string " ;\n" ;
      output_string "(" ;
      output_string col ;
      output_string ", lazy (" ;
      output_string expr ;
      output_string "))")

let () = output_string {ocaml|
      ]
end
|ocaml}
