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
    let x_0 = pow (cell (var (Witness 0, Curr)), 7) in
    let x_1 = pow (cell (var (Witness 1, Curr)), 7) in
    let x_2 = pow (cell (var (Witness 2, Curr)), 7) in
    let x_3 = pow (cell (var (Witness 6, Curr)), 7) in
    let x_4 = pow (cell (var (Witness 7, Curr)), 7) in
    let x_5 = pow (cell (var (Witness 8, Curr)), 7) in
    let x_6 = pow (cell (var (Witness 9, Curr)), 7) in
    let x_7 = pow (cell (var (Witness 10, Curr)), 7) in
    let x_8 = pow (cell (var (Witness 11, Curr)), 7) in
    let x_9 = pow (cell (var (Witness 12, Curr)), 7) in
    let x_10 = pow (cell (var (Witness 13, Curr)), 7) in
    let x_11 = pow (cell (var (Witness 14, Curr)), 7) in
    let x_12 = pow (cell (var (Witness 3, Curr)), 7) in
    let x_13 = pow (cell (var (Witness 4, Curr)), 7) in
    let x_14 = pow (cell (var (Witness 5, Curr)), 7) in
    cell (var (Index Poseidon, Curr))
    * ( cell (var (Witness 6, Curr))
      - ((mds (0, 0) * x_0) + (mds (0, 1) * x_1) + (mds (0, 2) * x_2))
      + alpha_pow 1
        * ( cell (var (Witness 7, Curr))
          - ((mds (1, 0) * x_0) + (mds (1, 1) * x_1) + (mds (1, 2) * x_2)) )
      + alpha_pow 2
        * ( cell (var (Witness 8, Curr))
          - ((mds (2, 0) * x_0) + (mds (2, 1) * x_1) + (mds (2, 2) * x_2)) )
      + alpha_pow 3
        * ( cell (var (Witness 9, Curr))
          - ((mds (0, 0) * x_3) + (mds (0, 1) * x_4) + (mds (0, 2) * x_5)) )
      + alpha_pow 4
        * ( cell (var (Witness 10, Curr))
          - ((mds (1, 0) * x_3) + (mds (1, 1) * x_4) + (mds (1, 2) * x_5)) )
      + alpha_pow 5
        * ( cell (var (Witness 11, Curr))
          - ((mds (2, 0) * x_3) + (mds (2, 1) * x_4) + (mds (2, 2) * x_5)) )
      + alpha_pow 6
        * ( cell (var (Witness 12, Curr))
          - ((mds (0, 0) * x_6) + (mds (0, 1) * x_7) + (mds (0, 2) * x_8)) )
      + alpha_pow 7
        * ( cell (var (Witness 13, Curr))
          - ((mds (1, 0) * x_6) + (mds (1, 1) * x_7) + (mds (1, 2) * x_8)) )
      + alpha_pow 8
        * ( cell (var (Witness 14, Curr))
          - ((mds (2, 0) * x_6) + (mds (2, 1) * x_7) + (mds (2, 2) * x_8)) )
      + alpha_pow 9
        * ( cell (var (Witness 3, Curr))
          - ((mds (0, 0) * x_9) + (mds (0, 1) * x_10) + (mds (0, 2) * x_11)) )
      + alpha_pow 10
        * ( cell (var (Witness 4, Curr))
          - ((mds (1, 0) * x_9) + (mds (1, 1) * x_10) + (mds (1, 2) * x_11)) )
      + alpha_pow 11
        * ( cell (var (Witness 5, Curr))
          - ((mds (2, 0) * x_9) + (mds (2, 1) * x_10) + (mds (2, 2) * x_11)) )
      + alpha_pow 12
        * ( cell (var (Witness 0, Next))
          - ((mds (0, 0) * x_12) + (mds (0, 1) * x_13) + (mds (0, 2) * x_14)) )
      + alpha_pow 13
        * ( cell (var (Witness 1, Next))
          - ((mds (1, 0) * x_12) + (mds (1, 1) * x_13) + (mds (1, 2) * x_14)) )
      + alpha_pow 14
        * ( cell (var (Witness 2, Next))
          - ((mds (2, 0) * x_12) + (mds (2, 1) * x_13) + (mds (2, 2) * x_14)) )
      )

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
      [ ( Index CompleteAdd
        , lazy
            (let x_0 =
               cell (var (Witness 2, Curr)) - cell (var (Witness 0, Curr))
             in
             let x_1 =
               cell (var (Witness 3, Curr)) - cell (var (Witness 1, Curr))
             in
             let x_2 =
               cell (var (Witness 0, Curr)) * cell (var (Witness 0, Curr))
             in
             alpha_pow 18
             * ( (cell (var (Witness 10, Curr)) * x_0)
               - ( field
                     "0x0000000000000000000000000000000000000000000000000000000000000001"
                 - cell (var (Witness 7, Curr)) ) )
             + (alpha_pow 19 * (cell (var (Witness 7, Curr)) * x_0))
             + alpha_pow 20
               * ( cell (var (Witness 7, Curr))
                   * ( double (cell (var (Witness 8, Curr)))
                       * cell (var (Witness 1, Curr))
                     - double x_2 - x_2 )
                 + ( field
                       "0x0000000000000000000000000000000000000000000000000000000000000001"
                   - cell (var (Witness 7, Curr)) )
                   * ((x_0 * cell (var (Witness 8, Curr))) - x_1) )
             + alpha_pow 21
               * ( cell (var (Witness 0, Curr))
                 + cell (var (Witness 2, Curr))
                 + cell (var (Witness 4, Curr))
                 - (cell (var (Witness 8, Curr)) * cell (var (Witness 8, Curr)))
                 )
             + alpha_pow 22
               * ( cell (var (Witness 8, Curr))
                   * ( cell (var (Witness 0, Curr))
                     - cell (var (Witness 4, Curr)) )
                 - cell (var (Witness 1, Curr))
                 - cell (var (Witness 5, Curr)) )
             + alpha_pow 23
               * ( x_1
                 * (cell (var (Witness 7, Curr)) - cell (var (Witness 6, Curr)))
                 )
             + alpha_pow 24
               * ( (x_1 * cell (var (Witness 9, Curr)))
                 - cell (var (Witness 6, Curr)) )) )
      ; ( Index Vbmul
        , lazy
            (let x_0 =
               cell (var (Witness 7, Next)) * cell (var (Witness 7, Next))
             in
             let x_1 =
               let x_0 =
                 cell (var (Witness 7, Next)) * cell (var (Witness 7, Next))
               in
               cell (var (Witness 2, Curr))
               - ( x_0
                 - cell (var (Witness 2, Curr))
                 - cell (var (Witness 0, Curr)) )
             in
             let x_2 =
               let x_1 =
                 let x_0 =
                   cell (var (Witness 7, Next)) * cell (var (Witness 7, Next))
                 in
                 cell (var (Witness 2, Curr))
                 - ( x_0
                   - cell (var (Witness 2, Curr))
                   - cell (var (Witness 0, Curr)) )
               in
               cell (var (Witness 3, Curr))
               + cell (var (Witness 3, Curr))
               - (x_1 * cell (var (Witness 7, Next)))
             in
             let x_3 =
               cell (var (Witness 8, Next)) * cell (var (Witness 8, Next))
             in
             let x_4 =
               let x_3 =
                 cell (var (Witness 8, Next)) * cell (var (Witness 8, Next))
               in
               cell (var (Witness 7, Curr))
               - ( x_3
                 - cell (var (Witness 7, Curr))
                 - cell (var (Witness 0, Curr)) )
             in
             let x_5 =
               let x_4 =
                 let x_3 =
                   cell (var (Witness 8, Next)) * cell (var (Witness 8, Next))
                 in
                 cell (var (Witness 7, Curr))
                 - ( x_3
                   - cell (var (Witness 7, Curr))
                   - cell (var (Witness 0, Curr)) )
               in
               cell (var (Witness 8, Curr))
               + cell (var (Witness 8, Curr))
               - (x_4 * cell (var (Witness 8, Next)))
             in
             let x_6 =
               cell (var (Witness 9, Next)) * cell (var (Witness 9, Next))
             in
             let x_7 =
               let x_6 =
                 cell (var (Witness 9, Next)) * cell (var (Witness 9, Next))
               in
               cell (var (Witness 9, Curr))
               - ( x_6
                 - cell (var (Witness 9, Curr))
                 - cell (var (Witness 0, Curr)) )
             in
             let x_8 =
               let x_7 =
                 let x_6 =
                   cell (var (Witness 9, Next)) * cell (var (Witness 9, Next))
                 in
                 cell (var (Witness 9, Curr))
                 - ( x_6
                   - cell (var (Witness 9, Curr))
                   - cell (var (Witness 0, Curr)) )
               in
               cell (var (Witness 10, Curr))
               + cell (var (Witness 10, Curr))
               - (x_7 * cell (var (Witness 9, Next)))
             in
             let x_9 =
               cell (var (Witness 10, Next)) * cell (var (Witness 10, Next))
             in
             let x_10 =
               let x_9 =
                 cell (var (Witness 10, Next)) * cell (var (Witness 10, Next))
               in
               cell (var (Witness 11, Curr))
               - ( x_9
                 - cell (var (Witness 11, Curr))
                 - cell (var (Witness 0, Curr)) )
             in
             let x_11 =
               let x_10 =
                 let x_9 =
                   cell (var (Witness 10, Next)) * cell (var (Witness 10, Next))
                 in
                 cell (var (Witness 11, Curr))
                 - ( x_9
                   - cell (var (Witness 11, Curr))
                   - cell (var (Witness 0, Curr)) )
               in
               cell (var (Witness 12, Curr))
               + cell (var (Witness 12, Curr))
               - (x_10 * cell (var (Witness 10, Next)))
             in
             let x_12 =
               cell (var (Witness 11, Next)) * cell (var (Witness 11, Next))
             in
             let x_13 =
               let x_12 =
                 cell (var (Witness 11, Next)) * cell (var (Witness 11, Next))
               in
               cell (var (Witness 13, Curr))
               - ( x_12
                 - cell (var (Witness 13, Curr))
                 - cell (var (Witness 0, Curr)) )
             in
             let x_14 =
               let x_13 =
                 let x_12 =
                   cell (var (Witness 11, Next)) * cell (var (Witness 11, Next))
                 in
                 cell (var (Witness 13, Curr))
                 - ( x_12
                   - cell (var (Witness 13, Curr))
                   - cell (var (Witness 0, Curr)) )
               in
               cell (var (Witness 14, Curr))
               + cell (var (Witness 14, Curr))
               - (x_13 * cell (var (Witness 11, Next)))
             in
             alpha_pow 36
             * ( cell (var (Witness 5, Curr))
               - ( cell (var (Witness 6, Next))
                 + double
                     ( cell (var (Witness 5, Next))
                     + double
                         ( cell (var (Witness 4, Next))
                         + double
                             ( cell (var (Witness 3, Next))
                             + double
                                 ( cell (var (Witness 2, Next))
                                 + double (cell (var (Witness 4, Curr))) ) ) )
                     ) ) )
             + alpha_pow 37
               * ( (cell (var (Witness 2, Next)) * cell (var (Witness 2, Next)))
                 - cell (var (Witness 2, Next)) )
             + alpha_pow 38
               * ( (cell (var (Witness 2, Curr)) - cell (var (Witness 0, Curr)))
                   * cell (var (Witness 7, Next))
                 - ( cell (var (Witness 3, Curr))
                   - ( cell (var (Witness 2, Next))
                     + cell (var (Witness 2, Next))
                     - field
                         "0x0000000000000000000000000000000000000000000000000000000000000001"
                     )
                     * cell (var (Witness 1, Curr)) ) )
             + alpha_pow 39
               * ( (x_2 * x_2)
                 - x_1 * x_1
                   * ( cell (var (Witness 7, Curr))
                     - cell (var (Witness 0, Curr))
                     + x_0 ) )
             + alpha_pow 40
               * ( (cell (var (Witness 8, Curr)) + cell (var (Witness 3, Curr)))
                   * x_1
                 - (cell (var (Witness 2, Curr)) - cell (var (Witness 7, Curr)))
                   * x_2 )
             + alpha_pow 41
               * ( (cell (var (Witness 3, Next)) * cell (var (Witness 3, Next)))
                 - cell (var (Witness 3, Next)) )
             + alpha_pow 42
               * ( (cell (var (Witness 7, Curr)) - cell (var (Witness 0, Curr)))
                   * cell (var (Witness 8, Next))
                 - ( cell (var (Witness 8, Curr))
                   - ( cell (var (Witness 3, Next))
                     + cell (var (Witness 3, Next))
                     - field
                         "0x0000000000000000000000000000000000000000000000000000000000000001"
                     )
                     * cell (var (Witness 1, Curr)) ) )
             + alpha_pow 43
               * ( (x_5 * x_5)
                 - x_4 * x_4
                   * ( cell (var (Witness 9, Curr))
                     - cell (var (Witness 0, Curr))
                     + x_3 ) )
             + alpha_pow 44
               * ( (cell (var (Witness 10, Curr)) + cell (var (Witness 8, Curr)))
                   * x_4
                 - (cell (var (Witness 7, Curr)) - cell (var (Witness 9, Curr)))
                   * x_5 )
             + alpha_pow 45
               * ( (cell (var (Witness 4, Next)) * cell (var (Witness 4, Next)))
                 - cell (var (Witness 4, Next)) )
             + alpha_pow 46
               * ( (cell (var (Witness 9, Curr)) - cell (var (Witness 0, Curr)))
                   * cell (var (Witness 9, Next))
                 - ( cell (var (Witness 10, Curr))
                   - ( cell (var (Witness 4, Next))
                     + cell (var (Witness 4, Next))
                     - field
                         "0x0000000000000000000000000000000000000000000000000000000000000001"
                     )
                     * cell (var (Witness 1, Curr)) ) )
             + alpha_pow 47
               * ( (x_8 * x_8)
                 - x_7 * x_7
                   * ( cell (var (Witness 11, Curr))
                     - cell (var (Witness 0, Curr))
                     + x_6 ) )
             + alpha_pow 48
               * ( ( cell (var (Witness 12, Curr))
                   + cell (var (Witness 10, Curr)) )
                   * x_7
                 - (cell (var (Witness 9, Curr)) - cell (var (Witness 11, Curr)))
                   * x_8 )
             + alpha_pow 49
               * ( (cell (var (Witness 5, Next)) * cell (var (Witness 5, Next)))
                 - cell (var (Witness 5, Next)) )
             + alpha_pow 50
               * ( (cell (var (Witness 11, Curr)) - cell (var (Witness 0, Curr)))
                   * cell (var (Witness 10, Next))
                 - ( cell (var (Witness 12, Curr))
                   - ( cell (var (Witness 5, Next))
                     + cell (var (Witness 5, Next))
                     - field
                         "0x0000000000000000000000000000000000000000000000000000000000000001"
                     )
                     * cell (var (Witness 1, Curr)) ) )
             + alpha_pow 51
               * ( (x_11 * x_11)
                 - x_10 * x_10
                   * ( cell (var (Witness 13, Curr))
                     - cell (var (Witness 0, Curr))
                     + x_9 ) )
             + alpha_pow 52
               * ( ( cell (var (Witness 14, Curr))
                   + cell (var (Witness 12, Curr)) )
                   * x_10
                 - ( cell (var (Witness 11, Curr))
                   - cell (var (Witness 13, Curr)) )
                   * x_11 )
             + alpha_pow 53
               * ( (cell (var (Witness 6, Next)) * cell (var (Witness 6, Next)))
                 - cell (var (Witness 6, Next)) )
             + alpha_pow 54
               * ( (cell (var (Witness 13, Curr)) - cell (var (Witness 0, Curr)))
                   * cell (var (Witness 11, Next))
                 - ( cell (var (Witness 14, Curr))
                   - ( cell (var (Witness 6, Next))
                     + cell (var (Witness 6, Next))
                     - field
                         "0x0000000000000000000000000000000000000000000000000000000000000001"
                     )
                     * cell (var (Witness 1, Curr)) ) )
             + alpha_pow 55
               * ( (x_14 * x_14)
                 - x_13 * x_13
                   * ( cell (var (Witness 0, Next))
                     - cell (var (Witness 0, Curr))
                     + x_12 ) )
             + alpha_pow 56
               * ( (cell (var (Witness 1, Next)) + cell (var (Witness 14, Curr)))
                   * x_13
                 - (cell (var (Witness 13, Curr)) - cell (var (Witness 0, Next)))
                   * x_14 )) )
      ; ( Index Endomul
        , lazy
            (let x_0 =
               ( field
                   "0x0000000000000000000000000000000000000000000000000000000000000001"
               + cell (var (Witness 11, Curr))
                 * ( endo_coefficient
                   - field
                       "0x0000000000000000000000000000000000000000000000000000000000000001"
                   ) )
               * cell (var (Witness 0, Curr))
             in
             let x_1 =
               ( field
                   "0x0000000000000000000000000000000000000000000000000000000000000001"
               + cell (var (Witness 13, Curr))
                 * ( endo_coefficient
                   - field
                       "0x0000000000000000000000000000000000000000000000000000000000000001"
                   ) )
               * cell (var (Witness 0, Curr))
             in
             let x_2 = square (cell (var (Witness 9, Curr))) in
             let x_3 = square (cell (var (Witness 10, Curr))) in
             let x_4 =
               cell (var (Witness 4, Curr)) - cell (var (Witness 7, Curr))
             in
             let x_5 =
               cell (var (Witness 7, Curr)) - cell (var (Witness 4, Next))
             in
             let x_6 =
               cell (var (Witness 5, Next)) + cell (var (Witness 8, Curr))
             in
             let x_7 =
               cell (var (Witness 8, Curr)) + cell (var (Witness 5, Curr))
             in
             alpha_pow 27
             * ( cell (var (Witness 11, Curr))
               - square (cell (var (Witness 11, Curr))) )
             + alpha_pow 28
               * ( cell (var (Witness 12, Curr))
                 - square (cell (var (Witness 12, Curr))) )
             + alpha_pow 29
               * ( cell (var (Witness 13, Curr))
                 - square (cell (var (Witness 13, Curr))) )
             + alpha_pow 30
               * ( cell (var (Witness 14, Curr))
                 - square (cell (var (Witness 14, Curr))) )
             + alpha_pow 31
               * ( (x_0 - cell (var (Witness 4, Curr)))
                   * cell (var (Witness 9, Curr))
                 - ( ( double (cell (var (Witness 12, Curr)))
                     - field
                         "0x0000000000000000000000000000000000000000000000000000000000000001"
                     )
                     * cell (var (Witness 1, Curr))
                   - cell (var (Witness 5, Curr)) ) )
             + alpha_pow 32
               * ( (double (cell (var (Witness 4, Curr))) - x_2 + x_0)
                   * ((x_4 * cell (var (Witness 9, Curr))) + x_7)
                 - (double (cell (var (Witness 5, Curr))) * x_4) )
             + alpha_pow 33
               * ( square x_7
                 - (square x_4 * (x_2 - x_0 + cell (var (Witness 7, Curr)))) )
             + alpha_pow 34
               * ( (x_1 - cell (var (Witness 7, Curr)))
                   * cell (var (Witness 10, Curr))
                 - ( ( double (cell (var (Witness 14, Curr)))
                     - field
                         "0x0000000000000000000000000000000000000000000000000000000000000001"
                     )
                     * cell (var (Witness 1, Curr))
                   - cell (var (Witness 8, Curr)) ) )
             + alpha_pow 35
               * ( (double (cell (var (Witness 7, Curr))) - x_3 + x_1)
                   * ((x_5 * cell (var (Witness 10, Curr))) + x_6)
                 - (double (cell (var (Witness 8, Curr))) * x_5) )
             + alpha_pow 36
               * ( square x_6
                 - (square x_5 * (x_3 - x_1 + cell (var (Witness 4, Next)))) )
             + alpha_pow 37
               * ( double
                     ( double
                         ( double
                             ( double (cell (var (Witness 6, Curr)))
                             + cell (var (Witness 11, Curr)) )
                         + cell (var (Witness 12, Curr)) )
                     + cell (var (Witness 13, Curr)) )
                 + cell (var (Witness 14, Curr))
                 - cell (var (Witness 6, Next)) )) )
      ; ( Index EndomulScalar
        , lazy
            (let x_0 =
               ( ( field
                     "0x1555555555555555555555555555555560C232FEADC45309330F104F00000001"
                   * cell (var (Witness 6, Curr))
                 + field
                     "0x2000000000000000000000000000000011234C7E04A67C8DCC9698767FFFFFFE"
                 )
                 * cell (var (Witness 6, Curr))
               + field
                   "0x0AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAB061197F56E229849987882780000002"
               )
               * cell (var (Witness 6, Curr))
             in
             let x_1 =
               ( ( field
                     "0x1555555555555555555555555555555560C232FEADC45309330F104F00000001"
                   * cell (var (Witness 7, Curr))
                 + field
                     "0x2000000000000000000000000000000011234C7E04A67C8DCC9698767FFFFFFE"
                 )
                 * cell (var (Witness 7, Curr))
               + field
                   "0x0AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAB061197F56E229849987882780000002"
               )
               * cell (var (Witness 7, Curr))
             in
             let x_2 =
               ( ( field
                     "0x1555555555555555555555555555555560C232FEADC45309330F104F00000001"
                   * cell (var (Witness 8, Curr))
                 + field
                     "0x2000000000000000000000000000000011234C7E04A67C8DCC9698767FFFFFFE"
                 )
                 * cell (var (Witness 8, Curr))
               + field
                   "0x0AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAB061197F56E229849987882780000002"
               )
               * cell (var (Witness 8, Curr))
             in
             let x_3 =
               ( ( field
                     "0x1555555555555555555555555555555560C232FEADC45309330F104F00000001"
                   * cell (var (Witness 9, Curr))
                 + field
                     "0x2000000000000000000000000000000011234C7E04A67C8DCC9698767FFFFFFE"
                 )
                 * cell (var (Witness 9, Curr))
               + field
                   "0x0AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAB061197F56E229849987882780000002"
               )
               * cell (var (Witness 9, Curr))
             in
             let x_4 =
               ( ( field
                     "0x1555555555555555555555555555555560C232FEADC45309330F104F00000001"
                   * cell (var (Witness 10, Curr))
                 + field
                     "0x2000000000000000000000000000000011234C7E04A67C8DCC9698767FFFFFFE"
                 )
                 * cell (var (Witness 10, Curr))
               + field
                   "0x0AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAB061197F56E229849987882780000002"
               )
               * cell (var (Witness 10, Curr))
             in
             let x_5 =
               ( ( field
                     "0x1555555555555555555555555555555560C232FEADC45309330F104F00000001"
                   * cell (var (Witness 11, Curr))
                 + field
                     "0x2000000000000000000000000000000011234C7E04A67C8DCC9698767FFFFFFE"
                 )
                 * cell (var (Witness 11, Curr))
               + field
                   "0x0AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAB061197F56E229849987882780000002"
               )
               * cell (var (Witness 11, Curr))
             in
             let x_6 =
               ( ( field
                     "0x1555555555555555555555555555555560C232FEADC45309330F104F00000001"
                   * cell (var (Witness 12, Curr))
                 + field
                     "0x2000000000000000000000000000000011234C7E04A67C8DCC9698767FFFFFFE"
                 )
                 * cell (var (Witness 12, Curr))
               + field
                   "0x0AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAB061197F56E229849987882780000002"
               )
               * cell (var (Witness 12, Curr))
             in
             let x_7 =
               ( ( field
                     "0x1555555555555555555555555555555560C232FEADC45309330F104F00000001"
                   * cell (var (Witness 13, Curr))
                 + field
                     "0x2000000000000000000000000000000011234C7E04A67C8DCC9698767FFFFFFE"
                 )
                 * cell (var (Witness 13, Curr))
               + field
                   "0x0AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAB061197F56E229849987882780000002"
               )
               * cell (var (Witness 13, Curr))
             in
             alpha_pow 59
             * ( double
                   (double
                      ( double
                          (double
                             ( double
                                 (double
                                    ( double
                                        (double
                                           ( double
                                               (double
                                                  ( double
                                                      (double
                                                         ( double
                                                             (double
                                                                ( double
                                                                    (double
                                                                       (cell
                                                                          (var
                                                                             ( Witness
                                                                                0
                                                                             , Curr
                                                                             ))))
                                                                + cell
                                                                    (var
                                                                       ( Witness
                                                                           6
                                                                       , Curr ))
                                                                ))
                                                         + cell
                                                             (var
                                                                (Witness 7, Curr))
                                                         ))
                                                  + cell (var (Witness 8, Curr))
                                                  ))
                                           + cell (var (Witness 9, Curr)) ))
                                    + cell (var (Witness 10, Curr)) ))
                             + cell (var (Witness 11, Curr)) ))
                      + cell (var (Witness 12, Curr)) ))
               + cell (var (Witness 13, Curr))
               - cell (var (Witness 1, Curr)) )
             + alpha_pow 60
               * ( double
                     ( double
                         ( double
                             ( double
                                 ( double
                                     ( double
                                         ( double
                                             ( double
                                                 (cell (var (Witness 2, Curr)))
                                             + x_0 )
                                         + x_1 )
                                     + x_2 )
                                 + x_3 )
                             + x_4 )
                         + x_5 )
                     + x_6 )
                 + x_7
                 - cell (var (Witness 4, Curr)) )
             + alpha_pow 61
               * ( double
                     ( double
                         ( double
                             ( double
                                 ( double
                                     ( double
                                         ( double
                                             ( double
                                                 (cell (var (Witness 3, Curr)))
                                             + ( x_0
                                               + ( ( field
                                                       "0x40000000000000000000000000000000224698FC094CF91B992D30ED00000000"
                                                     * cell
                                                         (var (Witness 6, Curr))
                                                   + field
                                                       "0x0000000000000000000000000000000000000000000000000000000000000003"
                                                   )
                                                   * cell
                                                       (var (Witness 6, Curr))
                                                 + field
                                                     "0x40000000000000000000000000000000224698FC094CF91B992D30ED00000000"
                                                 ) ) )
                                         + ( x_1
                                           + ( ( field
                                                   "0x40000000000000000000000000000000224698FC094CF91B992D30ED00000000"
                                                 * cell (var (Witness 7, Curr))
                                               + field
                                                   "0x0000000000000000000000000000000000000000000000000000000000000003"
                                               )
                                               * cell (var (Witness 7, Curr))
                                             + field
                                                 "0x40000000000000000000000000000000224698FC094CF91B992D30ED00000000"
                                             ) ) )
                                     + ( x_2
                                       + ( ( field
                                               "0x40000000000000000000000000000000224698FC094CF91B992D30ED00000000"
                                             * cell (var (Witness 8, Curr))
                                           + field
                                               "0x0000000000000000000000000000000000000000000000000000000000000003"
                                           )
                                           * cell (var (Witness 8, Curr))
                                         + field
                                             "0x40000000000000000000000000000000224698FC094CF91B992D30ED00000000"
                                         ) ) )
                                 + ( x_3
                                   + ( ( field
                                           "0x40000000000000000000000000000000224698FC094CF91B992D30ED00000000"
                                         * cell (var (Witness 9, Curr))
                                       + field
                                           "0x0000000000000000000000000000000000000000000000000000000000000003"
                                       )
                                       * cell (var (Witness 9, Curr))
                                     + field
                                         "0x40000000000000000000000000000000224698FC094CF91B992D30ED00000000"
                                     ) ) )
                             + ( x_4
                               + ( ( field
                                       "0x40000000000000000000000000000000224698FC094CF91B992D30ED00000000"
                                     * cell (var (Witness 10, Curr))
                                   + field
                                       "0x0000000000000000000000000000000000000000000000000000000000000003"
                                   )
                                   * cell (var (Witness 10, Curr))
                                 + field
                                     "0x40000000000000000000000000000000224698FC094CF91B992D30ED00000000"
                                 ) ) )
                         + ( x_5
                           + ( ( field
                                   "0x40000000000000000000000000000000224698FC094CF91B992D30ED00000000"
                                 * cell (var (Witness 11, Curr))
                               + field
                                   "0x0000000000000000000000000000000000000000000000000000000000000003"
                               )
                               * cell (var (Witness 11, Curr))
                             + field
                                 "0x40000000000000000000000000000000224698FC094CF91B992D30ED00000000"
                             ) ) )
                     + ( x_6
                       + ( ( field
                               "0x40000000000000000000000000000000224698FC094CF91B992D30ED00000000"
                             * cell (var (Witness 12, Curr))
                           + field
                               "0x0000000000000000000000000000000000000000000000000000000000000003"
                           )
                           * cell (var (Witness 12, Curr))
                         + field
                             "0x40000000000000000000000000000000224698FC094CF91B992D30ED00000000"
                         ) ) )
                 + ( x_7
                   + ( ( field
                           "0x40000000000000000000000000000000224698FC094CF91B992D30ED00000000"
                         * cell (var (Witness 13, Curr))
                       + field
                           "0x0000000000000000000000000000000000000000000000000000000000000003"
                       )
                       * cell (var (Witness 13, Curr))
                     + field
                         "0x40000000000000000000000000000000224698FC094CF91B992D30ED00000000"
                     ) )
                 - cell (var (Witness 5, Curr)) )
             + alpha_pow 62
               * ( ( ( ( cell (var (Witness 6, Curr))
                       + field
                           "0x40000000000000000000000000000000224698FC094CF91B992D30ECFFFFFFFB"
                       )
                       * cell (var (Witness 6, Curr))
                     + field
                         "0x000000000000000000000000000000000000000000000000000000000000000B"
                     )
                     * cell (var (Witness 6, Curr))
                   + field
                       "0x40000000000000000000000000000000224698FC094CF91B992D30ECFFFFFFFB"
                   )
                 * cell (var (Witness 6, Curr)) )
             + alpha_pow 63
               * ( ( ( ( cell (var (Witness 7, Curr))
                       + field
                           "0x40000000000000000000000000000000224698FC094CF91B992D30ECFFFFFFFB"
                       )
                       * cell (var (Witness 7, Curr))
                     + field
                         "0x000000000000000000000000000000000000000000000000000000000000000B"
                     )
                     * cell (var (Witness 7, Curr))
                   + field
                       "0x40000000000000000000000000000000224698FC094CF91B992D30ECFFFFFFFB"
                   )
                 * cell (var (Witness 7, Curr)) )
             + alpha_pow 64
               * ( ( ( ( cell (var (Witness 8, Curr))
                       + field
                           "0x40000000000000000000000000000000224698FC094CF91B992D30ECFFFFFFFB"
                       )
                       * cell (var (Witness 8, Curr))
                     + field
                         "0x000000000000000000000000000000000000000000000000000000000000000B"
                     )
                     * cell (var (Witness 8, Curr))
                   + field
                       "0x40000000000000000000000000000000224698FC094CF91B992D30ECFFFFFFFB"
                   )
                 * cell (var (Witness 8, Curr)) )
             + alpha_pow 65
               * ( ( ( ( cell (var (Witness 9, Curr))
                       + field
                           "0x40000000000000000000000000000000224698FC094CF91B992D30ECFFFFFFFB"
                       )
                       * cell (var (Witness 9, Curr))
                     + field
                         "0x000000000000000000000000000000000000000000000000000000000000000B"
                     )
                     * cell (var (Witness 9, Curr))
                   + field
                       "0x40000000000000000000000000000000224698FC094CF91B992D30ECFFFFFFFB"
                   )
                 * cell (var (Witness 9, Curr)) )
             + alpha_pow 66
               * ( ( ( ( cell (var (Witness 10, Curr))
                       + field
                           "0x40000000000000000000000000000000224698FC094CF91B992D30ECFFFFFFFB"
                       )
                       * cell (var (Witness 10, Curr))
                     + field
                         "0x000000000000000000000000000000000000000000000000000000000000000B"
                     )
                     * cell (var (Witness 10, Curr))
                   + field
                       "0x40000000000000000000000000000000224698FC094CF91B992D30ECFFFFFFFB"
                   )
                 * cell (var (Witness 10, Curr)) )
             + alpha_pow 67
               * ( ( ( ( cell (var (Witness 11, Curr))
                       + field
                           "0x40000000000000000000000000000000224698FC094CF91B992D30ECFFFFFFFB"
                       )
                       * cell (var (Witness 11, Curr))
                     + field
                         "0x000000000000000000000000000000000000000000000000000000000000000B"
                     )
                     * cell (var (Witness 11, Curr))
                   + field
                       "0x40000000000000000000000000000000224698FC094CF91B992D30ECFFFFFFFB"
                   )
                 * cell (var (Witness 11, Curr)) )
             + alpha_pow 68
               * ( ( ( ( cell (var (Witness 12, Curr))
                       + field
                           "0x40000000000000000000000000000000224698FC094CF91B992D30ECFFFFFFFB"
                       )
                       * cell (var (Witness 12, Curr))
                     + field
                         "0x000000000000000000000000000000000000000000000000000000000000000B"
                     )
                     * cell (var (Witness 12, Curr))
                   + field
                       "0x40000000000000000000000000000000224698FC094CF91B992D30ECFFFFFFFB"
                   )
                 * cell (var (Witness 12, Curr)) )
             + alpha_pow 69
               * ( ( ( ( cell (var (Witness 13, Curr))
                       + field
                           "0x40000000000000000000000000000000224698FC094CF91B992D30ECFFFFFFFB"
                       )
                       * cell (var (Witness 13, Curr))
                     + field
                         "0x000000000000000000000000000000000000000000000000000000000000000B"
                     )
                     * cell (var (Witness 13, Curr))
                   + field
                       "0x40000000000000000000000000000000224698FC094CF91B992D30ECFFFFFFFB"
                   )
                 * cell (var (Witness 13, Curr)) )) )
      ; ( Coefficient 0
        , lazy
            ( cell (var (Index Poseidon, Curr))
            * field
                "0x40000000000000000000000000000000224698FC094CF91B992D30ED00000000"
            ) )
      ; ( Coefficient 1
        , lazy
            ( cell (var (Index Poseidon, Curr))
            * ( alpha_pow 1
              * field
                  "0x40000000000000000000000000000000224698FC094CF91B992D30ED00000000"
              ) ) )
      ; ( Coefficient 2
        , lazy
            ( cell (var (Index Poseidon, Curr))
            * ( alpha_pow 2
              * field
                  "0x40000000000000000000000000000000224698FC094CF91B992D30ED00000000"
              ) ) )
      ; ( Coefficient 3
        , lazy
            ( cell (var (Index Poseidon, Curr))
            * ( alpha_pow 3
              * field
                  "0x40000000000000000000000000000000224698FC094CF91B992D30ED00000000"
              ) ) )
      ; ( Coefficient 4
        , lazy
            ( cell (var (Index Poseidon, Curr))
            * ( alpha_pow 4
              * field
                  "0x40000000000000000000000000000000224698FC094CF91B992D30ED00000000"
              ) ) )
      ; ( Coefficient 5
        , lazy
            ( cell (var (Index Poseidon, Curr))
            * ( alpha_pow 5
              * field
                  "0x40000000000000000000000000000000224698FC094CF91B992D30ED00000000"
              ) ) )
      ; ( Coefficient 6
        , lazy
            ( cell (var (Index Poseidon, Curr))
            * ( alpha_pow 6
              * field
                  "0x40000000000000000000000000000000224698FC094CF91B992D30ED00000000"
              ) ) )
      ; ( Coefficient 7
        , lazy
            ( cell (var (Index Poseidon, Curr))
            * ( alpha_pow 7
              * field
                  "0x40000000000000000000000000000000224698FC094CF91B992D30ED00000000"
              ) ) )
      ; ( Coefficient 8
        , lazy
            ( cell (var (Index Poseidon, Curr))
            * ( alpha_pow 8
              * field
                  "0x40000000000000000000000000000000224698FC094CF91B992D30ED00000000"
              ) ) )
      ; ( Coefficient 9
        , lazy
            ( cell (var (Index Poseidon, Curr))
            * ( alpha_pow 9
              * field
                  "0x40000000000000000000000000000000224698FC094CF91B992D30ED00000000"
              ) ) )
      ; ( Coefficient 10
        , lazy
            ( cell (var (Index Poseidon, Curr))
            * ( alpha_pow 10
              * field
                  "0x40000000000000000000000000000000224698FC094CF91B992D30ED00000000"
              ) ) )
      ; ( Coefficient 11
        , lazy
            ( cell (var (Index Poseidon, Curr))
            * ( alpha_pow 11
              * field
                  "0x40000000000000000000000000000000224698FC094CF91B992D30ED00000000"
              ) ) )
      ; ( Coefficient 12
        , lazy
            ( cell (var (Index Poseidon, Curr))
            * ( alpha_pow 12
              * field
                  "0x40000000000000000000000000000000224698FC094CF91B992D30ED00000000"
              ) ) )
      ; ( Coefficient 13
        , lazy
            ( cell (var (Index Poseidon, Curr))
            * ( alpha_pow 13
              * field
                  "0x40000000000000000000000000000000224698FC094CF91B992D30ED00000000"
              ) ) )
      ; ( Coefficient 14
        , lazy
            ( cell (var (Index Poseidon, Curr))
            * ( alpha_pow 14
              * field
                  "0x40000000000000000000000000000000224698FC094CF91B992D30ED00000000"
              ) ) )
      ]
