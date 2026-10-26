class_name MonsterElement
enum Element {
NONE, 
AIR, 
EARTH,  
METAL, 
PLANT, 
SHADOW, 
SNOW,
SPARK, 
WATER}

enum Effectiveness {
	NEUTRAL,
	WEAK,
	STRONG,
	IMMUNE
}

const DAMAGE_MODIFIER_BY_EFFECT: Dictionary[Effectiveness, float] = {
	Effectiveness.NEUTRAL: 1.0,
	Effectiveness.WEAK: 0.5,
	Effectiveness.STRONG: 2.0,
	Effectiveness.IMMUNE: 0.0
}

const EFFECTIVENESS_BY_ELEMENT: Dictionary[Element, Dictionary] = {
	Element.AIR: {
		Element.EARTH: Effectiveness.WEAK,
		Element.SHADOW: Effectiveness.WEAK,
		Element.SPARK: Effectiveness.STRONG
	},
	Element.EARTH: {
		Element.AIR: Effectiveness.STRONG,
		Element.METAL: Effectiveness.WEAK,
		Element.PLANT: Effectiveness.WEAK,
		Element.SPARK: Effectiveness.STRONG,
		Element.WATER: Effectiveness.WEAK
	},
	Element.METAL: {
		Element.EARTH: Effectiveness.STRONG,
		Element.PLANT: Effectiveness.STRONG,
		Element.SHADOW: Effectiveness.STRONG,
		Element.SNOW: Effectiveness.WEAK,
		Element.SPARK: Effectiveness.WEAK,
		Element.WATER: Effectiveness.WEAK
	},
	Element.PLANT: {
		Element.EARTH: Effectiveness.STRONG,
		Element.METAL: Effectiveness.WEAK,
		Element.SHADOW: Effectiveness.WEAK,
		Element.SNOW: Effectiveness.WEAK,
		Element.SPARK: Effectiveness.WEAK,
		Element.WATER: Effectiveness.STRONG
	},
	Element.SHADOW: {
		Element.AIR: Effectiveness.STRONG,
		Element.METAL: Effectiveness.WEAK,
		Element.PLANT: Effectiveness.STRONG,
		Element.SNOW: Effectiveness.WEAK,
		Element.SPARK: Effectiveness.WEAK,
		Element.WATER: Effectiveness.STRONG
	},
	Element.SNOW: {
		Element.METAL: Effectiveness.STRONG,
		Element.PLANT: Effectiveness.STRONG,
		Element.SPARK: Effectiveness.WEAK,
		Element.WATER: Effectiveness.STRONG
	},
	Element.SPARK: {
		Element.AIR: Effectiveness.WEAK,
		Element.EARTH: Effectiveness.IMMUNE,
		Element.METAL: Effectiveness.STRONG,
		Element.PLANT: Effectiveness.STRONG,
		Element.SHADOW: Effectiveness.STRONG,
		Element.SNOW: Effectiveness.STRONG,
		Element.WATER: Effectiveness.WEAK
	},
	Element.WATER: {
		Element.EARTH: Effectiveness.STRONG,
		Element.METAL: Effectiveness.STRONG,
		Element.PLANT: Effectiveness.WEAK,
		Element.SHADOW: Effectiveness.WEAK,
		Element.SNOW: Effectiveness.WEAK,
		Element.SPARK: Effectiveness.STRONG,
	}
}

static func get_element_effectiveness(source_element: Element, target_element: Element):
	if !EFFECTIVENESS_BY_ELEMENT.has(source_element) or !EFFECTIVENESS_BY_ELEMENT[source_element].has(target_element):
		return Effectiveness.NEUTRAL
	return EFFECTIVENESS_BY_ELEMENT[source_element][target_element]

static func get_element_advantage_coefficient(source_element: Element, target_element: Element):
	var effectiveness = get_element_effectiveness(source_element, target_element)
	return DAMAGE_MODIFIER_BY_EFFECT[effectiveness]
