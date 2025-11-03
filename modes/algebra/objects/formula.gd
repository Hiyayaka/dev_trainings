class_name Formula
extends MToken

##Will hold formulas. Must be written in markup format.[br]
##Formulas also may contain sub formulas.

var markup:String = ""

##Stores possible error message.[br]If compiling user input fails, error message is generated.[br]Only 1 Error message per failure. Compilation will stop at after first failure.
var error:String = ""
##Store for all the tokens successfully read from the raw string.
var token_list:Array=[]

##List of all mathematical operations supported by the tool.[br]
##Used when attemping to identify symbols from the raw input in formula.
var template_list:Array=[
	MVariable.new(), #This one will assume that if the symbol is unidentified at this point, it must be a variable.
]

##Interept raw input to MTokens.[br]
##Returns true if success, false if not.[br]
##If false is return, error message is set.
func read_tokens_from_string(raw:String) -> bool:
	#First we need to remove whitespaces from the string.
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

	#Attemp to identify raw input from s:
	while not s.is_empty():
		#Track the relative position of s string.
		var pos:int=0
		var mtoken=null
		
		for template in template_list:
			pos = template.identify(s)
			#Check for match
			if pos > 0: 
				mtoken=template.copy()
				template.clear()

		if pos <= 0:
			error="Failed to read: {0}".format([s])
			return false
		#Add token to token_list.
		add(mtoken)
		#Move next possible token on raw input.
		s=s.substr(pos)
	return true

func add(token:MToken):
	token_list.append(token)
	token.owned_by=self
	if token_list.size() > 1:
		token.prev=token_list[token_list.size()-2]
		token_list[token_list.size()-2].next=token