end

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
    let x_0 = pow (cell (var (Witness 0, Curr)), 7) in
    let x_1 = pow (cell (var (Witness 1, Curr)), 7) in
    let x_2 = pow (cell (var (Witness 2, Curr)), 7) in
    let x_3 = pow (cell (var (Witness 6, Curr)), 7) in
    let x_4 = pow (cell (var (Witness 7, Curr)), 7) in
    let x_5 = pow (cell (var (Witness 8, Curr)), 7) in
    let x_6 = pow (cell (var (Witness 9, Curr)), 7) in
    let x_7 = pow (cell (var (Witness 10, Curr)), 7) in
    let x_8 = pow (cell (var (Witness 11, Curr)), 7) in
    let x_9 = pow (cell (var (Witness 12, Curr)), 7) in
    let x_10 = pow (cell (var (Witness 13, Curr)), 7) in
    let x_11 = pow (cell (var (Witness 14, Curr)), 7) in
    let x_12 = pow (cell (var (Witness 3, Curr)), 7) in
    let x_13 = pow (cell (var (Witness 4, Curr)), 7) in
    let x_14 = pow (cell (var (Witness 5, Curr)), 7) in
    cell (var (Index Poseidon, Curr))
    * ( cell (var (Witness 6, Curr))
      - ((mds (0, 0) * x_0) + (mds (0, 1) * x_1) + (mds (0, 2) * x_2))
      + alpha_pow 1
        * ( cell (var (Witness 7, Curr))
          - ((mds (1, 0) * x_0) + (mds (1, 1) * x_1) + (mds (1, 2) * x_2)) )
      + alpha_pow 2
        * ( cell (var (Witness 8, Curr))
          - ((mds (2, 0) * x_0) + (mds (2, 1) * x_1) + (mds (2, 2) * x_2)) )
      + alpha_pow 3
        * ( cell (var (Witness 9, Curr))
          - ((mds (0, 0) * x_3) + (mds (0, 1) * x_4) + (mds (0, 2) * x_5)) )
      + alpha_pow 4
        * ( cell (var (Witness 10, Curr))
          - ((mds (1, 0) * x_3) + (mds (1, 1) * x_4) + (mds (1, 2) * x_5)) )
      + alpha_pow 5
        * ( cell (var (Witness 11, Curr))
          - ((mds (2, 0) * x_3) + (mds (2, 1) * x_4) + (mds (2, 2) * x_5)) )
      + alpha_pow 6
        * ( cell (var (Witness 12, Curr))
          - ((mds (0, 0) * x_6) + (mds (0, 1) * x_7) + (mds (0, 2) * x_8)) )
      + alpha_pow 7
        * ( cell (var (Witness 13, Curr))
          - ((mds (1, 0) * x_6) + (mds (1, 1) * x_7) + (mds (1, 2) * x_8)) )
      + alpha_pow 8
        * ( cell (var (Witness 14, Curr))
          - ((mds (2, 0) * x_6) + (mds (2, 1) * x_7) + (mds (2, 2) * x_8)) )
      + alpha_pow 9
        * ( cell (var (Witness 3, Curr))
          - ((mds (0, 0) * x_9) + (mds (0, 1) * x_10) + (mds (0, 2) * x_11)) )
      + alpha_pow 10
        * ( cell (var (Witness 4, Curr))
          - ((mds (1, 0) * x_9) + (mds (1, 1) * x_10) + (mds (1, 2) * x_11)) )
      + alpha_pow 11
        * ( cell (var (Witness 5, Curr))
          - ((mds (2, 0) * x_9) + (mds (2, 1) * x_10) + (mds (2, 2) * x_11)) )
      + alpha_pow 12
        * ( cell (var (Witness 0, Next))
          - ((mds (0, 0) * x_12) + (mds (0, 1) * x_13) + (mds (0, 2) * x_14)) )
      + alpha_pow 13
        * ( cell (var (Witness 1, Next))
          - ((mds (1, 0) * x_12) + (mds (1, 1) * x_13) + (mds (1, 2) * x_14)) )
      + alpha_pow 14
        * ( cell (var (Witness 2, Next))
          - ((mds (2, 0) * x_12) + (mds (2, 1) * x_13) + (mds (2, 2) * x_14)) )
      )

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
      [ ( Index CompleteAdd
        , lazy
            (let x_0 =
               cell (var (Witness 2, Curr)) - cell (var (Witness 0, Curr))
             in
             let x_1 =
               cell (var (Witness 3, Curr)) - cell (var (Witness 1, Curr))
             in
             let x_2 =
               cell (var (Witness 0, Curr)) * cell (var (Witness 0, Curr))
             in
             alpha_pow 18
             * ( (cell (var (Witness 10, Curr)) * x_0)
               - ( field
                     "0x0000000000000000000000000000000000000000000000000000000000000001"
                 - cell (var (Witness 7, Curr)) ) )
             + (alpha_pow 19 * (cell (var (Witness 7, Curr)) * x_0))
             + alpha_pow 20
               * ( cell (var (Witness 7, Curr))
                   * ( double (cell (var (Witness 8, Curr)))
                       * cell (var (Witness 1, Curr))
                     - double x_2 - x_2 )
                 + ( field
                       "0x0000000000000000000000000000000000000000000000000000000000000001"
                   - cell (var (Witness 7, Curr)) )
                   * ((x_0 * cell (var (Witness 8, Curr))) - x_1) )
             + alpha_pow 21
               * ( cell (var (Witness 0, Curr))
                 + cell (var (Witness 2, Curr))
                 + cell (var (Witness 4, Curr))
                 - (cell (var (Witness 8, Curr)) * cell (var (Witness 8, Curr)))
                 )
             + alpha_pow 22
               * ( cell (var (Witness 8, Curr))
                   * ( cell (var (Witness 0, Curr))
                     - cell (var (Witness 4, Curr)) )
                 - cell (var (Witness 1, Curr))
                 - cell (var (Witness 5, Curr)) )
             + alpha_pow 23
               * ( x_1
                 * (cell (var (Witness 7, Curr)) - cell (var (Witness 6, Curr)))
                 )
             + alpha_pow 24
               * ( (x_1 * cell (var (Witness 9, Curr)))
                 - cell (var (Witness 6, Curr)) )) )
      ; ( Index Vbmul
        , lazy
            (let x_0 =
               cell (var (Witness 7, Next)) * cell (var (Witness 7, Next))
             in
             let x_1 =
               let x_0 =
                 cell (var (Witness 7, Next)) * cell (var (Witness 7, Next))
               in
               cell (var (Witness 2, Curr))
               - ( x_0
                 - cell (var (Witness 2, Curr))
                 - cell (var (Witness 0, Curr)) )
             in
             let x_2 =
               let x_1 =
                 let x_0 =
                   cell (var (Witness 7, Next)) * cell (var (Witness 7, Next))
                 in
                 cell (var (Witness 2, Curr))
                 - ( x_0
                   - cell (var (Witness 2, Curr))
                   - cell (var (Witness 0, Curr)) )
               in
               cell (var (Witness 3, Curr))
               + cell (var (Witness 3, Curr))
               - (x_1 * cell (var (Witness 7, Next)))
             in
             let x_3 =
               cell (var (Witness 8, Next)) * cell (var (Witness 8, Next))
             in
             let x_4 =
               let x_3 =
                 cell (var (Witness 8, Next)) * cell (var (Witness 8, Next))
               in
               cell (var (Witness 7, Curr))
               - ( x_3
                 - cell (var (Witness 7, Curr))
                 - cell (var (Witness 0, Curr)) )
             in
             let x_5 =
               let x_4 =
                 let x_3 =
                   cell (var (Witness 8, Next)) * cell (var (Witness 8, Next))
                 in
                 cell (var (Witness 7, Curr))
                 - ( x_3
                   - cell (var (Witness 7, Curr))
                   - cell (var (Witness 0, Curr)) )
               in
               cell (var (Witness 8, Curr))
               + cell (var (Witness 8, Curr))
               - (x_4 * cell (var (Witness 8, Next)))
             in
             let x_6 =
               cell (var (Witness 9, Next)) * cell (var (Witness 9, Next))
             in
             let x_7 =
               let x_6 =
                 cell (var (Witness 9, Next)) * cell (var (Witness 9, Next))
               in
               cell (var (Witness 9, Curr))
               - ( x_6
                 - cell (var (Witness 9, Curr))
                 - cell (var (Witness 0, Curr)) )
             in
             let x_8 =
               let x_7 =
                 let x_6 =
                   cell (var (Witness 9, Next)) * cell (var (Witness 9, Next))
                 in
                 cell (var (Witness 9, Curr))
                 - ( x_6
                   - cell (var (Witness 9, Curr))
                   - cell (var (Witness 0, Curr)) )
               in
               cell (var (Witness 10, Curr))
               + cell (var (Witness 10, Curr))
               - (x_7 * cell (var (Witness 9, Next)))
             in
             let x_9 =
               cell (var (Witness 10, Next)) * cell (var (Witness 10, Next))
             in
             let x_10 =
               let x_9 =
                 cell (var (Witness 10, Next)) * cell (var (Witness 10, Next))
               in
               cell (var (Witness 11, Curr))
               - ( x_9
                 - cell (var (Witness 11, Curr))
                 - cell (var (Witness 0, Curr)) )
             in
             let x_11 =
               let x_10 =
                 let x_9 =
                   cell (var (Witness 10, Next)) * cell (var (Witness 10, Next))
                 in
                 cell (var (Witness 11, Curr))
                 - ( x_9
                   - cell (var (Witness 11, Curr))
                   - cell (var (Witness 0, Curr)) )
               in
               cell (var (Witness 12, Curr))
               + cell (var (Witness 12, Curr))
               - (x_10 * cell (var (Witness 10, Next)))
             in
             let x_12 =
               cell (var (Witness 11, Next)) * cell (var (Witness 11, Next))
             in
             let x_13 =
               let x_12 =
                 cell (var (Witness 11, Next)) * cell (var (Witness 11, Next))
               in
               cell (var (Witness 13, Curr))
               - ( x_12
                 - cell (var (Witness 13, Curr))
                 - cell (var (Witness 0, Curr)) )
             in
             let x_14 =
               let x_13 =
                 let x_12 =
                   cell (var (Witness 11, Next)) * cell (var (Witness 11, Next))
                 in
                 cell (var (Witness 13, Curr))
                 - ( x_12
                   - cell (var (Witness 13, Curr))
                   - cell (var (Witness 0, Curr)) )
               in
               cell (var (Witness 14, Curr))
               + cell (var (Witness 14, Curr))
               - (x_13 * cell (var (Witness 11, Next)))
             in
             alpha_pow 36
             * ( cell (var (Witness 5, Curr))
               - ( cell (var (Witness 6, Next))
                 + double
                     ( cell (var (Witness 5, Next))
                     + double
                         ( cell (var (Witness 4, Next))
                         + double
                             ( cell (var (Witness 3, Next))
                             + double
                                 ( cell (var (Witness 2, Next))
                                 + double (cell (var (Witness 4, Curr))) ) ) )
                     ) ) )
             + alpha_pow 37
               * ( (cell (var (Witness 2, Next)) * cell (var (Witness 2, Next)))
                 - cell (var (Witness 2, Next)) )
             + alpha_pow 38
               * ( (cell (var (Witness 2, Curr)) - cell (var (Witness 0, Curr)))
                   * cell (var (Witness 7, Next))
                 - ( cell (var (Witness 3, Curr))
                   - ( cell (var (Witness 2, Next))
                     + cell (var (Witness 2, Next))
                     - field
                         "0x0000000000000000000000000000000000000000000000000000000000000001"
                     )
                     * cell (var (Witness 1, Curr)) ) )
             + alpha_pow 39
               * ( (x_2 * x_2)
                 - x_1 * x_1
                   * ( cell (var (Witness 7, Curr))
                     - cell (var (Witness 0, Curr))
                     + x_0 ) )
             + alpha_pow 40
               * ( (cell (var (Witness 8, Curr)) + cell (var (Witness 3, Curr)))
                   * x_1
                 - (cell (var (Witness 2, Curr)) - cell (var (Witness 7, Curr)))
                   * x_2 )
             + alpha_pow 41
               * ( (cell (var (Witness 3, Next)) * cell (var (Witness 3, Next)))
                 - cell (var (Witness 3, Next)) )
             + alpha_pow 42
               * ( (cell (var (Witness 7, Curr)) - cell (var (Witness 0, Curr)))
                   * cell (var (Witness 8, Next))
                 - ( cell (var (Witness 8, Curr))
                   - ( cell (var (Witness 3, Next))
                     + cell (var (Witness 3, Next))
                     - field
                         "0x0000000000000000000000000000000000000000000000000000000000000001"
                     )
                     * cell (var (Witness 1, Curr)) ) )
             + alpha_pow 43
               * ( (x_5 * x_5)
                 - x_4 * x_4
                   * ( cell (var (Witness 9, Curr))
                     - cell (var (Witness 0, Curr))
                     + x_3 ) )
             + alpha_pow 44
               * ( (cell (var (Witness 10, Curr)) + cell (var (Witness 8, Curr)))
                   * x_4
                 - (cell (var (Witness 7, Curr)) - cell (var (Witness 9, Curr)))
                   * x_5 )
             + alpha_pow 45
               * ( (cell (var (Witness 4, Next)) * cell (var (Witness 4, Next)))
                 - cell (var (Witness 4, Next)) )
             + alpha_pow 46
               * ( (cell (var (Witness 9, Curr)) - cell (var (Witness 0, Curr)))
                   * cell (var (Witness 9, Next))
                 - ( cell (var (Witness 10, Curr))
                   - ( cell (var (Witness 4, Next))
                     + cell (var (Witness 4, Next))
                     - field
                         "0x0000000000000000000000000000000000000000000000000000000000000001"
                     )
                     * cell (var (Witness 1, Curr)) ) )
             + alpha_pow 47
               * ( (x_8 * x_8)
                 - x_7 * x_7
                   * ( cell (var (Witness 11, Curr))
                     - cell (var (Witness 0, Curr))
                     + x_6 ) )
             + alpha_pow 48
               * ( ( cell (var (Witness 12, Curr))
                   + cell (var (Witness 10, Curr)) )
                   * x_7
                 - (cell (var (Witness 9, Curr)) - cell (var (Witness 11, Curr)))
                   * x_8 )
             + alpha_pow 49
               * ( (cell (var (Witness 5, Next)) * cell (var (Witness 5, Next)))
                 - cell (var (Witness 5, Next)) )
             + alpha_pow 50
               * ( (cell (var (Witness 11, Curr)) - cell (var (Witness 0, Curr)))
                   * cell (var (Witness 10, Next))
                 - ( cell (var (Witness 12, Curr))
                   - ( cell (var (Witness 5, Next))
                     + cell (var (Witness 5, Next))
                     - field
                         "0x0000000000000000000000000000000000000000000000000000000000000001"
                     )
                     * cell (var (Witness 1, Curr)) ) )
             + alpha_pow 51
               * ( (x_11 * x_11)
                 - x_10 * x_10
                   * ( cell (var (Witness 13, Curr))
                     - cell (var (Witness 0, Curr))
                     + x_9 ) )
             + alpha_pow 52
               * ( ( cell (var (Witness 14, Curr))
                   + cell (var (Witness 12, Curr)) )
                   * x_10
                 - ( cell (var (Witness 11, Curr))
                   - cell (var (Witness 13, Curr)) )
                   * x_11 )
             + alpha_pow 53
               * ( (cell (var (Witness 6, Next)) * cell (var (Witness 6, Next)))
                 - cell (var (Witness 6, Next)) )
             + alpha_pow 54
               * ( (cell (var (Witness 13, Curr)) - cell (var (Witness 0, Curr)))
                   * cell (var (Witness 11, Next))
                 - ( cell (var (Witness 14, Curr))
                   - ( cell (var (Witness 6, Next))
                     + cell (var (Witness 6, Next))
                     - field
                         "0x0000000000000000000000000000000000000000000000000000000000000001"
                     )
                     * cell (var (Witness 1, Curr)) ) )
             + alpha_pow 55
               * ( (x_14 * x_14)
                 - x_13 * x_13
                   * ( cell (var (Witness 0, Next))
                     - cell (var (Witness 0, Curr))
                     + x_12 ) )
             + alpha_pow 56
               * ( (cell (var (Witness 1, Next)) + cell (var (Witness 14, Curr)))
                   * x_13
                 - (cell (var (Witness 13, Curr)) - cell (var (Witness 0, Next)))
                   * x_14 )) )
      ; ( Index Endomul
        , lazy
            (let x_0 =
               ( field
                   "0x0000000000000000000000000000000000000000000000000000000000000001"
               + cell (var (Witness 11, Curr))
                 * ( endo_coefficient
                   - field
                       "0x0000000000000000000000000000000000000000000000000000000000000001"
                   ) )
               * cell (var (Witness 0, Curr))
             in
             let x_1 =
               ( field
                   "0x0000000000000000000000000000000000000000000000000000000000000001"
               + cell (var (Witness 13, Curr))
                 * ( endo_coefficient
                   - field
                       "0x0000000000000000000000000000000000000000000000000000000000000001"
                   ) )
               * cell (var (Witness 0, Curr))
             in
             let x_2 = square (cell (var (Witness 9, Curr))) in
             let x_3 = square (cell (var (Witness 10, Curr))) in
             let x_4 =
               cell (var (Witness 4, Curr)) - cell (var (Witness 7, Curr))
             in
             let x_5 =
               cell (var (Witness 7, Curr)) - cell (var (Witness 4, Next))
             in
             let x_6 =
               cell (var (Witness 5, Next)) + cell (var (Witness 8, Curr))
             in
             let x_7 =
               cell (var (Witness 8, Curr)) + cell (var (Witness 5, Curr))
             in
             alpha_pow 27
             * ( cell (var (Witness 11, Curr))
               - square (cell (var (Witness 11, Curr))) )
             + alpha_pow 28
               * ( cell (var (Witness 12, Curr))
                 - square (cell (var (Witness 12, Curr))) )
             + alpha_pow 29
               * ( cell (var (Witness 13, Curr))
                 - square (cell (var (Witness 13, Curr))) )
             + alpha_pow 30
               * ( cell (var (Witness 14, Curr))
                 - square (cell (var (Witness 14, Curr))) )
             + alpha_pow 31
               * ( (x_0 - cell (var (Witness 4, Curr)))
                   * cell (var (Witness 9, Curr))
                 - ( ( double (cell (var (Witness 12, Curr)))
                     - field
                         "0x0000000000000000000000000000000000000000000000000000000000000001"
                     )
                     * cell (var (Witness 1, Curr))
                   - cell (var (Witness 5, Curr)) ) )
             + alpha_pow 32
               * ( (double (cell (var (Witness 4, Curr))) - x_2 + x_0)
                   * ((x_4 * cell (var (Witness 9, Curr))) + x_7)
                 - (double (cell (var (Witness 5, Curr))) * x_4) )
             + alpha_pow 33
               * ( square x_7
                 - (square x_4 * (x_2 - x_0 + cell (var (Witness 7, Curr)))) )
             + alpha_pow 34
               * ( (x_1 - cell (var (Witness 7, Curr)))
                   * cell (var (Witness 10, Curr))
                 - ( ( double (cell (var (Witness 14, Curr)))
                     - field
                         "0x0000000000000000000000000000000000000000000000000000000000000001"
                     )
                     * cell (var (Witness 1, Curr))
                   - cell (var (Witness 8, Curr)) ) )
             + alpha_pow 35
               * ( (double (cell (var (Witness 7, Curr))) - x_3 + x_1)
                   * ((x_5 * cell (var (Witness 10, Curr))) + x_6)
                 - (double (cell (var (Witness 8, Curr))) * x_5) )
             + alpha_pow 36
               * ( square x_6
                 - (square x_5 * (x_3 - x_1 + cell (var (Witness 4, Next)))) )
             + alpha_pow 37
               * ( double
                     ( double
                         ( double
                             ( double (cell (var (Witness 6, Curr)))
                             + cell (var (Witness 11, Curr)) )
                         + cell (var (Witness 12, Curr)) )
                     + cell (var (Witness 13, Curr)) )
                 + cell (var (Witness 14, Curr))
                 - cell (var (Witness 6, Next)) )) )
      ; ( Index EndomulScalar
        , lazy
            (let x_0 =
               ( ( field
                     "0x1555555555555555555555555555555560C232FEADDC3849D96CF90B00000001"
                   * cell (var (Witness 6, Curr))
                 + field
                     "0x2000000000000000000000000000000011234C7E04CA546EC62375907FFFFFFE"
                 )
                 * cell (var (Witness 6, Curr))
               + field
                   "0x0AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAB061197F56EE1C24ECB67C8580000002"
               )
               * cell (var (Witness 6, Curr))
             in
             let x_1 =
               ( ( field
                     "0x1555555555555555555555555555555560C232FEADDC3849D96CF90B00000001"
                   * cell (var (Witness 7, Curr))
                 + field
                     "0x2000000000000000000000000000000011234C7E04CA546EC62375907FFFFFFE"
                 )
                 * cell (var (Witness 7, Curr))
               + field
                   "0x0AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAB061197F56EE1C24ECB67C8580000002"
               )
               * cell (var (Witness 7, Curr))
             in
             let x_2 =
               ( ( field
                     "0x1555555555555555555555555555555560C232FEADDC3849D96CF90B00000001"
                   * cell (var (Witness 8, Curr))
                 + field
                     "0x2000000000000000000000000000000011234C7E04CA546EC62375907FFFFFFE"
                 )
                 * cell (var (Witness 8, Curr))
               + field
                   "0x0AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAB061197F56EE1C24ECB67C8580000002"
               )
               * cell (var (Witness 8, Curr))
             in
             let x_3 =
               ( ( field
                     "0x1555555555555555555555555555555560C232FEADDC3849D96CF90B00000001"
                   * cell (var (Witness 9, Curr))
                 + field
                     "0x2000000000000000000000000000000011234C7E04CA546EC62375907FFFFFFE"
                 )
                 * cell (var (Witness 9, Curr))
               + field
                   "0x0AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAB061197F56EE1C24ECB67C8580000002"
               )
               * cell (var (Witness 9, Curr))
             in
             let x_4 =
               ( ( field
                     "0x1555555555555555555555555555555560C232FEADDC3849D96CF90B00000001"
                   * cell (var (Witness 10, Curr))
                 + field
                     "0x2000000000000000000000000000000011234C7E04CA546EC62375907FFFFFFE"
                 )
                 * cell (var (Witness 10, Curr))
               + field
                   "0x0AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAB061197F56EE1C24ECB67C8580000002"
               )
               * cell (var (Witness 10, Curr))
             in
             let x_5 =
               ( ( field
                     "0x1555555555555555555555555555555560C232FEADDC3849D96CF90B00000001"
                   * cell (var (Witness 11, Curr))
                 + field
                     "0x2000000000000000000000000000000011234C7E04CA546EC62375907FFFFFFE"
                 )
                 * cell (var (Witness 11, Curr))
               + field
                   "0x0AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAB061197F56EE1C24ECB67C8580000002"
               )
               * cell (var (Witness 11, Curr))
             in
             let x_6 =
               ( ( field
                     "0x1555555555555555555555555555555560C232FEADDC3849D96CF90B00000001"
                   * cell (var (Witness 12, Curr))
                 + field
                     "0x2000000000000000000000000000000011234C7E04CA546EC62375907FFFFFFE"
                 )
                 * cell (var (Witness 12, Curr))
               + field
                   "0x0AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAB061197F56EE1C24ECB67C8580000002"
               )
               * cell (var (Witness 12, Curr))
             in
             let x_7 =
               ( ( field
                     "0x1555555555555555555555555555555560C232FEADDC3849D96CF90B00000001"
                   * cell (var (Witness 13, Curr))
                 + field
                     "0x2000000000000000000000000000000011234C7E04CA546EC62375907FFFFFFE"
                 )
                 * cell (var (Witness 13, Curr))
               + field
                   "0x0AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAB061197F56EE1C24ECB67C8580000002"
               )
               * cell (var (Witness 13, Curr))
             in
             alpha_pow 59
             * ( double
                   (double
                      ( double
                          (double
                             ( double
                                 (double
                                    ( double
                                        (double
                                           ( double
                                               (double
                                                  ( double
                                                      (double
                                                         ( double
                                                             (double
                                                                ( double
                                                                    (double
                                                                       (cell
                                                                          (var
                                                                             ( Witness
                                                                                0
                                                                             , Curr
                                                                             ))))
                                                                + cell
                                                                    (var
                                                                       ( Witness
                                                                           6
                                                                       , Curr ))
                                                                ))
                                                         + cell
                                                             (var
                                                                (Witness 7, Curr))
                                                         ))
                                                  + cell (var (Witness 8, Curr))
                                                  ))
                                           + cell (var (Witness 9, Curr)) ))
                                    + cell (var (Witness 10, Curr)) ))
                             + cell (var (Witness 11, Curr)) ))
                      + cell (var (Witness 12, Curr)) ))
               + cell (var (Witness 13, Curr))
               - cell (var (Witness 1, Curr)) )
             + alpha_pow 60
               * ( double
                     ( double
                         ( double
                             ( double
                                 ( double
                                     ( double
                                         ( double
                                             ( double
                                                 (cell (var (Witness 2, Curr)))
                                             + x_0 )
                                         + x_1 )
                                     + x_2 )
                                 + x_3 )
                             + x_4 )
                         + x_5 )
                     + x_6 )
                 + x_7
                 - cell (var (Witness 4, Curr)) )
             + alpha_pow 61
               * ( double
                     ( double
                         ( double
                             ( double
                                 ( double
                                     ( double
                                         ( double
                                             ( double
                                                 (cell (var (Witness 3, Curr)))
                                             + ( x_0
                                               + ( ( field
                                                       "0x40000000000000000000000000000000224698FC0994A8DD8C46EB2100000000"
                                                     * cell
                                                         (var (Witness 6, Curr))
                                                   + field
                                                       "0x0000000000000000000000000000000000000000000000000000000000000003"
                                                   )
                                                   * cell
                                                       (var (Witness 6, Curr))
                                                 + field
                                                     "0x40000000000000000000000000000000224698FC0994A8DD8C46EB2100000000"
                                                 ) ) )
                                         + ( x_1
                                           + ( ( field
                                                   "0x40000000000000000000000000000000224698FC0994A8DD8C46EB2100000000"
                                                 * cell (var (Witness 7, Curr))
                                               + field
                                                   "0x0000000000000000000000000000000000000000000000000000000000000003"
                                               )
                                               * cell (var (Witness 7, Curr))
                                             + field
                                                 "0x40000000000000000000000000000000224698FC0994A8DD8C46EB2100000000"
                                             ) ) )
                                     + ( x_2
                                       + ( ( field
                                               "0x40000000000000000000000000000000224698FC0994A8DD8C46EB2100000000"
                                             * cell (var (Witness 8, Curr))
                                           + field
                                               "0x0000000000000000000000000000000000000000000000000000000000000003"
                                           )
                                           * cell (var (Witness 8, Curr))
                                         + field
                                             "0x40000000000000000000000000000000224698FC0994A8DD8C46EB2100000000"
                                         ) ) )
                                 + ( x_3
                                   + ( ( field
                                           "0x40000000000000000000000000000000224698FC0994A8DD8C46EB2100000000"
                                         * cell (var (Witness 9, Curr))
                                       + field
                                           "0x0000000000000000000000000000000000000000000000000000000000000003"
                                       )
                                       * cell (var (Witness 9, Curr))
                                     + field
                                         "0x40000000000000000000000000000000224698FC0994A8DD8C46EB2100000000"
                                     ) ) )
                             + ( x_4
                               + ( ( field
                                       "0x40000000000000000000000000000000224698FC0994A8DD8C46EB2100000000"
                                     * cell (var (Witness 10, Curr))
                                   + field
                                       "0x0000000000000000000000000000000000000000000000000000000000000003"
                                   )
                                   * cell (var (Witness 10, Curr))
                                 + field
                                     "0x40000000000000000000000000000000224698FC0994A8DD8C46EB2100000000"
                                 ) ) )
                         + ( x_5
                           + ( ( field
                                   "0x40000000000000000000000000000000224698FC0994A8DD8C46EB2100000000"
                                 * cell (var (Witness 11, Curr))
                               + field
                                   "0x0000000000000000000000000000000000000000000000000000000000000003"
                               )
                               * cell (var (Witness 11, Curr))
                             + field
                                 "0x40000000000000000000000000000000224698FC0994A8DD8C46EB2100000000"
                             ) ) )
                     + ( x_6
                       + ( ( field
                               "0x40000000000000000000000000000000224698FC0994A8DD8C46EB2100000000"
                             * cell (var (Witness 12, Curr))
                           + field
                               "0x0000000000000000000000000000000000000000000000000000000000000003"
                           )
                           * cell (var (Witness 12, Curr))
                         + field
                             "0x40000000000000000000000000000000224698FC0994A8DD8C46EB2100000000"
                         ) ) )
                 + ( x_7
                   + ( ( field
                           "0x40000000000000000000000000000000224698FC0994A8DD8C46EB2100000000"
                         * cell (var (Witness 13, Curr))
                       + field
                           "0x0000000000000000000000000000000000000000000000000000000000000003"
                       )
                       * cell (var (Witness 13, Curr))
                     + field
                         "0x40000000000000000000000000000000224698FC0994A8DD8C46EB2100000000"
                     ) )
                 - cell (var (Witness 5, Curr)) )
             + alpha_pow 62
               * ( ( ( ( cell (var (Witness 6, Curr))
                       + field
                           "0x40000000000000000000000000000000224698FC0994A8DD8C46EB20FFFFFFFB"
                       )
                       * cell (var (Witness 6, Curr))
                     + field
                         "0x000000000000000000000000000000000000000000000000000000000000000B"
                     )
                     * cell (var (Witness 6, Curr))
                   + field
                       "0x40000000000000000000000000000000224698FC0994A8DD8C46EB20FFFFFFFB"
                   )
                 * cell (var (Witness 6, Curr)) )
             + alpha_pow 63
               * ( ( ( ( cell (var (Witness 7, Curr))
                       + field
                           "0x40000000000000000000000000000000224698FC0994A8DD8C46EB20FFFFFFFB"
                       )
                       * cell (var (Witness 7, Curr))
                     + field
                         "0x000000000000000000000000000000000000000000000000000000000000000B"
                     )
                     * cell (var (Witness 7, Curr))
                   + field
                       "0x40000000000000000000000000000000224698FC0994A8DD8C46EB20FFFFFFFB"
                   )
                 * cell (var (Witness 7, Curr)) )
             + alpha_pow 64
               * ( ( ( ( cell (var (Witness 8, Curr))
                       + field
                           "0x40000000000000000000000000000000224698FC0994A8DD8C46EB20FFFFFFFB"
                       )
                       * cell (var (Witness 8, Curr))
                     + field
                         "0x000000000000000000000000000000000000000000000000000000000000000B"
                     )
                     * cell (var (Witness 8, Curr))
                   + field
                       "0x40000000000000000000000000000000224698FC0994A8DD8C46EB20FFFFFFFB"
                   )
                 * cell (var (Witness 8, Curr)) )
             + alpha_pow 65
               * ( ( ( ( cell (var (Witness 9, Curr))
                       + field
                           "0x40000000000000000000000000000000224698FC0994A8DD8C46EB20FFFFFFFB"
                       )
                       * cell (var (Witness 9, Curr))
                     + field
                         "0x000000000000000000000000000000000000000000000000000000000000000B"
                     )
                     * cell (var (Witness 9, Curr))
                   + field
                       "0x40000000000000000000000000000000224698FC0994A8DD8C46EB20FFFFFFFB"
                   )
                 * cell (var (Witness 9, Curr)) )
             + alpha_pow 66
               * ( ( ( ( cell (var (Witness 10, Curr))
                       + field
                           "0x40000000000000000000000000000000224698FC0994A8DD8C46EB20FFFFFFFB"
                       )
                       * cell (var (Witness 10, Curr))
                     + field
                         "0x000000000000000000000000000000000000000000000000000000000000000B"
                     )
                     * cell (var (Witness 10, Curr))
                   + field
                       "0x40000000000000000000000000000000224698FC0994A8DD8C46EB20FFFFFFFB"
                   )
                 * cell (var (Witness 10, Curr)) )
             + alpha_pow 67
               * ( ( ( ( cell (var (Witness 11, Curr))
                       + field
                           "0x40000000000000000000000000000000224698FC0994A8DD8C46EB20FFFFFFFB"
                       )
                       * cell (var (Witness 11, Curr))
                     + field
                         "0x000000000000000000000000000000000000000000000000000000000000000B"
                     )
                     * cell (var (Witness 11, Curr))
                   + field
                       "0x40000000000000000000000000000000224698FC0994A8DD8C46EB20FFFFFFFB"
                   )
                 * cell (var (Witness 11, Curr)) )
             + alpha_pow 68
               * ( ( ( ( cell (var (Witness 12, Curr))
                       + field
                           "0x40000000000000000000000000000000224698FC0994A8DD8C46EB20FFFFFFFB"
                       )
                       * cell (var (Witness 12, Curr))
                     + field
                         "0x000000000000000000000000000000000000000000000000000000000000000B"
                     )
                     * cell (var (Witness 12, Curr))
                   + field
                       "0x40000000000000000000000000000000224698FC0994A8DD8C46EB20FFFFFFFB"
                   )
                 * cell (var (Witness 12, Curr)) )
             + alpha_pow 69
               * ( ( ( ( cell (var (Witness 13, Curr))
                       + field
                           "0x40000000000000000000000000000000224698FC0994A8DD8C46EB20FFFFFFFB"
                       )
                       * cell (var (Witness 13, Curr))
                     + field
                         "0x000000000000000000000000000000000000000000000000000000000000000B"
                     )
                     * cell (var (Witness 13, Curr))
                   + field
                       "0x40000000000000000000000000000000224698FC0994A8DD8C46EB20FFFFFFFB"
                   )
                 * cell (var (Witness 13, Curr)) )) )
      ; ( Coefficient 0
        , lazy
            ( cell (var (Index Poseidon, Curr))
            * field
                "0x40000000000000000000000000000000224698FC0994A8DD8C46EB2100000000"
            ) )
      ; ( Coefficient 1
        , lazy
            ( cell (var (Index Poseidon, Curr))
            * ( alpha_pow 1
              * field
                  "0x40000000000000000000000000000000224698FC0994A8DD8C46EB2100000000"
              ) ) )
      ; ( Coefficient 2
        , lazy
            ( cell (var (Index Poseidon, Curr))
            * ( alpha_pow 2
              * field
                  "0x40000000000000000000000000000000224698FC0994A8DD8C46EB2100000000"
              ) ) )
      ; ( Coefficient 3
        , lazy
            ( cell (var (Index Poseidon, Curr))
            * ( alpha_pow 3
              * field
                  "0x40000000000000000000000000000000224698FC0994A8DD8C46EB2100000000"
              ) ) )
      ; ( Coefficient 4
        , lazy
            ( cell (var (Index Poseidon, Curr))
            * ( alpha_pow 4
              * field
                  "0x40000000000000000000000000000000224698FC0994A8DD8C46EB2100000000"
              ) ) )
      ; ( Coefficient 5
        , lazy
            ( cell (var (Index Poseidon, Curr))
            * ( alpha_pow 5
              * field
                  "0x40000000000000000000000000000000224698FC0994A8DD8C46EB2100000000"
              ) ) )
      ; ( Coefficient 6
        , lazy
            ( cell (var (Index Poseidon, Curr))
            * ( alpha_pow 6
              * field
                  "0x40000000000000000000000000000000224698FC0994A8DD8C46EB2100000000"
              ) ) )
      ; ( Coefficient 7
        , lazy
            ( cell (var (Index Poseidon, Curr))
            * ( alpha_pow 7
              * field
                  "0x40000000000000000000000000000000224698FC0994A8DD8C46EB2100000000"
              ) ) )
      ; ( Coefficient 8
        , lazy
            ( cell (var (Index Poseidon, Curr))
            * ( alpha_pow 8
              * field
                  "0x40000000000000000000000000000000224698FC0994A8DD8C46EB2100000000"
              ) ) )
      ; ( Coefficient 9
        , lazy
            ( cell (var (Index Poseidon, Curr))
            * ( alpha_pow 9
              * field
                  "0x40000000000000000000000000000000224698FC0994A8DD8C46EB2100000000"
              ) ) )
      ; ( Coefficient 10
        , lazy
            ( cell (var (Index Poseidon, Curr))
            * ( alpha_pow 10
              * field
                  "0x40000000000000000000000000000000224698FC0994A8DD8C46EB2100000000"
              ) ) )
      ; ( Coefficient 11
        , lazy
            ( cell (var (Index Poseidon, Curr))
            * ( alpha_pow 11
              * field
                  "0x40000000000000000000000000000000224698FC0994A8DD8C46EB2100000000"
              ) ) )
      ; ( Coefficient 12
        , lazy
            ( cell (var (Index Poseidon, Curr))
            * ( alpha_pow 12
              * field
                  "0x40000000000000000000000000000000224698FC0994A8DD8C46EB2100000000"
              ) ) )
      ; ( Coefficient 13
        , lazy
            ( cell (var (Index Poseidon, Curr))
            * ( alpha_pow 13
              * field
                  "0x40000000000000000000000000000000224698FC0994A8DD8C46EB2100000000"
              ) ) )
      ; ( Coefficient 14
        , lazy
            ( cell (var (Index Poseidon, Curr))
            * ( alpha_pow 14
              * field
                  "0x40000000000000000000000000000000224698FC0994A8DD8C46EB2100000000"
              ) ) )
      ]
end
