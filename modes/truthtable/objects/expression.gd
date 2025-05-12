class_name OExpression #Expression is used by the godot
extends Token

const OPERATOR_LIST:Array=["("]

#The formula to calculate
var data:Array=[]
var error:String=""
var template_list:Array=[
	Negation.new(),
	Conjunction.new(),
	Disjunction.new(),
	Exclusive_Disjunction.new(),
	Implication.new(),
	Equivalence.new(),
	self,
	Identifier.new()]

#Laskujärjestys

#1. Negaatio
#2. Konjuktion
#3. Disjunktio

func read_tokens_from_string(raw:String) -> bool:
	data.clear()
	if raw.is_empty():
		error="Empty String."
		return false
	var regex:RegEx=RegEx.new()
	regex.compile("\\S+") #Negate all whitespaces..... propaply
	var temp:Array=[]
	for result in regex.search_all(raw):
		temp.append(result.get_string())
	raw="".join(temp)
	var s:String=raw.substr(0)
	
	while not s.is_empty():
		#Attemp to identify:
		var pos:int=0
		var token=null
		for template in template_list:
			pos = template.identify(s)
			if pos > 0:
				token=template.new()
				token.name=s.substr(0, pos)
				token.formula=token.name
				if token is OExpression:
					pos=pos+1
					token.name=token.name.substr(1)
					token.formula=token.name
					if not token.read_tokens_from_string(token.name):
						return false
				break
		if pos <= 0:
			error = "Failed to read \"{0}\"".format([s])
			return false
		add(token)
		s=s.substr(pos)
	return true

func add(token) -> void:
	if token is Identifier or token is Negation or token is Conjunction or token is Disjunction or token is Exclusive_Disjunction or token is Implication or token is Equivalence or token is OExpression:
		data.append(token)
		token.expression=self
		if data.size() > 1:
			token.prev=data[data.size()-2]
			data[data.size()-2].next=token

func rem(token) -> void:
	var pos=data.find(token)
	if pos == -1: return
	data[pos].unlink()
	data.remove_at(pos)
	token.free()
	

func get_identifiers() -> Array:
	var identifiers:Array=[]
	var target=data[0]
	while target != null:
		if target is OExpression:
			identifiers.append_array(target.get_identifiers())
		elif target is Identifier:
			identifiers.append(target)
		target = target.next
	return identifiers

func calculate_identifier_values() -> bool:
	var identifiers:Array=get_identifiers()
	for identifier in identifiers:
		if identifier.next is Identifier:
			error="Identifier cannot be next to another identifier."
			return false
	var doubless_identifiers = remove_double_identifiers(identifiers)
	var count:int=2**doubless_identifiers.size()
	var current_half:int=count/2
	for identifier in doubless_identifiers:
		for i in range(count):
			var value:bool = false if i / current_half % 2 else true
			identifier.values.append(value)
		current_half=current_half/2
	#Update possible doubles:
	for identifier in identifiers:
		for doubless_identifier in doubless_identifiers:
			if identifier.name == doubless_identifier.name:
				if identifier.values.is_empty():
					identifier.values = doubless_identifier.values
	return true

func remove_double_identifiers(identifiers:Array) -> Array:
	var new_array:Array=[]
	for identifier in identifiers:
		var skip:bool=false
		for new in new_array:
			if new.name == identifier.name:
				skip=true
		if not skip:
			new_array.append(identifier)
	return new_array

func get_negatives() -> Array:
	var negatives:Array=[]
	var target=data[0]
	while target != null:
		if target is Negation:
			negatives.append(target)
		target=target.next
	return negatives

func get_conjunctions() -> Array:
	var conjuctions:Array=[]
	var target=data[0]
	while target != null:
		if target is Conjunction:
			conjuctions.append(target)
		target=target.next
	return conjuctions

func get_disjunctions() -> Array:
	var disjunctions:Array=[]
	var target=data[0]
	while target != null:
		if target is Disjunction:
			disjunctions.append(target)
		target=target.next
	return disjunctions

func get_exclusive_disjunctions() -> Array:
	var ex_disjunctions:Array=[]
	var target=data[0]
	while target != null:
		if target is Exclusive_Disjunction:
			ex_disjunctions.append(target)
		target=target.next
	return ex_disjunctions

func get_implications() -> Array:
	var implications:Array=[]
	var target=data[0]
	while target != null:
		if target is Implication:
			implications.append(target)
		target=target.next
	return implications

func get_equivalences() -> Array:
	var equivalences:Array=[]
	var target=data[0]
	while target != null:
		if target is Equivalence:
			equivalences.append(target)
		target=target.next
	return equivalences

func get_expressions() -> Array:
	var expressions:Array=[]
	var target=data[0]
	while target != null:
		if target is OExpression:
			expressions.append(target)
		target=target.next
	return expressions

func calculate_token_values(tokens:Array) -> bool:
	for token in tokens:
		if not token.build_formula():
			return false
		token.build_values()
	return true

func build_formula() -> bool:
	if data.size() != 1:
		error="expression still holds more than 1 member."
		return false
	formula=data[0].formula
	return true

func build_values() -> void:
	#Fix the formula here
	formula = "({0})".format([formula])
	values=data[0].values
	rem(data[0])

func identify(raw:String) -> int:
	if OPERATOR_LIST.has(raw[0]):
		#find the end point
		var count:int=0
		var pos:int=0
		for letter in raw:
			if letter == "(": count+=1
			if letter == ")": count-=1
			if count <= 0: break
			pos+=1
		if count != 0: pos=-1
		return pos
	return 0

func new() -> OExpression:
	return OExpression.new()
