try(destroyDialog SlicerToolRollout)catch()
rollout SlicerToolRollout "Slicer Tool" width:351 height:310
(
	local SliceModsX1 = #()
	local SliceModsY1 = #()
	local SliceModsZ1 = #()
	
	local SliceModsX2 = #()
	local SliceModsY2 = #()
	local SliceModsZ2 = #()
	
	local SliceModsX3 = #()
	local SliceModsY3 = #()
	local SliceModsZ3 = #()
	
	local SliceModsX4 = #()
	local SliceModsY4 = #()
	local SliceModsZ4 = #()
	
	local SliceModsX5 = #()
	local SliceModsY5 = #()
	local SliceModsZ5 = #()
	
	local LOD1
	local LOD2
	local LOD3
	local LOD4
	local LOD5
	
	local OriginalSelectedObject
	
	local GroupedSelection = #()
	local GroupedObject
	
	local LODsCount = 0
	
	--spinner 'editLODs' "Number of LODs" pos:[9,7] width:117 height:16 range:[1,5,0] type:#integer align:#left
	GroupBox 'grp1' "LODs" pos:[15,20] width:323 height:240 align:#left
	
	--1
	label 'lbl1' "1." pos:[25,62] width:20 height:18 align:#left
	checkbox 'chk1' "" pos:[50,55] width:24 height:24 align:#left
	
	label 'lblX1' "X" pos:[109,40] width:12 height:14 toolTip:"Slices along the X axis" align:#left
	label 'lblY1' "Y" pos:[152,40] width:12 height:14 toolTip:"Slices along the Y axis" align:#left
	label 'lblZ1' "Z" pos:[200,40] width:12 height:14 toolTip:"Slices along the Z axis" align:#left
	
	spinner 'spnX1' "" pos:[100,60] width:35 height:16 range:[0,100,0] type:#integer align:#left
	spinner 'spnY1' "" pos:[144,60] width:35 height:16 range:[0,100,0] type:#integer align:#left
	spinner 'spnZ1' "" pos:[188,60] width:35 height:16 range:[0,100,0] type:#integer align:#left
	
	checkButton 'btn1' "Preview" pos:[253,50] width:71 height:25 align:#left
	
	--2
	label 'lbl2' "2." pos:[25,102] width:20 height:18 align:#left
	checkbox 'chk2' "" pos:[50,95] width:24 height:24 align:#left
		
	spinner 'spnX2' "" pos:[100,100] width:35 height:16 range:[0,100,0] type:#integer align:#left
	spinner 'spnY2' "" pos:[144,100] width:35 height:16 range:[0,100,0] type:#integer align:#left
	spinner 'spnZ2' "" pos:[188,100] width:35 height:16 range:[0,100,0] type:#integer align:#left
	
	checkButton 'btn2' "Preview" pos:[253,90] width:71 height:25 align:#left
	
	--3
	label 'lbl3' "3." pos:[25,142] width:20 height:18 align:#left
	checkbox 'chk3' "" pos:[50,135] width:24 height:24 align:#left
		
	spinner 'spnX3' "" pos:[100,140] width:35 height:16 range:[0,100,0] type:#integer align:#left
	spinner 'spnY3' "" pos:[144,140] width:35 height:16 range:[0,100,0] type:#integer align:#left
	spinner 'spnZ3' "" pos:[188,140] width:35 height:16 range:[0,100,0] type:#integer align:#left
	
	checkButton 'btn3' "Preview" pos:[253,130] width:71 height:25 align:#left
	
	--4
	label 'lbl4' "4." pos:[25,182] width:20 height:18 align:#left
	checkbox 'chk4' "" pos:[50,175] width:24 height:24 align:#left
		
	spinner 'spnX4' "" pos:[100,180] width:35 height:16 range:[0,100,0] type:#integer align:#left
	spinner 'spnY4' "" pos:[144,180] width:35 height:16 range:[0,100,0] type:#integer align:#left
	spinner 'spnZ4' "" pos:[188,180] width:35 height:16 range:[0,100,0] type:#integer align:#left
	
	checkButton 'btn4' "Preview" pos:[253,170] width:71 height:25 align:#left
	
	--5
	label 'lbl5' "5." pos:[25,222] width:20 height:18 align:#left
	checkbox 'chk5' "" pos:[50,215] width:24 height:24 align:#left		
	
	spinner 'spnX5' "" pos:[100,220] width:35 height:16 range:[0,100,0] type:#integer align:#left
	spinner 'spnY5' "" pos:[144,220] width:35 height:16 range:[0,100,0] type:#integer align:#left
	spinner 'spnZ5' "" pos:[188,220] width:35 height:16 range:[0,100,0] type:#integer align:#left
	
	checkButton 'btn5' "Preview" pos:[253,210] width:71 height:25 align:#left
	
	button 'btnAccept' "Accept" pos:[80,270] width:80 height:25 enabled:true align:#left
	
	button 'btnExport' "Export" pos:[180,270] width:80 height:25 enabled:false align:#left
	
	local Accepted = false
	
	on btnAccept pressed do
	(
		Accepted = true
		DestroyDialog SlicerToolRollout
	)
	
	on btnExport pressed do
	(
		if LOD1 != undefined do append GroupedSelection LOD1
		if LOD2 != undefined do append GroupedSelection LOD2
		if LOD3 != undefined do append GroupedSelection LOD3
		if LOD4 != undefined do append GroupedSelection LOD4
		if LOD5 != undefined do append GroupedSelection LOD5
		--print GroupedSelection
		GroupedObject = group GroupedSelection name:"temp"
		GroupedObject.pos = [0,0,0]
		
		GroupedSelection = #()
		
		select GroupedObject
		
		--Create LOD Sets from Groups
		max utility mode
		--setCommandPanelTaskMode #utility
		UtilityPanel.OpenUtility Level_of_Detail
		panel = windows.getChildHWND #max "Level of Detail"
		if (panel != undefined) do
		(
			tempButton = windows.getChildHWND #max "Create New Set"
			tempParent = UIAccessor.GetParentWindow tempButton[1]
			UIAccessor.PressButtonByName tempParent "Create New Set"
		)
	)
	
	fn SliceObject &SlicedObj &SliceMods Axis:#X NumSlices:0 =
	(
		max modify mode
		
		--empty &SliceMods
		if SlicedObj != undefined do
		(
			local objTM = SlicedObj.objecttransform
			
			if Axis == #X do
			(
				TotalDistance = SlicedObj.max.x - SlicedObj.min.x
				DistanceX = TotalDistance / (NumSlices + 1)
				
				for i = 1 to NumSlices do
				(
					mySlice = SliceModifier()
					addmodifier SlicedObj mySlice --ui:off
					modTM = getModContextTM SlicedObj mySlice
					mySlice.Slice_Plane.position = (([SlicedObj.min.x,SlicedObj.pos.y,SlicedObj.pos.z] + i * [DistanceX,0,0]) * modTM * (inverse objTM))
					mySlice.Slice_Plane.rotation.y_rotation = 90
					append SliceMods mySlice
				)
				
			)
			if Axis == #Y do
			(
				TotalDistance = SlicedObj.max.y - SlicedObj.min.y
				DistanceY = TotalDistance / (NumSlices + 1)
				
				for i = 1 to NumSlices do
				(
					mySlice = SliceModifier()
					addmodifier SlicedObj mySlice --ui:off
					modTM = getModContextTM SlicedObj mySlice
					mySlice.Slice_Plane.position = (([SlicedObj.pos.x,SlicedObj.min.y,SlicedObj.pos.z] + i * [0,DistanceY,0]) * modTM * (inverse objTM))
					mySlice.Slice_Plane.rotation.x_rotation = 90
					append SliceMods mySlice
				)
			)
			if Axis == #Z do
			(
				TotalDistance = SlicedObj.max.z - SlicedObj.min.z
				DistanceZ = TotalDistance / (NumSlices + 1)
					
				for i = 1 to NumSlices do
				(
					mySlice = SliceModifier()
					addmodifier SlicedObj mySlice --ui:off
					modTM = getModContextTM SlicedObj mySlice
					mySlice.Slice_Plane.position = (([SlicedObj.pos.x,SlicedObj.pos.y,SlicedObj.min.z] + i * [0,0,DistanceZ]) * modTM * (inverse objTM))
					append SliceMods mySlice
				)
			)
			max create mode
		)
	)
	
	--1
	on spnX1 changed NewValue do
	(
		for i in SliceModsX1 do(try(deleteModifier LOD1 i)catch())
		SliceObject &LOD1 &SliceModsX1 Axis:#X NumSlices:NewValue 
	)
	on spnY1 changed NewValue do
	(
		for i in SliceModsY1 do(try(deleteModifier LOD1 i)catch())
		SliceObject &LOD1 &SliceModsY1 Axis:#Y NumSlices:NewValue 
	)
	on spnZ1 changed NewValue do
	(
		for i in SliceModsZ1 do(try(deleteModifier LOD1 i)catch())
		SliceObject &LOD1 &SliceModsZ1 Axis:#Z NumSlices:NewValue 
	)
	--2
	on spnX2 changed NewValue do
	(
		for i in SliceModsX2 do(try(deleteModifier LOD2 i)catch())
		SliceObject &LOD2 &SliceModsX2 Axis:#X NumSlices:NewValue 
	)
	on spnY2 changed NewValue do
	(
		for i in SliceModsY2 do(try(deleteModifier LOD2 i)catch())
		SliceObject &LOD2 &SliceModsY2 Axis:#Y NumSlices:NewValue 
	)
	on spnZ2 changed NewValue do
	(
		for i in SliceModsZ2 do(try(deleteModifier LOD2 i)catch())
		SliceObject &LOD2 &SliceModsZ2 Axis:#Z NumSlices:NewValue 
	)
	--3
	on spnX3 changed NewValue do
	(
		for i in SliceModsX3 do(try(deleteModifier LOD3 i)catch())
		SliceObject &LOD3 &SliceModsX3 Axis:#X NumSlices:NewValue 
	)
	on spnY3 changed NewValue do
	(
		for i in SliceModsY3 do(try(deleteModifier LOD3 i)catch())
		SliceObject &LOD3 &SliceModsY3 Axis:#Y NumSlices:NewValue 
	)
	on spnZ3 changed NewValue do
	(
		for i in SliceModsZ3 do(try(deleteModifier LOD3 i)catch())
		SliceObject &LOD3 &SliceModsZ3 Axis:#Z NumSlices:NewValue 
	)
	--4
	on spnX4 changed NewValue do
	(
		for i in SliceModsX4 do(try(deleteModifier LOD4 i)catch())
		SliceObject &LOD4 &SliceModsX4 Axis:#X NumSlices:NewValue 
	)
	on spnY4 changed NewValue do
	(
		for i in SliceModsY4 do(try(deleteModifier LOD4 i)catch())
		SliceObject &LOD4 &SliceModsY4 Axis:#Y NumSlices:NewValue 
	)
	on spnZ4 changed NewValue do
	(
		for i in SliceModsZ4 do(try(deleteModifier LOD4 i)catch())
		SliceObject &LOD4 &SliceModsZ4 Axis:#Z NumSlices:NewValue 
	)
	--5
	on spnX5 changed NewValue do
	(
		for i in SliceModsX5 do(try(deleteModifier LOD5 i)catch())
		SliceObject &LOD5 &SliceModsX5 Axis:#X NumSlices:NewValue
	)
	on spnY5 changed NewValue do
	(
		for i in SliceModsY5 do(try(deleteModifier LOD5 i)catch())
		SliceObject &LOD5 &SliceModsY5 Axis:#Y NumSlices:NewValue 
	)
	on spnZ5 changed NewValue do
	(
		for i in SliceModsZ5 do(try(deleteModifier LOD5 i)catch())
		SliceObject &LOD5 &SliceModsZ5 Axis:#Z NumSlices:NewValue 
	)	
	
	fn DeleteSlices Axis:#All LOD:0 =
	(
		if LOD == 1 or LOD == 0 do
		(
			for i in SliceModsX1 do(try(deleteModifier $ i)catch())
			free SliceModsX1
			
			for i in SliceModsY1 do(try(deleteModifier $ i)catch())
			free SliceModsY1
			
			for i in SliceModsZ1 do(try(deleteModifier $ i)catch())
			free SliceModsZ1
		)
		
		if LOD == 2 or LOD == 0 do
		(
			for i in SliceModsX2 do(try(deleteModifier $ i)catch())
			free SliceModsX2
			
			for i in SliceModsY2 do(try(deleteModifier $ i)catch())
			free SliceModsY2
			
			for i in SliceModsZ2 do(try(deleteModifier $ i)catch())
			free SliceModsZ2
		)
		
		if LOD == 3 or LOD == 0 do
		(
			for i in SliceModsX3 do(try(deleteModifier $ i)catch())
			free SliceModsX3
			
			for i in SliceModsY3 do(try(deleteModifier $ i)catch())
			free SliceModsY3
			
			for i in SliceModsZ3 do(try(deleteModifier $ i)catch())
			free SliceModsZ3
		)
		
		if LOD == 4 or LOD == 0 do
		(
			for i in SliceModsX4 do(try(deleteModifier $ i)catch())
			free SliceModsX4
			
			for i in SliceModsY4 do(try(deleteModifier $ i)catch())
			free SliceModsY4
			
			for i in SliceModsZ4 do(try(deleteModifier $ i)catch())
			free SliceModsZ4
		)
		
		if LOD == 5 or LOD == 0 do
		(
			for i in SliceModsX5 do(try(deleteModifier $ i)catch())
			free SliceModsX5
			
			for i in SliceModsY5 do(try(deleteModifier $ i)catch())
			free SliceModsY5
			
			for i in SliceModsZ5 do(try(deleteModifier $ i)catch())
			free SliceModsZ5
		)
	)
	
	on SlicerToolRollout close do
	(
		if Accepted != true do 
		(
			max modify mode
			DeleteSlices()
			max create mode
			
			if chk1.state == true do if LOD1 != undefined do delete LOD1
			if chk2.state == true do if LOD2 != undefined do delete LOD2
			if chk3.state == true do if LOD3 != undefined do delete LOD3
			if chk4.state == true do if LOD4 != undefined do delete LOD4
			if chk5.state == true do if LOD5 != undefined do delete LOD5
			
			deselect
			if OriginalSelectedObject != undefined do
			(
				unhide OriginalSelectedObject
				select OriginalSelectedObject
			)
		)
	)
	
	on SlicerToolRollout open do
	(
		if $ != undefined then
		(
			OriginalSelectedObject = $
		)
		else
		(
			MessageBox "Please Select an Object to Slice"
			destroydialog SlicerToolRollout
		)
	)
	
	on chk1 changed state do
	(
		if state == true do
		(
			LODsCount += 1
			LOD1 = copy OriginalSelectedObject
			hide LOD1
			SliceObject &LOD1 &SliceModsX1 Axis:#X NumSlices:spnX1.Value 
			SliceObject &LOD1 &SliceModsY1 Axis:#Y NumSlices:spnY1.Value 
			SliceObject &LOD1 &SliceModsZ1 Axis:#Z NumSlices:spnZ1.Value 
		)
		if state == false do
		(
			LODsCount -= 1
			SliceModsX1 = #()
			SliceModsY1 = #()
			SliceModsZ1 = #()
			delete LOD1
			free LOD1
			if btn1.state == true do
			(
				unhide OriginalSelectedObject 
				select OriginalSelectedObject
			)
			btn1.state = false
		)
		
		btnExport.enabled = LODsCount >= 2
	)
	on chk2 changed state do
	(
		if state == true do
		(
			LODsCount += 1
			LOD2 = copy OriginalSelectedObject
			hide LOD2
			SliceObject &LOD2 &SliceModsX2 Axis:#X NumSlices:spnX2.Value 
			SliceObject &LOD2 &SliceModsY2 Axis:#Y NumSlices:spnY2.Value 
			SliceObject &LOD2 &SliceModsZ2 Axis:#Z NumSlices:spnZ2.Value 
		)
		if state == false do
		(
			LODsCount -= 1
			select OriginalSelectedObject
			SliceModsX2 = #()
			SliceModsY2 = #()
			SliceModsZ2 = #()
			delete LOD2
			free LOD2
			if btn2.state == true do unhide OriginalSelectedObject 
			btn2.state = false
		)
		
		btnExport.enabled = LODsCount >= 2
	)
	on chk3 changed state do
	(
		if state == true do
		(
			LODsCount += 1
			LOD3 = copy OriginalSelectedObject
			hide LOD3
			SliceObject &LOD3 &SliceModsX3 Axis:#X NumSlices:spnX3.Value 
			SliceObject &LOD3 &SliceModsY3 Axis:#Y NumSlices:spnY3.Value 
			SliceObject &LOD3 &SliceModsZ3 Axis:#Z NumSlices:spnZ3.Value 
		)
		if state == false do
		(
			LODsCount -= 1
			select OriginalSelectedObject
			SliceModsX3 = #()
			SliceModsY3 = #()
			SliceModsZ3 = #()
			delete LOD3
			free LOD3
			if btn3.state == true do unhide OriginalSelectedObject 
			btn3.state = false
		)
		
		btnAccept.enabled = LODsCount >= 2
	)
	on chk4 changed state do
	(
		if state == true do
		(
			LODsCount += 1
			LOD4 = copy OriginalSelectedObject
			hide LOD4
			SliceObject &LOD4 &SliceModsX4 Axis:#X NumSlices:spnX4.Value 
			SliceObject &LOD4 &SliceModsY4 Axis:#Y NumSlices:spnY4.Value 
			SliceObject &LOD4 &SliceModsZ4 Axis:#Z NumSlices:spnZ4.Value 
		)
		if state == false do
		(
			LODsCount -= 1
			select OriginalSelectedObject
			SliceModsX4 = #()
			SliceModsY4 = #()
			SliceModsZ4 = #()
			delete LOD4
			free LOD4
			if btn4.state == true do unhide OriginalSelectedObject 
			btn4.state = false
		)
		
		btnExport.enabled = LODsCount >= 2
	)
	on chk5 changed state do
	(
		if state == true do
		(
			LODsCount += 1
			LOD5 = copy OriginalSelectedObject
			hide LOD5
			SliceObject &LOD5 &SliceModsX5 Axis:#X NumSlices:spnX5.Value 
			SliceObject &LOD5 &SliceModsY5 Axis:#Y NumSlices:spnY5.Value 
			SliceObject &LOD5 &SliceModsZ5 Axis:#Z NumSlices:spnZ5.Value 
		)
		if state == false do
		(
			LODsCount -= 1
			select OriginalSelectedObject
			SliceModsX5 = #()
			SliceModsY5 = #()
			SliceModsZ5 = #()
			delete LOD5
			free LOD5
			if btn5.state == true do unhide OriginalSelectedObject 
			btn5.state = false
		)
		
		btnExport.enabled = LODsCount >= 2
	)
	
	on btn1 changed state do
	(
		if chk1.state == true then
		(
			if state == true do
			(
				hide $
				btn2.state = false
				btn3.state = false
				btn4.state = false
				btn5.state = false
				unhide LOD1
				select LOD1
			)
		
			if state == false and btn5.state == false and btn2.state == false and btn3.state == false and btn4.state == false do
			(
				hide LOD1
				deselect
				unhide OriginalSelectedObject
				select OriginalSelectedObject
			)
		)
		else (btn1.state = false)
	)
	on btn2 changed state do
	(
		if chk2.state == true then
		(
			if state == true do
			(
				hide $
				btn1.state = false
				btn3.state = false
				btn4.state = false
				btn5.state = false
				unhide LOD2
				select LOD2
			)
			
			if state == false and btn1.state == false and btn5.state == false and btn3.state == false and btn4.state == false do
			(
				hide LOD2
				deselect
				unhide OriginalSelectedObject
				select OriginalSelectedObject
			)
		)
		else (btn2.state = false)
	)
	on btn3 changed state do
	(
		if chk3.state == true then
		(
			if state == true do
			(
				hide $
				btn2.state = false
				btn1.state = false
				btn4.state = false
				btn5.state = false
				unhide LOD3
				select LOD3
			)
			
			if state == false and btn1.state == false and btn2.state == false and btn5.state == false and btn4.state == false do
			(
				hide LOD3
				deselect
				unhide OriginalSelectedObject
				select OriginalSelectedObject
			)
		)
		else (btn3.state = false)
	)
	on btn4 changed state do
	(
		if chk4.state == true then
		(
			if state == true do
			(
				hide $
				btn2.state = false
				btn3.state = false
				btn1.state = false
				btn5.state = false
				unhide LOD4
				select LOD4
			)
			
			if state == false and btn1.state == false and btn2.state == false and btn3.state == false and btn5.state == false do
			(
				hide LOD4
				deselect
				unhide OriginalSelectedObject
				select OriginalSelectedObject
			)
		)
		else (btn4.state = false)
	)
	on btn5 changed state do
	(
		if chk5.state == true then
		(
			if state == true do
			(
				hide $
				btn2.state = false
				btn3.state = false
				btn4.state = false
				btn1.state = false
				unhide LOD5
				select LOD5
			)
			
			if state == false and btn1.state == false and btn2.state == false and btn3.state == false and btn4.state == false do
			(
				hide LOD5
				deselect
				unhide OriginalSelectedObject
				select OriginalSelectedObject
			)
		)
		else (btn5.state = false)
	)
)
CreateDialog SlicerToolRollout style:#(#style_titlebar, #style_sysmenu, #style_toolwindow) --bgColor:[random 0 255, random 0 255, random 0 255