"use strict"

// all the variables
const variables = [
	{ name: 'brite', domain: [1,2,3,4,5], category: 'nationalitaet' },
	{ name: 'daene', domain: [1,2,3,4,5], category: 'nationalitaet' },
	{ name: 'schwede', domain: [1,2,3,4,5], category: 'nationalitaet' },
	{ name: 'norweger', domain: [1,2,3,4,5], category: 'nationalitaet' },
	{ name: 'deutsche', domain: [1,2,3,4,5], category: 'nationalitaet' },
	{ name: 'rot', domain: [1,2,3,4,5], category: 'farbe' },
	{ name: 'gruen', domain: [1,2,3,4,5], category: 'farbe' },
	{ name: 'gelb', domain: [1,2,3,4,5], category: 'farbe' },
	{ name: 'blau', domain: [1,2,3,4,5], category: 'farbe' },
	{ name: 'weiss', domain: [1,2,3,4,5], category: 'farbe' },
	{ name: 'hund', domain: [1,2,3,4,5], category: 'tier' },
	{ name: 'vogel', domain: [1,2,3,4,5], category: 'tier' },
	{ name: 'katze', domain: [1,2,3,4,5], category: 'tier' },
	{ name: 'pferd', domain: [1,2,3,4,5], category: 'tier' },
	{ name: 'fisch', domain: [1,2,3,4,5], category: 'tier' },
	{ name: 'tee', domain: [1,2,3,4,5], category: 'getraenk' },
	{ name: 'kaffee', domain: [1,2,3,4,5], category: 'getraenk' },
	{ name: 'milch', domain: [1,2,3,4,5], category: 'getraenk' },
	{ name: 'bier', domain: [1,2,3,4,5], category: 'getraenk' },
	{ name: 'wasser', domain: [1,2,3,4,5], category: 'getraenk' },
	{ name: 'pallmall', domain: [1,2,3,4,5], category: 'zigarette' },
	{ name: 'dunhill', domain: [1,2,3,4,5], category: 'zigarette' },
	{ name: 'marlboro', domain: [1,2,3,4,5], category: 'zigarette' },
	{ name: 'winfield', domain: [1,2,3,4,5], category: 'zigarette' },
	{ name: 'rothmanns', domain: [1,2,3,4,5], category: 'zigarette' }
]

// unary constraints
const unary = [
	{ x: 'norweger', value: [1] },
	{ x: 'milch', value: [3] }
]

// check by constraint type
const same = (x,y) => x === y

const different = (x,y) => x !== y

const leftto = (x,y) => y - x === 1

const rightto = (x,y) => x - y === 1

const nextto = (x,y) => Math.abs(x-y) === 1

// binary constraints
const binary = [
	{ x: 'brite', y: 'rot', type: same },
	{ x: 'schwede', y: 'hund', type: same },
	{ x: 'daene', y: 'tee', type: same },
	{ x: 'gruen', y: 'weiss', type: leftto },
	{ x: 'gruen', y: 'kaffee', type: same },
	{ x: 'vogel', y: 'pallmall', type: same },
	{ x: 'gelb', y: 'dunhill', type: same },
	{ x: 'marlboro', y: 'katze', type: nextto },
	{ x: 'pferd', y: 'dunhill', type: nextto },
	{ x: 'bier', y: 'winfield', type: same },
	{ x: 'norweger', y: 'blau', type: nextto },
	{ x: 'deutsche', y: 'rothmanns', type: same },
	{ x: 'marlboro', y: 'wasser', type: nextto }
]

// add the constraints in reverse
let rev = []
binary.forEach(c => {
	if (c.x === 'gruen' && c.y === 'weiss') {
		rev.push({ x: c.y, y: c.x, type: rightto})
	} else {
		rev.push({ x: c.y, y: c.x, type: c.type})
	}
})
rev.forEach(c => binary.push(c))

// add all different constraints by categories
const addAllDifferent = function(cat) {
	variables.filter(elem => elem.category === cat)
		.forEach(function(vx,i,arr) {
			arr.forEach(function(vy) {
				if (vx != vy) {
					binary.push({ x: vx.name, y: vy.name, type: different })
				}
			})
		})
}
const categories = ['nationalitaet', 'farbe', 'tier', 'getraenk', 'zigarette']
categories.forEach(addAllDifferent)

///////////////////////////////////////////////////////////

// prune by unary
const prune = (u, x) => {
	x.filter(elem => elem.name === u.x)
		.forEach(elem => elem.domain = u.value)
}

