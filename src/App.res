%%raw("import './App.css'")

let validCharacters = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "+", "-", "=", "*", "/"]
type state = {symbols: array<string>}
let state = {
  symbols: [],
}
type action = InputReceived(string) | Compute | Clear
let reducer = (state, action) => {
  switch action {
  | InputReceived(v) =>
    if validCharacters->Js.Array2.includes(v) == false {
      Js.Console.warn("Invalid character received")
      state
    } else {
      switch state.symbols->Belt.Array.copy->Js.Array2.pop {
      | None
        if state.symbols->Belt.Array.length < 1 &&
          Calculate.operators->Js.Array2.includes(v) => state
      | None => {
          symbols: [v],
        }
      | Some(item)
        if Calculate.operators->Js.Array2.includes(item) &&
          Calculate.operators->Js.Array2.includes(v) => {
          symbols: state.symbols
          ->Belt.Array.slice(~offset=0, ~len=state.symbols->Belt.Array.length - 1)
          ->Js.Array2.concat([v]),
        }
      | Some(_) => {
          symbols: state.symbols->Js.Array2.concat([v]),
        }
      }
    }
  | Compute => {
      let answer = state.symbols -> Calculate.make -> Belt.Float.toString
      {
        symbols: [answer],
      }
    }
  | Clear => {symbols: []}
  }
}
@react.component @genType
let make = () => {
  let (state, dispatch) = React.useReducer(reducer, state)
  <div className="App">
    <Display values=state.symbols />
    <Pad
      gatherValue={v => v->InputReceived->dispatch}
      compute={_ => Compute->dispatch}
      clear={_ => Clear->dispatch}
    />
  </div>
}
