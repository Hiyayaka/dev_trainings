class_name OExpression #Expression is used by the godot
extends Token
##[OExpression] holds formula that can be interpret to truth table.

const OPERATOR_LIST:Array=["("] ##All possible symbols for [OExpression]

var data:Array=[] ##Storage for [Token]s. Needs to be correct order to function propeply. 
var error:String="" ##Simple error message storage.
var template_list:Array=[ ##List used for looping test trouhgt all of its members.[br]Also used to instance new [Token] inherted types (with corret types)
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

##Attemp to compile user input to [Token]s[br]
##These are stored in [member OExpression.data][br]
func read_tokens_from_string(raw:String) -> bool:
	clear()
	if raw.is_empty():
		error="Empty String."
		return false
#Remove whitespaces.
	var regex:RegEx=RegEx.new()
	regex.compile("\\S+") #Negate all whitespaces..... propaply
	var temp:Array=[]
	for result in regex.search_all(raw):
		temp.append(result.get_string())
	raw="".join(temp)
	var s:String=raw.substr(0)

#Attemp to identify:
	while not s.is_empty():
		var pos:int=0
		var token=null
#Call every operator identyfying function in hopes to find operator in current position.
#Last will be Identifier that accepts almost everything.
		for template in template_list:
			pos = template.identify(s)
			if pos > 0:
#We found match. Create new instance of that type and set it up.
				token=template.new()
				token.name=s.substr(0, pos)
				token.formula=token.name
#OExpression needs to some recursive stuff. So we will call this function again for bracers.
				if token is OExpression:
					pos=pos+1
					token.name=token.name.substr(1)
					token.formula=token.name
					if not token.read_tokens_from_string(token.name):
						return false
				break# exit from template identifying procress
#No match. Error in input exit.
		if pos <= 0:
			error = "Failed to read \"{0}\"".format([s])
			return false
#Add new token to list
		add(token)
#Move forward in raw input.
		s=s.substr(pos)
	return true

##add new [Token] to [member OExpression.data].[br]
func add(token) -> void:
	if token is Identifier or token is Negation or token is Conjunction or token is Disjunction or token is Exclusive_Disjunction or token is Implication or token is Equivalence or token is OExpression:
		data.append(token)
		token.expression=self
		if data.size() > 1:
			token.prev=data[data.size()-2]
			data[data.size()-2].next=token

##Removes (free's) [Token] from [member OExpression.data].[br]
func rem(token) -> void:
	var pos=data.find(token)
	if pos == -1: return
	data[pos].unlink()
	data.remove_at(pos)
	token.free()

##Return all [Identifier]s in this [OExpression] and all possible sub [OExpression].
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

##Calculates starting values to [Identifier]s found from this [OExpression] and all sub ones too.
##[Identifier] values are calculated so that every row on truth table will have unique values in row.
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

##Leaves only unique [Identifier]'s to a list.
func remove_double_identifiers(identifiers:Array) -> Array:
	var new_array:Array=[]
	for identifier in identifiers:
		var skip:bool=false
		for target in new_array:
			if target.name == identifier.name:
				skip=true
		if not skip:
			new_array.append(identifier)
	return new_array

#Apparently gdscript dont have ability to pass class names as arguments, so copypaste method it is then:

#Pulls all operators expect ones found from ignore
func get_all_operators(ignore:Array=[]) -> Array:
	var tokens:Array=[]
	var target=data[0]
	while target != null:
		if target is Operator and not target.get_class_name() in ignore:
			tokens.append(target)
		target=target.next
	return tokens

##Returns all [Negation]'s from this [OExpression] but no sub ones.
func get_negatives() -> Array:
	var negatives:Array=[]
	var target=data[0]
	while target != null:
		if target is Negation:
			negatives.append(target)
		target=target.next
	return negatives

##Returns all [Conjuction]'s from this [OExpression] but no sub ones.
func get_conjunctions() -> Array:
	var conjuctions:Array=[]
	var target=data[0]
	while target != null:
		if target is Conjunction:
			conjuctions.append(target)
		target=target.next
	return conjuctions

##Returns all [Disjunction]'s from this [OExpression] but no sub ones.
func get_disjunctions() -> Array:
	var disjunctions:Array=[]
	var target=data[0]
	while target != null:
		if target is Disjunction:
			disjunctions.append(target)
		target=target.next
	return disjunctions

##Returns all [Exclusive_Disjunction]'s from this [OExpression] but no sub ones.
func get_exclusive_disjunctions() -> Array:
	var ex_disjunctions:Array=[]
	var target=data[0]
	while target != null:
		if target is Exclusive_Disjunction:
			ex_disjunctions.append(target)
		target=target.next
	return ex_disjunctions

##Returns all [Implication]'s from this [OExpression] but no sub ones.
func get_implications() -> Array:
	var implications:Array=[]
	var target=data[0]
	while target != null:
		if target is Implication:
			implications.append(target)
		target=target.next
	return implications

##Returns all [Equivalence]'s from this [OExpression] but no sub ones.
func get_equivalences() -> Array:
	var equivalences:Array=[]
	var target=data[0]
	while target != null:
		if target is Equivalence:
			equivalences.append(target)
		target=target.next
	return equivalences

##Returns all [OExpression]'s from this [OExpression] but no sub ones.
func get_expressions() -> Array:
	var expressions:Array=[]
	var target=data[0]
	while target != null:
		if target is OExpression:
			expressions.append(target)
		target=target.next
	return expressions

##Does error check ([method Token.check]), builds formula ([method Token.build_formula]) and calculates values ([method Token.build_values])[br]
##Returns true/false debending on [method Token.check]
func calculate_token_value(token) -> bool:
	var answer=token.check(token.get_class_name())
	if not answer[0]:
		error=answer[1]
		return false
	token.build_formula()
	token.build_values()
	return true

##Builds [member Token.formula] for this [OExpression]
func build_formula() -> bool:
	if data.size() != 1:
		error="expression still holds more than 1 member."
		return false
	formula=data[0].formula
	return true

##Calculates values from other [Token]s what are involed.
func build_values() -> void:
	#Fix the formula here
	formula = "({0})".format([formula])
	values=data[0].values
	rem(data[0])

##Identifies 1 [OExpression] from the stream
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

##Clears the [OExpression] and free's tokens memory allocation.
##If includes sub [OExpression], it will also free everything in it + itself.
func clear():
	error=""
	name=""
	formula=""
	values.clear()
	while data.size() > 0:
#Data may have 2x of same elements in it. removing it will leave null value anywhere else also.
		if !data[0]:
			data.pop_front()
			continue
		if data[0] is OExpression:
			data[0].clear()
			var token=data.pop_front()
			token.free()
		else:
			var token = data.pop_front()
			token.free()

##Creates [member Token.formula] from content of the [member OExpression.data]
func create_formula(add_braces:bool=false):
	for token in data:
		if token is OExpression:
			formula="{old} {token}".format({"old":formula, "token":token.formula})
		else:
			formula="{old} {token}".format({"old":formula, "token":token.name})
	if add_braces:
		formula="({0})".format([formula])

##Gives new instance of [OExpression]
func new() -> OExpression:
	return OExpression.new()

func get_class_name() -> String:
	return "OExpression"

##Ignore this one. Overwrites [Token] one. Returns true every time.
func check(_class_name:String) -> Array:
	return [true]
	