// fill current arc list with arcs to be checked
const addArcs = (arc, arcs, r2) => {
	r2.filter(elem => (elem.x === arc.x || elem.y === arc.x))
		.filter(elem => (elem.x !== arc.y && elem.y !== arc.y))
		.forEach(elem => arcs.push(elem))
	return arcs
}

// select the arc geared for efficiency
const selectArc = (arcs, vars) => {
	return arcs.shift()
}

// sort variables for efficiency
const sortVars = (vars) => {
	let news = vars.filter(elem => elem.domain.length > 1)
		.sort((a, b) => {
			if (a.domain.length > b.domain.length) { return 1}
			if (a.domain.length < b.domain.length) { return -1}
			return 0
		})
		vars.filter(elem => elem.domain.length === 1)
			.forEach(elem => news.push(elem))
		return news
}

// reduce values from the domain of x with the arc
const arc_reduce = (arc, vars) => {
	const x = vars.find(elem => (arc.x === elem.name))
	const y = vars.find(elem => (arc.y === elem.name))
	const newDomain = []
	let change = false
	x.domain.forEach(vx => {
		const some = y.domain.some(vy => arc.type(vx, vy))
		if (some) {
			newDomain.push(vx)
		} else {
			change = true
		}
	})
	x.domain = newDomain
	return change
}

// deep copy array
const deep = (old) => {
	var news = []
	for (var i = 0, len = old.length; i < len; i++) {
		  news[i] = old[i]
	}
	return news
}

// solver:
// x are the variables
// r1 are the unary constraints
// r2 are the binary constraints
const ac3 = (vars, r1, r2) => {
	// prune with unary constraints
	r1.forEach(u => prune(u, vars))
	let arcs = deep(r2)
	let consistent = true
	// while we still have arcs to be checked
	while (arcs.length > 0 && consistent) {
		// select the next arc to be checked
		let arc = selectArc(arcs, vars)
		// if the arc reduced the domain of x
		if (arc_reduce(arc, vars)) {
			// if x is empty
			const x = vars.find(elem => (arc.x === elem.name))
			if (x.domain.length < 1) {
				// oops...
				consistent = false
			} else {
				// add all the other arcs that need to be rechecked
				addArcs(arc, arcs, r2)
			}
		}
	}
	return consistent
}

// we have a solution when no options remain
const solution = (vars) => {
	return !vars.some(v => v.domain.length > 1)
}

// kickstart the solving
const solve = (vars, u, b) => {
	ac3(vars, u, b)
	// as long as we do not have a solution
	while (!solution(vars)) {
		// get most likely variable
		vars = sortVars(vars)
		let curr = vars.shift()
		// assign each value until one fits consistently
		const assigned = curr.domain.find(val => {
			let test = deep(vars)
			test.unshift({ name: curr.name, domain: [val], category: curr.category })
			return ac3(test, u, b)
		})
		vars.unshift({ name: curr.name, domain: [assigned], category: curr.category })
		ac3(vars, u, b)
	}
	return vars
}

///////////////////////////////////////////////////////////

const simple_variables = [
	{ name: 'brite', domain: [1,2], category: 'nationalitaet' },
	{ name: 'schwede', domain: [1,2], category: 'nationalitaet' },
	{ name: 'rot', domain: [1,2], category: 'farbe' },
	{ name: 'gruen', domain: [1,2], category: 'farbe' }
]

const simple_unary = [
	//{ x: 'brite', value: [1] }
]

const simple_binary = [
	{ x: 'brite', y: 'rot', type: same },
	{ x: 'rot', y: 'brite', type: same },
	{ x: 'schwede', y: 'gruen', type: same },
	{ x: 'gruen', y: 'schwede', type: same },
	{ x: 'brite', y: 'schwede', type: different },
	{ x: 'schwede', y: 'brite', type: different },
	{ x: 'rot', y: 'gruen', type: different },
	{ x: 'gruen', y: 'rot', type: different },
]

///////////////////////////////////////////////////////////

const einstein = () => {
	const solution = solve(variables, unary, binary)
	const fish = solution.find(elem => elem.name === 'fisch')
	const fishowner = solution.find(elem => elem.domain[0] === fish.domain[0] && elem.category === 'nationalitaet')
	const pretty = solution.reduce((houses, variable) => { 
		houses[variable['domain']] = houses[variable['domain']] || []
		houses[variable['domain']].push(variable['name'])
		return houses
	}, {})
	console.log(pretty)
	console.log("Wem gehoert der Fisch?")
	console.log("Der Fisch gehoert dem " + fishowner.name)
}

einstein()

