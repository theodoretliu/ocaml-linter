// regex patterns used in abstract syntax trees
var patterns = [
	new RegExp(/(LetIn) \((.*?), (.*?), (.*)\)/), // LetIn binding
	new RegExp(/(Binop) \((.*?), (.*?), (.*)\)/), // Binops
	new RegExp(/(Conditional) \((.*?), (.*?), (.*)\)/), // Condition
	new RegExp(/(Unop) \((.*?), (.*)\)/), // Unops
	new RegExp(/(Fun) \((.*?), (.*)\)/), // Functions
	new RegExp(/(Let) \((.*?), (.*)\)/), // Let binding
	new RegExp(/(LetRec) \((.*?), (.*)\)/), // LetRec binding
	new RegExp(/(LetRecIn) \((.*?), (.*?), (.*)\)/), // LetRecIn binding
	new RegExp(/(Unassigned)/), // temporarily unassigned
	new RegExp(/(App) \((.*?), (.*)\)/), // Function applications
	new RegExp(/(Cons) \((.*?), (.*)\)/), // List Cons
	new RegExp(/(Var "[a-z][a-z A-Z 0-9 _]*")/), // variable references
	new RegExp(/(Int \d+)/), // integers
	new RegExp(/(Float \d+\.?\d*)/), // floats
	new RegExp(/(Bool (true|false))/), // booleans
	new RegExp(/("[a-z][a-z A-Z 0-9 _]*")/), // variable assignments
	new RegExp(/([A-Z]+[a-z A-Z 0-9 _]*)/), // Single word tokens
];

// - : Ex.expr = Expr.LetIn ("x", Expr.Int 2, Expr.Var "x") 
// Parsing an abstract syntax tree string into an object
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
		return {"name": "ERROR. Unable to parse input", children: []};
	}

	return parse(str);
}

// the primary DOM elements used by this file
var input = document.getElementById('parse-input');
var submit = document.getElementById('parse-button');

// command line style history
var inputHistory = [];
var inputIdx = 0
function historyScroll(e) {
    // if down is pressed, go forward in the history if possible
    if (e.which === 40) {
    	if (inputIdx < inputHistory.length - 1) {
    		inputIdx += 1
    		input.value = inputHistory[inputIdx];
    	}
    	else if (inputIdx === inputHistory.length - 1) {
    		input.value = "";
    	}
    }
    // if up arrow key is pressed, go back in the history if possible
    else if (e.which === 38) {
    	if (inputIdx > 0) {
    		input.value = inputHistory[inputIdx];
    		inputIdx -= 1
    	}
    	else if (inputIdx === 0 && inputHistory.length != 0) {
    		input.value = inputHistory[inputIdx];
    	}
    }

	// moving the cursor to the end of text
    setTimeout(function() {
	    if (typeof input.selectionStart == "number") {
	        input.selectionStart = input.selectionEnd = input.value.length;
	    } else if (typeof input.createTextRange != "undefined") {
	        input.focus();
	        var range = input.createTextRange();
	        range.collapse(false);
	        range.select();
	    }
	}, 0);
};
input.addEventListener('keydown', function(e) {
	(e.which == 38 || e.which == 40) && historyScroll(e);
});

// activate the click event when 'Enter' is pressed as well
input.addEventListener('keyup', function(e) {
    e.preventDefault();
    if (e.keyCode == 13) {
        submit.click();
    }
});

var levels = [];
function DFS(node, lvl) {
	if (levels[lvl] == undefined) {
		levels[lvl] = 0;
	}
	levels[lvl] += node.children.length;
	for (var i = 0; i < node.children.length; i++) {
		DFS(node.children[i], lvl + 1);
	}
}

// parse the input and draw the graph
submit.addEventListener('click', function() {
	var result = parseAST(input.value);
	inputHistory.push(input.value);
	inputIdx = inputHistory.length - 1;
	input.value = '';
	document.getElementById('graph').innerHTML = '';
	if (result) {
		// calculating an appropriate height & width for the graph
		levels = [];
		DFS(result, 0);
		var width = Math.max(...levels);
		var depth = levels.length;
		console.log("Width: " + width)
		console.log("Depth: " + depth);
		console.log(result);
		width = Math.max(width, depth/2);
		setupTree(result, 360 + 180*depth, 140 + 100*width);
	} else {
		setupTree({"name": "ERROR. Cannot understand your input"}, 960, 500);
	}
});

/*

- : Ex.expr = Expr.LetIn ("x", Expr.Int 2, Var "x")

*/