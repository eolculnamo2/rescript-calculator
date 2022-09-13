@react.component
let make = (~values) => {
  <div style=ReactDOM.Style.make(~backgroundColor="#a3a365", ~padding="1rem", ~height=".75rem", ~border="4px solid gray", ~boxShadow="border-box", ())>
    {values -> Js.Array2.joinWith("")->React.string}
  </div>
}
