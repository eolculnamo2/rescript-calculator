exception IndexUnaccountedFor
module Array = {
let insertAtIndex = (arr, index, item) => {
  let newArr = []
    for i in 0 to arr -> Belt.Array.length {
      let _ = newArr -> Js.Array2.push(switch i {
        | n if n < index => arr -> Belt.Array.get(i) -> Belt.Option.getExn
        | n if n == index => item
        | n if n > index => arr -> Belt.Array.get(i - 1)-> Belt.Option.getExn 
        | _ => raise(IndexUnaccountedFor)
      })
    }
    newArr
  }
  let getAndRemove = (arr: array<'a>, index) => {
    let value = arr -> Belt.Array.get(index) 
    switch value {
     | None => None
      | Some(v) => {
        let filtered_arr = arr -> Js.Array2.filteri((_, i) => i != index)
        Some((v, filtered_arr))
      }
    }
  }
} 
