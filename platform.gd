extends StaticBody2D

var object_x = null
var object_y = null
var object_z = null
var object_a = null
var object_xx = null
var object_yy = null
var object_zz = null
var object_aa = null

func _ready():
	# Connecter les signaux
	$Area2D.body_entered.connect(_on_player_entered)
	$Area2D.body_exited.connect(_on_player_exited)
	
	# Rendre platform2 invisible
	$platform2.modulate.a = 0.0
	
	object_x = get_node_or_null("../../../Main/brokenfountain")
	object_y = get_node_or_null("../../../Main/brokenhouse1")
	object_z = get_node_or_null("../../../Main/brokenhouse2")
	object_a = get_node_or_null("../../../Main/brokenhouse3")
	object_xx = get_node_or_null("../../../Main/Maison6")
	object_yy = get_node_or_null("../../../Main/Maison7")
	object_zz = get_node_or_null("../../../Main/Maison8")
	object_aa = get_node_or_null("../../../Main/Maison9")
	
	if object_x:
		print("✅ Objet X trouvé")
	if object_y:
		print("✅ Objet Y trouvé")
	if object_z:
		print("✅ Objet Z trouvé")
	if object_a:
		print("✅ Objet A trouvé")
		
	if object_xx:
		print("✅ Objet XX trouvé")
	if object_yy:
		print("✅ Objet YY trouvé")
	if object_zz:
		print("✅ Objet ZZ trouvé")
	if object_aa:
		print("✅ Objet AA trouvé")

func _on_player_entered(body):
	print("👤 Body entré : ", body.name)
	if body.name == "Player":
		print("✅✅✅ PLAYER DÉTECTÉ SUR PLATFORM !")
		body.sur_platform = true
		print("sur_platform mis à : ", body.sur_platform)

func _on_player_exited(body):
	print("👤 Body sorti : ", body.name)
	if body.name == "Player":
		print("❌❌❌ PLAYER QUITTE PLATFORM !")
		body.sur_platform = false
