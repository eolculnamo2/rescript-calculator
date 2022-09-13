let operators = ["+", "-", "*", "/", "="]

exception InvalidOperatorToken(string)
exception NoOperatorFound
exception InvalidFinalToken
exception NaNException
type operatorToken = Add | Subtract | Multiply | Divide
let mapStringToToken = str => {
  switch str {
  | "+" => Add
  | "-" => Subtract
  | "*" => Multiply
  | "/" => Divide
  | _ => raise(InvalidOperatorToken(str))
  }
}
type token = Operator(operatorToken) | Number(float)
let combineNumericSymbols = (symbols): array<token> => {
  let combinedNumString = ref("")

  let reducedSymbols = symbols->Belt.Array.reduce([], (agg, cur) => {
    switch Belt.Float.fromString(cur) {
    | Some(_) => {
        combinedNumString.contents = combinedNumString.contents ++ cur
        agg
      }
    | None => {
        let n = combinedNumString.contents->Belt.Float.fromString->Belt.Option.getExn
        combinedNumString.contents = ""
        agg->Belt.Array.concat([Number(n), Operator(cur->mapStringToToken)])
      }
    }
  })
  // erm, what if this is an operator?
  reducedSymbols->Belt.Array.concat([
    Number(combinedNumString.contents->Belt.Float.fromString->Belt.Option.getExn),
  ])
}

let resolveOperator = (a, b, operator: operatorToken) => {
  switch operator {
  | Add => a +. b
  | Subtract => a -. b
  | Multiply => a *. b
  | Divide => a /. b
  }
}

let rec compute = (tokens: array<token>) => {
  let priorityOperatorIndex = tokens->Belt.Array.getIndexBy(a => {
    switch a {
    | Operator(Multiply | Divide) => true
    | _ => false
    }
  })

  let (i, operator) = switch priorityOperatorIndex {
  | Some(index) => (index, tokens->Belt.Array.get(index)->Belt.Option.getExn)
  | None => {
      let secondaryOperatorIndex = tokens->Belt.Array.getIndexBy(a => {
        switch a {
        | Operator(Add | Subtract) => true
        | _ => false
        }
      })
      switch secondaryOperatorIndex {
      | Some(secondaryIndex) => (
          secondaryIndex,
          tokens->Belt.Array.get(secondaryIndex)->Belt.Option.getExn,
        )
      | None => raise(NoOperatorFound)
      }
    }
  }

  let beforeFloat = tokens->Belt.Array.get(i - 1)
  let afterFloat = tokens->Belt.Array.get(i + 1)

  let subtotal = switch (beforeFloat, afterFloat, operator) {
  | (Some(Number(a)), Some(Number(b)), Operator(o)) => resolveOperator(a, b, o)
  | _ => 0.
  }
  let newTokens = tokens->Js.Array2.filteri((_, ind) => ind != i && ind != i - 1 && ind != i + 1)

  let setIndex = Js.Math.max_int(i - 1, 0)
  switch newTokens->Belt.Array.length {
  | 0 => subtotal
  | 1 =>
    switch newTokens->Belt.Array.get(0)->Belt.Option.getExn {
    | Number(a) => a
    | _ => raise(InvalidFinalToken)
    }
  | _ => newTokens->Utils.Array.insertAtIndex(setIndex, Number(subtotal))->compute
  }
}
let computeOrReturn = (combinedSymbols: array<token>) => {
  switch combinedSymbols->Belt.Array.length {
  | 0 => 0.
  | 1 =>
    switch combinedSymbols->Belt.Array.get(0)->Belt.Option.getExn {
    | Number(n) => n
    | _ => raise(NaNException)
    }
  | _ => compute(combinedSymbols)
  }
}
let make = (symbols: array<string>) => {
  if symbols->Belt.Array.length == 0 {
    0.
  } else {
    symbols->combineNumericSymbols->computeOrReturn
  }
}
