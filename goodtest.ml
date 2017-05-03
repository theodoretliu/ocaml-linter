let nlist n =
	let rec nlist' n acc =
		if n <= 0 then acc
		else nlist' (n - 1) (n :: acc)
	in nlist' n []
;;

let y = ("Shiebs", "Sam", "Gabbi") in
let (_, _, x) = y
