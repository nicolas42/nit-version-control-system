rebol []

do %nit.r 

try-to: func [ arg ] [
	attempt [ set/any 'e try arg ] 
	if error? get/any 'e [ e: disarm e ] 
	if unset? get/any 'e [ e: "" ]
    print e
]


insert-all: func [ a b ] [
    forall a [ a/1: head insert a/1 b ]
    a: head a
    return a
]


gui-update: has [ dir ] [  

    f/data: append copy [ %.. ] read what-dir
    f/sn: 0 
    f/sld/data: 0 
    f/update 
    show f 

    s/data: sort/reverse read dir: %.nit/states/
    insert-all s/data dir
    show s 

]

gui-init: does [ 
    s/data: sort/reverse read dir: %.nit/states/
    insert-all s/data dir
	s/picked: reduce [ s/data/1 ] 
    show s 

    f/data: append copy [ %.. ] read what-dir
	f/picked: reduce [ f/data/1 ] 
	show f

	t/text: read f/picked/1
	show t
]

gui-revert: does [
	revert-to s/picked/1
]

gui-do-file: func [ value ] [
    if dir? a: to-file value [ try-to [ change-dir a gui-update ] ]
	t/text: read f/picked/1
	show t
]

view layout compose [ 

	across
    s: text-list  400x800 [  gui-revert gui-update ] 
	f: text-list 400x800 [ gui-do-file value gui-update ]
	t: area 800x800
	return
	button "revert" [ gui-revert gui-update ] 
	button "commit" #"^s" [ commit gui-update ]
    button "halt" #"^[" [ halt ]

	do [ gui-init gui-update ]	
]

