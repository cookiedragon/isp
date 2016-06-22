"use strict"

// teilloesung, d.h die zwei gehoeren zusammen
function* teil(constraint, strasse) {
	for (const i of _.range(strasse.length)) {
		yield* teilAnStelle(constraint, i, strasse)
	}
}

// 
function* teilAnStelle(constraint, i, strasse) {
	if (klappt(strasse[i], constraint)) {
		const newStrasse = _.cloneDeep(strasse)
		newStrasse[i] = _.assign({}, strasse[i], constraint)
		yield newStrasse
	}
}

// ueberpruefung des constraints fuer das haus
const klappt(haus, constraint) {
	for (const key of Object.keys(constraint)) {
		if (haus[key] && haus[key] !== constraint[key]) {
			return false
		}
	}
	return true
}

// generiere loesung
function* loese(constraints, strasse) {
	if (constraints.length === 0) {
		yield strasse
	} else {
		for (const newStrasse of _.head(constraints)(strasse))
			yield* loese(_.tail(constraints), newStrasse)
	}
}

// unsere fuenf haeuser
const loesung = [{},{},{},{},{}]

// constraints
const einstein = [
	c => teil({person: 'brite', farbe: 'rot'}, c),
	c => teil({person: 'schwede', tier: 'hund'}, c),
	c => teil({person: 'daene', getraenk: 'tee'}, c),
	c => linksVon({farbe: 'gruen'}, {farbe: 'weiss'}, c),
	c => teil({farbe: 'gruen', getraenk: 'kaffee'}, c),
	c => teil({tier: 'vogel', zigarette: 'pallmall'}, c),
	c => mitte({getraenk: 'milch'}, c),
	c => teil({farbe: 'gelb', zigarette: 'dunnhill'}, c),
	c => erster({person: 'norweger'}, c),
	c => neben({zigarette: 'marlboro'}, {tier: 'katze'}, c),
	c => neben({tier: 'pferd'}, {zigarette: 'dunnhill'}, c),
	c => teil({getraenk: 'bier', zigarette: 'winfield'}, c),
	c => neben({person: 'norweger'}, {farbe: 'blau'}, c),
	c => teil({person: 'deutsche', zigarette: 'rothmanns'}, c),
	c => neben({zigarette: 'marlboro'}, {getraenk: 'wasser'}, c),
	c => teil({tier: 'fisch'}, c)
]

// und jetzt mach
console.log(loese(einstein, loesung))

