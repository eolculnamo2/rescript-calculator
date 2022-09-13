@react.component
let make = (~label, ~onClick, ~value, ~style=?) => {
  <button style={style->Belt.Option.getWithDefault(ReactDOM.Style.make(()))} onClick={_ => onClick(value)}>
    {label->React.string}
  </button>
}
