@react.component
let make = (~gatherValue, ~compute, ~clear) => {
  <div>
    <div style={ReactDOM.Style.make(~display="flex", ())}>
      <Button label="1" value="1" onClick=gatherValue />
      <Button label="2" value="2" onClick=gatherValue />
      <Button label="3" value="3" onClick=gatherValue />
      <Button label="-" value="-" onClick=gatherValue />
    </div>
    <div style={ReactDOM.Style.make(~display="flex", ())}>
      <Button label="4" value="4" onClick=gatherValue />
      <Button label="5" value="5" onClick=gatherValue />
      <Button label="6" value="6" onClick=gatherValue />
      <Button label="+" value="+" onClick=gatherValue />
    </div>
    <div style={ReactDOM.Style.make(~display="flex", ())}>
      <Button label="7" value="7" onClick=gatherValue />
      <Button label="8" value="8" onClick=gatherValue />
      <Button label="9" value="9" onClick=gatherValue />
      <Button label="*" value="*" onClick=gatherValue />
    </div>
    <div style={ReactDOM.Style.make(~display="flex", ())}>
      <Button label="0" value="0" onClick=gatherValue /> 
      <Button label="C" value="C" onClick=clear />
      <Button label="=" value="=" onClick=compute />
      <Button label="/" value="/" onClick=gatherValue />
    </div>
  </div>
}
