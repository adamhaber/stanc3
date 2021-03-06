open Core_kernel
open Middle
open Dataflow_types

val map_rec_expr :
     (expr_typed_located expr -> expr_typed_located expr)
  -> expr_typed_located
  -> expr_typed_located

val map_rec_expr_state :
     ('s -> expr_typed_located expr -> expr_typed_located expr * 's)
  -> 's
  -> expr_typed_located
  -> expr_typed_located * 's

val map_rec_stmt_loc :
     (   (expr_typed_located, stmt_loc) statement
      -> (expr_typed_located, stmt_loc) statement)
  -> stmt_loc
  -> stmt_loc

val map_rec_state_stmt_loc :
     (   's
      -> (expr_typed_located, stmt_loc) statement
      -> (expr_typed_located, stmt_loc) statement * 's)
  -> 's
  -> stmt_loc
  -> stmt_loc * 's

val map_rec_stmt_loc_num :
     (int, stmt_loc_num) Map.Poly.t
  -> (   int
      -> (expr_typed_located, stmt_loc) statement
      -> (expr_typed_located, stmt_loc) statement)
  -> stmt_loc_num
  -> stmt_loc

val map_rec_state_stmt_loc_num :
     (int, stmt_loc_num) Map.Poly.t
  -> (   int
      -> 's
      -> (expr_typed_located, stmt_loc) statement
      -> (expr_typed_located, stmt_loc) statement * 's)
  -> 's
  -> stmt_loc_num
  -> stmt_loc * 's

val stmt_loc_of_stmt_loc_num :
  (int, stmt_loc_num) Map.Poly.t -> stmt_loc_num -> stmt_loc

val statement_stmt_loc_of_statement_stmt_loc_num :
     (int, stmt_loc_num) Map.Poly.t
  -> (mtype_loc_ad with_expr, int) statement
  -> ( mtype_loc_ad with_expr
     , (mtype_loc_ad, location_span) stmt_with )
     statement

val unnumbered_prog_of_numbered_prog :
     (int, stmt_loc_num) Map.Poly.t
  -> ('a -> 'b)
  -> (stmt_loc_num, 'a) prog
  -> (stmt_loc, 'b) prog

val fwd_traverse_statement :
     ('e, 'a) statement
  -> init:'f
  -> f:('f -> 'a -> 'f * 'c)
  -> 'f * ('e, 'c) statement
(**
   A traversal that simultaneously accumulates a state (type 'f) and replaces the
   substatement values from ('a to 'c). Traversal is done in-order but ignores branching,
   e.g., and if's then block is followed by the else block rather than branching.
*)

val vexpr_of_expr_exn : expr_typed_located -> vexpr
(**
   Take a LHS expression from a general expression, throwing an exception if it can't be a
   LHS expression.
*)

val expr_var_set : expr_typed_located -> vexpr Set.Poly.t
(**
   The set of variables in an expression, including inside an index.

   For use in RHS sets, not LHS assignment sets, except in a target term.
*)

val index_var_set : expr_typed_located index -> vexpr Set.Poly.t
(**
   The set of variables in an index.

   For use in RHS sets, not LHS assignment sets, except in a target term
*)

val stmt_rhs : (expr_typed_located, 's) statement -> ExprSet.t
(**
   The set of variables that can affect the value or behavior of the expression, i.e. rhs.

   Using Set.Poly instead of ExprSet so that 'e can be polymorphic, it usually doesn't
   matter if there's duplication.
*)

val union_map : 'a Set.Poly.t -> f:('a -> 'b Set.Poly.t) -> 'b Set.Poly.t
(**
   This is a helper function equivalent to List.concat_map but for Sets
*)

val stmt_rhs_var_set : (expr_typed_located, 's) statement -> vexpr Set.Poly.t
(**
   The set of variables in an expression, including inside an index.

   For use in RHS sets, not LHS assignment sets, except in a target term.
*)

val expr_assigned_var : expr_typed_located -> vexpr
(**
   The variable being assigned to when the expression is the LHS
*)

val summation_terms : expr_typed_located -> expr_typed_located list
(** The list of terms in expression separated by a + *)

val stmt_of_block : stmt_loc list -> stmt_loc
(** Represent a list of statements as a single statement *)

val subst_expr :
     (string, expr_typed_located) Map.Poly.t
  -> expr_typed_located
  -> expr_typed_located
(** Substitute variables in an expression according to the provided Map. *)

val subst_stmt_base :
     (string, expr_typed_located) Map.Poly.t
  -> (expr_typed_located, 'a) statement
  -> (expr_typed_located, 'a) statement
(** Substitute variables occurring at the top level in statements according to the provided Map. *)

val subst_stmt :
  (string, expr_typed_located) Map.Poly.t -> stmt_loc -> stmt_loc
(** Substitute variables occurring anywhere in a statement according to the provided Map. *)

val expr_subst_expr :
  expr_typed_located ExprMap.t -> expr_typed_located -> expr_typed_located
(** Substitute subexpressions in an expression according to the provided Map, trying
    to match on larger subexpressions before smaller ones. *)

val expr_subst_stmt : expr_typed_located ExprMap.t -> stmt_loc -> stmt_loc
(** Substitute subexpressions occurring anywhere in a statement according to the provided Map. *)

val expr_subst_stmt_base :
     expr_typed_located ExprMap.t
  -> (expr_typed_located, 'a) statement
  -> (expr_typed_located, 'a) statement
(** Substitute subexpressions occurring at the top level in statements according to the provided Map. *)

val expr_depth : expr_typed_located -> int
(** Calculate how deeply nested an expression is. *)

val update_expr_ad_levels :
  string Set.Poly.t -> mtype_loc_ad with_expr -> mtype_loc_ad with_expr
(** Recompute all AD-levels in the metadata of an expression from the bottom up, making the variables
    in the first argument autodiffable *)
