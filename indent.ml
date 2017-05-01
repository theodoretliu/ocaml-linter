let last_word_regexp = Str.regexp "[^' ']*$"

let last_word s = 
  let trim_s = String.trim s in
  let index = Str.search_forward last_word_regexp trim_s 0 in
  String.sub trim_s index (String.length trim_s - index)
