let foo = [1,2,3]
let x = foo->Belt.Array.get(-1) -> Belt.Option.getWithDefault(9)
Js.log2("result: ", x)
