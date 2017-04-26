var treeData = [
  {
    name: "Top Level",
    children: [
      {
        name: "Level 2: A",
        children: [
          {
            name: "Son of A",
          },
          {
            name: "Daughter of A",
          }
        ]
      },
      {
        name: "Level 2: B",
      }
    ]
  }
]

var patterns = [
	new RegExp(/(LetIn) \((.*?), (.*?), (.*?)\)/), // LetIn binding
	new RegExp(/(Var "[a-z][a-z A-Z 0-9 _]*?")/), // variable references
	new RegExp(/("[a-z][a-z A-Z 0-9 _]*?")/), // variable assignments
	new RegExp(/(Int \d+?)/), // integers
];
/*
a = patterns[0];
b = patterns[1];
c = patterns[2];
d = patterns[3];
*/
// - : Ex.expr = Expr.LetIn ("x", Expr.Int 2, Expr.Var "x") 
function parseAST(str) {
	if (str == '') {
		return undefined;
	}

	// removing everything to the left of the equal sign if present
	var match = str.match(/(- : Ex\.expr =)(.*)/);
	if (match) {
		str = match[2].trim();
	}

	// removing "Expr." from everything
	str = str.replace(/Expr\./g, '').trim();

	console.log(str);
	// pattern matching!

	// LetIn ("x", Int 2, Var "x")
	function parse(str) {
		str = str.trim();
		if (!str) {
			return null;
		}
		for (var i = 0; i < patterns.length; i++) {
			if (patterns[i].test(str)) {
				var match = str.match(patterns[i]);
				console.log(str + " : " + match[1]);
				var newObj = {
					name: match[1],
					children: []
				};
				for (var j = 2; j < match.length; j++) {
					var child = parse(match[j]);
					if (child) {
						newObj.children.push(child);
					}
				}
				return newObj;
			}
		}
		return {"name": "ERROR. Unable to parse input"};
	}

	return parse(str);
}

document.getElementById('parse-input').addEventListener('keyup', function(e) {
    e.preventDefault();
    if (e.keyCode == 13) {
        document.getElementById('parse-button').click();
    }
});

document.getElementById('parse-button').addEventListener('click', function() {
	var input = document.getElementById('parse-input').value;
	var result = parseAST(input);
	document.getElementById('graph').innerHTML = '';
	resetTree();
	if (result) {
		console.log(result);
		setupTree(result);
	} else {
		setupTree({"name": "ERROR. Cannot understand your input"});
	}
});

