-- Blender importta primary bo X, secondary Z
-- preset save load ta hand e chain koyarsak parmaklar saçmaliyor
-- ayak attctrl den reset yapilinca fk ye geçiyor
-- limb kopyalayinca ustundeki bonelar kayboluyor
-- hub pivotuyla build controller pivotu farkli. Hub pivotu ortaya alinabilir.
-- exract rig'e root bone koyulmali
-- instantskin bone lari secerek yapilmali
-- extractta dont keep blend bones ta create tip bones deyince blendboneların tip leri kalıyor

global rst
global rName = ""
global delNodes
global newLayerControllers
global newLayerHiddenNodes
global newLayerBones
global copytailCheck
global tailsPosArray
global tailOffsets
global targetTM
global copyFingerCheck
global fingersPosArray
global returnArray
global fingerOffsets
global copyHandCheck
global HandFingersArray
global handFingersCount
global toeCheck
global copyCheck
global copiedModule
global limbsPosArray
global limbsWidthArray
global limbsLengthArray
global limbsHeigthArray
global limbOffsets
global upperTwistOffsets
global lowerTwistOffsets
global clavicleParts
global poleArray
global targetArmTM
global mrTail
global mrArm
global mrHand
global mrFinger
global clavicleCheck
global upperTwistBonesCount
global upperTwistBonesPosXArray
global upperTwistBonesWidthArray
global upperTwistBonesLengthArray
global twistOffset
global foreTwistBonesCount
global foreTwistBonesPosXArray
global foreTwistBonesWidthArray
global foreTwistBonesLengthArray
global selectionBoneArray
global FN_rename
global FN_renameRoot
global FN_createPoint
global FN_createCircle
global FN_createRectangle
global FN_createBox_lmt
global FN_createBox
global FN_addHolderAtt
global FN_createRootNode
global FN_createHubBone
global FN_createSpineBones
global FN_createSpine
global FN_deleteClavicle
global FN_addClavicle
global FN_createLimbBones
global FN_createTwistBones
global FN_createMiddle
global FN_deleteMiddle
global FN_changeMiddle
global FN_createChainBone
global FN_createChain
global FN_createFBone
global FN_createFinger
global FN_collectDelNodes
global FN_deleteModule
global FN_copyChain
global FN_pasteChain
global FN_copyFinger
global FN_pasteFinger
global FN_copyHand
global FN_pasteHand
global FN_CopyLimb
global FN_PasteMirrorLimb
global FN_addToLayer
global FN_createLayer
global FN_SELcallback
global instantRigFloater

--- build
global glbHubCtrl
global glbRoot
global glbBuildSCL
global curve_ca
global FN_reset
global FN_build
global FN_buildBox
global FN_addParameters
global FN_rootAttributes
global FN_exportAttributes
global FN_buildRoot
global FN_buildHub
global addChainAttributes
global addChainFKAttributes
global addSpringAttributes
global FN_buildChain
global FN_fingerAttributes
global FN_HandAttributes
global FN_CurveAttributes
global FN_IkAttribtes
global FN_buildArm
global FN_spineAttributes
global FN_buildSpine
global xmlDoc
global FN_copyModule
global recurseSaves
global FN_pasteModule
global recurseLoads
global FN_exportAttributes
global FN_getDeformBones
global FN_instantskin
global fktur = false
global LSW_EnvelopeCallbackFunction
global FN_bake
global deleteAll
global FNdeleteManual
global FNgetDelNodes
global deletedNodeModule = undefined
global delPost = false
global processRoll
global processDelRoll
-- global moduleRow = 1
fn FN_addParameters fnTarget=
(
	holder_att = attributes atts
	(
		Parameters main
		(	
			--reset icin
-- 			_this type:#maxObject
			isFinger type:#boolean default:false
			isFoot type:#boolean default:false -- Zemin üzerinden flip etmesi icin
			isAttCtrl type:#boolean default:false -- attributes reset icin
			isChest type:#boolean default:false -- attributes reset icin
			isIK type:#boolean default:false -- Resette son olarak resetlemek icin
			m3a type:#matrix3
			prnt type:#maxObject
			mrr type:#boolean default:false -- ik/fk match icin
			
			--picker icin
			_name type:#string default:""
			_type type:#integer default:1
			currentModuleCtrl type:#maxObject
-- 			parentModule type:#maxObject
			flipCtrl type:#maxObject
			mrrAxis type:#stringTab tabSize:0 tabSizeVariable:true
			childModules type:#maxObjectTab tabSize:0 tabSizeVariable:true
			hubCtrls type:#maxObjectTab tabSize:0 tabSizeVariable:true
			tailCtrls type:#maxObjectTab tabSize:0 tabSizeVariable:true
			tailSprings type:#maxObjectTab tabSize:0 tabSizeVariable:true
			shoulderCtrl type:#maxObject
			fkCtrls type:#maxObjectTab tabSize:0 tabSizeVariable:true
			ikCtrls type:#maxObjectTab tabSize:0 tabSizeVariable:true
			blendCtrls type:#maxObjectTab tabSize:0 tabSizeVariable:true
			bendCtrls type:#maxObjectTab tabSize:0 tabSizeVariable:true
			handCtrl type:#maxObject
			fingerLists type:#intTab tabSize:0 tabSizeVariable:true -- her parmakta kaç bone oldugu
			fingerCtrls type:#maxObjectTab tabSize:0 tabSizeVariable:true
			spineCtrls type:#maxObjectTab tabSize:0 tabSizeVariable:true
			
-- 			_rollRow type:#integer default:1
-- 			_ctrlRow type:#integer default:1
			
-- 			_root type:#maxObject
			--spring icin
			_overlapDist type:#floattab tabSize:2
-- 			oBones type:#maxObjectTab tabSize:0 tabSizeVariable:true
-- 			oCtrls type:#maxObjectTab tabSize:0 tabSizeVariable:true
		)
	)
	Custattributes.add fnTarget holder_att
)
fn FN_addBoneProperties fnTarget=
(
	holder_att = attributes bone_attributes
	(
		Parameters main
		(
		moduleCtrl type:#maxObject
		isBlendBone type:#boolean default:false
		childG type:#maxObjectTab tabSize:0 tabSizeVariable:true
-- 		refBone type:#maxObjectTab tabSize:0 tabSizeVariable:true
-- 		father type:#maxObjectTab tabSize:0 tabSizeVariable:true
		rigNodes type:#maxObjectTab tabSize:0 tabSizeVariable:true --extracttan sonra kalanlari silmek icin
		)
	)
	Custattributes.add fnTarget holder_att
)
fn charMap fnText=
(
	allowedChars =#("a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","_","0","1","2","3","4","5","6","7","8","9" )
	
	for i=1 to fnText.count do
	( 
		if (findItem allowedChars fnText[i]) == 0 do fnText[i] = "_"
	)
	fnText
)
fn deleteAll=
(
	createDialog processDelRoll style:#(#style_border)
	disableSceneRedraw()
	ay = #()
	for i in objects do
	(
		try(
		if (i.irA != undefined) do append ay i
		)
		catch ()
	)
	with undo off 
	(
		for i in ay do
		(
			delete i
		)
	)
	clearUndoBuffer()
	enableSceneRedraw()
	destroydialog processDelRoll
)
fn FN_reset fn_target=
(
	curve_ca = attributes resetAttributes 
	(
		Rollout Params "Reset Attributes"
		(
			button reset_select "Reset"
			fn FNmrrPlane _node=
			(
				mrrPlane = point cross:false centermarker:false box:false axistripod:false size:20
				mrrPlane.pos = _node.pos + [0,0,-5]
				mrrPlane.rotation.controller = lookat_Constraint ()
				mrrPlane.rotation.controller.lookat_vector_length = 0
				mrrPlane.rotation.controller.target_axis = 0
				mrrPlane.rotation.controller.upnode_axis = 2
				mrrPlane.rotation.controller.StoUP_axis = 2
				mrrPlane.rotation.controller.upnode_world = off
				mrrPlane.rotation.controller.pickUpNode = _node
				mrrPlane.rotation.controller.appendTarget _node 100;
				
				mrrP = point cross:false centermarker:false box:false axistripod:false size:20
				mrrP.transform = mrrPlane.transform
				delete mrrPlane
				mrrP.pos.z += 5
				
				
				mrrP
			)
			
			fn _rstSelected i=
			(
-- 				try
-- 				(
					if i.currentModuleCtrl.node._type==1 then i.transform = i.m3a
					else 
					(
						if i.isAttCtrl do
						(
							i.modifiers[#attributes].uLength = i.modifiers[#attributes].uLengthAct
							i.modifiers[#attributes].lLength = i.modifiers[#attributes].lLengthAct
							i.modifiers[#attributes].tLength = i.modifiers[#attributes].uLength + i.modifiers[#attributes].lLength
							i.modifiers[#attributes].ikfk = 1.0
							i.modifiers[#attributes].fk_AbRel = 0.0
							i.modifiers[#attributes].softIK = 0.0
							i.modifiers[#attributes].ikStretch = 1.0
							i.modifiers[#attributes].poleSnap = 0.0
							i.modifiers[#attributes].squash  = 0.0
							i.modifiers[#attributes].curve  = 0.0
							i.modifiers[#attributes].constant = true
							i.modifiers[#attributes].followU = 0.5
							i.modifiers[#attributes].followM = 0.5
							i.modifiers[#attributes].followL = 0.5
							i.modifiers[#attributes]._scale = 1.0
						)
						if i.isChest do
						(
							i.modifiers[#attributes].cPos = false
							i.modifiers[#attributes].cOrient = 1.0
							i.modifiers[#attributes].cOrientPivot = 0.0
							i.modifiers[#attributes]._tanh = 0.5
							i.modifiers[#attributes].squash = 0.0
							i.modifiers[#attributes].constant = true
							
							i.modifiers[#attributes].spineAttributes.params.cOrient.enabled = true
							i.modifiers[#attributes].spineAttributes.params.cOrientPivot.enabled = true 
						)
						
						if i.isfoot then
						(
							_pivot = FNmrrPlane i.prnt.node
							i.transform = i.m3a*_pivot.transform
							delete _pivot
						)
						else i.transform = i.m3a*i.prnt.node.transform
					)
-- 				)catch()
			)
		
			on reset_select pressed do
				(
					with undo on
					(
						_this = (refs.dependentNodes (refs.dependents this)[1])[1]
						_rstSelected _this
					)
				)
			
		)
	)
	Custattributes.add fn_target.modifiers[#attributes] curve_ca
)
fn mirrorMatrixFn \
axis:"z" 				/*(Axis to mirror over)*/
flip:"z" 				/*(Axis to flip)*/
tm:(matrix3 1) 			/*(Matrix to mirror)*/
pivotTm:(matrix3 1) 	/*(Matrix to mirror around)*/
=						/*By Mike Biddlecombe and Paul Neale.  I'm just ripping it off!*/
(
	fn FetchReflection a =
	(
		case a of
		(
			"x": [-1,1,1]  -- reflect in YZ plane
			"y": [1,-1,1]  --         in ZX plane
			"z": [1,1,-1]  --         in XY plane
			"xy": [-1,-1,1]
			"yz": [1,-1,-1]
			"xz": [-1,1,-1]
			"xyz": [-1,-1,-1]
		)
	)

	aReflection = scalematrix (FetchReflection axis)
	fReflection = scalematrix (FetchReflection flip)

	fReflection * (tm * (inverse pivotTm)) * aReflection * pivotTm
)

fn rst fn_object=
(
Try
	(	
		local CurObj = fn_object

		if classof CurObj.rotation.controller != Rotation_Layer do
			(
				-- freeze rotation		
				CurObj.rotation.controller = Euler_Xyz() 		
				CurObj.rotation.controller.X_Rotation.controller = bezier_float ()
				CurObj.rotation.controller.Y_Rotation.controller = bezier_float ()
				CurObj.rotation.controller.Z_Rotation.controller = bezier_float ()
				CurObj.rotation.controller = Rotation_list() 			
				CurObj.rotation.controller.available.controller = Euler_xyz() 		
				
				/* "Localization on" */  
			
				CurObj.rotation.controller.setname 1 "Zero" 		
				CurObj.rotation.controller.setname 2 "XYZ"		
			
				/* "Localization off" */  
				
				CurObj.rotation.controller.SetActive 2 		
			)
		if classof CurObj.position.controller != Position_Layer do
		(
			-- freeze position
			CurObj.position.controller = Bezier_Position() 			
			CurObj.position.controller = position_list() 			
			CurObj.position.controller.available.controller = Position_XYZ() 	

			/* "Localization on" */  
					
			CurObj.position.controller.setname 1 "Zero" 	
			CurObj.position.controller.setname 2 "XYZ" 			
			
			/* "Localization off" */  
			
			CurObj.position.controller.SetActive 2 		

			-- position to zero
			CurObj.Position.controller[2].x_Position = 0
			CurObj.Position.controller[2].y_Position = 0
			CurObj.Position.controller[2].z_Position = 0
		)
	)	
/* "Localization on" */  

Catch()
	
/* "Localization off" */  	
	
)
fn FN_addHolderAtt fnTarget=
(
	holder_att = attributes holder_attributes
	(
		Parameters main
		(
		rigSectionHolderG type:#integer default:0
		hubHolderG type:#maxObjectTab tabSize:0 tabSizeVariable:true
		hubCheck type:#boolean default:false
		moduleHubHolderG type:#maxObjectTab tabSize:0 tabSizeVariable:true
		chestHolderG type:#maxObjectTab tabSize:0 tabSizeVariable:true
		spineHolderG type:#maxObjectTab tabSize:0 tabSizeVariable:true
		spineEndHolderG type:#maxObjectTab tabSize:0 tabSizeVariable:true
		middleCtrlHolderG type:#maxObjectTab tabSize:0 tabSizeVariable:true
		moduleSpineHolderG type:#maxObjectTab tabSize:0 tabSizeVariable:true
		modulNameHolder type:#string default:""
		middleCheck type:#boolean default:false
		rowHolderG type:#integer default:1
		moduleArmHolderG type:#maxObjectTab tabSize:0 tabSizeVariable:true
		moduleLegHolderG type:#maxObjectTab tabSize:0 tabSizeVariable:true
		armBonesHolderG type:#maxObjectTab tabSize:0 tabSizeVariable:true
		nodeMirror type:#boolean default:false
		clavicleCheck type:#boolean default:true
		clavicleUpHolderG type:#maxObjectTab tabSize:0 tabSizeVariable:true
		twistBoneHolderG type:#maxObjectTab tabSize:0 tabSizeVariable:true
		pPointHolderG type:#maxObjectTab tabSize:0 tabSizeVariable:true
		armPoleHolderG type:#maxObjectTab tabSize:0 tabSizeVariable:true
		legToeHolderG type:#maxObjectTab tabSize:0 tabSizeVariable:true
		isFinger type:#boolean default:false
		fingerBoneHolderG type:#maxObjectTab tabSize:0 tabSizeVariable:true
		fingerBoneCountHolderG type:#integer default:1
		moduleFingerHolderG type:#maxObjectTab tabSize:0 tabSizeVariable:true
		parentPointHolderG type:#maxObjectTab tabSize:0 tabSizeVariable:true
		moduleTailHolderG type:#maxObjectTab tabSize:0 tabSizeVariable:true
		tailBoneHolderG type:#maxObjectTab tabSize:0 tabSizeVariable:true
		chType type:#integer default:2
		rootNodeHolderG type:#maxObjectTab tabSize:0 tabSizeVariable:true
		parentHolderG type:#maxObjectTab tabSize:0 tabSizeVariable:true
		nameHolderG type:#string default:""
		btnEnableG type:#boolTab tabSize:0 tabSizeVariable:true
		rootCheck type:#boolean default:false
		)
	)
	Custattributes.add fnTarget holder_att
)
fn FN_addIR fnTarget= -- demo modu için. Sahnede silinecek nodelari secebilmeyi sagliyor
(
	h_att = attributes irA
	(
		Parameters main
		(
			ir type:#boolean
		)
	)
	Custattributes.add fnTarget h_att
)
fn FN_rename fnTarget=
(
	if fnTarget.moduleTailHolderG.count != 0 then
	(
		for i in fnTarget.moduleTailHolderG do
		(
			parentPoint = i.node
			parentPoint.name = parentPoint.parent.name+"_chainParentPoint" + (parentPoint.rowHolderG as string)
				for b = 1 to parentPoint.tailBoneHolderG.count do
				(
					parentPoint.tailBoneHolderG[b].node.name = parentPoint.parent.name+"_" + parentPoint.modulNameHolder + (b as string)
					FN_rename parentPoint.tailBoneHolderG[b].node
				)
			
		)
	)
	if fnTarget.moduleArmHolderG.count != 0 then
	(
		for i in fnTarget.moduleArmHolderG do
		(
			armParent = i.node.parent
			parentPoint = i.node
			upperArm = i.node.armbonesHolderG[1].node
			foreArm = i.node.armbonesHolderG[2].node
			hand = i.node.armbonesHolderG[3].node
			
			if i.node.armbonesHolderG.count > 3  then clavicle = i.node.armbonesHolderG[4].node
			
			parentPoint.name = armParent.name+"_"+parentPoint.modulNameHolder+"_armPP"
			
			upperArm.name = armParent.name+"_"+parentPoint.modulNameHolder+"_upper"+ "1"
			FN_rename upperArm
			if upperArm.twistBoneHolderG.count != 0 then
				(
					for t = 1 to upperArm.twistBoneHolderG.count do
						(
							parentName = replace upperArm.name upperArm.name.count 1 ""
							upperArm.twistBoneHolderG[t].node.name = parentName + ((t+1) as string)
							FN_rename upperArm.twistBoneHolderG[t].node
						)
				)
			upperArm.pPointHolderG[1].node.name = upperArm.name + "_pP"
			
			foreArm.name = armParent.name+"_"+parentPoint.modulNameHolder+"_lower"+ "1"
			FN_rename foreArm
			if foreArm.twistBoneHolderG.count != 0 then
				(
					for t = 1 to foreArm.twistBoneHolderG.count do
						(
							parentName = replace foreArm.name foreArm.name.count 1 ""
							foreArm.twistBoneHolderG[t].node.name = parentName + ((t+1) as string)
							FN_rename foreArm.twistBoneHolderG[t].node
						)
				)
			foreArm.pPointHolderG[1].node.name = foreArm.name + "_pP"
				
			hand.name = armParent.name+"_"+parentPoint.modulNameHolder+"_hand"
			FN_rename hand
			for i in hand.modulefingerHolderG do
				(
					i.node.name = hand.name+"_fingerPP" + (i.node.rowHolderG as string)
					for b = 1 to i.node.fingerBoneHolderG.count do
					(
						i.node.fingerBoneHolderG[b].node.name = hand.name+"_finger" + (i.node.rowHolderG as string) + (b as string)
						FN_rename i.node.fingerBoneHolderG[b].node
					)
					
				)
				
			if  i.node.armbonesHolderG.count > 3 then 
				(
					clavicle.name = armParent.name+"_"+parentPoint.modulNameHolder+"_clavicle"; FN_rename clavicle
					clavicle.clavicleUpHolderG[1].node.name = clavicle.name + "_upNode"
					clavicle.clavicleUpHolderG[2].node.name = clavicle.clavicleUpHolderG[1].node.name + "_P"
				)
			
			
			parentPoint.armPoleHolderG[1].node.name = armParent.name+"_"+parentPoint.modulNameHolder+"_poleParentPoint"
			parentPoint.armPoleHolderG[2].node.name = armParent.name+"_"+parentPoint.modulNameHolder+"_pole"
			parentPoint.armPoleHolderG[3].node.name = armParent.name+"_"+parentPoint.modulNameHolder+"_poleRefPointUpper"
			parentPoint.armPoleHolderG[4].node.name = armParent.name+"_"+parentPoint.modulNameHolder+"_poleRefPointfore"
			
			
		)
	)
	if fnTarget.moduleLegHolderG.count != 0 then
	(
		for i in fnTarget.moduleLegHolderG do
		(
			armParent = i.node.parent
			parentPoint = i.node
			upperArm = i.node.armbonesHolderG[1].node
			foreArm = i.node.armbonesHolderG[2].node
			hand = i.node.armbonesHolderG[3].node
			toe = i.node.legToeHolderG[1].node
			heel= i.node.legToeHolderG[2].node
			footIK= i.node.legToeHolderG[3].node
			hp=i.node.legToeHolderG[4].node
			
			if i.node.armbonesHolderG.count > 4  then clavicle = i.node.armbonesHolderG[5].node
			
			parentPoint.name = armParent.name+"_"+parentPoint.modulNameHolder+"_legPP"
			
			upperArm.name = armParent.name+"_"+parentPoint.modulNameHolder+"_upper" + "1"
			FN_rename upperArm
			if upperArm.twistBoneHolderG.count != 0 then
				(
					for t = 1 to upperArm.twistBoneHolderG.count do
						(
							parentName = replace upperArm.name upperArm.name.count 1 ""
							upperArm.twistBoneHolderG[t].node.name = parentName + ((t+1) as string)
							FN_rename upperArm.twistBoneHolderG[t].node
						)
				)
			upperArm.pPointHolderG[1].node.name = upperArm.name + "_pP"
			
			foreArm.name = armParent.name+"_"+parentPoint.modulNameHolder+"_lower"+"1"
			FN_rename foreArm
			if foreArm.twistBoneHolderG.count != 0 then
				(
					for t = 1 to foreArm.twistBoneHolderG.count do
						(
							parentName = replace foreArm.name foreArm.name.count 1 ""
							foreArm.twistBoneHolderG[t].node.name = parentName + ((t+1) as string)
							FN_rename foreArm.twistBoneHolderG[t].node
						)
				)
			foreArm.pPointHolderG[1].node.name = foreArm.name + "_pP"
				
			hand.name = armParent.name+"_"+parentPoint.modulNameHolder+"_foot"
			FN_rename hand
			for i in hand.modulefingerHolderG do
				(
					i.node.name = hand.name+"_fingerPP" + (i.node.rowHolderG as string)
					for b = 1 to i.node.fingerBoneHolderG.count do
					(
						i.node.fingerBoneHolderG[b].node.name = hand.name+"_finger" + (i.node.rowHolderG as string) + (b as string)
						FN_rename i.node.fingerBoneHolderG[b].node
					)
					
				)
			
			toe.name = hand.name+"_toe"
			heel.name = hand.name+"_heel"
			hp.name = hand.name+"_heelPoint"
			footIK.name = hand.name+"_footIK"
				
			if  i.node.armbonesHolderG.count > 4 then 
				(
					clavicle.name = armParent.name+"_"+parentPoint.modulNameHolder+"_clavicle"; FN_rename clavicle
					clavicle.clavicleUpHolderG[1].node.name = clavicle.name + "_upNode"
					clavicle.clavicleUpHolderG[2].node.name = clavicle.clavicleUpHolderG[1].node.name + "_P"
				)
			
			
			parentPoint.armPoleHolderG[1].node.name = armParent.name+"_"+parentPoint.modulNameHolder+"_poleParentPoint"
			parentPoint.armPoleHolderG[2].node.name = armParent.name+"_"+parentPoint.modulNameHolder+"_pole"
			parentPoint.armPoleHolderG[3].node.name = armParent.name+"_"+parentPoint.modulNameHolder+"_poleRefPointUpper"
			parentPoint.armPoleHolderG[4].node.name = armParent.name+"_"+parentPoint.modulNameHolder+"_poleRefPointfore"
			
			
		)
	)
	if fnTarget.moduleSpineHolderG.count != 0 then
	(
		for i in fnTarget.moduleSpineHolderG do
		(
			chestParent = i.node.parent
			chestRow = i.node.rowHolderG
			parentPoint = i.node
			chestBone = i.node.chestHolderG[1].node
			parentBone = i.node.spineEndHolderG[1].node
			
			
			try(
			midBone = parentPoint.middleCtrlHolderG[1].node
			midpnt = parentPoint.middleCtrlHolderG[2].node) catch ()
			
			for i = 1 to parentPoint.spineHolderG.count do
			(
				parentPoint.spineHolderG[i].node.name = chestParent.name+"_"+parentPoint.modulNameHolder+"_T"+(i as string)
-- 				if (parentPoint.middleCheck) do parentPoint.spineHolderG[i].node.name = chestParent.name+"_neck"+(chestRow as string)+(i as string)
				FN_rename parentPoint.spineHolderG[i].node
			)
			
			parentPoint.name = chestParent.name+"_"+parentPoint.modulNameHolder+"_pp"--+(chestRow as string)
			chestBone.name = chestParent.name+"_"+parentPoint.modulNameHolder--+(chestRow as string)
			parentBone.name = chestParent.name+"_"+parentPoint.modulNameHolder+"_P"--+(chestRow as string)
-- 			if (parentPoint.middleCheck) do
-- 			(
-- 				parentPoint.name = chestParent.name+"_headParentPoint"+(chestRow as string)
-- 				chestBone.name = chestParent.name+"_head"+(chestRow as string)
-- 				parentBone.name = chestParent.name+"_neckParent"+(chestRow as string)
-- 			)
			try(
			midBone.name = chestBone.name+"_middle"
			midpnt.name = chestBone.name+"_middleParentPoint") catch ()

			FN_rename chestBone
		)
	)
	if fnTarget.moduleHubHolderG.count != 0 then
	(
		for i in fnTarget.moduleHubHolderG do
		(
			i.node.name = rName+"_"+i.node.modulNameHolder+"_pp"
			i.node.hubHolderG[1].node.name = rName+"_"+i.node.modulNameHolder
			FN_rename i.node.hubHolderG[1].node
		)
	)
	
	
	
)
fn FN_renameRoot fnTarget=
(
	parentPoint = fnTarget.parentPointHolderG[1].node
	fnTarget.nameHolderG = rName
	fnTarget.name = rName + "_" + parentPoint.modulNameHolder
	parentPoint.name = rName + "_" + parentPoint.modulNameHolder + "P"
	
	FN_rename fnTarget
)
fn FN_addToLayer fnTarget =
(	
	if fnTarget.moduleTailHolderG.count != 0 then
	(
		for i in fnTarget.moduleTailHolderG do
		(
			newLayerHiddenNodes.addNode i.node
				for b = 1 to i.node.tailBoneHolderG.count do
				(
					newLayerBones.addNode i.node.tailBoneHolderG[b].node
					FN_addToLayer i.node.tailBoneHolderG[b].node
				)
			
		)
	)
	if fnTarget.moduleArmHolderG.count != 0 then
	(
		for i in fnTarget.moduleArmHolderG do
		(
			parentPoint = i.node
			upperArm = i.node.armbonesHolderG[1].node
			foreArm = i.node.armbonesHolderG[2].node
			hand = i.node.armbonesHolderG[3].node
			
			if i.node.armbonesHolderG.count > 3  then clavicle = i.node.armbonesHolderG[4].node
			
			newLayerHiddenNodes.addNode parentPoint
			
			newLayerBones.addNode upperArm
			FN_addToLayer upperArm
			if upperArm.twistBoneHolderG.count != 0 then
				(
					for t = 1 to upperArm.twistBoneHolderG.count do
						(
							newLayerBones.addNode upperArm.twistBoneHolderG[t].node
							FN_addToLayer upperArm.twistBoneHolderG[t].node
						)
				)
			newLayerHiddenNodes.addNode upperArm.pPointHolderG[1].node
			
			newLayerBones.addNode foreArm
			FN_addToLayer foreArm
			if foreArm.twistBoneHolderG.count != 0 then
				(
					for t = 1 to foreArm.twistBoneHolderG.count do
						(
							newLayerBones.addNode foreArm.twistBoneHolderG[t].node
							FN_addToLayer foreArm.twistBoneHolderG[t].node
						)
				)
			newLayerHiddenNodes.addNode foreArm.pPointHolderG[1].node
				
			newLayerBones.addNode hand
			FN_addToLayer hand
			for i in hand.modulefingerHolderG do
				(
					newLayerHiddenNodes.addNode i.node
					for b = 1 to i.node.fingerBoneHolderG.count do
					(
						newLayerBones.addNode i.node.fingerBoneHolderG[b].node
						FN_addToLayer i.node.fingerBoneHolderG[b].node
					)
					
				)
				
			if  i.node.armbonesHolderG.count > 3 then 
				(
					newLayerBones.addNode clavicle
					newLayerBones.addNode clavicle.clavicleUpHolderG[1].node
					newLayerHiddenNodes.addNode clavicle.clavicleUpHolderG[2].node
					FN_addToLayer clavicle
				)
			
			
			newLayerHiddenNodes.addNode parentPoint.armPoleHolderG[1].node
			newLayerBones.addNode parentPoint.armPoleHolderG[2].node
			newLayerHiddenNodes.addNode parentPoint.armPoleHolderG[3].node
			newLayerHiddenNodes.addNode parentPoint.armPoleHolderG[4].node
			
			
		)
	)
	if fnTarget.moduleLegHolderG.count != 0 then
	(
		for i in fnTarget.moduleLegHolderG do
		(
			parentPoint = i.node
			upperArm = i.node.armbonesHolderG[1].node
			foreArm = i.node.armbonesHolderG[2].node
			hand = i.node.armbonesHolderG[3].node
			
			if i.node.armbonesHolderG.count > 4  then clavicle = i.node.armbonesHolderG[5].node
			
			newLayerHiddenNodes.addNode parentPoint
			
			newLayerBones.addNode upperArm
			FN_addToLayer upperArm
			if upperArm.twistBoneHolderG.count != 0 then
				(
					for t = 1 to upperArm.twistBoneHolderG.count do
						(
							newLayerBones.addNode upperArm.twistBoneHolderG[t].node
							FN_addToLayer upperArm.twistBoneHolderG[t].node
						)
				)
			newLayerHiddenNodes.addNode upperArm.pPointHolderG[1].node
			
			newLayerBones.addNode foreArm
			FN_addToLayer foreArm
			if foreArm.twistBoneHolderG.count != 0 then
				(
					for t = 1 to foreArm.twistBoneHolderG.count do
						(
							newLayerBones.addNode foreArm.twistBoneHolderG[t].node
							FN_addToLayer foreArm.twistBoneHolderG[t].node
						)
				)
			newLayerHiddenNodes.addNode foreArm.pPointHolderG[1].node
				
			newLayerBones.addNode hand
			FN_addToLayer hand
			for i in hand.modulefingerHolderG do
				(
					newLayerHiddenNodes.addNode i.node
					for b = 1 to i.node.fingerBoneHolderG.count do
					(
						newLayerBones.addNode i.node.fingerBoneHolderG[b].node
						FN_addToLayer i.node.fingerBoneHolderG[b].node
					)
					
				)
			
-- 				for t in i.node.legToeHolderG do newLayerBones.addNode t.node
				newLayerBones.addNode i.node.legToeHolderG[1].node
				newLayerBones.addNode i.node.legToeHolderG[2].node
				newLayerControllers.addNode i.node.legToeHolderG[3].node
				newLayerHiddenNodes.addNode i.node.legToeHolderG[4].node
				
			if  i.node.armbonesHolderG.count > 4 then 
				(
					newLayerBones.addNode clavicle 
					FN_addToLayer clavicle
					newLayerBones.addNode clavicle.clavicleUpHolderG[1].node
					newLayerHiddenNodes.addNode clavicle.clavicleUpHolderG[2].node
				)
			
			
			newLayerHiddenNodes.addNode parentPoint.armPoleHolderG[1].node
			newLayerBones.addNode parentPoint.armPoleHolderG[2].node
			newLayerHiddenNodes.addNode parentPoint.armPoleHolderG[3].node
			newLayerHiddenNodes.addNode parentPoint.armPoleHolderG[4].node
		)
	)
	if fnTarget.moduleSpineHolderG.count != 0 then
	(
		for i in fnTarget.moduleSpineHolderG do
		(
			parentPoint = i.node
			chestBone = i.node.chestHolderG[1].node
			parentBone = i.node.spineEndHolderG[1].node
			
			try(
			midBone = parentPoint.middleCtrlHolderG[1].node;
			midpnt = parentPoint.middleCtrlHolderG[2].node;) catch ()
			
			for i = 1 to parentPoint.spineHolderG.count do
			(
				newLayerBones.addNode parentPoint.spineHolderG[i].node
				FN_addToLayer parentPoint.spineHolderG[i].node
			)
			newLayerHiddenNodes.addNode parentPoint
			newLayerBones.addNode chestBone
			newLayerBones.addNode parentBone
			try(
			newLayerBones.addNode midBone
			newLayerHiddenNodes.addNode midpnt) catch()
			FN_addToLayer chestBone
		)
	)
	if fnTarget.moduleHubHolderG.count != 0 then
	(
		for i in fnTarget.moduleHubHolderG do
		(
			newLayerHiddenNodes.addNode i.node
			newLayerBones.addNode i.node.hubHolderG[1].node
			FN_addToLayer i.node.hubHolderG[1].node
		)
	)
	
	
	
)
fn FN_createLayer fnTarget = -- rootnode ve direk isim olarak girecek
(
	parentPoint = fnTarget.parentPointHolderG[1].node
	
	newLayerName = rName + "_controllers"
	newLayerControllers = LayerManager.getLayerFromName newLayerName
	if newLayerControllers == undefined then newLayerControllers = LayerManager.newLayerFromName newLayerName
	
	newLayerName = rName + "_hiddenNodes"
	newLayerHiddenNodes = LayerManager.getLayerFromName newLayerName
	if newLayerHiddenNodes == undefined then newLayerHiddenNodes = LayerManager.newLayerFromName newLayerName
	newLayerHiddenNodes.ishidden = true
	
	newLayerName = rName + "_bones"
	newLayerBones = LayerManager.getLayerFromName newLayerName
	if newLayerBones == undefined then newLayerBones = LayerManager.newLayerFromName newLayerName

	newLayerHiddenNodes.addNode parentPoint
	newLayerControllers.addNode fnTarget
-- 	
	FN_addToLayer fnTarget
		
)
fn FN_collectDelNodes fnTarget fnArray=
(	
	if fnTarget.moduleTailHolderG.count != 0 then
	(
		for i in fnTarget.moduleTailHolderG do
			(
				parentPoint = i.node
				for b = 1 to parentPoint.tailBoneHolderG.count do
				(
					FN_collectDelNodes parentPoint.tailBoneHolderG[b].node delNodes
					append fnArray parentPoint.tailBoneHolderG[b].node
				)
				append fnArray parentPoint
			)
	)
	if fnTarget.moduleArmHolderG.count != 0 then
	(
		for i in fnTarget.moduleArmHolderG do
		(
			parentPoint = i.node
			upperArm = i.node.armbonesHolderG[1].node
			foreArm = i.node.armbonesHolderG[2].node
			hand = i.node.armbonesHolderG[3].node
			if i.node.armbonesHolderG.count > 3  then (clavicle = i.node.armbonesHolderG[4].node;)
			
			append fnArray parentPoint.armPoleHolderG[1].node
			append fnArray parentPoint.armPoleHolderG[2].node
			append fnArray parentPoint.armPoleHolderG[3].node
			append fnArray parentPoint.armPoleHolderG[4].node
			
			for i in hand.modulefingerHolderG do
				(
					for b = 1 to i.node.fingerBoneHolderG.count do
					(
						FN_collectDelNodes i.node.fingerBoneHolderG[b].node delNodes
						append fnArray i.node.fingerBoneHolderG[b].node
					)
					append fnArray i.node
				)
			FN_collectDelNodes hand delNodes
			append fnArray hand
			
			if foreArm.twistBoneHolderG.count != 0 then
				(
					for t = 1 to foreArm.twistBoneHolderG.count do
						(
							FN_collectDelNodes foreArm.twistBoneHolderG[t].node delNodes
							append fnArray foreArm.twistBoneHolderG[t].node
						)
				)
			append fnArray foreArm.pPointHolderG[1].node
			FN_collectDelNodes foreArm delNodes
			append fnArray foreArm
			
			if upperArm.twistBoneHolderG.count != 0 then
				(
					for t = 1 to upperArm.twistBoneHolderG.count do
						(
							FN_collectDelNodes upperArm.twistBoneHolderG[t].node delNodes
							append fnArray upperArm.twistBoneHolderG[t].node
						)
				)
			append fnArray upperArm.pPointHolderG[1].node
			FN_collectDelNodes upperArm delNodes
			append fnArray upperArm
				
			if i.node.armbonesHolderG.count > 3  then (FN_collectDelNodes clavicle delNodes; append fnArray clavicle.clavicleUpHolderG[1].node; append fnArray clavicle.clavicleUpHolderG[2].node; append fnArray clavicle;)
				
			append fnArray parentPoint
		)
	)
	if fnTarget.moduleLegHolderG.count != 0 then
	(
		for i in fnTarget.moduleLegHolderG do
		(
			parentPoint = i.node
			upperArm = i.node.armbonesHolderG[1].node
			foreArm = i.node.armbonesHolderG[2].node
			hand = i.node.armbonesHolderG[3].node
			toe = i.node.armbonesHolderG[4].node
			if i.node.armbonesHolderG.count > 4  then (clavicle = i.node.armbonesHolderG[5].node;)
			
			append fnArray parentPoint.armPoleHolderG[1].node
			append fnArray parentPoint.armPoleHolderG[2].node
			append fnArray parentPoint.armPoleHolderG[3].node
			append fnArray parentPoint.armPoleHolderG[4].node
			
			for i in hand.modulefingerHolderG do
				(
					for b = 1 to i.node.fingerBoneHolderG.count do
					(
						FN_collectDelNodes i.node.fingerBoneHolderG[b].node delNodes
						append fnArray i.node.fingerBoneHolderG[b].node
					)
					append fnArray i.node
				)
			FN_collectDelNodes toe delNodes
			-- append, toe, heel, ikfoot and other points
			for t in i.node.legToeHolderG do append delNodes t.node
			FN_collectDelNodes hand delNodes
			append fnArray hand
			
			if foreArm.twistBoneHolderG.count != 0 then
				(
					for t = 1 to foreArm.twistBoneHolderG.count do
						(
							FN_collectDelNodes foreArm.twistBoneHolderG[t].node delNodes
							append fnArray foreArm.twistBoneHolderG[t].node
						)
				)
			append fnArray foreArm.pPointHolderG[1].node
			FN_collectDelNodes foreArm delNodes
			append fnArray foreArm
			
			if upperArm.twistBoneHolderG.count != 0 then
				(
					for t = 1 to upperArm.twistBoneHolderG.count do
						(
							FN_collectDelNodes upperArm.twistBoneHolderG[t].node delNodes
							append fnArray upperArm.twistBoneHolderG[t].node
						)
				)
			append fnArray upperArm.pPointHolderG[1].node
			FN_collectDelNodes upperArm delNodes
			append fnArray upperArm
				
			if i.node.armbonesHolderG.count > 4  then (FN_collectDelNodes clavicle delNodes; append fnArray clavicle.clavicleUpHolderG[1].node; append fnArray clavicle.clavicleUpHolderG[2].node; append fnArray clavicle;)
				
			append fnArray parentPoint
		)
	)

	if fnTarget.moduleSpineHolderG.count != 0 then
	(
		for i in fnTarget.moduleSpineHolderG do
		(
			parentPoint = i.node
			chestBone = i.node.chestHolderG[1].node
			parentBone = i.node.spineEndHolderG[1].node
			
			for i = 1 to parentPoint.spineHolderG.count do
			(
				FN_collectDelNodes parentPoint.spineHolderG[i].node delNodes
				append fnArray parentPoint.spineHolderG[i].node
			)
			try (FN_deleteMiddle chestBone) catch ()
			FN_collectDelNodes chestBone delNodes
			append fnArray chestBone
			append fnArray parentPoint
			append fnArray parentBone
		)
	)
	if fnTarget.moduleHubHolderG.count != 0 then
	(
		for i in fnTarget.moduleHubHolderG do
			(
				parentPoint = i.node
				FN_collectDelNodes parentPoint.hubHolderG[1].node delNodes
				append fnArray parentPoint.hubHolderG[1].node
				append fnArray parentPoint
			)
	)
	
	fnArray
	
)
fn FN_deleteModule fnTarget =
(
	if fnTarget.rootCheck then
	(
		FN_collectDelNodes fnTarget.rootNodeHolderG[1].node delNodes
		append delNodes fnTarget.RootNodeHolderG[1].node
	)
	if fnTarget.tailBoneHolderG.count != 0 then
	(
		for b = 1 to fnTarget.tailBoneHolderG.count do
		(
			FN_collectDelNodes fnTarget.tailBoneHolderG[b].node delNodes
			append delNodes fnTarget.tailBoneHolderG[b].node
		)
		
		deleteItem fnTarget.parentHolderG[1].node.moduleTailHolderG fnTarget.rowHolderG
		if fnTarget.parentHolderG[1].node.moduleTailHolderG.count != 0 then
		(
			for i =1 to fnTarget.parentHolderG[1].node.moduleTailHolderG.count do
				(
					fnTarget.parentHolderG[1].node.moduleTailHolderG[i].node.rowHolderG = i
				)
		)
	)
	if (fnTarget.armBonesHolderG.count != 0 and fnTarget.legToeHolderG.count == 0) then
	(
		upperArm = fnTarget.armbonesHolderG[1].node
		foreArm = fnTarget.armbonesHolderG[2].node
		hand = fnTarget.armbonesHolderG[3].node
		if fnTarget.armbonesHolderG.count > 3  then (clavicle = fnTarget.armbonesHolderG[4].node;)
		
		append delNodes fnTarget.armPoleHolderG[1].node
		append delNodes fnTarget.armPoleHolderG[2].node
		append delNodes fnTarget.armPoleHolderG[3].node
		append delNodes fnTarget.armPoleHolderG[4].node
		
		for i in hand.modulefingerHolderG do
			(
				for b = 1 to i.node.fingerBoneHolderG.count do
				(
					FN_collectDelNodes i.node.fingerBoneHolderG[b].node delNodes
					append delNodes i.node.fingerBoneHolderG[b].node
				)
				append delNodes i.node
			)
		FN_collectDelNodes hand delNodes
		append delNodes hand
		
		if foreArm.twistBoneHolderG.count != 0 then
			(
				for t = 1 to foreArm.twistBoneHolderG.count do
					(
						FN_collectDelNodes foreArm.twistBoneHolderG[t].node delNodes
						append delNodes foreArm.twistBoneHolderG[t].node
					)
			)
		append delNodes foreArm.pPointHolderG[1].node
		FN_collectDelNodes foreArm delNodes
		append delNodes foreArm
		
		if upperArm.twistBoneHolderG.count != 0 then
			(
				for t = 1 to upperArm.twistBoneHolderG.count do
					(
						FN_collectDelNodes upperArm.twistBoneHolderG[t].node delNodes
						append delNodes upperArm.twistBoneHolderG[t].node
					)
			)
		append delNodes upperArm.pPointHolderG[1].node
		FN_collectDelNodes upperArm delNodes
		append delNodes upperArm
			
		if fnTarget.armbonesHolderG.count > 3  then (FN_collectDelNodes clavicle delNodes; append delNodes clavicle.clavicleUpHolderG[1].node; append delNodes clavicle.clavicleUpHolderG[2].node; append delNodes clavicle;)
			
		deleteItem fnTarget.parentHolderG[1].node.moduleArmHolderG fnTarget.rowHolderG
		if fnTarget.parentHolderG[1].node.moduleArmHolderG.count != 0 then
		(
			for i =1 to fnTarget.parentHolderG[1].node.moduleArmHolderG.count do
				(
					fnTarget.parentHolderG[1].node.moduleArmHolderG[i].node.rowHolderG = i
				)
		)
	)
	if (fnTarget.armBonesHolderG.count != 0 and fnTarget.legToeHolderG.count != 0) then
	(
		upperArm = fnTarget.armbonesHolderG[1].node
		foreArm = fnTarget.armbonesHolderG[2].node
		hand = fnTarget.armbonesHolderG[3].node
		toe = fnTarget.armbonesHolderG[4].node
		if fnTarget.armbonesHolderG.count > 4  then (clavicle = fnTarget.armbonesHolderG[5].node;)
		
		append delNodes fnTarget.armPoleHolderG[1].node
		append delNodes fnTarget.armPoleHolderG[2].node
		append delNodes fnTarget.armPoleHolderG[3].node
		append delNodes fnTarget.armPoleHolderG[4].node
		
		for i in hand.modulefingerHolderG do
			(
				for b = 1 to i.node.fingerBoneHolderG.count do
				(
					FN_collectDelNodes i.node.fingerBoneHolderG[b].node delNodes
					append delNodes i.node.fingerBoneHolderG[b].node
				)
				append delNodes i.node
			)
		FN_collectDelNodes toe delNodes
		-- append, toe, heel, ikfoot and other points
		for i in fnTarget.legToeHolderG do append delNodes i.node
		FN_collectDelNodes hand delNodes
		append delNodes hand
		
		if foreArm.twistBoneHolderG.count != 0 then
			(
				for t = 1 to foreArm.twistBoneHolderG.count do
					(
						FN_collectDelNodes foreArm.twistBoneHolderG[t].node delNodes
						append delNodes foreArm.twistBoneHolderG[t].node
					)
			)
		append delNodes foreArm.pPointHolderG[1].node
		FN_collectDelNodes foreArm delNodes
		append delNodes foreArm
		
		if upperArm.twistBoneHolderG.count != 0 then
			(
				for t = 1 to upperArm.twistBoneHolderG.count do
					(
						FN_collectDelNodes upperArm.twistBoneHolderG[t].node delNodes
						append delNodes upperArm.twistBoneHolderG[t].node
					)
			)
		append delNodes upperArm.pPointHolderG[1].node
		FN_collectDelNodes upperArm delNodes
		append delNodes upperArm
			
		if fnTarget.armbonesHolderG.count > 4  then (FN_collectDelNodes clavicle delNodes; append delNodes clavicle.clavicleUpHolderG[1].node; append delNodes clavicle.clavicleUpHolderG[2].node; append delNodes clavicle;)
		
		deleteItem fnTarget.parentHolderG[1].node.moduleLegHolderG fnTarget.rowHolderG
		if fnTarget.parentHolderG[1].node.moduleLegHolderG.count != 0 then
		(
			for i =1 to fnTarget.parentHolderG[1].node.moduleLegHolderG.count do
				(
					fnTarget.parentHolderG[1].node.moduleLegHolderG[i].node.rowHolderG = i
				)
		)
			
	)

	if fnTarget.chestHolderG.count != 0 then
	(
		chestBone = fnTarget.chestHolderG[1].node
		parentBone =  fnTarget.spineEndHolderG[1].node
		
		for i = 1 to fnTarget.spineHolderG.count do
		(
			FN_collectDelNodes fnTarget.spineHolderG[i].node delNodes
			append delNodes fnTarget.spineHolderG[i].node
		)
		try (FN_deleteMiddle chestBone) catch ()
		FN_collectDelNodes chestBone delNodes
		
		deleteItem fnTarget.parentHolderG[1].node.moduleSpineHolderG fnTarget.rowHolderG
		if fnTarget.parentHolderG[1].node.moduleSpineHolderG.count != 0 then
		(
			for i =1 to fnTarget.parentHolderG[1].node.moduleSpineHolderG.count do
				(
					fnTarget.parentHolderG[1].node.moduleSpineHolderG[i].node.rowHolderG = i
				)
		)
		append delNodes chestBone
		append delNodes parentBone
	)
	if fnTarget.HubHolderG.count != 0 then
	(
		FN_collectDelNodes fnTarget.hubHolderG[1].node delNodes
		append delNodes fnTarget.hubHolderG[1].node
		deleteItem fnTarget.parentHolderG[1].node.moduleHubHolderG fnTarget.rowHolderG
		if fnTarget.parentHolderG[1].node.moduleHubHolderG.count != 0 then
		(
			for i =1 to fnTarget.parentHolderG[1].node.moduleHubHolderG.count do
				(
					fnTarget.parentHolderG[1].node.moduleHubHolderG[i].node.rowHolderG = i
				)
		)
	)
	try (FN_renameRoot fnTarget.rootNodeHolderG[1].node) catch()
	append delNodes fnTarget
)
fn FN_createPoint =
( 
	bonePivot = BoneSys.createBone [0,0,0] [0,0,25] [-25,0,0]
	sp = point cross:false centermarker:false box:false axistripod:false size:5
	FN_addIR sp
	try
	(
		obj = NodeTransformMonitor node:sp forwardTransformChangeMsgs:false
		append glbRoot.rigNodes obj
	)catch()
	sp.wirecolor = [255,80,0]
	sp.parent = bonePivot
	ResetTransform sp
	delete bonePivot
-- 	sp.isHidden = true
	
	sp.name = uniquename  (rName + "_hiddenNodes_")
	
	newLayerName = rName + "_hiddenNodes"
	newLayerHiddenNodes = LayerManager.getLayerFromName newLayerName
	if newLayerHiddenNodes == undefined then newLayerHiddenNodes = LayerManager.newLayerFromName newLayerName
	newLayerHiddenNodes.ishidden = true
	newLayerHiddenNodes.addNode sp
	
	hide sp
	freeze sp
	
	sp
)
fn FN_createCircle cRadius =
(
	bonePivot = BoneSys.createBone [0,0,0] [0,0,25] [-25,0,0]
	sc = circle ()
	FN_addIR sc
	try
	(
		obj = NodeTransformMonitor node:sc forwardTransformChangeMsgs:false
		append glbRoot.rigNodes obj
	)catch()
	sc.parent = bonePivot
	ResetTransform sc
	delete bonePivot
	sc.radius = cRadius
	sc.wirecolor = [255,255,0]
		
	newLayerName = rName + "_controllers"
	newLayerControllers = LayerManager.getLayerFromName newLayerName
	if newLayerControllers == undefined then newLayerControllers = LayerManager.newLayerFromName newLayerName
	newLayerControllers.addNode sc

	addModifier sc (EmptyModifier ()) 
	sc.modifiers[#attribute_holder].name = "attributes"
	FN_addParameters sc
-- 	obj = NodeTransformMonitor node:sc forwardTransformChangeMsgs:false
-- 	sc.modifiers[#attributes]._this = obj
	FN_Reset sc

	sc
)
fn FN_createNgon cRadius =
(
	bonePivot = BoneSys.createBone [0,0,0] [0,0,25] [-25,0,0]
	sc = ngon ()
	FN_addIR sc
	try
	(
		obj = NodeTransformMonitor node:sc forwardTransformChangeMsgs:false
		append glbRoot.rigNodes obj
	)catch()
	sc.parent = bonePivot
	ResetTransform sc
	delete bonePivot
	sc.radius = cRadius
	sc.wirecolor = [0,0,255]
		
	newLayerName = rName + "_controllers"
	newLayerControllers = LayerManager.getLayerFromName newLayerName
	if newLayerControllers == undefined then newLayerControllers = LayerManager.newLayerFromName newLayerName
	newLayerControllers.addNode sc

	addModifier sc (EmptyModifier ()) 
	sc.modifiers[#attribute_holder].name = "attributes"
	FN_addParameters sc
-- 	obj = NodeTransformMonitor node:sc forwardTransformChangeMsgs:false
-- 	sc.modifiers[#attributes]._this = obj
	FN_Reset sc

	sc
)
fn FN_createAsterix cSize =
(
	bonePivot = BoneSys.createBone [0,0,0] [0,0,25] [-25,0,0]
	ss = SplineShape ()
	FN_addIR ss
	try
	(
		obj = NodeTransformMonitor node:ss forwardTransformChangeMsgs:false
		append glbRoot.rigNodes obj
	)catch()
	ss.parent = bonePivot
	ss.transform = bonePivot.transform
	addNewSpline ss
	addKnot ss 1 #corner #line [1*cSize,0,0]
	addKnot ss 1 #corner #line [-1*cSize,0,0]
	addNewSpline ss
	addKnot ss 2 #corner #line [0,1*cSize,0]
	addKnot ss 2 #corner #line [0,-1*cSize,0]
	addNewSpline ss
	addKnot ss 3 #corner #line [0,0,1*cSize]
	addKnot ss 3 #corner #line [0,0,-1*cSize]
	updateShape ss

	ResetTransform ss
	delete bonePivot
	ss.wirecolor = [255,0,0]
		
	newLayerName = rName + "_controllers"
	newLayerControllers = LayerManager.getLayerFromName newLayerName
	if newLayerControllers == undefined then newLayerControllers = LayerManager.newLayerFromName newLayerName
	newLayerControllers.addNode ss

	addModifier ss (EmptyModifier ()) 
	ss.modifiers[#attribute_holder].name = "attributes"
	FN_addParameters ss
-- 	obj = NodeTransformMonitor node:ss forwardTransformChangeMsgs:false
-- 	ss.modifiers[#attributes]._this = obj
	FN_Reset ss

	ss
)
fn FN_createPin fnStartPos fnEndPos =
(
	wp1 = fnStartPos
	shp = splineShape()
	shp2 = splineShape()
	FN_addIR shp2
	try
	(
		obj = NodeTransformMonitor node:shp2 forwardTransformChangeMsgs:false
		append glbRoot.rigNodes obj
	)catch()
	select shp
	selectmore shp2
	spln = addNewSpline shp

	addKnot shp spln #bezierCorner #curve [11.8312,0,0] [11.8312,-6.52827,0] [11.8312,6.52827,0]
	addKnot shp spln #bezierCorner #curve [-5.17156e-007,11.8312,0] [6.52827,11.8312,0] [-6.52827,11.8312,0]
	addKnot shp spln #bezierCorner #curve [-11.8312,-1.03431e-006,0] [-11.8312,6.52827,0] [-11.8312,-6.52827,0]
	addKnot shp spln #bezierCorner #curve [1.55147e-006,-11.8312,0] [-6.52827,-11.8312,0] [6.52827,-11.8312,0]
	close shp spln

	spln = addNewSpline shp
	addKnot shp spln #bezierCorner #curve [-5.17156e-007,0,-11.8312] [-5.17156e-007,-6.52827,-11.8312] [-5.17156e-007,6.52827,-11.8312]
	addKnot shp spln #bezierCorner #curve [0,11.8312,5.17156e-007] [-2.8536e-007,11.8312,-6.52827] [2.8536e-007,11.8312,6.52827]
	addKnot shp spln #bezierCorner #curve [5.17156e-007,-1.03431e-006,11.8312] [5.17156e-007,6.52827,11.8312] [5.17156e-007,-6.52827,11.8312]
	addKnot shp spln #bezierCorner #curve [0,-11.8312,-1.55147e-006] [2.8536e-007,-11.8312,6.52827] [-2.8536e-007,-11.8312,-6.52827]
	close shp spln

	spln = addNewSpline shp
	addKnot shp spln #bezierCorner #curve [11.8312,0,0] [11.8312,2.8536e-007,-6.52827] [11.8312,-2.8536e-007,6.52827]
	addKnot shp spln #bezierCorner #curve [-5.17156e-007,-5.17156e-007,11.8312] [6.52827,-5.17156e-007,11.8312] [-6.52827,-5.17156e-007,11.8312]
	addKnot shp spln #bezierCorner #curve [-11.8312,0,-1.03431e-006] [-11.8312,-2.8536e-007,6.52827] [-11.8312,2.8536e-007,-6.52827]
	addKnot shp spln #bezierCorner #curve [1.55147e-006,5.17156e-007,-11.8312] [-6.52827,5.17156e-007,-11.8312] [6.52827,5.17156e-007,-11.8312]
	close shp spln

	spln = addNewSpline shp2
	addKnot shp2 spln #Corner #curve [0,0,0] [0,0,0] [0,0,0]
	addKnot shp2 spln #Corner #curve [0,-100,0] [0,0,0] [0,0,0]
	--close shp2 spln

	shp.pos = fnStartPos
	shp2.pos = fnStartPos
	shp.wireColor = [255,255,0]
	shp2.wireColor = [255,255,0]
	shp2.name = uniqueName "Pin_CNT"
	addModifier shp (xform())

	---------
		
	wp2 = fnEndPos
	shp.pos = wp2
	setKnotPoint shp2 1 2 wp2
	updateShape shp2
	scl = [(distance wp1 wp2)/100,(distance wp1 wp2)/100,(distance wp1 wp2)/100]
	shp.modifiers[#xform].gizmo.scale = scl

	-----------
		
	converttosplineshape shp
	updateShape shp
	updateShape shp2
	addAndWeld shp2 shp 0
	shp2.thickness=.2 
	shp2.sides=3 
	shp2.steps=3 
	shp2.displayRenderMesh=false
		
	addModifier shp2 (EmptyModifier ()) 
	shp2.modifiers[#attribute_holder].name = "attributes"
	FN_addParameters shp2
-- 	obj = NodeTransformMonitor node:shp2 forwardTransformChangeMsgs:false
-- 	shp2.modifiers[#attributes]._this = obj
	FN_Reset shp2
		
	newLayerName = rName + "_controllers"
	newLayerControllers = LayerManager.getLayerFromName newLayerName
	if newLayerControllers == undefined then newLayerControllers = LayerManager.newLayerFromName newLayerName
	newLayerControllers.addNode shp2
	
	shp2
)
fn FN_createRectangle w:1 l:1 build:true=
(
	bonePivot = BoneSys.createBone [0,0,0] [0,0,25] [-25,0,0]
	sc = rectangle ()
	FN_addIR sc
	try
	(
		obj = NodeTransformMonitor node:sc forwardTransformChangeMsgs:false
		append glbRoot.rigNodes obj
	)catch()
	_min = amin #(w, l)
	sc.cornerRadius = _min/10
	sc.parent = bonePivot
	ResetTransform sc
	delete bonePivot
	sc.width = w
	sc.length = l
	sc.wirecolor = [0,0,255]
	
	newLayerName = rName + "_controllers"
	newLayerControllers = LayerManager.getLayerFromName newLayerName
	if newLayerControllers == undefined then newLayerControllers = LayerManager.newLayerFromName newLayerName
	newLayerControllers.addNode sc
	
	if (build == true) then
	(
	addModifier sc (EmptyModifier ()) 
	sc.modifiers[#attribute_holder].name = "attributes"
	FN_addParameters sc
-- 	obj = NodeTransformMonitor node:sc forwardTransformChangeMsgs:false
-- 	sc.modifiers[#attributes]._this = obj
	FN_Reset sc
	)
	else
	(
		sc.scale.controller = ScaleXYZ ()
		
		sc.scale.controller.z_Scale.controller = float_list ()
		sc.scale.controller.z_Scale.controller.Available.controller = bezier_float ()
		paramWire.connect sc.scale.controller.z_Scale.controller[1] sc.scale.controller.z_Scale.controller[2] "-(Bezier_Float-1)"
		paramText =  w as string +"*Bezier_Float"
		paramWire.connect sc.scale.controller.z_Scale.controller[1] sc.baseObject[#Width] paramText
		
		sc.scale.controller.x_Scale.controller = float_list ()
		sc.scale.controller.x_Scale.controller.Available.controller = bezier_float ()
		paramWire.connect sc.scale.controller.x_Scale.controller[1] sc.scale.controller.x_Scale.controller[2] "-(Bezier_Float-1)"
		paramText =  l as string +"*Bezier_Float"
		paramWire.connect sc.scale.controller.x_Scale.controller[1] sc.baseObject[#Length] paramText
		
		sc.scale.controller.y_Scale.controller = float_limit ()
		sc.scale.controller.y_Scale.controller.upper_limit = 1
		sc.scale.controller.y_Scale.controller.lower_limit = 1
	)
	sc
)
fn FN_createBox_lmt fnBwidth fnBlength fnBheight=
(
	bonePivot = BoneSys.createBone [0,0,0] [0,0,25] [-25,0,0]
	sb = Box ()
	FN_addIR sb
	try
	(
		obj = NodeTransformMonitor node:sb forwardTransformChangeMsgs:false
		append glbRoot.rigNodes obj
	)catch()
-- 	sb = ChamferBox Length_Segments:1 Width_Segments:1 Height_Segments:1 Fillet_Segments:2  Fillet:.7 smooth:1 mapcoords:1
	sb.parent = bonePivot
	ResetTransform sb
	delete bonePivot
	sb.wirecolor = [255,80,0]
	sb.scale.controller = ScaleXYZ ()
	
	sb.height = fnBheight
	
	sb.scale.controller.z_Scale.controller = float_list ()
	sb.scale.controller.z_Scale.controller.Available.controller = bezier_float ()
	paramWire.connect sb.scale.controller.z_Scale.controller[1] sb.scale.controller.z_Scale.controller[2] "-(Bezier_Float-1)"
	paramText =  fnBwidth as string +"*Bezier_Float"
	paramWire.connect sb.scale.controller.z_Scale.controller[1] sb.baseObject[#Width] paramText
	
	sb.scale.controller.y_Scale.controller = float_list ()
	sb.scale.controller.y_Scale.controller.Available.controller = bezier_float ()
	paramWire.connect sb.scale.controller.y_Scale.controller[1] sb.scale.controller.y_Scale.controller[2] "-(Bezier_Float-1)"
	paramText =  fnBlength as string +"*Bezier_Float"
	paramWire.connect sb.scale.controller.y_Scale.controller[1] sb.baseObject[#Length] paramText
	
	sb.scale.controller.X_Scale.controller = float_limit ()
	sb.scale.controller.X_Scale.controller.upper_limit = 1
	sb.scale.controller.X_Scale.controller.lower_limit = 1
	
	newLayerName = rName + "_bones"
	newLayerBones = LayerManager.getLayerFromName newLayerName
	if newLayerBones == undefined then newLayerBones = LayerManager.newLayerFromName newLayerName
	newLayerBones.addNode sb

	sb
)
fn FN_createBox fnBwidth fnBlength fnBheight=
(
	bonePivot = BoneSys.createBone [0,0,0] [0,0,25] [-25,0,0]
	sb = Box ()
	FN_addIR sb
	try
	(
		obj = NodeTransformMonitor node:sb forwardTransformChangeMsgs:false
		append glbRoot.rigNodes obj
	)catch()
-- 	sb = ChamferBox Length_Segments:1 Width_Segments:1 Height_Segments:1 Fillet_Segments:2  Fillet:.7 smooth:1 mapcoords:1
	sb.parent = bonePivot
	ResetTransform sb
	delete bonePivot
	sb.wirecolor = [255,80,0]
	sb.scale.controller = ScaleXYZ ()
	
	sb.scale.controller.x_Scale.controller = float_list ()
	sb.scale.controller.x_Scale.controller.Available.controller = bezier_float ()
	paramWire.connect sb.scale.controller.x_Scale.controller[1] sb.scale.controller.x_Scale.controller[2] "-(Bezier_Float-1)"
	paramText = fnBheight as string +"*Bezier_Float"
	paramWire.connect sb.scale.controller.x_Scale.controller[1] sb.baseObject[#Height] paramText
	
	sb.scale.controller.z_Scale.controller = float_list ()
	sb.scale.controller.z_Scale.controller.Available.controller = bezier_float ()
	paramWire.connect sb.scale.controller.z_Scale.controller[1] sb.scale.controller.z_Scale.controller[2] "-(Bezier_Float-1)"
	paramText =  fnBwidth as string +"*Bezier_Float"
	paramWire.connect sb.scale.controller.z_Scale.controller[1] sb.baseObject[#Width] paramText
	
	sb.scale.controller.y_Scale.controller = float_list ()
	sb.scale.controller.y_Scale.controller.Available.controller = bezier_float ()
	paramWire.connect sb.scale.controller.y_Scale.controller[1] sb.scale.controller.y_Scale.controller[2] "-(Bezier_Float-1)"
	paramText = fnBlength as string +"*Bezier_Float"
	paramWire.connect sb.scale.controller.y_Scale.controller[1] sb.baseObject[#Length] paramText	
	
	newLayerName = rName + "_bones"
	newLayerBones = LayerManager.getLayerFromName newLayerName
	if newLayerBones == undefined then newLayerBones = LayerManager.newLayerFromName newLayerName
	newLayerBones.addNode sb
	
	sb
)
fn FN_createRootNode=
(
	parentPoint = FN_createPoint ()
	
	FN_addHolderAtt parentPoint
	parentPoint.rootCheck = true
	
	root_Node = FN_createRectangle w:58 l:38 build:false
	root_node.parent = parentPoint
	
	FN_addHolderAtt root_Node
	obj = NodeTransformMonitor node:root_Node forwardTransformChangeMsgs:false
	append root_Node.rootNodeHolderG obj
	obj = NodeTransformMonitor node:root_Node forwardTransformChangeMsgs:false
	append parentPoint.rootNodeHolderG obj
	obj = NodeTransformMonitor node:parentPoint forwardTransformChangeMsgs:false
	append root_Node.parentPointHolderG obj
	
	root_Node.nameHolderG = rName
	parentPoint.modulNameHolder = "root"
	root_Node.name = rName + "_" + parentPoint.modulNameHolder
	parentPoint.name = rName + "_"+parentPoint.modulNameHolder+"P"
	
	root_Node.btnEnableG = #(true,false,false,false,false,false)
	root_Node.rigSectionHolderG = 10
	
	root_Node.scale.controller = bezier_scale ()
	root_Node.width.controller = bezier_float ()
	root_Node.length.controller = bezier_float ()
	root_Node.scale.controller = ScaleXYZ ()
	paramWire.connect root_Node.scale.controller[#X_Scale] root_Node.scale.controller[#Y_Scale] "X_Scale"
	paramWire.connect root_Node.scale.controller[#X_Scale] root_Node.scale.controller[#Z_Scale] "X_Scale"
		
	select root_Node
)
fn	FN_createHubBone fnParent=
(
	parentPoint = FN_createPoint ()
	parentPoint.parent = fnParent
	parentPoint.transform = fnParent.transform
	parentPoint.pos.controller.x_position += 130
	
	FN_addHolderAtt parentPoint
	
	obj = NodeTransformMonitor node:parentPoint forwardTransformChangeMsgs:false
	append fnParent.moduleHubHolderG obj
	
	
	obj = NodeTransformMonitor node:fnParent forwardTransformChangeMsgs:false
	append parentPoint.parentHolderG obj
	
	obj = NodeTransformMonitor node:fnParent forwardTransformChangeMsgs:false
	append parentPoint.rootNodeHolderG obj
	
	
	rNode = fnParent
	glbScl = rNode.scale.controller.X_Scale/100
	
	hubBone = FN_createBox 25 20 10
	hubBone.parent = parentPoint
	hubBone.transform = parentPoint.transform
	
	hubBone.scale.controller.X_Scale.controller.Bezier_Float *= glbScl
	hubBone.scale.controller.Y_Scale.controller.Bezier_Float *= glbScl
	hubBone.scale.controller.Z_Scale.controller.Bezier_Float *= glbScl
		
	FN_addHolderAtt hubBone
	
		
	hubBone.rigSectionHolderG = 1
		
	hubBone.boneEnable = true
	hubBone.boneFreezeLength=false
	hubBone.boneScaleType = #none
	
		
	obj = NodeTransformMonitor node:hubBone forwardTransformChangeMsgs:false
	append parentPoint.hubHolderG obj
	
	obj = NodeTransformMonitor node:parentPoint forwardTransformChangeMsgs:false
	append hubBone.parentPointHolderG obj
	
	obj = NodeTransformMonitor node:fnParent forwardTransformChangeMsgs:false
	append hubBone.rootNodeHolderG obj
	
	parentPoint.rowHolderG = fnParent.moduleHubHolderG.count
	
	hubBone.btnEnableG = #(false,true,true,true,false,true)
	hubBone.hubCheck = true
	
	parentPoint.modulNameHolder = "hub"+(parentPoint.rowHolderG as string)
	hubBone.name = rName+"_"+parentPoint.modulNameHolder
	parentPoint.name = rName+"_"+parentPoint.modulNameHolder+ "_pp"
	select hubBone
	
	hubbone
)
fn FN_createSpineBones fnTarget fnSpineSpinner=
(	
	
	with redraw off
	
	parentPoint = fnTarget.parentPointHolderG[1].node
	chestBone = parentPoint.chestHolderG[1].node
	rNode = parentPoint.rootNodeHolderG[1].node
	
	parentBone = parentPoint.spineEndHolderG[1].node
	
	spineBonesLocal = #()
	for i = 1 to parentPoint.spineHolderG.count do append spineBonesLocal parentPoint.spineHolderG[i].node
		
	for i = 1 to parentPoint.spineHolderG.count do
	(
		parentPoint.spineHolderG[i].node.height.controller = bezier_float ()
	)
	
	oldVal = parentPoint.spineHolderG.count
	newVal = fnSpineSpinner
	diffVal = newVal-oldVal
	
	if newVal > oldVal then
	(
		cnt = (100.0/newVal)
		for i = 1 to oldVal do
			(
				
				spineBonesLocal[i].pos.controller[1].setWeight 1 (100-cnt*(i-1))
				spineBonesLocal[i].pos.controller[1].setWeight 2 (cnt*(i-1))
				
			)
			
		parentSpineBone = parentPoint.spineHolderG[parentPoint.spineHolderG.count].node
		for i = (oldVal+1) to newVal do
			(
-- 			nSpineBone = FN_createBox_lmt 10 10 10
			nSpineBone = FN_createBox_lmt	parentSpineBone.width parentSpineBone.length parentSpineBone.height
			nSpineBone.parent = parentPoint
				
			posCons = position_constraint ()
			posCons.appendTarget parentBone (100-cnt*(i-1))
			posCons.appendTarget chestBone (cnt*(i-1))
			nSpineBone.pos.controller = posCons
			nSpineBone.pos.controller = position_list ()
			nSpineBone.pos.controller.available.controller = position_xyz ()
			nSpineBone.pos.controller.SetActive 2
				
				
			nSpineBone.boneEnable = true
			nSpineBone.boneFreezeLength=false
			nSpineBone.boneScaleType = #none
			nSpineBone.boneAutoAlign=false
			
			nSpineBone.scale.controller.y_Scale.controller[1].controller.value = 100
			nSpineBone.scale.controller.z_Scale.controller[1].controller.value = 100
				
			FN_addHolderAtt nSpineBone
			
			obj = NodeTransformMonitor node:parentPoint forwardTransformChangeMsgs:false
			append nspineBone.parentPointHolderG obj
				
			obj = NodeTransformMonitor node:nspineBone forwardTransformChangeMsgs:false
			append parentPoint.spineHolderG obj
			
			append spineBonesLocal nSpineBone
				
			nSpineBone.name = parentPoint.parent.name+"_"+parentPoint.modulNameHolder+"_T"+(i as string)
-- 			if (parentPoint.middleCheck) do nSpineBone.name = parentPoint.parent.name+"_neck"+(parentPoint.rowHolderG as string)+(i as string)
			
			nSpineBone.rootNodeHolderG =  parentPoint.rootNodeHolderG
		
			nSpineBone.btnEnableG = #(false,false,true,true,false,true)
			nSpineBone.rigSectionHolderG = 2
		)
		
		spineBonesLocal[oldVal].rotation.controller.deleteTarget 1
		spineBonesLocal[oldVal].rotation.controller.appendTarget spineBonesLocal[oldVal+1] 100
		for i = (oldVal+1) to spineBonesLocal.count do
		(
			spineBonesLocal[i].rotation.controller = lookat_Constraint ()
			spineBonesLocal[i].rotation.controller.lookat_vector_length = 0
			spineBonesLocal[i].rotation.controller.target_axis = 0
			spineBonesLocal[i].rotation.controller.upnode_ctrl = 1
			spineBonesLocal[i].rotation.controller.StoUP_axis = 2
			spineBonesLocal[i].rotation.controller.upnode_axis = 2
			spineBonesLocal[i].rotation.controller.pickUpNode = parentPoint
			spineBonesLocal[i].rotation.controller.upnode_world = off
			if i == spineBonesLocal.count then spineBonesLocal[i].rotation.controller.appendTarget chestBone 100;
				else spineBonesLocal[i].rotation.controller.appendTarget spineBonesLocal[i+1] 100
		)
		
	)

	if newVal < oldVal then
	(
		cnt = (100.0/newVal)
		
		for i = 1 to newVal do
			(
				spineBonesLocal[i].pos.controller[1].setWeight 1 (100-cnt*(i-1))
				spineBonesLocal[i].pos.controller[1].setWeight 2 (cnt*(i-1))
			)
			
		for i = (newVal+1) to oldval do 
		(
			delNodes = #()
			callbacks.removeScripts id:#getDelNodes
			delete (FN_collectDelNodes parentPoint.spineHolderG[parentPoint.spineHolderG.count].node delNodes)
			delete parentPoint.spineHolderG[parentPoint.spineHolderG.count].node
			callbacks.addScript #nodepreDelete "FNgetDelNodes()" id:#getDelNodes
			deleteItem parentPoint.spineHolderG parentPoint.spineHolderG.count
			deleteItem spineBonesLocal spineBonesLocal.count
		)
		spineBonesLocal[spineBonesLocal.count].rotation.controller.deleteTarget 1
		spineBonesLocal[spineBonesLocal.count].rotation.controller.appendTarget chestBone 100
	)
	
	append spineBonesLocal chestBone
	for i = 1 to spineBonesLocal.count-1 do
	(
		spineBonesLocal[i].height.controller = float_script ()
		spineBonesLocal[i].height.controller.addNode "ths" spineBonesLocal[i]
		spineBonesLocal[i].height.controller.addNode "chld" spineBonesLocal[i+1]
		spineBonesLocal[i].height.controller.addNode "rNode" rNode
		spineBonesLocal[i].height.controller.script = "try (distance ths chld)/(rNode.scale.controller.X_Scale/100) catch (0)"

	)
	free spineBonesLocal
)
fn  FN_createSpine fnTarget=
(
	rNode = fnTarget.rootNodeHolderG[1].node
	glbScl = rNode.scale.controller.X_Scale/100
	
	parentPoint = FN_createPoint ()
	parentPoint.parent = fnTarget
	parentPoint.transform = fnTarget.transform
	parentPoint.pos.controller.x_position.controller = fnTarget.height.controller
	
	FN_addHolderAtt parentPoint
	
	obj = NodeTransformMonitor node:parentPoint forwardTransformChangeMsgs:false
	append fnTarget.moduleSpineHolderG obj
	
	obj = NodeTransformMonitor node:fnTarget forwardTransformChangeMsgs:false
	append parentPoint.parentHolderG obj
	
	parentPoint.rootNodeHolderG =  fnTarget.rootNodeHolderG
	
	if (fnTarget.parentPointHolderG[1].node.spineHolderG.count>0) then
	(
		parentBone = FN_createBox (fnTarget.width*.8) (fnTarget.length*.8) (fnTarget.height*.1)
	)
	else
	(
		parentBone = FN_createBox (fnTarget.width*.8) (fnTarget.length*.8) (fnTarget.height*.5)
	)
	parentBone.parent = parentPoint
	parentBone.transform = parentPoint.transform
	
	parentBone.scale.controller.X_Scale.controller.Bezier_Float *= glbScl
	parentBone.scale.controller.Y_Scale.controller.Bezier_Float *= glbScl
	parentBone.scale.controller.Z_Scale.controller.Bezier_Float *= glbScl
	
	parentBone.boneEnable = true
	parentBone.boneFreezeLength=false
	parentBone.boneScaleType = #none
	
	FN_addHolderAtt parentBone
	
	obj = NodeTransformMonitor node:parentBone forwardTransformChangeMsgs:false
	append parentPoint.spineEndHolderG obj

	obj = NodeTransformMonitor node:parentPoint forwardTransformChangeMsgs:false
	append parentBone.parentPointHolderG obj

	parentBone.rootNodeHolderG =  fnTarget.rootNodeHolderG

	parentBone.btnEnableG = #(false,false,false,false,false,false)
	parentBone.rigSectionHolderG = 2
	
	
	----first bone
	if (fnTarget.parentPointHolderG[1].node.spineHolderG.count>0) then
	(
		chestBone = FN_createBox (fnTarget.width*.8) (fnTarget.length*.8) (fnTarget.height*.8)
	)
	else
	(
		chestBone = FN_createBox (fnTarget.width*1.3) (fnTarget.length*.8) (fnTarget.height*3)
	)
	
	chestBone.parent = parentPoint
	chestBone.transform = parentPoint.transform
	if (fnTarget.parentPointHolderG[1].node.spineHolderG.count>0) then
	(
		chestBone.pos.controller.x_position += (fnTarget.height)
	)
	else
	(
		chestBone.pos.controller.x_position += (fnTarget.height*4)
	)
	chestBone.scale.controller.X_Scale.controller.Bezier_Float *= glbScl
	chestBone.scale.controller.Y_Scale.controller.Bezier_Float *= glbScl
	chestBone.scale.controller.Z_Scale.controller.Bezier_Float *= glbScl
-- 	chestBone.parent = parentPoint
	
	chestBone.boneEnable = true
	chestBone.boneFreezeLength=false
	chestBone.boneScaleType = #none
		
	FN_addHolderAtt chestBone
	

	obj = NodeTransformMonitor node:chestBone forwardTransformChangeMsgs:false
	append parentPoint.chestHolderG obj
		
	obj = NodeTransformMonitor node:parentPoint forwardTransformChangeMsgs:false
	append chestBone.parentPointHolderG obj
	
	
	chestBone.rootNodeHolderG =  fnTarget.rootNodeHolderG
	
	chestBone.btnEnableG = #(false,true,true,true,false,true)
	chestBone.rigSectionHolderG = 2
	
	spineBone = FN_createBox_lmt (chestBone.width*.5) (chestBone.length*.5) (chestBone.height)
	spineBone.parent = parentPoint
	spineBone.transform = parentPoint.transform
	posCons = position_constraint ()
	posCons.appendTarget parentBone 100
	posCons.appendTarget chestBone 0
	spineBone.pos.controller = posCons
	spineBone.pos.controller = position_list ()
	spineBone.pos.controller.available.controller = position_xyz ()
	spineBone.pos.controller.SetActive 2
	
	spineBone.rotation.controller = lookat_Constraint ()
	spineBone.rotation.controller.lookat_vector_length = 0
	spineBone.rotation.controller.target_axis = 0
	spineBone.rotation.controller.upnode_ctrl = 1
	spineBone.rotation.controller.StoUP_axis = 2
	spineBone.rotation.controller.upnode_axis = 2
	spineBone.rotation.controller.pickUpNode = parentPoint
	spineBone.rotation.controller.upnode_world = off
	spineBone.rotation.controller.appendTarget chestBone 100
	
	spineBone.scale.controller.Y_Scale.controller.Bezier_Float *= glbScl
	spineBone.scale.controller.Z_Scale.controller.Bezier_Float *= glbScl
	
	spineBone.boneEnable = true
	spineBone.boneFreezeLength=false
	spineBone.boneScaleType = #none
	
	FN_addHolderAtt spineBone
	
	obj = NodeTransformMonitor node:parentPoint forwardTransformChangeMsgs:false
	append spineBone.parentPointHolderG obj
	
	obj = NodeTransformMonitor node:spineBone forwardTransformChangeMsgs:false
	append parentPoint.spineHolderG obj
	
	
			
	spineBone.rootNodeHolderG =  fnTarget.rootNodeHolderG
	
	spineBone.btnEnableG = #(false,false,true,true,false,true)
	spineBone.rigSectionHolderG = 2
	--- naming
	chestCount = fnTarget.moduleSpineHolderG.count
	parentPoint.rowHolderG = chestCount
	parentPoint.modulNameHolder = "spine" + (chestCount as string)
	chestBone.name = fnTarget.name+"_"+parentPoint.modulNameHolder
		

	spineBone.name = chestBone.name+"_T"+"1"
	parentPoint.name = chestBone.name+"_pp"+(chestCount as string)
	parentBone.name = chestBone.name+"_P"+(chestCount as string)
	
	spineBone.height.controller = float_script ()
	spineBone.height.controller.addNode "ths" spineBone
	spineBone.height.controller.addNode "chld" chestBone
	spineBone.height.controller.addNode "rNode" rNode
	spineBone.height.controller.script = "try (distance ths chld)/(rNode.scale.controller.X_Scale/100) catch (0)"
	
	select chestBone
	
	parentPoint
)
fn FN_deleteClavicle fnTarget=
(
	parentPoint = fnTarget
	parentPoint.clavicleCheck = false
	
	delNodes = #()
	callbacks.removeScripts id:#getDelNodes
	delete (FN_collectDelNodes parentPoint.armBonesHolderG[parentPoint.armBonesHolderG.count].node delNodes)
	delete parentPoint.armBonesHolderG[parentPoint.armBonesHolderG.count].node.clavicleUpHolderG[2].node
	delete parentPoint.armBonesHolderG[parentPoint.armBonesHolderG.count].node.clavicleUpHolderG[1].node
	delete parentPoint.armBonesHolderG[parentPoint.armBonesHolderG.count].node
	callbacks.addScript #nodepreDelete "FNgetDelNodes()" id:#getDelNodes
	deleteItem parentPoint.armBonesHolderG parentPoint.armBonesHolderG.count
	
)
fn FN_addClavicle fnTarget =
(
	upperArm = fnTarget.armBonesHolderG[1].node
	parentPoint = fnTarget
	
-- 	if parentPoint.nodeMirror[1] == false then (mrr = 1) else (mrr = -1)
	parentPoint.clavicleCheck = true
	rNode = parentPoint.rootNodeHolderG[1].node
	glbScl = rNode.scale.controller.X_Scale/100
	
	pnt = FN_createPoint ()
	pnt.parent = upperArm
	pnt.transform = upperArm.transform

	refBone = FN_createBox (upperArm.width) (upperArm.width) (upperArm.width)
	refBone.parent = pnt
	refBone.transform = pnt.transform
	refBone.pos.controller.y_position = upperArm.height*.5
	
	refBone.rotation.controller.X_Rotation.controller = float_list ()
	refBone.rotation.controller.X_Rotation.controller.Available.controller = bezier_float ()
	paramWire.connect refBone.rotation.controller.X_Rotation.controller[1] refBone.rotation.controller.X_Rotation.controller[2] "-Bezier_Float"
	pnt.rotation.controller.X_Rotation.controller = refBone.rotation.controller.X_Rotation.controller.Bezier_Float.controller
	refBone.rotation.controller.X_Rotation.controller.Bezier_Float = 0
	
	pnt.pos.controller.X_Position.controller = float_script ()
	pnt.pos.controller.X_Position.controller.script ="0"
	pnt.pos.controller.Y_Position.controller = float_script ()
	pnt.pos.controller.Y_Position.controller.script ="0"
	pnt.pos.controller.Z_Position.controller = float_script ()
	pnt.pos.controller.Z_Position.controller.script ="0"
	
	pnt.rotation.controller.Y_Rotation.controller = float_script ()
	pnt.rotation.controller.Y_Rotation.controller.script ="0"
	pnt.rotation.controller.Z_Rotation.controller = float_script ()
	pnt.rotation.controller.Z_Rotation.controller.script ="0"
	
	refBone.pos.controller.X_Position.controller = float_script ()
	refBone.pos.controller.X_Position.controller.script ="0"
	refBone.pos.controller.Y_Position.controller = float_limit ()
	refBone.pos.controller.Y_Position.controller.upper_limit = 100
	refBone.pos.controller.Y_Position.controller.lower_limit = -100
	refBone.pos.controller.Z_Position.controller = float_script ()
	refBone.pos.controller.Z_Position.controller.script ="0"

	
	refBone.rotation.controller.Y_Rotation.controller = float_script ()
	refBone.rotation.controller.Y_Rotation.controller.script ="0"
	refBone.rotation.controller.Z_Rotation.controller = float_script ()
	refBone.rotation.controller.Z_Rotation.controller.script ="0"
	
	refBone.scale.controller.X_Scale.controller.Bezier_Float *= glbScl
	refBone.scale.controller.Y_Scale.controller.Bezier_Float *= glbScl
	refBone.scale.controller.Z_Scale.controller.Bezier_Float *= glbScl
	
	refBone.scale.controller = scale_script ()
	
	
	FN_addHolderAtt refBone
	
	clavicle = FN_createBox_lmt (upperArm.width*.7) (upperArm.length*.7) ((distance upperArm parentPoint)/glbScl)
	clavicle.parent = parentPoint
	clavicle.transform = parentPoint.transform
	if parentPoint.nodeMirror then
	clavicle.pos.controller.z_position -=parentPoint.parentHolderG[1].node.height
	else
	clavicle.pos.controller.z_position +=parentPoint.parentHolderG[1].node.height
	clavicle.rotation.controller = lookat_constraint ()
	clavicle.rotation.controller.lookat_vector_length = 0
	clavicle.rotation.controller.target_axis = 0
	clavicle.rotation.controller.upnode_ctrl = 0
	clavicle.rotation.controller.StoUP_axis = 1
	clavicle.rotation.controller.upnode_axis = 1
	clavicle.rotation.controller.pickUpNode = refBone
	clavicle.rotation.controller.upnode_world = off
	clavicle.rotation.controller.appendTarget upperArm 100
-- 	if parentPoint.nodeMirror[1] == true then (clavicle.rotation.controller.target_axisFlip = on; clavicle.rotation.controller.StoUP_axisFlip = on;) 
	clavicle.rotation.controller.target_axisFlip = off
	clavicle.rotation.controller.StoUP_axisFlip = off 

	clavicle.scale.controller.Y_Scale.controller.Bezier_Float *= glbScl
	clavicle.scale.controller.Z_Scale.controller.Bezier_Float *= glbScl
	
	clavicle.boneEnable = true
	clavicle.boneFreezeLength=false
	clavicle.boneScaleType = #none
	
	clavicle.height.controller = float_script ()
	clavicle.height.controller.addNode "ths" clavicle
	clavicle.height.controller.addNode "chld" upperArm
	clavicle.height.controller.addNode "rNode" rNode
	clavicle.height.controller.script = "try (distance ths.pos chld.pos)/(rNode.scale.controller.X_Scale/100) catch (0)"
	
	FN_addHolderAtt clavicle
	
	clavicle.rootNodeHolderG =  parentPoint.rootNodeHolderG
	
	clavicle.btnEnableG = #(false,false,false,false,false,true)
	clavicle.rigSectionHolderG = 10
	
	obj = NodeTransformMonitor node:parentPoint forwardTransformChangeMsgs:false
	append clavicle.parentPointHolderG obj
	
	obj = NodeTransformMonitor node:clavicle forwardTransformChangeMsgs:false
	append parentPoint.armBonesHolderG obj
	
	obj = NodeTransformMonitor node:refBone forwardTransformChangeMsgs:false
	append clavicle.clavicleUpHolderG obj
	
	obj = NodeTransformMonitor node:pnt forwardTransformChangeMsgs:false
	append clavicle.clavicleUpHolderG obj
	
	obj = NodeTransformMonitor node:parentPoint forwardTransformChangeMsgs:false
	append refBone.parentPointHolderG obj
	
	refBone.rootNodeHolderG =  parentPoint.rootNodeHolderG
	
	refBone.btnEnableG = #(false,false,true,false,false,false)
	refBone.rigSectionHolderG = 10
	
	refBone.boneEnable = true
	refBone.boneFreezeLength=false
	refBone.boneScaleType = #none
	
-- 	fnTarget.modulNameHolder = "arm"+(fnTarget.rowHolderG as string)
	clavicle.name = fnTarget.parent.name +"_"+ fnTarget.modulNameHolder + "_clavicle"
	refBone.name = clavicle.name + "_upNode"
	pnt.name = refBone.name + "_P"
	
	refBone.showLinks = true
	refBone.showLinksOnly = true
	pnt.showLinks = true
	pnt.showLinksOnly = true
	
	clavicle
	
)
fn FN_createLimbBones fnParent Type:0 =
(
	parentPoint = FN_createPoint()
	parentPoint.parent = fnParent
	parentPoint.transform = fnParent.transform
	parentPoint.rotation.controller.y_rotation = 90
	
	FN_addHolderAtt parentPoint
	
	obj = NodeTransformMonitor node:parentPoint forwardTransformChangeMsgs:false
	append fnParent.moduleArmHolderG obj
	
	
	obj = NodeTransformMonitor node:fnParent forwardTransformChangeMsgs:false
	append parentPoint.parentHolderG obj
	
	parentPoint.rootNodeHolderG =  fnParent.rootNodeHolderG
	
	rNode = fnParent.rootNodeHolderG[1].node
	glbScl = rNode.scale.controller.X_Scale/100
	

	refClavicle = FN_createBox_lmt (fnParent.height*.3) (fnParent.height*.3) (fnParent.width*.6)
	refClavicle.parent = parentPoint
	refClavicle.transform = parentPoint.transform
-- 	refClavicle.rotation.controller.y_rotation = -90
	refClavicle.pos.controller.z_position +=fnParent.height
	
	refClavicle.scale.controller.Y_Scale.controller.Bezier_Float *= glbScl
	refClavicle.scale.controller.Z_Scale.controller.Bezier_Float *= glbScl
	
	refClavicle.boneEnable = true
	refClavicle.boneFreezeLength=false
	refClavicle.boneScaleType = #none
	
		
	upperArm = FN_createBox_lmt (fnParent.width*.2) (fnParent.width*.3) (fnParent.width)
	upperArm.parent = refClavicle
	upperArm.transform = refClavicle.transform
	upperArm.pos.controller.x_position += refClavicle.height
	
	upperArm.parent = parentPoint
	
	callbacks.removeScripts id:#getDelNodes
	delete refClavicle
	callbacks.addScript #nodepreDelete "FNgetDelNodes()" id:#getDelNodes
	
	upperArm.scale.controller.Y_Scale.controller.Bezier_Float *= glbScl
	upperArm.scale.controller.Z_Scale.controller.Bezier_Float *= glbScl
	
		
	upperArm.boneEnable = true
	upperArm.boneFreezeLength=false
	upperArm.boneScaleType = #none
		
	FN_addHolderAtt upperArm
	
	
	upperArm.rootNodeHolderG =  fnParent.rootNodeHolderG
	
	upperArm.btnEnableG = #(false,false,false,false,false,true)
	
	armCount = fnParent.moduleArmHolderG.count
	parentPoint.rowHolderG = armCount
	parentPoint.modulNameHolder = "arm"+(parentPoint.rowHolderG as string)
	upperArm.name = fnParent.name+"_"+parentPoint.modulNameHolder+"_upper" + "1"
		
	---create foreArm
	foreArm = FN_createBox_lmt (upperArm.width*.9) (upperArm.length*.9) (upperArm.height)
	foreArm.parent = upperArm
	foreArm.transform = upperArm.transform
	foreArm.pos.controller.x_position += upperArm.height
	foreArm.rotation.controller.z_rotation -= 2
	
	foreArm.scale.controller.Y_Scale.controller.Bezier_Float *= glbScl
	foreArm.scale.controller.Z_Scale.controller.Bezier_Float *= glbScl
	
	foreArm.boneEnable = true
	foreArm.boneFreezeLength=false
	foreArm.boneScaleType = #none

		
	FN_addHolderAtt foreArm
	
	
	foreArm.rootNodeHolderG =  fnParent.rootNodeHolderG
	
	foreArm.btnEnableG = #(false,false,false,false,false,true)
	
	foreArm.rigSectionHolderG = 3
	
	--- forearm twistbone update hizli çalissin diye upper armlari buna bagliyoruz
	pPointF = FN_createPoint()
	pPointF.parent = foreArm
	pPointF.transform = foreArm.transform
	
	obj = NodeTransformMonitor node:pPointF forwardTransformChangeMsgs:false
	append upperArm.pPointHolderG obj
	
	---create Hand
	
	hand = FN_createBox (foreArm.length*1.3) (foreArm.width*.7) (foreArm.height*.4)
	hand.parent = foreArm
	hand.transform = foreArm.transform
	hand.rotation.controller.x_rotation +=90
	hand.pos.controller.x_position += foreArm.height
	
	hand.scale.controller.X_Scale.controller.Bezier_Float *= glbScl
	hand.scale.controller.Y_Scale.controller.Bezier_Float *= glbScl
	hand.scale.controller.Z_Scale.controller.Bezier_Float *= glbScl
	
	hand.boneEnable = true
	hand.boneFreezeLength=false
	hand.boneScaleType = #none

		
	FN_addHolderAtt hand
	
	
	hand.rootNodeHolderG =  fnParent.rootNodeHolderG
	
	hand.btnEnableG = #(false,false,false,false,false,true)
	
	hand.rigSectionHolderG = 4
	
	--- forearm twistbone update hizli çalissin diye forearmlari buna bagliyoruz
	pPointH = FN_createPoint()
	pPointH.parent = hand
	pPointH.transform = hand.transform
	
	obj = NodeTransformMonitor node:pPointH forwardTransformChangeMsgs:false
	append foreArm.pPointHolderG obj
	
	
	parentPoint.name = fnParent.name+"_"+parentPoint.modulNameHolder+"_armPP"
	
	foreArm.name = fnParent.name+"_"+parentPoint.modulNameHolder+"_lower" + "1"
	pPointF.name = upperArm.name+"_pP"
	
	hand.name = fnParent.name+"_"+parentPoint.modulNameHolder+"_hand"
	pPointH.name = foreArm.name+"_pP"
		
	upperArm.rigSectionHolderG = 3
	
	upperArm.height.controller = float_script ()
	upperArm.height.controller.addNode "ths" upperArm
	upperArm.height.controller.addNode "chld" foreArm
	upperArm.height.controller.addNode "rNode" rNode
	upperArm.height.controller.script = "try (distance ths.pos chld.pos)/(rNode.scale.controller.X_Scale/100) catch (0)"
	
	foreArm.height.controller = float_script ()
	foreArm.height.controller.addNode "ths" foreArm
	foreArm.height.controller.addNode "chld" hand
	foreArm.height.controller.addNode "rNode" rNode
	foreArm.height.controller.script = "try (distance ths.pos chld.pos)/(rNode.scale.controller.X_Scale/100) catch (0)"
	
	--- create pole
	
	poleRefFore = FN_createPoint ()
	poleRefFore.parent = foreArm
	poleRefFore.transform = foreArm.transform
	poleRefFore.pos.controller.x_position += 1
	
	poleRefUpper = FN_createPoint ()
	poleRefUpper.parent = upperArm
	poleRefUpper.transform = upperArm.transform
	poleRefUpper.pos.controller.X_Position.controller = float_script ()
	poleRefUpper.pos.controller.X_Position.controller.addNode "parent" upperArm
	poleRefUpper.pos.controller.X_Position.controller.addNode "chld" foreArm
	poleRefUpper.pos.controller.X_Position.controller.addNode "rNode" rNode
	poleRefUpper.pos.controller.X_Position.controller.script = "try(if (chld != undefined and parent != undefined) then (((distance parent chld)/(rNode.scale.controller.X_Scale/100))-1) else (0))catch(0)"
	
	poleRef = FN_createPoint ()
	poleRef.parent = upperArm
	poleRef.pos.controller = Position_Constraint ()
	poleRef.pos.controller.appendTarget poleRefUpper 50
	poleRef.pos.controller.appendTarget poleRefFore 50
	
	poleRef.rotation.controller = lookat_Constraint ()
	poleRef.rotation.controller.lookat_vector_length = 0
	poleRef.rotation.controller.target_axis = 1
	poleRef.rotation.controller.upnode_ctrl = 1
	poleRef.rotation.controller.StoUP_axis = 2
	poleRef.rotation.controller.upnode_axis = 2
	poleRef.rotation.controller.pickUpNode = upperArm
	poleRef.rotation.controller.upnode_world = off
	poleRef.rotation.controller.appendTarget foreArm 100
	poleRef.scale *= glbScl
	
	poleBone = FN_createBox 5 5 5
	poleBone.parent = poleRef
	poleBone.transform = poleRef.transform
	poleBone.pos.controller.y_position += upperArm.height
	poleBone.pos.controller.Y_Position.controller = float_limit ()
	poleBone.pos.controller.Y_Position.controller.upper_limit = 1000
	poleBone.pos.controller.Y_Position.controller.lower_limit = (foreArm.height)*.2
	poleBone.pos.controller.X_Position.controller = float_limit ()
	poleBone.pos.controller.X_Position.controller.upper_limit = 0
	poleBone.pos.controller.X_Position.controller.lower_limit = 0
	poleBone.pos.controller.Z_Position.controller = float_limit ()
	poleBone.pos.controller.Z_Position.controller.upper_limit = 0
	poleBone.pos.controller.Z_Position.controller.lower_limit = 0
	
	poleBone.scale.controller.X_Scale.controller.Bezier_Float *= glbScl
	poleBone.scale.controller.Y_Scale.controller.Bezier_Float *= glbScl
	poleBone.scale.controller.Z_Scale.controller.Bezier_Float *= glbScl
	
	poleBone.scale.controller = scale_script ()
	
	poleBone.showLinks = true
	poleBone.showLinksOnly = true
	poleRef.showLinks = true
	poleRef.showLinksOnly = true
	
	FN_addHolderAtt poleBone
	FN_addHolderAtt poleRef
	
	poleBone.rootNodeHolderG =  fnParent.rootNodeHolderG
	poleRef.rootNodeHolderG =  fnParent.rootNodeHolderG
	
	poleBone.rigSectionHolderG = 10
	
	poleBone.boneEnable = true
	poleBone.boneFreezeLength=false
	poleBone.boneScaleType = #none

	
	poleBone.name = fnParent.name+"_"+parentPoint.modulNameHolder+"_pole"
	poleRef.name = fnParent.name+"_"+parentPoint.modulNameHolder+"_polePP"
	poleRefUpper.name = fnParent.name+"_"+parentPoint.modulNameHolder+"_poleRefPUpper"
	poleRefFore.name = fnParent.name+"_"+parentPoint.modulNameHolder+"_poleRefPLower"
	
	
	
	obj = NodeTransformMonitor node:parentPoint forwardTransformChangeMsgs:false
	append upperArm.parentPointHolderG obj
	
	obj = NodeTransformMonitor node:parentPoint forwardTransformChangeMsgs:false
	append foreArm.parentPointHolderG obj
	
	obj = NodeTransformMonitor node:parentPoint forwardTransformChangeMsgs:false
	append hand.parentPointHolderG obj
	
	obj = NodeTransformMonitor node:parentPoint forwardTransformChangeMsgs:false
	append poleBone.parentPointHolderG obj
	
	
	
	
	obj = NodeTransformMonitor node:upperArm forwardTransformChangeMsgs:false
	append parentPoint.armBonesHolderG obj
	
	obj = NodeTransformMonitor node:foreArm forwardTransformChangeMsgs:false
	append parentPoint.armBonesHolderG obj
	
	obj = NodeTransformMonitor node:hand forwardTransformChangeMsgs:false
	append parentPoint.armBonesHolderG obj
	
	
	clavicle = FN_addClavicle ParentPoint
	
-- 	obj = NodeTransformMonitor node:clavicle forwardTransformChangeMsgs:false
-- 	append parentPoint.armBonesHolderG obj
-- 	
-- 	obj = NodeTransformMonitor node:parentPoint forwardTransformChangeMsgs:false
-- 	append clavicle.parentPointHolderG obj
	
	
	obj = NodeTransformMonitor node:poleRef forwardTransformChangeMsgs:false
	append parentPoint.armPoleHolderG obj
	
	obj = NodeTransformMonitor node:poleBone forwardTransformChangeMsgs:false
	append parentPoint.armPoleHolderG obj
	
	obj = NodeTransformMonitor node:poleRefUpper forwardTransformChangeMsgs:false
	append parentPoint.armPoleHolderG obj
	
	obj = NodeTransformMonitor node:poleRefFore forwardTransformChangeMsgs:false
	append parentPoint.armPoleHolderG obj
	
	
	
	if Type == 1 then 
		(
			c = FN_createPoint ()
			c.transform = parentPoint.rootNodeHolderG[1].node.transform
			c.parent = parentPoint.rootNodeHolderG[1].node
			c.scale = [1,1,1]
			rotate c (angleaxis 176 [1,0,0])
			c.pos = fnParent.transform.pos
			c.parent = parentPoint
			c.pos.controller.x_position +=fnParent.width/2
			upperArm.transform = c.transform
			upperArm.scale.controller.Y_Scale.controller.Bezier_Float *= glbScl
			upperArm.scale.controller.Z_Scale.controller.Bezier_Float *= glbScl

			delete c
			
-- 			legLength = (((distance parentPoint.rootNodeHolderG[1].node upperArm)/glbScl)-14)
			legLength = (upperArm.pos.z)/glbScl - hand.height*.87
			
			foreArm.pos.controller.x_position = legLength/2
			foreArm.rotation.controller.z_rotation -= 4
			
			hand.pos.controller.x_position = legLength/2
			hand.rotation.controller.x_rotation -=90
			hand.rotation.controller.z_rotation +=45
			hand.scale.controller.X_Scale.controller = float_limit ()
			hand.scale.controller.X_Scale.controller.upper_limit = 1
			hand.scale.controller.X_Scale.controller.lower_limit = 1
			
			handY = hand.width/(hand.scale.controller.Y_Scale.controller.Bezier_Float*.01)
			handZ = hand.length/(hand.scale.controller.Z_Scale.controller.Bezier_Float*.01)
			paramWire.connect hand.scale.controller.Z_Scale.controller[#Bezier_Float] hand.baseObject[#Width] ((handY as string)+"*Bezier_Float")
			paramWire.connect hand.scale.controller.Y_Scale.controller[#Bezier_Float] hand.baseObject[#Length] ((handZ as string)+"*Bezier_Float")
			
			
			
			toe = FN_createBox (hand.width) (hand.length) (hand.height*.7)
			toe.parent = hand
			toe.transform = hand.transform
			toe.pos.controller.x_position += hand.height
			toe.rotation.controller.z_rotation +=47
			
			toe.scale.controller.X_Scale.controller.Bezier_Float *= glbScl
			toe.scale.controller.Y_Scale.controller.Bezier_Float *= glbScl
			toe.scale.controller.Z_Scale.controller.Bezier_Float *= glbScl
			
			toe.boneEnable = true
			toe.boneFreezeLength=false
			toe.boneScaleType = #none
			
			FN_addHolderAtt toe
			
			toe.rootNodeHolderG =  fnParent.rootNodeHolderG
			
			toe.btnEnableG = #(false,false,false,false,false,true)
	
			toe.rigSectionHolderG = 10
			
			-- heel
			
			hp = FN_createPoint ()
			hp.parent = hand
			hp.transform = hand.transform
-- 			hp.pos.controller.x_position -= (hand.height)
-- 			hp.parent = hand
			
			heel = FN_createBox 3 3 3
			heel.parent = toe
			heel.transform = toe.transform
			heel.pos.controller.x_position -= (hand.height)
-- 			heel.objectOffsetPos = [(heel.height/2)*-1, 0, 0]
			heel.parent = hp
			
			heel.scale.controller.X_Scale.controller.Bezier_Float *= glbScl
			heel.scale.controller.Y_Scale.controller.Bezier_Float *= glbScl
			heel.scale.controller.Z_Scale.controller.Bezier_Float *= glbScl
			
			heel.boneEnable = true
			heel.boneFreezeLength=false
			heel.boneScaleType = #none
			
			hp.showLinks = true
			hp.showLinksOnly = true
			heel.showLinks = true
			heel.showLinksOnly = true
			
			FN_addHolderAtt heel
			
			heel.rootNodeHolderG =  fnParent.rootNodeHolderG
			
			heel.btnEnableG = #(false,false,false,false,true,false)
	
			heel.rigSectionHolderG = 10
			
			footIK = FN_createRectangle w:(hand.width*2) l:((hand.height + toe.height)*1.5) build:false
			footIK.parent = toe
			footIK.transform = toe.transform
			footIK.pos.controller.x_position -= ((hand.height + toe.height)/2)-toe.height
			footIK.pos.controller.y_position -= toe.length/2
			footIK.rotation.controller.z_rotation +=90
			ResetTransform footIK
			footIK.parent = hand
			
			footIK.scale.controller.X_Scale.controller.Bezier_Float *= glbScl
			footIK.scale.controller.Z_Scale.controller.Bezier_Float *= glbScl
			
			FN_addHolderAtt footIK
			
			footIK.rootNodeHolderG =  fnParent.rootNodeHolderG
			
			footIK.btnEnableG = #(false,false,false,false,true,false)
	
			footIK.rigSectionHolderG = 10
			
			deleteitem fnParent.moduleArmHolderG fnParent.moduleArmHolderG.count
			
			obj = NodeTransformMonitor node:parentPoint forwardTransformChangeMsgs:false
			append fnParent.moduleLegHolderG obj
			
			
			obj = NodeTransformMonitor node:toe forwardTransformChangeMsgs:false
			append parentPoint.legToeHolderG obj
			
-- 			obj = NodeTransformMonitor node:toe forwardTransformChangeMsgs:false
-- 			append hand.legToeHolderG obj
			
			obj = NodeTransformMonitor node:parentPoint forwardTransformChangeMsgs:false
			append toe.parentPointHolderG obj
			
			obj = NodeTransformMonitor node:heel forwardTransformChangeMsgs:false
			append parentPoint.legToeHolderG obj
			
-- 			obj = NodeTransformMonitor node:heel forwardTransformChangeMsgs:false
-- 			append hand.legToeHolderG obj
			
			obj = NodeTransformMonitor node:parentPoint forwardTransformChangeMsgs:false
			append heel.parentPointHolderG obj
			
			obj = NodeTransformMonitor node:footIK forwardTransformChangeMsgs:false
			append parentPoint.legToeHolderG obj
			
-- 			obj = NodeTransformMonitor node:footIK forwardTransformChangeMsgs:false
-- 			append hand.legToeHolderG obj
			
			obj = NodeTransformMonitor node:parentPoint forwardTransformChangeMsgs:false
			append footIK.parentPointHolderG obj
			
-- 			obj = NodeTransformMonitor node:pPointH forwardTransformChangeMsgs:false
-- 			append parentPoint.legToeHolderG obj
-- 			
-- 			obj = NodeTransformMonitor node:pPointF forwardTransformChangeMsgs:false
-- 			append parentPoint.legToeHolderG obj

			obj = NodeTransformMonitor node:hp forwardTransformChangeMsgs:false
			append parentPoint.legToeHolderG obj
			
-- 			obj = NodeTransformMonitor node:hp forwardTransformChangeMsgs:false
-- 			append hand.legToeHolderG obj
			
			FN_deleteClavicle parentPoint --- clavicle hep sonda olmali
			
			obj = NodeTransformMonitor node:toe forwardTransformChangeMsgs:false
			append parentPoint.armBonesHolderG obj
			
-- 			clavicle = FN_addClavicle ParentPoint

-- 				obj = NodeTransformMonitor node:clavicle forwardTransformChangeMsgs:false
-- 				append parentPoint.armBonesHolderG obj
-- 				
-- 				obj = NodeTransformMonitor node:parentPoint forwardTransformChangeMsgs:false
-- 				append clavicle.parentPointHolderG obj
			
			
			legCount = fnParent.moduleLegHolderG.count
			parentPoint.rowHolderG = legCount
			parentPoint.modulNameHolder = "leg"+(parentPoint.rowHolderG as string)
			
			
			hand.name = fnParent.name+"_"+parentPoint.modulNameHolder+"_foot"
			
			toe.name = hand.name+"_toe"
			
			heel.name = hand.name+"_heel"
			
			hp.name = hand.name+"_heelPoint"
			
			footIK.name = hand.name+"_footIK"
			
			upperArm.name = fnParent.name+"_"+parentPoint.modulNameHolder+"_upper"+ "1"

			foreArm.name = fnParent.name+"_"+parentPoint.modulNameHolder+"_lower"+ "1"
				
-- 			clavicle.name = fnParent.name+"_"+parentPoint.modulNameHolder+"-hipJoint"
			
			parentPoint.name = fnParent.name+"_"+parentPoint.modulNameHolder+"_legPP"
			
			pPointH.name = foreArm.name+"_pPoint"
			
			pPointF.name = upperArm.name+"_pPoint"
			
			poleBone.name = fnParent.name+"_"+parentPoint.modulNameHolder+"_pole"
			poleRef.name = fnParent.name+"_"+parentPoint.modulNameHolder+"_poleParentPoint"
			poleRefUpper.name = fnParent.name+"_"+parentPoint.modulNameHolder+"_poleRefPointUpper"
			poleRefFore.name = fnParent.name+"_"+parentPoint.modulNameHolder+"_poleRefPointlower"
			
			
			hand.height.controller = float_script ()
			hand.height.controller.addNode "ths" hand
			hand.height.controller.addNode "chld" toe
			hand.height.controller.addNode "rNode" rNode
			hand.height.controller.script = "try (distance ths.pos chld.pos)/(rNode.scale.controller.X_Scale/100) catch (0)"
		)
		
		
	select upperArm
		
	parentPoint
)
fn FN_createTwistBones fnTarget fnTwistBoneSpinner=
(
	rNode = fnTarget.rootNodeHolderG[1].node
	glbScl = rNode.scale.controller.X_Scale/100
	
	twistBonesLocal = fnTarget.twistBoneHolderG
	oldVal = twistBonesLocal.count
	newVal = fnTwistBoneSpinner-1
	diffVal = newVal-oldVal
	
	if oldVal  != newVal then
		(
			fnTarget.height.controller = bezier_float ()
			for i = 1 to twistBonesLocal.count do fnTarget.twistBoneHolderG[i].node.height.controller = bezier_float ()
			
			if newVal == 0 then
				(
			-- 			for i = 1 to twistBonesLocal.count do fnTarget.twistBoneHolderG[i].node.height.controller = bezier_float ()
					for i = 1 to twistBonesLocal.count do
					(
					delNodes = #()
					callbacks.removeScripts id:#getDelNodes
					delete (FN_collectDelNodes fnTarget.twistBoneHolderG[fnTarget.twistBoneHolderG.count].node delNodes)
					delete fnTarget.twistBoneHolderG[fnTarget.twistBoneHolderG.count].node
					callbacks.addScript #nodepreDelete "FNgetDelNodes()" id:#getDelNodes
					deleteItem fnTarget.twistBoneHolderG fnTarget.twistBoneHolderG.count
					)
					fnTarget.height.controller = float_script ()
					fnTarget.height.controller.addNode "ths" fnTarget
					fnTarget.height.controller.addNode "chld" fnTarget.pPointHolderG[1].node
					fnTarget.height.controller.addNode "rNode" rNode
					fnTarget.height.controller.script = "try (distance ths.pos chld.pos)/(rNode.scale.controller.X_Scale/100) catch (0)"
					
				)
			
			else if newVal < oldVal then
				(
		-- 				for i = newVal to oldVal do fnTarget.twistBoneHolderG[i].node.height.controller = bezier_float ()
					
					for i = (newVal+1) to oldVal do
						(
						delNodes = #()
						callbacks.removeScripts id:#getDelNodes
						delete (FN_collectDelNodes fnTarget.twistBoneHolderG[fnTarget.twistBoneHolderG.count].node delNodes)
						delete fnTarget.twistBoneHolderG[fnTarget.twistBoneHolderG.count].node
						callbacks.addScript #nodepreDelete "FNgetDelNodes()" id:#getDelNodes
						deleteItem fnTarget.twistBoneHolderG fnTarget.twistBoneHolderG.count
						)
						
					twistBonesLocal = fnTarget.twistBoneHolderG
					for i = 1 to twistBonesLocal.count do
						(
							twistBonesLocal[i].node.pos.controller.X_Position.controller.script = "try ((((distance ths.pos chld.pos)/(rNode.scale.controller.X_Scale/100))/"+((twistBonesLocal.count+1) as string)+")*"+(i as string)+") catch (0)"
						)
					
					twistBones = #()
					append twistBones fnTarget
					for i = 1 to fnTarget.twistBoneHolderG.count do (append twistBones fnTarget.twistBoneHolderG[i].node)
					append twistBones fnTarget.pPointHolderG[1].node
					for i = 1 to (twistBones.count-1) do
					(
					twistBones[i].height.controller = float_script ()
					twistBones[i].height.controller.addNode "ths" twistBones[i]
					twistBones[i].height.controller.addNode "chld" twistBones[i+1]
					twistBones[i].height.controller.addNode "rNode" rNode
					twistBones[i].height.controller.script = "try (distance ths.pos chld.pos)/(rNode.scale.controller.X_Scale/100) catch (0)"
					)
				)
				
			else if newVal > oldVal then
				(
-- 					if fnTarget.parentPointHolderG[1].node.nodeMirror[1] == false then (mrr = 1) else (mrr = -1)
					rNode = fnTarget.rootNodeHolderG[1].node
					glbScl = rNode.scale.controller.X_Scale/100
					twistBones = #()
					twistBoneCount = fnTarget.twistBoneHolderG.count
					
					if fnTarget.twistBoneHolderG.count != 0 then
					(
					for i = 1 to twistBoneCount do append twistBones fnTarget.twistBoneHolderG[i].node
					)
					
					if twistBones.count == 0 then parentTwistBone = fnTarget;
					else parentTwistBone = twistBones[twistBones.count];
					
					for i = (twistBoneCount+2) to fnTwistBoneSpinner do
					(
-- 					twistBone = FN_createBox_lmt (parentTwistBone.width) (parentTwistBone.length) (parentTwistBone.height)
					twistBone = FN_createBox_lmt (parentTwistBone.width/(parentTwistBone.scale.controller.Z_Scale.controller.Bezier_Float/100)) (parentTwistBone.length/(parentTwistBone.scale.controller.Y_Scale.controller.Bezier_Float/100)) (parentTwistBone.height)
					twistBone.parent = fnTarget
					twistBone.transform = fnTarget.transform
					twistBone.pos.controller.x_position = (fnTarget.height/3)*(i-1)
					
					twistBone.pos.controller.X_Position.controller = float_script ()
					twistBone.pos.controller.X_Position.controller.addNode "ths" fnTarget
					twistBone.pos.controller.X_Position.controller.addNode "chld" fnTarget.pPointHolderG[1].node
					twistBone.pos.controller.X_Position.controller.addNode "rNode" rNode
					twistBone.pos.controller.X_Position.controller.script = "try ((((distance ths.pos chld.pos)/(rNode.scale.controller.X_Scale/100))/"+(fnTwistBoneSpinner as string)+")*"+((i-1) as string)+") catch (0)" 
					
					twistBone.scale.controller.Y_Scale.controller.Bezier_Float = parentTwistBone.scale.controller.Y_Scale.controller.Bezier_Float
					twistBone.scale.controller.Z_Scale.controller.Bezier_Float = parentTwistBone.scale.controller.Z_Scale.controller.Bezier_Float

					twistBone.rotation.controller.X_Rotation.controller = float_limit ()
					twistBone.rotation.controller.X_Rotation.controller.upper_limit = 0
					twistBone.rotation.controller.X_Rotation.controller.lower_limit = 0
					twistBone.rotation.controller.Y_Rotation.controller = float_limit ()
					twistBone.rotation.controller.Y_Rotation.controller.upper_limit = 0
					twistBone.rotation.controller.Y_Rotation.controller.lower_limit = 0
					twistBone.rotation.controller.Z_Rotation.controller = float_limit ()
					twistBone.rotation.controller.Z_Rotation.controller.upper_limit = 0
					twistBone.rotation.controller.Z_Rotation.controller.lower_limit = 0
					
					twistBone.boneEnable = true
					twistBone.boneFreezeLength=false
					twistBone.boneScaleType = #none
					
					obj = NodeTransformMonitor node:twistBone forwardTransformChangeMsgs:false
					append fnTarget.twistBoneHolderG obj
					
					append twistBones twistBone
					
					setTransformLockFlags twistBone #{3,2,1}
					
					FN_addHolderAtt twistBone
					
					obj = NodeTransformMonitor node:fnTarget.parentPointHolderG[1].node forwardTransformChangeMsgs:false
					append twistBone.parentPointHolderG obj
					
					twistBone.rootNodeHolderG = fnTarget.rootNodeHolderG
					
					twistBone.btnEnableG = #(false,false,false,false,false,true)
					twistBone.rigSectionHolderG = 3
					
					parentName = replace fnTarget.name fnTarget.name.count 1 ""
					twistBone.name = parentName + (i as string)
						
					)
					
					for i = 1 to twistBones.count do
					(
					twistBones[i].pos.controller.X_Position.controller.script = "try ((((distance ths.pos chld.pos)/(rNode.scale.controller.X_Scale/100))/"+(fnTwistBoneSpinner as string)+")*"+(i as string)+") catch (0)" 
					)
					
					append twistBones fnTarget.pPointHolderG[1].node
					insertItem fnTarget twistBones 1
					for i = 1 to (twistBones.count-1) do
					(
					twistBones[i].height.controller = float_script ()
					twistBones[i].height.controller.addNode "ths" twistBones[i]
					twistBones[i].height.controller.addNode "chld" twistBones[i+1]
					twistBones[i].height.controller.addNode "rNode" rNode
					twistBones[i].height.controller.script = "try (distance ths.pos chld.pos)/(rNode.scale.controller.X_Scale/100) catch (0)"
					)
				)
		)
)
fn FN_createMiddle fnTarget =
(
		
		parentPoint = fnTarget.parentPointHolderG[1].node
		chestBone = fnTarget.parentPointHolderG[1].node.chestHolderG[1].node
		spineBonesLocal = fnTarget.parentPointHolderG[1].node.spineHolderG
		rNode = parentPoint.rootNodeHolderG[1].node
		glbScl = rNode.scale.controller.X_Scale/100
	
		targetBone = spineBonesLocal[(spineBonesLocal.count/2)+1].node
		
				
		pnt = FN_createPoint ()
		pnt.parent = targetBone
		pnt.transform = targetBone.transform
	
		pnt.pos.controller.Y_Position.controller = float_limit ()
		pnt.pos.controller.Y_Position.controller.upper_limit = 0
		pnt.pos.controller.Y_Position.controller.lower_limit = 0
		pnt.pos.controller.Z_Position.controller = float_limit ()
		pnt.pos.controller.Z_Position.controller.upper_limit = 0
		pnt.pos.controller.Z_Position.controller.lower_limit = 0
		
		pnt.rotation.controller.X_rotation.controller = float_limit ()
		pnt.rotation.controller.X_rotation.controller.upper_limit = 0
		pnt.rotation.controller.X_rotation.controller.lower_limit = 0
		pnt.rotation.controller.Y_rotation.controller = float_limit ()
		pnt.rotation.controller.Y_rotation.controller.upper_limit = 0
		pnt.rotation.controller.Y_rotation.controller.lower_limit = 0


		midBone = FN_createBox 5 5 5
		midBone.parent = pnt
		midBone.transform = targetBone.transform
		midBone.pos.controller.y_position -= 20
		midBone.pos.controller.X_Position.controller = float_list ()
		midBone.pos.controller.X_Position.controller.Available.controller = bezier_float ()
		midBone.pos.controller.X_Position.controller.Bezier_Float.controller = float_limit ()
		midBone.pos.controller.X_Position.controller.Float_Limit.controller.lower_limit = 0
		midBone.pos.controller.X_Position.controller.Float_Limit.controller.upper_limit.controller = float_script ()
		midBone.pos.controller.X_Position.controller.Float_Limit.controller.upper_limit.controller.addTarget "uLmt" targetBone.height.controller
		midBone.pos.controller.X_Position.controller.Float_Limit.controller.upper_limit.controller.script = "uLmt"

		paramWire.connect midBone.pos.controller.X_Position.controller[#Float_Limit] midBone.pos.controller.X_Position.controller[#Bezier_Float] "-(Float_Limit)"

		midBone.pos.controller.Y_Position.controller = float_limit ()
		midBone.pos.controller.Y_Position.controller.upper_limit = 0
		midBone.pos.controller.Y_Position.controller.lower_limit = -100
		midBone.pos.controller.Z_Position.controller = float_limit ()
		midBone.pos.controller.Z_Position.controller.upper_limit = 0
		midBone.pos.controller.Z_Position.controller.lower_limit = 0
		
		midBone.rotation.controller.Z_Rotation.controller = float_list ()
		midBone.rotation.controller.Z_Rotation.controller.Available.controller = bezier_float ()
		midBone.rotation.controller.Z_Rotation.controller.Bezier_Float.controller = float_limit ()
		midBone.rotation.controller.Z_Rotation.controller.Float_Limit.controller.upper_limit = 0.785398
		midBone.rotation.controller.Z_Rotation.controller.Float_Limit.controller.lower_limit = -0.785398
		paramWire.connect midBone.rotation.controller.Z_Rotation.controller[#Float_Limit] midBone.rotation.controller.Z_Rotation.controller[#Bezier_Float] "-Float_Limit"
		
		midBone.rotation.controller.X_rotation.controller = float_limit ()
		midBone.rotation.controller.X_rotation.controller.upper_limit = 0
		midBone.rotation.controller.X_rotation.controller.lower_limit = 0
		midBone.rotation.controller.Y_rotation.controller = float_limit ()
		midBone.rotation.controller.Y_rotation.controller.upper_limit = 0
		midBone.rotation.controller.Y_rotation.controller.lower_limit = 0

		
		pnt.position.controller.X_position.controller = midBone.pos.controller.X_Position.controller.Float_Limit.controller
		pnt.rotation.controller.Z_rotation.controller = midBone.rotation.controller.Z_Rotation.controller[1].controller
		if (mod spineBonesLocal.count 2) != 0 then midBone.pos.controller.X_Position.controller.Float_Limit.controller.Limited_Controller__Bezier_Float = targetBone.height/2
		
		
		midBone.scale.controller.X_Scale.controller.Bezier_Float *= glbScl
		midBone.scale.controller.Y_Scale.controller.Bezier_Float *= glbScl
		midBone.scale.controller.Z_Scale.controller.Bezier_Float *= glbScl
		
		midBone.scale.controller = scale_script ()
		
		midBone.showLinks = true
		midBone.showLinksOnly = true
		pnt.showLinks = true
		pnt.showLinksOnly = true
		
		FN_addHolderAtt midBone
		
		midBone.rowHolderG = spineBonesLocal.count/2+1
		
		obj = NodeTransformMonitor node:midBone forwardTransformChangeMsgs:false
		append parentPoint.middleCtrlHolderG obj
		
		obj = NodeTransformMonitor node:pnt forwardTransformChangeMsgs:false
		append parentPoint.middleCtrlHolderG obj
		
		obj = NodeTransformMonitor node:parentPoint forwardTransformChangeMsgs:false
		append midBone.parentPointHolderG obj
		
		midBone.rootNodeHolderG =  parentPoint.rootNodeHolderG
		
		midBone.btnEnableG = #(false,false,true,false,false,false)
		midBone.rigSectionHolderG = 7
		
		midBone.name = chestBone.name+"_middle"
		pnt.name = chestBone.name+"_middleParentPoint"
		
				
)
fn FN_deleteMiddle fnTarget =
(
	parentPoint = fnTarget.parentPointHolderG[1].node
	
	callbacks.removeScripts id:#getDelNodes
	delete parentPoint.middleCtrlHolderG[2].node
	deleteItem parentPoint.middleCtrlHolderG 2
	delete parentPoint.middleCtrlHolderG[1].node
	deleteItem parentPoint.middleCtrlHolderG 1
	callbacks.addScript #nodepreDelete "FNgetDelNodes()" id:#getDelNodes
)
fn FN_changeMiddle fnTarget fnSpinner=
(
	
	parentPoint = fnTarget.parentPointHolderG[1].node
	spineBonesLocal = fnTarget.parentPointHolderG[1].node.spineHolderG

	
	targetBone = spineBonesLocal[fnSpinner].node
	parentPoint.middleCtrlHolderG[2].node.parent = targetBone
	parentPoint.middleCtrlHolderG[2].node.transform = targetBone.transform
	parentPoint.middleCtrlHolderG[1].node.pos.controller.X_Position.controller.Float_Limit.controller.upper_limit.controller = targetBone.height.controller
	parentPoint.middleCtrlHolderG[1].node.rowHolderG = fnSpinner
	
	
)
fn FN_createChainBone fnParent fnBone=
(
-- 	if fnParent.nodeMirror[1] == false then (mrr = 1) else (mrr = -1)
	
	rNode = fnParent.rootNodeHolderG[1].node
	glbScl = rNode.scale.controller.X_Scale/100
	
	pNode = fnParent
	oldVal = pNode.tailBoneHolderG.count
	newVal = fnBone
	
	if newVal > oldVal then
	(
		tailBoneArray = #()
		tailHeight = 0
		newHeight = 0
		if oldVal != 0 then
		(
			for i = 1 to pNode.tailBoneHolderG.count do --parmak sayisi kadar her parmaga alt bone üretilecek
				(
					append tailBoneArray pNode.tailBoneHolderG[i].node; 
					tailHeight += pNode.tailBoneHolderG[i].node.height;
				)
				oldBonesCount = tailBoneArray.count
				parenttail = tailBoneArray[tailBoneArray.count] -- sonuncu bone parent olarak belirlendi
				sizeArray = #(parenttail.width, parenttail.length, (tailHeight/fnBone))
				parentPointCheck = 1
		)
		else 
			(
			parenttail = fnParent
			sizeArray = #((fnParent.parent.length*.5), (fnParent.parent.length*.5), (fnParent.parent.height/fnBone))
			parentPointCheck = 0
			)
		
		for t = (tailBoneArray.count+1) to newVal do -- tailBoneArray sayisinda zaten son bone oldugu için bir ilave ederek sonraki bonlari üretiyoruz 
			(
				tail = FN_createBox sizeArray[1] sizeArray[2] sizeArray[3]
-- 				tail.fillet = .4
				tail.parent = parenttail
				tail.transform = parenttail.transform
				
				if parentPointCheck == 1 then tail.pos.controller.x_position += parenttail.Height
					
							
				tail.scale.controller.X_Scale.controller.Bezier_Float *= glbScl
				tail.scale.controller.Y_Scale.controller.Bezier_Float *= glbScl
				tail.scale.controller.Z_Scale.controller.Bezier_Float *= glbScl
				
				tail.boneEnable = true
				tail.boneFreezeLength=false
				tail.boneScaleType = #none
				
				FN_addHolderAtt tail
				
				obj = NodeTransformMonitor node:tail forwardTransformChangeMsgs:false
				append pNode.tailBoneHolderG obj
				
				obj = NodeTransformMonitor node:pNode forwardTransformChangeMsgs:false
				append tail.parentPointHolderG obj
		
				tail.rootNodeHolderG =  fnParent.rootNodeHolderG
				
				tail.btnEnableG = #(false,false,true,true,false,true)
				
				tail.name = pNode.parent.name+"_"+pNode.modulNameHolder + (t as string)
				
				tail.rigSectionHolderG = 6
				
				append tailBoneArray tail
				
				parenttail = tail
				parentPointCheck = 1
				
			)
		
		if oldVal != 0 then
		(
			for i = oldVal to tailBoneArray.count-1 do
				(
					tailBoneArray[i].height.controller = float_script ()
					tailBoneArray[i].height.controller.addNode "ths" tailBoneArray[i]
					tailBoneArray[i].height.controller.addNode "chld" tailBoneArray[i+1]
					tailBoneArray[i].height.controller.addNode "rNode" rNode
					tailBoneArray[i].height.controller.script = "try (distance ths.pos chld.pos)/(rNode.scale.controller.X_Scale/100) catch (0)"
				)
			
			for t = 1 to oldVal do -- eski bone larin boylari yeni eklem sayisina göre oranlanacak
			(
				newHeight = (tailBoneArray[t].height/(newVal))*oldVal
				tailBoneArray[t+1].pos.controller.x_position = newHeight
			)
		)
		else
		(
			for i = 1 to tailBoneArray.count-1 do
				(
					tailBoneArray[i].height.controller = float_script ()
					tailBoneArray[i].height.controller.addNode "ths" tailBoneArray[i]
					tailBoneArray[i].height.controller.addNode "chld" tailBoneArray[i+1]
					tailBoneArray[i].height.controller.addNode "rNode" rNode
					tailBoneArray[i].height.controller.script = "try (distance ths.pos chld.pos)/(rNode.scale.controller.X_Scale/100) catch (0)"
				)
			
			for t = 1 to oldVal do -- eski bone larin boylari yeni eklem sayisina göre oranlanacak
			(
				newHeight = (tailBoneArray[t].height/(newVal))*oldVal
				tailBoneArray[t+1].pos.controller.x_position = newHeight
			)
		)
	free tailBoneArray
	) 
	
	if newVal < oldVal then
	(
		tailBoneArray = #()
		tailHeight = 0
		rateHeight =0
		newHeight = 0
		difVal = oldVal - newVal
		
		for i = 1 to pNode.tailBoneHolderG.count do --su anki toplam uzunluk
			(
				append tailBoneArray pNode.tailBoneHolderG[i].node; 
				tailHeight += pNode.tailBoneHolderG[i].node.height;
			)
		for i = 1 to newVal do -- kalacaklarin eski uzunluklari. Bunlar yeni uzunlua oranlanacak
			(
				rateHeight += pNode.tailBoneHolderG[i].node.height;
			)
			
			
-- 				for i = newVal to oldVal do tailBoneArray[i].height.controller = bezier_float ()
			
			for i = (newVal+1) to oldVal do -- oldVal sayisinda zaten son bone oldugu için bir ilave ederek sonraki bonlari üretiyoruz 
				(
					deleteItem tailBoneArray tailBoneArray.count
				)
			
			for t = 1 to tailBoneArray.count do -- eski bone larin boylari yeni eklem sayisina göre oranlanacak
			(
				newHeight = (tailBoneArray[t].height/rateHeight)*tailHeight

				if t == tailBoneArray.count then 
				(
					lastOne = tailBoneArray[t]
					try (origHeight = fnParent.parent.height*2/(fnParent.parent.scale.controller.X_Scale.controller.Bezier_Float/100))catch(origHeight =fnParent.parent.height*2)
					lastOne.scale.controller.X_Scale.controller.Bezier_Float = (newHeight/origHeight)*100
					paramText = (origHeight as string)+"*Bezier_Float"
					paramWire.connect lastOne.scale.controller.X_Scale.controller[#Bezier_Float] lastOne.baseObject[#Height] paramText
				)
				else tailBoneArray[t+1].pos.controller.x_position = newHeight
			)
			for i = (newVal+1) to oldVal do -- oldVal sayisinda zaten son bone oldugu için bir ilave ederek sonraki bonlari üretiyoruz 
				(
					delNodes = #()
					callbacks.removeScripts id:#getDelNodes
					delete (FN_collectDelNodes pNode.tailBoneHolderG[pNode.tailBoneHolderG.count].node delNodes)
					delete  pNode.tailBoneHolderG[pNode.tailBoneHolderG.count].node
					callbacks.addScript #nodepreDelete "FNgetDelNodes()" id:#getDelNodes
					deleteItem  pNode.tailBoneHolderG  pNode.tailBoneHolderG.count
				)

		
	free tailBoneArray
	)

	
)
fn FN_createChain fnTarget=
(
	rNode = fnTarget.rootNodeHolderG[1].node
	glbScl = rNode.scale.controller.X_Scale/100
	
	
	parentPoint = FN_createPoint()
	parentPoint.parent = fnTarget
	parentPoint.transform = fnTarget.transform
	
	FN_addHolderAtt parentPoint
	
	obj = NodeTransformMonitor node:parentPoint forwardTransformChangeMsgs:false
	append fnTarget.moduleTailHolderG obj
	
	obj = NodeTransformMonitor node:fnTarget forwardTransformChangeMsgs:false
	append parentPoint.parentHolderG obj
	
	
	parentPoint.rootNodeHolderG =  fnTarget.rootNodeHolderG
	parentPoint.nodeMirror = fnTarget.parentPointHolderG[1].node.nodeMirror
	
	parentPoint.rowHolderG = fnTarget.moduleTailHolderG.count
	
	parentPoint.name = fnTarget.name+"_chainParentPoint" + (parentPoint.rowHolderG as string)
	parentPoint.modulNameHolder = "chain" +(parentPoint.rowHolderG as string)
	
	FN_createChainBone parentPoint 1 
	
	select parentPoint.tailBoneHolderG[1].node
	
	parentPoint.tailBoneHolderG[1].node
)
fn FN_createFBone fnParent fnBone=
(
-- 	if fnParent.nodeMirror[1] == false then (mrr = 1) else (mrr = -1)
	rNode = fnParent.rootNodeHolderG[1].node
	glbScl = rNode.scale.controller.X_Scale/100
	
	pNode = fnParent
	oldVal = pNode.fingerBoneHolderG.count
	newVal = fnBone
	
	if newVal > oldVal then
	(
		fingerBoneArray = #()
		fingerHeight = 0
		newHeight = 0
		if oldVal != 0 then
		(
			for i = 1 to pNode.fingerBoneHolderG.count do --parmak sayisi kadar her parmaga alt bone üretilecek
				(
					append fingerBoneArray pNode.fingerBoneHolderG[i].node; 
					fingerHeight += pNode.fingerBoneHolderG[i].node.height;
				)
				oldBonesCount = fingerBoneArray.count
				parentFinger = fingerBoneArray[fingerBoneArray.count] -- sonuncu bone parent olarak belirlendi
				sizeArray = #(parentFinger.width, parentFinger.length, (fingerHeight/fnBone))
				parentPointCheck = 1
		)
		else 
			(
				parentFinger = fnParent
				sizeArray = #((fnParent.parent.length*.8), (fnParent.parent.length*.8), (fnParent.parent.height*1.2/fnBone))
				parentPointCheck = 0
			)
		
		for t = (fingerBoneArray.count+1) to newVal do -- fingerBoneArray sayisinda zaten son bone oldugu için bir ilave ederek sonraki bonlari üretiyoruz 
			(
				finger = FN_createBox sizeArray[1] sizeArray[2] sizeArray[3]
-- 				finger.fillet = .4
				finger.parent = parentFinger
				finger.transform = parentFinger.transform
				if parentPointCheck == 1 then finger.pos.controller.x_position += parentFinger.Height
							
				finger.scale.controller.X_Scale.controller.Bezier_Float *= glbScl
				finger.scale.controller.Y_Scale.controller.Bezier_Float *= glbScl
				finger.scale.controller.Z_Scale.controller.Bezier_Float *= glbScl
				
				finger.boneEnable = true
				finger.boneFreezeLength=false
				finger.boneScaleType = #none
				
				FN_addHolderAtt finger
				finger.isFinger= true
				
				obj = NodeTransformMonitor node:finger forwardTransformChangeMsgs:false
				append pNode.fingerBoneHolderG obj
				
				obj = NodeTransformMonitor node:pNode forwardTransformChangeMsgs:false
				append finger.parentPointHolderG obj
		
				finger.rootNodeHolderG =  fnParent.rootNodeHolderG
				
				finger.btnEnableG = #(false,false,false,false,false,true)
				
				finger.name = pNode.parent.name+"_finger"+(pNode.rowHolderG as string) + (t as string)
				
				finger.rigSectionHolderG = 5
				
				append fingerBoneArray finger
				
				parentFinger = finger
				parentPointCheck = 1
				
			)
		
		if oldVal != 0 then
		(
			for i = oldVal to fingerBoneArray.count-1 do
				(
					fingerBoneArray[i].height.controller = float_script ()
					fingerBoneArray[i].height.controller.addNode "ths" fingerBoneArray[i]
					fingerBoneArray[i].height.controller.addNode "chld" fingerBoneArray[i+1]
					fingerBoneArray[i].height.controller.addNode "rNode" rNode
					fingerBoneArray[i].height.controller.script = "try (distance ths.pos chld.pos)/(rNode.scale.controller.X_Scale/100) catch (0)"
				)
			
			for t = 1 to oldVal do -- eski bone larin boylari yeni eklem sayisina göre oranlanacak
			(
				newHeight = (fingerBoneArray[t].height/(newVal))*oldVal
				fingerBoneArray[t+1].pos.controller.x_position = newHeight
			)
		)
		else
		(
			for i = 1 to fingerBoneArray.count-1 do
				(
					fingerBoneArray[i].height.controller = float_script ()
					fingerBoneArray[i].height.controller.addNode "ths" fingerBoneArray[i]
					fingerBoneArray[i].height.controller.addNode "chld" fingerBoneArray[i+1]
					fingerBoneArray[i].height.controller.addNode "rNode" rNode
					fingerBoneArray[i].height.controller.script = "try (distance ths.pos chld.pos)/(rNode.scale.controller.X_Scale/100) catch (0)"
				)
			
			for t = 1 to oldVal do -- eski bone larin boylari yeni eklem sayisina göre oranlanacak
			(
				newHeight = (fingerBoneArray[t].height/(newVal))*oldVal
				fingerBoneArray[t+1].pos.controller.x_position = newHeight
			)
		)
	free fingerBoneArray
	) 
	
	if newVal < oldVal then
	(
		fingerBoneArray = #()
		fingerHeight = 0
		newHeight = 0
		rateHeight =0
		difVal = oldVal - newVal
		
		for i = 1 to pNode.fingerBoneHolderG.count do --parmak sayisi kadar her parmaga alt bone üretilecek
			(
				append fingerBoneArray pNode.fingerBoneHolderG[i].node; 
				fingerHeight += pNode.fingerBoneHolderG[i].node.height;
			)
		for i = 1 to newVal do -- kalacaklarin eski uzunluklari. Bunlar yeni uzunlua oranlanacak
		(
			rateHeight += pNode.fingerBoneHolderG[i].node.height;
		)
			
		if newVal != 0 then
			(
-- 				for i = newVal to oldVal do fingerBoneArray[i].height.controller = bezier_float ()
			
			for i = (newVal+1) to oldVal do -- oldVal sayisinda zaten son bone oldugu için bir ilave ederek sonraki bonlari üretiyoruz 
				(
					deleteItem fingerBoneArray fingerBoneArray.count
				)
			
			for t = 1 to fingerBoneArray.count do -- eski bone larin boylari yeni eklem sayisina göre oranlanacak
			(
				newHeight = (fingerBoneArray[t].height/rateHeight)*fingerHeight
				
				if t == fingerBoneArray.count then 
				(
					lastOne = fingerBoneArray[t]
					origHeight = (fnParent.parent.height*1.2)/(fnParent.parent.scale.controller.X_Scale.controller.Bezier_Float/100)
					lastOne.scale.controller.X_Scale.controller.Bezier_Float = (newHeight/origHeight)*100
					paramText = (origHeight as string)+"*Bezier_Float"
					paramWire.connect lastOne.scale.controller.X_Scale.controller[#Bezier_Float] lastOne.baseObject[#Height] paramText
				)
				else fingerBoneArray[t+1].pos.controller.x_position = newHeight
			)
			for i = (newVal+1) to oldVal do -- oldVal sayisinda zaten son bone oldugu için bir ilave ederek sonraki bonlari üretiyoruz 
				(
					delNodes = #()
					callbacks.removeScripts id:#getDelNodes
					delete (FN_collectDelNodes pNode.fingerBoneHolderG[pNode.fingerBoneHolderG.count].node delNodes)
					delete  pNode.fingerBoneHolderG[pNode.fingerBoneHolderG.count].node
					callbacks.addScript #nodepreDelete "FNgetDelNodes()" id:#getDelNodes
					deleteItem  pNode.fingerBoneHolderG  pNode.fingerBoneHolderG.count
				)
		)
		else
		(
-- 				for i = 1 to fingerBoneArray.count do fingerBoneArray[i].height.controller = bezier_float ()
			
			for i = 1 to oldVal do -- oldVal sayisinda zaten son bone oldugu için bir ilave ederek sonraki bonlari üretiyoruz 
				(
					delNodes = #()
					callbacks.removeScripts id:#getDelNodes
					delete (FN_collectDelNodes pNode.fingerBoneHolderG[pNode.fingerBoneHolderG.count].node delNodes)
					delete  pNode.fingerBoneHolderG[pNode.fingerBoneHolderG.count].node
					callbacks.addScript #nodepreDelete "FNgetDelNodes()" id:#getDelNodes
					deleteItem  pNode.fingerBoneHolderG  pNode.fingerBoneHolderG.count
				)
		)
		
	free fingerBoneArray
	)
	pNode.fingerBoneCountHolderG = fnBone
	
)
fn FN_createFinger fnParent fnFinger fnBone=
(
	fnParent.fingerBoneCountHolderG = fnBone
	rNode = fnParent.rootNodeHolderG[1].node
	glbScl = rNode.scale.controller.X_Scale/100
	
	oldVal = fnParent.moduleFingerHolderG.count
	newVal = fnFinger
	
	
	if fnParent.parent.parentPointHolderG[1].node.legToeHolderG.count != 0 then (pNode = fnParent.parent.parentPointHolderG[1].node.legToeHolderG[1].node) else (pNode = fnParent)
	
	if newVal == oldVal then
	(
		for t =1 to oldVal do
		(
			FN_createFBone fnParent.moduleFingerHolderG[t].node fnBone
			if fnParent.parent.parentPointHolderG[1].node.legToeHolderG.count == 0 then
			(
				if fnParent.parentPointHolderG[1].node.nodeMirror then
				(
				fnParent.moduleFingerHolderG[t].node.pos.controller.script ="b =((posZ/fingCount)*row)-(posZ/2)-((posZ/fingCount)/2);[posX, 0, b]"
				)
				else
				fnParent.moduleFingerHolderG[t].node.pos.controller.script ="b =((posZ/fingCount)*row)-(posZ/2)-((posZ/fingCount)/2);[posX, 0, -b]"
			)
			else
			(
				if fnParent.parentPointHolderG[1].node.nodeMirror then
				fnParent.moduleFingerHolderG[t].node.pos.controller.script ="b =((posZ/fingCount)*row)-(posZ/2)-((posZ/fingCount)/2);[0, 0, b]"
				else
				fnParent.moduleFingerHolderG[t].node.pos.controller.script ="b =((posZ/fingCount)*row)-(posZ/2)-((posZ/fingCount)/2);[0, 0, -b]"
			)
		)
	)
	
	if newVal > oldVal then
	(
		if oldVal != 0 then -- 0 sa editlenecek ilk bone yok demektir
		(
			for t=1 to oldVal do
				(
					if fnParent.parent.parentPointHolderG[1].node.legToeHolderG.count == 0 then
					(
						fnParent.moduleFingerHolderG[t].node.pos.controller.addConstant "fingCount" fnFinger
						fnParent.moduleFingerHolderG[t].node.pos.controller.addConstant "row" t
						if fnParent.parentPointHolderG[1].node.nodeMirror then
						(
						fnParent.moduleFingerHolderG[t].node.pos.controller.script ="b =((posZ/fingCount)*row)-(posZ/2)-((posZ/fingCount)/2);[posX, 0, b]"
						)
						else
						fnParent.moduleFingerHolderG[t].node.pos.controller.script ="b =((posZ/fingCount)*row)-(posZ/2)-((posZ/fingCount)/2);[posX, 0, -b]"
					)
					else
					(
						fnParent.moduleFingerHolderG[t].node.pos.controller.addConstant "fingCount" fnFinger
						fnParent.moduleFingerHolderG[t].node.pos.controller.addConstant "row" t
						if fnParent.parentPointHolderG[1].node.nodeMirror then
						fnParent.moduleFingerHolderG[t].node.pos.controller.script ="b =((posZ/fingCount)*row)-(posZ/2)-((posZ/fingCount)/2);[0, 0, b]"
						else
						fnParent.moduleFingerHolderG[t].node.pos.controller.script ="b =((posZ/fingCount)*row)-(posZ/2)-((posZ/fingCount)/2);[0, 0, -b]"
					)
				)
		)
		if fnParent.parent.parentPointHolderG[1].node.legToeHolderG.count != 0 do fnParent.parent.parentPointHolderG[1].node.legToeHolderG[1].node.boxmode = on
		for t = (oldVal+1) to newVal do --- +1 çünkü 0 için tekrar bone üretmesin
			(
				parentPoint = FN_createPoint()
				parentPoint.parent = pNode
				parentPoint.transform = pNode.transform
				if fnParent.parent.parentPointHolderG[1].node.legToeHolderG.count == 0 then
				(
					parentPoint.pos.controller.x_position +=pNode.height
					parentPoint.pos.controller.z_position +=((pNode.width/fnFinger)*t)-(pNode.width/2)-((pNode.width/fnFinger)/2)
					parentPoint.pos.controller = position_script ()
					parentPoint.pos.controller.addTarget "posX" pNode.height.controller
					parentPoint.pos.controller.addTarget "posZ" pNode.width.controller
					parentPoint.pos.controller.addConstant "fingCount" fnFinger
					parentPoint.pos.controller.addConstant "row" t
					if fnParent.parentPointHolderG[1].node.nodeMirror then
					parentPoint.pos.controller.script ="b =((posZ/fingCount)*row)-(posZ/2)-((posZ/fingCount)/2);[posX, 0, b]"
					else
					parentPoint.pos.controller.script ="b =((posZ/fingCount)*row)-(posZ/2)-((posZ/fingCount)/2);[posX, 0, -b]"
				)
				else
				(
					parentPoint.pos.controller.z_position +=((pNode.width/fnFinger)*t)-(pNode.width/2)-((pNode.width/fnFinger)/2)
					parentPoint.pos.controller = position_script ()
					parentPoint.pos.controller.addTarget "posZ" pNode.width.controller
					parentPoint.pos.controller.addConstant "fingCount" fnFinger
					parentPoint.pos.controller.addConstant "row" t
					if fnParent.parentPointHolderG[1].node.nodeMirror then
						parentPoint.pos.controller.script ="b =((posZ/fingCount)*row)-(posZ/2)-((posZ/fingCount)/2);[0, 0, b]"
					else
						parentPoint.pos.controller.script ="b =((posZ/fingCount)*row)-(posZ/2)-((posZ/fingCount)/2);[0, 0, -b]"
				)
				
				FN_addHolderAtt parentPoint
				
				parentPoint.fingerBoneCountHolderG = fnBone
				
				
				obj = NodeTransformMonitor node:parentPoint forwardTransformChangeMsgs:false
				append fnParent.moduleFingerHolderG obj
				
				obj = NodeTransformMonitor node:fnParent forwardTransformChangeMsgs:false
				append parentPoint.parentPointHolderG obj
				
				parentPoint.rowHolderG = t
				
				parentPoint.rootNodeHolderG =  fnParent.rootNodeHolderG
				parentPoint.nodeMirror = fnParent.parentPointHolderG[1].node.nodeMirror
				
				tempParent = parentPoint -- ilk bone pointe baglanir. ilk üretimdden sonra tempParent üretilen bona atanir ki dgerleri de sirayla bi oncekine baglansin 
				
				parentPoint.name = fnParent.name+"_fingerParentPoint"+(t as string)
				
				FN_createFBone fnParent.moduleFingerHolderG[t].node fnBone
			)
			
			
	)
	if newVal < oldVal then
	(
		if newVal !=0 then
		(
		for t=1 to newVal do
			(
				if fnParent.parent.parentPointHolderG[1].node.legToeHolderG.count == 0 then
				(
					fnParent.moduleFingerHolderG[t].node.pos.controller.addConstant "fingCount" fnFinger
					fnParent.moduleFingerHolderG[t].node.pos.controller.addConstant "row" t
					if fnParent.parentPointHolderG[1].node.nodeMirror then
					fnParent.moduleFingerHolderG[t].node.pos.controller.script ="b =((posZ/fingCount)*row)-(posZ/2)-((posZ/fingCount)/2);[posX, 0, -b]"
					else
					fnParent.moduleFingerHolderG[t].node.pos.controller.script ="b =((posZ/fingCount)*row)-(posZ/2)-((posZ/fingCount)/2);[posX, 0, b]"
				)
				else
				(
					fnParent.moduleFingerHolderG[t].node.pos.controller.addConstant "fingCount" fnFinger
					fnParent.moduleFingerHolderG[t].node.pos.controller.addConstant "row" t
					if fnParent.parentPointHolderG[1].node.nodeMirror then
					fnParent.moduleFingerHolderG[t].node.pos.controller.script ="b =((posZ/fingCount)*row)-(posZ/2)-((posZ/fingCount)/2);[0, 0, -b]"
					else
					fnParent.moduleFingerHolderG[t].node.pos.controller.script ="b =((posZ/fingCount)*row)-(posZ/2)-((posZ/fingCount)/2);[0, 0, b]"
				)
			)
		)
		if ((fnParent.parent.parentPointHolderG[1].node.legToeHolderG.count != 0) and (newVal == 0)) do fnParent.parent.parentPointHolderG[1].node.legToeHolderG[1].node.boxmode = off
		for i=(newVal+1) to oldVal do
		(
			FN_createFBone fnParent.moduleFingerHolderG[fnParent.moduleFingerHolderG.count].node 0
			callbacks.removeScripts id:#getDelNodes
			delete fnParent.moduleFingerHolderG[fnParent.moduleFingerHolderG.count].node
			deleteItem fnParent.moduleFingerHolderG fnParent.moduleFingerHolderG.count
			callbacks.addScript #nodepreDelete "FNgetDelNodes()" id:#getDelNodes
		)
	)
)
fn FN_copyChain fnTarget =
(
	copytailCheck = 1
	tailsPosArray = #()
	tailsCount = fnTarget.tailBoneHolderG.count
	
	targetTM = fnTarget.transform.controller.value
	 
	mrTail = fntarget.nodemirror
	tailOffsets=#()
	
	append tailsPosArray tailsCount
	for i = 1 to tailsCount do
	(
		tailOffset=#()
		append tailsPosArray fnTarget.tailBoneHolderG[i].node.transform.controller.value

		append tailsPosArray (fnTarget.tailBoneHolderG[i].node.baseObject[#length].getExprText 1)
		append tailsPosArray fnTarget.tailBoneHolderG[i].node.scale.controller.Y_Scale.controller.Bezier_Float
		append tailsPosArray (fnTarget.tailBoneHolderG[i].node.baseObject[#width].getExprText 1)
		append tailsPosArray fnTarget.tailBoneHolderG[i].node.scale.controller.Z_Scale.controller.Bezier_Float
		
		append tailOffset fnTarget.tailBoneHolderG[i].node.objectOffsetPos
		append tailOffset fnTarget.tailBoneHolderG[i].node.objectOffsetRot
		append tailOffset fnTarget.tailBoneHolderG[i].node.objectOffsetScale
		append tailOffsets tailOffset
		if i == tailsCount then 
		(
			append tailsPosArray (fnTarget.tailBoneHolderG[i].node.baseObject[#height].getExprText 1)
			append tailsPosArray fnTarget.tailBoneHolderG[fnTarget.tailBoneHolderG.count].node.scale.controller.X_Scale.controller.Bezier_Float
		)
	)
	tailsPosArray
	
)
fn FN_pasteChain fnTarget fnArray PmAxis:false=
(
	
	FN_createChainBone fnTarget fnArray[1]
	t = 2
	for i = 1 to fnTarget.tailBoneHolderG.count do
	(
		fnTarget.tailBoneHolderG[i].node.transform.controller.value = fnArray[t]
		t += 1
		fnTarget.tailBoneHolderG[i].node.baseObject[#length].setExprText 1 fnArray[t]
		t += 1
		fnTarget.tailBoneHolderG[i].node.scale.controller.Y_Scale.controller.Bezier_Float = fnArray[t]
		t += 1
		fnTarget.tailBoneHolderG[i].node.baseObject[#width].setExprText 1 fnArray[t]
		t += 1
		fnTarget.tailBoneHolderG[i].node.scale.controller.Z_Scale.controller.Bezier_Float = fnArray[t]
		t += 1
		if i == fnTarget.tailBoneHolderG.count then 
			(
				fnTarget.tailBoneHolderG[i].node.baseObject[#height].setExprText 1 fnArray[t]
				t += 1
				fnTarget.tailBoneHolderG[fnTarget.tailBoneHolderG.count].node.scale.controller.X_Scale.controller.Bezier_Float = fnArray[t]
				t += 1
			)
			
		if PmAxis then
		(
			tr =quatToEuler	tailOffsets[i][2]
			tr.x *=  -1;
			tr.y *=  -1;
			te = eulerToQuat tr
			fnTarget.tailBoneHolderG[i].node.objectOffsetRot = te
			
			fnTarget.tailBoneHolderG[i].node.objectOffsetScale = tailOffsets[i][3]*[1,1,-1]
			fnTarget.tailBoneHolderG[i].node.objectOffsetPos = tailOffsets[i][1]*[1,1,-1]
			
			fntarget.nodemirror = not mrTail
			fnTarget.tailBoneHolderG[i].node.transform = mirrorMatrixFn axis:"z" tm:fnTarget.tailBoneHolderG[i].node.transform pivottm:fnTarget.tailBoneHolderG[i].node.parent.transform	
		)
		else
		(
			fnTarget.tailBoneHolderG[i].node.objectOffsetPos = tailOffsets[i][1]
			fnTarget.tailBoneHolderG[i].node.objectOffsetRot = tailOffsets[i][2]
			fnTarget.tailBoneHolderG[i].node.objectOffsetScale = tailOffsets[i][3]
			
			fnTarget.transform.controller.value = targetTM
			fntarget.nodemirror = mrTail
		)
	)
	instantRigFloater.rollouts[5].tailBoneCount.value = fnArray[1]
)
fn FN_copyFinger fnTarget =
(
	mrFinger = fnTarget.parent.parentPointHolderG[1].node.nodeMirror

	copyFingerCheck = 1
	fingersPosArray = #()
	fingersCount = fnTarget.fingerBoneHolderG.count
	
	fingerOffsets=#()
	
	returnArray = #()
	
	append fingersPosArray fingersCount
	for i = 1 to fingersCount do
	(
		fingerOffset=#()
		
		append fingersPosArray fnTarget.fingerBoneHolderG[i].node.fingerBoneCountHolderG
		append fingersPosArray #(fnTarget.fingerBoneHolderG[i].node.transform, fnTarget.fingerBoneHolderG[i].node.transform.controller.value)
		append fingersPosArray (fnTarget.fingerBoneHolderG[i].node.baseObject[#length].getExprText 1)
		append fingersPosArray fnTarget.fingerBoneHolderG[i].node.scale.controller.Y_Scale.controller.Bezier_Float
		append fingersPosArray (fnTarget.fingerBoneHolderG[i].node.baseObject[#width].getExprText 1)
		append fingersPosArray fnTarget.fingerBoneHolderG[i].node.scale.controller.Z_Scale.controller.Bezier_Float
		
		append fingerOffset fnTarget.fingerBoneHolderG[i].node.objectOffsetPos
		append fingerOffset fnTarget.fingerBoneHolderG[i].node.objectOffsetRot
		append fingerOffset fnTarget.fingerBoneHolderG[i].node.objectOffsetScale
		append fingerOffsets fingerOffset
		if i == fingersCount then 
		(
			append fingersPosArray (fnTarget.fingerBoneHolderG[i].node.baseObject[#height].getExprText 1)
			append fingersPosArray fnTarget.fingerBoneHolderG[fnTarget.fingerBoneHolderG.count].node.scale.controller.X_Scale.controller.Bezier_Float
		)
	)
	append returnArray fingersPosArray
	append returnArray fingerOffsets
	
	returnArray
)
fn FN_pasteFinger fnTarget fnArray rollUpdate:0=
(
	FN_createFBone fnTarget fnArray[1][1]
	t = 2
	for i = 1 to fnTarget.fingerBoneHolderG.count do
	(
		fnTarget.fingerBoneHolderG[i].node.fingerBoneCountHolderG = t
		t += 1
		
		fnTarget.fingerBoneHolderG[i].node.transform.controller.value = fnArray[1][t][2]
		if mrFinger != fnTarget.parent.parentPointHolderG[1].node.nodeMirror then
		(
			fnTarget.fingerBoneHolderG[i].node.transform = mirrorMatrixFn axis:"z" tm:fnTarget.fingerBoneHolderG[i].node.transform pivottm:fnTarget.fingerBoneHolderG[i].node.parent.transform
			
			tr =quatToEuler	fnArray[2][i][2]
			tr.x *=  -1;
			tr.y *=  -1;
			te = eulerToQuat tr
			fnTarget.fingerBoneHolderG[i].node.objectOffsetRot = te
			
			fnTarget.fingerBoneHolderG[i].node.objectOffsetScale = fnArray[2][i][3]*[1,1,-1]
			fnTarget.fingerBoneHolderG[i].node.objectOffsetPos = fnArray[2][i][1]*[1,1,-1]
		)
		else
		(
			fnTarget.fingerBoneHolderG[i].node.objectOffsetPos = fnArray[2][i][1]
			fnTarget.fingerBoneHolderG[i].node.objectOffsetRot = fnArray[2][i][2]
			fnTarget.fingerBoneHolderG[i].node.objectOffsetScale = fnArray[2][i][3]
		)

		t += 1
		fnTarget.fingerBoneHolderG[i].node.baseObject[#length].setExprText 1 fnArray[1][t]
		t += 1
		fnTarget.fingerBoneHolderG[i].node.scale.controller.Y_Scale.controller.Bezier_Float = fnArray[1][t]
		t += 1
		fnTarget.fingerBoneHolderG[i].node.baseObject[#width].setExprText 1 fnArray[1][t]
		t += 1
		fnTarget.fingerBoneHolderG[i].node.scale.controller.Z_Scale.controller.Bezier_Float = fnArray[1][t]
		t += 1
		if i == fnTarget.fingerBoneHolderG.count then 
			(
				fnTarget.fingerBoneHolderG[i].node.baseObject[#height].setExprText 1 fnArray[1][t]
				t += 1
				fnTarget.fingerBoneHolderG[fnTarget.fingerBoneHolderG.count].node.scale.controller.X_Scale.controller.Bezier_Float = fnArray[1][t]
				t += 1
			)
	)
	if rollUpdate == 1 then
	(
		instantRigFloater.rollouts[4].fingerBoneCount.value = fnArray[1][1]
	)
)
fn FN_copyHand fnTarget =
(
	copyHandCheck = 1
	mrHand = fnTarget.parent.parentPointHolderG[1].node.nodeMirror
	handPosArray = #()
	HandFingersArray = #()
	handFingersCount = fnTarget.moduleFingerHolderG.count
	
	append handPosArray fnTarget.fingerBoneCountHolderG
	append handPosArray fnTarget.transform.controller.value
	
	append handPosArray fnTarget.objectOffsetPos
	append handPosArray fnTarget.objectOffsetRot
	append handPosArray fnTarget.objectOffsetScale

	append handPosArray (fnTarget.baseObject[#length].getExprText 1)
	append handPosArray fnTarget.scale.controller.Y_Scale.controller.Bezier_Float
	append handPosArray (fnTarget.baseObject[#width].getExprText 1)
	append handPosArray fnTarget.scale.controller.Z_Scale.controller.Bezier_Float
	
	if fnTarget.parent.parentPointHolderG[1].node.legToeHolderG.count == 0 then 
	(
		append handPosArray (fnTarget.baseObject[#height].getExprText 1)
		append handPosArray fnTarget.scale.controller.X_Scale.controller.Bezier_Float
		toeCheck = 0
	)
	else 
	(
		toeCheck = 1
		append handPosArray fnTarget.parent.parentPointHolderG[1].node.legToeHolderG[1].node.fingerBoneCountHolderG
		append handPosArray fnTarget.parent.parentPointHolderG[1].node.legToeHolderG[1].node.transform.controller.value
		append handPosArray (fnTarget.parent.parentPointHolderG[1].node.legToeHolderG[1].node.baseObject[#length].getExprText 1)
		append handPosArray fnTarget.parent.parentPointHolderG[1].node.legToeHolderG[1].node.scale.controller.Y_Scale.controller.Bezier_Float
		append handPosArray (fnTarget.parent.parentPointHolderG[1].node.legToeHolderG[1].node.baseObject[#width].getExprText 1)
		append handPosArray fnTarget.parent.parentPointHolderG[1].node.legToeHolderG[1].node.scale.controller.Z_Scale.controller.Bezier_Float
		append handPosArray (fnTarget.parent.parentPointHolderG[1].node.legToeHolderG[1].node.baseObject[#height].getExprText 1)
		append handPosArray fnTarget.parent.parentPointHolderG[1].node.legToeHolderG[1].node.scale.controller.X_Scale.controller.Bezier_Float
		append handPosArray fnTarget.parent.parentPointHolderG[1].node.legToeHolderG[1].node.objectOffsetPos
		append handPosArray fnTarget.parent.parentPointHolderG[1].node.legToeHolderG[1].node.objectOffsetRot
		append handPosArray fnTarget.parent.parentPointHolderG[1].node.legToeHolderG[1].node.objectOffsetScale
		
		append handPosArray fnTarget.parent.parentPointHolderG[1].node.legToeHolderG[2].node.transform.controller.value
		append handPosArray (fnTarget.parent.parentPointHolderG[1].node.legToeHolderG[2].node.baseObject[#length].getExprText 1)
		append handPosArray fnTarget.parent.parentPointHolderG[1].node.legToeHolderG[2].node.scale.controller.Y_Scale.controller.Bezier_Float
		append handPosArray (fnTarget.parent.parentPointHolderG[1].node.legToeHolderG[2].node.baseObject[#width].getExprText 1)
		append handPosArray fnTarget.parent.parentPointHolderG[1].node.legToeHolderG[2].node.scale.controller.Z_Scale.controller.Bezier_Float
		append handPosArray (fnTarget.parent.parentPointHolderG[1].node.legToeHolderG[2].node.baseObject[#height].getExprText 1)
		append handPosArray fnTarget.parent.parentPointHolderG[1].node.legToeHolderG[2].node.scale.controller.X_Scale.controller.Bezier_Float
		append handPosArray fnTarget.parent.parentPointHolderG[1].node.legToeHolderG[2].node.objectOffsetPos
		append handPosArray fnTarget.parent.parentPointHolderG[1].node.legToeHolderG[2].node.objectOffsetRot
		append handPosArray fnTarget.parent.parentPointHolderG[1].node.legToeHolderG[2].node.objectOffsetScale
		
		append handPosArray fnTarget.parent.parentPointHolderG[1].node.legToeHolderG[3].node.transform.controller.value
		append handPosArray (fnTarget.parent.parentPointHolderG[1].node.legToeHolderG[3].node.baseObject[#width].getExprText 1)
		append handPosArray fnTarget.parent.parentPointHolderG[1].node.legToeHolderG[3].node.scale.controller.Z_Scale.controller.Bezier_Float
		append handPosArray (fnTarget.parent.parentPointHolderG[1].node.legToeHolderG[3].node.baseObject[#length].getExprText 1)
		append handPosArray fnTarget.parent.parentPointHolderG[1].node.legToeHolderG[3].node.scale.controller.X_Scale.controller.Bezier_Float
		append handPosArray fnTarget.parent.parentPointHolderG[1].node.legToeHolderG[3].node.cornerRadius
		append handPosArray fnTarget.parent.parentPointHolderG[1].node.legToeHolderG[3].node.objectOffsetPos
		append handPosArray fnTarget.parent.parentPointHolderG[1].node.legToeHolderG[3].node.objectOffsetRot
		append handPosArray fnTarget.parent.parentPointHolderG[1].node.legToeHolderG[3].node.objectOffsetScale
		
	)
			
	append HandFingersArray handPosArray
	
	if fnTarget.moduleFingerHolderG.count != 0 then
	(
		for i in fnTarget.moduleFingerHolderG do
		(
			copyFin = FN_copyFinger i.node
			append HandFingersArray copyFin
		)
	)
)
fn FN_pasteHand fnTarget rollUpdate:0 tm:0 =
(
	fnTarget.fingerBoneCountHolderG  = HandFingersArray[1][1]
	

	oldPos = fnTarget.pos
	fnTarget.transform.controller.value = HandFingersArray[1][2]
	if mrHand != fnTarget.parent.parentPointHolderG[1].node.nodeMirror then
	(
		fnTarget.transform = mirrorMatrixFn axis:"z" tm:fnTarget.transform pivottm:fnTarget.parent.transform
		tr =quatToEuler	HandFingersArray[1][4]
		tr.x *=  -1;
		tr.y *=  -1;
		te = eulerToQuat tr
		fnTarget.objectOffsetRot = te
		
		fnTarget.objectOffsetScale = HandFingersArray[1][5]*[1,1,-1]
		fnTarget.objectOffsetPos =  HandFingersArray[1][3]*[1,1,-1]
	)
	else
	(
		fnTarget.objectOffsetPos =  HandFingersArray[1][3]
		fnTarget.objectOffsetRot = HandFingersArray[1][4]
		fnTarget.objectOffsetScale = HandFingersArray[1][5]
	)
	
	if tm ==0 do
		fnTarget.pos = oldPos
	
	fnTarget.baseObject[#length].setExprText 1 HandFingersArray[1][6]
	fnTarget.scale.controller.Y_Scale.controller.Bezier_Float = HandFingersArray[1][7]
	fnTarget.baseObject[#width].setExprText 1 HandFingersArray[1][8]
	fnTarget.scale.controller.Z_Scale.controller.Bezier_Float = HandFingersArray[1][9]
	if fnTarget.parent.parentPointHolderG[1].node.legToeHolderG.count == 0 then 
	(
		fnTarget.baseObject[#height].setExprText 1 HandFingersArray[1][10]
		fnTarget.scale.controller.X_Scale.controller.Bezier_Float = HandFingersArray[1][11]
	)
	else
	(
		fnTarget.parent.parentPointHolderG[1].node.legToeHolderG[1].node.fingerBoneCountHolderG  = HandFingersArray[1][10]
-- 		fnTarget.parent.parentPointHolderG[1].node.legToeHolderG[1].node.transform = mirrorMatrixFn axis:"z" tm:HandFingersArray[1][6] pivottm:fnTarget.parent.parentPointHolderG[1].node.parent.transform
		oldPos = fnTarget.parent.parentPointHolderG[1].node.legToeHolderG[1].node.pos
		fnTarget.parent.parentPointHolderG[1].node.legToeHolderG[1].node.transform.controller.value = HandFingersArray[1][11]
		if mrHand != fnTarget.parent.parentPointHolderG[1].node.nodeMirror then
		(
			fnTarget.parent.parentPointHolderG[1].node.legToeHolderG[1].node.transform = mirrorMatrixFn axis:"z" tm:fnTarget.parent.parentPointHolderG[1].node.legToeHolderG[1].node.transform pivottm:fnTarget.transform
			
			tr =quatToEuler	HandFingersArray[1][19]
			tr.x *=  -1;
			tr.y *=  -1;
			te = eulerToQuat tr
			fnTarget.parent.parentPointHolderG[1].node.legToeHolderG[1].node.objectOffsetRot = te
			
			fnTarget.parent.parentPointHolderG[1].node.legToeHolderG[1].node.objectOffsetScale = HandFingersArray[1][20]*[1,1,-1]
			fnTarget.parent.parentPointHolderG[1].node.legToeHolderG[1].node.objectOffsetPos =  HandFingersArray[1][18]*[1,1,-1]
		)
		else
		(
			fnTarget.parent.parentPointHolderG[1].node.legToeHolderG[1].node.objectOffsetPos =  HandFingersArray[1][18]
			fnTarget.parent.parentPointHolderG[1].node.legToeHolderG[1].node.objectOffsetRot = HandFingersArray[1][19]
			fnTarget.parent.parentPointHolderG[1].node.legToeHolderG[1].node.objectOffsetScale = HandFingersArray[1][20]
		)
		
		if tm ==0 do
			fnTarget.parent.parentPointHolderG[1].node.legToeHolderG[1].node.pos = oldPos
	
		fnTarget.parent.parentPointHolderG[1].node.legToeHolderG[1].node.baseObject[#length].setExprText 1 HandFingersArray[1][12]
		fnTarget.parent.parentPointHolderG[1].node.legToeHolderG[1].node.scale.controller.Y_Scale.controller.Bezier_Float = HandFingersArray[1][13]
		fnTarget.parent.parentPointHolderG[1].node.legToeHolderG[1].node.baseObject[#width].setExprText 1 HandFingersArray[1][14]
		fnTarget.parent.parentPointHolderG[1].node.legToeHolderG[1].node.scale.controller.Z_Scale.controller.Bezier_Float = HandFingersArray[1][15]
		fnTarget.parent.parentPointHolderG[1].node.legToeHolderG[1].node.baseObject[#height].setExprText 1 HandFingersArray[1][16]
		fnTarget.parent.parentPointHolderG[1].node.legToeHolderG[1].node.scale.controller.X_Scale.controller.Bezier_Float = HandFingersArray[1][17]
		
-- 		fnTarget.parent.parentPointHolderG[1].node.legToeHolderG[2].node.transform = mirrorMatrixFn axis:"z" tm:HandFingersArray[1][10] pivottm:fnTarget.parent.parentPointHolderG[1].node.parent.transform

		oldPos = fnTarget.parent.parentPointHolderG[1].node.legToeHolderG[2].node.pos
		fnTarget.parent.parentPointHolderG[1].node.legToeHolderG[2].node.transform.controller.value = HandFingersArray[1][21]
		if mrHand != fnTarget.parent.parentPointHolderG[1].node.nodeMirror then
		(
			fnTarget.parent.parentPointHolderG[1].node.legToeHolderG[2].node.transform = mirrorMatrixFn axis:"z" tm:fnTarget.parent.parentPointHolderG[1].node.legToeHolderG[2].node.transform pivottm:fnTarget.transform
			
			tr =quatToEuler	HandFingersArray[1][29]
			tr.x *=  -1;
			tr.y *=  -1;
			te = eulerToQuat tr
			fnTarget.parent.parentPointHolderG[1].node.legToeHolderG[2].node.objectOffsetRot = te
			
			fnTarget.parent.parentPointHolderG[1].node.legToeHolderG[2].node.objectOffsetScale = HandFingersArray[1][30]*[1,1,-1]
			fnTarget.parent.parentPointHolderG[1].node.legToeHolderG[2].node.objectOffsetPos =  HandFingersArray[1][28]*[1,1,-1]
		)
		else
		(
			fnTarget.parent.parentPointHolderG[1].node.legToeHolderG[2].node.objectOffsetPos =  HandFingersArray[1][28]
			fnTarget.parent.parentPointHolderG[1].node.legToeHolderG[2].node.objectOffsetRot = HandFingersArray[1][29]
			fnTarget.parent.parentPointHolderG[1].node.legToeHolderG[2].node.objectOffsetScale = HandFingersArray[1][30]
		)
		
-- 		if tm ==0 do
-- 			fnTarget.parent.parentPointHolderG[1].node.legToeHolderG[2].node.pos = oldPos
		
		fnTarget.parent.parentPointHolderG[1].node.legToeHolderG[2].node.baseObject[#length].setExprText 1 HandFingersArray[1][22]
		fnTarget.parent.parentPointHolderG[1].node.legToeHolderG[2].node.scale.controller.Y_Scale.controller.Bezier_Float = HandFingersArray[1][23]
		fnTarget.parent.parentPointHolderG[1].node.legToeHolderG[2].node.baseObject[#width].setExprText 1 HandFingersArray[1][24]
		fnTarget.parent.parentPointHolderG[1].node.legToeHolderG[2].node.scale.controller.Z_Scale.controller.Bezier_Float = HandFingersArray[1][25]
		fnTarget.parent.parentPointHolderG[1].node.legToeHolderG[2].node.baseObject[#height].setExprText 1 HandFingersArray[1][26]
		fnTarget.parent.parentPointHolderG[1].node.legToeHolderG[2].node.scale.controller.X_Scale.controller.Bezier_Float = HandFingersArray[1][27]
		
-- 		fnTarget.parent.parentPointHolderG[1].node.legToeHolderG[3].node.transform = mirrorMatrixFn axis:"z" tm:HandFingersArray[1][14] pivottm:fnTarget.parent.parentPointHolderG[1].node.parent.transform
		oldPos = fnTarget.parent.parentPointHolderG[1].node.legToeHolderG[3].node.pos
		fnTarget.parent.parentPointHolderG[1].node.legToeHolderG[3].node.transform.controller.value = HandFingersArray[1][31]
		if mrHand != fnTarget.parent.parentPointHolderG[1].node.nodeMirror then
		(
			fnTarget.parent.parentPointHolderG[1].node.legToeHolderG[3].node.transform = mirrorMatrixFn axis:"z" tm:fnTarget.parent.parentPointHolderG[1].node.legToeHolderG[3].node.transform pivottm:fnTarget.transform
			
			tr =quatToEuler	HandFingersArray[1][38]
			tr.x *=  -1;
			tr.y *=  -1;
			te = eulerToQuat tr
			fnTarget.parent.parentPointHolderG[1].node.legToeHolderG[3].node.objectOffsetRot = te
			
			fnTarget.parent.parentPointHolderG[1].node.legToeHolderG[3].node.objectOffsetScale = HandFingersArray[1][39]*[1,1,-1]
			fnTarget.parent.parentPointHolderG[1].node.legToeHolderG[3].node.objectOffsetPos =  HandFingersArray[1][37]*[1,1,-1]
		)
		else
		(
			fnTarget.parent.parentPointHolderG[1].node.legToeHolderG[3].node.objectOffsetPos =  HandFingersArray[1][37]
			fnTarget.parent.parentPointHolderG[1].node.legToeHolderG[3].node.objectOffsetRot = HandFingersArray[1][38]
			fnTarget.parent.parentPointHolderG[1].node.legToeHolderG[3].node.objectOffsetScale = HandFingersArray[1][39]
		)
		if tm ==0 do
			fnTarget.parent.parentPointHolderG[1].node.legToeHolderG[3].node.pos = oldPos
		
		fnTarget.parent.parentPointHolderG[1].node.legToeHolderG[3].node.baseObject[#width].setExprText 1 HandFingersArray[1][32]
		fnTarget.parent.parentPointHolderG[1].node.legToeHolderG[3].node.scale.controller.Z_Scale.controller.Bezier_Float = HandFingersArray[1][33]
		fnTarget.parent.parentPointHolderG[1].node.legToeHolderG[3].node.baseObject[#length].setExprText 1 HandFingersArray[1][34]
		fnTarget.parent.parentPointHolderG[1].node.legToeHolderG[3].node.scale.controller.X_Scale.controller.Bezier_Float = HandFingersArray[1][35]
		fnTarget.parent.parentPointHolderG[1].node.legToeHolderG[3].node.cornerRadius = HandFingersArray[1][36]
	)
	FN_createFinger fnTarget handFingersCount fnTarget.fingerBoneCountHolderG
	
	for i =1 to fnTarget.moduleFingerHolderG.count do
	(
		FN_pasteFinger fnTarget.moduleFingerHolderG[i].node HandFingersArray[i+1]
	)
	
	if rollUpdate == 1 then
	(
		instantRigFloater.rollouts[5].fingerCount.value = fnTarget.moduleFingerHolderG.count
		instantRigFloater.rollouts[5].fingerBoneCount.value = fnTarget.fingerBoneCountHolderG
	)

)
fn FN_CopyLimb fnTarget =
(
	if fnTarget.legToeHolderG.count == 0 then toeCheck = 0 else toeCheck = 1
	copyCheck = 1
	
	limbsPosArray = #()
	
	limbsWidthArray = #()
	limbsLengthArray = #()
	limbsHeigthArray = #()
	
	clavicleParts = #()
	
	poleArray = #()
	
	limbOffsets = #()
	upperTwistOffsets = #()
	lowerTwistOffsets = #()
	
	targetArmTM = fnTarget.transform.controller.value

	mrArm = fnTarget.nodeMirror
		
	if toeCheck ==0 then clv = 4 else clv = 5
	
	if fnTarget.armBonesHolderG[clv] != undefined then
	(
		-- store clavicle
		clavicleCheck = 1
		append clavicleParts fnTarget.armBonesHolderG[clv].node.clavicleUpHolderG[1].node.pos.controller.Y_Position.controller.Limited_Controller__Bezier_Float
		append clavicleParts fnTarget.armBonesHolderG[clv].node.clavicleUpHolderG[2].node.rotation.controller.X_Rotation
		
		
		append limbsPosArray fnTarget.armBonesHolderG[clv].node.transform.controller.value
		append limbsWidthArray (fnTarget.armBonesHolderG[clv].node.baseObject[#length].getExprText 1)
		append limbsWidthArray fnTarget.armBonesHolderG[clv].node.scale.controller.Y_Scale.controller.Bezier_Float
		append limbsLengthArray (fnTarget.armBonesHolderG[clv].node.baseObject[#width].getExprText 1)
		append limbsLengthArray fnTarget.armBonesHolderG[clv].node.scale.controller.Z_Scale.controller.Bezier_Float
		
		limbOffset = #()
		append limbOffset fnTarget.armBonesHolderG[clv].node.objectOffsetPos
		append limbOffset fnTarget.armBonesHolderG[clv].node.objectOffsetRot
		append limbOffset fnTarget.armBonesHolderG[clv].node.objectOffsetScale
		append limbOffsets limbOffset
	)
	
	else
		(	
			clavicleCheck = 0
			append clavicleParts 0
			append clavicleParts 0
			
			append limbsPosArray 0
			append limbsWidthArray 0
			append limbsWidthArray 0
			append limbsLengthArray 0
			append limbsLengthArray 0
			
			limbOffset = #()
			append limbOffset 0
			append limbOffset 0
			append limbOffset 0
			append limbOffsets limbOffset
		)
	
	-- store opperarm
	append limbsPosArray fnTarget.armBonesHolderG[1].node.transform.controller.value
	append limbsWidthArray (fnTarget.armBonesHolderG[1].node.baseObject[#length].getExprText 1)
	append limbsWidthArray fnTarget.armBonesHolderG[1].node.scale.controller.Y_Scale.controller.Bezier_Float
	append limbsLengthArray (fnTarget.armBonesHolderG[1].node.baseObject[#width].getExprText 1)
	append limbsLengthArray fnTarget.armBonesHolderG[1].node.scale.controller.Z_Scale.controller.Bezier_Float
	
	limbOffset = #()
	append limbOffset fnTarget.armBonesHolderG[1].node.objectOffsetPos
	append limbOffset fnTarget.armBonesHolderG[1].node.objectOffsetRot
	append limbOffset fnTarget.armBonesHolderG[1].node.objectOffsetScale
	append limbOffsets limbOffset
		
	upperTwistBonesCount =  fnTarget.armBonesHolderG[1].node.twistBoneHolderG.count
	if fnTarget.armBonesHolderG[1].node.twistBoneHolderG.count != 0 then
	(
		upperTwistBonesPosXArray = #()
		upperTwistBonesWidthArray = #()
		upperTwistBonesLengthArray = #()
		
		for i = 1 to upperTwistBonesCount do
			(
				append upperTwistBonesPosXArray 0 --fnTarget.armBonesHolderG[1].node.twistBoneHolderG[i].node.pos.controller.X_Position.controller.Bezier_Float
				append upperTwistBonesWidthArray (fnTarget.armBonesHolderG[1].node.twistBoneHolderG[i].node.baseObject[#length].getExprText 1)
				append upperTwistBonesWidthArray fnTarget.armBonesHolderG[1].node.twistBoneHolderG[i].node.scale.controller.Y_Scale.controller.Bezier_Float
				append upperTwistBonesLengthArray (fnTarget.armBonesHolderG[1].node.twistBoneHolderG[i].node.baseObject[#width].getExprText 1)
				append upperTwistBonesLengthArray fnTarget.armBonesHolderG[1].node.twistBoneHolderG[i].node.scale.controller.Z_Scale.controller.Bezier_Float
				
				twistOffset = #()
				append twistOffset fnTarget.armBonesHolderG[1].node.twistBoneHolderG[i].node.objectOffsetPos
				append twistOffset fnTarget.armBonesHolderG[1].node.twistBoneHolderG[i].node.objectOffsetRot
				append twistOffset fnTarget.armBonesHolderG[1].node.twistBoneHolderG[i].node.objectOffsetScale
				append upperTwistOffsets twistOffset
			)
	)
	
	
	-- store forearm
	append limbsPosArray fnTarget.armBonesHolderG[2].node.transform.controller.value
	append limbsWidthArray (fnTarget.armBonesHolderG[2].node.baseObject[#length].getExprText 1)
	append limbsWidthArray fnTarget.armBonesHolderG[2].node.scale.controller.Y_Scale.controller.Bezier_Float
	append limbsLengthArray (fnTarget.armBonesHolderG[2].node.baseObject[#width].getExprText 1)
	append limbsLengthArray fnTarget.armBonesHolderG[2].node.scale.controller.Z_Scale.controller.Bezier_Float
	
	limbOffset = #()
	append limbOffset fnTarget.armBonesHolderG[2].node.objectOffsetPos
	append limbOffset fnTarget.armBonesHolderG[2].node.objectOffsetRot
	append limbOffset fnTarget.armBonesHolderG[2].node.objectOffsetScale
	append limbOffsets limbOffset
	
	foreTwistBonesCount =  fnTarget.armBonesHolderG[2].node.twistBoneHolderG.count
	if fnTarget.armBonesHolderG[2].node.twistBoneHolderG.count != 0 then
	(
		foreTwistBonesPosXArray = #()
		foreTwistBonesWidthArray = #()
		foreTwistBonesLengthArray = #()
		
		for i = 1 to foreTwistBonesCount do
			(
				append foreTwistBonesWidthArray (fnTarget.armBonesHolderG[2].node.twistBoneHolderG[i].node.baseObject[#length].getExprText 1)
				append foreTwistBonesWidthArray fnTarget.armBonesHolderG[2].node.twistBoneHolderG[i].node.scale.controller.Y_Scale.controller.Bezier_Float
				append foreTwistBonesLengthArray (fnTarget.armBonesHolderG[2].node.twistBoneHolderG[i].node.baseObject[#width].getExprText 1)
				append foreTwistBonesLengthArray fnTarget.armBonesHolderG[2].node.twistBoneHolderG[i].node.scale.controller.Z_Scale.controller.Bezier_Float
				
				twistOffset = #()
				append twistOffset fnTarget.armBonesHolderG[2].node.twistBoneHolderG[i].node.objectOffsetPos
				append twistOffset fnTarget.armBonesHolderG[2].node.twistBoneHolderG[i].node.objectOffsetRot
				append twistOffset fnTarget.armBonesHolderG[2].node.twistBoneHolderG[i].node.objectOffsetScale
				append lowerTwistOffsets twistOffset
			)
	)

	--store hand
	FN_copyHand fnTarget.armBonesHolderG[3].node

		
	--- store pole
	append poleArray fnTarget.armPoleHolderG[2].node.pos.controller.Y_Position.controller.Limited_Controller__Bezier_Float
)
fn FN_PasteMirrorLimb fnTarget PmAxis:false=
(
	pm =false
	
	glbScl = fnTarget.rootNodeHolderG[1].node.scale.controller.X_Scale/100
	if PmAxis then
	(
		pm = true
		if fnTarget.nodeMirror == mrArm then 
		(
			fnTarget.nodeMirror = not mrArm
			fnTarget.transform = mirrorMatrixFn axis:"z" tm:fnTarget.transform pivottm:fnTarget.parent.transform
		)
	)
	else
	(
		fnTarget.transform.controller.value = targetArmTM
		fnTarget.nodeMirror = mrArm
	)
	
	
if toeCheck ==0 then clv = 4 else clv = 5

	if fnTarget.armBonesHolderG[clv] != undefined and clavicleCheck ==1 then
		(
			FN_deleteClavicle fnTarget
			FN_addClavicle fnTarget
			
			fnTarget.armBonesHolderG[clv].node.clavicleUpHolderG[1].node.pos.controller.Y_Position.controller.Limited_Controller__Bezier_Float = clavicleParts[1]
			fnTarget.armBonesHolderG[clv].node.clavicleUpHolderG[2].node.rotation.controller.X_Rotation = clavicleParts[2]
-- 			fnTarget.armBonesHolderG[clv].node.rotation.controller.target_axisFlip = fnTarget.nodeMirror[1]
			
			fnTarget.armBonesHolderG[clv].node.transform.controller.value =limbsPosArray[1]
			if pm then
			(
				fnTarget.armBonesHolderG[clv].node.clavicleUpHolderG[2].node.rotation.controller.X_Rotation = clavicleParts[2]*-1
				fnTarget.armBonesHolderG[clv].node.transform = mirrorMatrixFn axis:"z" tm:fnTarget.armBonesHolderG[clv].node.transform pivottm:fnTarget.transform
				
				tr =quatToEuler	limbOffsets[1][2]
				tr.x *=  -1;
				tr.y *=  -1;
				te = eulerToQuat tr
				fnTarget.armBonesHolderG[clv].node.objectOffsetRot = te
				
				fnTarget.armBonesHolderG[clv].node.objectOffsetScale = limbOffsets[1][3]*[1,1,-1]
				fnTarget.armBonesHolderG[clv].node.objectOffsetPos =  limbOffsets[1][1]*[1,1,-1]
			)
			else
			(
				fnTarget.armBonesHolderG[clv].node.objectOffsetPos = limbOffsets[1][1]
				fnTarget.armBonesHolderG[clv].node.objectOffsetRot = limbOffsets[1][2]
				fnTarget.armBonesHolderG[clv].node.objectOffsetScale = limbOffsets[1][3]
			)
			
			fnTarget.armBonesHolderG[clv].node.baseObject[#length].setExprText 1 limbsWidthArray[1]
			fnTarget.armBonesHolderG[clv].node.scale.controller.Y_Scale.controller.Bezier_Float = limbsWidthArray[2]
			fnTarget.armBonesHolderG[clv].node.baseObject[#width].setExprText 1 limbsLengthArray[1]
			fnTarget.armBonesHolderG[clv].node.scale.controller.Z_Scale.controller.Bezier_Float = limbsLengthArray[2]
		)
	
	else if fnTarget.armBonesHolderG[clv] == undefined and clavicleCheck ==1 then
		(
			FN_addClavicle fnTarget
			instantRigFloater.rollouts[5].clavicleChk.checked = true
			
			fnTarget.armBonesHolderG[clv].node.clavicleUpHolderG[1].node.pos.controller.Y_Position.controller.Limited_Controller__Bezier_Float = clavicleParts[1]
			fnTarget.armBonesHolderG[clv].node.clavicleUpHolderG[2].node.rotation.controller.X_Rotation = clavicleParts[2]
-- 			fnTarget.armBonesHolderG[clv].node.rotation.controller.target_axisFlip = fnTarget.nodeMirror[1]
			
			fnTarget.armBonesHolderG[clv].node.transform.controller.value =limbsPosArray[1]
			if pm then
			(
				fnTarget.armBonesHolderG[clv].node.clavicleUpHolderG[2].node.rotation.controller.X_Rotation = clavicleParts[2]*-1
				fnTarget.armBonesHolderG[clv].node.transform = mirrorMatrixFn axis:"z" tm:fnTarget.armBonesHolderG[clv].node.transform pivottm:fnTarget.transform
				
				tr =quatToEuler	limbOffsets[1][2]
				tr.x *=  -1;
				tr.y *=  -1;
				te = eulerToQuat tr
				fnTarget.armBonesHolderG[clv].node.objectOffsetRot = te
				
				fnTarget.armBonesHolderG[clv].node.objectOffsetScale = limbOffsets[1][3]*[1,1,-1]
				fnTarget.armBonesHolderG[clv].node.objectOffsetPos =  limbOffsets[1][1]*[1,1,-1]
			)
			else
			(
				fnTarget.armBonesHolderG[clv].node.objectOffsetPos = limbOffsets[1][1]
				fnTarget.armBonesHolderG[clv].node.objectOffsetRot = limbOffsets[1][2]
				fnTarget.armBonesHolderG[clv].node.objectOffsetScale = limbOffsets[1][3]
			)
			fnTarget.armBonesHolderG[clv].node.baseObject[#length].setExprText 1 limbsWidthArray[1]	
			fnTarget.armBonesHolderG[clv].node.scale.controller.Y_Scale.controller.Bezier_Float = limbsWidthArray[2]
			fnTarget.armBonesHolderG[clv].node.baseObject[#width].setExprText 1 limbsLengthArray[1]
			fnTarget.armBonesHolderG[clv].node.scale.controller.Z_Scale.controller.Bezier_Float = limbsLengthArray[2]
		)
	else if fnTarget.armBonesHolderG[clv] != undefined and clavicleCheck ==0 then
		(
			FN_deleteClavicle fnTarget
			instantRigFloater.rollouts[5].clavicleChk.checked = false
		)
	
	-- upperArm
-- 	if pm then
-- 		fnTarget.armBonesHolderG[1].node.transform = mirrorMatrixFn axis:"z" tm:limbsPosArray[2] pivottm:fnTarget.parent.transform
-- 	else
-- 		fnTarget.armBonesHolderG[1].node.transform = limbsPosArray[2]
	
	fnTarget.armBonesHolderG[1].node.transform.controller.value = limbsPosArray[2]
	if pm then
	(
		fnTarget.armBonesHolderG[1].node.transform = mirrorMatrixFn axis:"z" tm:fnTarget.armBonesHolderG[1].node.transform pivottm:fnTarget.transform
		
		tr =quatToEuler	limbOffsets[2][2]
		tr.x *=  -1;
		tr.y *=  -1;
		te = eulerToQuat tr
		fnTarget.armBonesHolderG[1].node.objectOffsetRot = te
		
		fnTarget.armBonesHolderG[1].node.objectOffsetScale = limbOffsets[2][3]*[1,1,-1]
		fnTarget.armBonesHolderG[1].node.objectOffsetPos =  limbOffsets[2][1]*[1,1,-1]
	)
	else
	(
		fnTarget.armBonesHolderG[1].node.objectOffsetPos = limbOffsets[2][1]
		fnTarget.armBonesHolderG[1].node.objectOffsetRot = limbOffsets[2][2]
		fnTarget.armBonesHolderG[1].node.objectOffsetScale = limbOffsets[2][3]
	)
	
	fnTarget.armBonesHolderG[1].node.baseObject[#length].setExprText 1 limbsWidthArray[3]
	fnTarget.armBonesHolderG[1].node.scale.controller.Y_Scale.controller.Bezier_Float = limbsWidthArray[4]
	fnTarget.armBonesHolderG[1].node.baseObject[#width].setExprText 1 limbsLengthArray[3]
	fnTarget.armBonesHolderG[1].node.scale.controller.Z_Scale.controller.Bezier_Float = limbsLengthArray[4]

	FN_createTwistBones fnTarget.armBonesHolderG[1].node (upperTwistBonesCount+1)
	
	cnt = 1;
	for i = 1 to upperTwistBonesCount do
	(
		fnTarget.armBonesHolderG[1].node.twistBoneHolderG[i].node.baseObject[#length].setExprText 1 upperTwistBonesWidthArray[cnt]
		fnTarget.armBonesHolderG[1].node.twistBoneHolderG[i].node.scale.controller.Y_Scale.controller.Bezier_Float = upperTwistBonesWidthArray[cnt+1]
		fnTarget.armBonesHolderG[1].node.twistBoneHolderG[i].node.baseObject[#width].setExprText 1 upperTwistBonesLengthArray[cnt]
		fnTarget.armBonesHolderG[1].node.twistBoneHolderG[i].node.scale.controller.Z_Scale.controller.Bezier_Float = upperTwistBonesLengthArray[cnt+1]
		cnt +=2;
		if pm then
		(
			tr =quatToEuler	upperTwistOffsets[i][2]
			tr.x *=  -1;
			tr.y *=  -1;
			te = eulerToQuat tr
			fnTarget.armBonesHolderG[1].node.twistBoneHolderG[i].node.objectOffsetRot = te
			
			fnTarget.armBonesHolderG[1].node.twistBoneHolderG[i].node.objectOffsetScale = upperTwistOffsets[i][3]*[1,1,-1]
			fnTarget.armBonesHolderG[1].node.twistBoneHolderG[i].node.objectOffsetPos =  upperTwistOffsets[i][1]*[1,1,-1]
		)
		else
		(
			fnTarget.armBonesHolderG[1].node.twistBoneHolderG[i].node.objectOffsetPos = upperTwistOffsets[i][1]
			fnTarget.armBonesHolderG[1].node.twistBoneHolderG[i].node.objectOffsetRot = upperTwistOffsets[i][2]
			fnTarget.armBonesHolderG[1].node.twistBoneHolderG[i].node.objectOffsetScale = upperTwistOffsets[i][3]
		)
	)						

				
	
	-- foreArm
-- 	if pm then
-- 		fnTarget.armBonesHolderG[2].node.transform = mirrorMatrixFn axis:"z" tm:limbsPosArray[3] pivottm:fnTarget.parent.transform
-- 	else
-- 		fnTarget.armBonesHolderG[2].node.transform = limbsPosArray[3]
	fnTarget.armBonesHolderG[2].node.transform.controller.value = limbsPosArray[3]
	if pm then
	(
		fnTarget.armBonesHolderG[2].node.transform = mirrorMatrixFn axis:"z" flip:"z" tm:fnTarget.armBonesHolderG[2].node.transform pivottm:fnTarget.armBonesHolderG[1].node.transform
		
		tr =quatToEuler	limbOffsets[3][2]
		tr.x *=  -1;
		tr.y *=  -1;
		te = eulerToQuat tr
		fnTarget.armBonesHolderG[2].node.objectOffsetRot = te
		
		fnTarget.armBonesHolderG[2].node.objectOffsetScale = limbOffsets[3][3]*[1,1,-1]
		fnTarget.armBonesHolderG[2].node.objectOffsetPos =  limbOffsets[3][1]*[1,1,-1]
	)
	else
	(
		fnTarget.armBonesHolderG[2].node.objectOffsetPos = limbOffsets[3][1]
		fnTarget.armBonesHolderG[2].node.objectOffsetRot = limbOffsets[3][2]
		fnTarget.armBonesHolderG[2].node.objectOffsetScale = limbOffsets[3][3]
	)
	
	fnTarget.armBonesHolderG[2].node.baseObject[#length].setExprText 1 limbsWidthArray[5]
	fnTarget.armBonesHolderG[2].node.scale.controller.Y_Scale.controller.Bezier_Float = limbsWidthArray[6]
	fnTarget.armBonesHolderG[2].node.baseObject[#width].setExprText 1 limbsLengthArray[5]
	fnTarget.armBonesHolderG[2].node.scale.controller.Z_Scale.controller.Bezier_Float = limbsLengthArray[6]
	

	FN_createTwistBones fnTarget.armBonesHolderG[2].node (foreTwistBonesCount+1)
	cnt = 1
	for i = 1 to foreTwistBonesCount do
	(							
		fnTarget.armBonesHolderG[2].node.twistBoneHolderG[i].node.baseObject[#length].setExprText 1 foreTwistBonesWidthArray[cnt]
		fnTarget.armBonesHolderG[2].node.twistBoneHolderG[i].node.scale.controller.Y_Scale.controller.Bezier_Float = foreTwistBonesWidthArray[cnt+1]
		fnTarget.armBonesHolderG[2].node.twistBoneHolderG[i].node.baseObject[#width].setExprText 1 foreTwistBonesLengthArray[cnt]
		fnTarget.armBonesHolderG[2].node.twistBoneHolderG[i].node.scale.controller.Z_Scale.controller.Bezier_Float = foreTwistBonesLengthArray[cnt+1]
		cnt+=2
		if pm then
		(
			tr =quatToEuler	lowerTwistOffsets[i][2]
			tr.x *=  -1;
			tr.y *=  -1;
			te = eulerToQuat tr
			fnTarget.armBonesHolderG[2].node.twistBoneHolderG[i].node.objectOffsetRot = te
			
			fnTarget.armBonesHolderG[2].node.twistBoneHolderG[i].node.objectOffsetScale = lowerTwistOffsets[i][3]*[1,1,-1]
			fnTarget.armBonesHolderG[2].node.twistBoneHolderG[i].node.objectOffsetPos =  lowerTwistOffsets[i][1]*[1,1,-1]
		)
		else
		(
			fnTarget.armBonesHolderG[2].node.twistBoneHolderG[i].node.objectOffsetPos = lowerTwistOffsets[i][1]
			fnTarget.armBonesHolderG[2].node.twistBoneHolderG[i].node.objectOffsetRot = lowerTwistOffsets[i][2]
			fnTarget.armBonesHolderG[2].node.twistBoneHolderG[i].node.objectOffsetScale = lowerTwistOffsets[i][3]
		)
	)						
	
	
	--hand
	FN_pasteHand fnTarget.armBonesHolderG[3].node tm:1
	
		
	-- pole
	
-- 	fnTarget.armPoleHolderG[1].node.rotation.controller.target_axisFlip = fnTarget.nodeMirror[1]
	fnTarget.armPoleHolderG[2].node.pos.controller.Y_Position.controller.Limited_Controller__Bezier_Float = poleArray[1]
	
	instantRigFloater.rollouts[5].upperTwist.value = upperTwistBonesCount+1
	instantRigFloater.rollouts[5].foreTwist.value = foreTwistBonesCount+1
)

-------------
--build functions
--------------

--- build body

fn FN_build fnTarget fnParent= -- ana build motoru, her bonu inceleyip içinde bir modul varsa build eder
(
	if fnTarget.moduleHubHolderG.count != 0 then
	(
		for i in fnTarget.moduleHubHolderG do
		(
			hParent = (FN_buildHub i.node fnParent) -- üretimi yaptiktan sonra sonraki modülleri bu bona parentlar. parent i da mParente atadik.
			FN_build i.node.hubHolderG[1].node hParent
		)
	)
	if fnTarget.moduleTailHolderG.count != 0 then
	(
		for i in fnTarget.moduleTailHolderG do
		(
			tParent = (FN_buildChain i.node fnParent)
			for t = 1 to i.node.tailBoneHolderG.count do
			(
				FN_build i.node.tailBoneHolderG[t].node tParent[t]
			)
		)
	)
	if fnTarget.moduleArmHolderG.count != 0 then
	(
		for i in fnTarget.moduleArmHolderG do
		(
			aParent = (FN_buildArm i.node fnParent)
			
			upperArm = i.node.armbonesHolderG[1].node
			foreArm = i.node.armbonesHolderG[2].node
			hand = i.node.armbonesHolderG[3].node
			
			FN_build upperArm aParent[1][1]
			if upperArm.twistBoneHolderG.count != 0 then
			(
				for t = 1 to upperArm.twistBoneHolderG.count do
					(
						FN_build upperArm.twistBoneHolderG[t].node aParent[1][t+1]
					)
			)
			
			FN_build foreArm aParent[2][1]
			if foreArm.twistBoneHolderG.count != 0 then
			(
				for t = 1 to foreArm.twistBoneHolderG.count do
				(
					FN_build foreArm.twistBoneHolderG[t].node aParent[2][t+1]
				)
			)
			
			FN_build hand aParent[3][1]
			fingerModule = 0
			for i in hand.modulefingerHolderG do
			(
				fingerModule += 1
				for b = 1 to i.node.fingerBoneHolderG.count do
				(
					FN_build i.node.fingerBoneHolderG[b].node aParent[6][fingerModule][b]
				)
			)
			
			if i.node.armbonesHolderG.count > 3  then 
			(
				clavicle = i.node.armbonesHolderG[4].node
				FN_build clavicle aParent[4][1]
			)
		)
	)
	if fnTarget.moduleLegHolderG.count != 0 then
	(
		for i in fnTarget.moduleLegHolderG do
		(
			lParent = (FN_buildArm i.node fnParent)
			
			upperArm = i.node.armbonesHolderG[1].node
			foreArm = i.node.armbonesHolderG[2].node
			hand = i.node.armbonesHolderG[3].node
			toe = i.node.armbonesHolderG[4].node
			
			if i.node.armbonesHolderG.count > 4  then (clavicle = i.node.armbonesHolderG[5].node; FN_build clavicle lParent[1][1];)
			
			FN_build upperArm lParent[1][1]
			if upperArm.twistBoneHolderG.count != 0 then
			(
				for t = 1 to upperArm.twistBoneHolderG.count do
				(
					FN_build upperArm.twistBoneHolderG[t].node lParent[1][t+1]
				)
			)
			
			FN_build foreArm lParent[2][1]
			if foreArm.twistBoneHolderG.count != 0 then
			(
				for t = 1 to foreArm.twistBoneHolderG.count do
				(
					FN_build foreArm.twistBoneHolderG[t].node lParent[2][t+1]
				)
			)
				
			FN_build hand lParent[3][1]
			FN_build toe lParent[5][1]
			fingerModule = 0
			for i in hand.modulefingerHolderG do
			(
				fingerModule += 1
				for b = 1 to i.node.fingerBoneHolderG.count do
				(
					FN_build i.node.fingerBoneHolderG[b].node lParent[6][fingerModule][b]
				)
			)
		)
	)
	if fnTarget.moduleSpineHolderG.count != 0 then
	(
		for i in fnTarget.moduleSpineHolderG do
		(
			sParent = (FN_buildSpine i.node fnParent)
			
			for t = 1 to i.node.spineHolderG.count do
			(
				FN_build i.node.spineHolderG[t].node sParent[1][t]
			)
			
			FN_build i.node.chestHolderG[1].node sParent[2]
		)
	)
)

fn FN_buildBox refBone fnBwidth fnBlength fnBheight _blend:0=
(
	bonePivot = BoneSys.createBone [0,0,0] [0,0,25] [-25,0,0]
	sb = Box ()
	FN_addIR sb
	FN_addBoneProperties sb
-- 	try
-- 	(
-- 		obj = NodeTransformMonitor node:sb forwardTransformChangeMsgs:false
-- 		append glbRoot.rigNodes obj
-- 	)catch()
-- 	sb = ChamferBox Length_Segments:1 Width_Segments:1 Height_Segments:1 Fillet_Segments:2  Fillet:.4 smooth:1 mapcoords:1
	sb.parent = bonePivot
	ResetTransform sb
	delete bonePivot
	sb.wirecolor = [255,80,0]
-- 	sb.scale.controller = ScaleXYZ ()
	
	sb.width = fnBwidth
	sb.length = fnBlength
	sb.height = fnBheight
	
	if _blend == 1 do CenterPivot sb
	
	sb.boneEnable = true
	
	newLayerName = rName + "_bones"
	newLayerBones = LayerManager.getLayerFromName newLayerName
	if newLayerBones == undefined then newLayerBones = LayerManager.newLayerFromName newLayerName
-- 	newLayerBones.ishidden = true
	newLayerBones.addNode sb

	if (refBone != undefined) do
	(
		sb.objectOffsetRot = refBone.objectOffsetRot
		sb.objectOffsetPos = refBone.objectOffsetPos
		sb.objectOffsetScale = refBone.objectOffsetScale
	)

-- 	hide sb
-- 	freeze sb
	sb
)

fn FN_rootAttributes fn_target=
(
	curve_ca = attributes creditAtt
	(
		Rollout Params "InstantRig 1.52"
		(
			hyperLink irig  "www.instantrig.com" align:#left offset:[10, 5] color:[255,255,255] hoverColor:[255,130,0] address:"http://www.instantrig.com"
			Button um  "?" align:#right offset:[0, -25] tooltip:"InstantRig User Manual"
			
			on um pressed do ShellLaunch "http://docs.instantrig.com/rst/animation/sub/modules/rootatts.html#root-attributes" ""
		)
	)
	Custattributes.add fn_target.modifiers[#attributes] curve_ca
	
	holder_att = attributes root_attributes
	(
		Parameters main
		(
			rigSectionHolderG type:#integer default:11
		)
	)
	Custattributes.add fn_Target holder_att
)

fn FN_exportAttributes fn_target=
(
	curve_ca = attributes expAtt
	(
		fn bakeRef childNode bakedArray=
		(
			for i in childNode.childG do
			(	
				local p
				p = PRS() -- Create standard transform controller to bake keys into
				p.position.controller = position_xyz()       
				p.rotation.controller = euler_xyz()       
				p.scale.controller = linear_scale()
				
				for t = animationRange.start to animationRange.end by 1 do -- Loop over given time range
				(   
					at time t, with animate on, in coordsys world -- At time t grab obj transform in world space
					(
						p.value = i.node.transform 
					)
				)
				append bakedArray p
				bakeRef i.node bakedArray
			)
			
			bakedArray
		)
		fn bake childNode parent tm createTip parented blendBones=
		(
			for i in childNode.childG do
			(
				local p
				p = PRS() -- Create standard transform controller to bake keys into
				p.position.controller = position_xyz()       
				p.rotation.controller = euler_xyz()       
				p.scale.controller = linear_scale()
				
				at time tm, with animate off, in coordsys world 
				(
					p.value = i.node.transform
				) 
				
				i.node.parent = parent
				i.node.Transform.controller = p
				i.node.transform = p.value
				if parented then (newparent = i.node) else (newparent = undefined)
				if i.node.isBlendBone do append blendBones i.node
				bake i.node newparent tm createTip parented blendBones
				
			)
			if childNode.childG.count == 0 and createTip /*and childNode.isBlendBone == false*/ do
			(
				tip = copy childNode
				tip.height = .1
				tip.parent = childNode
				tip.pos.controller.x_position = childNode.height
				tip.boneEnable = true
				tip.name = childNode.name + "_tip"
				tip.wirecolor = childNode.wirecolor
			)
			blendBones
		)
		fn loadAnims childNode bakedArray n=
		(
			for i in childNode.childG do
			(
				for t = animationRange.start to animationRange.end by 1 do -- Loop over given time range
				(   
					at time t, with animate on, in coordsys world -- At time t grab obj transform in world space
					(
						i.node.transform = bakedArray[bakedArray.count +1 - n].value
						
					)
				)
				n = loadAnims i.node bakedArray (n-1)
			)
			n
		)
		fn deleteRig nodes=
		(
			ay = #()
			for i in nodes do
			(
				try(
						if (i.node != undefined) do append ay i.node
					)
				catch ()
			)
 			delete ay
 			delete $
		)
		Parameters main rollout:Params
		(
			expAnimP Type:#boolean UI:expAnim Default:true
			parentedP Type:#boolean UI:parented Default:true
			blendBoneP Type:#boolean UI:blendBone Default:false
			tipP Type:#boolean UI:tip Default:false
-- 			remRigP Type:#boolean UI:remRig Default:false
		)
			
		Rollout Params "Exract"
		(
-- 			label lbl "It makes rigs down to\n their deformation bones and bakes their animations\nThis action cannot be undone.\nPlease save your progress." height:70 pos:[8,5]
			button exportBtn "Extract Rig" width:150 height:25 align:#center tooltip:"It makes rigs down to their deformation bones and bakes their animations."
			checkbox expAnim "Include Animations" align:#left
			checkbox parented "Keep Hierarchy" align:#left
			checkbox blendBone "Keep Blend Bones" align:#left tooltip:"It keeps blend bones at knees, elbows, wrists"
			checkbox tip "Create Tip Bones" align:#left
-- 			checkbox remRig "remove i-rig" align:#center
			
			on exportBtn pressed do
			(
				if expAnim.checked then
				(
					sliderTime = animationRange.start
					bakedRefs = #()
					blendBones = #()
					bakeRef $ bakedRefs
					unhide $.childG[1].node
					unfreeze $.childG[1].node
					bake $ undefined animationRange.start tip.checked parented.checked blendBones
					loadAnims $ bakedRefs bakedRefs.count
					if blendBone.checked == false do delete blendBones
				)
				else
				(
					blendBones = #()
					bake $ undefined currenttime tip.checked parented.checked blendBones
					if blendBone.checked == false do delete blendBones
				)

				deleteRig $.rigNodes
			)
		)
	)
	Custattributes.add fn_target.modifiers[#attributes] curve_ca
)

fn FN_overlapAttributes fn_target=
(
	curve_ca = attributes ovAtt
	(
		Rollout overlapAtts "Overlapping Action"
		(
			fn _createDialog=
			(
				global overlapFloater
				global overlapRollout
				global getPosActiveCnt
				global getRotActiveCnt
				global getScaleActiveCnt
				global writeBezierKeys
				global writeTCBKeys
				global pcase
				global rcase
				global scase
				global loadBezierKeys
				global loadTCBkeys
				global saveOverlapAnim
				global loadOverlapAnim
				
				--save load functions
				fn getPosActiveCnt pc = --what is the active position controller?  function
				(
					if (classof pc == position_list or classof pc == position_layer) then ppc = pc[pc.active] else ppc = pc
					if classof ppc == springPositionController then ppcc=ppc.position.controller else ppcc=ppc
					if ppcc.controller != undefined and (classof ppcc.controller == position_list or classof ppcc.controller == position_layer) then ppccc= getPosActiveCnt ppcc.controller else ppccc=ppcc
					if ppccc.controller!= undefined then (return ppccc.controller) else (return ppccc)
					)

				fn getRotActiveCnt rc=  --what is the active rotation controller?  function
				(
					if (classof rc == rotation_list or classof rc == rotation_layer) then rrc = rc[rc.active] else rrc = rc
					if rrc.controller != undefined and (classof rrc.controller == rotation_list or classof rrc.controller == rotation_layer) then rrcc= getRotActiveCnt rrc.controller else rrcc=rrc
					if rrcc.controller != undefined then (return rrcc.controller) else (return rrcc)
					)

				fn getScaleActiveCnt sc=  --what is the active scale controller?  function
				(
					if (classof sc == scale_list or classof sc == scale_layer) then ssc = sc[sc.active] else ssc = sc
					if ssc.controller != undefined and (classof ssc.controller == scale_list or classof ssc.controller == scale_layer) then sscc= getScaleActiveCnt ssc.controller else sscc=ssc
					if sscc.controller != undefined then (return sscc.controller) else (return sscc)
					)	

				fn writeBezierKeys cnt ff st en = --write bezier keys function
				(
					cntk=#()
					for kk in cnt.keys do 
					(
						if kk.time >=st and kk.time<=en then append cntk kk else()
						)
					format "\t\t%\n" cntk.count to:ff
					for i=1 to cntk.count do
					(
						format "\t\t% % % % % % % % % % % % %\n" (cntk[i].time-st) cntk[i].value cntk[i].inTangentType cntk[i].inTangent cntk[i].inTangentLength cntk[i].outTangentType cntk[i].outTangent cntk[i].outTangentLength cntk[i].freeHandle cntk[i].x_locked cntk[i].y_locked cntk[i].z_locked cntk[i].constantVelocity to:ff
						)
					)

				fn writeTCBKeys cnt ff st en = --write tcb keys function
				(
					cntk=#()
					for kk in cnt.keys do 
					(
						if kk.time >=st and kk.time<=en then append cntk kk else()
						)
					format "\t\t%\n" cntk.count to:ff
					for i=1 to cntk.count do
					(
						format "\t\t% % % % % % %\n" (cntk[i].time-st) (at time cntk[i].time cnt.value) cntk[i].tension cntk[i].continuity cntk[i].bias cntk[i].easeto cntk[i].easefrom to:ff
						)
					)

				fn pcase cnt =  --what kind of controller is the active position controller? 
				(
					case (classof cnt) of 
					(
						position_xyz:a=1
						tcb_position:a=2
						bezier_position:a=3
						default:a=4
						)
					)

				fn rcase cnt =  --what kind of controller is the active rotation controller? 
				(
					case (classof cnt) of 
					(
						euler_xyz:a=1
						tcb_rotation:a=2
						default:a=4
						)
					)

				fn scase cnt =  --what kind of controller is the active position controller? 
				(
					case (classof cnt) of 
					(
						scalexyz:a=1
						tcb_scale:a=2
						bezier_scale:a=3
						default:a=4
						)
					)
					
				fn loadBezierKeys cnt ffl kn pffset= --load bezier keys functions
				(
					for i=1 to kn do
					(
						t=readvalue ffl
						val=readvalue ffl
						intgt=readvalue ffl
						intg=readvalue ffl
						intgl=readvalue ffl
						outtgt=readvalue ffl
						outtg=readvalue ffl
						outtgl=readvalue ffl
						frh=readvalue ffl
						xlk=readvalue ffl
						ylk=readvalue ffl
						zlk=readvalue ffl
						constvel=readvalue ffl
						kk=addNewKey cnt (t+pffset)
						kk.value=val
						kk.inTangent=intg
						kk.inTangentLength=intgl
						kk.outTangent=outtg
						kk.outTangentLength=outtgl
						kk.freeHandle=frh
						kk.x_locked=xlk
						kk.y_locked=ylk
						kk.z_locked=zlk
						kk.constantVelocity=constvel
						kk.inTangentType=intgt
						kk.outTangentType=outtgt
						)
					)

				fn loadTCBkeys cnt ffl kn pffset=
				(
					for i=1 to kn do
					(
						t=readvalue ffl
						val=readvalue ffl
						tns=readvalue ffl
						cont=readvalue ffl
						bbias=readvalue ffl
						eto=readvalue ffl
						efrom=readvalue ffl
						kk=addNewKey cnt (t+pffset)
						with animate on at time (t+pffset) cnt.value=val
						kk.tension=tns
						kk.continuity=cont
						kk.bias=bbias
						kk.easeto=eto
						kkeasefrom=efrom
						)
					)

				fn saveOverlapAnim nodes ss startTime endTime=  -- the save animation button
				(
					if nodes.count == 0 then (messagebox "No Object Selected")
					else
					(
						if ss != undefined then
						(
							ff = createfile ss --creates the save file
							stt=startTime --start time
							ent=endTime -- end time

							format "%\n" ((stt as integer)/ticksperframe) to:ff
							format "%\n" (((ent-stt) as integer)/ticksperframe) to:ff
								
							for i = 1 to nodes.count do  -- takes every object and.....
							(
				-- 				pbrr2.value = 100.*i/selection.count --the progress bar 
								o=nodes[i]
				-- 				lbl3.text=o.name
								format "% \n" o.name to:ff -- write the object name
								pcnt=getPosActiveCnt o.position.controller
								rcnt =getRotActiveCnt o.rotation.controller
								scnt=getScaleActiveCnt o.scale.controller
								format "\tposition_controller_type %\n" (pcase pcnt) to:ff --writes the position controller type
								case pcase pcnt of --write position keys
								(
									1:(
										writeBezierKeys pcnt.x_position.controller ff stt ent
										writeBezierKeys pcnt.y_position.controller ff stt ent
										writeBezierKeys pcnt.z_position.controller ff stt ent
											)
									2:(
										writeTCBKeys pcnt ff stt ent
											)
									3:(
										writeBezierKeys pcnt ff stt ent
											)
									default:()
									)   --end write position keys
								
								format "\trotation_controller_type %\n" (rcase rcnt) to:ff -- writes the rotation controller type
								case rcase rcnt of  --write rotation keys
								(
									1:(
										writeBezierKeys rcnt.x_rotation.controller ff stt ent
										writeBezierKeys rcnt.y_rotation.controller ff stt ent
										writeBezierKeys rcnt.z_rotation.controller ff stt ent
											)
									2:(
										writeTCBKeys rcnt ff stt ent
											)
									default:()
								
									)  --end write rotation keys
									
								format "\tscale_controller_type %\n" (scase scnt) to:ff -- writes the scale controller type
								case scase scnt of  --write scale keys
								(
									1:(
										writeBezierKeys scnt.x_scale.controller ff stt ent
										writeBezierKeys scnt.y_scale.controller ff stt ent
										writeBezierKeys scnt.z_scale.controller ff stt ent
											)
									2:(
										writeTCBKeys scnt ff stt ent
											)
									3:(
										writeBezierKeys scnt ff stt ent
											)
									default:()
									)
								)
							)
						else()
						close ff
					)
				)

				fn loadOverlapAnim nodes fload= -- the load animation button
				(
					if nodes.count == 0 then (messagebox "No Object Selected")
					else
					(
						if fload !=undefined then
						(
							ff=openfile fload --opens the saved file
							pffset = (readvalue ff) as time  --the time offset
							rng=readvalue ff
							for i=1 to nodes.count do --takes every selected object and...
							(
								o=nodes[i]
				-- 				lbl4.text=o.name
				-- 				pbrr.value = 100.*i/selection.count --the progress bar 
								
								pcnt=getPosActiveCnt o.position.controller -- what is the active position controller?
								rcnt=getRotActiveCnt o.rotation.controller -- what is the active rotation controller?
								scnt=getScaleActiveCnt o.scale.controller -- what is the active scale controller?
								
								--deleting the existing active controllers keys in range:
								selectKeys pcnt pffset (pffset + rng)
								deletekeys pcnt #selection
								selectKeys rcnt pffset (pffset + rng)
								deletekeys rcnt #selection
								selectKeys scnt pffset (pffset + rng)
								deletekeys scnt #selection
								
								tr = seek ff 0 --goes to begining of the saved file
								tr = skiptostring ff (o.name + " ") --goes to object line
								
								if (eof ff) == false then  -- tests if the object exists in the saved file
								(
									skiptostring ff "position_controller_type" --goes to saved position controller line --begining of reading position controller
									pct=readvalue ff --gets the saved position controller type
									if pct == pcase pcnt then --tests if the saved position controller type is the same as actual position controller type
									(
										case pct of --loads the position controller keys
										(
											1:( --position_xyz
													knx=readvalue ff
													ffx=""
													for i=1 to knx do ffx=ffx+readline ff
													fflx=ffx as stringstream
													loadBezierKeys pcnt.x_position.controller fflx knx pffset
													
													kny=readvalue ff
													ffy=""
													for i=1 to kny do ffy=ffy+readline ff
													ffly=ffy as stringstream
													loadBezierKeys pcnt.y_position.controller ffly kny pffset
													
													knz=readvalue ff
													ffz=""
													for i=1 to knz do ffz=ffz+readline ff
													fflz=ffz as stringstream
													loadBezierKeys pcnt.z_position.controller fflz knz pffset
													)
											2:( --tcb
													knw=readvalue ff
													ffw=""
													for i=1 to knw do ffw=ffw+readline ff
													fflw=ffw as stringstream
													loadTCBKeys pcnt fflw knw pffset
													)
											3:( --bezier_position
													knw=readvalue ff
													ffw=""
													for i=1 to knw do ffw=ffw+readline ff
													fflw=ffw as stringstream
													loadBezierKeys pcnt fflw knw pffset
													)
											default:()
											)
										)
									else(print ("--some controllers are of a different type than the saved controllers - "+o.name +": " + (pcnt as string)))
									-- end of reading position controller
									
									skiptostring ff "rotation_controller_type" --goes to saved position controller line --begining of reading position controller
									rct=readvalue ff --reads the saved rotation controller type
									if rct == rcase rcnt then --tests if the saved rotation controller type is the same as actual rotation controller type
									(
										case rct of --loads the rotation controller keys
										(
											1:( --euler_xyz
													knx=readvalue ff
													ffx=""
													for i=1 to knx do ffx=ffx+readline ff
													fflx=ffx as stringstream
													loadBezierKeys rcnt.x_rotation.controller fflx knx pffset
													
													kny=readvalue ff
													ffy=""
													for i=1 to kny do ffy=ffy+readline ff
													ffly=ffy as stringstream
													loadBezierKeys rcnt.y_rotation.controller ffly kny pffset
													
													knz=readvalue ff
													ffz=""
													for i=1 to knz do ffz=ffz+readline ff
													fflz=ffz as stringstream
													loadBezierKeys rcnt.z_rotation.controller fflz knz pffset
													)
											2:( --tcb
													knw=readvalue ff
													ffw=""
													for i=1 to knw do ffw=ffw+readline ff
													fflw=ffw as stringstream
													loadTCBKeys rcnt fflw knw pffset
													)
											default:()
											)
										)
									else(print ("--some controllers are of a different type than the saved controllers - "+o.name+": " + (rcnt as string)))
									-- end of reading position controller
										
									skiptostring ff "scale_controller_type" --goes to saved scale controller line --begining of reading scale controller
									sct=readvalue ff --gets the saved scale controller type
									if sct == scase scnt then --tests if the saved scale controller type is the same as actual scale controller type
									(
										case sct of --loads the scale controller keys
										(
											1:( --scale_xyz
													knx=readvalue ff
													ffx=""
													for i=1 to knx do ffx=ffx+readline ff
													fflx=ffx as stringstream
													loadBezierKeys scnt.x_scale.controller fflx knx pffset
													
													kny=readvalue ff
													ffy=""
													for i=1 to kny do ffy=ffy+readline ff
													ffly=ffy as stringstream
													loadBezierKeys scnt.y_scale.controller ffly kny pffset
													
													knz=readvalue ff
													ffz=""
													for i=1 to knz do ffz=ffz+readline ff
													fflz=ffz as stringstream
													loadBezierKeys scnt.z_scale.controller fflz knz pffset
													)
											2:( --tcb
													knw=readvalue ff
													ffw=""
													for i=1 to knw do ffw=ffw+readline ff
													fflw=ffw as stringstream
													loadTCBKeys scnt fflw knw pffset
													)
											3:( --bezier_scale
													knw=readvalue ff
													ffw=""
													for i=1 to knw do ffw=ffw+readline ff
													fflw=ffw as stringstream
													loadBezierKeys scnt fflw knw pffset
													)
											default:()
											)
										)
									else(print ("--some controllers are of a different type than the saved controllers - "+o.name+": " + (pcnt as string)))
									-- end of reading scale controller
									)
								else() -- if the object does not exist in the saved file nothing happens
								)
								
				-- 			pbrr.value = 0 --the progress barr resets
				-- 			lbl4.text="Completed"
							close ff -- close file (i don't know if that's necessary :D)
							)
						else()
					)
				)

				--end save load funcs


				rollout overlapRollout "Overlap Attributes"
				(
					checkbutton dckL "<" align:#left offset:[-10,-5] checked:true tooltip:"Dockable" width:69 height:15
					checkbutton dckR ">" align:#left offset:[82,-20] checked:false tooltip:"Dockable" width:69 height:15
					Button _help  "?" align:#left offset:[60, -20] height:15 tooltip:"InstantRig User Manual" 
	
					on _help pressed do ShellLaunch "http://docs.instantrig.com/rst/animation/sub/overlap.html" ""
					group "Overlapping Action"
					(
						button overlap "Overlap" pos:[16,38] width:56 height:24
						button recover "Recover" pos:[88,38] width:56 height:24
					)
					
					group "Attributes"
					(
						label ctrlLbl "Controller" pos:[32,90] width:48 height:16
						dropDownList ctrlDD ""  pos:[80,85] width:70 height:21 items:#("Both", "Position", "Rotation")
						spinner weightsp "Weight" align:#right range:[0,100,100]
						spinner tensionsp "Tension" align:#right range:[0,30,2]
						spinner dragsp "Drag" align:#right range:[0,30,1]
						spinner rotAffectsp "Rot Influence" align:#right range:[1,10,3]
						spinner redsp "Reduce keys" align:#right range:[0,10,0]
						button rst "Reset Attributes" align:#center width:140 height:16
					)
					
					group "Overlap Range"
					(
						spinner startS "Start" align:#right range:[-9999,9999,0] enabled:false type:#integer
						spinner endS "End" align:#right range:[-9999,9999,100] enabled:false type:#integer
						radioButtons setRange ""  labels:#("Active" , "Custom") columns:2
					)
					fn FNgetdir=
					(
						try
						(
							pth = (pathConfig.GetDir #animations)+ "/savedAnims/"
							makeDir pth
							pth += "overlapParams.prm"
							pth
						)
						catch
						(
							messagebox "Something went wrong!"
							break
						)
					)
					fn loadParams=
					(
						try 
						(
							ff=openfile ((pathConfig.GetDir #animations)+ "/savedAnims/overlapParams.prm")
							
							ctrlDD.selection  = (readvalue ff) as integer
							weightsp.value = (readvalue ff) as float
							tensionsp.value = (readvalue ff) as float
							dragsp.value = (readvalue ff) as float
							rotAffectsp.value = (readvalue ff) as float
							redsp.value = (readvalue ff) as float
							startS.value = (readvalue ff) as integer
							endS.value = (readvalue ff) as integer
							setRange.state  = (readvalue ff) as integer
							
							close ff
						)
						catch()
					)
					fn saveParams =
					(
						try
						(
							ff = createfile ((pathConfig.GetDir #animations)+ "/savedAnims/overlapParams.prm")
							format "%\n" (ctrlDD.selection) to:ff
							format "%\n" (weightsp.value) to:ff
							format "%\n" (tensionsp.value) to:ff
							format "%\n" (dragsp.value) to:ff
							format "%\n" (rotAffectsp.value) to:ff
							format "%\n" (redsp.value) to:ff
							format "%\n" (startS.value) to:ff
							format "%\n" (endS.value) to:ff
							format "%\n" (setRange.state) to:ff
							
							close ff
							
						)
						catch(print "Something went wrong while writing overlapping attributes.")
					)
					
					on ctrlDD selected stt do saveParams()
					on weightsp changed val do saveParams()
					on tensionsp changed val do saveParams()
					on dragsp changed val do saveParams()
					on rotAffectsp changed val do saveParams()
					on redsp changed val do saveParams()
					on startS changed val do saveParams()
					on endS changed val do saveParams()
					
					on rst pressed do 
					(
						ctrlDD.selection  = 1
						weightsp.value = 100
						tensionsp.value = 2
						dragsp.value = 1
						rotAffectsp.value = 3
						redsp.value = 0
					)
					
					on overlapRollout open do
					(
						loadParams()
						
						if setRange.state == 1 then
						(
							startS.enabled = false
							endS.enabled = false
						)
						else
						(
							startS.enabled = true
							endS.enabled = true
						)
					)

					on setRange changed state do
					(
						if state == 1 then
						(
							startS.enabled = false
							endS.enabled = false
						)
						else
						(
							startS.enabled = true
							endS.enabled = true
						)
						saveParams()
					)
					
					on overlap pressed do
					(
						set animate off
				-- 		ctrls = for i in refsArray[1].oCtrls collect i.node
				-- 		bns = for i in refsArray[1].oBones collect i.node
						
						startTime = animationRange.start
						endTime = animationRange.end
						
						if setRange.state == 2 do
						(
							startTime = startS.value as time
							endTime = endS.value as time
						)
						
						crTime = currenttime
						crAnimationRangeStart = animationRange.start
						crAnimationRangeEnd = animationRange.end
						animationRange = interval startTime endTime
						slidertime =  animationRange.start

						for i in selection do
						(
							try
							(
								dist = i._overlapDist
								pth = (pathConfig.GetDir #animations)+ "/recoverAnim/"
								makeDir pth
								saveOverlapAnim #(i) (pth+i.name+".anim") startTime endTime
						
								mainSprng = point cross:false centermarker:false box:false axistripod:false size:5
								mainSprng.transform = i.transform
								mainSprng.parent = i
								
								ctrlType = ctrlDD.selected
								
								if (dist[1] == 0 and dist[2] == 0) do ctrlType = ctrlDD.items[2]
							
								lookatPrnt= point cross:false centermarker:false box:false axistripod:false size:5
								lookatPrnt.transform = i.transform
								lookatPrnt.parent = mainSprng
								lookatPrnt.pos.xposition.controller.value += dist[1]*(21-rotAffectsp.value*2)

								lookatSprng= point cross:false centermarker:false box:false axistripod:false size:5
								lookatSprng.transform = lookatPrnt.transform
								lookatSprng.parent = lookatPrnt
								
								lookSidePrnt= point cross:false centermarker:false box:false axistripod:false size:5
								lookSidePrnt.transform = i.transform
								lookSidePrnt.parent = mainSprng
								lookSidePrnt.pos.zposition.controller.value += dist[2]*(21-rotAffectsp.value*2)

								lookSideSprng= point cross:false centermarker:false box:false axistripod:false size:5
								lookSideSprng.transform = lookSidePrnt.transform
								lookSideSprng.parent = lookSidePrnt

								mainSprng.position.controller = positionlist()
								mainSprng.position.available.controller = SpringPositionController()
								mainSprng.position.controller[2].setDrag dragsp.value
								mainSprng.position.controller[2].setTension 1 tensionsp.value
								mainSprng.position.controller[#Weights].Weight__Spring = weightsp.value
								mainSprng.position.controller[2].start = startTime

								lookatSprng.position.controller = positionlist()
								lookatSprng.position.available.controller = SpringPositionController()
								lookatSprng.position.controller[2].setDrag dragsp.value
								lookatSprng.position.controller[2].setTension 1 tensionsp.value
								lookatSprng.position.controller[#Weights].Weight__Spring = weightsp.value
								lookatSprng.position.controller[2].start = startTime
								
								lookSideSprng.position.controller = positionlist()
								lookSideSprng.position.available.controller = SpringPositionController()
								lookSideSprng.position.controller[2].setDrag dragsp.value
								lookSideSprng.position.controller[2].setTension 1 tensionsp.value
								lookSideSprng.position.controller[#Weights].Weight__Spring = weightsp.value
								lookSideSprng.position.controller[2].start = startTime

								mainPnt = point cross:false centermarker:false box:false axistripod:false size:2
								mainPnt.transform = mainSprng.transform
								mainPnt.parent = mainSprng

								lkt = lookat_Constraint ()
								lkt.lookat_vector_length = 0
								lkt.target_axis = 0
								lkt.upnode_ctrl = 0
								lkt.StoUP_axis = 2
								lkt.upnode_axis = 2
								lkt.pickUpNode = lookSideSprng
								lkt.upnode_world = off
								lkt.appendTarget lookatSprng 100
								mainPnt.rotation.controller = lkt	

								p = PRS() -- Create standard transform controller to bake keys into
								p.position.controller = position_xyz()       
								p.rotation.controller = euler_xyz()       
								p.scale.controller = linear_scale()

								for t = startTime to endTime by 1 do 
								(
									animate on at time t 
									(
										p.value = mainPnt.transform
									)
								)
								scl = copy i.scale.track
								ps = copy i.position.track
								for t = startTime to endTime by 1 do 
								(
									animate on at time t 
									(
										case ctrlType of
										(
										"Position": i.pos = p.position
										"Rotation": i.transform = p.value
										default: 
											(
												i.transform = p.value
											)
										)
									)
								)
								
								if redsp.value > 0 do
								(
-- 									setCommandPanelTaskMode #create
									case ctrlType of
										(
										--bütün floating toolbarlari kaldiriyor??
										"Position": t = reduceKeys i.pos.controller redsp.value 1f animationrange
										"Rotation": t = reduceKeys i.rotation.controller redsp.value 1f animationrange
										default: 
											(
												t = reduceKeys i.pos.controller redsp.value 1f animationrange
												t = reduceKeys i.rotation.controller redsp.value 1f animationrange
											)
										)
									
									
-- 									setCommandPanelTaskMode #modify
								)
								
								i.scale.track = scl
								if (ctrlType == "Rotation") do
								(
									i.position.track = ps
								)
								

								try (delete mainSprng) catch()
								try (delete lookatPrnt) catch()
								try (delete lookatSprng) catch()
								try (delete mainPnt) catch()
								try (delete lookSideSprng) catch()
								try (delete lookSidePrnt) catch()
								
							set animate on
							)
							catch
							(
								print (i.name + " is not a node of instantrig")
							)
						)
-- 						try 
-- 							(
-- 								uiaccessor.closedialog (windows.getchildhwnd 0 "MAXScript Listener")[1]
-- 								if cui.commandPanelOpen do
-- 								(
-- 									actionMan.executeAction 0 "408"
-- 									actionMan.executeAction 0 "408"
-- 								)
-- 							)catch()
						animationRange = interval crAnimationRangeStart crAnimationRangeEnd
						slidertime =  crTime
					)
					on recover pressed do
					(
						for i in selection do
						(
							try
							(
								dist = i._overlapDist
								pth = (pathConfig.GetDir #animations)+ "/recoverAnim/"
								loadOverlapAnim #(i) (pth+i.name+".anim")
							)
							catch
							(
								print ("Recover animation cannot be loaded on " + i.name)
							)
						)
					)
					
					on dckL changed state do 
					(
						if state then
						(
							dckR.state = false
							cui.RegisterDialogBar overlapFloater minSize:[180,100] maxSize:[180,366] style:#(#cui_max_sized, #cui_dock_all, #cui_floatable, #cui_handles) 
							cui.DockDialogBar overlapFloater #cui_dock_left
				-- 			cui.floatdialogbar iPicker
						)
						else
						(
				-- 			cui.floatdialogbar iPicker
							cui.UnRegisterDialogBar overlapFloater
						)
					)
					on dckR changed state do 
					(
						if state then
						(
							dckL.state = false
							cui.RegisterDialogBar overlapFloater minSize:[180,100] maxSize:[180,366] style:#(#cui_max_sized, #cui_dock_all, #cui_floatable, #cui_handles) 
							cui.DockDialogBar overlapFloater #cui_dock_right
				-- 			cui.floatdialogbar iPicker
						)
						else
						(
				-- 			cui.floatdialogbar iPicker
							cui.UnRegisterDialogBar overlapFloater
						)
					)
				)
				
				try (cui.UnRegisterDialogBar overlapFloater; closeRolloutFloater overlapFloater)catch()
				try closeRolloutFloater overlapFloater catch()
				overlapFloater = newRolloutFloater "Overlap" 180 366
				overlapFloater.pos = [10,50]
				cui.RegisterDialogBar overlapFloater minSize:[180,100] maxSize:[180,366] style:#(#cui_max_sized, #cui_dock_all, #cui_floatable, #cui_handles) 
				cui.DockDialogBar overlapFloater #cui_dock_left
-- 				cui.floatdialogbar overlapFloater

				addRollout overlapRollout overlapFloater
				clearListener()
			)

			button launch "Launch!" width:120 height:20
			
			on launch pressed do
			(
				_createDialog()
			)
		)
	)
	Custattributes.add fn_target.modifiers[#attributes] curve_ca
)
fn FN_addPoseManager fn_target=
(
	curve_ca = attributes pmAtt
	(
		Rollout pmAtts "Pose Manager"
		(
			fn _createDialog=
			(
				global FNgetFilePath
				global loadSaveFloater
				global loadSaveRoll
				global FN_updateRollout
				global FN_saveLoadCallback
				global mirrorMatrixFn
				
				fn FNgetFilePath _name=
				(
					try
					(
						pth = (pathConfig.GetDir #animations)+ "/savedAnims/"
						makeDir pth
						pth += _name+".anim"
						pth
					)
					catch
					(
						messagebox "Something went wrong!"
						break
					)
				)
				fn mirrorMatrixFn \
				axis:"z" 				/*(Axis to mirror over)*/
				flip:"z" 				/*(Axis to flip)*/
				tm:(matrix3 1) 			/*(Matrix to mirror)*/
				pivotTm:(matrix3 1) 	/*(Matrix to mirror around)*/
				=						/*By Mike Biddlecombe and Paul Neale.  I'm just ripping it off!*/
				(
					fn FetchReflection a =
					(
						case a of
						(
							"x": [-1,1,1]  -- reflect in YZ plane
							"y": [1,-1,1]  --         in ZX plane
							"z": [1,1,-1]  --         in XY plane
							"xy": [-1,-1,1]
							"yz": [1,-1,-1]
							"xz": [-1,1,-1]
							"xyz": [-1,-1,-1]
							"no": [1,1,1]
						)
					)

					aReflection = scalematrix (FetchReflection axis)
					fReflection = scalematrix (FetchReflection flip)

					fReflection * (tm * (inverse pivotTm)) * aReflection * pivotTm
				)
				fn FN_updateRollout=
				(
					if selection.count == 0 then
					(
						for i in loadSaveFloater.rollouts[1].controls do
						(
				-- 			loadSaveFloater.rollouts[1]._smh.state = 1
							if i != loadSaveFloater.rollouts[1]._help and i != loadSaveFloater.rollouts[1].dckL and i != loadSaveFloater.rollouts[1].dckR do i.enabled = false
						)

					)
					else if selection.count > 0 then
					(
							try 
							(
								selection[1].isFinger
								for i in loadSaveFloater.rollouts[1].controls do
								(
									i.enabled=true
								)
								if loadSaveFloater.rollouts[1]._smh.state == 1 then
								(
									loadSaveFloater.rollouts[1]._flip.enabled = false
									if doesFileExist (FNgetFilePath "poseInd1") then loadSaveFloater.rollouts[1]._paste.enabled = true
										else loadSaveFloater.rollouts[1]._paste.enabled = false
								)
								else
								(
									loadSaveFloater.rollouts[1]._flip.enabled = true
									if selection[1].currentModuleCtrl.node._type== 1 do --root
									(
										if doesFileExist (FNgetFilePath "copyRootModule") then loadSaveFloater.rollouts[1]._paste.enabled = true
										else loadSaveFloater.rollouts[1]._paste.enabled = false
									)
									if selection[1].currentModuleCtrl.node._type== 2 do --hub
									(
										if doesFileExist (FNgetFilePath "copyHubModule") then loadSaveFloater.rollouts[1]._paste.enabled = true
										else loadSaveFloater.rollouts[1]._paste.enabled = false
										
									)
									if selection[1].currentModuleCtrl.node._type== 3 do --tail
									(
										if doesFileExist (FNgetFilePath "copyTailModule") then loadSaveFloater.rollouts[1]._paste.enabled = true
										else loadSaveFloater.rollouts[1]._paste.enabled = false
									)
									if selection[1].currentModuleCtrl.node._type== 4 do --arm
									(
										if doesFileExist (FNgetFilePath "copyArmModule") then loadSaveFloater.rollouts[1]._paste.enabled = true
										else loadSaveFloater.rollouts[1]._paste.enabled = false
									)
									if selection[1].currentModuleCtrl.node._type== 5 do --leg
									(
										if doesFileExist (FNgetFilePath "copyLegModule") then loadSaveFloater.rollouts[1]._paste.enabled = true
										else loadSaveFloater.rollouts[1]._paste.enabled = false
									)
									if selection[1].currentModuleCtrl.node._type== 6 do --spine
									(
										if doesFileExist (FNgetFilePath "copySpineModule") then loadSaveFloater.rollouts[1]._paste.enabled = true
										else loadSaveFloater.rollouts[1]._paste.enabled = false
									)
								)
							)
							catch
							(
								for i in loadSaveFloater.rollouts[1].controls do
								(
									if i != loadSaveFloater.rollouts[1]._help and i != loadSaveFloater.rollouts[1].dckL and i != loadSaveFloater.rollouts[1].dckR do i.enabled = false
								)
							)
					)
				)
				fn FN_saveLoadCallback=
				(
					FN_updateRollout()
				)
				Rollout loadSaveRoll "Pose Manager"
				(
					checkbutton dckL "<" align:#left offset:[-10,-5] checked:true tooltip:"Dockable" width:69 height:15
					checkbutton dckR ">" align:#left offset:[82,-20] checked:false tooltip:"Dockable" width:69 height:15
					Button _help  "?" align:#left offset:[60, -20] height:15 tooltip:"InstantRig User Manual" 
	
					on _help pressed do ShellLaunch "http://docs.instantrig.com/rst/animation/sub/posemanager.html" ""

					group "Action"
					(
						radioButtons _smh "" pos:[25,40]  labels:#("Single" , "Module") columns:2 enabled:false
						button _copy "Copy" pos:[10,60] width:48 height:22 enabled:false
						button _paste "Paste" pos:[58,60] width:48 height:22 enabled:false
						button _flip "Flip" pos:[106,60] width:48 height:22 enabled:false
						button _rst "Reset" pos:[10,85] width:71 height:20
						button _clr "Clear Cache" pos:[83,85] width:71 height:20

				-- 		button _save "Save" pos:[10,40] width:60 height:20 enabled:false visible:false
				-- 		button _load "Load" pos:[10,62] width:60 height:20 enabled:false visible:false
						
					)
					
					fn FNmrrPlane _node=
					(
						mrrPlane = point cross:false centermarker:false box:false axistripod:false size:20
						mrrPlane.pos = _node.pos + [0,0,-5]
						mrrPlane.rotation.controller = lookat_Constraint ()
						mrrPlane.rotation.controller.lookat_vector_length = 0
						mrrPlane.rotation.controller.target_axis = 0
						mrrPlane.rotation.controller.upnode_axis = 2
						mrrPlane.rotation.controller.StoUP_axis = 2
						mrrPlane.rotation.controller.upnode_world = off
						mrrPlane.rotation.controller.pickUpNode = _node
						mrrPlane.rotation.controller.appendTarget _node 100;
						
						mrrP = point cross:false centermarker:false box:false axistripod:false size:20
						mrrP.transform = mrrPlane.transform
						mrrP.scale = _node.scale
						delete mrrPlane
						mrrP.pos.z += 5
						
						
						mrrP
					)
					
					fn _rstSelected i=
					(
						try
						(
							if i.currentModuleCtrl.node._type==1 then i.transform = i.m3a
							else 
							(
								if i.isAttCtrl do
								(
									i.modifiers[#attributes].uLength = i.modifiers[#attributes].uLengthAct
									i.modifiers[#attributes].lLength = i.modifiers[#attributes].lLengthAct
									i.modifiers[#attributes].tLength = i.modifiers[#attributes].uLength + i.modifiers[#attributes].lLength
									i.modifiers[#attributes].ikfk = 1.0
									if i._type == 5 do i.modifiers[#attributes].ikfk = 0.0
									i.modifiers[#attributes].fk_AbRel = 0.0
									i.modifiers[#attributes].softIK = 0.0
									i.modifiers[#attributes].ikStretch = 1.0
									i.modifiers[#attributes].poleSnap = 0.0
									i.modifiers[#attributes].squash  = 0.0
									i.modifiers[#attributes].curve  = 0.0
									i.modifiers[#attributes].constant = true
									i.modifiers[#attributes].followU = 0.5
									i.modifiers[#attributes].followM = 0.5
									i.modifiers[#attributes].followL = 0.5
									i.modifiers[#attributes]._scale = 1.0
								)
								
								if i.isChest do
								(
									i.modifiers[#attributes].cPos = false
									i.modifiers[#attributes].cOrient = 1.0
									i.modifiers[#attributes].cOrientPivot = 0.0
									i.modifiers[#attributes]._tanh = 0.5
									i.modifiers[#attributes].squash = 0.0
									i.modifiers[#attributes].constant = true
									
									i.modifiers[#attributes].spineAttributes.params.cOrient.enabled = true
									i.modifiers[#attributes].spineAttributes.params.cOrientPivot.enabled = true 
								)
								
								if i.isfoot then
								(
									_pivot = FNmrrPlane i.prnt.node
									i.transform = i.m3a*_pivot.transform
									delete _pivot
								)
								else i.transform = i.m3a*i.prnt.node.transform
							)
						)catch()
					)
					-------------------------------------------------------------
					on loadSaveRoll open do
					(
						FN_updateRollout()
						callbacks.addScript #selectionSetChanged "FN_saveLoadCallback()" id:#savLoadUpdate
					)
					on loadSaveRoll close do
					(
						callbacks.removeScripts id:#savLoadUpdate
				-- 		loadSaveRoll = undefined
				-- 		loadSaveFloater = undefined
					)
					on dckL changed state do 
					(
						if state then
						(
							dckR.state = false
							cui.RegisterDialogBar loadSaveFloater minSize:[180,100] maxSize:[180,152] style:#(#cui_max_sized, #cui_dock_all, #cui_floatable, #cui_handles) 
							cui.DockDialogBar loadSaveFloater #cui_dock_left
				-- 			cui.floatdialogbar iPicker
						)
						else
						(
				-- 			cui.floatdialogbar iPicker
							cui.UnRegisterDialogBar loadSaveFloater
						)
					)
					on dckR changed state do 
					(
						if state then
						(
							dckL.state = false
							cui.RegisterDialogBar loadSaveFloater minSize:[180,100] maxSize:[180,152] style:#(#cui_max_sized, #cui_dock_all, #cui_floatable, #cui_handles) 
							cui.DockDialogBar loadSaveFloater #cui_dock_right
				-- 			cui.floatdialogbar iPicker
						)
						else
						(
				-- 			cui.floatdialogbar iPicker
							cui.UnRegisterDialogBar loadSaveFloater
						)
					)
					on _smh changed state do 
					(
						FN_updateRollout()
					)
					on _clr pressed do
					(
						pth = (pathConfig.GetDir #animations)+ "/savedAnims/"
						files = getFiles (pth+"*.anim")
						for i in files do deletefile i
						FN_updateRollout()
					)
					on _rst pressed do
					(
						with undo on
						(
							if _smh.state == 1 then
							(
								fingers = #()
								iks = #()
								for i in selection do
								(
									try
									(
										if i.isfinger then
										(
											append fingers i
										)
										else if i.isIK then
										(
											append iks i
										)
										else
										(
											_rstSelected i
										)
										
									)
									catch(print (i.name + " is not a node of instantrig"))
								)

								if fingers.count > 0 do
								(
									try (for i in fingers do _rstSelected i)
										catch(print ("Something went wrong."))
								)

								if iks.count > 0 do
								(
									try
									(
										for i in iks do
										(
											_rstSelected i
										)
									)
									catch(print ("Something went wrong."))
								)
							)
							else
							(
								try
								(
									moduleCtrl = selection[1].currentModuleCtrl.node
									if moduleCtrl._type== 1 do --root
									(
										_rstSelected moduleCtrl
									)
									if moduleCtrl._type== 2 do --hub
									(
										for i in moduleCtrl.hubCtrls do
										(
											_rstSelected i.node
										)
									)
									if moduleCtrl._type== 3 do --tail
									(
										for i in moduleCtrl.tailCtrls do
										(
											_rstSelected i.node
										)

										for i in moduleCtrl.tailSprings do
										(
											_rstSelected i.node
										)
									)
									if moduleCtrl._type== 4 or moduleCtrl._type== 5 do --arm
									(
										fingers = #()
										iks = #()
										
										--shoulder
										_rstSelected moduleCtrl.shoulderCtrl.node
										
										--fk
										for i in moduleCtrl.fkCtrls do
										(
											_rstSelected i.node
										)
										-- ik
										for i in moduleCtrl.ikCtrls do
										(
											if i.node.isIK then
											(
												append iks i.node
											)
											else
											(
												_rstSelected i.node
											)
										)
										--blend
										for i in moduleCtrl.blendCtrls do
										(
											_rstSelected i.node
										)
										
										--bend
										for i in moduleCtrl.bendCtrls do
										(
											_rstSelected i.node
										)

										--fingers
										for i in moduleCtrl.fingerCtrls do --i = parmaktaki bone sayisi
										(
											if i.node.isfinger then
											(
												append fingers i.node
											)
											else
											(
												_rstSelected i.node
											)
										)
										
										if fingers.count > 0 do
										(
											try (for i in fingers do _rstSelected i)
												catch(print ("Something went wrong."))
										)

										if iks.count > 0 do
										(
											try (for i in iks do _rstSelected i)
												catch(print ("Something went wrong."))
										)
										
									)
									if moduleCtrl._type== 6 do --spine
									(
										for i in moduleCtrl.spineCtrls do
										(
											_rstSelected i.node
										)
									)
								)catch(print "something went wrong")
							)
						)
					)
					---------------------------------
					fn FNcopyPose _node =
					(
						local trsfm;
-- 						try
-- 						(							
							if  _node.isFoot then 
							(
								_pivot = FNmrrPlane _node.prnt.node
								trsfm = _node.transform*(inverse _pivot.transform)
								delete _pivot
							)
							else (trsfm = _node.transform*(inverse _node.prnt.node.transform))
							
-- 						)
-- 						catch
-- 						(
-- 							print "something went wrong on " + _node.name as string
-- 						)
						trsfm
					)
					fn FNpastePose _node trsfm mrr:false=
					(
						try
						(
							local _pivot
							local _del = false
							if  _node.isFoot then
							(
								_pivot = FNmrrPlane _node.prnt.node
								_del = true
							)
							else (_pivot = _node.prnt.node)
							
							trsfm = trsfm*_pivot.transform
							
							if mrr do 
							(
								if _node.mrrAxis.count > 0 then
								(
									trsfm = mirrorMatrixFn axis:_node.mrrAxis[1] flip:_node.mrrAxis[2] tm:trsfm pivottm:_node.prnt.node.transform
								)
								else 
								(
									trsfm = mirrorMatrixFn tm:trsfm pivottm:_pivot.transform
								)
							)
							if _del do delete _pivot;
							_node.transform  = trsfm
						)
						catch
						(
							print "something went wrong on " + _node.name as string
						)
					)
					--- copy ind fn
					fn FNcopyPoseInd _node ss=
					(
						addCounter = 1
						try
						(
							mrr = _node.currentModuleCtrl.node.mrr
							ff = createfile ss --creates the save file
							format "%\n" mrr to:ff
							format "%" (FNcopyPose _node) to:ff --writes the position controller type
							close ff
						)
						catch(print (_node.name as string + " is not a part of instantrig");addCounter = 0)
						addCounter
					)
					fn FNpastePoseInd _node ss=
					(
						addCounter = 1
						try
						(
							currentMRR = _node.currentModuleCtrl.node.mrr
							ff=openfile ss --opens the saved file
							incomingMRR = readvalue ff
							mrr = false
							if ((currentMRR and (not incomingMRR)) or ((not currentMRR) and incomingMRR)) do mrr = true
							
							trsfm = (readvalue ff) as matrix3
							
							FNpastePose _node trsfm mrr:mrr
								
							close ff
						)
						catch(print (_node.name as string + " is not a part of instantrig"); addCounter = 0 )
						addCounter
					)
					---------------------
					--- copy module fn
					fn FNcopyRootModule moduleCtrl ff=
					(
						format "%" (FNcopyPose moduleCtrl) to:ff
					)
					fn FNcopyHubModule moduleCtrl ff=
					(
						for i in moduleCtrl.hubCtrls do
						(
							format "%\n" (FNcopyPose i.node) to:ff
						)
					)
					fn FNcopyTailModule moduleCtrl ff=
					(
							format "%\n" (moduleCtrl.tailCtrls.count) to:ff
							for i in moduleCtrl.tailCtrls do
							(
								format "%\n" (FNcopyPose i.node) to:ff
							)

							format "%\n" (moduleCtrl.tailSprings.count) to:ff
							for i in moduleCtrl.tailSprings do
							(
								format "%\n" (FNcopyPose i.node) to:ff
							)
					)
					fn FNcopyLimbModule moduleCtrl ff=
					(
						format "%\n" moduleCtrl.mrr to:ff
						--shoulder 
						format "%\n" (FNcopyPose moduleCtrl.shoulderCtrl.node) to:ff
						--fk
						for i in moduleCtrl.fkCtrls do
						(
							format "%\n" (FNcopyPose i.node) to:ff
						)
						-- ik
						for i in moduleCtrl.ikCtrls do
						(
							format "%\n" (FNcopyPose i.node) to:ff
						)
						--blend
						for i in moduleCtrl.blendCtrls do
						(
							format "%\n" (FNcopyPose i.node) to:ff
						)
						--bend
						format "%\n" (moduleCtrl.bendCtrls.count) to:ff
						for i in moduleCtrl.bendCtrls do
						(
							format "%\n" (FNcopyPose i.node) to:ff
						)
						--fingers
						format "%\n" (moduleCtrl.fingerLists.count) to:ff
						fbCount = 0
						for i in moduleCtrl.fingerLists do --i = parmaktaki bone sayisi
						(
							format "%\n" i to:ff
							for f=1 to i do
							(
								if f==1 do
								(
									for k=2 to i-1 do
									(
										format "%\n" moduleCtrl.fingerCtrls[f+fbCount].node.modifiers[#attributes].fingerAttributes["knuckle_"+(k-1) as string].value to:ff
									)
								)
								format "%\n" (FNcopyPose moduleCtrl.fingerCtrls[f+fbCount].node) to:ff
							)
							fbCount+=i
						)
						format "%\n" moduleCtrl.modifiers[#attributes].tLength to:ff
						format "%\n" moduleCtrl.modifiers[#attributes].uLength to:ff
						format "%\n" moduleCtrl.modifiers[#attributes].lLength to:ff
						format "%\n" moduleCtrl.modifiers[#attributes].ikfk to:ff
						format "%\n" moduleCtrl.modifiers[#attributes].fk_AbRel to:ff
						format "%\n" moduleCtrl.modifiers[#attributes].softIK to:ff
						format "%\n" moduleCtrl.modifiers[#attributes].ikStretch to:ff
						format "%\n" moduleCtrl.modifiers[#attributes].poleSnap to:ff
						format "%\n" moduleCtrl.modifiers[#attributes].squash to:ff
						format "%\n" moduleCtrl.modifiers[#attributes].curve to:ff
						format "%\n" moduleCtrl.modifiers[#attributes].constant to:ff
						format "%\n" moduleCtrl.modifiers[#attributes].followU to:ff
						format "%\n" moduleCtrl.modifiers[#attributes].followM to:ff
						format "%\n" moduleCtrl.modifiers[#attributes].followL to:ff
						format "%\n" moduleCtrl.modifiers[#attributes]._scale to:ff
					)
					fn FNcopySpineModule moduleCtrl ff=
					(
						format "%\n" (FNcopyPose moduleCtrl.spineCtrls[1].node) to:ff
						format "%\n" (FNcopyPose moduleCtrl.spineCtrls[2].node) to:ff
						
						format "%\n" (moduleCtrl.spineCtrls.count) to:ff
						
						for i=3 to moduleCtrl.spineCtrls.count do
						(
							format "%\n" (FNcopyPose moduleCtrl.spineCtrls[i].node) to:ff
						)
					)
					fn FNpasteRootModule moduleCtrl ff=
					(
						trsfm = (readvalue ff) as matrix3
						FNpastePose moduleCtrl trsfm
					)
					fn FNpasteHubModule moduleCtrl ff=
					(
						for i in moduleCtrl.hubCtrls do
						(
							trsfm = (readvalue ff) as matrix3
							FNpastePose i.node trsfm
						)
					)
					fn FNpasteTailModule moduleCtrl ff=
					(
						_tailCtrlCount =  (readvalue ff) as integer
						for i=1 to _tailCtrlCount do
						(
							try
							(
							trsfm = (readvalue ff) as matrix3
							FNpastePose moduleCtrl.tailCtrls[i].node trsfm
							)catch()
						)
						_tailSpringCount =  (readvalue ff) as integer
						for i=1 to _tailSpringCount do
						(
							try
							(
							trsfm = (readvalue ff) as matrix3
							FNpastePose moduleCtrl.tailSprings[i].node trsfm
							)catch()
						)
					)
					fn FNpasteLimbModule moduleCtrl ff isFoot:false=
					(
						currentMRR = moduleCtrl.mrr
						incomingMRR = readvalue ff
						mrr = false
						if ((currentMRR and (not incomingMRR)) or ((not currentMRR) and incomingMRR)) do mrr = true
						
						--shoulder
						trsfm = (readvalue ff) as matrix3
						FNpastePose moduleCtrl.shoulderCtrl.node trsfm  mrr:mrr
						--fk
						if isFoot then
						(
							trsfm = (readvalue ff) as matrix3
							FNpastePose moduleCtrl.fkCtrls[1].node trsfm  mrr:mrr axis:"z" flip:"no"
							trsfm = (readvalue ff) as matrix3
							FNpastePose moduleCtrl.fkCtrls[2].node trsfm mrr:mrr axis:"xyz" flip:"no"
							trsfm = (readvalue ff) as matrix3
							FNpastePose moduleCtrl.fkCtrls[3].node trsfm mrr:mrr axis:"xyz" flip:"z"
							trsfm = (readvalue ff) as matrix3
							FNpastePose moduleCtrl.fkCtrls[4].node trsfm mrr:mrr axis:"z" flip:"no"
						)
						else
						(
							for i =1 to moduleCtrl.fkCtrls.count do
							(
								trsfm = (readvalue ff) as matrix3
								if i==1 then FNpastePose moduleCtrl.fkCtrls[i].node trsfm  mrr:mrr axis:"z" flip:"no"
								else FNpastePose moduleCtrl.fkCtrls[i].node trsfm mrr:mrr axis:"xyz" flip:"no"
							)
						)
						-- ik
						for i in moduleCtrl.ikCtrls do
						(
							trsfm = (readvalue ff) as matrix3
							FNpastePose i.node trsfm mrr:mrr
						)
						--blend
						for i in moduleCtrl.blendCtrls do
						(
							trsfm = (readvalue ff) as matrix3
							FNpastePose i.node trsfm mrr:mrr
						)
						--bend
						_bendCtrlsCount =  (readvalue ff) as integer
						if moduleCtrl.bendCtrls.count == _bendCtrlsCount then
						(
							for i in moduleCtrl.bendCtrls do
							(
								trsfm = (readvalue ff) as matrix3
								FNpastePose i.node trsfm mrr:mrr
							)
						)
						else
						(
							for i=1 to _bendCtrlsCount do
							(
								trsfm = (readvalue ff) as matrix3
							)
						)
						--fingers
						_fingersCount =  (readvalue ff) as integer
						fbCount = 0
						for i=1 to _fingersCount do --i = parmaktaki bone sayisi
						(
							_BoneCount =  (readvalue ff) as integer
							for f=1 to _BoneCount do
							(
								if f==1 do
								(
									for k=2 to _BoneCount-1 do
									(
										knuckleVal =  (readvalue ff) as integer
										try( moduleCtrl.fingerCtrls[f+fbCount].node.modifiers[#attributes].fingerAttributes["knuckle_"+(k-1) as string].value = knuckleVal) catch(print "additional knuckle value has not been pasted")
									)
								)
								trsfm = (readvalue ff) as matrix3
								try (FNpastePose moduleCtrl.fingerCtrls[f+fbCount].node trsfm mrr:mrr)catch(print "additional finger bone has not been pasted")
							)
							try (fbCount+=moduleCtrl.fingerlists[i])catch(print "additional finger has not been pasted")
						)
						moduleCtrl.modifiers[#attributes].tLength = (readvalue ff) as float
						moduleCtrl.modifiers[#attributes].uLength =  (readvalue ff) as float
						moduleCtrl.modifiers[#attributes].lLength = (readvalue ff) as float
						moduleCtrl.modifiers[#attributes].ikfk = (readvalue ff) as float
						moduleCtrl.modifiers[#attributes].fk_AbRel = (readvalue ff) as float
						moduleCtrl.modifiers[#attributes].softIK = (readvalue ff) as float
						moduleCtrl.modifiers[#attributes].ikStretch = (readvalue ff) as float
						moduleCtrl.modifiers[#attributes].poleSnap = (readvalue ff) as float
						moduleCtrl.modifiers[#attributes].squash = (readvalue ff) as float
						moduleCtrl.modifiers[#attributes].curve = (readvalue ff) as float
						moduleCtrl.modifiers[#attributes].constant = (readvalue ff)
						moduleCtrl.modifiers[#attributes].followU = (readvalue ff) as float
						moduleCtrl.modifiers[#attributes].followM = (readvalue ff) as float
						moduleCtrl.modifiers[#attributes].followL = (readvalue ff) as float
						moduleCtrl.modifiers[#attributes]._scale = (readvalue ff) as float
					)
					fn FNpasteSpineModule moduleCtrl ff=
					(
						trsfm = (readvalue ff) as matrix3
						FNpastePose moduleCtrl.spineCtrls[1].node trsfm
						trsfm = (readvalue ff) as matrix3
						FNpastePose moduleCtrl.spineCtrls[2].node trsfm
						
						_spineCount =  (readvalue ff) as integer
						
						for i=3 to _spineCount do
						(
							try
							(
								trsfm = (readvalue ff) as matrix3
								FNpastePose moduleCtrl.spineCtrls[i].node trsfm
							)catch()
						)
					)
					fn FNcopyPoseModule moduleCtrl=
					(
						if moduleCtrl._type== 1 do --root
						(
							ff = createfile (FNgetFilePath "copyRootModule") --creates the save file
							FNcopyRootModule moduleCtrl ff
							close ff
						)
						if moduleCtrl._type== 2 do --hub
						(
							ff = createfile (FNgetFilePath "copyHubModule") --creates the save file
							FNcopyHubModule moduleCtrl ff
							close ff
						)
						if moduleCtrl._type== 3 do --tail
						(
							ff = createfile (FNgetFilePath "copyTailModule")
							FNcopyTailModule moduleCtrl ff
							close ff
						)
						if moduleCtrl._type== 4 do --arm
						(
							ff = createfile (FNgetFilePath "copyArmModule")
							FNcopyLimbModule moduleCtrl ff
							close ff
						)
						if moduleCtrl._type== 5 do --leg
						(
							ff = createfile (FNgetFilePath "copyLegModule")
							FNcopyLimbModule moduleCtrl ff
							close ff
						)
						if moduleCtrl._type== 6 do --spine
						(
							ff = createfile (FNgetFilePath "copySpineModule")
							FNcopySpineModule moduleCtrl ff
							close ff
						)
						
					)
					fn FNpastePoseModule moduleCtrl=
					(		
						if moduleCtrl._type== 1 do --root
						(
							ff = openfile (FNgetFilePath "copyRootModule") --creates the save file
							FNpasteRootModule moduleCtrl ff
							close ff
						)
						if moduleCtrl._type== 2 do --hub
						(
							ff = openfile (FNgetFilePath "copyHubModule") --creates the save file
							FNpasteHubModule moduleCtrl ff
							close ff
						)
						if moduleCtrl._type== 3 do --tail
						(
							ff = openfile (FNgetFilePath "copyTailModule")
							FNpasteTailModule moduleCtrl ff
							close ff
						)
						if moduleCtrl._type== 4 do --arm
						(
							ff = openfile (FNgetFilePath "copyArmModule")
							FNpasteLimbModule moduleCtrl ff
							close ff
						)
						if moduleCtrl._type== 5 do --leg
						(
							ff = openfile (FNgetFilePath "copyLegModule")
							FNpasteLimbModule moduleCtrl ff isFoot:true
							close ff
						)
						if moduleCtrl._type== 6 do --spine
						(
							ff = openfile (FNgetFilePath "copySpineModule")
							FNpasteSpineModule moduleCtrl ff
							close ff
						)
					)
					fn FNpastePoseModuleFlip moduleCtrl=
					(
						if moduleCtrl._type== 1 do --root
						(
							mrrPlane = FNmrrPlane moduleCtrl
							moduleCtrl.transform = mirrorMatrixFn axis:"z" flip:"z" tm:moduleCtrl.transform pivottm:mrrPlane.transform
							delete mrrPlane
						)
						if moduleCtrl._type== 2 do --hub
						(
							mrrPlane = FNmrrPlane moduleCtrl
							for i = 1 to moduleCtrl.hubCtrls.count do
							(
								 if i == 1 then moduleCtrl.hubCtrls[i].node.transform = mirrorMatrixFn axis:"z" flip:"z" tm: moduleCtrl.hubCtrls[i].node.transform pivottm:mrrPlane.transform
									 else moduleCtrl.hubCtrls[i].node.transform = mirrorMatrixFn axis:"z" flip:"z" tm: moduleCtrl.hubCtrls[i].node.transform pivottm:moduleCtrl.hubCtrls[1].node.transform
							)
							delete mrrPlane
						)
						if moduleCtrl._type== 3 do --tail
						(
							for i in moduleCtrl.tailCtrls do
							(
								i.node.transform = mirrorMatrixFn axis:"z" flip:"z" tm: i.node.transform pivottm:i.node.prnt.node.transform
							)
							for i in moduleCtrl.tailSprings do
							(
								i.node.transform = mirrorMatrixFn axis:"z" flip:"z" tm: i.node.transform pivottm:i.node.prnt.node.transform
							)
						)
						if moduleCtrl._type== 4 do --arm
						(
							if moduleCtrl.flipCtrl != undefined then
							(
								ff = createfile (FNgetFilePath "copyArmModuleFlip1")
								FNcopyLimbModule moduleCtrl ff
								close ff
								ff = createfile (FNgetFilePath "copyArmModuleFlip2")
								FNcopyLimbModule moduleCtrl.flipCtrl.node ff
								close ff
								ff = openfile (FNgetFilePath "copyArmModuleFlip2")
								FNpasteLimbModule moduleCtrl ff
								close ff
								ff = openfile (FNgetFilePath "copyArmModuleFlip1")
								FNpasteLimbModule moduleCtrl.flipCtrl.node ff
								close ff
								
				-- 				try 
				-- 				(
				-- 					deleteFile (FNgetFilePath "copyArmModuleFlip1")
				-- 					deleteFile (FNgetFilePath "copyArmModuleFlip2")
				-- 				)catch()
							)
							else
							(
								messagebox "Please pick mirror arm from attribute control modifier."
							)
						)
						if moduleCtrl._type== 5 do --leg
						(
							if moduleCtrl.flipCtrl != undefined then
							(
								ff = createfile (FNgetFilePath "copyLegModuleFlip1")
								FNcopyLimbModule moduleCtrl ff
								close ff
								ff = createfile (FNgetFilePath "copyLegModuleFlip2")
								FNcopyLimbModule moduleCtrl.flipCtrl.node ff
								close ff
								ff = openfile (FNgetFilePath "copyLegModuleFlip2")
								FNpasteLimbModule moduleCtrl ff isFoot:true
								close ff
								ff = openfile (FNgetFilePath "copyLegModuleFlip1")
								FNpasteLimbModule moduleCtrl.flipCtrl.node ff isFoot:true
								close ff
								
				-- 				try 
				-- 				(
				-- 					deleteFile (FNgetFilePath "copyLegModuleFlip1")
				-- 					deleteFile (FNgetFilePath "copyLegModuleFlip2")
				-- 				)catch()
							)
							else
							(
								messagebox "Please pick mirror leg from attribute control modifier."
							)
						)
						if moduleCtrl._type== 6 do --spine
						(
							for i in moduleCtrl.spineCtrls do
							(
								i.node.transform = mirrorMatrixFn axis:"z" flip:"z" tm: i.node.transform pivottm:i.node.prnt.node.transform
							)
						)
					)	
					-------------------------------------------

					on _copy pressed do
					(
						if _smh.state == 1 do 
						(
							counter = 1
							for i =1 to selection.count do 
							(
								counter += FNcopyPoseInd selection[i] (FNgetFilePath ("poseInd"+counter as string))
							)
							FN_updateRollout()
						)
						if _smh.state == 2 do 
						(			
							FNcopyPoseModule selection[1].currentModuleCtrl.node
							FN_updateRollout()
						)
					)
					on _paste pressed do
					(
						with undo on
						(
							if _smh.state == 1 do 
							(
								counter = 1
								for i =1 to selection.count do 
								(
									counter += FNpastePoseInd selection[i] (FNgetFilePath ("poseInd"+counter as string))
								)
							)
							if _smh.state == 2 do 
							(			
								FNpastePoseModule selection[1].currentModuleCtrl.node
							)
						)
					)
					on _flip pressed do
					(
						with undo on
						(
							if _smh.state == 1 do 
							(
								messagebox "No flip for single node."
							)
							if _smh.state == 2 do 
							(			
								FNpastePoseModuleFlip selection[1].currentModuleCtrl.node
							)
						)
					)
					
				)

				try (cui.UnRegisterDialogBar loadSaveFloater; closeRolloutFloater loadSaveFloater)catch()
				try closeRolloutFloater loadSaveFloater catch()
				loadSaveFloater = newRolloutFloater "Pose Manager" 180 152
				loadSaveFloater.pos = [10,50]
				cui.RegisterDialogBar loadSaveFloater minSize:[180,100] maxSize:[180,152] style:#(#cui_max_sized, #cui_dock_all, #cui_floatable, #cui_handles) 
				cui.DockDialogBar loadSaveFloater #cui_dock_left
				cui.floatdialogbar loadSaveFloater
				cui.DockDialogBar loadSaveFloater #cui_dock_left

				addRollout loadSaveRoll loadSaveFloater
				clearListener()
			)

			button launch "Launch!" width:120 height:20
			
			on launch pressed do
			(
				_createDialog()
			)
		)
	)
 	custAttributes.delete fn_target.modifiers[#attributes] 1
	Custattributes.add fn_target.modifiers[#attributes] curve_ca
)
	

--- build Root
fn FN_buildRoot fnTarget=
(
	root_Node = fnTarget.rootNodeHolderG[1].node
	glbBuildSCL = root_Node.scale.controller.X_Scale/100
	
	glbRoot = FN_createRectangle w:(root_Node.width*glbBuildSCL) l:(root_Node.length*glbBuildSCL)
	glbRoot.transform = root_Node.transform
	glbRoot.scale = [1,1,1]
	rst glbRoot
	glbRoot.name = root_Node.name + "_Ctrl"
	
	FN_rootAttributes glbRoot
	FN_addPoseManager glbRoot
	FN_overlapAttributes glbRoot
	FN_exportAttributes glbRoot
	FN_addBoneProperties glbRoot
	
	---add parameters
	glbRoot.m3a = glbRoot.transform
	glbRoot._name = root_Node.name
	obj = NodeTransformMonitor node:glbRoot forwardTransformChangeMsgs:false
	glbRoot.currentModuleCtrl = obj
	obj = NodeTransformMonitor node:glbRoot forwardTransformChangeMsgs:false
	glbRoot.prnt = obj
-- 	moduleRow +=1
	--------------
	
	--addbone
	rootBone = FN_buildBox undefined (root_Node.width*.2*glbBuildSCL) (root_Node.length*.2*glbBuildSCL) (.1*glbBuildSCL)
	rootBone.transform = glbRoot.transform
	rootBone.parent = glbRoot
	rst rootBone
	rootBone.name = root_Node.name
	
	obj = NodeTransformMonitor node:rootBone forwardTransformChangeMsgs:false
	append glbRoot.childG obj
	obj = NodeTransformMonitor node:glbRoot forwardTransformChangeMsgs:false
	rootBone.moduleCtrl = obj
	
	hide rootBone
	freeze rootBone
	
	glbRoot.scale.controller = ScaleXYZ ()
	paramWire.connect glbRoot.scale.controller[#X_Scale] glbRoot.scale.controller[#Y_Scale] "X_Scale"
	paramWire.connect glbRoot.scale.controller[#X_Scale] glbRoot.scale.controller[#Z_Scale] "X_Scale"
	
	FN_build root_Node glbRoot
	glbRoot
)

--build hub

fn FN_buildHub fnTarget fnParent=
(
	root_Node = fnTarget.rootNodeHolderG[1].node
	guideHub = fnTarget.hubHolderG[1].node
	
	parentPoint = FN_createPoint () -- parente bagli olan 
	parentPoint.parent = fnParent
	parentPoint.transform = guideHub.transform
	parentPoint.scale = [1,1,1]
	rst parentPoint
	
	glbHubCtrl = FN_createNgon ((guideHub.width*glbBuildSCL + guideHub.length*glbBuildSCL)/2)
	glbHubCtrl.transform = parentPoint.transform
	glbHubCtrl.parent = parentPoint
	glbHubCtrl.pos.controller.x_position += (guideHub.height/2)*glbBuildSCL
	rst glbHubCtrl
-- 	glbHubCtrl.scale.controller = scale_script()
	setTransformLockFlags glbHubCtrl #{9,8,7}
	glbHubCtrl.name = guideHub.name + "_Ctrl"
	
	
	hipCtrl = FN_createCircle (((guideHub.width*glbBuildSCL + guideHub.length*glbBuildSCL)/2)*.8)
	hipCtrl.transform = glbHubCtrl.transform
	hipCtrl.parent = glbHubCtrl
	rst hipCtrl
	hipCtrl.name = guideHub.name + "_innerCtrl"
	
	---add parameters
	
	obj = NodeTransformMonitor node:glbHubCtrl.parent forwardTransformChangeMsgs:false
	glbHubCtrl.prnt = obj
	glbHubCtrl.m3a = (glbHubCtrl.transform*(inverse glbHubCtrl.parent.transform))
		
	obj = NodeTransformMonitor node:hipCtrl.parent forwardTransformChangeMsgs:false
	hipCtrl.prnt = obj
	hipCtrl.m3a = (hipCtrl.transform*(inverse hipCtrl.parent.transform))
		
	glbHubCtrl._type = 2
	glbHubCtrl._name = fnTarget.modulNameHolder

	hipCtrl._name = fnTarget.modulNameHolder + "_inner"
	
	obj = NodeTransformMonitor node:glbHubCtrl forwardTransformChangeMsgs:false
	append fnParent.childModules obj
	obj = NodeTransformMonitor node:glbHubCtrl forwardTransformChangeMsgs:false
	append glbHubCtrl.hubCtrls obj
	obj = NodeTransformMonitor node:hipCtrl forwardTransformChangeMsgs:false
	append glbHubCtrl.hubCtrls obj
	obj = NodeTransformMonitor node:glbHubCtrl forwardTransformChangeMsgs:false
	glbHubCtrl.currentModuleCtrl = obj
	obj = NodeTransformMonitor node:glbHubCtrl forwardTransformChangeMsgs:false
	hipCtrl.currentModuleCtrl = obj
	--------------
	
	hubBone = FN_buildBox guideHub (guideHub.width*glbBuildSCL) (guideHub.length*glbBuildSCL) (guideHub.height*glbBuildSCL)
	hubBone.transform = hipCtrl.transform
	hubBone.parent = hipCtrl
	hubBone.pos.controller.x_position -= (guideHub.height/2)*glbBuildSCL
	rst hubBone
	hubBone.name = guideHub.name
	
	obj = NodeTransformMonitor node:hubBone forwardTransformChangeMsgs:false
	append fnParent.childG[1].node.childG obj
	obj = NodeTransformMonitor node:glbHubCtrl forwardTransformChangeMsgs:false
	hubBone.moduleCtrl = obj
	
	glbHubCtrl._overlapDist[1] = hubBone.height
	glbHubCtrl._overlapDist[2] = hubBone.width
	
	hipCtrl._overlapDist[1] = hubBone.height
	hipCtrl._overlapDist[2] = hubBone.width

	hubBone
	
)

-- build Tail
fn addChainFKAttributes fn_target=
(
	curve_ca = attributes tailAttributes 
	(
		Parameters main rollout:tailAtts
			(
				absRelS Type:#float UI:absRelSpin Default:1.0
			)
		Rollout tailAtts "Chain Attributes"
			(
				hyperLink irig  "Need Help?" align:#right color:[255,255,255] hoverColor:[255,130,0] address:"http://docs.instantrig.com/rst/animation/sub/modules/chainatts.html#fk-chain-attributes"
				spinner absRelSpin "Abs/Rel" align:#right Range:[0,1,1] Type:#float
			)
	)
-- 	addModifier fn_target (EmptyModifier ()) 
-- 	fn_target.modifiers[#attribute_holder].name = "attributes"
	Custattributes.add fn_target.modifiers[#attributes] curve_ca
)
fn addChainAttributes fn_target=
(
	curve_ca = attributes tailAttributes 
	(
		Parameters main rollout:tailAtts
			(
				stretchS Type:#float UI:stretchSpin Default:1.0
				absRelS Type:#float UI:absRelSpin Default:1.0
			)
		Rollout tailAtts "Chain Attributes"
			(
				hyperLink irig  "Need Help?" align:#right color:[255,255,255] hoverColor:[255,130,0] address:"http://docs.instantrig.com/rst/animation/sub/modules/chainatts.html#spring-chain-attributes"
				spinner stretchSpin "Stretchable" align:#right range:[0,1,1] Type:#float
				spinner absRelSpin "Rot. Abs/Rel" align:#right range:[0,1,1] Type:#float
			)
	)
-- 	addModifier fn_target (EmptyModifier ()) 
-- 	fn_target.modifiers[#attribute_holder].name = "attributes"
	Custattributes.add fn_target.modifiers[#attributes] curve_ca
)
fn addSpringAttributes fn_target=
(
	sp_att = attributes springControls
	(
		parameters params rollout:springPrm
		(
-- 			onoff type:#boolean ui:onoffBtn default:false
			sprngNodes type:#maxObjectTab tabSize:0 tabSizeVariable:true
-- 			sprngCtrls type:#maxObjectTab tabSize:0 tabSizeVariable:true
			weight type:#float ui:weightsp default:100
-- 			mass type:#float ui:masssp default:300
			dragp type:#float ui:dragsp default:.6
			tension type:#float ui:tensionsp default:2
-- 			dmp type:#float ui:dmpsp default:1.0
			strt type:#integer ui:strtsp default:0
			
		)
		rollout springPrm "Spring Attributes" width:162 height:372
		(
			group "Spring On/Off"
			(
				checkButton onoffBtn "On/Off" default:false
			)
			group "Spring Weight"
			(
				spinner weightsp "Weight" range:[0,500,100]
-- 				spinner masssp "Mass" range:[0,5000,300]
				spinner dragsp "Drag" range:[0,10,.8]
				spinner tensionsp "Tension" range:[-100,100,3]
-- 				spinner dmpsp "Dampening" range:[-10,10,.8]
				spinner strtsp "Start at:" range:[-9999,9999,0] type:#integer
				button rst "Reset" width:45 height:18 pos:[10,165]
				button bakeanim "Bake" width:45 height:18 pos:[62,165]
				button unbakeanim "Unbake" width:45 height:18 pos:[108,165]
				
			)
			
			on springPrm open do
			(
				if sprngNodes[1].node.pos.controller[#spring].steps == 0 then onoffBtn.state = false else onoffBtn.state = true
				weightsp.enabled = onoffBtn.state
-- 				masssp.enabled = onoffBtn.state
				dragsp.enabled = onoffBtn.state
				tensionsp.enabled = onoffBtn.state
-- 				dmpsp.enabled = onoffBtn.state
				rst.enabled = onoffBtn.state
				bakeanim.enabled = onoffBtn.state
				strtsp.enabled = onoffBtn.state
				
				
			)
			on onoffBtn changed state do
			(
				if state == on then
					(
						weightsp.enabled = true
-- 						masssp.enabled = true
						dragsp.enabled = true
						tensionsp.enabled = true
-- 						dmpsp.enabled = true
						rst.enabled = true
						bakeanim.enabled = true
						strtsp.enabled = true
					
						for o in sprngNodes do
							(
							  o.node.pos.controller[#spring].steps=2
							)
					)
				else
					(
						weightsp.enabled = false
-- 						masssp.enabled = false
						dragsp.enabled = false
						tensionsp.enabled = false
-- 						dmpsp.enabled = false
						rst.enabled = false
						bakeanim.enabled = false
						strtsp.enabled = false
							
						for o in sprngNodes do
							(
							  o.node.pos.controller[#spring].steps=0
							)
					)
			)
			on weightsp changed val do
			(
				for i in sprngNodes do
				(
					i.node.pos.controller[#Weights].Weight__Spring = weightsp.value
				)
					
			)
-- 			on masssp changed val do
-- 			(
-- 				for i in sprngNodes do
-- 				(
-- 					i.node.pos.controller[#Spring].setMass masssp.value
-- 				)
-- 					
-- 			)
			on dragsp changed val do
			(
				for i in sprngNodes do
				(
					i.node.pos.controller[#Spring].setDrag dragsp.value
				)
					
			)
			on tensionsp changed val do
			(
				for i in sprngNodes do
				(
					i.node.pos.controller[#Spring].setTension 1 tensionsp.value
				)
					
			)
-- 			on dmpsp changed val do
-- 			(
-- 				for i in sprngNodes do
-- 				(
-- 					i.node.pos.controller[#Spring].setDampening 1 dmpsp.value
-- 				)
-- 					
-- 			)
			on strtsp changed val do
			(
				for i in sprngNodes do
					(
						i.node.pos.controller[#Spring].start = strtsp.value
					)
			)
			on rst pressed do
			(
				weightsp.value = 100
-- 				masssp.value = 300
				dragsp.value = .6
				tensionsp.value = 2
-- 				dmpsp.value = 1.0
				strtsp.value = 0
				for i in sprngNodes do
				(
					i.node.pos.controller[#Weights].Weight__Spring = weightsp.value
-- 					i.node.pos.controller[#Spring].setMass masssp.value
					i.node.pos.controller[#Spring].setDrag dragsp.value
					i.node.pos.controller[#Spring].setTension 1 tensionsp.value
-- 					i.node.pos.controller[#Spring].setDampening 1 dmpsp.value
				)
			)
			on bakeanim pressed do
			(
				pnts = #()
				for i=1 to sprngNodes.count do
					(
						pnt = point cross:false centermarker:false box:false axistripod:false size:0
						append pnts pnt
					)
				
				for i=1 to sprngNodes.count do
				(
					for t = animationRange.start to animationRange.end by 1 do 
					(
						animate on at time t 
						(
							pnts[i].transform = sprngNodes[i].node.transform
						)
-- 					slidertime += 1
					)
				)
					
				onoffBtn.state = false
				weightsp.enabled = onoffBtn.state
-- 				masssp.enabled = onoffBtn.state
				dragsp.enabled = onoffBtn.state
				tensionsp.enabled = onoffBtn.state
-- 				dmpsp.enabled = onoffBtn.state
				rst.enabled = onoffBtn.state
				bakeanim.enabled = onoffBtn.state
				strtsp.enabled = onoffBtn.state
					
				for o in sprngNodes do o.node.pos.controller[#spring].steps=0
					
				for i=1 to sprngNodes.count do
				(
					for t = animationRange.start to animationRange.end by 1 do 
					(
						animate on at time t 
						(
							sprngNodes[i].node.transform = pnts[i].transform
						)
					)    
				)
				
				for o=1 to pnts.count do delete pnts[o]
			)
			on unbakeanim pressed do
			(
				for i in sprngNodes do
					(
						deleteKeys i.node.transform.controller #allKeys
						i.node.transform.controller.value = (matrix3 [1,0,0] [0,1,0] [0,0,1] [0,0,0])
					)
			)
		)
		
		


	)
	Custattributes.add fn_target.modifiers[#attributes] sp_att
)
fn FN_buildChain fnTarget fnParent=
(
	-----------------------
	--rotation absolute relative ayarlanicak
	-------------------------
	pntParent = FN_createPoint () -- parente bagli olan 
	pntParent.parent = fnParent
	pntParent.transform = fnTarget.tailBoneHolderG[1].node.transform
	pntParent.scale = [1,1,1]
	rst pntParent
	
	pntRoot = FN_createPoint () -- roota bagli rotasyon pointi
	pntRoot.parent = glbRoot
	pntRoot.transform = fnTarget.tailBoneHolderG[1].node.transform
	pntRoot.scale = [1,1,1]
	rst pntRoot
	pntRoot.pos.controller[2].controller = Position_Constraint ()
	pntRoot.pos.controller[2].controller.appendTarget pntParent 100
	
	pntAbsRel = FN_createPoint () --ikisinin arasinda oryante olan
	pntAbsRel.parent = fnParent
	pntAbsRel.transform = pntParent.transform
	pntAbsRel.scale = [1,1,1]
	rst pntAbsRel
	pntAbsRel.rotation.controller[2].controller = Orientation_Constraint ()
	pntAbsRel.rotation.controller[2].controller.appendTarget pntRoot 0
	pntAbsRel.rotation.controller[2].controller.appendTarget pntParent 100
	
	-----------------------
	-- tail yapimi
	-----------------------
	
	parentPoint = FN_createPoint ()
	parentPoint.parent = pntAbsRel
	parentPoint.transform = pntAbsRel.transform
	rst parentPoint
	
	if fnTarget.chType == 2 then
	(
		tailBones = #()
		tailCtrls =#()
		tailBonesN = #()
		for i = 1 to fnTarget.tailBoneHolderG.count do append tailBones fnTarget.tailBoneHolderG[i].node
		
		tempParent = parentPoint
		for i = 1 to tailBones.count do
		(
			tailCtrl = (FN_createNgon (((tailBones[i].width + tailBones[i].length)/2)*glbBuildSCL))
			tailCtrl.transform = tailBones[i].transform
			tailCtrl.scale = [1,1,1]
			tailCtrl.parent = tempParent
			
			
			rst tailCtrl
			tailCtrl.name = tailBones[i].name + "Ctrl"
			append tailCtrls tailCtrl
			
			tailbone = (FN_buildBox tailBones[i] (tailBones[i].width*glbBuildSCL) (tailBones[i].length*glbBuildSCL) (tailBones[i].height*glbBuildSCL))
			
			tailBone.transform = tailCtrl.transform
			tailbone.parent = tailCtrl; 
-- 			tailBone.scale = [1,1,1]
			setTransformLockFlags tailBone #{9,8,7,6,5,4,3,2,1}
					
			
			rst tailbone
			tailbone.name = tailBones[i].name
			append tailBonesN tailBone
			tempParent = tailBone	
		)
		
		addChainFKAttributes tailCtrls[1]
		
		paramWire.connect tailCtrls[1].modifiers[#attributes].tailAttributes[#absRelS] pntAbsRel.rotation.controller.Orientation_Constraint.controller[#Orientation_Weight_0] "1-absRelS"
		paramWire.connect tailCtrls[1].modifiers[#attributes].tailAttributes[#absRelS] pntAbsRel.rotation.controller.Orientation_Constraint.controller[#Orientation_Weight_1] "absRelS"
	)
	else
	(
		tailBones = #()
		
		for i = 1 to fnTarget.tailBoneHolderG.count do append tailBones fnTarget.tailBoneHolderG[i].node
		
		springPnts = #()
		tailCtrls = #()
		tailBonesN = #()
		tempParent = parentPoint
		
		for i = 1 to tailBones.count do
		(
			tailbone = (FN_buildBox tailBones[i] (tailBones[i].width*glbBuildSCL) (tailBones[i].length*glbBuildSCL) (tailBones[i].height*glbBuildSCL))
			
			tailBone.transform = tailBones[i].transform
			tailBone.scale = [1,1,1]
			tailbone.parent = tempParent; 
			
-- 			if fnTarget.nodeMirror == true do tailbone.rotation.controller.y_Rotation += 180
					
			tailBone.height.controller = float_script ()
			
			rst tailbone
			tailbone.name = tailBones[i].name
			append tailBonesN tailBone
			tempParent = tailbone	
				
		)
		
		--- create tip bone
		tipbone = (FN_buildBox tailBones[tailBones.count] (tailBones[tailBones.count].width*glbBuildSCL*.4) (tailBones[tailBones.count].length*glbBuildSCL*.4) (1))
		tipBone.transform = tailBonesN[tailBonesN.count].transform; 
		tipbone.parent = tailBonesN[tailBonesN.count]; 
		tipbone.scale = [1,1,1]
		tipBone.pos.controller.x_position = tailBonesN[tailBonesN.count].height;
		tipBone.height.controller = float_script ()
		tipBone.name = tailBonesN[tailBonesN.count].name+"_tip"
		
		rst tipbone
		append tailBonesN tipBone
		---
		
		tempParent = parentPoint
		for i = 1 to tailBonesN.count do
		(
			springPnt = FN_createAsterix (((tailBonesN[i].length + tailBonesN[i].width)/2))
			springPnt.name = tailBonesN[i].name+"_spr"
			springPnt.parent = tailBonesN[i]
			springPnt.transform = tailBonesN[i].transform
			rst springPnt
			append springPnts springPnt
			tempParent = tailBonesN[i]
		)
		
		tempParent = parentPoint
		for i = 1 to tailBonesN.count do
		(
			if i != 1 do tempParent = tailBonesN[i]
				
			tailCtrl = (FN_createNgon ((tailBonesN[i].width + tailBonesN[i].length)/2))
			tailCtrl.transform = tempParent.transform
			tailCtrl.parent = tempParent
			
			rst tailCtrl
			tailCtrl.name = tailBonesN[i].name + "Ctrl"
			append tailCtrls tailCtrl
		)
		
		for i = 1 to tailCtrls.count do
		(
			springPnts[i].parent = tailCtrls[i]
			rst springPnts[i]
			springPnts[i].pos.controller[2].controller = SpringPositionController ()
			springPnts[i].pos.controller[2].controller.steps=0
-- 			springPnts[i].rotation.controller[2].controller = rotation_script ()
			setTransformLockFlags springPnts[i] #{6,5,4}
			if i != 1 then tailCtrls[i].parent = springPnts[i-1]
			rst tailCtrls[i]
			
		)
		
		------------------------------
		--- tail attributes
		------------------------------
		addChainAttributes tailCtrls[1]
		
		paramWire.connect tailCtrls[1].modifiers[#attributes].tailAttributes[#absRelS] pntAbsRel.rotation.controller.Orientation_Constraint.controller[#Orientation_Weight_0] "1-absRelS"
		paramWire.connect tailCtrls[1].modifiers[#attributes].tailAttributes[#absRelS] pntAbsRel.rotation.controller.Orientation_Constraint.controller[#Orientation_Weight_1] "absRelS"
			
		tailCtrls[1].modifiers[#attributes].tailAttributes.stretchS.controller = bezier_float ()
		
		
		tailBonesN[1].position.controller[2].controller = position_constraint ()
		tailBonesN[1].position.controller[2].controller.appendTarget tailCtrls[1] 100
		for i = 1 to tailBonesN.count-1 do
		(
			tailBonesN[i].rotation.controller[2].controller = lookat_Constraint ()
			tailBonesN[i].rotation.controller[2].controller.lookat_vector_length = 0
			tailBonesN[i].rotation.controller[2].controller.target_axis = 0
			tailBonesN[i].rotation.controller[2].controller.upnode_ctrl = 1
			tailBonesN[i].rotation.controller[2].controller.StoUP_axis = 2
			tailBonesN[i].rotation.controller[2].controller.upnode_axis = 2
			--tailBonesN[i].rotation.controller[2].controller.target_axisFlip = on
			tailBonesN[i].rotation.controller[2].controller.pickUpNode = tailCtrls[i]
			tailBonesN[i].rotation.controller[2].controller.upnode_world = off
			tailBonesN[i].rotation.controller[2].controller.appendTarget springPnts[i+1] 100
		)
		tailBonesN[tailBonesN.count].rotation.controller[2].controller = orientation_Constraint ()
		tailBonesN[tailBonesN.count].rotation.controller[2].controller.appendTarget springPnts[springPnts.count] 100
		
		for i = 2 to tailBonesN.count do
		(
			tailBonesN[i].pos.controller.XYZ.controller.X_Position.controller = float_script ()
			tailBonesN[i].pos.controller.XYZ.controller.X_Position.controller.AddConstant "hgt" tailBonesN[i-1].height
			tailBonesN[i].pos.controller.XYZ.controller.X_Position.controller.addNode "ctrl" springPnts[i-1]
			tailBonesN[i].pos.controller.XYZ.controller.X_Position.controller.addNode "sprng" springPnts[i]
			tailBonesN[i].pos.controller.XYZ.controller.X_Position.controller.AddTarget "att" tailCtrls[1].modifiers[#attributes].tailAttributes.stretchS.controller
			tailBonesN[i].pos.controller.XYZ.controller.X_Position.controller.AddTarget "scl" glbRoot.scale.controller.X_Scale.controller
			tailBonesN[i].pos.controller.XYZ.controller.X_Position.controller.script = "try(((distance ctrl sprng)-(hgt*(scl/100)))*att)/(scl/100)catch(0)"
			
		)
		for i = 1 to tailBonesN.count do
		(
			tailBonesN[i].boneEnable = false -- ???böyle kapatip açmadan son bone'un tip kontolcüsü cekilince scale olmuyo ???
			tailBonesN[i].boneEnable = true
			tailBonesN[i].boneFreezeLength=false
		)

		--------------------------------------------
		--- spring attributes
		-------------------------------------------
		addSpringAttributes tailCtrls[1]
		
		for i in springPnts do
		(
			obj = NodeTransformMonitor node:i forwardTransformChangeMsgs:false
			append tailCtrls[1].modifiers[#Attributes].sprngNodes obj
			
		)
	)
	
	---add parameters
	tailCtrls[1]._type = 3
	tailCtrls[1]._name = fnTarget.modulNameHolder
	obj = NodeTransformMonitor node:tailCtrls[1] forwardTransformChangeMsgs:false
	append fnParent.moduleCtrl.node.childModules obj
	obj = NodeTransformMonitor node:tailCtrls[1] forwardTransformChangeMsgs:false
	append tailCtrls[1].tailCtrls obj
	obj = NodeTransformMonitor node:tailCtrls[1] forwardTransformChangeMsgs:false
	tailCtrls[1].currentModuleCtrl = obj
	
	for i = 1 to  tailCtrls.count do
	(
		tailCtrls[i]._overlapDist[1] = tailBonesN[i].height
		tailCtrls[i]._overlapDist[2] = tailBonesN[i].width
		
		obj = NodeTransformMonitor node:tailCtrls[i].parent forwardTransformChangeMsgs:false
		tailCtrls[i].prnt = obj
		tailCtrls[i].m3a = (tailCtrls[i].transform*(inverse tailCtrls[i].parent.transform))
			
		if i != 1 do
		(
			obj = NodeTransformMonitor node:tailCtrls[i] forwardTransformChangeMsgs:false
			append tailCtrls[1].tailCtrls obj
			obj = NodeTransformMonitor node:tailCtrls[1] forwardTransformChangeMsgs:false
			tailCtrls[i].currentModuleCtrl = obj
		)
	)
	
	try
	(
		for i = 1 to springPnts.count do
		(
			obj = NodeTransformMonitor node:springPnts[i].parent forwardTransformChangeMsgs:false
			springPnts[i].prnt = obj
			springPnts[i].m3a = (springPnts[i].transform*(inverse springPnts[i].parent.transform))
			
			obj = NodeTransformMonitor node:springPnts[i] forwardTransformChangeMsgs:false
			append tailCtrls[1].tailSprings obj
			obj = NodeTransformMonitor node:tailCtrls[1] forwardTransformChangeMsgs:false
			springPnts[i].currentModuleCtrl = obj
		)
	)catch()
	
	--------------
	
	refBoneCount = tailBonesN.count
-- 	if fnTarget.chType == 2 do refBoneCount = tailBonesN.count
	
	for i = 1 to refBoneCount do
	(
		if i==1 then
		(
			obj = NodeTransformMonitor node:tailBonesN[i] forwardTransformChangeMsgs:false
			append fnParent.childG obj
			obj = NodeTransformMonitor node:tailCtrls[1] forwardTransformChangeMsgs:false
			tailBonesN[i].moduleCtrl = obj
		)
		
		else
		(
			obj = NodeTransformMonitor node:tailBonesN[i] forwardTransformChangeMsgs:false
			append tailBonesN[i-1].childG obj
			obj = NodeTransformMonitor node:tailCtrls[1] forwardTransformChangeMsgs:false
			tailBonesN[i].moduleCtrl = obj
		)
		
	)
	
	tailBonesN
	
)


-- build ARM & LEG

fn FN_fingerAttributes fn_target fn_count=
(
	strParam = ""
	strRoll = ""

	for i = 1 to fn_count do
	(
-- 		_default = (1.0/(fn_count-1))*i
		_default = 2
		strParam += "knuckle_"+ ((i) as string) +" Type:#float UI:knuckle"+ ((i) as string) +" Default:"+ (_default as string) +"\n"
	)
	for i = 1 to fn_count do
	(
		strRoll += "slider knuckle"+ ((i) as string) +" \"Knuckle "+ ((i) as string) +":\" Width:133 Height:25 Align:#Center Offset:[0,0] Type:#float Range:[0,3,0] Orient:#Horizontal Ticks:3\n"
	)
	str = "curve_ca = attributes fingerAttributes 
			(
				Parameters main rollout:params
				(
					"+strParam+"
					squash Type:#float UI:squash Default:0.0
						
				)
				Rollout Params \"Orientation Multiplier\"
				(
					hyperLink irig  \"Need Help?\" align:#right color:[255,255,255] hoverColor:[255,130,0] address:\"http://docs.instantrig.com/rst/animation/sub/modules/armlegatts.html#finger-attributes\"
					group \"Influence on:\"
					(
						"+strRoll+"
					)
					group \"\"
					(
						slider Squash \"Squash:\" Width:133 Height:25 Align:#Center Offset:[0,0] Type:#float Range:[0,1,0] Orient:#Horizontal Ticks:3
					)
				)
			)"
			
			execute (str)
			Custattributes.add fn_target.modifiers[#attributes] curve_ca
	
)

fn FN_HandAttributes fn_target=
(
	curve_ca = attributes handAttributes 
	(
		Parameters main rollout:params
		(
			_scale Type:#float UI:_scale Default:1.0
		)
		Rollout Params "Hand Attributes"
		(
-- 			Group "Hand Scale"
-- 			(
				spinner _scale "Hand Scale" align:#right range:[0.01,5,1]
-- 				slider _scale "" Width:133 Height:25 Align:#Center Offset:[0,0] Type:#float Range:[0,5,1] Orient:#Horizontal Ticks:5 tooltip:"Right click to reset"
-- 			)
		
			on  _scale rightClick do _scale.value=1.0
		)
	)
	Custattributes.add fn_target.modifiers[#attributes] curve_ca
)

fn FN_CurveAttributes fn_target=
(
	curve_ca = attributes curveAttributes 
	(
		Parameters main rollout:params
		(
			squash Type:#float UI:squash Default:0.0
			curve Type:#float UI:curve Default:0.0
			constant Type:#boolean UI:constant Default:true
			followU Type:#float UI:followU Default:0.5
			followM Type:#float UI:followM Default:0.5
			followL Type:#float UI:followL Default:0.5
			constantHolder type:#maxObjectTab tabSize:0 tabSizeVariable:true
		)
		Rollout Params "Curve Attributes"
		(
			Group "Attributes"
			(
				spinner Squash "Squash" align:#right range:[0,1,0] Type:#float
				spinner curve "Curvy" align:#right range:[0,1,0] Type:#float
				checkbox constant "Constant Space" Align:#right checked:true
			)
			Group "Twist Orientation"
			(
				spinner followU "Folow Upper" align:#right range:[0,1,0.5] Type:#float
				spinner followM "Folow Middle" align:#right range:[0,1,0.5] Type:#float
				spinner followL "Folow Lower" align:#right range:[0,1,0.5] Type:#float
			)
			
			on followU rightClick do followU.value=.5
			on followM rightClick do followM.value=.5
			on followL rightClick do followL.value=.5
				
			on constant changed state do
			(
				if state then
				(
					for i in constantHolder do
					(
						i.node.pos.controller.constantVel = on
					)
				)
					
				else 
				(
					for i in constantHolder do
					(
						i.node.pos.controller.constantVel = off
					)
				)
			)
		)
	)
	Custattributes.add fn_target.modifiers[#attributes] curve_ca
)

fn FN_IkAttribtes fn_target=	
(
	length_att = attributes ikAttributes
	(
		Parameters main rollout:params
		(
-- 			_length Type:#float UI:_length Default:0.0
			tLength Type:#float UI:tLength Default:0.0
			uLength Type:#float UI:uLength Default:0.0
			uLengthAct Type:#float Default:0.0
			lLength Type:#float UI:lLength Default:0.0
			lLengthAct Type:#float Default:0.0
			ikfk Type:#float UI:ikfk Default:0.0
			fk_AbRel Type:#float UI:fk_AbRel Default:0.0
			softIK Type:#float UI:softIK Default:0.0
			ikStretch Type:#float UI:ikStretch Default:1.0
			poleSnap Type:#float UI:poleSnap Default:0.0
			matchHolder type:#maxObjectTab tabSize:0 tabSizeVariable:true
			fkHolder type:#maxObjectTab tabSize:0 tabSizeVariable:true
			ikHolder type:#maxObjectTab tabSize:0 tabSizeVariable:true
			bendHolder type:#maxObjectTab tabSize:0 tabSizeVariable:true
			strHolder type:#maxObjectTab tabSize:0 tabSizeVariable:true
		)
			Rollout Params "IK/FK"
			(
				fn shape_filt obj = isKindOf obj Shape
				hyperLink irig  "Need Help?" align:#right color:[255,255,255] hoverColor:[255,130,0] address:"http://docs.instantrig.com/rst/animation/sub/modules/armlegatts.html#arm-leg-attributes"
				group "Attributes"
				(
					spinner ikfk "IK/FK Switch" align:#right range:[0,1,0]
					spinner ikStretch "Stretchable" align:#right range:[0,1,0]
					spinner softIK "Soft IK" align:#right range:[0,1,0]
					spinner poleSnap "Pole Snap" align:#right range:[0,1,0]
					spinner fk_AbRel "FK Abs/Rel" align:#right range:[0,1,0]
				)
				group "IK/FK Match"
				(
					button ikfkBt "IK->FK" Align:#left Offset:[0,0] width:65
					button fkikBt "FK->IK" Align:#right Offset:[0,-26]  width:65
				)
				group "Hide/Unhide Controllers"
				(
					button fkhide "FK" Align:#left Offset:[0,0] width:33
					button ikhide "IK" Align:#left Offset:[34,-26] width:33
					button bendhide "Bend" Align:#left Offset:[68,-26] width:33
					button strhide "Fine" Align:#left Offset:[102,-26] width:33
				)
				group "Mirror Limb"
				(
					pickbutton mrrLimb "Pick Mirror Limb" filter:shape_filt
				)
				group "IK Length"
				(
					spinner uLength "Upper Length" align:#right Type:#float Range:[0,999,0]
					spinner lLength  "Lower Length" align:#right Type:#float Range:[0,999,0]
					spinner tLength " Total Length" align:#right Type:#float Range:[0,999,0]
-- 					Button _reset "Reset" Width:140 Height:30 Align:#Center
				)
				on Params open do
				(
					_this = ((refs.dependentNodes (refs.dependents this)[1])[1])
					if _this.flipCtrl != undefined do 
					(
						mrrLimb.text = _this.flipCtrl.node._name
					)
				)
				on mrrLimb picked flipNode do
				(
					_this = ((refs.dependentNodes (refs.dependents this)[1])[1])
					if flipNode != undefined do
					(
						type=0
						try
						(
							if (flipNode.currentModuleCtrl.node._type == _this.currentModuleCtrl.node._type) then
							(
								mrrLimb.text = flipNode.currentModuleCtrl.node._name
								obj = NodeTransformMonitor node:flipNode.currentModuleCtrl.node forwardTransformChangeMsgs:false
								_this.flipCtrl = obj
								
								obj = NodeTransformMonitor node:_this forwardTransformChangeMsgs:false
								flipNode.currentModuleCtrl.node.flipCtrl = obj
							)
							else (messagebox "Please pick any other limb controller")
						)
						catch(messagebox "Please pick any other limb controller")
					)
				)
				
-- 				on _reset pressed do
-- 				(
-- 					uLength.value = uLengthAct
-- 					lLength.value = lLengthAct
-- 					tLength.value = uLength.value + lLength.value
-- 				)
				
				on uLength changed val do
				(
					tLength.value = uLength.value + lLength.value
				)
				
				on lLength changed val do
				(
					tLength.value = uLength.value + lLength.value
				)
				
				on tLength changed val do
				(
					mlt = uLength.value/(uLength.value+lLength.value)
					uLength.value = tLength.value*mlt
					lLength.value = tLength.value - uLength.value
				)
				
				on fkHide pressed  do
				(
					undo on
					(
						a = fkHolder[1].node
						hidden = a.isNodeHidden
						for i = 1 to (fkHolder.count) do
						(
							a = fkHolder[i].node
							a.isNodeHidden = not hidden
						)	
					)
				)
				on ikHide pressed  do
				(
					undo on
					(
						a = ikHolder[1].node
						hidden = a.isNodeHidden
						for i = 1 to (ikHolder.count) do
						(
							a = ikHolder[i].node
							a.isNodeHidden = not hidden
						)	
					)
				)
				on strHide pressed  do
				(
					undo on
					(
						a = strHolder[1].node
						hidden = a.isNodeHidden
						for i = 1 to (strHolder.count) do
						(
							a = strHolder[i].node
							a.isNodeHidden = not hidden
						)	
					)
				)
				on bendHide pressed do
				(
					undo on
					(
						a = bendHolder[1].node
						hidden = a.isNodeHidden
						for i = 1 to (bendHolder.count) do
						(
							a = bendHolder[i].node
							a.isNodeHidden = not hidden
						)	
					)
				)
				on ikfkBt pressed do
				(
					with undo on
					(
						if matchHolder.count == 0 then 
						(
							messageBox "IK/FK match only works on arms/legs with 2 bones."
						)
						else
						(
							softIK.value = 0
							ikfk.value = 1
							uLength.value = (distance matchHolder[6].node matchHolder[7].node)/(matchHolder[12].node.scale.controller.X_Scale/100)
							lLength.value = (distance matchHolder[4].node matchHolder[6].node)/(matchHolder[12].node.scale.controller.X_Scale/100)
							tLength.value = uLength.value+lLength.value
							
							if matchHolder.count > 12 do
							(
								-- footIK control
								matchHolder[15].node.transform = matchHolder[16].node.transform
								-- heel
								matchHolder[17].node.Position.controller[2].x_Position = 0
								matchHolder[17].node.Position.controller[2].y_Position = 0
								matchHolder[17].node.Position.controller[2].z_Position = 0
								matchHolder[17].node.rotation.controller[2].x_Rotation = 0
								matchHolder[17].node.rotation.controller[2].y_Rotation = 0
								matchHolder[17].node.rotation.controller[2].z_Rotation = 0
								-- tip
								matchHolder[18].node.Position.controller[2].x_Position = 0
								matchHolder[18].node.Position.controller[2].y_Position = 0
								matchHolder[18].node.Position.controller[2].z_Position = 0
								matchHolder[18].node.rotation.controller[2].x_Rotation = 0
								matchHolder[18].node.rotation.controller[2].y_Rotation = 0
								matchHolder[18].node.rotation.controller[2].z_Rotation = 0
								-- ankle
								matchHolder[19].node.transform = matchHolder[20].node.transform
-- 								orj = matchHolder[21].node.scale.controller.X_Scale.controller.GetConstant "hgt"
-- 								_glbScl =(matchHolder[22].node.scale.controller.X_Scale/100)
-- 								matchHolder[19].node.scale.controller.X_Scale = (((distance matchHolder[19].node matchHolder[4].node)/_glbScl)/orj)*100
								-- toe
								matchHolder[14].node.transform = matchHolder[13].node.transform
								
							)
							matchHolder[1].node.transform = matchHolder[2].node.transform -- ik_pole_ctrl -> fk_pole
							matchHolder[3].node.transform = matchHolder[4].node.children[1].transform -- ik_ctrl -> fk_ctrl_array[3]
							matchHolder[8].node.transform = matchHolder[7].node.children[1].transform -- ik_point_fkcorrect_array[1] -> fk_ctrl_array[1]
							matchHolder[9].node.transform = matchHolder[6].node.children[1].transform -- ik_point_fkcorrect_array[2] -> fk_ctrl_array[2]
							matchHolder[10].node.transform = matchHolder[4].node.children[1].transform -- ik_point_fkcorrect_array[3] -> fk_ctrl_array[3]
						)
					)
				)
				on fkikBt pressed do
				(
					with undo on
					(
						if matchHolder.count == 0 then 
						(
							messageBox "IK/FK match only works on arms/legs with 2 bones."
						)
						else
						(
							ikfk.value = 0
							if matchHolder[7].node.currentModuleCtrl.node.mrr == true then
							(
								mp = point cross:false centermarker:true box:false axistripod:false size:5
								mp.parent = matchHolder[11].node
								mp.transform = matchHolder[11].node.transform
								mp.rotation.controller.z_rotation +=180
								matchHolder[7].node.transform = mp.transform -- fk_ctrl_array[1] -> ik_point_array[1]
								delete mp
							)
							else matchHolder[7].node.transform = matchHolder[11].node.transform -- fk_ctrl_array[1] -> ik_point_array[1]
								
							if matchHolder[6].node.currentModuleCtrl.node.mrr == true then
							(
								mp = point cross:false centermarker:true box:false axistripod:false size:5
								mp.parent = matchHolder[9].node
								mp.transform = matchHolder[9].node.transform
								mp.rotation.controller.z_rotation +=180
								matchHolder[6].node.transform = mp.transform -- fk_ctrl_array[1] -> ik_point_array[1]
								delete mp
							)
							else matchHolder[6].node.transform = matchHolder[9].node.transform -- fk_ctrl_array[2] -> ik_point_fkcorrect_array[2]
								
							if matchHolder[4].node.currentModuleCtrl.node.mrr == true then
							(
								if matchHolder.count > 12 then
								(
									matchHolder[4].node.transform = matchHolder[3].node.transform
								)
								else
								(
									mp = point cross:false centermarker:true box:false axistripod:false size:5
									mp.parent = matchHolder[3].node
									mp.transform = matchHolder[3].node.transform
									mp.rotation.controller.z_rotation +=180
									matchHolder[4].node.transform = mp.transform -- fk_ctrl_array[1] -> ik_point_array[1]
									delete mp
								)
							)
							else matchHolder[4].node.transform = matchHolder[3].node.transform -- fk_ctrl_array[3] -> ik_ctrl

							if matchHolder.count > 12 do
							(
							matchHolder[13].node.transform = matchHolder[14].node.transform
							)
						)
					)
				)
			)
	)
Custattributes.add fn_target.modifiers[#attributes] length_att				
)

fn FN_buildArm fnTarget fnParent =
(
	fn_limb = #(fnTarget.armBonesHolderG[1], fnTarget.armBonesHolderG[2], fnTarget.armBonesHolderG[3])
	
	
	if fn_limb[3].node.parent.parentPointHolderG[1].node.legToeHolderG.count != 0 then -- yani ayak var
	(
		try (fn_toe = fnTarget.armBonesHolderG[4]) catch (fn_toe = undefined)
		try (fn_collar = fnTarget.armBonesHolderG[5]) catch (fn_collar = undefined)
	)
	else
	(
		try (fn_collar = fnTarget.armBonesHolderG[4]) catch (fn_collar = undefined)
	)

	-----------create attribute holder

	att_ctrl_radius = ((fn_limb[3].node.length + fn_limb[3].node.width)/4)*glbBuildSCL
	att_ctrl = FN_createNgon att_ctrl_radius
	att_ctrl.name = fn_limb[3].node.name + "_AttCtrl"
	att_ctrl.transform = fn_limb[3].node.transform
	att_ctrl.scale = [1,1,1]
	att_ctrl.parent = fn_limb[3].node
	att_ctrl.rotation.controller.z_Rotation += 90
	att_ctrl.pos.controller.y_position += fn_limb[3].node.length
	att_ctrl.pos.controller.x_position += fn_limb[3].node.height/2
-- 	deletemodifier att_ctrl att_ctrl.modifiers[#attributes]
-- 	addModifier att_ctrl (EmptyModifier ()) 
-- 	att_ctrl.modifiers[#attribute_holder].name = "attributes"
	FN_IkAttribtes att_ctrl
	FN_CurveAttributes att_ctrl
	FN_handAttributes att_ctrl 
	att_ctrl.modifiers[#attributes].ikAttributes[#ikStretch].controller = bezier_float ()
	att_ctrl.modifiers[#attributes].ikAttributes[#softIK].controller = bezier_float ()
	att_ctrl.modifiers[#attributes].curveAttributes[#squash].controller = bezier_float ()
	att_ctrl.modifiers[#attributes].curveAttributes[#curve].controller = bezier_float ()
	att_ctrl.modifiers[#attributes].curveAttributes[#followU].controller = bezier_float ()
	att_ctrl.modifiers[#attributes].curveAttributes[#followM].controller = bezier_float ()
	att_ctrl.modifiers[#attributes].curveAttributes[#followL].controller = bezier_float ()
	att_ctrl.modifiers[#attributes].handAttributes[#_scale].controller = bezier_float ()
		
	if fnTarget.legToeHolderG.count == 0 do att_ctrl.modifiers[#attributes].ikAttributes.ikfk = 1
	if fnTarget.nodeMirror do 
	(
		att_ctrl.mrr = true
	)
	

	----------create shoulder & base parents
	if fn_collar != undefined then
	(
		parentPoint_ref = FN_createPoint ()
		parentPoint_ref.parent = fnParent
		parentPoint_ref.transform = fn_collar.node.transform
		parentPoint_ref.scale = [1,1,1]
		rst parentPoint_ref
		
		parentPoint = FN_createPoint () -- scale'den etkilenmesin diye roota parentlanan alt parent
		parentPoint.parent = glbRoot
		parentPoint.transform = parentPoint_ref.transform
		parentPoint.scale = [1,1,1]
		rst parentPoint
		parentPoint.pos.controller[2].controller = Position_Constraint ()
		parentPoint.pos.controller[2].controller.appendTarget parentPoint_ref 100
		parentPoint.rotation.controller[2].controller = Orientation_Constraint ()
		parentPoint.rotation.controller[2].controller.appendTarget parentPoint_ref 100
		
		------- shoulder bone & ctrl
		if fnTarget.nodeMirror then (shoulder_ctrl = FN_createPin parentPoint.pos (parentPoint.pos + [0,fn_collar.node.clavicleUpHolderG[1].node.pos.controller.y_position*glbBuildSCL*-.8,0]))
		else (shoulder_ctrl = FN_createPin parentPoint.pos (parentPoint.pos + [0,fn_collar.node.clavicleUpHolderG[1].node.pos.controller.y_position*glbBuildSCL*.8,0]))
		shoulder_ctrl.name = fn_collar.node.name + "Ctrl"
		shoulder_ctrl.transform = parentPoint.transform
		shoulder_ctrl.scale = [1,1,1]
		shoulder_ctrl.parent = parentPoint
		if fnTarget.nodeMirror do 
		(
			shoulder_ctrl.rotation.controller.z_rotation +=180
		)
		rst shoulder_ctrl
		shoulder_ctrl.scale.controller = scale_script ()
		
		
		-- for mirrored arm fix rotation
		shoulderChildPnt = FN_createPoint () -- parente bagli olan 
		shoulderChildPnt.parent = shoulder_ctrl
		shoulderChildPnt.transform =  parentPoint.transform
		shoulderChildPnt.scale = [1,1,1]
		rst shoulderChildPnt

		shoulderBone = (FN_buildBox fn_collar.node (fn_collar.node.width*glbBuildSCL) (fn_collar.node.length*glbBuildSCL) (fn_collar.node.height*glbBuildSCL))
		shoulderBone.name = fn_collar.node.name
		shoulderBone.transform = shoulderChildPnt.transform
		shoulderBone.parent = shoulderChildPnt
-- 		if fnTarget.nodeMirror[1] == true do shoulderBone.rotation.controller.z_rotation = 0; shoulderBone.rotation.controller.x_rotation = 0;
		rst shoulderBone
	
		parentPoint = FN_createPoint () -- parente bagli olan 
		parentPoint.parent = shoulderBone
		parentPoint.transform = fn_limb[1].node.transform
		parentPoint.scale = [1,1,1]
		rst parentPoint
		
		pntRoot = FN_createPoint () -- roota bagli rotasyon pointi
		pntRoot.parent = glbHubCtrl
		pntRoot.transform = parentPoint.transform
		rst pntRoot
		pntRoot.pos.controller[2].controller = Position_Constraint ()
		pntRoot.pos.controller[2].controller.appendTarget parentPoint 100
		
		pntAbsRel = FN_createPoint () --ikisinin arasinda oryante olan
		pntAbsRel.parent = shoulderBone
		pntAbsRel.transform = parentPoint.transform
		rst pntAbsRel
		pntAbsRel.rotation.controller[2].controller = Orientation_Constraint ()
		pntAbsRel.rotation.controller[2].controller.appendTarget pntRoot 0
		pntAbsRel.rotation.controller[2].controller.appendTarget parentPoint 100
		
		paramWire.connect att_ctrl.modifiers[#attributes].ikAttributes[#fk_AbRel] pntAbsRel.rotation.controller[2].controller[#Orientation_Weight_0] "1-fk_AbRel"
		paramWire.connect att_ctrl.modifiers[#attributes].ikAttributes[#fk_AbRel] pntAbsRel.rotation.controller[2].controller[#Orientation_Weight_1] "fk_AbRel"
		
		
		fkparentPoint = FN_createPoint ()
		fkparentPoint.parent = pntAbsRel
		fkparentPoint.transform = pntAbsRel.transform
		rst fkparentPoint
	)
	else 
	(
		parentPoint_ref = FN_createPoint () -- parente bagli olan 
		parentPoint_ref.parent = fnParent
		parentPoint_ref.transform = fn_limb[1].node.transform
		parentPoint_ref.scale = [1,1,1]
		rst parentPoint_ref
		
		parentPoint = FN_createPoint () -- scale'den etkilenmesin diye roota parentlanan alt parent
		parentPoint.parent = glbRoot
		parentPoint.transform = parentPoint_ref.transform
		parentPoint.scale = [1,1,1]
		rst parentPoint
		parentPoint.pos.controller[2].controller = Position_Constraint ()
		parentPoint.pos.controller[2].controller.appendTarget parentPoint_ref 100
		parentPoint.rotation.controller[2].controller = Orientation_Constraint ()
		parentPoint.rotation.controller[2].controller.appendTarget parentPoint_ref 100
		
		------- shoulder bone & ctrl
		if fnTarget.nodeMirror then (shoulder_ctrl = FN_createPin parentPoint.pos (parentPoint.pos + [0,(fn_limb[1].node.height*(fn_limb[1].node.twistBoneHolderG.count+1))*-.5*glbBuildSCL,0]))
		else (shoulder_ctrl = FN_createPin parentPoint.pos (parentPoint.pos + [0,(fn_limb[1].node.height*(fn_limb[1].node.twistBoneHolderG.count+1))*.5*glbBuildSCL,0]))
		
			
		shoulder_ctrl.name = fn_limb[1].node.name + "_MainCtrl"
		shoulder_ctrl.transform = parentPoint.transform
		shoulder_ctrl.parent = parentPoint
		if fnTarget.nodeMirror do 
		(
			shoulder_ctrl.rotation.controller.z_rotation +=180
		)
		rst shoulder_ctrl
		shoulder_ctrl.scale.controller = scale_script ()
		-- for mirrored arm fix rotation
		shoulderChildPnt = FN_createPoint () -- parente bagli olan 
		shoulderChildPnt.parent = shoulder_ctrl
		shoulderChildPnt.transform =  fn_limb[1].node.transform
		shoulderChildPnt.scale = [1,1,1]
		rst shoulderChildPnt
		
		parentPoint = FN_createPoint () -- parente bagli olan 
		parentPoint.parent = shoulderChildPnt
		parentPoint.transform =  fn_limb[1].node.transform
		parentPoint.scale = [1,1,1]
		rst parentPoint
		
		pntRoot = FN_createPoint () -- roota bagli rotasyon pointi
		pntRoot.parent = glbHubCtrl
		pntRoot.transform =  parentPoint.transform
		rst pntRoot
		pntRoot.pos.controller[2].controller = Position_Constraint ()
		pntRoot.pos.controller[2].controller.appendTarget parentPoint 100
		
		pntAbsRel = FN_createPoint () --ikisinin arasinda oryante olan
		pntAbsRel.parent = shoulderChildPnt
		pntAbsRel.transform = shoulderChildPnt.transform
		rst pntAbsRel
		pntAbsRel.rotation.controller[2].controller = Orientation_Constraint ()
		pntAbsRel.rotation.controller[2].controller.appendTarget pntRoot 0
		pntAbsRel.rotation.controller[2].controller.appendTarget parentPoint 100
		
		paramWire.connect att_ctrl.modifiers[#attributes].ikAttributes[#fk_AbRel] pntAbsRel.rotation.controller[2].controller[#Orientation_Weight_0] "1-fk_AbRel"
		paramWire.connect att_ctrl.modifiers[#attributes].ikAttributes[#fk_AbRel] pntAbsRel.rotation.controller[2].controller[#Orientation_Weight_1] "fk_AbRel"
		
		
		fkparentPoint = FN_createPoint ()
		fkparentPoint.parent = pntAbsRel
		fkparentPoint.transform = pntAbsRel.transform
		rst fkparentPoint
	)
	
	--------------------- create fk circles

	fk_ctrl_array = #()
	fk_ctrlChild_array = #()

	for i=1 to (fn_limb.count-1) do
	(
		circle_radius = ((fn_limb[i].node.length + fn_limb[i].node.width)/2)*glbBuildSCL
		circle_ctrl = FN_createCircle circle_radius
		circle_ctrl.name = fn_limb[i].node.name + "_FKCtrl"
		circle_ctrl.transform = fn_limb[i].node.transform
		circle_ctrl.scale = [1,1,1]
		circle_ctrl.parent = fn_limb[i].node
		
		if fnTarget.nodeMirror do 
		(
			circle_ctrl.rotation.controller.z_rotation +=180
		)
		rst circle_ctrl
		-- for mirrored arm fix rotation
		fkChildPnt = FN_createPoint () -- parente bagli olan 
-- 		fkChildPnt.parent = circle_ctrl
		fkChildPnt.transform =  fn_limb[i].node.transform
		fkChildPnt.scale = [1,1,1]
		rst fkChildPnt
		
		append	fk_ctrl_array circle_ctrl
		append	fk_ctrlChild_array fkChildPnt
		obj = NodeTransformMonitor node:circle_ctrl forwardTransformChangeMsgs:false
		append att_ctrl.modifiers[#attributes].ikAttributes.fkHolder obj
	)
	
	circle_radius = ((fn_limb[3].node.Length + fn_limb[3].node.width)/2.2)*glbBuildSCL
	circle_ctrl = FN_createCircle circle_radius
	circle_ctrl.name = fn_limb[3].node.name + "_FKCtrl"
	circle_ctrl.transform = fn_limb[3].node.transform
	circle_ctrl.scale = [1,1,1]
	circle_ctrl.parent = fn_limb[3].node
	
	if fnTarget.nodeMirror do 
	(
		circle_ctrl.rotation.controller.z_rotation +=180
	)
	-- for mirrored arm fix rotation
	fkChildPnt = FN_createPoint () -- parente bagli olan 
-- 	fkChildPnt.parent = circle_ctrl
	fkChildPnt.transform =  fn_limb[3].node.transform
	fkChildPnt.scale = [1,1,1]
	rst fkChildPnt
	append	fk_ctrl_array circle_ctrl
	append	fk_ctrlChild_array fkChildPnt
	obj = NodeTransformMonitor node:circle_ctrl forwardTransformChangeMsgs:false
	append att_ctrl.modifiers[#attributes].ikAttributes.fkHolder obj


	----------- create ik points

	ik_point_array = #()
	ik_point_fkcorrect_array = #()


	for i=1 to fk_ctrl_array.count do
	(
		ik_point = FN_createPoint ()
		ik_point.transform = fk_ctrlChild_array[i].transform
		ik_point.scale = [1,1,1]
		ik_point.parent = fk_ctrlChild_array[i]
-- 		
		append ik_point_array ik_point
			
		ik_point_fkcorrect = FN_createPoint ()
		ik_point_fkcorrect.transform = fk_ctrlChild_array[i].transform
		ik_point_fkcorrect.scale = [1,1,1]
		ik_point_fkcorrect.parent = ik_point
		append ik_point_fkcorrect_array ik_point_fkcorrect
	)
	
	ik_point_array[1].parent = parentPoint

	for i=2 to ik_point_array.count do
	(
		ik_point_array[i].parent = ik_point_array[i-1]
	)
	

	---------- create ik pole

	ik_pole = FN_createPoint ()
	ik_pole.transform = fnTarget.armPoleHolderG[2].node.transform
	ik_pole.scale = [1,1,1]
	ik_pole.parent = glbRoot

-- 	ik_pole_ctrl = FN_createRectangle w:((fn_limb[3].node.length + fn_limb[3].node.width)*glbBuildSCL*.5) l:((fn_limb[3].node.length + fn_limb[3].node.width)*glbBuildSCL*.5)
	ik_pole_ctrl = FN_createAsterix (((fn_limb[3].node.length + fn_limb[3].node.width)/2)*glbBuildSCL)
	ik_pole_ctrl.name = fnTarget.armPoleHolderG[2].node.name + "Ctrl"
	ik_pole_ctrl.transform = ik_pole.transform
	ik_pole_ctrl.parent = ik_pole
	rst ik_pole_ctrl
	
	obj = NodeTransformMonitor node:ik_pole_ctrl forwardTransformChangeMsgs:false
	append att_ctrl.modifiers[#attributes].ikAttributes.ikHolder obj
	-- pole snap
	
	poleSnap = FN_createPoint ()
	poleSnap.parent = ik_point_fkcorrect_array[2]
	poleSnap.transform = ik_point_fkcorrect_array[2].transform
	
	poleSnap_pos = position_constraint ()
	poleSnap_pos.appendTarget ik_point_fkcorrect_array[2] 100
	poleSnap_pos.appendTarget ik_pole_ctrl 0
	poleSnap.position.controller = poleSnap_pos
	poleSnap.position.controller.weight[2].controller = bezier_float ()
	paramWire.connect att_ctrl.modifiers[#attributes].ikAttributes[#poleSnap] poleSnap.position.controller[#Position_Weight_0] "1-poleSnap"
	paramWire.connect att_ctrl.modifiers[#attributes].ikAttributes[#poleSnap] poleSnap.position.controller[#Position_Weight_1] "poleSnap"
	
	ik_blendParentArray = #(ik_point_fkcorrect_array[1], polesnap, ik_point_fkcorrect_array[3])

	--create ik

	nGon_radius = ((fn_limb[3].node.length + fn_limb[3].node.width)/2)*glbBuildSCL
	ik_ctrl = FN_createNgon nGon_radius
	ik_ctrl.name = fn_limb[3].node.name+ "_IKctrl"
	ik_ctrl.transform = fk_ctrlChild_array[fk_ctrlChild_array.count].transform
	ik_ctrl.parent = glbRoot
	rst ik_ctrl
	ik_ctrl.scale.controller = scale_script ()

	ik_arm = IKSys.ikChain ik_point_array[1] ik_point_array[ik_point_array.count] "IKHISolver"
	FN_addIR ik_arm
	try
	(
		obj = NodeTransformMonitor node:ik_arm forwardTransformChangeMsgs:false
		append glbRoot.rigNodes obj
	)catch()
	ik_arm.transform.controller.VHTarget = ik_pole_ctrl
	ik_arm.transform.controller.dispGoal = on
	ik_arm.parent = ik_ctrl
	ik_arm.transform = ik_ctrl.transform
	
	ik_arm.name = uniquename  (rName + "_hiddenNodes_")
	newLayerHiddenNodes.addNode ik_arm
	
	hide ik_arm
	freeze ik_arm
	
	obj = NodeTransformMonitor node:ik_ctrl forwardTransformChangeMsgs:false
	append att_ctrl.modifiers[#attributes].ikAttributes.ikHolder obj


	--------- make ik stretchable

	upper_length = distance ik_point_array[1] ik_point_array[2]
	lower_length = distance ik_point_array[2] ik_point_array[3]
	total_length = upper_length + lower_length
	
	att_ctrl.modifiers[#attributes].ikAttributes[#uLength].controller = bezier_float ()
	att_ctrl.modifiers[#attributes].ikAttributes[#uLength].value = upper_length
	att_ctrl.modifiers[#attributes].ikAttributes[#uLengthAct].controller = bezier_float ()
	att_ctrl.modifiers[#attributes].ikAttributes[#uLengthAct].value = upper_length
	att_ctrl.modifiers[#attributes].ikAttributes[#lLength].controller = bezier_float ()
	att_ctrl.modifiers[#attributes].ikAttributes[#lLength].value = lower_length
	att_ctrl.modifiers[#attributes].ikAttributes[#lLengthAct].controller = bezier_float ()
	att_ctrl.modifiers[#attributes].ikAttributes[#lLengthAct].value = lower_length
	att_ctrl.modifiers[#attributes].ikAttributes[#tLength].controller = bezier_float ()
	att_ctrl.modifiers[#attributes].ikAttributes[#tLength].value = total_length
	
	pntLookat = FN_createPoint ()
	pntLookat.transform = parentPoint.transform
	pntLookat.parent = parentPoint
	
	pntLookat.rotation.controller = LookAt_Constraint ()
	pntLookat.rotation.controller.lookat_vector_length = 0
	pntLookat.rotation.controller.upnode_world = off
	pntLookat.rotation.controller.pickUpNode = parentPoint
	pntLookat.rotation.controller.StoUP_axis = 2
	pntLookat.rotation.controller.upnode_axis = 2
	pntLookat.rotation.controller.appendTarget ik_arm 100
	
	pntSoft = FN_createPoint ()
	pntSoft.transform = pntLookat.transform
	pntSoft.parent = pntLookat
	pntSoft.size = 20
-- 	
		
	str_script = float_script ()
	str_script.addtarget "scl"  glbRoot.scale.controller
	str_script.addnode "bs" pntLookat
	str_script.addnode "tg"  ik_ctrl
	str_script.script = "try((distance bs tg)/scl.x)catch(0)"
	pntSoft.pos.controller.X_Position.controller = float_limit ()
	pntSoft.pos.controller.X_Position.controller.Limited_Controller__Bezier_Float.controller = str_script
	pntSoft.pos.controller.X_Position.controller.upper_limit.controller = att_ctrl.modifiers[#attributes].ikAttributes.tLength.controller
	
	str_script = float_script ()
	str_script.addTarget "softIK" att_ctrl.modifiers[#attributes].ikAttributes.softIK.controller
	str_script.addTarget "tL"  att_ctrl.modifiers[#attributes].ikAttributes.tLength.controller
	str_script.script = "tL*softIK*.1"
	pntSoft.pos.controller.X_Position.controller.upper_smoothing.controller = str_script
	

	ik_mlt_array = #() --ik bone length muliplier
	for i = 2 to ik_point_array.count do
	(
		dist= distance ik_point_array[i-1] ik_point_array[i]
		ik_mlt = dist/total_length
		append ik_mlt_array ik_mlt
	)


	str_script = float_script ()
	str_script.addtarget "scl"  glbRoot.scale.controller
	str_script.addNode "soft" pntSoft
	str_script.addNode "ik" ik_ctrl
	str_script.addtarget "ikStretch" att_ctrl.modifiers[#attributes].ikAttributes[#ikStretch].controller
	str_script.addtarget "uLength" att_ctrl.modifiers[#attributes].ikAttributes[#uLength].controller
	str_script.addtarget "lLength" att_ctrl.modifiers[#attributes].ikAttributes[#lLength].controller
-- 	if fnTarget.nodeMirror[1] == true then str_script.script = "(uLength + (((distance soft ik)/scl.x)*(uLength/(uLength+lLength))))*-1"
	str_script.script = "try((uLength + ikStretch*(((distance soft ik)/scl.x)*(uLength/(uLength+lLength)))))catch(0)"
	ik_point_array[2].transform.controller.FK_Sub_Control.controller.Position.controller[#x_Position].controller = str_script
	
	str_script = float_script ()
	str_script.addtarget "scl"  glbRoot.scale.controller
	str_script.addNode "soft" pntSoft
	str_script.addNode "ik" ik_ctrl
	str_script.addtarget "ikStretch" att_ctrl.modifiers[#attributes].ikAttributes[#ikStretch].controller
	str_script.addtarget "uLength" att_ctrl.modifiers[#attributes].ikAttributes[#uLength].controller
	str_script.addtarget "lLength" att_ctrl.modifiers[#attributes].ikAttributes[#lLength].controller
-- 	if fnTarget.nodeMirror[1] == true then str_script.script = "(lLength + (((distance soft ik)/scl.x)*(lLength/(uLength+lLength))))*-1"
	str_script.script = "try((lLength + ikStretch*(((distance soft ik)/scl.x)*(lLength/(uLength+lLength)))))catch(0)"
	ik_point_array[3].transform.controller.FK_Sub_Control.controller.Position.controller[#x_Position].controller = str_script

	fk_ctrl_array[1].parent = fkparentPoint
	rst fk_ctrl_array[1]
-- 	if fnTarget.nodeMirror do fk_ctrl_array[1].scale.controller.value = [-1,-1,1]
	fk_ctrlChild_array[1].parent = fk_ctrl_array[1]
	fk_ctrl_array[1].scale.controller = scale_script ()
	fk_ctrl_array[1].pos.controller.XYZ.controller.X_Position.controller = float_script ()
	fk_ctrl_array[1].pos.controller.XYZ.controller.Y_Position.controller = float_script ()
	fk_ctrl_array[1].pos.controller.XYZ.controller.Z_Position.controller = float_script ()

	for i=2 to (fk_ctrl_array.count) do
	(
		fk_ctrl_array[i].parent = fk_ctrl_array[i-1]
		rst fk_ctrl_array[i]
		fk_ctrl_array[i].scale.controller = scale_script ()
-- 		if fnTarget.nodeMirror do fk_ctrl_array[i].scale.controller.value = [-1,-1,1]
		fk_ctrlChild_array[i].parent = fk_ctrl_array[i]
		rst fk_ctrlChild_array[i]
		fk_ctrl_array[i].pos.controller.XYZ.controller.Y_Position.controller = float_script ()
		fk_ctrl_array[i].pos.controller.XYZ.controller.Z_Position.controller = float_script ()
	)

	----- create fk pole for ik/fk match
		
	if fk_ctrl_array.count == 3 then
	(
		poleRefFore = FN_createPoint ()
		poleRefFore.parent = fk_ctrlChild_array[2]
		poleRefFore.transform = fk_ctrlChild_array[2].transform
		poleRefFore.pos.controller.x_position += 1
		
		poleRefUpper = FN_createPoint ()
		poleRefUpper.parent = fk_ctrlChild_array[1]
		poleRefUpper.transform = fk_ctrlChild_array[1].transform
		poleRefUpper.pos.controller.X_Position.controller = float_script ()
		poleRefUpper.pos.controller.X_Position.controller.addNode "parent" fk_ctrlChild_array[1]
		poleRefUpper.pos.controller.X_Position.controller.addNode "chld" fk_ctrlChild_array[2]
		poleRefUpper.pos.controller.X_Position.controller.addNode "rNode" glbRoot
		(poleRefUpper.pos.controller.X_Position.controller.script = "try(if (chld != undefined and parent != undefined) then (((distance parent chld)/(rNode.scale.x))-1) else (0))catch(0)")
		
		poleRef = FN_createPoint ()
		poleRef.parent = fk_ctrlChild_array[1]
		poleRef.pos.controller = Position_Constraint ()
		poleRef.pos.controller.appendTarget poleRefUpper 50
		poleRef.pos.controller.appendTarget poleRefFore 50
		
		poleRef.rotation.controller = lookat_Constraint ()
		poleRef.rotation.controller.lookat_vector_length = 0
		poleRef.rotation.controller.target_axis = 1
		poleRef.rotation.controller.upnode_ctrl = 1
		poleRef.rotation.controller.StoUP_axis = 2
		poleRef.rotation.controller.upnode_axis = 2
		poleRef.rotation.controller.pickUpNode = fk_ctrlChild_array[1]
		poleRef.rotation.controller.upnode_world = off
		poleRef.rotation.controller.appendTarget fk_ctrlChild_array[2] 100
		poleRef.scale *= glbBuildSCL
		
		fk_pole = FN_createPoint ()
		fk_pole.parent = poleRef
		fk_pole.transform = ik_pole_ctrl.transform
		fk_pole.pos.controller.y_position.controller = float_script ()
		fk_pole.pos.controller.y_Position.controller.addConstant "cns" (distance ik_pole_ctrl fk_ctrlChild_array[2])
		fk_pole.pos.controller.y_Position.controller.addTarget "parent" fk_ctrlChild_array[2].pos.controller[2].controller.Y_Position.controller
		fk_pole.pos.controller.y_Position.controller.addTarget "child" fk_ctrlChild_array[3].pos.controller[2].controller.Y_Position.controller
		fk_pole.pos.controller.y_Position.controller.addTarget "scl" glbRoot.scale.controller.X_Scale.controller
		(fk_pole.pos.controller.y_Position.controller.script = "if parent < 0 do parent = 0 \nif child < 0 do child = 0 \n(cns+parent+child)")
	
	)

		---------- blend points

	blendPointArray = #()

	for i = 1 to (fk_ctrl_array.count-1) do
	(
		blendPoint = FN_createPoint ()
		blendPoint.parent = parentPoint
		blendPoint.transform = fk_ctrlChild_array[i].transform
		blendPoint.scale = [1,1,1]
		blendPoint_rot = orientation_constraint ()
		blendPoint_rot.appendTarget ik_blendParentArray[i] 0
		blendPoint_rot.appendTarget fk_ctrlChild_array[i] 100
		blendPoint.rotation.controller = blendPoint_rot
		blendPoint.rotation.controller.weight[2].controller = bezier_float ()
		paramWire.connect att_ctrl.modifiers[#attributes].ikAttributes[#ikfk] blendPoint.rotation.controller[#Orientation_Weight_0] "1-ikfk"
		paramWire.connect att_ctrl.modifiers[#attributes].ikAttributes[#ikfk] blendPoint.rotation.controller[#Orientation_Weight_1] "ikfk"

		blendPoint_pos = position_constraint ()
		blendPoint_pos.appendTarget ik_blendParentArray[i] 0
		blendPoint_pos.appendTarget fk_ctrlChild_array[i] 100
		blendPoint.position.controller = blendPoint_pos
		blendPoint.position.controller.weight[2].controller = bezier_float ()
		paramWire.connect att_ctrl.modifiers[#attributes].ikAttributes[#ikfk] blendPoint.position.controller[#Position_Weight_0] "1-ikfk"
		paramWire.connect att_ctrl.modifiers[#attributes].ikAttributes[#ikfk] blendPoint.position.controller[#Position_Weight_1] "ikfk"
		append blendPointArray blendPoint
	)

	blendPoint = FN_createPoint ()
	blendPoint.parent = parentPoint
	blendPoint.transform = fk_ctrlChild_array[fk_ctrlChild_array.count].transform
	blendPoint.scale = [1,1,1]
	blendPoint_rot = orientation_constraint ()
	blendPoint_rot.appendTarget ik_ctrl 0
	blendPoint_rot.appendTarget fk_ctrlChild_array[fk_ctrlChild_array.count] 100
	blendPoint.rotation.controller = blendPoint_rot
	blendPoint.rotation.controller.weight[2].controller = bezier_float ()
	paramWire.connect att_ctrl.modifiers[#attributes].ikAttributes[#ikfk] blendPoint.rotation.controller[#Orientation_Weight_0] "1-ikfk"
	paramWire.connect att_ctrl.modifiers[#attributes].ikAttributes[#ikfk] blendPoint.rotation.controller[#Orientation_Weight_1] "ikfk"

	blendPoint_pos = position_constraint ()
	blendPoint_pos.appendTarget ik_point_array[ik_point_array.count] 0
	blendPoint_pos.appendTarget fk_ctrlChild_array[fk_ctrlChild_array.count] 100
	blendPoint.position.controller = blendPoint_pos
	blendPoint.position.controller.weight[2].controller = bezier_float ()
	paramWire.connect att_ctrl.modifiers[#attributes].ikAttributes[#ikfk] blendPoint.position.controller[#Position_Weight_0] "1-ikfk"
	paramWire.connect att_ctrl.modifiers[#attributes].ikAttributes[#ikfk] blendPoint.position.controller[#Position_Weight_1] "ikfk"
	append blendPointArray blendPoint


	------------ ik/fk match

	if fk_ctrl_array.count == 3 do
	(
		obj = NodeTransformMonitor node:ik_pole_ctrl forwardTransformChangeMsgs:false
		append att_ctrl.modifiers[#attributes].ikAttributes.matchHolder obj

		obj = NodeTransformMonitor node:fk_pole forwardTransformChangeMsgs:false
		append att_ctrl.modifiers[#attributes].ikAttributes.matchHolder obj

		obj = NodeTransformMonitor node:ik_ctrl forwardTransformChangeMsgs:false
		append att_ctrl.modifiers[#attributes].ikAttributes.matchHolder obj

		obj = NodeTransformMonitor node:fk_ctrl_array[3] forwardTransformChangeMsgs:false
		append att_ctrl.modifiers[#attributes].ikAttributes.matchHolder obj

		obj = NodeTransformMonitor node:ik_point_array[2] forwardTransformChangeMsgs:false
		append att_ctrl.modifiers[#attributes].ikAttributes.matchHolder obj

		obj = NodeTransformMonitor node:fk_ctrl_array[2] forwardTransformChangeMsgs:false
		append att_ctrl.modifiers[#attributes].ikAttributes.matchHolder obj

		obj = NodeTransformMonitor node:fk_ctrl_array[1] forwardTransformChangeMsgs:false
		append att_ctrl.modifiers[#attributes].ikAttributes.matchHolder obj

		obj = NodeTransformMonitor node:ik_point_fkcorrect_array[1] forwardTransformChangeMsgs:false
		append att_ctrl.modifiers[#attributes].ikAttributes.matchHolder obj

		obj = NodeTransformMonitor node:ik_point_fkcorrect_array[2] forwardTransformChangeMsgs:false
		append att_ctrl.modifiers[#attributes].ikAttributes.matchHolder obj

		obj = NodeTransformMonitor node:ik_point_fkcorrect_array[3] forwardTransformChangeMsgs:false
		append att_ctrl.modifiers[#attributes].ikAttributes.matchHolder obj

		obj = NodeTransformMonitor node:ik_point_array[1] forwardTransformChangeMsgs:false
		append att_ctrl.modifiers[#attributes].ikAttributes.matchHolder obj
		
		obj = NodeTransformMonitor node:glbRoot forwardTransformChangeMsgs:false
		append att_ctrl.modifiers[#attributes].ikAttributes.matchHolder obj
	)
	

	---- Bend ctrls
	
	bendCtrlsArray = #()
	
	for i = 1 to 3 do
	(
		if i == 2 then 
		(
			bendCtrl = FN_createPin fn_limb[i].node.pos (fn_limb[i].node.pos + [0,fnTarget.armPoleHolderG[2].node.pos.controller.y_position*glbBuildSCL*.5,0])

			obj = NodeTransformMonitor node:bendCtrl forwardTransformChangeMsgs:false
			append att_ctrl.modifiers[#attributes].ikAttributes.bendHolder obj
		)
		else
		(
			bendCtrl = FN_createAsterix (((fn_limb[i].node.length + fn_limb[i].node.width)/2)*glbBuildSCL)
			
			obj = NodeTransformMonitor node:bendCtrl forwardTransformChangeMsgs:false
			append att_ctrl.modifiers[#attributes].ikAttributes.strHolder obj
		)
		bendCtrl.name = fn_limb[i].node.name + "_BendCtrl"
		bendCtrl.parent = blendPointArray[i]
		bendCtrl.transform = blendPointArray[i].transform
		
		append bendCtrlsArray bendCtrl

	)

	upperGuide = FN_createPoint ()
	upperGuide.parent = parentPoint
	upperGuide.transform = parentPoint.transform
	
	upperGuide_rot = orientation_constraint ()
	upperGuide_rot.appendTarget parentPoint 50
	upperGuide_rot.appendTarget blendPointArray[1] 50
	upperGuide.rotation.controller = upperGuide_rot

	paramWire.connect att_ctrl.modifiers[#attributes].curveAttributes[#followU] upperGuide.rotation.controller[#Orientation_Weight_0] "1-followU"
	paramWire.connect att_ctrl.modifiers[#attributes].curveAttributes[#followU] upperGuide.rotation.controller[#Orientation_Weight_1] "followU"
	
	bendCtrlsArray[1].parent = upperGuide
	rst bendCtrlsArray[1]
	
	
	middleGuide = FN_createPoint ()
	middleGuide.parent = blendPointArray[2]
	middleGuide.transform = blendPointArray[2].transform
	
	middleGuide_rot = orientation_constraint ()
	middleGuide_rot.appendTarget blendPointArray[1] 50
	middleGuide_rot.appendTarget blendPointArray[2] 50
	middleGuide.rotation.controller = middleGuide_rot
	
	paramWire.connect att_ctrl.modifiers[#attributes].curveAttributes[#followM] middleGuide.rotation.controller[#Orientation_Weight_0] "1-followM"
	paramWire.connect att_ctrl.modifiers[#attributes].curveAttributes[#followM] middleGuide.rotation.controller[#Orientation_Weight_1] "followM"
	
	bendCtrlsArray[2].parent = middleGuide
	bendCtrlsArray[2].transform = middleGuide.transform
	rst bendCtrlsArray[2]
	
	----- bilek egik riglendiyse son bend kontrolcüsü ön kola hizlanir bilege degil. lookat hizalama yapmak için kullanilir.
	
	refGuide = FN_createPoint ()
	refGuide.parent = blendPointArray[3]
	refGuide.transform = blendPointArray[3].transform
	
	refGuide.rotation.controller = LookAt_Constraint ()
	refGuide.rotation.controller.lookat_vector_length = 0
	refGuide.rotation.controller.upnode_world = off
	refGuide.rotation.controller.pickUpNode = blendPointArray[2]
	refGuide.rotation.controller.StoUP_axis = 1
	refGuide.rotation.controller.upnode_axis = 1
	refGuide.rotation.controller.target_axis = 0
	refGuide.rotation.controller.target_axisFlip = on
	refGuide.rotation.controller.appendTarget blendPointArray[2] 100
	
	lowerGuideCorrection = FN_createPoint ()
	lowerGuideCorrection.parent = blendPointArray[3]
	lowerGuideCorrection.transform = refGuide.transform 
	
	
	delete refGuide
	
	lowerGuide = FN_createPoint ()
	lowerGuide.parent = lowerGuideCorrection
	lowerGuide.transform = lowerGuideCorrection.transform
	
	lowerGuide_rot = orientation_constraint ()
	lowerGuide_rot.appendTarget blendPointArray[2] 50
	lowerGuide_rot.appendTarget lowerGuideCorrection 50
	lowerGuide.rotation.controller = lowerGuide_rot
	
	paramWire.connect att_ctrl.modifiers[#attributes].curveAttributes[#followL] lowerGuide.rotation.controller[#Orientation_Weight_0] "1-followL"
	paramWire.connect att_ctrl.modifiers[#attributes].curveAttributes[#followL] lowerGuide.rotation.controller[#Orientation_Weight_1] "followL"
-- 	

	bendCtrlsArray[3].parent = lowerGuide
	bendCtrlsArray[3].transform = lowerGuide.transform
	rst bendCtrlsArray[3]
	
	
	bendGuidesArray = #(upperGuide, middleGuide, lowerGuide)
	
	-- bend bones parent points or upper arm
	
	curveCtrls_Array = #()
	curvePoints_Array = #(#(), #())
	curveBone_Array = #(#(), #())
	armTwistBones = #()
	
	for i = 1 to 2 do
	(
		pntBend = FN_createPoint () -- bend ctrl'e bagli olan 
		pntBend.parent = bendCtrlsArray[i]
		pntBend.transform =  bendGuidesArray[i].transform
		rst pntBend
		
		
		pntBlend = FN_createPoint () -- blend pointe  bagli rotasyon pointi
		pntBlend.parent = bendCtrlsArray[i]
		pntBlend.transform =  bendGuidesArray[i].transform
		rst pntBlend
		pntBlend.rotation.controller[2].controller = LookAt_Constraint ()
		pntBlend.rotation.controller[2].controller.lookat_vector_length = 0
		pntBlend.rotation.controller[2].controller.upnode_world = off
		pntBlend.rotation.controller[2].controller.pickUpNode = bendCtrlsArray[i]
		pntBlend.rotation.controller[2].controller.StoUP_axis = 2
		pntBlend.rotation.controller[2].controller.upnode_axis = 2
		pntBlend.rotation.controller[2].controller.target_axisFlip = off
		pntBlend.rotation.controller[2].controller.appendTarget bendCtrlsArray[i+1] 100
		
		pntOriented = FN_createPoint () --ikisinin arasinda oryante olan
		pntOriented.parent = bendCtrlsArray[i]
		pntOriented.transform = bendGuidesArray[i].transform
		rst pntOriented
		pntOriented.rotation.controller[2].controller = Orientation_Constraint ()
		pntOriented.rotation.controller[2].controller.appendTarget pntBend 0
		pntOriented.rotation.controller[2].controller.appendTarget pntBlend 100
		
		paramWire.connect att_ctrl.modifiers[#attributes].curveAttributes[#curve] pntOriented.rotation.controller[2].controller[#Orientation_Weight_0] "curve"
		paramWire.connect att_ctrl.modifiers[#attributes].curveAttributes[#curve] pntOriented.rotation.controller[2].controller[#Orientation_Weight_1] "1-curve"
		
		curvePoints_Array[i][1] = pntOriented
		
		
		
		-----------
		
		pntBend = FN_createPoint () -- bend ctrl'e bagli olan 
		pntBend.parent = bendCtrlsArray[i+1]
		pntBend.transform =  bendGuidesArray[i+1].transform
		rst pntBend
		
		
		pntBlend = FN_createPoint () -- blend pointe  bagli rotasyon pointi
		pntBlend.parent = bendCtrlsArray[i+1]
		pntBlend.transform =  bendGuidesArray[i+1].transform
		rst pntBlend
		pntBlend.rotation.controller[2].controller = LookAt_Constraint ()
		pntBlend.rotation.controller[2].controller.lookat_vector_length = 0
		pntBlend.rotation.controller[2].controller.upnode_world = off
		pntBlend.rotation.controller[2].controller.pickUpNode = bendCtrlsArray[i+1]
		pntBlend.rotation.controller[2].controller.StoUP_axis = 1
		pntBlend.rotation.controller[2].controller.upnode_axis = 1
		pntBlend.rotation.controller[2].controller.target_axisFlip = on
		pntBlend.rotation.controller[2].controller.appendTarget bendCtrlsArray[i] 100
		
		pntOriented = FN_createPoint () --ikisinin arasinda oryante olan
		pntOriented.parent = bendCtrlsArray[i+1]
		pntOriented.transform = bendGuidesArray[i+1].transform
		rst pntOriented
		pntOriented.rotation.controller[2].controller = Orientation_Constraint ()
		pntOriented.rotation.controller[2].controller.appendTarget pntBend 0
		pntOriented.rotation.controller[2].controller.appendTarget pntBlend 100
		
		paramWire.connect att_ctrl.modifiers[#attributes].curveAttributes[#curve] pntOriented.rotation.controller[2].controller[#Orientation_Weight_0] "curve"
		paramWire.connect att_ctrl.modifiers[#attributes].curveAttributes[#curve] pntOriented.rotation.controller[2].controller[#Orientation_Weight_1] "(1-curve)"
		
		curvePoints_Array[i][2] = pntOriented
			
		
		------------
			
		ss = SplineShape ()
		FN_addIR ss
		try
		(
			obj = NodeTransformMonitor node:ss forwardTransformChangeMsgs:false
			append glbRoot.rigNodes obj
		)catch()
		ss.name = uniquename  (rName + "_hiddenNodes_")
		newLayerHiddenNodes.addNode ss
		ss.parent = glbRoot
		ss.transform = curvePoints_Array[i][1].transform
		addNewSpline ss
		addKnot ss 1 #smooth #curve curvePoints_Array[i][1].pos
		addKnot ss 1 #smooth #curve curvePoints_Array[i][2].pos
		updateShape ss
		
		for i=1 to 2 do 
		(
			setKnotType ss 1 i (#bezier )
		)
		updateShape ss
		
		--center point
		pntCenter = FN_createPoint () -- bend ctrl'e bagli olan 
		pntCenter.transform =  curvePoints_Array[i][1].transform
		pntCenter.pos = ((curvePoints_Array[i][1].pos + curvePoints_Array[i][2].pos)/2)
		
		if i == 1 then(pntCenter.parent = curvePoints_Array[i][2])
		else (pntCenter.parent = curvePoints_Array[i][1])
		
		midCtrl = FN_createPin pntCenter.pos (pntCenter.pos + [0,fnTarget.armPoleHolderG[2].node.pos.controller.y_position*glbBuildSCL*.5,0])
		midCtrl.name = fn_limb[i].node.name + "_midCtrl"
		midCtrl.transform = pntCenter.transform
		midCtrl.parent = pntCenter
		rst midCtrl
		
		obj = NodeTransformMonitor node:midCtrl.parent forwardTransformChangeMsgs:false
		midCtrl.prnt = obj
		midCtrl.m3a = (midCtrl.transform*(inverse midCtrl.parent.transform))
			
		obj = NodeTransformMonitor node:midCtrl forwardTransformChangeMsgs:false
		append att_ctrl.blendCtrls obj
		obj = NodeTransformMonitor node:att_ctrl forwardTransformChangeMsgs:false
		midCtrl.currentModuleCtrl = obj
			
		obj = NodeTransformMonitor node:midCtrl forwardTransformChangeMsgs:false
		append att_ctrl.modifiers[#attributes].ikAttributes.bendHolder obj
		
-- 		midCtrl.mrrAxis = #("z","xyz")
		
		
		--new splineIK
		setCommandPanelTaskMode #modify
		select ss
		
		addModifier ss (Skin ())
		
		pntTop = FN_createPoint ()
		pntTop.transform = curvePoints_Array[i][1].transform
		pntTop.parent = curvePoints_Array[i][1]
			
		pntMid = FN_createPoint ()
		pntMid.transform = midCtrl.transform
		pntMid.parent = midCtrl
			
		pntBtm = FN_createPoint ()
		pntBtm.transform = curvePoints_Array[i][2].transform
		pntBtm.parent = curvePoints_Array[i][2]
			
			
		skinOps.addbone ss.modifiers[#Skin] pntTop 1
		skinOps.addbone ss.modifiers[#Skin] pntMid 1
		skinOps.addbone ss.modifiers[#Skin] pntBtm 1
		
		enableSceneRedraw()
		redrawViews()
		disableSceneRedraw()
		
		skinOps.ReplaceVertexWeights ss.modifiers[#Skin] 1 #(1) #(1)
		skinOps.ReplaceVertexWeights ss.modifiers[#Skin] 2 #(1) #(1)
		skinOps.ReplaceVertexWeights ss.modifiers[#Skin] 3 #(2) #(1)
		skinOps.ReplaceVertexWeights ss.modifiers[#Skin] 4 #(2) #(1)
		skinOps.ReplaceVertexWeights ss.modifiers[#Skin] 5 #(3) #(1)
		skinOps.ReplaceVertexWeights ss.modifiers[#Skin] 6 #(3) #(1)
			
		setCommandPanelTaskMode #create
-- 		addModifier ss (Spline_IK_Control ()) 
-- 		ss.modifiers[#Spline_IK_Control].noLinking()
-- 		ss.modifiers[#Spline_IK_Control].createHelper 2

-- 		ss.modifiers[#Spline_IK_Control].helper_list[1].parent = curvePoints_Array[i][1]
-- 		ss.modifiers[#Spline_IK_Control].helper_list[2].parent = curvePoints_Array[i][2]
			
		setInheritanceFlags ss #{1,2,3,7,8,9}
		
-- 		for i in ss.modifiers[#Spline_IK_Control].helper_list do
-- 		(
-- 			FN_addIR i
-- 			try
-- 			(
-- 				obj = NodeTransformMonitor node:i forwardTransformChangeMsgs:false
-- 				append glbRoot.rigNodes obj
-- 			)catch()
-- 			i.box = false
-- 			i.centermarker = false
-- 			i.cross = false
-- 			i.axistripod = false
-- 			i.size=5
-- 			hide i
-- 			freeze i
-- 			i.name = uniquename  (rName + "_hiddenNodes_")
-- 			newLayerHiddenNodes.addNode i
-- 		)
		-----------
			

-- 		max modify mode
-- 		select ss
-- 		subobjectLevel = 1
-- 		setKnotSelection ss 1 #(2) keep:false
-- 		LX1 = Linked_XForm name:"First XForm"
-- 		modPanel.addModToSelection LX1
-- 		LX1.Control = curvePoints_Array[i][1]
-- 		sselect = splineselect name:"Blocker"
-- 		addmodifier ss sselect
-- 		es2 = edit_spline name:"Second ES"
-- 		modPanel.addModToSelection es2
-- 		subobjectLevel = 1
-- 		setKnotSelection ss 1 #(1) keep:false
-- 		LX2 = Linked_XForm name:"Second XForm"
-- 		modPanel.addModToSelection LX2
-- 		LX2.Control = curvePoints_Array[i][2]
		
		hide ss
		freeze ss
		
		twistBonesArray = #(fn_limb[i].node)
		
		for t = 1 to fn_limb[i].node.twistBoneHolderG.count do
		(
			append twistBonesArray fn_limb[i].node.twistBoneHolderG[t].node
		)
		
		curveDriverPointsArray = #()
		for t = 1 to (twistBonesArray.count+1) do
		(
			ts=(1/(twistBonesArray.count as float))*(t-1)
			tp=(1/((twistBonesArray.count as float)+1))*(t)
			scp = FN_createPoint () /*spine curve point*/ 
			scp.parent = glbRoot
			scp.pos.controller = path_constraint()
			scp.pos.controller.path = ss
			scp.pos.controller.percent = ts*100
			deletekeys scp

			scp.rotation.controller = Orientation_Constraint ()
			scp.rotation.controller.relative = false
			scp.rotation.controller.appendTarget curvePoints_Array[i][1] (100-(ts*100))
			scp.rotation.controller.appendTarget curvePoints_Array[i][2] (ts*100)
			append curveDriverPointsArray scp
				
			obj = NodeTransformMonitor node:scp forwardTransformChangeMsgs:false
			append att_ctrl.modifiers[#attributes].curveAttributes.constantHolder obj
		)
-- 		
		curveDriverCtrls = curveDriverPointsArray
		
		if twistBonesArray.count > 1 then
		(
			curveDriverCtrls = #()
			
			firstPoint = FN_createPoint ()
			firstPoint.parent = curveDriverPointsArray[1]
			firstPoint.transform = curveDriverPointsArray[1].transform
			append curveDriverCtrls firstPoint
			
			for t = 2 to curveDriverPointsArray.count-1 do
			(
				bendCtrl = FN_createAsterix (((twistBonesArray[t].length + twistBonesArray[t].width)/2)*glbBuildSCL)
				bendCtrl.name = twistBonesArray[t].name +"_BendCtrl"
				bendCtrl.parent = curveDriverPointsArray[t]
				bendCtrl.transform = curveDriverPointsArray[t].transform
				rst bendCtrl
				bendCtrl.rotation.controller.XYZ.controller.Y_Rotation.controller = float_script ()
				bendCtrl.rotation.controller.XYZ.controller.Z_Rotation.controller = float_script ()
				bendCtrl.scale.controller = scale_script ()
				
				append curveDriverCtrls bendCtrl
				append curveCtrls_Array bendCtrl
				
				obj = NodeTransformMonitor node:bendCtrl forwardTransformChangeMsgs:false
				append att_ctrl.modifiers[#attributes].ikAttributes.strHolder obj
			)
			
			lastPoint = FN_createPoint ()
			lastPoint.parent = curveDriverPointsArray[curveDriverPointsArray.count]
			lastPoint.transform = curveDriverPointsArray[curveDriverPointsArray.count].transform
			append curveDriverCtrls lastPoint
		)
-- 		
		for t = 1 to twistBonesArray.count do
		(
			fn_tb=(1/((twistBonesArray.count as float)-1))*(t-1)
			oldPoint = curveDriverCtrls[t]
			p1 = curveDriverCtrls[t+1]
			sb =(FN_buildBox twistBonesArray[t] (twistBonesArray[t].width*glbBuildSCL) (twistBonesArray[t].length*glbBuildSCL) (twistBonesArray[t].height*glbBuildSCL))
			sb.name = twistBonesArray[t].name
			sb.parent = parentPoint
			sb.pos.controller = position_Constraint ()
			sb.pos.controller.appendTarget oldPoint 100
			sb.rotation.controller = lookat_Constraint ()
			sb.rotation.controller.target_axis = 0
			sb.rotation.controller.lookat_vector_length = 0
			sb.rotation.controller.upnode_ctrl = 1
			sb.rotation.controller.StoUP_axis = 1
			sb.rotation.controller.upnode_axis = 1
			sb.rotation.controller.pickUpNode = oldPoint
			sb.rotation.controller.upnode_world = off
			sb.rotation.controller.appendTarget p1 100
			sb.height = (distance oldPoint p1)/glbRoot.scale.x
			sb.scale.controller = ScaleXYZ ()
			sb.scale.X_Scale.controller = float_script ()
			sb.scale.X_Scale.controller.AddNode "p0" oldPoint
			sb.scale.X_Scale.controller.AddNode "p1" p1
			sb.scale.X_Scale.controller.AddTarget "scl" glbRoot.scale.controller
			sb.scale.X_Scale.controller.Addconstant "hgt" sb.height
			sb.scale.X_Scale.controller.script = "try(((distance p0 p1)/hgt)*(1/scl.x))catch(0)"
			sb.scale.controller.Y_Scale.controller = float_list ()
			sb.scale.controller.Y_Scale.controller.Bezier_Float.controller = float_script ()
			sb.scale.controller.Y_Scale.controller.Available.controller = float_script ()
			sb.scale.controller.Y_Scale.controller.weight[1].controller = float_script ()
			sb.scale.controller.Y_Scale.controller.weight[2].controller = float_script ()
			sb.scale.controller.Y_Scale.controller[1].controller.AddNode "p0" oldPoint
			sb.scale.controller.Y_Scale.controller[1].controller.AddNode "p1" p1
			sb.scale.controller.Y_Scale.controller[1].controller.AddTarget "scl" glbRoot.scale.controller
			sb.scale.controller.Y_Scale.controller[1].controller.Addconstant "hgt" sb.height
			sb.scale.controller.Y_Scale.controller[1].controller.script = "try((1/(((distance p0 p1)/hgt)))*scl.x)catch(0)"
			sb.scale.controller.Y_Scale.controller[2].controller.script ="1"
			sb.scale.controller.Y_Scale.controller.weight[1].controller.AddTarget "mlt" att_ctrl.modifiers[#attributes].curveAttributes[#squash].controller
			sb.scale.controller.Y_Scale.controller.weight[1].controller.script = "mlt"
			sb.scale.controller.Y_Scale.controller.weight[2].controller.AddTarget "mlt" att_ctrl.modifiers[#attributes].curveAttributes[#squash].controller
			sb.scale.controller.Y_Scale.controller.weight[2].controller.script = "1-mlt"
			sb.scale.controller.Z_Scale.controller = float_list ()
			sb.scale.controller.Z_Scale.controller.Bezier_Float.controller = float_script ()
			sb.scale.controller.Z_Scale.controller.Available.controller = float_script ()
			sb.scale.controller.Z_Scale.controller.weight[1].controller = float_script ()
			sb.scale.controller.Z_Scale.controller.weight[2].controller = float_script ()
			sb.scale.controller.Z_Scale.controller[1].controller.AddNode "p0" oldPoint
			sb.scale.controller.Z_Scale.controller[1].controller.AddNode "p1" p1
			sb.scale.controller.Z_Scale.controller[1].controller.AddTarget "scl" glbRoot.scale.controller
			sb.scale.controller.Z_Scale.controller[1].controller.Addconstant "hgt" sb.height
			sb.scale.controller.Z_Scale.controller[1].controller.script = "try((1/(((distance p0 p1)/hgt)))*scl.z)catch(0)"
			sb.scale.controller.Z_Scale.controller[2].controller.script ="1"
			sb.scale.controller.Z_Scale.controller.weight[1].controller.AddTarget "mlt" att_ctrl.modifiers[#attributes].curveAttributes[#squash].controller
			sb.scale.controller.Z_Scale.controller.weight[1].controller.script = "mlt"
			sb.scale.controller.Z_Scale.controller.weight[2].controller.AddTarget "mlt" att_ctrl.modifiers[#attributes].curveAttributes[#squash].controller
			sb.scale.controller.Z_Scale.controller.weight[2].controller.script = "1-mlt"
			curveBone_Array[i][t] = sb
			if t == 1 do append armTwistBones sb
		)
		
		if twistBonesArray.count < 2 do
		(
			hide midCtrl
		)
	)
	
	---- palm
	
	palm_bone = (FN_buildBox fn_limb[3].node (fn_limb[3].node.width*glbBuildSCL) (fn_limb[3].node.length*glbBuildSCL) (fn_limb[3].node.height*glbBuildSCL))
	palm_bone.name = fn_limb[3].node.name
	palm_bone.transform = blendPointArray[3].transform
	palm_bone.parent = blendPointArray[3]

	
	palm_bone.pos.controller = position_Constraint ()
	palm_bone.pos.controller.RELATIVE = on
	palm_bone.pos.controller.appendTarget bendCtrlsArray[3] 100
	

	paramWire.connect att_ctrl.modifiers[#attributes].handAttributes[#_scale] blendPointArray[3].transform.controller[#Scale] "_scale*[1,1,1]"
	
	bBones = #(0,0,0)
	--- blend bones sholder-elbow-wrist
	if fn_collar != undefined then
	(
		a=curveBone_Array[1][1].width
		b=curveBone_Array[1][1].length
		bBone =FN_buildBox fnTarget.rootNodeHolderG[1].node (a*1.2) (b*1.2) ((a+b)/5) _blend:1
		bBone.name = fn_collar.node.name+ "Blend"
		bBone.transform = curveBone_Array[1][1].transform
		bBone.parent = parentpoint
		bBone.pos.controller = position_Constraint ()
		bBone.pos.controller.appendTarget curveBone_Array[1][1] 100
		bBone.rotation.controller = orientation_Constraint ()
		bBone.rotation.controller.appendTarget shoulderBone 50
		bBone.rotation.controller.appendTarget curveBone_Array[1][1] 50
		
		bBone.scale.controller = ScaleXYZ ()
		bBone.scale.Y_Scale.controller = float_script ()
		bBone.scale.Y_Scale.controller.AddTarget "scl1" shoulderBone.scale.controller
		bBone.scale.Y_Scale.controller.AddTarget "scl2" curveBone_Array[1][1].scale.controller
		bBone.scale.Y_Scale.controller.script = "((scl1.y+scl2.y)/2)"
		bBone.scale.Z_Scale.controller = float_script ()
		bBone.scale.Z_Scale.controller.AddTarget "scl1" shoulderBone.scale.controller
		bBone.scale.Z_Scale.controller.AddTarget "scl2" curveBone_Array[1][1].scale.controller
		bBone.scale.Z_Scale.controller.script = "((scl1.z+scl2.z)/2)"
		bBones[1] = bBone
	)
	
	a = (curveBone_Array[1][curveBone_Array[1].count].width + curveBone_Array[2][1].width)/2
	b = (curveBone_Array[1][curveBone_Array[1].count].length + curveBone_Array[2][1].length)/2
	bBone =FN_buildBox fnTarget.rootNodeHolderG[1].node (a*1.2) (b*1.2) ((a+b)/5) _blend:1
	bBone.name = fn_limb[2].node.name + "Blend"
	bBone.transform = curveBone_Array[2][1].transform
	bBone.parent = parentpoint
	bBone.pos.controller = position_Constraint ()
	bBone.pos.controller.appendTarget curveBone_Array[2][1] 100
	bBone.rotation.controller = orientation_Constraint ()
	bBone.rotation.controller.appendTarget curveBone_Array[1][curveBone_Array[1].count] 50
	bBone.rotation.controller.appendTarget curveBone_Array[2][1] 50
	
	bBone.scale.controller = ScaleXYZ ()
	bBone.scale.Y_Scale.controller = float_script ()
	bBone.scale.Y_Scale.controller.AddTarget "scl1" curveBone_Array[1][curveBone_Array[1].count].scale.controller
	bBone.scale.Y_Scale.controller.AddTarget "scl2" curveBone_Array[2][1].scale.controller
	bBone.scale.Y_Scale.controller.script = "((scl1.y+scl2.y)/2)"
	bBone.scale.Z_Scale.controller = float_script ()
	bBone.scale.Z_Scale.controller.AddTarget "scl1" curveBone_Array[1][curveBone_Array[1].count].scale.controller
	bBone.scale.Z_Scale.controller.AddTarget "scl2" curveBone_Array[2][1].scale.controller
	bBone.scale.Z_Scale.controller.script = "((scl1.z+scl2.z)/2)"
	
	bBones[2] = bBone
	
	refGuide = FN_createPoint ()
	refGuide.parent = curveBone_Array[2][curveBone_Array[2].count]
	refGuide.transform = palm_bone.transform
	
	a = (curveBone_Array[2][curveBone_Array[2].count].width + palm_bone.width)/2
	b = (curveBone_Array[2][curveBone_Array[2].count].length + palm_bone.length)/2
	bBone =FN_buildBox fnTarget.rootNodeHolderG[1].node a b ((a+b)/5) _blend:1
	bBone.name = fn_limb[3].node.name + "Blend"
	bBone.transform = curveBone_Array[2][curveBone_Array[2].count].transform
	bBone.parent = parentpoint
	bBone.pos.controller = position_Constraint ()
	bBone.pos.controller.appendTarget palm_bone 100
	bBone.rotation.controller = orientation_Constraint ()
	bBone.rotation.controller.appendTarget refGuide 50
	bBone.rotation.controller.appendTarget palm_bone 50
	
	bBone.scale.controller = ScaleXYZ ()
	bBone.scale.Y_Scale.controller = float_script ()
	bBone.scale.Y_Scale.controller.AddTarget "scl1" curveBone_Array[2][curveBone_Array[2].count].scale.controller
	bBone.scale.Y_Scale.controller.AddTarget "scl2" blendPointArray[3].scale.controller
	bBone.scale.Y_Scale.controller.script = "((scl1.y+scl2.y)/2)"
	bBone.scale.Z_Scale.controller = float_script ()
	bBone.scale.Z_Scale.controller.AddTarget "scl1" curveBone_Array[2][curveBone_Array[2].count].scale.controller
	bBone.scale.Z_Scale.controller.AddTarget "scl2" palm_bone.scale.controller
	bBone.scale.Z_Scale.controller.script = "((scl1.z+scl2.z)/2)"
		
	bBones[3] = bBone	
-- 	
	if fnTarget.legToeHolderG.count != 0 then -- create foot
	(
		setTransformLockFlags bendCtrlsArray[3] #{3,2,1}
		
		--realign attribute ctrl
		att_ctrl.pos.controller.y_position = fn_limb[3].node.length
		
		-- fk scale
-- 		fk_ctrl_array[3].mrr = false
		fk_ctrl_array[3].transform = ik_ctrl.transform
		fk_ctrl_array[3].scale.controller = ScaleXYZ ()
		paramWire.connect fk_ctrl_array[3].scale.controller[#X_Scale] fk_ctrl_array[3].scale.controller[#Y_Scale] "X_Scale"
		paramWire.connect fk_ctrl_array[3].scale.controller[#X_Scale] fk_ctrl_array[3].scale.controller[#Z_Scale] "X_Scale"
		
		
		paramWire.connect att_ctrl.modifiers[#attributes].handAttributes[#_scale] fk_ctrl_array[3].scale.controller[#X_Scale] "_scale"
		if fnTarget.nodeMirror == false do fk_ctrlChild_array[2].transform = fk_ctrl_array[2].transform
		fk_ctrlChild_array[3].transform = fk_ctrl_array[3].transform
		
		--create footik
		footIKctrl = FN_createRectangle w:(fnTarget.legToeHolderG[3].node.width*abs(fnTarget.legToeHolderG[3].node.scale.z)) l:(fnTarget.legToeHolderG[3].node.length*abs(fnTarget.legToeHolderG[3].node.scale.x))
		footIKctrl.name = fn_limb[3].node.name +"_FootIKctrl"
		footIKctrl.parent = fnTArget.legToeHolderG[3].node
		footIKctrl.transform = fnTarget.legToeHolderG[3].node.transform
		footIKctrl.rotation.controller.z_rotation -=90
		ResetTransform footIKctrl
		footIKctrl.parent = glbRoot
		footIKctrl.scale = [1,1,1]
		
		rst footIKctrl
		
		footIKctrl.scale.controller = ScaleXYZ ()
		paramWire.connect footIKctrl.scale.controller[#X_Scale] footIKctrl.scale.controller[#Y_Scale] "X_Scale"
		paramWire.connect footIKctrl.scale.controller[#X_Scale] footIKctrl.scale.controller[#Z_Scale] "X_Scale"
		
		paramWire.connect att_ctrl.modifiers[#attributes].handAttributes[#_scale] footIKctrl.scale.controller[#X_Scale] "_scale"
		
		obj = NodeTransformMonitor node:footIKctrl forwardTransformChangeMsgs:false
		append att_ctrl.modifiers[#attributes].ikAttributes.ikHolder obj
		
		--create heel ctrl
		heelCtrl = FN_createCircle (footIKctrl.width/5)
		heelCtrl.name = fn_limb[3].node.name +"_HeelCtrl"
		heelCtrl.parent = footIKctrl
		heelCtrl.transform = fnTarget.legToeHolderG[2].node.transform
		heelCtrl.scale = [1,1,1]
		heelCtrl.rotation.controller.y_rotation = -90
		ResetTransform heelCtrl
		rst heelCtrl
		
		obj = NodeTransformMonitor node:heelCtrl forwardTransformChangeMsgs:false
		append att_ctrl.modifiers[#attributes].ikAttributes.ikHolder obj
		
		--create tip ctrl
		tipCtrl = FN_createCircle (footIKctrl.width/5)
		tipCtrl.name = fn_limb[3].node.name +"_TipCtrl"
		tipCtrl.parent = fn_toe.node
		tipCtrl.transform = fn_toe.node.transform
		tipCtrl.pos.controller.x_position = fnTarget.legToeHolderG[1].node.height
-- 		
		tipCtrl.rotation.controller.y_rotation = -90
		ResetTransform tipCtrl
		tipCtrl.parent = heelCtrl
		tipCtrl.scale = [1,1,1]
		rst tipCtrl
		
		obj = NodeTransformMonitor node:tipCtrl forwardTransformChangeMsgs:false
		append att_ctrl.modifiers[#attributes].ikAttributes.ikHolder obj
		
		
		--create ankle ctrl
		ankleCtrl = FN_createNgon ((fn_toe.node.width*glbBuildSCL+fn_toe.node.length*glbBuildSCL)/2)
		ankleCtrl.name = fn_limb[3].node.name +"_AnkleCtrl"
		ankleCtrl.parent = fn_limb[3].node
		ankleCtrl.transform = fn_limb[3].node.transform
		ankleCtrl.scale = [1,1,1]
		ankleCtrl.pos.controller.x_position = fn_limb[3].node.height
		ankleCtrl.objectOffsetPos = [fn_limb[3].node.height*glbBuildSCL*-1,0,0]
		ankleCtrl.parent = tipCtrl
		rst ankleCtrl
		
		
		ankleCtrl.scale.controller = ScaleXYZ ()
		
		ankleCtrl.scale.controller.z_Scale.controller = float_script ()
		ankleCtrl.scale.controller.y_Scale.controller = float_script ()
		
		ik_ctrl.parent = ankleCtrl
		ik_ctrl.radius = 0
		
		obj = NodeTransformMonitor node:ankleCtrl forwardTransformChangeMsgs:false
		append att_ctrl.modifiers[#attributes].ikAttributes.ikHolder obj
		
			
		-- create ik toe
		toeGuidePpPoint = fn_createPoint ()
		toeGuidePpPoint.parent = ik_point_array[ik_point_array.count]
		toeGuidePpPoint.transform =  ik_point_array[ik_point_array.count].transform
		toeGuidePpPoint.scale = [1,1,1]
		toeGuidePpPoint.rotation.controller = orientation_Constraint ()
		toeGuidePpPoint.rotation.controller.appendTarget ik_ctrl 100
		
		toeGuidePpPoint.scale.controller = scale_list ()
		toeGuidePpPoint.scale.controller[1].controller = ankleCtrl.scale.controller
		toeGuidePpPoint.scale.controller.Available.controller = ScaleXYZ ()
		
		paramWire.connect toeGuidePpPoint.scale.controller[2].controller[#X_Scale] toeGuidePpPoint.scale.controller[2].controller[#Y_Scale] "X_Scale"
		paramWire.connect toeGuidePpPoint.scale.controller[2].controller[#X_Scale] toeGuidePpPoint.scale.controller[2].controller[#Z_Scale] "X_Scale"
		
		paramWire.connect att_ctrl.modifiers[#attributes].handAttributes[#_scale] toeGuidePpPoint.scale.controller[2].controller[#X_Scale] "_scale"
		
		toeGuidePPoint = fn_createPoint ()
		toeGuidePPoint.parent = toeGuidePpPoint
		toeGuidePPoint.transform = fn_toe.node.transform
			
		toeGuidePoint = fn_createPoint ()
		toeGuidePoint.parent = tipCtrl
		toeGuidePoint.transform = fn_toe.node.transform
		toeGuidePoint.scale = [1,1,1]
		toeGuidePoint.pos.controller = position_Constraint ()
		toeGuidePoint.pos.controller.appendTarget toeGuidePPoint 100
		
		ikToeCtrl = FN_createRectangle w:(fn_toe.node.width*2*glbBuildSCL) l:(fn_toe.node.length*2*glbBuildSCL)
		ikToeCtrl.name = fn_limb[3].node.name +"_IKtoeCtrl"
		ikToeCtrl.parent = toeGuidePoint
		ikToeCtrl.transform =toeGuidePoint.transform
		ikToeCtrl.scale = [1,1,1]
		rst ikToeCtrl
		
		
		ikToeCtrl.scale.controller = ScaleXYZ ()
		paramWire.connect ikToeCtrl.scale.controller[#X_Scale] ikToeCtrl.scale.controller[#Y_Scale] "X_Scale"
		paramWire.connect ikToeCtrl.scale.controller[#X_Scale] ikToeCtrl.scale.controller[#Z_Scale] "X_Scale"
		
		ikToeCtrl.pos.controller.XYZ.controller.X_Position.controller = float_script ()
		ikToeCtrl.pos.controller.XYZ.controller.Y_Position.controller = float_script ()
		ikToeCtrl.pos.controller.XYZ.controller.Z_Position.controller = float_script ()
		
		obj = NodeTransformMonitor node:ikToeCtrl forwardTransformChangeMsgs:false
		append att_ctrl.modifiers[#attributes].ikAttributes.ikHolder obj
		
		------------ fk
		--- create fk Toe
		fkToeCtrl = FN_createRectangle w:(fn_toe.node.width*2*glbBuildSCL) l:(fn_toe.node.length*2*glbBuildSCL)
		fkToeCtrl.name = fn_limb[3].node.name +"_FKtoeCtrl"
		fkToeCtrl.parent = fn_toe.node
		fkToeCtrl.transform = fn_toe.node.transform
		fkToeCtrl.scale = [1,1,1]
		fkToeCtrl.parent = fk_ctrlChild_array[3]
		fkToeCtrl.wirecolor = [255,255,0]
		rst fkToeCtrl
		
		
		fkToeCtrl.scale.controller = ScaleXYZ ()
		paramWire.connect fkToeCtrl.scale.controller[#X_Scale] fkToeCtrl.scale.controller[#Y_Scale] "X_Scale"
		paramWire.connect fkToeCtrl.scale.controller[#X_Scale] fkToeCtrl.scale.controller[#Z_Scale] "X_Scale"
		fkToeCtrl.pos.controller.XYZ.controller.Y_Position.controller = float_script ()
		fkToeCtrl.pos.controller.XYZ.controller.Z_Position.controller = float_script ()
		
		obj = NodeTransformMonitor node:fkToeCtrl forwardTransformChangeMsgs:false
		append att_ctrl.modifiers[#attributes].ikAttributes.fkHolder obj
		
		-- point parented to fk for footik ctrl match
		mP_FootIK = fn_createPoint ()
		mP_FootIK.parent = fkToeCtrl
		mP_FootIK.transform = fnTarget.legToeHolderG[3].node.transform
		mP_FootIK.scale = [1,1,1]
		
		mP_Ankle = fn_createPoint ()
		mP_Ankle.parent = fkToeCtrl
		mP_Ankle.transform = fkToeCtrl.transform
		
		mP_Ankle.rotation.controller = lookat_Constraint ()
		mP_Ankle.rotation.controller.lookat_vector_length = 0
		mP_Ankle.rotation.controller.appendTarget fk_ctrlChild_array[3] 100
		mP_Ankle.rotation.controller.target_axis = 0
		mP_Ankle.rotation.controller.upnode_axis = 2
		mP_Ankle.rotation.controller.StoUP_axis = 2
		mP_Ankle.rotation.controller.target_axisFlip = on
		
		mP_Ankle.rotation.controller.upnode_world = off
		mP_Ankle.rotation.controller.pickUpNode = fk_ctrlChild_array[3]
		mP_Ankle.rotation.controller.upnode_ctrl = 1
		mP_Ankle.rotation.controller.StoUP_axis = 2
		mP_Ankle.rotation.controller.upnode_axis = 2
	
		---------------------
		--tip blend point
		blendPoint = FN_createPoint ()
		blendPoint.parent = blendPointArray[3]
		blendPoint.transform = fkToeCtrl.transform
		blendPoint.scale = [1,1,1]
		blendPoint_rot = orientation_constraint ()
		blendPoint_rot.appendTarget ikToeCtrl 0
		blendPoint_rot.appendTarget fkToeCtrl 100
		blendPoint.rotation.controller = blendPoint_rot
		blendPoint.rotation.controller.weight[2].controller = bezier_float ()
		paramWire.connect att_ctrl.modifiers[#attributes].ikAttributes[#ikfk] blendPoint.rotation.controller[#Orientation_Weight_0] "1-ikfk"
		paramWire.connect att_ctrl.modifiers[#attributes].ikAttributes[#ikfk] blendPoint.rotation.controller[#Orientation_Weight_1] "ikfk"

		blendPoint_pos = position_constraint ()
		blendPoint_pos.appendTarget ikToeCtrl 0
		blendPoint_pos.appendTarget fkToeCtrl 100
		blendPoint.position.controller = blendPoint_pos
		blendPoint.position.controller.weight[2].controller = bezier_float ()
		paramWire.connect att_ctrl.modifiers[#attributes].ikAttributes[#ikfk] blendPoint.position.controller[#Position_Weight_0] "1-ikfk"
		paramWire.connect att_ctrl.modifiers[#attributes].ikAttributes[#ikfk] blendPoint.position.controller[#Position_Weight_1] "ikfk"
		
		blendPoint.scale.controller = scale_script ()
		blendPoint.scale.controller.addtarget "ikfk" att_ctrl.modifiers[#attributes].ikAttributes.ikfk.controller
		blendPoint.scale.controller.addtarget "fk" fkToeCtrl.scale.controller
		blendPoint.scale.controller.addtarget "ik" ikToeCtrl.scale.controller
		blendPoint.scale.controller.script = "(fk*ikfk)+ik*(1-ikfk)"
		
		
		------------
		-- create bones
		-- update palm
		palm_bone.scale.controller = ScaleXYZ ()
		palm_bone.scale.X_Scale.controller = float_script ()
		palm_bone.scale.X_Scale.controller.AddNode "p0" bendCtrlsArray[3]
		palm_bone.scale.X_Scale.controller.AddNode "p1" blendPoint
		palm_bone.scale.X_Scale.controller.AddTarget "scl" glbRoot.scale.controller
		palm_bone.scale.X_Scale.controller.AddTarget "hs" att_ctrl.modifiers[#attributes].handAttributes._scale.controller
		palm_bone.scale.X_Scale.controller.Addconstant "hgt" palm_bone.height
		palm_bone.scale.X_Scale.controller.script = "try(((distance p0 p1)/hgt)*(1/scl.x)*(1/hs))catch(0)"
		
		
		-- Toe bone
		ToeBone =(FN_buildBox fn_toe.node (fn_toe.node.width*glbBuildSCL) (fn_toe.node.length*glbBuildSCL) (fn_toe.node.height*glbBuildSCL))
		ToeBone.name = fn_toe.node.name
		ToeBone.parent = blendPoint
		ToeBone.transform = fn_toe.node.transform
		ToeBone.scale = [1,1,1]
			
		obj = NodeTransformMonitor node:fkToeCtrl forwardTransformChangeMsgs:false --13
		append att_ctrl.modifiers[#attributes].ikAttributes.matchHolder obj
			
		obj = NodeTransformMonitor node:ikToeCtrl forwardTransformChangeMsgs:false --14
		append att_ctrl.modifiers[#attributes].ikAttributes.matchHolder obj
		
		obj = NodeTransformMonitor node:footIKctrl forwardTransformChangeMsgs:false --15
		append att_ctrl.modifiers[#attributes].ikAttributes.matchHolder obj
			
		obj = NodeTransformMonitor node:mP_FootIK forwardTransformChangeMsgs:false --16
		append att_ctrl.modifiers[#attributes].ikAttributes.matchHolder obj
		
		obj = NodeTransformMonitor node:heelCtrl forwardTransformChangeMsgs:false --17
		append att_ctrl.modifiers[#attributes].ikAttributes.matchHolder obj
			
		obj = NodeTransformMonitor node:tipCtrl forwardTransformChangeMsgs:false --18
		append att_ctrl.modifiers[#attributes].ikAttributes.matchHolder obj
		
		obj = NodeTransformMonitor node:ankleCtrl forwardTransformChangeMsgs:false --19
		append att_ctrl.modifiers[#attributes].ikAttributes.matchHolder obj
		
		obj = NodeTransformMonitor node:mP_Ankle forwardTransformChangeMsgs:false --20
		append att_ctrl.modifiers[#attributes].ikAttributes.matchHolder obj
		
		obj = NodeTransformMonitor node:palm_bone forwardTransformChangeMsgs:false --21
		append att_ctrl.modifiers[#attributes].ikAttributes.matchHolder obj
		
		obj = NodeTransformMonitor node:glbRoot forwardTransformChangeMsgs:false --22
		append att_ctrl.modifiers[#attributes].ikAttributes.matchHolder obj

	)
	
	fingerModules = #()
	fingerCtrls = #()
	if fn_limb[3].node.moduleFingerHolderG.count != 0 do
	(
		for f in fn_limb[3].node.moduleFingerHolderG do
		(
			-- create finger controllers
			parentPoint = FN_createPoint () -- scale'den etkilenmesin diye roota parentlanan alt parent
			parentPoint.parent = palm_bone
			if fnTarget.legToeHolderG.count != 0 do parentPoint.parent = ToeBone
			parentPoint.transform = f.node.fingerBoneHolderG[1].node.transform
			parentPoint.scale = [1,1,1]
			rst parentPoint
			
			tempParent = parentPoint
			
			baseCtrl = FN_createAsterix ((f.node.fingerBoneHolderG[1].node.width*glbBuildSCL + f.node.fingerBoneHolderG[1].node.length*glbBuildSCL)/4)
			baseCtrl.name = f.node.fingerBoneHolderG[1].node.name +"MainCtrl"
			baseCtrl.transform = parentPoint.transform
			baseCtrl.parent =parentPoint
			baseCtrl.pos.controller.y_position = f.node.fingerBoneHolderG[1].node.length*glbBuildSCL*2
			rst baseCtrl
			
-- 			baseCtrl.pos.controller.available.controller = position_script ()
-- 			baseCtrl.pos.controller.setActive 3
			baseCtrl.scale.controller = ScaleXYZ ()
			deletemodifier baseCtrl baseCtrl.modifiers[#attributes]
			addModifier baseCtrl (EmptyModifier ()) 
			baseCtrl.modifiers[#attribute_holder].name = "attributes"
			FN_reset baseCtrl
			FN_fingerAttributes baseCtrl (f.node.fingerBoneHolderG.count)
			
			setTransformLockFlags baseCtrl #{1,2,3,7,8,9}
			
			fingerCtrlArray = #()	
			for i = 1 to f.node.fingerBoneHolderG.count do
			(

				_pin = FN_createPin f.node.fingerBoneHolderG[i].node.pos (f.node.fingerBoneHolderG[i].node.pos + [0,f.node.fingerBoneHolderG[i].node.length*glbBuildSCL*2,0])
				_pin.isFinger = true
				_pin.parent = tempParent
				_pin.transform = f.node.fingerBoneHolderG[i].node.transform
				_pin.scale = [1,1,1]
				rst _pin
				_pin.name = f.node.fingerBoneHolderG[i].node.name +"Ctrl"
				
				_pin.scale.controller = ScaleXYZ ()
				paramWire.connect _pin.scale.controller[#X_Scale] _pin.scale.controller[#Y_Scale] "X_Scale"
				paramWire.connect _pin.scale.controller[#X_Scale] _pin.scale.controller[#Z_Scale] "X_Scale"
				
				baseCtrl.modifiers[#attributes].fingerAttributes.squash.controller = bezier_float ()
-- 				if i != 1 do
-- 				(
					_str = baseCtrl.modifiers[#attributes].fingerAttributes[execute("#knuckle_"+(i as string))].controller = bezier_float ()

					
					_pin.rotation.controller.XYZ.controller.X_Rotation.controller = float_script ()
					_pin.rotation.controller.XYZ.controller.X_Rotation.controller.AddTarget  "ref" baseCtrl.rotation.controller.XYZ.controller.X_Rotation.controller
					_pin.rotation.controller.XYZ.controller.X_Rotation.controller.AddTarget "mlt" _str
					_pin.rotation.controller.XYZ.controller.X_Rotation.controller.script = "(degtorad ref)*mlt"
					
					_pin.rotation.controller.XYZ.controller.Y_Rotation.controller = float_script ()
					_pin.rotation.controller.XYZ.controller.Y_Rotation.controller.AddTarget  "ref" baseCtrl.rotation.controller.XYZ.controller.Y_Rotation.controller
					_pin.rotation.controller.XYZ.controller.Y_Rotation.controller.AddTarget "mlt" _str
					_pin.rotation.controller.XYZ.controller.Y_Rotation.controller.script = "(degtorad ref)*mlt"
					
					_pin.rotation.controller.XYZ.controller.Z_Rotation.controller = float_script ()
					_pin.rotation.controller.XYZ.controller.Z_Rotation.controller.AddTarget  "ref" baseCtrl.rotation.controller.XYZ.controller.Z_Rotation.controller
					_pin.rotation.controller.XYZ.controller.Z_Rotation.controller.AddTarget "mlt" _str
					_pin.rotation.controller.XYZ.controller.Z_Rotation.controller.script = "(degtorad ref)*mlt"
					
					_pin.rotation.controller.Available.controller = Euler_XYZ ()
					_pin.rotation.controller.SetActive 3
-- 				)
				
				tempParent = _pin
				
				append fingerCtrlArray _pin
			)
			

			fingerTipCtrl = FN_createAsterix (((f.node.fingerBoneHolderG[f.node.fingerBoneHolderG.count].node.width*glbBuildSCL)+(f.node.fingerBoneHolderG[f.node.fingerBoneHolderG.count].node.length*glbBuildSCL))*.2)
			fingerTipCtrl.name = f.node.fingerBoneHolderG[f.node.fingerBoneHolderG.count].node.name +"TipCtrl"
			fingerTipCtrl.parent = fingerCtrlArray[fingerCtrlArray.count]
			fingerTipCtrl.transform = fingerCtrlArray[fingerCtrlArray.count].transform
			fingerTipCtrl.scale = [1,1,1]
			fingerTipCtrl.pos.controller.x_position = (f.node.fingerBoneHolderG[f.node.fingerBoneHolderG.count].node.height*glbBuildSCL)
			rst fingerTipCtrl
			fingerTipCtrl.scale.controller = scalexyz()
			append fingerCtrlArray fingerTipCtrl
			
			baseCtrl.parent = fingerCtrlArray[1]
		
			fingerBones = #()
			for t = 1 to (fingerCtrlArray.count-1) do
			(
				oldPoint = fingerCtrlArray[t]
				p1 = fingerCtrlArray[t+1]
				
				sb =(FN_buildBox f.node.fingerBoneHolderG[t].node (f.node.fingerBoneHolderG[t].node.width*glbBuildSCL) (f.node.fingerBoneHolderG[t].node.length*glbBuildSCL) (f.node.fingerBoneHolderG[t].node.height*glbBuildSCL))
				sb.name = f.node.fingerBoneHolderG[t].node.name
				sb.parent = fingerCtrlArray[1]
				sb.pos.controller = position_Constraint ()
				sb.pos.controller.appendTarget oldPoint 100
				sb.rotation.controller = lookat_Constraint ()
				sb.rotation.controller.target_axis = 0
				sb.rotation.controller.lookat_vector_length = 0
				sb.rotation.controller.upnode_ctrl = 1
				sb.rotation.controller.StoUP_axis = 2
				sb.rotation.controller.upnode_axis = 2
				sb.rotation.controller.pickUpNode = oldPoint
				sb.rotation.controller.upnode_world = off
				sb.rotation.controller.appendTarget p1 100
				sb.height = (distance oldPoint p1)/glbRoot.scale.x
				sb.scale.controller = ScaleXYZ ()
				sb.scale.X_Scale.controller = float_script ()
				sb.scale.X_Scale.controller.AddNode "p0" oldPoint
				sb.scale.X_Scale.controller.AddNode "p1" p1
				sb.scale.X_Scale.controller.AddTarget "scl" glbRoot.scale.controller
				sb.scale.X_Scale.controller.AddTarget "sclP" blendPointArray[3].scale.controller
				sb.scale.X_Scale.controller.AddTarget "sclF" fingerCtrlArray[1].scale.controller
				sb.scale.X_Scale.controller.Addconstant "hgt" sb.height
				if fnTarget.legToeHolderG.count != 0 then 
				(
					sb.scale.X_Scale.controller.AddTarget "sclT" blendPoint.scale.controller
					sb.scale.X_Scale.controller.script = "try(((distance p0 p1)/hgt)*(1/scl.x)*(1/sclP.x)*(1/sclF.x)*(1/sclT.x))catch(0)"
				)
				else
				(
					sb.scale.X_Scale.controller.script = "try(((distance p0 p1)/hgt)*(1/scl.x)*(1/sclP.x)*(1/sclF.x))catch(0)"
				)
				sb.scale.controller.Y_Scale.controller = float_list ()
				sb.scale.controller.Y_Scale.controller.Bezier_Float.controller = float_script ()
				sb.scale.controller.Y_Scale.controller.Available.controller = float_script ()
				sb.scale.controller.Y_Scale.controller.weight[1].controller = float_script ()
				sb.scale.controller.Y_Scale.controller.weight[2].controller = float_script ()
				sb.scale.controller.Y_Scale.controller[1].controller.AddNode "p0" oldPoint
				sb.scale.controller.Y_Scale.controller[1].controller.AddNode "p1" p1
				sb.scale.controller.Y_Scale.controller[1].controller.AddTarget "scl" glbRoot.scale.controller
				sb.scale.controller.Y_Scale.controller[1].controller.Addconstant "hgt" sb.height
				sb.scale.controller.Y_Scale.controller[1].controller.script = "try((1/(((distance p0 p1)/hgt)))*scl.x)catch(0)"
				sb.scale.controller.Y_Scale.controller[2].controller.script ="1"
				sb.scale.controller.Y_Scale.controller.weight[1].controller.AddTarget "mlt" baseCtrl.modifiers[#attributes].fingerAttributes[#squash].controller
				sb.scale.controller.Y_Scale.controller.weight[1].controller.script = "mlt"
				sb.scale.controller.Y_Scale.controller.weight[2].controller.AddTarget "mlt" baseCtrl.modifiers[#attributes].fingerAttributes[#squash].controller
				sb.scale.controller.Y_Scale.controller.weight[2].controller.script = "1-mlt"
				sb.scale.controller.Z_Scale.controller = float_list ()
				sb.scale.controller.Z_Scale.controller.Bezier_Float.controller = float_script ()
				sb.scale.controller.Z_Scale.controller.Available.controller = float_script ()
				sb.scale.controller.Z_Scale.controller.weight[1].controller = float_script ()
				sb.scale.controller.Z_Scale.controller.weight[2].controller = float_script ()
				sb.scale.controller.Z_Scale.controller[1].controller.AddNode "p0" oldPoint
				sb.scale.controller.Z_Scale.controller[1].controller.AddNode "p1" p1
				sb.scale.controller.Z_Scale.controller[1].controller.AddTarget "scl" glbRoot.scale.controller
				sb.scale.controller.Z_Scale.controller[1].controller.Addconstant "hgt" sb.height
				sb.scale.controller.Z_Scale.controller[1].controller.script = "try((1/(((distance p0 p1)/hgt)))*scl.z)catch(0)"
				sb.scale.controller.Z_Scale.controller[2].controller.script ="1"
				sb.scale.controller.Z_Scale.controller.weight[1].controller.AddTarget "mlt" baseCtrl.modifiers[#attributes].fingerAttributes[#squash].controller
				sb.scale.controller.Z_Scale.controller.weight[1].controller.script = "mlt"
				sb.scale.controller.Z_Scale.controller.weight[2].controller.AddTarget "mlt" baseCtrl.modifiers[#attributes].fingerAttributes[#squash].controller
				sb.scale.controller.Z_Scale.controller.weight[2].controller.script = "1-mlt"
				append fingerBones sb
			)
			append fingerModules fingerBones
			
			for i=1 to fingerCtrlArray.count-1 do
			(
				fingerCtrlArray[i]._overlapDist[1] = fingerBones[i].height
				fingerCtrlArray[i]._overlapDist[2] = fingerBones[i].width
			)
			insertItem baseCtrl fingerCtrlArray 1
			append fingerCtrls fingerCtrlArray
		)
	)
	
	att_ctrl.parent = palm_bone
	rst att_ctrl
	setTransformLockFlags att_ctrl #{1,2,3,4,5,6,7,8,9}
-- 	att_ctrl.scale.controller = scale_script ()
-- 	att_ctrl.pos.controller.XYZ.controller = position_script ()
-- 	att_ctrl.rotation.controller.XYZ.controller = rotation_script ()
	
	free fn_limb
	
	--add parameters
	obj = NodeTransformMonitor node:att_ctrl.parent forwardTransformChangeMsgs:false
	att_ctrl.prnt = obj
	att_ctrl.m3a = (att_ctrl.transform*(inverse att_ctrl.parent.transform))
		
	att_ctrl._type = 4
	if fnTarget.legToeHolderG.count != 0 do att_ctrl._type = 5
	att_ctrl.isAttCtrl = true
	att_ctrl._name = fnTarget.modulNameHolder
	obj = NodeTransformMonitor node:att_ctrl forwardTransformChangeMsgs:false
	append fnParent.moduleCtrl.node.childModules obj
	obj = NodeTransformMonitor node:att_ctrl forwardTransformChangeMsgs:false
	att_ctrl.currentModuleCtrl = obj
	obj = NodeTransformMonitor node:att_ctrl forwardTransformChangeMsgs:false
	append att_ctrl.ikCtrls obj

	obj = NodeTransformMonitor node:shoulder_ctrl.parent forwardTransformChangeMsgs:false
	shoulder_ctrl.prnt = obj
	shoulder_ctrl.m3a = (shoulder_ctrl.transform*(inverse shoulder_ctrl.parent.transform))
		
	obj = NodeTransformMonitor node:shoulder_ctrl forwardTransformChangeMsgs:false
	att_ctrl.shoulderCtrl = obj
	obj = NodeTransformMonitor node:att_ctrl forwardTransformChangeMsgs:false
	shoulder_ctrl.currentModuleCtrl = obj
	
	shoulder_ctrl.mrrAxis = #("z","xyz")

	
	if fn_collar != undefined do
	(
		obj = NodeTransformMonitor node:shoulderBone forwardTransformChangeMsgs:false
		append fnParent.childG obj
		obj = NodeTransformMonitor node:att_ctrl forwardTransformChangeMsgs:false
		shoulderBone.moduleCtrl = obj
		
		bBones[1].bone_attributes.isBlendBone = true
		obj = NodeTransformMonitor node:bBones[1] forwardTransformChangeMsgs:false
		append shoulderBone.childG obj
		
		shoulder_ctrl._overlapDist[1] = shoulderBone.height
		shoulder_ctrl._overlapDist[2] = shoulderBone.width
	)
	
	for f = 1 to fk_ctrl_array.count do
	(
		if f == 1 do 
		(
			fk_ctrl_array[f]._overlapDist[1] = armTwistBones[1].height
			fk_ctrl_array[f]._overlapDist[2] = armTwistBones[1].width
			fk_ctrl_array[f].mrrAxis = #("z","no")
		)
		if f==2 do
		(
		fk_ctrl_array[f]._overlapDist[1] = armTwistBones[2].height
		fk_ctrl_array[f]._overlapDist[2] = armTwistBones[2].width
		fk_ctrl_array[f].mrrAxis = #("xyz","no")
		)
		
		if f == 3 do
		(
			if fn_toe != undefined then 
			(
				fk_ctrl_array[f]._overlapDist[1] = ToeBone.height
				fk_ctrl_array[f]._overlapDist[2] = ToeBone.width
				fk_ctrl_array[f].mrrAxis = #("xyz","z")
				
				footIKctrl._overlapDist[1] = ToeBone.height
				footIKctrl._overlapDist[2] = ToeBone.width
			)
			else
			(
				fk_ctrl_array[f]._overlapDist[1] = palm_bone.height
				fk_ctrl_array[f]._overlapDist[2] = palm_bone.width
				fk_ctrl_array[f].mrrAxis = #("xyz","no")
				
				IK_ctrl._overlapDist[1] = palm_bone.height
				IK_ctrl._overlapDist[2] = palm_bone.width
			)
		)
		
		obj = NodeTransformMonitor node:fk_ctrl_array[f].parent forwardTransformChangeMsgs:false
		fk_ctrl_array[f].prnt =obj
		fk_ctrl_array[f].m3a =(fk_ctrl_array[f].transform*(inverse fk_ctrl_array[f].parent.transform))
			
		obj = NodeTransformMonitor node:fk_ctrl_array[f] forwardTransformChangeMsgs:false
		append att_ctrl.fkCtrls obj
		obj = NodeTransformMonitor node:att_ctrl forwardTransformChangeMsgs:false
		fk_ctrl_array[f].currentModuleCtrl = obj
	)
	
	-- iks
	if fnTarget.legToeHolderG.count != 0 then
	(
		mrrPlane = FN_createPoint()
		mrrPlane.pos = fnParent.parent.parent.pos + [0,0,-5]
		mrrPlane.rotation.controller = lookat_Constraint ()
		mrrPlane.rotation.controller.lookat_vector_length = 0
		mrrPlane.rotation.controller.target_axis = 0
		mrrPlane.rotation.controller.upnode_axis = 2
		mrrPlane.rotation.controller.StoUP_axis = 2
		mrrPlane.rotation.controller.upnode_world = off
		mrrPlane.rotation.controller.pickUpNode = fnParent.parent.parent
		mrrPlane.rotation.controller.appendTarget fnParent.parent.parent 100;
		
		mrrP = FN_createPoint()
		mrrP.transform = mrrPlane.transform
		mrrP.scale = fnParent.parent.parent.scale
		delete mrrPlane
		mrrP.pos.z += 5
		
		--foot ik
		obj = NodeTransformMonitor node:fnParent.parent.parent forwardTransformChangeMsgs:false
		footIKctrl.prnt =obj
		footIKctrl.m3a =(footIKctrl.transform*(inverse mrrP.transform))
		obj = NodeTransformMonitor node:footIKctrl forwardTransformChangeMsgs:false
		append att_ctrl.ikCtrls obj
		obj = NodeTransformMonitor node:att_ctrl forwardTransformChangeMsgs:false
		footIKctrl.currentModuleCtrl = obj
			
		footIKctrl.isIK = true
		footIKctrl.isFoot = true
		---------
			
		--heelCtrl
		obj = NodeTransformMonitor node:heelCtrl.parent forwardTransformChangeMsgs:false
		heelCtrl.prnt =obj
		heelCtrl.m3a =(heelCtrl.transform*(inverse heelCtrl.parent.transform))
		obj = NodeTransformMonitor node:heelCtrl forwardTransformChangeMsgs:false
		append att_ctrl.ikCtrls obj
		obj = NodeTransformMonitor node:att_ctrl forwardTransformChangeMsgs:false
		heelCtrl.currentModuleCtrl = obj
		---------
		
		--tipCtrl
		obj = NodeTransformMonitor node:tipCtrl.parent forwardTransformChangeMsgs:false
		tipCtrl.prnt =obj
		tipCtrl.m3a =(tipCtrl.transform*(inverse tipCtrl.parent.transform))
		obj = NodeTransformMonitor node:tipCtrl forwardTransformChangeMsgs:false
		append att_ctrl.ikCtrls obj
		obj = NodeTransformMonitor node:att_ctrl forwardTransformChangeMsgs:false
		tipCtrl.currentModuleCtrl = obj
		---------
			
		--ankleCtrl
		obj = NodeTransformMonitor node:ankleCtrl.parent forwardTransformChangeMsgs:false
		ankleCtrl.prnt = obj
		ankleCtrl.m3a = (ankleCtrl.transform*(inverse ankleCtrl.parent.transform))
		obj = NodeTransformMonitor node:ankleCtrl forwardTransformChangeMsgs:false
		append att_ctrl.ikCtrls obj
		obj = NodeTransformMonitor node:att_ctrl forwardTransformChangeMsgs:false
		ankleCtrl.currentModuleCtrl = obj
		---------
			
		--ikToeCtrl
		obj = NodeTransformMonitor node:ikToeCtrl.parent forwardTransformChangeMsgs:false
		ikToeCtrl.prnt =obj
		ikToeCtrl.m3a =(ikToeCtrl.transform*(inverse ikToeCtrl.parent.transform))
		obj = NodeTransformMonitor node:ikToeCtrl forwardTransformChangeMsgs:false
		append att_ctrl.ikCtrls obj
		obj = NodeTransformMonitor node:att_ctrl forwardTransformChangeMsgs:false
		ikToeCtrl.currentModuleCtrl = obj
		---------
			
		--fkToeCtrl
		obj = NodeTransformMonitor node:fkToeCtrl.parent forwardTransformChangeMsgs:false
		fkToeCtrl.prnt =obj
		fkToeCtrl.m3a =(fkToeCtrl.transform*(inverse fkToeCtrl.parent.transform))
		obj = NodeTransformMonitor node:fkToeCtrl forwardTransformChangeMsgs:false
		append att_ctrl.fkCtrls obj
		obj = NodeTransformMonitor node:att_ctrl forwardTransformChangeMsgs:false
		fkToeCtrl.currentModuleCtrl = obj
-- 		fkToeCtrl.mrrAxis = #("z","no")
		---------
			
		obj = NodeTransformMonitor node:ik_ctrl.parent forwardTransformChangeMsgs:false
		ik_ctrl.prnt =obj
		ik_ctrl.m3a =(ik_ctrl.transform*(inverse ik_ctrl.parent.transform))
		
		obj = NodeTransformMonitor node:ik_ctrl forwardTransformChangeMsgs:false
		append att_ctrl.ikCtrls obj
		obj = NodeTransformMonitor node:att_ctrl forwardTransformChangeMsgs:false
		ik_ctrl.currentModuleCtrl = obj
			
		obj = NodeTransformMonitor node:fnParent.parent.parent forwardTransformChangeMsgs:false
		ik_pole_ctrl.prnt = obj
		ik_pole_ctrl.m3a = (ik_pole_ctrl.transform*(inverse mrrP.transform))
		
		delete mrrP

		obj = NodeTransformMonitor node:ik_pole_ctrl forwardTransformChangeMsgs:false
		append att_ctrl.ikCtrls obj
		obj = NodeTransformMonitor node:att_ctrl forwardTransformChangeMsgs:false
		ik_pole_ctrl.currentModuleCtrl = obj
		
		ik_pole_ctrl.isIK = true
		ik_pole_ctrl.isFoot = true
			
		att_ctrl.modifiers[#attributes].ikAttributes.Params.fkhide.pressed()
	)
	else
	(
		obj = NodeTransformMonitor node:fnParent forwardTransformChangeMsgs:false
		ik_ctrl.prnt =obj
		ik_ctrl.m3a =(ik_ctrl.transform*(inverse fnParent.transform))
		
		obj = NodeTransformMonitor node:ik_ctrl forwardTransformChangeMsgs:false
		append att_ctrl.ikCtrls obj
		obj = NodeTransformMonitor node:att_ctrl forwardTransformChangeMsgs:false
		ik_ctrl.currentModuleCtrl = obj
		
		ik_ctrl.isIK = true
			
		obj = NodeTransformMonitor node:fnParent forwardTransformChangeMsgs:false
		ik_pole_ctrl.prnt = obj
		ik_pole_ctrl.m3a = (ik_pole_ctrl.transform*(inverse fnParent.transform))

		obj = NodeTransformMonitor node:ik_pole_ctrl forwardTransformChangeMsgs:false
		append att_ctrl.ikCtrls obj
		obj = NodeTransformMonitor node:att_ctrl forwardTransformChangeMsgs:false
		ik_pole_ctrl.currentModuleCtrl = obj
		
		ik_pole_ctrl.isIK = true
			
		att_ctrl.modifiers[#attributes].ikAttributes.Params.ikhide.pressed()
	)
	

	---blends
	for i =1 to bendCtrlsArray.count do
	(
		obj = NodeTransformMonitor node:bendCtrlsArray[i].parent forwardTransformChangeMsgs:false
		bendCtrlsArray[i].prnt =obj
		bendCtrlsArray[i].m3a =(bendCtrlsArray[i].transform*(inverse bendCtrlsArray[i].parent.transform))
		obj = NodeTransformMonitor node:bendCtrlsArray[i] forwardTransformChangeMsgs:false
		append att_ctrl.blendCtrls obj
		obj = NodeTransformMonitor node:att_ctrl forwardTransformChangeMsgs:false
		bendCtrlsArray[i].currentModuleCtrl = obj
	)
	---Bends
	for i =1 to curveCtrls_Array.count do
	(
		obj = NodeTransformMonitor node:curveCtrls_Array[i].parent forwardTransformChangeMsgs:false
		curveCtrls_Array[i].prnt =obj
		curveCtrls_Array[i].m3a =(curveCtrls_Array[i].transform*(inverse curveCtrls_Array[i].parent.transform))
		obj = NodeTransformMonitor node:curveCtrls_Array[i] forwardTransformChangeMsgs:false
		append att_ctrl.bendCtrls obj
		obj = NodeTransformMonitor node:att_ctrl forwardTransformChangeMsgs:false
		curveCtrls_Array[i].currentModuleCtrl = obj
	)
	
	--fingers
	for i in fingerCtrls do
	(
		append att_ctrl.fingerLists i.count
		for f in i do
		(
			obj = NodeTransformMonitor node:f.parent forwardTransformChangeMsgs:false
			f.prnt =obj
			f.m3a =(f.transform*(inverse f.parent.transform))
			obj = NodeTransformMonitor node:f forwardTransformChangeMsgs:false
			append att_ctrl.fingerCtrls obj
			obj = NodeTransformMonitor node:att_ctrl forwardTransformChangeMsgs:false
			f.currentModuleCtrl = obj
		)
	)
-----------------------------------------------
	
	for i = 1 to curveBone_Array[1].count do
	(
		obj = NodeTransformMonitor node:att_ctrl forwardTransformChangeMsgs:false
		curveBone_Array[1][i].moduleCtrl = obj
		if fn_collar != undefined then
		(
			if i == 1 then
			(
				obj = NodeTransformMonitor node:curveBone_Array[1][i] forwardTransformChangeMsgs:false
				append shoulderBone.childG obj
			)
			else
			(
				obj = NodeTransformMonitor node:curveBone_Array[1][i] forwardTransformChangeMsgs:false
				append curveBone_Array[1][i-1].childG obj
			)
		)
		else
		(
			if i == 1 then
			(
				obj = NodeTransformMonitor node:curveBone_Array[1][i] forwardTransformChangeMsgs:false
				append fnParent.childG obj
			)
			else
			(
				obj = NodeTransformMonitor node:curveBone_Array[1][i] forwardTransformChangeMsgs:false
				append curveBone_Array[1][i-1].childG obj
			)
		)
	)
	
	bBones[2].bone_attributes.isBlendBone = true
	obj = NodeTransformMonitor node:bBones[2] forwardTransformChangeMsgs:false
	append curveBone_Array[1][curveBone_Array[1].count].childG obj

	
	for i = 1 to curveBone_Array[2].count do
	(
		obj = NodeTransformMonitor node:att_ctrl forwardTransformChangeMsgs:false
		curveBone_Array[2][i].moduleCtrl = obj
		if i == 1 then
		(
			obj = NodeTransformMonitor node:curveBone_Array[2][i] forwardTransformChangeMsgs:false
			append curveBone_Array[1][curveBone_Array[1].count].childG obj
		)
		else
		(
			obj = NodeTransformMonitor node:curveBone_Array[2][i] forwardTransformChangeMsgs:false
			append curveBone_Array[2][i-1].childG obj
		)
	)
	
	bBones[3].bone_attributes.isBlendBone = true
	obj = NodeTransformMonitor node:bBones[3] forwardTransformChangeMsgs:false
	append curveBone_Array[2][curveBone_Array[2].count].childG obj
	
	obj = NodeTransformMonitor node:palm_bone forwardTransformChangeMsgs:false
	append curveBone_Array[2][curveBone_Array[2].count].childG obj
	obj = NodeTransformMonitor node:att_ctrl forwardTransformChangeMsgs:false
	palm_bone.moduleCtrl = obj
	
	if fn_toe != undefined do
	(
		obj = NodeTransformMonitor node:ToeBone forwardTransformChangeMsgs:false
		append palm_bone.childG obj
		obj = NodeTransformMonitor node:att_ctrl forwardTransformChangeMsgs:false
		ToeBone.moduleCtrl = obj
	)
	
	for i in fingerModules do
	(
		for f = 1 to i.count do
		(
			obj = NodeTransformMonitor node:att_ctrl forwardTransformChangeMsgs:false
			i[f].moduleCtrl = obj
			if f == 1 then
			(
				obj = NodeTransformMonitor node:i[f] forwardTransformChangeMsgs:false
				if fn_toe == undefined then
					append palm_bone.childG obj
				else
					append ToeBone.childG obj
			)
			else
			(
				obj = NodeTransformMonitor node:i[f] forwardTransformChangeMsgs:false
				append i[f-1].childG obj
			)
		)
	)
	
	hand = #(palm_bone)
	collar = #()
	toes = #()
	if fn_collar != undefined do append collar shoulderbone
	if fn_toe != undefined do append toes ToeBone
		
	att_ctrl.modifiers[#attributes].ikAttributes.Params.strhide.pressed()
	
	limbs = #(curveBone_Array[1], curveBone_Array[2], hand, collar, toes, fingerModules)
	
	limbs
)

-- Build Spine

fn FN_spineAttributes fn_target=
(
	curve_ca = attributes spineAttributes 
	(
		Parameters main rollout:params
		(
			cPos Type:#boolean UI:cPos Default:false
			cOrient Type:#float UI:cOrient Default:0
			cOrientPivot Type:#float UI:cOrientPivot Default:0
			_tanh Type:#float UI:_tanh Default:.5
			boneCount Type:#integer Default:0
			consWeight Type:#float Default:0
			squash Type:#float UI:squash Default:0.0
			constant Type:#boolean UI:constant Default:true
			tanHolder type:#maxObjectTab tabSize:0 tabSizeVariable:true
			constantHolder type:#maxObjectTab tabSize:0 tabSizeVariable:true
			cPosHolder type:#maxObjectTab tabSize:0 tabSizeVariable:true
			midCtrlsHolder type:#maxObjectTab tabSize:0 tabSizeVariable:true
		)
		Rollout Params "Spine Attributes"
		(
			hyperLink irig  "Need Help?" align:#right color:[255,255,255] hoverColor:[255,130,0] address:"http://docs.instantrig.com/rst/animation/sub/modules/spineatts.html#spine-attributes"
			Group "Chest"
			(
				checkbutton cPos "Free Move" Width:133 Height:25 Align:#Center Offset:[0,0]
				spinner cOrient "Rot. Abs/Rel" align:#right range:[0,1,0] Type:#float
				spinner cOrientPivot "Pivot Abs/Rel" align:#right range:[0,1,0] Type:#float
				button fintune "Fine Tune Controls" Width:133 Height:25 Align:#Center Offset:[0,0]
			)
			Group "Attributes"
			(
				spinner _tanh "Curve Weight" align:#right range:[0,1,.5] Type:#float
				spinner Squash "Squash" align:#right range:[0,1,0] Type:#float
				checkbox constant "Constant Space" Align:#right checked:true
			)
			on params open do
			(
				if cPos.state then
				(
					cOrient.enabled = false
					cOrientPivot.enabled = false
				)
					
				else 
				(
					cOrient.enabled = true
					cOrientPivot.enabled = true
				)
			)
			on fintune pressed do
			(
				undo on
					(
						a = midCtrlsHolder[1].node
						hidden = a.isNodeHidden
						print hidden
						for i = 1 to (midCtrlsHolder.count) do
						(
							a = midCtrlsHolder[i].node
							a.isNodeHidden = not hidden
						)	
					)
			)
			on cPos changed state do
			(
				if state then
				(
					cPosHolder[1].node.pos.controller.weight[2] = 0
					cPosHolder[1].node.rotation.controller.weight[2] = 0
					
					cOrient.enabled = false
					cOrientPivot.enabled = false
				)
					
				else 
				(
					cPosHolder[1].node.pos.controller.weight[2] = 100
					cPosHolder[1].node.rotation.controller.weight[2] = 100
					
					cOrient.enabled = true
					cOrientPivot.enabled = true
				)
			)
			
			on _tanh changed val do
			(
				for i = 2 to (tanHolder.count-1) do
				(
				_node = tanHolder[i].node
				consWeight =  100*((tanh(((_tanh.value*400)/boneCount)*(i-1)-((_tanh.value*400)/2))+1)/2)
				_node.pos.controller.Position_Constraint.controller.weight[1] = consWeight
				_node.pos.controller.Position_Constraint.controller.weight[2] = 100 - consWeight
				_node.rotation.controller.Orientation_Constraint.controller.weight[1] = consWeight
				_node.rotation.controller.Orientation_Constraint.controller.weight[2] = 100 - consWeight
				
				)
			)
			on constant changed state do
			(
				if state then
				(
					for i in constantHolder do
					(
						i.node.pos.controller.constantVel = on
					)
				)
					
				else 
				(
					for i in constantHolder do
					(
						i.node.pos.controller.constantVel = off
					)
				)
			)
		)
	)
	Custattributes.add fn_target.modifiers[#attributes] curve_ca
)
fn FN_buildSpine fnTarget fnParent=
(
	chestBoneG = fnTarget.chestHolderG[1].node
	spineBonesG = #()
	spineLength = 0
	for i = 1 to fnTarget.spineHolderG.count do
	(
		append spineBonesG fnTarget.spineHolderG[i].node
		spineLength += fnTarget.spineHolderG[i].node.height*glbBuildSCL
	)
	append spineBonesG chestBoneG
	
	pntAbsRel = FN_createPoint ()
	pntAbsRel.parent = chestBoneG
	pntAbsRel.transform = spineBonesG[1].transform
	pparent = glbHubCtrl
	if fnTarget.parentHolderG[1].node.hubCheck==false do pparent = fnParent
	pntAbsRel.parent = pparent
	pntAbsRel.scale = [1,1,1]
-- 	pntAbsRel.parent = glbRoot
	rst pntAbsRel
	
-- 	pntAbsRel.pos.controller[2].controller = Position_Constraint ()
-- 	pntAbsRel.pos.controller[2].controller.appendTarget pparent 100
-- 	pntAbsRel.pos.controller[2].controller.RELATIVE = on
	
	pntAbsRel.rotation.controller[2].controller = Orientation_Constraint ()
	pntAbsRel.rotation.controller[2].controller.appendTarget glbroot 100
	pntAbsRel.rotation.controller[2].controller.RELATIVE = on
		
	
	--- hub parented oriantaion from parent point
	pvtparentPoint01 = FN_createPoint ()
	pvtparentPoint01.parent = pntAbsRel
	pvtparentPoint01.transform = pntAbsRel.transform
	pvtparentPoint01.scale = [1,1,1]
-- 	preparentPoint01.pos.controller.x_position = (fnParent.height/2)
-- 	if fnTarget.parentHolderG[1].node.hubCheck==false do preparentPoint01.pos.controller.x_position = (fnParent.height)
	rst pvtparentPoint01
	
	pvtparentPoint02 = FN_createPoint ()
	pvtparentPoint02.parent = pntAbsRel
	pvtparentPoint02.transform = pntAbsRel.transform
	pvtparentPoint02.scale = [1,1,1]
-- 	preparentPoint02.pos.controller.x_position = (fnParent.height/2)
-- 	if fnTarget.parentHolderG[1].node.hubCheck==false do preparentPoint02.pos.controller.x_position = (fnParent.height)
	rst pvtparentPoint02
	
	pvtparentPoint = FN_createPoint ()
	pvtparentPoint.parent = pvtparentPoint01
	pvtparentPoint.transform = pvtparentPoint01.transform
	pvtparentPoint.scale = [1,1,1]
	rst pvtparentPoint
	
	pvtparentPoint.rotation.controller[2].controller = Orientation_Constraint ()
	pvtparentPoint.rotation.controller[2].controller.appendTarget pvtparentPoint01 0
	pvtparentPoint.rotation.controller[2].controller.appendTarget pvtparentPoint02 100
	
	
	parentPoint = FN_createPoint ()
	parentPoint.parent = pvtparentPoint
	parentPoint.transform = pvtparentPoint.transform
	parentPoint.scale = [1,1,1]
	parentPoint.parent = glbroot
	rst parentPoint
	
	parentPoint.pos.controller[2].controller = Position_Constraint ()
	parentPoint.pos.controller[2].controller.appendTarget pvtparentPoint 100
	parentPoint.pos.controller[2].controller.RELATIVE = on
	
	parentPoint.rotation.controller[2].controller = Orientation_Constraint ()
	parentPoint.rotation.controller[2].controller.appendTarget pvtparentPoint 100
	parentPoint.rotation.controller[2].controller.RELATIVE = on

	chestCtrl = FN_createNgon ((chestBoneG.width*glbBuildSCL + chestBoneG.length*glbBuildSCL)/2)
	chestCtrl.transform = chestBoneG.transform
	chestCtrl.parent = chestBoneG
	chestCtrl.scale = [1,1,1]
	if fnTarget.middleCheck == true do chestCtrl.pos.controller.x_position += (chestBoneG.height/2)
	chestCtrl.parent = parentPoint
	rst chestCtrl
	chestCtrl.name = chestBoneG.name+"_Ctrl"
		
-- 	addModifier chestCtrl (EmptyModifier ()) 
-- 	chestCtrl.modifiers[#attribute_holder].name = "attributes"
	FN_spineAttributes chestCtrl
	
	obj = NodeTransformMonitor node:parentPoint forwardTransformChangeMsgs:false
	append chestCtrl.modifiers[#attributes].spineAttributes.cPosHolder obj
	
	chestCtrl.modifiers[#attributes].spineAttributes[#squash].controller = bezier_float ()
	chestCtrl.modifiers[#attributes].spineAttributes[#_tanh].controller = bezier_float ()
	chestCtrl.modifiers[#attributes].spineAttributes.boneCount = spineBonesG.count-1
		
		if fnTarget.parentHolderG[1].node.hubCheck == true do
		(
			chestCtrl.modifiers[#attributes].spineAttributes.cOrient = 1
			chestCtrl.modifiers[#attributes].spineAttributes.cOrientPivot= 0
		)
		
-- 	paramWire.connect chestCtrl.modifiers[#attributes].spineAttributes[#cOrient] pntAbsRel.rotation.controller[2].controller[#Orientation_Weight_0] "1-cOrient"
	paramWire.connect chestCtrl.modifiers[#attributes].spineAttributes[#cOrient] pntAbsRel.rotation.controller.weights[#Weight__Orientation_Constraint] "1-cOrient"
		
-- 	paramWire.connect chestCtrl.modifiers[#attributes].spineAttributes[#cPos] pntAbsRel.pos.controller.weights[#Weight__Position_Constraint] "1-cPos"
-- 	paramWire.connect chestCtrl.modifiers[#attributes].spineAttributes[#cPos] pntAbsRel.pos.controller.Position_Constraint.controller[#Position_Weight_1] "cPos"
		
	paramWire.connect chestCtrl.modifiers[#attributes].spineAttributes[#cOrientPivot] pvtparentPoint.rotation.controller[2].controller[#Orientation_Weight_0] "cOrientPivot"
	paramWire.connect chestCtrl.modifiers[#attributes].spineAttributes[#cOrientPivot] pvtparentPoint.rotation.controller[2].controller[#Orientation_Weight_1] "1-cOrientPivot"
		
-- 	paramWire.connect chestCtrl.modifiers[#attributes].spineAttributes[#cOrientPivot] prepntRoot.rotation.controller[2].controller[#Orientation_Weight_0] "cOrientPivot"
-- 	paramWire.connect chestCtrl.modifiers[#attributes].spineAttributes[#cOrientPivot] prepntRoot.rotation.controller[2].controller[#Orientation_Weight_1] "1-cOrientPivot"
	
-- 	paramWire.connect chestCtrl.rotation.controller[#XYZ] pvtparentPoint01.rotation.controller[#XYZ] "XYZ"
-- 	paramWire.connect chestCtrl.rotation.controller.XYZ.controller[#X_Rotation] pvtparentPoint01.rotation.controller.XYZ.controller[#X_Rotation] "X_Rotation*1.5"
	paramWire.connect chestCtrl.rotation.controller.XYZ.controller[#Y_Rotation] pvtparentPoint01.rotation.controller.XYZ.controller[#Y_Rotation] "Y_Rotation*3"
	paramWire.connect chestCtrl.rotation.controller.XYZ.controller[#Z_Rotation] pvtparentPoint01.rotation.controller.XYZ.controller[#Z_Rotation] "Z_Rotation*3"
	
-- 	paramWire.connect chestCtrl.rotation.controller[#XYZ] prepntRoot01.rotation.controller[#XYZ] "XYZ"
-- 	paramWire.connect chestCtrl.rotation.controller.XYZ.controller[#X_Rotation] prepntRoot01.rotation.controller.XYZ.controller[#X_Rotation] "X_Rotation/2"
-- 	paramWire.connect chestCtrl.rotation.controller.XYZ.controller[#Y_Rotation] prepntRoot01.rotation.controller.XYZ.controller[#Y_Rotation] "Y_Rotation/2"
-- 	paramWire.connect chestCtrl.rotation.controller.XYZ.controller[#Z_Rotation] prepntRoot01.rotation.controller.XYZ.controller[#Z_Rotation] "Z_Rotation/2"


	
	innerChestCtrl = FN_createCircle (((chestBoneG.width*glbBuildSCL + chestBoneG.length*glbBuildSCL)/2)*.9)
	innerChestCtrl.parent =ChestCtrl
	innerChestCtrl.transform = chestBoneG.transform
	innerChestCtrl.scale = [1,1,1]
	if fnTarget.middleCheck == true do innerChestCtrl.objectOffsetPos = [(chestBoneG.height/2)*glbBuildSCL, 0,0]
	rst innerChestCtrl
	setTransformLockFlags innerChestCtrl #{3,2,1}
-- 	innerChestCtrl.pos.controller.XYZ.controller = position_script ()
	
	innerChestCtrl.name = chestBoneG.name+"_InnerCtrl"
	
	
	chestBone = FN_buildBox chestBoneG (chestBoneG.width*glbBuildSCL) (chestBoneG.length*glbBuildSCL) (chestBoneG.height*glbBuildSCL)
	chestBone.transform = chestBoneG.transform
	chestBone.parent = innerChestCtrl
	chestBone.scale = [1,1,1]
	rst chestBone
	chestBone.name = chestBoneG.name
		
		
	---- create spines
	
	parentPoint = FN_createPoint () -- parente bagli olan 
	parentPoint.parent = fnParent
	parentPoint.transform = spineBonesG[1].transform
	parentPoint.scale = [1,1,1]
	rst parentPoint
	
	TanPointChest = FN_createPoint () -- parente bagli olan 
	TanPointChest.parent = chestCtrl
	TanPointChest.transform = spineBonesG[spineBonesG.count].transform
	
	ptMidChild = FN_createPoint ()
	
	TanPointHip = FN_createPoint () -- parente bagli olan 
	TanPointHip.parent = parentPoint
	TanPointHip.transform = parentPoint.transform
	
	TanPointChest.scale.controller = scale_script()
	TanPointChest.scale.controller = scale_list()
	TanPointChest.scale.controller.available.controller = bezier_scale()
	TanPointChest.scale.controller.setActive 2
	TanPointChest.scale.controller[1].controller.addconstant "dist" (distance TanPointChest parentPoint)
	TanPointChest.scale.controller[1].controller.addnode "hip" TanPointHip
	TanPointChest.scale.controller[1].controller.addnode "chest" TanPointChest
	TanPointChest.scale.controller[1].controller.script = "try([1,1,1]*((distance chest.pos hip.pos)/dist))catch([1,1,1])"
	rst TanPointChest
	
	
	TanPointHip.scale.controller = scale_script()
	TanPointHip.scale.controller = scale_list()
	TanPointHip.scale.controller.available.controller = bezier_scale()
	TanPointHip.scale.controller.setActive 2
	TanPointHip.scale.controller[1].controller.addconstant "dist" (distance TanPointChest parentPoint)
	TanPointHip.scale.controller[1].controller.addnode "hip" TanPointHip
	TanPointHip.scale.controller[1].controller.addnode "chest" TanPointChest
	TanPointHip.scale.controller[1].controller.script = "try([1,1,1]*((distance chest.pos hip.pos)/dist))catch([1,1,1])"
	rst TanPointHip
	
	setInheritanceFlags TanPointChest #{1,2,3,4,5,6}
	setInheritanceFlags TanPointHip #{1,2,3,4,5,6}
	
	------- spline part
	ss = SplineShape ()
	FN_addIR ss
	try
	(
		obj = NodeTransformMonitor node:ss forwardTransformChangeMsgs:false
		append glbRoot.rigNodes obj
	)catch()
	ss.name = uniquename  (rName + "_hiddenNodes_")
	newLayerHiddenNodes.addNode ss
	ss.parent = glbHubCtrl
	ss.transform = spineBonesG[1].transform
	
	addNewSpline ss
	addKnot ss 1 #smooth #curve TanPointHip.position
	addKnot ss 1 #smooth #curve TanPointChest.position
	updateShape ss
	
	for i=1 to 2 do 
	(
		setKnotType ss 1 i (#bezier )
	)
	updateShape ss
	
	------new 
	dist = (distance TanPointChest TanPointHip)
	ptChest = FN_createPoint ()
	ptChest.transform = TanPointChest.transform
	ptChest.scale = [1,1,1]
	ptChest.parent = TanPointChest
	ptChest.pos.controller.x_position = -dist/2
	
	ptHip = FN_createPoint ()
	ptHip.transform = TanPointHip.transform
	ptHip.scale = [1,1,1]
	ptHip.parent = TanPointHip
	ptHip.pos.controller.x_position = dist/2
		
	
	ptMid = FN_createPoint ()
	ptMid.transform = ptChest.transform
	ptMid.scale = [1,1,1]
	ptMid.parent = parentPoint
	rst ptMid
	
	ptMid.pos.controller[2].controller = position_Constraint ()
	ptMid.pos.controller[2].controller.appendTarget ptChest 50
	ptMid.pos.controller[2].controller.appendTarget ptHip 50
	ptMid.rotation.controller[2].controller = orientation_Constraint ()
	ptMid.rotation.controller[2].controller.appendTarget ptChest 50
	ptMid.rotation.controller[2].controller.appendTarget ptHip 50
	
	
	
	if spineBonesG.count > 2 then
	(
		midCtrlPos = FN_createPoint () /*spine curve point*/
		midCtrlPos.pos.controller = path_constraint()
		midCtrlPos.pos.controller.path = ss
		midCtrlPos.pos.controller.percent = 50
		
		midCtrlMain = FN_createPin ptMid.pos (ptMid.pos + [0,(chestBone.width +chestBone.length)*.8*glbBuildSCL,0])
		midCtrlMain.transform = ptMid.transform
		midCtrlMain.parent = ptMid
		midCtrlMain.pos = midCtrlPos.pos
		delete midCtrlPos
		rst midCtrlMain
		midCtrlMain.name = chestBoneG.name+"_mid_Ctrl"
		
		--ptMidChild i yukarida toptan la bottomtan arasinda yaratiyoruz cunku skin isme göre bone id veriyor
		ptMidChild.transform = midCtrlMain.transform
		ptMidChild.parent = midCtrlMain
	)
	else
	(
		--ptMidChild i yukarida toptan la bottomtan arasinda yaratiyoruz cunku skin isme göre bone id veriyor
		ptMidChild.transform = ptMid.transform
		ptMidChild.parent = ptMid
	)
	
	

	setCommandPanelTaskMode #modify
	select ss
	
	addModifier ss (Skin ())
		
	skinOps.addbone ss.modifiers[#Skin] TanPointChest 1
	skinOps.addbone ss.modifiers[#Skin] ptMidChild 1
	skinOps.addbone ss.modifiers[#Skin] TanPointHip 1
	
	enableSceneRedraw()
	redrawViews()
	disableSceneRedraw()
	
	skinOps.ReplaceVertexWeights ss.modifiers[#Skin] 1 #(3) #(1)
	skinOps.ReplaceVertexWeights ss.modifiers[#Skin] 2 #(3) #(1)
	skinOps.ReplaceVertexWeights ss.modifiers[#Skin] 3 #(2) #(1)
	skinOps.ReplaceVertexWeights ss.modifiers[#Skin] 4 #(2) #(1)
	skinOps.ReplaceVertexWeights ss.modifiers[#Skin] 5 #(1) #(1)
	skinOps.ReplaceVertexWeights ss.modifiers[#Skin] 6 #(1) #(1)
		
	setCommandPanelTaskMode #create
	
	
	setInheritanceFlags ss #{1,2,3,7,8,9}
	
	hide ss
	freeze ss
	
	boneDrivePoints = #()
	_percentPos = 0
	scpArray = #()
	for t = 1 to spineBonesG.count do
	(
		scp = FN_createPoint () /*spine curve point*/
		scp.parent = glbRoot
		scp.pos.controller = path_constraint()
		scp.pos.controller.path = ss
		scp.pos.controller.percent = _percentPos*100
		deletekeys scp
		append scpArray scp
		
		_percentPos += (spineBonesG[t].height*glbBuildSCL)/spineLength
		if _percentPos > 1 do _percentPos = 1
			
		obj = NodeTransformMonitor node:scp forwardTransformChangeMsgs:false
		append chestCtrl.modifiers[#attributes].spineAttributes.constantHolder obj

		append boneDrivePoints scp
	)
	
	scpArray[1].rotation.controller = Orientation_Constraint ()
	scpArray[1].rotation.controller.relative = false
	scpArray[1].rotation.controller.appendTarget fnParent 100
	scpArray[1].rotation.controller.appendTarget chestBone 0
		
	scpArray[scpArray.count].rotation.controller = Orientation_Constraint ()
	scpArray[scpArray.count].rotation.controller.relative = false
	scpArray[scpArray.count].rotation.controller.appendTarget fnParent 0
	scpArray[scpArray.count].rotation.controller.appendTarget chestBone 100
	
	for i = 2 to scpArray.count-1 do
	(
		distLoc = (distance ptMidChild.position ((scpArray[i].transform.position +scpArray[i+1].transform.position)/2))
		midTs = (distLoc/(dist*.5))
			
		distLoc2 = (distance TanPointHip.position ((scpArray[i].transform.position +scpArray[i+1].transform.position)/2))
		percentRot = (distLoc2/dist)
		
		scpArray[i].rotation.controller = Orientation_Constraint ()
		scpArray[i].rotation.controller.relative = false
		scpArray[i].rotation.controller.appendTarget fnParent (midTs*(100-(percentRot*100)))
		scpArray[i].rotation.controller.appendTarget ptMidChild ((1-midTs)*100)
		scpArray[i].rotation.controller.appendTarget chestBone (midTs*(percentRot*100))
	)
	
	
	tLength = 0
	for i = 1 to (spineBonesG.count) do
	(
		tLength += spineBonesG[i].length
	)
		
	midCtrls = #()
	for i = 1 to (boneDrivePoints.count-1) do
	(
		midPoint = FN_createPoint ()
		midPoint.transform = spineBonesG[i].transform
		midPoint.parent = boneDrivePoints[i]
-- 		midPoint.pos.controller = position_Constraint ()
-- 		midPoint.pos.controller.appendTarget boneDrivePoints[i] 100
		midPoint.rotation.controller = lookat_Constraint ()
		midPoint.rotation.controller.target_axis = 0
		midPoint.rotation.controller.lookat_vector_length = 0
		midPoint.rotation.controller.upnode_ctrl = 1
		midPoint.rotation.controller.StoUP_axis = 2
		midPoint.rotation.controller.upnode_axis = 2
		midPoint.rotation.controller.pickUpNode = boneDrivePoints[i]
		midPoint.rotation.controller.upnode_world = off
		midPoint.rotation.controller.appendTarget boneDrivePoints[i+1] 100
		

		midCtrl = FN_createPin boneDrivePoints[i].pos (boneDrivePoints[i].pos + [0,(chestBone.width +chestBone.length)*.5*glbBuildSCL,0])
		midCtrl.transform = midPoint.transform
		midCtrl.parent = midPoint
		boneDrivePoints[i] = midCtrl
		rst midCtrl
		midCtrl.name = spineBonesG[i].name + "_Ctrl"
		append midCtrls midCtrl
		
		obj = NodeTransformMonitor node:midCtrl forwardTransformChangeMsgs:false
		append chestCtrl.modifiers[#attributes].spineAttributes.midCtrlsHolder obj
	)
	
	spineBones = #()
	for t = 1 to (spineBonesG.count-1) do -- -1 cünkü chestbone u da arraya dahil etmistik
	(
		oldPoint = boneDrivePoints[t]
		p1 = boneDrivePoints[t+1]
		
		sb =(FN_buildBox spineBonesG[t] (spineBonesG[t].width*glbBuildSCL) (spineBonesG[t].length*glbBuildSCL) (spineBonesG[t].height*glbBuildSCL))
		sb.parent = glbHubCtrl
		sb.pos.controller = position_Constraint ()
		sb.pos.controller.appendTarget oldPoint 100
		sb.rotation.controller = lookat_Constraint ()
		sb.rotation.controller.target_axis = 0
		sb.rotation.controller.lookat_vector_length = 0
		sb.rotation.controller.upnode_ctrl = 1
		sb.rotation.controller.StoUP_axis = 2
		sb.rotation.controller.upnode_axis = 2
		sb.rotation.controller.pickUpNode = oldPoint
		sb.rotation.controller.upnode_world = off
		sb.rotation.controller.appendTarget p1 100
		sb.height = (distance oldPoint p1)/glbRoot.scale.x
		sb.scale.controller = ScaleXYZ ()
		sb.scale.X_Scale.controller = float_script ()
		sb.scale.X_Scale.controller.AddNode "p0" oldPoint
		sb.scale.X_Scale.controller.AddNode "p1" p1
		sb.scale.X_Scale.controller.AddTarget "scl" glbRoot.scale.controller
		sb.scale.X_Scale.controller.Addconstant "hgt" sb.height
		sb.scale.X_Scale.controller.script = "try(((distance p0 p1)/hgt)*(1/scl.x))catch(0)"
		sb.scale.controller.Y_Scale.controller = float_list ()
		sb.scale.controller.Y_Scale.controller.Bezier_Float.controller = float_script ()
		sb.scale.controller.Y_Scale.controller.Available.controller = float_script ()
		sb.scale.controller.Y_Scale.controller.weight[1].controller = float_script ()
		sb.scale.controller.Y_Scale.controller.weight[2].controller = float_script ()
		sb.scale.controller.Y_Scale.controller[1].controller.AddNode "p0" oldPoint
		sb.scale.controller.Y_Scale.controller[1].controller.AddNode "p1" p1
		sb.scale.controller.Y_Scale.controller[1].controller.AddTarget "scl" glbRoot.scale.controller
		sb.scale.controller.Y_Scale.controller[1].controller.Addconstant "hgt" sb.height
		sb.scale.controller.Y_Scale.controller[1].controller.script = "try((1/(((distance p0 p1)/hgt)))*scl.x)catch(0)"
		sb.scale.controller.Y_Scale.controller[2].controller.script ="1"
		sb.scale.controller.Y_Scale.controller.weight[1].controller.AddTarget "mlt" chestCtrl.modifiers[#attributes].spineAttributes[#squash].controller
		sb.scale.controller.Y_Scale.controller.weight[1].controller.script = "mlt"
		sb.scale.controller.Y_Scale.controller.weight[2].controller.AddTarget "mlt" chestCtrl.modifiers[#attributes].spineAttributes[#squash].controller
		sb.scale.controller.Y_Scale.controller.weight[2].controller.script = "1-mlt"
		sb.scale.controller.Z_Scale.controller = float_list ()
		sb.scale.controller.Z_Scale.controller.Bezier_Float.controller = float_script ()
		sb.scale.controller.Z_Scale.controller.Available.controller = float_script ()
		sb.scale.controller.Z_Scale.controller.weight[1].controller = float_script ()
		sb.scale.controller.Z_Scale.controller.weight[2].controller = float_script ()
		sb.scale.controller.Z_Scale.controller[1].controller.AddNode "p0" oldPoint
		sb.scale.controller.Z_Scale.controller[1].controller.AddNode "p1" p1
		sb.scale.controller.Z_Scale.controller[1].controller.AddTarget "scl" glbRoot.scale.controller
		sb.scale.controller.Z_Scale.controller[1].controller.Addconstant "hgt" sb.height
		sb.scale.controller.Z_Scale.controller[1].controller.script = "try((1/(((distance p0 p1)/hgt)))*scl.z)catch(0)"
		sb.scale.controller.Z_Scale.controller[2].controller.script ="1"
		sb.scale.controller.Z_Scale.controller.weight[1].controller.AddTarget "mlt" chestCtrl.modifiers[#attributes].spineAttributes[#squash].controller
		sb.scale.controller.Z_Scale.controller.weight[1].controller.script = "mlt"
		sb.scale.controller.Z_Scale.controller.weight[2].controller.AddTarget "mlt" chestCtrl.modifiers[#attributes].spineAttributes[#squash].controller
		sb.scale.controller.Z_Scale.controller.weight[2].controller.script = "1-mlt"
		append spineBones sb
		sb.name = spineBonesG[t].name
	)
	
-- 	select chestBone
	for i = 1 to spineBones.count do
	(
		obj = NodeTransformMonitor node:chestCtrl forwardTransformChangeMsgs:false
		spineBones[i].moduleCtrl = obj
		if i == 1 then
		(
			obj = NodeTransformMonitor node:spineBones[i] forwardTransformChangeMsgs:false
			append fnParent.childG obj
		)
		else
		(
			obj = NodeTransformMonitor node:spineBones[i] forwardTransformChangeMsgs:false
			append spineBones[i-1].childG obj
		)
	)
	
	
	obj = NodeTransformMonitor node:chestBone forwardTransformChangeMsgs:false
	append spineBones[spineBones.count].childG obj
	obj = NodeTransformMonitor node:chestCtrl forwardTransformChangeMsgs:false
	chestBone.moduleCtrl = obj
	
	--add parameters
	obj = NodeTransformMonitor node:chestCtrl.parent forwardTransformChangeMsgs:false
	chestCtrl.prnt =obj
	chestCtrl.m3a =(chestCtrl.transform*(inverse chestCtrl.parent.transform))
		
	chestCtrl._type = 6
	chestCtrl._name = fnTarget.modulNameHolder
	chestCtrl.isChest = true
	obj = NodeTransformMonitor node:chestCtrl forwardTransformChangeMsgs:false
	append fnParent.moduleCtrl.node.childModules obj
	obj = NodeTransformMonitor node:chestCtrl forwardTransformChangeMsgs:false
	chestCtrl.currentModuleCtrl = obj
	obj = NodeTransformMonitor node:chestCtrl forwardTransformChangeMsgs:false
	append chestCtrl.spineCtrls obj
		
	chestCtrl._overlapDist[1] = chestBone.height
	chestCtrl._overlapDist[2] = chestBone.width
	
	--inner chest
	obj = NodeTransformMonitor node:innerChestCtrl.parent forwardTransformChangeMsgs:false
	innerChestCtrl.prnt =obj
	innerChestCtrl.m3a =(innerChestCtrl.transform*(inverse innerChestCtrl.parent.transform))
	
	obj = NodeTransformMonitor node:innerChestCtrl forwardTransformChangeMsgs:false
	append chestCtrl.spineCtrls obj
	obj = NodeTransformMonitor node:chestCtrl forwardTransformChangeMsgs:false
	innerChestCtrl.currentModuleCtrl = obj
	
	for i = 1 to midCtrls.count do
	(
		midCtrls[i]._overlapDist[1] = spineBones[i].height
		midCtrls[i]._overlapDist[2] = spineBones[i].width
		
		obj = NodeTransformMonitor node:midCtrls[i].parent forwardTransformChangeMsgs:false
		midCtrls[i].prnt =obj
		midCtrls[i].m3a =(midCtrls[i].transform*(inverse midCtrls[i].parent.transform))
			
		obj = NodeTransformMonitor node:midCtrls[i] forwardTransformChangeMsgs:false
		append chestCtrl.spineCtrls obj
		obj = NodeTransformMonitor node:chestCtrl forwardTransformChangeMsgs:false
		midCtrls[i].currentModuleCtrl = obj
	)
	
	if midCtrlMain != undefined do
	(
		midCtrlMain._overlapDist[1] = chestBone.height
		midCtrlMain._overlapDist[2] = chestBone.width
		
		obj = NodeTransformMonitor node:midCtrlMain.parent forwardTransformChangeMsgs:false
		midCtrlMain.prnt =obj
		midCtrlMain.m3a =(midCtrlMain.transform*(inverse midCtrlMain.parent.transform))
			
		obj = NodeTransformMonitor node:midCtrlMain forwardTransformChangeMsgs:false
		append chestCtrl.spineCtrls obj
		obj = NodeTransformMonitor node:chestCtrl forwardTransformChangeMsgs:false
		midCtrlMain.currentModuleCtrl = obj
		
		chestCtrl.modifiers[#attributes].spineAttributes.Params.fintune.pressed()
	)
	
	
	
	
	---------------
	
	spine = #(spineBones, chestBone)
	spine
)


fn FN_copyModule fnTarget =
(
	xmlPath = getSaveFileName caption:"Save as:" types:"XML(*.xml)|*.xml|"
	if xmlPath == undefined do (return false)
	dotNet.loadAssembly "system.xml"
	xmlDoc=dotNetObject "system.xml.xmlDocument"
	saves=xmlDoc.createElement "Saves"
	xmlDoc.appendChild saves
	

-- 	xmlPath += "\\root.xml"
	root=xmlDoc.createElement "root"
	root.setAttribute "scale" (fnTarget.children[1].scale as string)
	root.setAttribute "size" ("["+fnTarget.children[1].length as string+","+fnTarget.children[1].width as string+"]")
	saves.appendChild root
	recurseSaves fnTarget.children[1] root
	
	xmlDoc.save xmlPath
-- 	edit xmlPath
)

fn recurseSaves fnTarget ele =
(
	if fnTarget.moduleHubHolderG.count != 0 then
	(
		for i in fnTarget.moduleHubHolderG do
		(
			newElement=xmlDoc.createElement "hub"
			newElement.setAttribute "name" i.node.modulNameHolder
			newElement.setAttribute "mr" (i.node.nodeMirror as string)
			newElement.setAttribute "transform" (i.node.hubHolderG[1].node.transform.controller.value as string)
			newElement.setAttribute "size" ("["+i.node.hubHolderG[1].node.scale.controller.X_Scale.controller.Bezier_Float as string+","+ i.node.hubHolderG[1].node.scale.controller.Y_Scale.controller.Bezier_Float as string +","+ i.node.hubHolderG[1].node.scale.controller.Z_Scale.controller.Bezier_Float as string+"]")
			newElement.setAttribute "expr" ("#(\""+(i.node.hubHolderG[1].node.baseObject[#length].getExprText 1)+"\",\""+ (i.node.hubHolderG[1].node.baseObject[#width].getExprText 1)+"\",\""+ (i.node.hubHolderG[1].node.baseObject[#height].getExprText 1)+"\")")
			newElement.setAttribute "offset" ("#("+i.node.hubHolderG[1].node.objectOffsetPos as string+","+ i.node.hubHolderG[1].node.objectOffsetRot as string+","+ i.node.hubHolderG[1].node.objectOffsetScale as string+")")
			ele.appendChild newElement
			
			recurseSaves i.node.hubHolderG[1].node newElement
		)
	)
	
	if fnTarget.moduleTailHolderG.count != 0 then
	(
		for i in fnTarget.moduleTailHolderG do
		(
			newElement=xmlDoc.createElement "chain"
			newElement.setAttribute "transform" (i.node.transform.controller.value as string)
			newElement.setAttribute "name" i.node.modulNameHolder
			newElement.setAttribute "isSpring" (i.node.chType as string)
			newElement.setAttribute "mr" (i.node.nodeMirror as string)
				
			ele.appendChild newElement
			for t = 1 to i.node.tailBoneHolderG.count do
			(
				newchildElement=xmlDoc.createElement "chainBone"
				newchildElement.setAttribute "transform" (i.node.tailBoneHolderG[t].node.transform.controller.value as string)
				newchildElement.setAttribute "size" ("["+i.node.tailBoneHolderG[t].node.scale.controller.X_Scale.controller.Bezier_Float as string+","+ i.node.tailBoneHolderG[t].node.scale.controller.Y_Scale.controller.Bezier_Float as string +","+ i.node.tailBoneHolderG[t].node.scale.controller.Z_Scale.controller.Bezier_Float as string+"]")
				hgt = try(i.node.tailBoneHolderG[t].node.baseObject[#height].getExprText 1)catch("null")
				newchildElement.setAttribute "expr" ("#(\""+(i.node.tailBoneHolderG[t].node.baseObject[#length].getExprText 1)+"\",\""+ (i.node.tailBoneHolderG[t].node.baseObject[#width].getExprText 1)+"\",\""+ hgt+"\")")
				newchildElement.setAttribute "offset" ("#("+i.node.tailBoneHolderG[t].node.objectOffsetPos as string+","+ i.node.tailBoneHolderG[t].node.objectOffsetRot as string+","+ i.node.tailBoneHolderG[t].node.objectOffsetScale as string+")")
				newElement.appendChild newchildElement
				
				recurseSaves i.node.tailBoneHolderG[t].node newchildElement
			)
		)
	)
	
	if fnTarget.moduleArmHolderG.count != 0 then
	(
		for i in fnTarget.moduleArmHolderG do
		(
			upperArm = i.node.armbonesHolderG[1].node
			foreArm = i.node.armbonesHolderG[2].node
			hand = i.node.armbonesHolderG[3].node
			pole = i.node.armPoleHolderG[2].node
			
			newElement=xmlDoc.createElement "arm"
			newElement.setAttribute "transform" (i.node.transform.controller.value as string)
			newElement.setAttribute "name" i.node.modulNameHolder
			newElement.setAttribute "mr" (i.node.nodeMirror as string)
			ele.appendChild newElement
			
			newChildElement=xmlDoc.createElement "pole"
			newChildElement.setAttribute "pos" (pole.pos.controller.Y_Position.controller.Limited_Controller__Bezier_Float as string)
			newElement.appendChild newChildElement
			
			newChildElement=xmlDoc.createElement "upperarm"
			newElement.appendChild newChildElement
			
			newtwistElement=xmlDoc.createElement "twist"
			newtwistElement.setAttribute "transform" (upperArm.transform.controller.value as string)
			newtwistElement.setAttribute "size" ("["+upperArm.scale.controller.Y_Scale.controller.Bezier_Float as string +","+ upperArm.scale.controller.Z_Scale.controller.Bezier_Float as string+"]")
			newtwistElement.setAttribute "expr" ("#(\""+(upperArm.baseObject[#length].getExprText 1)+"\",\""+ (upperArm.baseObject[#width].getExprText 1)+"\")")
			newtwistElement.setAttribute "offset" ("#("+upperArm.objectOffsetPos as string+","+ upperArm.objectOffsetRot as string+","+ upperArm.objectOffsetScale as string+")")
			newChildElement.appendChild newtwistElement
			recurseSaves upperArm newtwistElement
		
			if upperArm.twistBoneHolderG.count != 0 then
			(
				for t = 1 to upperArm.twistBoneHolderG.count do
				(
					newtwistElement=xmlDoc.createElement "twist"
-- 					newtwistElement.setAttribute "transform" (upperArm.twistBoneHolderG[t].node.transform.controller.value as string)
					newtwistElement.setAttribute "size" ("["+ upperArm.twistBoneHolderG[t].node.scale.controller.Y_Scale.controller.Bezier_Float as string +","+ upperArm.twistBoneHolderG[t].node.scale.controller.Z_Scale.controller.Bezier_Float as string+"]")
					newtwistElement.setAttribute "expr" ("#(\""+(upperArm.twistBoneHolderG[t].node.baseObject[#length].getExprText 1)+"\",\""+ (upperArm.twistBoneHolderG[t].node.baseObject[#width].getExprText 1)+"\")")
					newtwistElement.setAttribute "offset" ("#("+upperArm.twistBoneHolderG[t].node.objectOffsetPos as string+","+ upperArm.twistBoneHolderG[t].node.objectOffsetRot as string+","+ upperArm.twistBoneHolderG[t].node.objectOffsetScale as string+")")
					newChildElement.appendChild newtwistElement
					recurseSaves upperArm.twistBoneHolderG[t].node newtwistElement
				)
			)
			
			newChildElement=xmlDoc.createElement "foretarm"
			newElement.appendChild newChildElement
			
			newtwistElement=xmlDoc.createElement "twist"
			newtwistElement.setAttribute "transform" (foreArm.transform.controller.value as string)
			newtwistElement.setAttribute "size" ("["+foreArm.scale.controller.Y_Scale.controller.Bezier_Float as string +","+ foreArm.scale.controller.Z_Scale.controller.Bezier_Float as string+"]")
			newtwistElement.setAttribute "expr" ("#(\""+(foreArm.baseObject[#length].getExprText 1)+"\",\""+ (foreArm.baseObject[#width].getExprText 1)+"\")")
			newtwistElement.setAttribute "offset" ("#("+foreArm.objectOffsetPos as string+","+ foreArm.objectOffsetRot as string+","+ foreArm.objectOffsetScale as string+")")
			newChildElement.appendChild newtwistElement
			recurseSaves foreArm newtwistElement
			
			if foreArm.twistBoneHolderG.count != 0 then
			(
				for t = 1 to foreArm.twistBoneHolderG.count do
				(
					newtwistElement=xmlDoc.createElement "twist"
-- 					newtwistElement.setAttribute "transform" (foreArm.twistBoneHolderG[t].node.transform.controller.value as string)
					newtwistElement.setAttribute "size" ("["+ foreArm.twistBoneHolderG[t].node.scale.controller.Y_Scale.controller.Bezier_Float as string +","+ foreArm.twistBoneHolderG[t].node.scale.controller.Z_Scale.controller.Bezier_Float as string+"]")
					newtwistElement.setAttribute "expr" ("#(\""+(foreArm.twistBoneHolderG[t].node.baseObject[#length].getExprText 1)+"\",\""+ (foreArm.twistBoneHolderG[t].node.baseObject[#width].getExprText 1)+"\")")
					newtwistElement.setAttribute "offset" ("#("+foreArm.twistBoneHolderG[t].node.objectOffsetPos as string+","+ foreArm.twistBoneHolderG[t].node.objectOffsetRot as string+","+ foreArm.twistBoneHolderG[t].node.objectOffsetScale as string+")")
					newChildElement.appendChild newtwistElement
					recurseSaves foreArm.twistBoneHolderG[t].node newtwistElement
				)
			)
			
			newChildElement=xmlDoc.createElement "hand"
			newChildElement.setAttribute "transform" (hand.transform.controller.value as string)
			newChildElement.setAttribute "size" ("["+hand.scale.controller.X_Scale.controller.Bezier_Float as string +","+hand.scale.controller.Y_Scale.controller.Bezier_Float as string +","+ hand.scale.controller.Z_Scale.controller.Bezier_Float as string+"]")
			newChildElement.setAttribute "expr" ("#(\""+(hand.baseObject[#length].getExprText 1)+"\",\""+ (hand.baseObject[#width].getExprText 1)+"\",\""+(hand.baseObject[#height].getExprText 1)+"\")")
			newChildElement.setAttribute "offset" ("#("+hand.objectOffsetPos as string+","+ hand.objectOffsetRot as string+","+ hand.objectOffsetScale as string+")")
			newElement.appendChild newChildElement
			recurseSaves hand newChildElement

			for t in hand.modulefingerHolderG do
			(
				newFingerElement=xmlDoc.createElement "finger"
				newChildElement.appendChild newFingerElement
				
				for b = 1 to t.node.fingerBoneHolderG.count do
				(
					newfingerBoneElement=xmlDoc.createElement "fingerBone"
					newfingerBoneElement.setAttribute "transform" (t.node.fingerBoneHolderG[b].node.transform.controller.value as string)
					newfingerBoneElement.setAttribute "size" ("["+t.node.fingerBoneHolderG[b].node.scale.controller.X_Scale.controller.Bezier_Float as string+","+ t.node.fingerBoneHolderG[b].node.scale.controller.Y_Scale.controller.Bezier_Float as string +","+ t.node.fingerBoneHolderG[b].node.scale.controller.Z_Scale.controller.Bezier_Float as string+"]")
					hgt = try(t.node.fingerBoneHolderG[b].node.baseObject[#height].getExprText 1)catch("null")
					newfingerBoneElement.setAttribute "expr" ("#(\""+(t.node.fingerBoneHolderG[b].node.baseObject[#length].getExprText 1)+"\",\""+ (t.node.fingerBoneHolderG[b].node.baseObject[#width].getExprText 1)+"\",\""+ hgt+"\")")
					newfingerBoneElement.setAttribute "offset" ("#("+t.node.fingerBoneHolderG[b].node.objectOffsetPos as string+","+ t.node.fingerBoneHolderG[b].node.objectOffsetRot as string+","+ t.node.fingerBoneHolderG[b].node.objectOffsetScale as string+")")
					newFingerElement.appendChild newfingerBoneElement
					recurseSaves t.node.fingerBoneHolderG[b].node newfingerBoneElement
				)
			)
			
			if i.node.armbonesHolderG.count > 3  then 
			(
				clavicle = i.node.armbonesHolderG[4].node
				newChildElement=xmlDoc.createElement "clavicle"
				newChildElement.setAttribute "transform" (clavicle.transform.controller.value as string)
				newChildElement.setAttribute "size" ("["+ clavicle.scale.controller.Y_Scale.controller.Bezier_Float as string +","+ clavicle.scale.controller.Z_Scale.controller.Bezier_Float as string+"]")
				newChildElement.setAttribute "expr" ("#(\""+(clavicle.baseObject[#length].getExprText 1)+"\",\""+ (clavicle.baseObject[#width].getExprText 1)+"\")")
				newChildElement.setAttribute "offset" ("#("+clavicle.objectOffsetPos as string+","+ clavicle.objectOffsetRot as string+","+ clavicle.objectOffsetScale as string+")")
				newElement.appendChild newChildElement
				
				newclaviclePartsElement=xmlDoc.createElement "clavicleParts"
				newclaviclePartsElement.setAttribute "pos" (clavicle.clavicleUpHolderG[1].node.pos.controller.Y_Position.controller.Limited_Controller__Bezier_Float as string)
				newclaviclePartsElement.setAttribute "rot" (clavicle.clavicleUpHolderG[2].node.rotation.controller.X_Rotation as string)
				newChildElement.appendChild newclaviclePartsElement

				recurseSaves clavicle newChildElement
			)
		)
	)
	
	if fnTarget.moduleLegHolderG.count != 0 then
	(
		for i in fnTarget.moduleLegHolderG do
		(
			upperArm = i.node.armbonesHolderG[1].node
			foreArm = i.node.armbonesHolderG[2].node
			hand = i.node.armbonesHolderG[3].node
			toe = i.node.legToeHolderG[1].node
			heel = i.node.legToeHolderG[2].node
			footIK = i.node.legToeHolderG[3].node
			pole = i.node.armPoleHolderG[2].node
			
			newElement=xmlDoc.createElement "leg"
			newElement.setAttribute "transform" (i.node.transform.controller.value as string)
			newElement.setAttribute "name" i.node.modulNameHolder
			newElement.setAttribute "mr" (i.node.nodeMirror as string)
			ele.appendChild newElement
			
			newChildElement=xmlDoc.createElement "pole"
			newChildElement.setAttribute "pos" (pole.pos.controller.Y_Position.controller.Limited_Controller__Bezier_Float as string)
			newElement.appendChild newChildElement
			
			newChildElement=xmlDoc.createElement "upperarm"
			newElement.appendChild newChildElement
			
			newtwistElement=xmlDoc.createElement "twist"
			newtwistElement.setAttribute "transform" (upperArm.transform.controller.value as string)
			newtwistElement.setAttribute "size" ("["+upperArm.scale.controller.Y_Scale.controller.Bezier_Float as string +","+ upperArm.scale.controller.Z_Scale.controller.Bezier_Float as string+"]")
			newtwistElement.setAttribute "expr" ("#(\""+(upperArm.baseObject[#length].getExprText 1)+"\",\""+ (upperArm.baseObject[#width].getExprText 1)+"\")")
			newtwistElement.setAttribute "offset" ("#("+upperArm.objectOffsetPos as string+","+ upperArm.objectOffsetRot as string+","+ upperArm.objectOffsetScale as string+")")
			newChildElement.appendChild newtwistElement
			recurseSaves upperArm newtwistElement
		
			if upperArm.twistBoneHolderG.count != 0 then
			(
				for t = 1 to upperArm.twistBoneHolderG.count do
				(
					newtwistElement=xmlDoc.createElement "twist"
-- 					newtwistElement.setAttribute "transform" (upperArm.twistBoneHolderG[t].node.transform.controller.value as string)
					newtwistElement.setAttribute "size" ("["+ upperArm.twistBoneHolderG[t].node.scale.controller.Y_Scale.controller.Bezier_Float as string +","+ upperArm.twistBoneHolderG[t].node.scale.controller.Z_Scale.controller.Bezier_Float as string+"]")
					newtwistElement.setAttribute "expr" ("#(\""+(upperArm.twistBoneHolderG[t].node.baseObject[#length].getExprText 1)+"\",\""+ (upperArm.twistBoneHolderG[t].node.baseObject[#width].getExprText 1)+"\")")
					newtwistElement.setAttribute "offset" ("#("+upperArm.twistBoneHolderG[t].node.objectOffsetPos as string+","+ upperArm.twistBoneHolderG[t].node.objectOffsetRot as string+","+ upperArm.twistBoneHolderG[t].node.objectOffsetScale as string+")")
					newChildElement.appendChild newtwistElement
					recurseSaves upperArm.twistBoneHolderG[t].node newtwistElement
				)
			)
			
			newChildElement=xmlDoc.createElement "foretarm"
			newElement.appendChild newChildElement
			
			newtwistElement=xmlDoc.createElement "twist"
			newtwistElement.setAttribute "transform" (foreArm.transform.controller.value as string)
			newtwistElement.setAttribute "size" ("["+foreArm.scale.controller.Y_Scale.controller.Bezier_Float as string +","+ foreArm.scale.controller.Z_Scale.controller.Bezier_Float as string+"]")
			newtwistElement.setAttribute "expr" ("#(\""+(foreArm.baseObject[#length].getExprText 1)+"\",\""+ (foreArm.baseObject[#width].getExprText 1)+"\")")
			newtwistElement.setAttribute "offset" ("#("+foreArm.objectOffsetPos as string+","+ foreArm.objectOffsetRot as string+","+ foreArm.objectOffsetScale as string+")")
			newChildElement.appendChild newtwistElement
			recurseSaves foreArm newtwistElement
			
			if foreArm.twistBoneHolderG.count != 0 then
			(
				for t = 1 to foreArm.twistBoneHolderG.count do
				(
					newtwistElement=xmlDoc.createElement "twist"
-- 					newtwistElement.setAttribute "transform" (foreArm.twistBoneHolderG[t].node.transform.controller.value as string)
					newtwistElement.setAttribute "size" ("["+ foreArm.twistBoneHolderG[t].node.scale.controller.Y_Scale.controller.Bezier_Float as string +","+ foreArm.twistBoneHolderG[t].node.scale.controller.Z_Scale.controller.Bezier_Float as string+"]")
					newtwistElement.setAttribute "expr" ("#(\""+(foreArm.twistBoneHolderG[t].node.baseObject[#length].getExprText 1)+"\",\""+ (foreArm.twistBoneHolderG[t].node.baseObject[#width].getExprText 1)+"\")")
					newtwistElement.setAttribute "offset" ("#("+foreArm.twistBoneHolderG[t].node.objectOffsetPos as string+","+ foreArm.twistBoneHolderG[t].node.objectOffsetRot as string+","+ foreArm.twistBoneHolderG[t].node.objectOffsetScale as string+")")
					newChildElement.appendChild newtwistElement
					recurseSaves foreArm.twistBoneHolderG[t].node newtwistElement
				)
			)
			
			newChildElement=xmlDoc.createElement "hand"
			newChildElement.setAttribute "transform" (hand.transform.controller.value as string)
			newChildElement.setAttribute "size" ("["+hand.scale.controller.Y_Scale.controller.Bezier_Float as string +","+ hand.scale.controller.Z_Scale.controller.Bezier_Float as string+"]")
			newChildElement.setAttribute "expr" ("#(\""+(hand.baseObject[#length].getExprText 1)+"\",\""+ (hand.baseObject[#width].getExprText 1)+"\")")
			newChildElement.setAttribute "offset" ("#("+hand.objectOffsetPos as string+","+ hand.objectOffsetRot as string+","+ hand.objectOffsetScale as string+")")
			newElement.appendChild newChildElement
			recurseSaves hand newChildElement
			
			newHeelElement=xmlDoc.createElement "heel"
			newHeelElement.setAttribute "transform" (heel.transform.controller.value as string)
			newHeelElement.setAttribute "size" ("["+heel.scale.controller.X_Scale.controller.Bezier_Float as string +","+heel.scale.controller.Y_Scale.controller.Bezier_Float as string +","+ heel.scale.controller.X_Scale.controller.Bezier_Float as string+"]")
			newHeelElement.setAttribute "expr" ("#(\""+(heel.baseObject[#length].getExprText 1)+"\",\""+ (heel.baseObject[#width].getExprText 1)+"\",\""+(heel.baseObject[#height].getExprText 1)+"\")")
-- 			newHeelElement.setAttribute "offset" ("#("+heel.objectOffsetPos as string+","+ heel.objectOffsetRot as string+","+ heel.objectOffsetScale as string+")")
			newChildElement.appendChild newHeelElement
			recurseSaves heel newChildElement
			
			newfootIKElement=xmlDoc.createElement "footIK"
			newfootIKElement.setAttribute "transform" (footIK.transform.controller.value as string)
			newfootIKElement.setAttribute "size" ("["+footIK.scale.controller.X_Scale.controller.Bezier_Float as string+"," + footIK.scale.controller.Z_Scale.controller.Bezier_Float as string+"]")
			newfootIKElement.setAttribute "expr" ("#(\""+(footIK.baseObject[#length].getExprText 1)+"\",\""+ (footIK.baseObject[#width].getExprText 1)+"\",\""+(footIK.cornerRadius as string)+"\")")
			newfootIKElement.setAttribute "offset" ("#("+footIK.objectOffsetPos as string+","+ footIK.objectOffsetRot as string+","+ footIK.objectOffsetScale as string+")")
			newChildElement.appendChild newfootIKElement
			recurseSaves footIK newChildElement
			
			newtoeElement=xmlDoc.createElement "toe"
			newtoeElement.setAttribute "transform" (toe.transform.controller.value as string)
			newtoeElement.setAttribute "size" ("["+toe.scale.controller.X_Scale.controller.Bezier_Float as string +","+toe.scale.controller.Y_Scale.controller.Bezier_Float as string +","+ toe.scale.controller.Z_Scale.controller.Bezier_Float as string+"]")
			newtoeElement.setAttribute "expr" ("#(\""+(toe.baseObject[#length].getExprText 1)+"\",\""+ (toe.baseObject[#width].getExprText 1)+"\",\""+(toe.baseObject[#height].getExprText 1)+"\")")
			newtoeElement.setAttribute "offset" ("#("+toe.objectOffsetPos as string+","+ toe.objectOffsetRot as string+","+ toe.objectOffsetScale as string+")")
			newChildElement.appendChild newtoeElement
			recurseSaves toe newtoeElement

			for t in hand.modulefingerHolderG do
			(
				newFingerElement=xmlDoc.createElement "finger"
				newtoeElement.appendChild newFingerElement
				
				for b = 1 to t.node.fingerBoneHolderG.count do
				(
					newfingerBoneElement=xmlDoc.createElement "fingerBone"
					newfingerBoneElement.setAttribute "transform" (t.node.fingerBoneHolderG[b].node.transform.controller.value as string)
					newfingerBoneElement.setAttribute "size" ("["+t.node.fingerBoneHolderG[b].node.scale.controller.X_Scale.controller.Bezier_Float as string+","+ t.node.fingerBoneHolderG[b].node.scale.controller.Y_Scale.controller.Bezier_Float as string +","+ t.node.fingerBoneHolderG[b].node.scale.controller.Z_Scale.controller.Bezier_Float as string+"]")
					hgt = try(t.node.fingerBoneHolderG[b].node.baseObject[#height].getExprText 1)catch("null")
					newfingerBoneElement.setAttribute "expr" ("#(\""+(t.node.fingerBoneHolderG[b].node.baseObject[#length].getExprText 1)+"\",\""+ (t.node.fingerBoneHolderG[b].node.baseObject[#width].getExprText 1)+"\",\""+ hgt+"\")")
					newfingerBoneElement.setAttribute "offset" ("#("+t.node.fingerBoneHolderG[b].node.objectOffsetPos as string+","+ t.node.fingerBoneHolderG[b].node.objectOffsetRot as string+","+ t.node.fingerBoneHolderG[b].node.objectOffsetScale as string+")")
					newFingerElement.appendChild newfingerBoneElement
					recurseSaves t.node.fingerBoneHolderG[b].node newfingerBoneElement
				)
			)
			
			if i.node.armbonesHolderG.count > 4  then 
			(
				clavicle = i.node.armbonesHolderG[5].node
				newChildElement=xmlDoc.createElement "clavicle"
				newChildElement.setAttribute "transform" (clavicle.transform.controller.value as string)
				newChildElement.setAttribute "size" ("["+ clavicle.scale.controller.Y_Scale.controller.Bezier_Float as string +","+ clavicle.scale.controller.Z_Scale.controller.Bezier_Float as string+"]")
				newChildElement.setAttribute "expr" ("#(\""+(clavicle.baseObject[#length].getExprText 1)+"\",\""+ (clavicle.baseObject[#width].getExprText 1)+"\")")
				newChildElement.setAttribute "offset" ("#("+clavicle.objectOffsetPos as string+","+ clavicle.objectOffsetRot as string+","+ clavicle.objectOffsetScale as string+")")
				newElement.appendChild newChildElement
				newclaviclePartsElement=xmlDoc.createElement "clavicleParts"
				newclaviclePartsElement.setAttribute "pos" (clavicle.clavicleUpHolderG[1].node.pos.controller.Y_Position.controller.Limited_Controller__Bezier_Float as string)
				newclaviclePartsElement.setAttribute "rot" (clavicle.clavicleUpHolderG[2].node.rotation.controller.X_Rotation as string)
				newChildElement.appendChild newclaviclePartsElement

				recurseSaves clavicle newChildElement
			)
		)
	)
	
	if fnTarget.moduleSpineHolderG.count != 0 then
	(
		for i in fnTarget.moduleSpineHolderG do
		(
			spineEnd = i.node.spineEndHolderG[1].node
			chest = i.node.chestHolderG[1].node
			
			newElement=xmlDoc.createElement "spine"
			newElement.setAttribute "transform" (i.node.transform.controller.value as string)
			newElement.setAttribute "name" i.node.modulNameHolder
			newElement.setAttribute "mr" (i.node.nodeMirror as string)
			newElement.setAttribute "mCheck" (i.node.middleCheck as string)
			
			ele.appendChild newElement
			
			newchildElement=xmlDoc.createElement "spineEnd"
			newchildElement.setAttribute "transform" (spineEnd.transform.controller.value as string)
			newchildElement.setAttribute "size" ("["+spineEnd.scale.controller.X_Scale.controller.Bezier_Float as string +","+spineEnd.scale.controller.Y_Scale.controller.Bezier_Float as string +","+ spineEnd.scale.controller.Z_Scale.controller.Bezier_Float as string+"]")
			newchildElement.setAttribute "expr" ("#(\""+(spineEnd.baseObject[#length].getExprText 1)+"\",\""+ (spineEnd.baseObject[#width].getExprText 1)+"\",\""+(spineEnd.baseObject[#height].getExprText 1)+"\")")
			newchildElement.setAttribute "offset" ("#("+spineEnd.objectOffsetPos as string+","+ spineEnd.objectOffsetRot as string+","+ spineEnd.objectOffsetScale as string+")")
			newElement.appendChild newchildElement
			
			newchildElement=xmlDoc.createElement "chest"
			newchildElement.setAttribute "transform" (chest.transform.controller.value as string)
			newchildElement.setAttribute "size" ("["+chest.scale.controller.X_Scale.controller.Bezier_Float as string +","+chest.scale.controller.Y_Scale.controller.Bezier_Float as string +","+ chest.scale.controller.Z_Scale.controller.Bezier_Float as string+"]")
			newchildElement.setAttribute "expr" ("#(\""+(chest.baseObject[#length].getExprText 1)+"\",\""+ (chest.baseObject[#width].getExprText 1)+"\",\""+(chest.baseObject[#height].getExprText 1)+"\")")
			newchildElement.setAttribute "offset" ("#("+chest.objectOffsetPos as string+","+ chest.objectOffsetRot as string+","+ chest.objectOffsetScale as string+")")
			newElement.appendChild newchildElement
			recurseSaves chest newchildElement
			
			newspineHolderElement=xmlDoc.createElement "spineBones"
			newElement.appendChild newspineHolderElement
			for spine in i.node.spineHolderG do
			(
				newspineElement=xmlDoc.createElement "spineBone"
				newspineElement.setAttribute "pos" (spine.node.pos.controller.Position_XYZ.value as string)
				newspineElement.setAttribute "size" ("["+spine.node.scale.controller.Y_Scale.controller.Bezier_Float as string +","+ spine.node.scale.controller.Z_Scale.controller.Bezier_Float as string+"]")
				newspineElement.setAttribute "expr" ("#(\""+(spine.node.baseObject[#length].getExprText 1)+"\",\""+ (spine.node.baseObject[#width].getExprText 1)+"\")")
				newspineElement.setAttribute "offset" ("#("+spine.node.objectOffsetPos as string+","+ spine.node.objectOffsetRot as string+","+ spine.node.objectOffsetScale as string+")")
				newspineHolderElement.appendChild newspineElement
				recurseSaves spine.node newspineElement
			)
			
		)
	)
)

fn FN_pasteModule fnTarget xmlpath isMirror:false =
(
	t = sliderTime
	dotNet.loadAssembly "system.xml"
	xmlDoc=dotNetObject "system.xml.xmlDocument"

	
	xmlDoc.load xmlPath
	ele = xmlDoc.documentElement.ChildNodes.itemOf[0]
	
	sc = execute (ele.GetAttributeNode "scale").value
	sz = execute (ele.GetAttributeNode "size").value
	
	fnTarget.children[1].scale =sc
	fnTarget.children[1].length = sz[1]
	fnTarget.children[1].width = sz[2]
	--Recurse the XML tree.
	recurseLoads ele fnTarget.children[1] isMirror:isMirror
	
	select fnTarget.children[1]
	FN_renameRoot fnTarget.children[1]
	sliderTime = t+1
	sliderTime = t
)

fn recurseLoads ele fnparent isMirror:false=
(
	for i = 0 to ele.childNodes.count-1 do
	(
		if (ele.ChildNodes.itemOf[i].name == "hub") do
		(
			tr=execute (ele.ChildNodes.itemOf[i].GetAttributeNode "transform").value
			sz=execute (ele.ChildNodes.itemOf[i].GetAttributeNode "size").value
			expr=execute (ele.ChildNodes.itemOf[i].GetAttributeNode "expr").value
			ofst = execute (ele.ChildNodes.itemOf[i].GetAttributeNode "offset").value

			hb = (FN_createHubBone fnparent)
			hb.parentPointHolderG[1].node.modulNameHolder = (ele.ChildNodes.itemOf[i].GetAttributeNode "name").value
			hb.parentPointHolderG[1].node.nodeMirror = execute (ele.ChildNodes.itemOf[i].GetAttributeNode "mr").value
			if isMirror then (tr = mirrorMatrixFn tm:tr pivottm:fnparent.parent.transform)
			hb.transform.controller.value = tr
			hb.scale.controller.X_Scale.controller.Bezier_Float= sz[1]
			hb.scale.controller.Y_Scale.controller.Bezier_Float= sz[2]
			hb.scale.controller.Z_Scale.controller.Bezier_Float= sz[3]
			hb.baseObject[#length].setExprText 1 expr[1]
			hb.baseObject[#width].setExprText 1 expr[2]
			hb.baseObject[#height].setExprText 1 expr[3]
			hb.objectOffsetPos = ofst[1]
			hb.objectOffsetRot = ofst[2]
			hb.objectOffsetScale = ofst[3]
			
			--recurse the xml tree
			recurseLoads ele.ChildNodes.itemOf[i] hb isMirror:isMirror
		)
		if (ele.ChildNodes.itemOf[i].name == "chain") do
		(
			ch = (FN_createChain fnparent)
			FN_createChainBone ch.parentPointHolderG[1].node ele.ChildNodes.itemOf[i].ChildNodes.Count
			tr = execute (ele.ChildNodes.itemOf[i].GetAttributeNode "transform").value
			if isMirror then (tr = mirrorMatrixFn flip:"y" tm:tr)
			ch.parentPointHolderG[1].node.transform.controller.value = tr
			ch.parentPointHolderG[1].node.modulNameHolder = (ele.ChildNodes.itemOf[i].GetAttributeNode "name").value
			ch.parentPointHolderG[1].node.nodeMirror = execute (ele.ChildNodes.itemOf[i].GetAttributeNode "mr").value
			ch.parentPointHolderG[1].node.chType = execute (ele.ChildNodes.itemOf[i].GetAttributeNode "isSpring").value

			for t = 0 to (ele.ChildNodes.itemOf[i].ChildNodes.Count - 1) do
			(
				tr=execute (ele.ChildNodes.itemOf[i].ChildNodes.itemOf[t].GetAttributeNode "transform").value
				sz=execute (ele.ChildNodes.itemOf[i].ChildNodes.itemOf[t].GetAttributeNode "size").value
				expr=execute (ele.ChildNodes.itemOf[i].ChildNodes.itemOf[t].GetAttributeNode "expr").value
				ofst = execute (ele.ChildNodes.itemOf[i].ChildNodes.itemOf[t].GetAttributeNode "offset").value
				if isMirror then (tr = mirrorMatrixFn axis:"y" flip:"y" tm:tr)
				
				ch.parentPointHolderG[1].node.tailBoneHolderG[t+1].node.scale.controller.X_Scale.controller.Bezier_Float= sz[1]
				ch.parentPointHolderG[1].node.tailBoneHolderG[t+1].node.scale.controller.Y_Scale.controller.Bezier_Float= sz[2]
				ch.parentPointHolderG[1].node.tailBoneHolderG[t+1].node.scale.controller.Z_Scale.controller.Bezier_Float= sz[3]
				ch.parentPointHolderG[1].node.tailBoneHolderG[t+1].node.baseObject[#length].setExprText 1 expr[1]
				ch.parentPointHolderG[1].node.tailBoneHolderG[t+1].node.baseObject[#width].setExprText 1 expr[2]
				try(ch.parentPointHolderG[1].node.tailBoneHolderG[t+1].node.baseObject[#height].setExprText 1 expr[3])catch()
				ch.parentPointHolderG[1].node.tailBoneHolderG[t+1].node.transform.controller.value = tr
				ch.parentPointHolderG[1].node.tailBoneHolderG[t+1].node.objectOffsetPos = ofst[1]
				ch.parentPointHolderG[1].node.tailBoneHolderG[t+1].node.objectOffsetRot = ofst[2]
				ch.parentPointHolderG[1].node.tailBoneHolderG[t+1].node.objectOffsetScale = ofst[3]
				--recurse the xml tree
				recurseLoads ele.ChildNodes.itemOf[i].ChildNodes.itemOf[t] ch.parentPointHolderG[1].node.tailBoneHolderG[t+1].node isMirror:isMirror
			)
		)
		
		if (ele.ChildNodes.itemOf[i].name == "arm") do
		(
			arm = FN_createLimbBones fnParent
			
			upperArm = arm.armbonesHolderG[1].node
			foreArm = arm.armbonesHolderG[2].node
			hand = arm.armbonesHolderG[3].node
			pole = arm.armPoleHolderG[2].node
			
			arm.modulNameHolder = (ele.ChildNodes.itemOf[i].GetAttributeNode "name").value
			arm.nodeMirror = execute (ele.ChildNodes.itemOf[i].GetAttributeNode "mr").value
			tr =  execute (ele.ChildNodes.itemOf[i].GetAttributeNode "transform").value
			if isMirror do 
				(
					arm.nodeMirror = not arm.nodeMirror
					tr = mirrorMatrixFn flip:"y" tm:tr
				)
			arm.transform.controller.value = tr
			

			if ele.ChildNodes.itemOf[i].ChildNodes.count == 5 then
			(
				sz=execute (ele.ChildNodes.itemOf[i].ChildNodes.itemOf[4].GetAttributeNode "size").value
				expr=execute (ele.ChildNodes.itemOf[i].ChildNodes.itemOf[4].GetAttributeNode "expr").value
				ofst = execute (ele.ChildNodes.itemOf[i].ChildNodes.itemOf[4].GetAttributeNode "offset").value
				
				clavicle = arm.armbonesHolderG[4].node
				tr = execute (ele.ChildNodes.itemOf[i].ChildNodes.itemOf[4].GetAttributeNode "transform").value
				if isMirror then (tr = mirrorMatrixFn axis:"y" flip:"y" tm:tr; clavicle.rotation.controller.StoUP_axisFlip = on;)
				clavicle.transform.controller.value = tr
				clavicle.scale.controller.Y_Scale.controller.Bezier_Float= sz[1]
				clavicle.scale.controller.Z_Scale.controller.Bezier_Float= sz[2]
				clavicle.baseObject[#length].setExprText 1 expr[1]
				clavicle.baseObject[#width].setExprText 1 expr[2]
				clavicle.objectOffsetPos = ofst[1]
				clavicle.objectOffsetRot = ofst[2]
				clavicle.objectOffsetScale = ofst[3]
				
				pos=execute (ele.ChildNodes.itemOf[i].ChildNodes.itemOf[4].ChildNodes.itemOf[0].GetAttributeNode "pos").value
				rot=execute (ele.ChildNodes.itemOf[i].ChildNodes.itemOf[4].ChildNodes.itemOf[0].GetAttributeNode "rot").value
				clavicle.clavicleUpHolderG[1].node.pos.controller.Y_Position.controller.Limited_Controller__Bezier_Float= pos
				clavicle.clavicleUpHolderG[2].node.rotation.controller.X_Rotation= rot

				recurseLoads ele.ChildNodes.itemOf[i].ChildNodes.itemOf[4] clavicle isMirror:isMirror
				
			)
			else(FN_deleteClavicle arm)

			pole.pos.controller.Y_Position.controller.Limited_Controller__Bezier_Float = execute (ele.ChildNodes.itemOf[i].ChildNodes.itemOf[0].GetAttributeNode "pos").value
			
			tr=execute (ele.ChildNodes.itemOf[i].ChildNodes.itemOf[1].ChildNodes.itemOf[0].GetAttributeNode "transform").value
			if isMirror then (tr = mirrorMatrixFn axis:"y" flip:"y" tm:tr)
			sz=execute (ele.ChildNodes.itemOf[i].ChildNodes.itemOf[1].ChildNodes.itemOf[0].GetAttributeNode "size").value
			expr=execute (ele.ChildNodes.itemOf[i].ChildNodes.itemOf[1].ChildNodes.itemOf[0].GetAttributeNode "expr").value
			ofst = execute (ele.ChildNodes.itemOf[i].ChildNodes.itemOf[1].ChildNodes.itemOf[0].GetAttributeNode "offset").value
			upperArm.transform.controller.value = tr
			upperArm.scale.controller.Y_Scale.controller.Bezier_Float= sz[1]
			upperArm.scale.controller.Z_Scale.controller.Bezier_Float= sz[2]
			upperArm.baseObject[#length].setExprText 1 expr[1]
			upperArm.baseObject[#width].setExprText 1 expr[2]
			upperArm.objectOffsetPos = ofst[1]
			upperArm.objectOffsetRot = ofst[2]
			upperArm.objectOffsetScale = ofst[3]
			recurseLoads ele.ChildNodes.itemOf[i].ChildNodes.itemOf[1].ChildNodes.itemOf[0] upperArm isMirror:isMirror
			
			twistCount = ele.ChildNodes.itemOf[i].ChildNodes.itemOf[1].ChildNodes.count
			
			if twistCount > 0 do
			(
				FN_createTwistBones upperArm twistCount
				twistCount -=1
				for t = 1 to twistCount do
				(
					sz=execute (ele.ChildNodes.itemOf[i].ChildNodes.itemOf[1].ChildNodes.itemOf[t].GetAttributeNode "size").value
					expr=execute (ele.ChildNodes.itemOf[i].ChildNodes.itemOf[1].ChildNodes.itemOf[t].GetAttributeNode "expr").value
					ofst = execute (ele.ChildNodes.itemOf[i].ChildNodes.itemOf[1].ChildNodes.itemOf[t].GetAttributeNode "offset").value
					upperArm.twistBoneHolderG[t].node.scale.controller.Y_Scale.controller.Bezier_Float= sz[1]
					upperArm.twistBoneHolderG[t].node.scale.controller.Z_Scale.controller.Bezier_Float= sz[2]
					upperArm.twistBoneHolderG[t].node.baseObject[#length].setExprText 1 expr[1]
					upperArm.twistBoneHolderG[t].node.baseObject[#width].setExprText 1 expr[2]
					upperArm.twistBoneHolderG[t].node.objectOffsetPos = ofst[1]
					upperArm.twistBoneHolderG[t].node.objectOffsetRot = ofst[2]
					upperArm.twistBoneHolderG[t].node.objectOffsetScale = ofst[3]
					recurseLoads ele.ChildNodes.itemOf[i].ChildNodes.itemOf[1].ChildNodes.itemOf[t] upperArm.twistBoneHolderG[t].node isMirror:isMirror
				)
			)
			
			
			tr=execute (ele.ChildNodes.itemOf[i].ChildNodes.itemOf[2].ChildNodes.itemOf[0].GetAttributeNode "transform").value
			if isMirror then (tr = mirrorMatrixFn axis:"y" flip:"y" tm:tr)
			sz=execute (ele.ChildNodes.itemOf[i].ChildNodes.itemOf[2].ChildNodes.itemOf[0].GetAttributeNode "size").value
			expr=execute (ele.ChildNodes.itemOf[i].ChildNodes.itemOf[2].ChildNodes.itemOf[0].GetAttributeNode "expr").value
			ofst = execute (ele.ChildNodes.itemOf[i].ChildNodes.itemOf[2].ChildNodes.itemOf[0].GetAttributeNode "offset").value
			foreArm.transform.controller.value = tr
			foreArm.scale.controller.Y_Scale.controller.Bezier_Float= sz[1]
			foreArm.scale.controller.Z_Scale.controller.Bezier_Float= sz[2]
			foreArm.baseObject[#length].setExprText 1 expr[1]
			foreArm.baseObject[#width].setExprText 1 expr[2]
			foreArm.objectOffsetPos = ofst[1]
			foreArm.objectOffsetRot = ofst[2]
			foreArm.objectOffsetScale = ofst[3]
			recurseLoads ele.ChildNodes.itemOf[i].ChildNodes.itemOf[2] foreArm isMirror:isMirror
			
			twistCount = ele.ChildNodes.itemOf[i].ChildNodes.itemOf[2].ChildNodes.Count
			
			if twistCount > 0 do
			(
				FN_createTwistBones foreArm twistCount
				twistCount -=1
				for t = 1 to twistCount do
				(
					sz=execute (ele.ChildNodes.itemOf[i].ChildNodes.itemOf[2].ChildNodes.itemOf[t].GetAttributeNode "size").value
					expr=execute (ele.ChildNodes.itemOf[i].ChildNodes.itemOf[2].ChildNodes.itemOf[t].GetAttributeNode "expr").value
					ofst = execute (ele.ChildNodes.itemOf[i].ChildNodes.itemOf[2].ChildNodes.itemOf[t].GetAttributeNode "offset").value
					foreArm.twistBoneHolderG[t].node.scale.controller.Y_Scale.controller.Bezier_Float= sz[1]
					foreArm.twistBoneHolderG[t].node.scale.controller.Z_Scale.controller.Bezier_Float= sz[2]
					foreArm.twistBoneHolderG[t].node.baseObject[#length].setExprText 1 expr[1]
					foreArm.twistBoneHolderG[t].node.baseObject[#width].setExprText 1 expr[2]
					foreArm.twistBoneHolderG[t].node.objectOffsetPos = ofst[1]
					foreArm.twistBoneHolderG[t].node.objectOffsetRot = ofst[2]
					foreArm.twistBoneHolderG[t].node.objectOffsetScale = ofst[3]
					recurseLoads ele.ChildNodes.itemOf[i].ChildNodes.itemOf[2].ChildNodes.itemOf[t] foreArm.twistBoneHolderG[t].node isMirror:isMirror
				)
			)
			
			
			tr=execute (ele.ChildNodes.itemOf[i].ChildNodes.itemOf[3].GetAttributeNode "transform").value
			if isMirror then (tr = mirrorMatrixFn axis:"y" flip:"y" tm:tr)
			sz=execute (ele.ChildNodes.itemOf[i].ChildNodes.itemOf[3].GetAttributeNode "size").value
			expr=execute (ele.ChildNodes.itemOf[i].ChildNodes.itemOf[3].GetAttributeNode "expr").value
			ofst = execute (ele.ChildNodes.itemOf[i].ChildNodes.itemOf[3].GetAttributeNode "offset").value
			hand.transform.controller.value = tr
			hand.scale.controller.X_Scale.controller.Bezier_Float= sz[1]
			hand.scale.controller.Y_Scale.controller.Bezier_Float= sz[2]
			hand.scale.controller.Z_Scale.controller.Bezier_Float= sz[3]
			hand.baseObject[#length].setExprText 1 expr[1]
			hand.baseObject[#width].setExprText 1 expr[2]
			hand.baseObject[#height].setExprText 1 expr[3]
			hand.objectOffsetPos = ofst[1]
			hand.objectOffsetRot = ofst[2]
			hand.objectOffsetScale = ofst[3]
			recurseLoads ele.ChildNodes.itemOf[i].ChildNodes.itemOf[3] hand isMirror:isMirror
			
			fingerCnt = ele.ChildNodes.itemOf[i].ChildNodes.itemOf[3].ChildNodes.count
			FN_createFinger hand fingerCnt 1
			for t = 1 to fingerCnt do
			(
				finger = hand.modulefingerHolderG[t].node
				fBoneCount = ele.ChildNodes.itemOf[i].ChildNodes.itemOf[3].ChildNodes.itemOf[t-1].ChildNodes.count
				FN_createFBone finger fBoneCount
				
				for k = 1 to fBoneCount do
				(
					tr=execute (ele.ChildNodes.itemOf[i].ChildNodes.itemOf[3].ChildNodes.itemOf[t-1].ChildNodes.itemOf[k-1].GetAttributeNode "transform").value
					if isMirror then (tr = mirrorMatrixFn axis:"y" flip:"y" tm:tr)
					sz=execute (ele.ChildNodes.itemOf[i].ChildNodes.itemOf[3].ChildNodes.itemOf[t-1].ChildNodes.itemOf[k-1].GetAttributeNode "size").value
					expr=execute (ele.ChildNodes.itemOf[i].ChildNodes.itemOf[3].ChildNodes.itemOf[t-1].ChildNodes.itemOf[k-1].GetAttributeNode "expr").value
					ofst = execute (ele.ChildNodes.itemOf[i].ChildNodes.itemOf[3].ChildNodes.itemOf[t-1].ChildNodes.itemOf[k-1].GetAttributeNode "offset").value
					finger.fingerBoneHolderG[k].node.transform.controller.value = tr
					finger.fingerBoneHolderG[k].node.scale.controller.X_Scale.controller.Bezier_Float= sz[1]
					finger.fingerBoneHolderG[k].node.scale.controller.Y_Scale.controller.Bezier_Float= sz[2]
					finger.fingerBoneHolderG[k].node.scale.controller.Z_Scale.controller.Bezier_Float= sz[3]
					finger.fingerBoneHolderG[k].node.baseObject[#length].setExprText 1 expr[1]
					finger.fingerBoneHolderG[k].node.baseObject[#width].setExprText 1 expr[2]
					try(finger.fingerBoneHolderG[k].node.baseObject[#height].setExprText 1 expr[3])catch()
					finger.fingerBoneHolderG[k].node.objectOffsetPos = ofst[1]
					finger.fingerBoneHolderG[k].node.objectOffsetRot = ofst[2]
					finger.fingerBoneHolderG[k].node.objectOffsetScale = ofst[3]
					recurseLoads ele.ChildNodes.itemOf[i].ChildNodes.itemOf[3].ChildNodes.itemOf[t-1].ChildNodes.itemOf[k-1] finger.fingerBoneHolderG[k].node isMirror:isMirror
				)
			)
		)
		if (ele.ChildNodes.itemOf[i].name == "leg") do
		(
			arm = FN_createLimbBones fnParent type:1
			
			upperArm = arm.armbonesHolderG[1].node
			foreArm = arm.armbonesHolderG[2].node
			hand = arm.armbonesHolderG[3].node
			toe = arm.legToeHolderG[1].node
			heel = arm.legToeHolderG[2].node
			footIK = arm.legToeHolderG[3].node
			pole = arm.armPoleHolderG[2].node
			
			arm.modulNameHolder = (ele.ChildNodes.itemOf[i].GetAttributeNode "name").value
			arm.nodeMirror = execute (ele.ChildNodes.itemOf[i].GetAttributeNode "mr").value
			arm.transform.controller.value = execute (ele.ChildNodes.itemOf[i].GetAttributeNode "transform").value
			

			if ele.ChildNodes.itemOf[i].ChildNodes.count == 5 then
			(
				FN_addClavicle arm
				sz=execute (ele.ChildNodes.itemOf[i].ChildNodes.itemOf[4].GetAttributeNode "size").value
				expr=execute (ele.ChildNodes.itemOf[i].ChildNodes.itemOf[4].GetAttributeNode "expr").value
				ofst = execute (ele.ChildNodes.itemOf[i].ChildNodes.itemOf[4].GetAttributeNode "offset").value
				clavicle = arm.armbonesHolderG[5].node
				clavicle.transform.controller.value = execute (ele.ChildNodes.itemOf[i].ChildNodes.itemOf[4].GetAttributeNode "transform").value
				clavicle.scale.controller.Y_Scale.controller.Bezier_Float= sz[1]
				clavicle.scale.controller.Z_Scale.controller.Bezier_Float= sz[2]
				clavicle.baseObject[#length].setExprText 1 expr[1]
				clavicle.baseObject[#width].setExprText 1 expr[2]
				clavicle.objectOffsetPos = ofst[1]
				clavicle.objectOffsetRot = ofst[2]
				clavicle.objectOffsetScale = ofst[3]
				
				pos=execute (ele.ChildNodes.itemOf[i].ChildNodes.itemOf[4].ChildNodes.itemOf[0].GetAttributeNode "pos").value
				rot=execute (ele.ChildNodes.itemOf[i].ChildNodes.itemOf[4].ChildNodes.itemOf[0].GetAttributeNode "rot").value
				clavicle.clavicleUpHolderG[1].node.pos.controller.Y_Position.controller.Limited_Controller__Bezier_Float= pos
				clavicle.clavicleUpHolderG[2].node.rotation.controller.X_Rotation= rot
				
				recurseLoads ele.ChildNodes.itemOf[i].ChildNodes.itemOf[4] clavicle
				
			)

			pole.pos.controller.Y_Position.controller.Limited_Controller__Bezier_Float = execute (ele.ChildNodes.itemOf[i].ChildNodes.itemOf[0].GetAttributeNode "pos").value
			
			tr=execute (ele.ChildNodes.itemOf[i].ChildNodes.itemOf[1].ChildNodes.itemOf[0].GetAttributeNode "transform").value
			sz=execute (ele.ChildNodes.itemOf[i].ChildNodes.itemOf[1].ChildNodes.itemOf[0].GetAttributeNode "size").value
			expr=execute (ele.ChildNodes.itemOf[i].ChildNodes.itemOf[1].ChildNodes.itemOf[0].GetAttributeNode "expr").value
			ofst = execute (ele.ChildNodes.itemOf[i].ChildNodes.itemOf[1].ChildNodes.itemOf[0].GetAttributeNode "offset").value
			upperArm.transform.controller.value = tr
			upperArm.scale.controller.Y_Scale.controller.Bezier_Float= sz[1]
			upperArm.scale.controller.Z_Scale.controller.Bezier_Float= sz[2]
			upperArm.baseObject[#length].setExprText 1 expr[1]
			upperArm.baseObject[#width].setExprText 1 expr[2]
			upperArm.objectOffsetPos = ofst[1]
			upperArm.objectOffsetRot = ofst[2]
			upperArm.objectOffsetScale = ofst[3]
			recurseLoads ele.ChildNodes.itemOf[i].ChildNodes.itemOf[1].ChildNodes.itemOf[0] upperArm
			
			twistCount = ele.ChildNodes.itemOf[i].ChildNodes.itemOf[1].ChildNodes.count
			
			if twistCount > 0 do
			(
				FN_createTwistBones upperArm twistCount
				twistCount -=1
				for t = 1 to twistCount do
				(
					sz=execute (ele.ChildNodes.itemOf[i].ChildNodes.itemOf[1].ChildNodes.itemOf[t].GetAttributeNode "size").value
					expr=execute (ele.ChildNodes.itemOf[i].ChildNodes.itemOf[1].ChildNodes.itemOf[t].GetAttributeNode "expr").value
					ofst = execute (ele.ChildNodes.itemOf[i].ChildNodes.itemOf[1].ChildNodes.itemOf[t].GetAttributeNode "offset").value
					upperArm.twistBoneHolderG[t].node.scale.controller.Y_Scale.controller.Bezier_Float= sz[1]
					upperArm.twistBoneHolderG[t].node.scale.controller.Z_Scale.controller.Bezier_Float= sz[2]
					upperArm.twistBoneHolderG[t].node.baseObject[#length].setExprText 1 expr[1]
					upperArm.twistBoneHolderG[t].node.baseObject[#width].setExprText 1 expr[2]
					upperArm.twistBoneHolderG[t].node.objectOffsetPos = ofst[1]
					upperArm.twistBoneHolderG[t].node.objectOffsetRot = ofst[2]
					upperArm.twistBoneHolderG[t].node.objectOffsetScale = ofst[3]
					recurseLoads ele.ChildNodes.itemOf[i].ChildNodes.itemOf[1].ChildNodes.itemOf[t] upperArm.twistBoneHolderG[t].node
				)
			)
			
			
			tr=execute (ele.ChildNodes.itemOf[i].ChildNodes.itemOf[2].ChildNodes.itemOf[0].GetAttributeNode "transform").value
			sz=execute (ele.ChildNodes.itemOf[i].ChildNodes.itemOf[2].ChildNodes.itemOf[0].GetAttributeNode "size").value
			expr=execute (ele.ChildNodes.itemOf[i].ChildNodes.itemOf[2].ChildNodes.itemOf[0].GetAttributeNode "expr").value
			ofst = execute (ele.ChildNodes.itemOf[i].ChildNodes.itemOf[2].ChildNodes.itemOf[0].GetAttributeNode "offset").value
			foreArm.transform.controller.value = tr
			foreArm.scale.controller.Y_Scale.controller.Bezier_Float= sz[1]
			foreArm.scale.controller.Z_Scale.controller.Bezier_Float= sz[2]
			foreArm.baseObject[#length].setExprText 1 expr[1]
			foreArm.baseObject[#width].setExprText 1 expr[2]
			foreArm.objectOffsetPos = ofst[1]
			foreArm.objectOffsetRot = ofst[2]
			foreArm.objectOffsetScale = ofst[3]
			recurseLoads ele.ChildNodes.itemOf[i].ChildNodes.itemOf[2] foreArm
			
			twistCount = ele.ChildNodes.itemOf[i].ChildNodes.itemOf[2].ChildNodes.Count
			
			if twistCount > 0 do
			(
				FN_createTwistBones foreArm twistCount
				twistCount -=1
				for t = 1 to twistCount do
				(
					sz=execute (ele.ChildNodes.itemOf[i].ChildNodes.itemOf[2].ChildNodes.itemOf[t].GetAttributeNode "size").value
					expr=execute (ele.ChildNodes.itemOf[i].ChildNodes.itemOf[2].ChildNodes.itemOf[t].GetAttributeNode "expr").value
					ofst = execute (ele.ChildNodes.itemOf[i].ChildNodes.itemOf[2].ChildNodes.itemOf[t].GetAttributeNode "offset").value
					foreArm.twistBoneHolderG[t].node.scale.controller.Y_Scale.controller.Bezier_Float= sz[1]
					foreArm.twistBoneHolderG[t].node.scale.controller.Z_Scale.controller.Bezier_Float= sz[2]
					foreArm.twistBoneHolderG[t].node.baseObject[#length].setExprText 1 expr[1]
					foreArm.twistBoneHolderG[t].node.baseObject[#width].setExprText 1 expr[2]
					foreArm.twistBoneHolderG[t].node.objectOffsetPos = ofst[1]
					foreArm.twistBoneHolderG[t].node.objectOffsetRot = ofst[2]
					foreArm.twistBoneHolderG[t].node.objectOffsetScale = ofst[3]
					recurseLoads ele.ChildNodes.itemOf[i].ChildNodes.itemOf[2].ChildNodes.itemOf[t] foreArm.twistBoneHolderG[t].node
				)
			)
			
			
			tr=execute (ele.ChildNodes.itemOf[i].ChildNodes.itemOf[3].GetAttributeNode "transform").value
			sz=execute (ele.ChildNodes.itemOf[i].ChildNodes.itemOf[3].GetAttributeNode "size").value
			expr=execute (ele.ChildNodes.itemOf[i].ChildNodes.itemOf[3].GetAttributeNode "expr").value
			ofst = execute (ele.ChildNodes.itemOf[i].ChildNodes.itemOf[3].GetAttributeNode "offset").value
			hand.transform.controller.value = tr
			hand.scale.controller.Y_Scale.controller.Bezier_Float= sz[1]
			hand.scale.controller.Z_Scale.controller.Bezier_Float= sz[2]
			hand.baseObject[#length].setExprText 1 expr[1]
			hand.baseObject[#width].setExprText 1 expr[2]
			hand.objectOffsetPos = ofst[1]
			hand.objectOffsetRot = ofst[2]
			hand.objectOffsetScale = ofst[3]
			recurseLoads ele.ChildNodes.itemOf[i].ChildNodes.itemOf[3] hand
			
			tr=execute (ele.ChildNodes.itemOf[i].ChildNodes.itemOf[3].ChildNodes.itemOf[0].GetAttributeNode "transform").value
			sz=execute (ele.ChildNodes.itemOf[i].ChildNodes.itemOf[3].ChildNodes.itemOf[0].GetAttributeNode "size").value
			expr=execute (ele.ChildNodes.itemOf[i].ChildNodes.itemOf[3].ChildNodes.itemOf[0].GetAttributeNode "expr").value
-- 			ofst = execute (ele.ChildNodes.itemOf[i].ChildNodes.itemOf[3].ChildNodes.itemOf[0].GetAttributeNode "offset").value
			heel.transform.controller.value = tr
			heel.scale.controller.X_Scale.controller.Bezier_Float= sz[1]
			heel.scale.controller.Y_Scale.controller.Bezier_Float= sz[2]
			heel.scale.controller.Z_Scale.controller.Bezier_Float= sz[3]
			heel.baseObject[#length].setExprText 1 expr[1]
			heel.baseObject[#width].setExprText 1 expr[2]
			heel.baseObject[#height].setExprText 1 expr[3]
			recurseLoads ele.ChildNodes.itemOf[i].ChildNodes.itemOf[3].ChildNodes.itemOf[0] heel
			
			tr=execute (ele.ChildNodes.itemOf[i].ChildNodes.itemOf[3].ChildNodes.itemOf[1].GetAttributeNode "transform").value
			sz=execute (ele.ChildNodes.itemOf[i].ChildNodes.itemOf[3].ChildNodes.itemOf[1].GetAttributeNode "size").value
			expr=execute (ele.ChildNodes.itemOf[i].ChildNodes.itemOf[3].ChildNodes.itemOf[1].GetAttributeNode "expr").value
			ofst = execute (ele.ChildNodes.itemOf[i].ChildNodes.itemOf[3].ChildNodes.itemOf[1].GetAttributeNode "offset").value
			footIK.transform.controller.value = tr
			footIK.scale.controller.X_Scale.controller.Bezier_Float= sz[1]
			footIK.scale.controller.Z_Scale.controller.Bezier_Float= sz[2]
			footIK.baseObject[#length].setExprText 1 expr[1]
			footIK.baseObject[#width].setExprText 1 expr[2]
			footIK.objectOffsetPos = ofst[1]
			footIK.objectOffsetRot = ofst[2]
			footIK.objectOffsetScale = ofst[3]
			footIK.cornerRadius = execute expr[3]
			recurseLoads ele.ChildNodes.itemOf[i].ChildNodes.itemOf[3].ChildNodes.itemOf[1] footIK
-- 			
			tr=execute (ele.ChildNodes.itemOf[i].ChildNodes.itemOf[3].ChildNodes.itemOf[2].GetAttributeNode "transform").value
			sz=execute (ele.ChildNodes.itemOf[i].ChildNodes.itemOf[3].ChildNodes.itemOf[2].GetAttributeNode "size").value
			expr=execute (ele.ChildNodes.itemOf[i].ChildNodes.itemOf[3].ChildNodes.itemOf[2].GetAttributeNode "expr").value
			ofst = execute (ele.ChildNodes.itemOf[i].ChildNodes.itemOf[3].ChildNodes.itemOf[2].GetAttributeNode "offset").value
			toe.transform.controller.value = tr
			toe.scale.controller.X_Scale.controller.Bezier_Float= sz[1]
			toe.scale.controller.Y_Scale.controller.Bezier_Float= sz[2]
			toe.scale.controller.Z_Scale.controller.Bezier_Float= sz[3]
			toe.baseObject[#length].setExprText 1 expr[1]
			toe.baseObject[#width].setExprText 1 expr[2]
			toe.baseObject[#height].setExprText 1 expr[3]
			toe.objectOffsetPos = ofst[1]
			toe.objectOffsetRot = ofst[2]
			toe.objectOffsetScale = ofst[3]
			recurseLoads ele.ChildNodes.itemOf[i].ChildNodes.itemOf[3].ChildNodes.itemOf[2] toe
			
			fingerCnt = ele.ChildNodes.itemOf[i].ChildNodes.itemOf[3].ChildNodes.itemOf[2].ChildNodes.count
			FN_createFinger hand fingerCnt 1
			
			for t = 1 to fingerCnt do
			(
				finger = hand.modulefingerHolderG[t].node
				
				fBoneCount = ele.ChildNodes.itemOf[i].ChildNodes.itemOf[3].ChildNodes.itemOf[2].ChildNodes.itemOf[t-1].ChildNodes.count
				FN_createFBone finger fBoneCount
				
				for k = 1 to fBoneCount do
				(
					tr=execute (ele.ChildNodes.itemOf[i].ChildNodes.itemOf[3].ChildNodes.itemOf[2].ChildNodes.itemOf[t-1].ChildNodes.itemOf[k-1].GetAttributeNode "transform").value
					sz=execute (ele.ChildNodes.itemOf[i].ChildNodes.itemOf[3].ChildNodes.itemOf[2].ChildNodes.itemOf[t-1].ChildNodes.itemOf[k-1].GetAttributeNode "size").value
					expr=execute (ele.ChildNodes.itemOf[i].ChildNodes.itemOf[3].ChildNodes.itemOf[2].ChildNodes.itemOf[t-1].ChildNodes.itemOf[k-1].GetAttributeNode "expr").value
					ofst = execute (ele.ChildNodes.itemOf[i].ChildNodes.itemOf[3].ChildNodes.itemOf[2].ChildNodes.itemOf[t-1].ChildNodes.itemOf[k-1].GetAttributeNode "offset").value
					finger.fingerBoneHolderG[k].node.transform.controller.value = tr
					finger.fingerBoneHolderG[k].node.scale.controller.X_Scale.controller.Bezier_Float= sz[1]
					finger.fingerBoneHolderG[k].node.scale.controller.Y_Scale.controller.Bezier_Float= sz[2]
					finger.fingerBoneHolderG[k].node.scale.controller.Z_Scale.controller.Bezier_Float= sz[3]
					finger.fingerBoneHolderG[k].node.baseObject[#length].setExprText 1 expr[1]
					finger.fingerBoneHolderG[k].node.baseObject[#width].setExprText 1 expr[2]
					try(finger.fingerBoneHolderG[k].node.baseObject[#height].setExprText 1 expr[3])catch()
					finger.fingerBoneHolderG[k].node.objectOffsetPos = ofst[1]
					finger.fingerBoneHolderG[k].node.objectOffsetRot = ofst[2]
					finger.fingerBoneHolderG[k].node.objectOffsetScale = ofst[3]
					recurseLoads ele.ChildNodes.itemOf[i].ChildNodes.itemOf[3].ChildNodes.itemOf[2].ChildNodes.itemOf[t-1].ChildNodes.itemOf[k-1] finger.fingerBoneHolderG[k].node
				)
			)
		)
		if (ele.ChildNodes.itemOf[i].name == "spine") do
		(
			spine =  FN_createSpine fnParent
			spineEnd = spine.spineEndHolderG[1].node
			chest = spine.chestHolderG[1].node
			
			spine.modulNameHolder = (ele.ChildNodes.itemOf[i].GetAttributeNode "name").value
			spine.nodeMirror = execute (ele.ChildNodes.itemOf[i].GetAttributeNode "mr").value
			spine.transform.controller.value = execute (ele.ChildNodes.itemOf[i].GetAttributeNode "transform").value
			spine.middleCheck = execute (ele.ChildNodes.itemOf[i].GetAttributeNode "mCheck").value
			
			spineEnd.transform.controller.value = execute (ele.ChildNodes.itemOf[i].ChildNodes.itemOf[0].GetAttributeNode "transform").value
			sz=execute (ele.ChildNodes.itemOf[i].ChildNodes.itemOf[0].GetAttributeNode "size").value
			expr=execute (ele.ChildNodes.itemOf[i].ChildNodes.itemOf[0].GetAttributeNode "expr").value
			ofst = execute (ele.ChildNodes.itemOf[i].ChildNodes.itemOf[0].GetAttributeNode "offset").value
			spineEnd.scale.controller.X_Scale.controller.Bezier_Float= sz[1]
			spineEnd.scale.controller.Y_Scale.controller.Bezier_Float= sz[2]
			spineEnd.scale.controller.Z_Scale.controller.Bezier_Float= sz[3]
			spineEnd.baseObject[#length].setExprText 1 expr[1]
			spineEnd.baseObject[#width].setExprText 1 expr[2]
			spineEnd.baseObject[#height].setExprText 1 expr[3]
			spineEnd.objectOffsetPos = ofst[1]
			spineEnd.objectOffsetRot = ofst[2]
			spineEnd.objectOffsetScale = ofst[3]
			
			chest.transform.controller.value = execute (ele.ChildNodes.itemOf[i].ChildNodes.itemOf[1].GetAttributeNode "transform").value
			sz=execute (ele.ChildNodes.itemOf[i].ChildNodes.itemOf[1].GetAttributeNode "size").value
			expr=execute (ele.ChildNodes.itemOf[i].ChildNodes.itemOf[1].GetAttributeNode "expr").value
			ofst = execute (ele.ChildNodes.itemOf[i].ChildNodes.itemOf[1].GetAttributeNode "offset").value
			chest.scale.controller.X_Scale.controller.Bezier_Float= sz[1]
			chest.scale.controller.Y_Scale.controller.Bezier_Float= sz[2]
			chest.scale.controller.Z_Scale.controller.Bezier_Float= sz[3]
			chest.baseObject[#length].setExprText 1 expr[1]
			chest.baseObject[#width].setExprText 1 expr[2]
			chest.baseObject[#height].setExprText 1 expr[3]
			chest.objectOffsetPos = ofst[1]
			chest.objectOffsetRot = ofst[2]
			chest.objectOffsetScale = ofst[3]
			recurseLoads ele.ChildNodes.itemOf[i].ChildNodes.itemOf[1] chest
			
			FN_createSpineBones chest ele.ChildNodes.itemOf[i].ChildNodes.itemOf[2].ChildNodes.count
			for t = 0 to ele.ChildNodes.itemOf[i].ChildNodes.itemOf[2].ChildNodes.count-1 do
			(
				spineBone = spine.spineHolderG[t+1].node
				spineBone.pos.controller.Position_XYZ.value = execute (ele.ChildNodes.itemOf[i].ChildNodes.itemOf[2].ChildNodes.itemOf[t].GetAttributeNode "pos").value
				sz=execute (ele.ChildNodes.itemOf[i].ChildNodes.itemOf[2].ChildNodes.itemOf[t].GetAttributeNode "size").value
				expr=execute (ele.ChildNodes.itemOf[i].ChildNodes.itemOf[2].ChildNodes.itemOf[t].GetAttributeNode "expr").value
				ofst = execute (ele.ChildNodes.itemOf[i].ChildNodes.itemOf[2].ChildNodes.itemOf[t].GetAttributeNode "offset").value
				spineBone.scale.controller.Y_Scale.controller.Bezier_Float= sz[1]
				spineBone.scale.controller.Z_Scale.controller.Bezier_Float= sz[2]
				spineBone.baseObject[#length].setExprText 1 expr[1]
				spineBone.baseObject[#width].setExprText 1 expr[2]
				spineBone.objectOffsetPos = ofst[1]
				spineBone.objectOffsetRot = ofst[2]
				spineBone.objectOffsetScale = ofst[3]
				recurseLoads ele.ChildNodes.itemOf[i].ChildNodes.itemOf[2].ChildNodes.itemOf[t] spineBone
			)
		)
	)
)

fn FNgetDelNodes=
(
	deletedObj = callbacks.notificationParam()
	delNodes = #()
	try 
	(
		if deletedObj.isFinger then deletedNodeModule = deletedObj.parentPointHolderG[1].node.parentPointHolderG[1].node.parentPointHolderG[1].node
		else deletedNodeModule = deletedObj.parentPointHolderG[1].node
		set animate off
		FN_deleteModule deletedNodeModule
		deleteItem delNodes (finditem delNodes deletedObj)
		delPost = true
	)
	catch (delPost = false)
)
fn FNdeleteManual=
(
	if delPost do
	(
	delPost = false
	callbacks.removeScripts id:#getDelNodes
	callbacks.removeScripts id:#deleteManual
	with undo off
	(
		gc()
		delete delNodes
		try (LayerManager.deleteLayerByName (rName + "_hiddenNodes")) catch()
		try (LayerManager.deleteLayerByName (rName + "_controllers")) catch()
		try (LayerManager.deleteLayerByName (rName + "_bones")) catch()
	)
	callbacks.addScript #nodepreDelete "FNdeleteManual()" id:#deleteManual
	callbacks.addScript #nodepreDelete "FNgetDelNodes()" id:#getDelNodes
	clearUndoBuffer()
	gc()
	)
)

rollout deleteModule "Delete Module"
(
	button delMod "Delete" align:#center width:155 height:25
	on delMod pressed do
	(
		set animate off
-- 		setCommandPanelTaskMode #modify
		delNodes = #()
		FN_deleteModule selection[1].parentPointHolderG[1].node
		callbacks.removeScripts id:#getDelNodes
		callbacks.removeScripts id:#deleteManual
		with undo off
		(
			gc()
			delete delNodes
			try (LayerManager.deleteLayerByName (rName + "_hiddenNodes")) catch()
			try (LayerManager.deleteLayerByName (rName + "_controllers")) catch()
			try (LayerManager.deleteLayerByName (rName + "_bones")) catch()
		)
		callbacks.addScript #nodepreDelete "FNdeleteManual()" id:#deleteManual
		callbacks.addScript #nodepreDelete "FNgetDelNodes()" id:#getDelNodes
		clearUndoBuffer()
		gc()
	)
)
rollout middleRoll "Placing" 
(
	spinner middleRow "Row: " pos:[35,8] width:50 height:16 range:[2,15,2] type:#integer
	
	on middleRow changed val do
	(
		set animate off
-- 		setCommandPanelTaskMode #modify
		with undo off 
		(	
			FN_changeMiddle selection[1] middleRow.value
		)
	)

)
rollout nameAtts "Module Name"
(
	editText moduleName "" align:#center width:160 height:17
	
	on moduleName entered txt do
	(
		with undo off
		(
			moduleName.text = charMap txt
			selection[1].parentPointHolderG[1].node.modulNameHolder = moduleName.text
			try (FN_renameRoot selection[1].rootNodeHolderG[1].node) catch()
		)
	)
)

rollout spineCounterRoll "Spine Attributes"
(
	spinner spineCounterSpin "Bones: " pos:[30,5] width:50 height:16 range:[1,8,1] type:#integer
	checkbox middleCheck "Pivot at Middle" pos:[90,6] width:94 height:14
	
	on moduleName entered txt do
	(
		with undo off
		(
			selection[1].parentPointHolderG[1].node.modulNameHolder = moduleName.text
			try (FN_renameRoot selection[1].rootNodeHolderG[1].node) catch()
		)
	)
	
	on middleCheck changed theState do
	(
		set animate off
-- 		setCommandPanelTaskMode #modify
		with undo off
		(
			if theState == true then (selection[1].parentPointHolderG[1].node.middleCheck = true)
			else (selection[1].parentPointHolderG[1].node.middleCheck = false)
			FN_renameRoot selection[1].rootNodeHolderG[1].node
		)
	)
		
	on spineCounterRoll open do
	(
		with undo off spineCounterSpin.value = selection[1].spineHolderG.count
	)
	on spineCounterSpin changed val do
	(
		set animate off
-- 		setCommandPanelTaskMode #modify
		with undo off FN_createSpineBones selection[1] spineCounterSpin.value
	)
)
rollout chain_attributes "Chain Attributes" width:181 height:112
(
	group "Copy / Paste"
		(
			button copyBtn "Copy"  pos:[15,25] width:45 height:20
			button pasteBtn "Paste"  pos:[63,25] width:45 height:20 enabled:false
			button pmBtn "Paste Mirror"  pos:[110,25] width:65 height:20 enabled:false
		)		
	spinner tailBoneCount "Bone:  " pos:[30,60] width:50 height:16 range:[1,16,1] type:#integer 
	radioButtons chType "" pos:[90,60] width:121 height:16 labels:#("Spring" , "FK") default:2 columns:2
	
-- 	groupBox grpPM "Paste Axis" pos:[7,30] width:180 height:35
-- 	radiobuttons pmAxis "" pos:[10,45] width:97 height:16 labels:#("N     ", "X   ", "Y   ", "Z   ") columns:4 default:1 enabled:false
	
	on copyBtn pressed do
	(
		with undo off
		(
			FN_copyChain selection[1].parentPointHolderG[1].node
			pasteBtn.enabled = true	
			pmBtn.enabled = true
		)
	)
	on pasteBtn pressed do
	(
		set animate off
-- 		setCommandPanelTaskMode #modify
		with undo off FN_pasteChain selection[1].parentPointHolderG[1].node tailsPosArray;
	)
	on pmBtn pressed do
	(
		set animate off
-- 		setCommandPanelTaskMode #modify
		with undo off FN_pasteChain selection[1].parentPointHolderG[1].node tailsPosArray PmAxis:true;
	)
	on tailBoneCount changed val do
	(
		set animate off
-- 		setCommandPanelTaskMode #modify
		with undo off FN_createChainBone selection[1].parentPointHolderG[1].node tailBoneCount.value;
	)
	on chType changed state do
	(
		with undo off selection[1].parentPointHolderG[1].node.chType = state
	)
)
rollout finger_attributes "Finger Attributes" width:162 height:49
(

	button copyBtn "Copy" pos:[10,6] width:40 height:20
	button pasteBtn "Paste" pos:[55,6] width:40 height:20 enabled:false
	spinner fingerBoneCount "Bone: " pos:[120,9] width:50 height:16 range:[1,8,1] type:#integer 
 
	on fingerBoneCount changed val do
	(
		set animate off
-- 		setCommandPanelTaskMode #modify
		with undo off FN_createFBone selection[1].parentPointHolderG[1].node fingerBoneCount.value;
	)
	
	on copyBtn pressed do
	(
		with undo off
		(
			FN_copyFinger selection[1].parentPointHolderG[1].node
			pasteBtn.enabled = true
		)
	)
	
	on pasteBtn pressed do
	(
		set animate off
-- 		setCommandPanelTaskMode #modify
		with undo off FN_pasteFinger selection[1].parentPointHolderG[1].node returnArray rollUpdate:1;
	)
)
rollout hand_attributes "Hand Attributes" width:162 height:46
(
	group "Copy / Paste"
		(
		button copyBtn "Copy" pos:[10,25] width:80 height:20
		button pasteBtn "Paste" pos:[95,25] width:80 height:20 enabled:false
		)
	group "Attributes"
		(
		spinner fingerCount "Finger: " pos:[35,75] width:50 height:16 range:[0,8,0] type:#integer 
		spinner fingerBoneCount "Bone: " pos:[120,75] width:50 height:16 range:[1,8,1] type:#integer 
		)
	on copyBtn pressed do
	(
		with undo off
		(
			FN_copyHand selection[1]
			pasteBtn.enabled = true
		)
	)
	on pasteBtn pressed do
	(
		set animate off
-- 		setCommandPanelTaskMode #modify
		with undo off FN_pasteHand selection[1] rollUpdate:1;
	)

	on fingerCount changed val do
	(
		set animate off
-- 		setCommandPanelTaskMode #modify
		with undo off FN_createFinger selection[1] fingerCount.value fingerBoneCount.value;
	)
	on fingerBoneCount changed val do
	(
		set animate off
-- 		setCommandPanelTaskMode #modify
		with undo off FN_createFinger selection[1] fingerCount.value fingerBoneCount.value;
	)
)
rollout limb_attributes "Limb Attributes"
(
	group "Copy / Paste"
		(
			button copyBtn "Copy"  pos:[15,25] width:45 height:20
			button pasteBtn "Paste"  pos:[63,25] width:45 height:20 enabled:false
			button pmBtn "Paste Mirror"  pos:[110,25] width:65 height:20 enabled:false
		)				
	group "Clavicle"
		(
			checkbox clavicleChk "clavicle " align:#left width:61 height:17 checked:true
		)
	group "Twist Bones"
		(
			spinner upperTwist "Upper" align:#Left width:50 height:16 type:#integer range:[1,8,1]
			spinner foreTwist "Lower" pos:[110,122] width:50 height:16 type:#integer range:[1,8,1]
		)
		
	on upperTwist changed val do
	(
		set animate off
-- 		setCommandPanelTaskMode #modify
		with undo off FN_createTwistBones selection[1].parentPointHolderG[1].node.armBonesHolderG[1].node upperTwist.value;
	)
	on foreTwist changed val do
	(
		set animate off
-- 		setCommandPanelTaskMode #modify
		with undo off FN_createTwistBones selection[1].parentPointHolderG[1].node.armBonesHolderG[2].node foreTwist.value;
	)
		
	on clavicleChk changed theState do
	(
		if theState == true then
			(
				set animate off
-- 				setCommandPanelTaskMode #modify
				with undo off FN_addClavicle selection[1].parentPointHolderG[1].node;
			)
		if theState == false then
			(
				set animate off
-- 				setCommandPanelTaskMode #modify
				with undo off FN_deleteClavicle selection[1].parentPointHolderG[1].node
			)
	)
	on copyBtn pressed do
	(
		with undo off
		(
			FN_CopyLimb selection[1].parentPointHolderG[1].node
			pmBtn.enabled = true
			pasteBtn.enabled = true
		)
		
	)
	on pasteBtn pressed do
	(
		set animate off
-- 		setCommandPanelTaskMode #modify
		with undo off FN_PasteMirrorLimb selection[1].parentPointHolderG[1].node;
	)
	
	on pmBtn pressed do
	(
		set animate off
-- 		setCommandPanelTaskMode #modify
		with undo off FN_PasteMirrorLimb selection[1].parentPointHolderG[1].node PmAxis:True;
	)
									
)
---------- Create base node and selection callback
rollout creditRoll "InstantRig 1.52"
(
	checkbutton dckL "<" align:#left offset:[-10, -5] checked:true tooltip:"Dockable" width:80 height:15
	checkbutton dckR ">" align:#left offset:[91,-20] checked:false tooltip:"Dockable" width:80 height:15
	Button _help  "?" align:#left offset:[70, -20]  height:15 tooltip:"InstantRig User Manual"
	hyperLink fck "by Firat KIRAL" align:#center color:[255,255,255] hoverColor:[255,130,0] address:"http://www.kiral.org"
	hyperLink irig  "www.instantrig.com" align:#center color:[255,255,255] hoverColor:[255,130,0] address:"http://www.instantrig.com"
	
	
	on _help pressed do ShellLaunch "http://docs.instantrig.com" ""
	
	on dckL changed state do 
	(
		if state then
		(
			dckR.state = false
			cui.RegisterDialogBar instantRigFloater minSize:[205,100] maxSize:[205,600] style:#(#cui_max_sized, #cui_dock_all, #cui_floatable, #cui_handles) 
			cui.DockDialogBar instantRigFloater #cui_dock_left
-- 			cui.floatdialogbar iPicker
		)
		else
		(
-- 			cui.floatdialogbar iPicker
			cui.UnRegisterDialogBar instantRigFloater
		)
	)
	on dckR changed state do 
	(
		if state then
		(
			dckL.state = false
			cui.RegisterDialogBar instantRigFloater minSize:[205,100] maxSize:[205,600] style:#(#cui_max_sized, #cui_dock_all, #cui_floatable, #cui_handles) 
			cui.DockDialogBar instantRigFloater #cui_dock_right
-- 			cui.floatdialogbar iPicker
		)
		else
		(
-- 			cui.floatdialogbar iPicker
			cui.UnRegisterDialogBar instantRigFloater
		)
	)
)
rollout processRoll ""
(
	label bldLab "              Processing..." align:#left
	timer clock "testClock" interval:500 --tick once a second
	local cnt = 0
	on clock tick do
	(
		if (mod cnt 3) == 0 do bldLab.text = "              Processing."
		if (mod cnt 3) == 1 do bldLab.text = "              Processing.."
		if (mod cnt 3) == 2 do bldLab.text = "              Processing..."
		cnt+=1
	)
)
rollout processDelRoll ""
(
	label bldLab "Finding and Removing Rigs..." align:#center
	timer clock "testClock" interval:500 --tick once a second
	local cnt = 0
	on clock tick do
	(
		if (mod cnt 3) == 0 do bldLab.text = "Finding and Removing Rigs..."
		if (mod cnt 3) == 1 do bldLab.text = "Finding and Removing Rigs..."
		if (mod cnt 3) == 2 do bldLab.text = "Finding and Removing Rigs..."
		cnt+=1
	)
)
rollout startupRoll "Main Parameters"
(
on startupRoll open do
	(
		callbacks.addScript #nodepreDelete "FNgetDelNodes()" id:#getDelNodes
		callbacks.addScript #nodepostDelete "FNdeleteManual()" id:#deleteManual
		callbacks.addScript #selectionSetChanged "FN_SELcallback instantRigFloater" id:#Rollout_Update
		try
			(		
				rName = selection[1].rootNodeHolderG[1].node.nameHolderG
				startupRoll.rigNameText.text = rName 
			)catch (startupRoll.rigNameText.text=""; rName ="")
			
		if fktur do
		(
			callbacks.removeScripts id:#deleteAllp
			callbacks.addScript #filePreSaveProcess "deleteAll()" id:#deleteAllp
			messageBox "InstantRig trial version. Rigs cannot be saved. Be sure autoback is turned off."
		)
	)
on startupRoll close do
	(
		callbacks.removeScripts id:#getDelNodes
		callbacks.removeScripts id:#deleteManual
		callbacks.removeScripts id:#Rollout_Update
		if fktur do
		(
		deleteAll()
		callbacks.removeScripts id:#deleteAllp
		)
	)
	group "Prefix" 
	(
		editText rigNameText "" align:#center width:80 height:17 pos:[10,20]
		button startBtn "Create Root" align:#center width:80 height:20  pos:[100,20]
	)

	button saveRig "Save" pos:[10,50] align:#center width:80 height:20 enabled:false
	button loadRig "Load" pos:[100,50] align:#center width:80 height:20 enabled:false

	button buildBtn "Build Rig" width:170 height:20 enabled:false pos:[10,75]
	label bldLab "                   Processing..." visible:false width:164 height:14 pos:[13,78]

	on saveRig pressed do
	(
		FN_copyModule selection[1].rootNodeHolderG[1].node.parentpointholderg[1].node
	)
	
	on loadRig pressed do
	(
		xmlPath = getOpenFileName caption:"Load From File:" types:"XML(*.xml)|*.xml|"
		if xmlPath == undefined do (return false)
		createDialog processRoll style:#(#style_border)
		disableSceneRedraw()
		callbacks.removeScripts id:#getDelNodes
		callbacks.removeScripts id:#deleteManual
		callbacks.removeScripts id:#Rollout_Update -- spine build ederken bi ara spline sectigi için rName = "" oluyor. Bu yüzden callback kapatip açilir.
		if loadSaveFloater != undefined and loadSaveFloater.open do (callbacks.removeScripts id:#savLoadUpdate)
		pn = selection[1].parentpointholderg[1].node.rootNodeHolderG[1].node.parentpointholderg[1].node

		set animate off
		setCommandPanelTaskMode #create
		
		for i in selection[1].rootNodeHolderG[1].node.moduleHubHolderG do
		(
			with undo off 
			(
				delNodes = #()
				FN_deleteModule i.node
				gc()
				delete delNodes
				try (LayerManager.deleteLayerByName (rName + "_hiddenNodes")) catch()
				try (LayerManager.deleteLayerByName (rName + "_controllers")) catch()
				try (LayerManager.deleteLayerByName (rName + "_bones")) catch()
			)
		)
			
		FN_pasteModule pn xmlPath
		destroydialog processRoll
		callbacks.addScript #nodepreDelete "FNgetDelNodes()" id:#getDelNodes
		callbacks.addScript #nodepostDelete "FNdeleteManual()" id:#deleteManual
		callbacks.addScript #selectionSetChanged "FN_SELcallback instantRigFloater" id:#Rollout_Update
		if loadSaveFloater != undefined and loadSaveFloater.open do (callbacks.addScript #selectionSetChanged "FN_saveLoadCallback()" id:#savLoadUpdate)
		enableSceneRedraw()
		redrawViews()
		gc()
	)
	on rigNameText entered txt do
	(
-- 			setCommandPanelTaskMode #modify
		with undo off
		(
		rigNameText.text = charMap txt
		try (oldName = selection[1].rootNodeHolderG[1].node.nameHolderG) catch()
		try (selection[1].rootNodeHolderG[1].node.nameHolderG = rigNameText.text) catch()
		try (rName =rigNameText.text) catch()
		try (FN_renameRoot selection[1].rootNodeHolderG[1].node) catch()
		try (FN_createLayer selection[1].rootNodeHolderG[1].node) catch()
		try (LayerManager.deleteLayerByName (oldName + "_hiddenNodes")) catch()
		try (LayerManager.deleteLayerByName (oldName + "_controllers")) catch()
		try (LayerManager.deleteLayerByName (oldName + "_bones")) catch()
		)
		
	)
	
	on startBtn pressed do
	(
		rName = rigNameText.text -- createPoint fonksiyonuna createlayer için isim gönderiyoruz
		set animate off
-- 			setCommandPanelTaskMode #modify
		with undo off FN_createRootNode();
		
	)
	on buildBtn pressed do
	(
		createDialog processRoll style:#(#style_border)
		disableSceneRedraw()
		bldLab.visible = true;

		set animate off
		setCommandPanelTaskMode #create
		rN = selection[1].rootNodeHolderG[1].node
		callbacks.removeScripts id:#getDelNodes
		callbacks.removeScripts id:#deleteManual
		callbacks.removeScripts id:#Rollout_Update -- spine build ederken bi ara spline sectigi için rName = "" oluyor. Bu yüzden callback kapatip açilir.
		if loadSaveFloater != undefined and loadSaveFloater.open do (callbacks.removeScripts id:#savLoadUpdate)
		with undo off 
		(
			root = FN_buildRoot selection[1]
			delNodes = #()
			FN_deleteModule rN.parentPointHolderG[1].node
			delete delNodes
			bldLab.visible = false;
		)
		callbacks.addScript #nodepreDelete "FNgetDelNodes()" id:#getDelNodes
		callbacks.addScript #nodepostDelete "FNdeleteManual()" id:#deleteManual
		callbacks.addScript #selectionSetChanged "FN_SELcallback instantRigFloater" id:#Rollout_Update
		if loadSaveFloater != undefined and loadSaveFloater.open do (callbacks.addScript #selectionSetChanged "FN_saveLoadCallback()" id:#savLoadUpdate)
		select root
		enableSceneRedraw()
		redrawViews()
		destroydialog processRoll
		messagebox "Rig is successfully built."
	)
)
rollout partsRoll "Create Module"
(
	button hubBtn "Hub" pos:[10, 10] width:80 height:22 enabled:false
	button chestBtn "Spine" pos:[100, 10] width:80 height:22 enabled:false
	button armBtn "Arm" pos:[10, 40] width:80 height:22 enabled:false
	button legBtn "Leg" pos:[100, 40] width:80 height:22 enabled:false
	button chainBtn "Chain" pos:[10, 70] width:80 height:22 enabled:false
-- 	button wingBtn "Wing" pos:[95, 70] width:80 height:22 enabled:false toolTip:"Not available in this version"
	group "Don't Affect Pivot"
	(
		checkButton affObj "Edit Mode" pos:[10, 115] width:80 height:22 default:false enabled:false
		button rstObj "Reset" pos:[100, 115] width:80 height:22 enabled:false
	)
	on affObj changed state do
		(
			if state == on then
			(
				selectionBoneArray = #()
				maxops.pivotmode = #objectOnly
				for i in selection do 
					(
						if i.boneEnable == true then 
						(
							i.boneEnable = false
							append selectionBoneArray i
						)
					)
			)
			else
			(
				maxops.pivotmode = #none
				for i in selectionBoneArray do (i.boneEnable = true; i.boneFreezeLength=false; i.boneScaleType = #none;)
			)
		)
	on rstObj pressed do
		(
			with undo off
				(
					selection[1].objectOffsetPos = [0,0,0]
					selection[1].objectOffsetRot = (quat -0.707107 0 -0.707107 0)
					selection[1].objectOffsetScale = [1,1,1]
				)
		)
	on hubBtn pressed do
		(
			set animate off
			setCommandPanelTaskMode #modify
			with undo off FN_createHubBone selection[1];
		)
	on chestBtn pressed do
		(
			set animate off
			setCommandPanelTaskMode #modify
			with undo off FN_createSpine selection[1];
		)
	on armBtn pressed do
		(
			set animate off
			setCommandPanelTaskMode #modify
			with undo off FN_createLimbBones selection[1];
		)
	on legBtn pressed do
		(
			set animate off
			setCommandPanelTaskMode #modify
			with undo off FN_createLimbBones selection[1] type:1;
		)
	on chainBtn pressed do
		(
			set animate off
			setCommandPanelTaskMode #modify
			with undo off FN_createChain selection[1];
		)
)
fn FN_getDeformBones childNode deformBones=
(
	for i in childNode.childG do
	(
		if i.node.isBlendBone != true do
		(
			append deformBones i.node
		)
		FN_getDeformBones i.node deformBones
	)
	deformBones
)
fn FN_bake childNode parent tm skinBones=
(
	for i in childNode.childG do
	(
		if i.node.isBlendBone != true do
		(
			local p
			p = PRS() -- Create standard transform controller to bake keys into
			p.position.controller = position_xyz()       
			p.rotation.controller = euler_xyz()       
			p.scale.controller = linear_scale()
			at time tm, with animate off, in coordsys world 
			(
				p.value = i.node.transform
			) 
			bonePivot = BoneSys.createBone [0,0,0] [0,0,25] [-25,0,0]
			
			nb = Box length:i.node.length width:i.node.width height:i.node.height
			nb.name = i.node.name
			nb.parent = bonePivot
			ResetTransform nb
			delete bonePivot
			nb.wirecolor = [255,80,0]
			
			nb.parent = parent
			nb.Transform.controller = p
			nb.transform = p.value
			newparent = nb
			
			nb.boneEnable = true
			nb.boneFreezeLength=false
			nb.boneScaleType = #none
			
			append skinBones nb
		)
		FN_bake i.node newparent tm skinBones
	)
	skinBones
)
fn LSW_EnvelopeCallbackFunction =
(
	WindowHandle = DialogMonitorOPS.GetWindowHandle()
	theDialogName = UIAccessor.GetWindowText WindowHandle

	if theDialogName != undefined and matchpattern theDialogName pattern:"*Load Envelopes*" do
		UIAccessor.PressButtonByName WindowHandle "Match by Name"	
		
	if theDialogName != undefined and matchpattern theDialogName pattern:"*Load Envelopes*" do
		UIAccessor.PressButtonByName WindowHandle "OK"

	true
)
fn FN_instantskin state=
(
	rootCtrl = selection[1]
	meshes = #()
	skinModifier = Skin ()
	for i = 2 to selection.count do
	(
		append meshes selection[i]
		addModifier selection[i] (skinModifier) 
-- 		sc.modifiers[#attribute_holder].name = "attributes"
	)
	
	deformBones = #()
	FN_getDeformBones rootCtrl deformBones
	
	if state == 3 then
	(
		select meshes
		for i in deformBones do
		(
			skinOps.addbone meshes[1].modifiers[#Skin] i 1
		)
	)
	
	else
	(
		skinBones = #()
		FN_bake rootCtrl undefined currenttime skinBones
		
		select meshes
		for i in skinBones do
		(
			skinOps.addbone meshes[1].modifiers[#Skin] i 1
		)
		
		for i in meshes do
		(
			select i
			sk = i.modifiers[#Skin]
			skinOps.voxelWeighting sk (state - 1) 0.8 10 512 true true 
			
			skinOps.SaveEnvelope  sk ((pathConfig.GetDir #export)+ "/temp.env")

			deleteModifier i (sk)
			addModifier i (skin())
			sk = i.modifiers[#Skin]
			for b in deformBones do
			(
				skinOps.addbone sk b 1
			)
			
			DialogMonitorOPS.RegisterNotification LSW_EnvelopeCallbackFunction ID:#ANoon_Envelopes
			DialogMonitorOPS.Enabled = true
			
			completeRedraw()
			skinOps.loadEnvelope  sk ((pathConfig.GetDir #export)+ "/temp.env")
			
			DialogMonitorOPS.Enabled = false
			DialogMonitorOPS.UnRegisterNotification ID:#ANoon_Envelopes
		)
		delete skinBones
	)
	
	select rootCtrl
)

rollout instantSkin ""
(
	button iskin "InstantSkin" align:#center width:155 height:25 tooltip:"ctrl + select meshes"
	radiobuttons skinType "Solver:" align:#left  labels:#("Geodesic Voxel", "Heat Map", "Envelope") default:1 enabled:True tooltip:"ctrl + select meshes"
	on iskin pressed do
	(
		if selection.count < 2 then
		(
			messagebox "Please control + select at least 1 mesh while root is selected."
		)
		else
		(
			set animate off
			setCommandPanelTaskMode #modify
			with undo off FN_instantskin skinType.state
			messagebox "Skin binding is successfully completed."
		)
		
	)
	
	on skinType changed state do
	(
		if state != 3 do
		(
		try (skinOps.voxelWeighting) 
		catch 
			(
				skinType.state = 3
				messagebox "Geodesic Voxel and Heat Map are only supported on Max 2017 or higher"
			)
		)
	)
)
fn FN_SELcallback fn_Floater= 
(
	--- rollout name update
	try
	(		
		rName = selection[1].rootNodeHolderG[1].node.nameHolderG
		startupRoll.rigNameText.text = rName 
	)catch (startupRoll.rigNameText.text=""; rName ="")
	
	if selection[1] != undefined then
	(
		partsRoll.affObj.enabled = true
		partsRoll.rstObj.enabled = true
		if partsRoll.affObj.state == on then
		(
			for i in selection do 
				(
					if i.boneEnable == true then 
					(
						i.boneEnable = false; 
						append selectionBoneArray i;
					)
				)
		)
		
	)
	else
	(
		partsRoll.affObj.enabled = false
		partsRoll.rstObj.enabled = false
		partsRoll.affObj.state = off
		maxops.pivotmode = #none
		try
		(
		if selectionBoneArray.count != 0 then 
			(
				for i in selectionBoneArray do
					(
						i.boneEnable = true; 
						i.boneFreezeLength=false; 
						i.boneScaleType = #none
						)
			)
		)catch ()
		selectionBoneArray = #()

	)
		
	try (
		boolArry = selection[1].btnEnableG
		partsRoll.hubBtn.enabled = boolArry[1]
		partsRoll.chestBtn.enabled = boolArry[2]
		partsRoll.armBtn.enabled = boolArry[3]
		partsRoll.legBtn.enabled = boolArry[4]
-- 		partsRoll.wingBtn.enabled = boolArry[5]
		partsRoll.chainBtn.enabled = boolArry[6]

		)catch(
		partsRoll.hubBtn.enabled = false
		partsRoll.chestBtn.enabled = false
		partsRoll.armBtn.enabled = false
		partsRoll.legBtn.enabled = false
-- 		partsRoll.wingBtn.enabled = false
		partsRoll.chainBtn.enabled = false
		removeRollout limb_attributes fn_Floater
		removeRollout spineCounterRoll fn_Floater
		)
		
		try
		(
			if (selection[1].rigSectionHolderG == 10 or selection[1].rigSectionHolderG == 1 or selection[1].rigSectionHolderG == 2 or selection[1].rigSectionHolderG == 3 or selection[1].rigSectionHolderG == 4 or selection[1].rigSectionHolderG == 6 or selection[1].rigSectionHolderG == 7) then 
			(
				try(removeRollout nameAtts fn_Floater); catch(); -- eger bir sectiondan ötekine geçilirse önce silip sonra en alta tekrar atanacak
				addRollout nameAtts fn_Floater;
				nameAtts.moduleName.text = selection[1].parentPointHolderG[1].node.modulNameHolder
			) 
			else 
			(removeRollout nameAtts fn_Floater)
			
			if selection[1].rigSectionHolderG == 2 then 
				(
					try(removeRollout spineCounterRoll fn_Floater); catch();
					addRollout spineCounterRoll fn_Floater;
					spineCounterRoll.spineCounterSpin.value = selection[1].parentPointHolderG[1].node.spineHolderG.count
					if selection[1].parentPointHolderG[1].node.middleCheck == false then spineCounterRoll.middleCheck.checked = false
						else (spineCounterRoll.middleCheck.checked = true)
				)
				else (removeRollout spineCounterRoll fn_Floater)
			if selection[1].rigSectionHolderG == 3 then 
				(
				try(removeRollout limb_attributes fn_Floater); catch();
				addRollout limb_attributes fn_Floater; 
				limb_attributes.clavicleChk.checked = selection[1].parentPointHolderG[1].node.clavicleCheck; 
				limb_attributes.foreTwist.value = selection[1].parentPointHolderG[1].node.armBonesHolderG[2].node.twistBoneHolderG.count + 1; 
				limb_attributes.upperTwist.value = selection[1].parentPointHolderG[1].node.armBonesHolderG[1].node.twistBoneHolderG.count +1 
				
					if copyCheck != undefined then
					(
						try(
						if ((selection[1].parentPointHolderG[1].node.legToeHolderG[1] == undefined) and (toeCheck ==0)) then (limb_attributes.pasteBtn.enabled = true; limb_attributes.pmBtn.enabled = true)
						else if ((selection[1].parentPointHolderG[1].node.legToeHolderG[1] != undefined) and (toeCheck ==1)) then (limb_attributes.pasteBtn.enabled = true; limb_attributes.pmBtn.enabled = true)
						else (limb_attributes.pasteBtn.enabled = false; limb_attributes.pmBtn.enabled = false)
						)catch (limb_attributes.pasteBtn.enabled = false; limb_attributes.pmBtn.enabled = false)

					)
					else 
					(
						limb_attributes.pasteBtn.enabled = false 
						limb_attributes.pmBtn.enabled = false
					)
				)
			else (removeRollout limb_attributes fn_Floater)
			if selection[1].rigSectionHolderG == 4 then 
				(
					try(removeRollout hand_attributes fn_Floater); catch();
					addRollout hand_attributes fn_Floater; 
					hand_attributes.fingerCount.value = selection[1].moduleFingerHolderG.count; 
					hand_attributes.fingerBoneCount.value = selection[1].fingerBoneCountHolderG
					if copyHandCheck != undefined then
					(
						try(
						if ((selection[1].parentPointHolderG[1].node.legToeHolderG[1] == undefined) and (toeCheck ==0)) then (hand_attributes.pasteBtn.enabled = true)
						else if ((selection[1].parentPointHolderG[1].node.legToeHolderG[1] != undefined) and (toeCheck ==1)) then (hand_attributes.pasteBtn.enabled = true)
						else (hand_attributes.pasteBtn.enabled = false)
						)catch (hand_attributes.pasteBtn.enabled = false)	
					)
					else (hand_attributes.pasteBtn.enabled = false)
					)
			else (removeRollout hand_attributes fn_Floater)
			if selection[1].rigSectionHolderG == 5 then 
				(
					try(removeRollout finger_attributes fn_Floater); catch();
					addRollout finger_attributes fn_Floater; 
					finger_attributes.fingerBoneCount.value = selection[1].parentPointHolderG[1].node.fingerBoneCountHolderG
					if copyFingerCheck != undefined then
					(
						finger_attributes.pasteBtn.enabled = true	
					)
					else (finger_attributes.pasteBtn.enabled = false)
				)
			else (removeRollout finger_attributes fn_Floater)
			if selection[1].rigSectionHolderG == 6 then 
				(
					try(removeRollout chain_attributes fn_Floater); catch();
					addRollout chain_attributes fn_Floater; 
					chain_attributes.tailBoneCount.value = selection[1].parentPointHolderG[1].node.tailBoneHolderG.count
					chain_attributes.chType.state = selection[1].parentPointHolderG[1].node.chType
					if copyTailCheck != undefined then
					(
						chain_attributes.pasteBtn.enabled = true
						chain_attributes.pmBtn.enabled = true
					)
					else (chain_attributes.pasteBtn.enabled = false;chain_attributes.pmBtn.enabled = false)
				)
			else (removeRollout chain_attributes fn_Floater)
			if selection[1].rigSectionHolderG == 7 then (addRollout middleRoll fn_Floater; middleRoll.middleRow.value = selection[1].parentPointHolderG[1].node.middleCtrlHolderG[1].node.rowHolderG; middleRoll.middleRow.range = [2, (selection[1].parentPointHolderG[1].node.spineHolderG.count), middleRoll.middleRow.value]; )
			else (removeRollout middleRoll fn_Floater)
			
			if (selection[1].rigSectionHolderG == 10 or selection[1].rigSectionHolderG == 1 or selection[1].rigSectionHolderG == 2 or selection[1].rigSectionHolderG == 3 or selection[1].rigSectionHolderG == 4 or selection[1].rigSectionHolderG == 6 or selection[1].rigSectionHolderG == 7) then 
				(
					startupRoll.buildBTN.enabled = true
					startupRoll.saveRig.enabled = true
					startupRoll.loadRig.enabled = true
					
					try(removeRollout deleteModule fn_Floater); catch(); -- eger bir sectiondan ötekine geçilirse önce silip sonra en alta tekrar atanacak
					addRollout deleteModule fn_Floater;
				) 
			else 
				(removeRollout deleteModule fn_Floater; startupRoll.buildBTN.enabled = false;startupRoll.saveRig.enabled = false;startupRoll.loadRig.enabled = false;)
				
			if (selection[1].rigSectionHolderG == 11) then 
			(
				try(removeRollout instantSkin fn_Floater); catch();
				addRollout instantSkin fn_Floater;
				try (skinOps.voxelWeighting) catch (instantSkin.skinType.state = 3)
-- 				if selection.count == 1 then
-- 				(
-- 					instantSkin.skinType.enabled = false
-- 					instantSkin.iskin.enabled = false
-- 				)
-- 				else
-- 				(
-- 					instantSkin.skinType.enabled = true
-- 					instantSkin.iskin.enabled = true
-- 				)
					
				
			)
			else
			(removeRollout instantSkin fn_Floater)
		)
		catch(removeRollout instantSkin fn_Floater; removeRollout nameAtts fn_Floater; removeRollout limb_attributes fn_Floater; removeRollout spineCounterRoll fn_Floater; removeRollout hand_attributes fn_Floater; removeRollout finger_attributes fn_Floater; removeRollout chain_attributes fn_Floater; removeRollout deleteModule fn_Floater;startupRoll.buildBTN.enabled = false;startupRoll.saveRig.enabled = false;startupRoll.loadRig.enabled = false;)
		

)

try (cui.UnRegisterDialogBar instantRigFloater; closeRolloutFloater instantRigFloater)catch()
try closeRolloutFloater instantRigFloater catch()
instantRigFloater = newRolloutFloater "InstantRig" 205 590
instantRigFloater.pos = [10,50]
cui.RegisterDialogBar instantRigFloater minSize:[205,100] maxSize:[205,600] style:#(#cui_max_sized, #cui_dock_all, #cui_floatable, #cui_handles) 
cui.DockDialogBar instantRigFloater #cui_dock_left
cui.floatdialogbar instantRigFloater
cui.DockDialogBar instantRigFloater #cui_dock_left

addRollout creditRoll instantRigFloater
addRollout startupRoll instantRigFloater
addRollout partsRoll instantRigFloater
clearListener()