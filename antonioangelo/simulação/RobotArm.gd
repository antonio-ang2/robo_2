extends Spatial

export(NodePath) var ik_path
var ik
export(NodePath) var camera_node

onready var skeleton = get_node("Armature")
onready var camera = get_node(camera_node)
onready var base_gizmo = get_node("Armature/002-Shoulder2/Spatial/003-Arm2/Spatial2/003-Arm2/BaseGizmo")
onready var x_label = get_node("HUD/CoordPanel/XTitle/XValue")
onready var y_label = get_node("HUD/CoordPanel/YTitle/YValue")
onready var z_label = get_node("HUD/CoordPanel/ZTitle/ZValue")
onready var easingx = get_node("EasingX")
onready var easingy = get_node("EasingY")
onready var easingz = get_node("EasingZ")
onready var pose_editor = get_node("PoseEditor/Panel/MarginContainer/ItemList")

var ultima = {'g':90, 'wa':90, 'wr':90, 'x':100, 'y':100, 'z':100}
var pose_changed = false
var coordenadas = {'r': 0, 'j1': 0, 'j2': 0, 'j3': 0, 'j4': 0}

var x_target = 100
var y_target = 100
var z = 100

var timer = false
var playing = false

var mandatory_keys = ["x", "y", "z", "g", "wa", "wr"]

func _ready():
	ik = get_node(ik_path)
#	marker.hide()
	set_process(true)
	x_target = 50
	y_target = 50
	z = 50
	ik.calcIK(x_target, y_target, z, 90, 90, 90)
	x_target = 100
	y_target = 100
	z = 50
	ik.calcIK(x_target, y_target, z, 90, 90, 90)
	
func _process(delta):
	ik.calcIK(x_target, y_target, z, 90, 90, 90)
	x_label.text = str(int(x_target))
	y_label.text = str(int(y_target))
	z_label.text = str(int(z))
	

func _on_ArmIK_servo_moved(base, shoulder, elbow, wrist, gripper):
	skeleton.set_rotation_degrees(Vector3(0,90-base,0))
	$"Armature/002-Shoulder2".set_rotation_degrees(Vector3(shoulder-90, 0, 0))
	$"Armature/002-Shoulder2/Spatial".set_rotation_degrees(Vector3(elbow-90, 0, 0)) 
	$"Armature/002-Shoulder2/Spatial/003-Arm2/Spatial2".set_rotation_degrees(Vector3(90-wrist, 0, 0))

# PLAY
func _on_Button2_pressed():
	playing = true
	var poses = [ultima]
	print(poses)

	for i in poses.size():
		if poses[i].has_all(mandatory_keys):
			easingx.interpolate_property(self, 'x_target', x_target, poses[i].x, Data.poses.speed, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
			easingy.interpolate_property(self, 'y_target', y_target, poses[i].y, Data.poses.speed, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
			easingz.interpolate_property(self, 'z', z, poses[i].z, Data.poses.speed, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		else:
			print("Error: pose does not have all mandatory keys")
		easingx.start()
		easingy.start()
		easingz.start()
		#pose_editor.select(i)
#		print("x:",x_target)
#		print("y:",y_target)
#		print("z:",z)
		yield(get_tree().create_timer(Data.poses.speed + Data.poses.pause), "timeout")
		#pose_editor.unselect(i)
	playing = false

	#pose_editor.select(pose_selected)

# SAVE button
func _on_Button4_pressed():
	$HUD/FileDialog.set_mode(FileDialog.MODE_SAVE_FILE)
	$HUD/FileDialog.show_modal(true)
	
# LOAD button
func _on_Button3_pressed():
	$HUD/FileDialog.set_mode(FileDialog.MODE_OPEN_FILE)
	$HUD/FileDialog.show_modal(true)

func _on_FileDialog_file_selected(path):
	if $HUD/FileDialog.get_mode() == FileDialog.MODE_OPEN_FILE:
		print("Loading...")
		print(path)
		Data.poses = FileAccess.load(path)

#		print(Data.poses)
		pose_editor.load_data()
	elif $HUD/FileDialog.get_mode() == FileDialog.MODE_SAVE_FILE:
		print("Saving...")
		print(path)
		FileAccess.save(Data.poses, path)

func _on_Timer_timeout():
	$HTTPRequest.request('http://127.0.0.1:5000/position')

func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	var results = json.result.positions[-1]
	coordenadas.r = results.r
	coordenadas.j1 = results.j1
	coordenadas.j2 = results.j2
	coordenadas.j3 = results.j3
	coordenadas.j4 = results.j4
	if(ultima.x != results.x or ultima.y != results.y or ultima.z != results.z):
		ultima.x = results.x
		ultima.y = results.y
		ultima.z = results.z
		pose_changed = true

func _on_requestTimer_timeout():
	$HTTPRequest.request('http://127.0.0.1:5000/position')
