module Rational exposing
  ( Rational
  , new

  , add, sub, mul, div

  , toString, toDecimalString
  )


import Set exposing (Set)


type Rational
  = Rational Int Int


new : Int -> Int -> Maybe Rational
new numer denom =
  if denom == 0 then
    Nothing
  else
    Just (makeRational numer denom)


makeRational : Int -> Int -> Rational
makeRational numer denom =
  let
    divisor =
      gcd numer denom

    g =
      if denom < 0 then
        -divisor
      else
        divisor

    n =
      numer // g

    d =
      denom // g
  in
    Rational n d


gcd : Int -> Int -> Int
gcd a b =
  gcdHelper (abs a) (abs b)


gcdHelper : Int -> Int -> Int
gcdHelper a b =
  if b == 0 then
    a
  else
    gcdHelper b (modBy b a)


add : Rational -> Rational -> Rational
add (Rational n1 d1) (Rational n2 d2) =
  makeRational (n1*d2 + n2*d1) (d1*d2)


sub : Rational -> Rational -> Rational
sub (Rational n1 d1) (Rational n2 d2) =
  makeRational (n1*d2 - n2*d1) (d1*d2)


mul : Rational -> Rational -> Rational
mul (Rational n1 d1) (Rational n2 d2) =
  makeRational (n1*n2) (d1*d2)


div : Rational -> Rational -> Rational
div (Rational n1 d1) (Rational n2 d2) =
  if n2 == 0 then
    Rational 0 1
  else
    makeRational (n1*d2) (d1*n2)


toString : Rational -> String
toString (Rational n d) =
  if d == 1 then
    String.fromInt n
  else
    String.fromInt n ++ "/" ++ String.fromInt d


toDecimalString : Rational -> String
toDecimalString (Rational n d) =
  if d == 1 then
    String.fromInt n
  else
    let
      quotient =
        n // d

      remainder =
        modBy d (abs n)
    in
      String.fromInt quotient ++ "." ++ (decimalRep remainder d)


decimalRep : Int -> Int -> String
decimalRep n d =
  decimalRepHelper n d [] Set.empty


decimalRepHelper : Int -> Int -> List (Int, Int) -> Set (Int, Int) -> String
decimalRepHelper n d terms seen =
  let
    n10 =
      n * 10

    q =
      n10 // d

    r =
      modBy d n10
  in
    if r == 0 then
      displayTerminating (List.reverse ((q, r) :: terms))
    else
      if Set.member (q, r) seen then
        displayRepeating (List.reverse terms) (q, r)
      else
        decimalRepHelper
          r
          d
          ((q, r) :: terms)
          (Set.insert (q, r) seen)


displayTerminating : List (Int, Int) -> String
displayTerminating terms =
  case terms of
    [] ->
      ""

    ((q, _) :: rest) ->
      String.fromInt q ++ displayTerminating rest


displayRepeating : List (Int, Int) -> (Int, Int) -> String
displayRepeating terms marker =
  case terms of
    [] ->
      ")"

    ((q, r) :: rest) ->
      let
        s =
          if (q, r) == marker then
            "(" ++ String.fromInt q
          else
            String.fromInt q
      in
        s ++ displayRepeating rest marker
