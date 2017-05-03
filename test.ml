let nlist n =
	let rec recursive_helper_nlist number_that_is_int number_accumulator =
		if number_that_is_int <= 0 then number_accumulator
		else recursive_helper_nlist_y (number_that_is_int - 1) (number_that_is_int :: number_accumulator)
	in recursive_helper_nlist' n []
;;

let y = ("Shiebs", "Sam", "Gabbi") in
let x =
	match y with
	| (a, b, c) -> c



let k = x||y
