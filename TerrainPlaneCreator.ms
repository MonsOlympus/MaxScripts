
try(destroyDialog TerrainCreatorRollout)catch()
rollout TerrainCreatorRollout "Terrain Helper" width:321 height:636
(
	local UVWMod = uvwMap()
	local DisplaceMod = Displace()
	local TurboMod = TurboSmooth()
	
	local DisplaceModB = Displace()
	local TurboModB = TurboSmooth()
	
	local DisplayTypeBak = units.DisplayType
	local MetricTypeBak = units.MetricType
	local SystemTypeBak = units.SystemType
	local GridSpaceBak = getGridSpacing()
	local GridLinesBak = getGridMajorLines()
	local layer
	local tempString = ""
	
	local Created = false
	local DirChosen = false
	local DispMapChosen = false
	local LODGenerated = false
	local Dirty = false
	
	local AllPlanes = #()
	local AllLayers = #()
	local AllTurboMod = #()
	local PlaneColumns = #()
	
	GroupBox 'ScaleBox' "Scale" pos:[9,7] width:303 height:182 align:#left

	GroupBox 'grp4' "Grid Size" pos:[19,73] width:282 height:79 align:#left
	spinner 'TerrainSizeX' "X" pos:[85,37] width:72 height:16 range:[1,1000,10] type:#integer toolTip:"" align:#left
	spinner 'TerrainSizeY' "Y" pos:[182,37] width:72 height:16 range:[1,1000,10] type:#integer toolTip:"" align:#left
	
	GroupBox 'grp5' "Terrain Size" pos:[50,19] width:227 height:46 align:#left
	spinner 'GridXMax' "Maximum X" pos:[32,90] width:74 height:16 range:[1,10,2] type:#float toolTip:"" align:#left
	spinner 'GridXMin' "Minimum X" pos:[32,118] width:77 height:16 range:[1e-06,10,0.25] type:#float toolTip:"" align:#left
	spinner 'GridYMax' "Maximum Y" pos:[172,91] width:73 height:16 range:[1,10,2] type:#float toolTip:"" align:#left
	spinner 'GridYMin' "Minimum Y" pos:[173,118] width:76 height:16 range:[1e-06,10,0.25] type:#float toolTip:"" align:#left
	
	button 'Accept' "Create" pos:[123,158] width:70 height:24 enabled:true align:#left

	GroupBox 'DispBox' "Displacement" pos:[10,196] width:302 height:117 align:#left
	spinner 'DispStrength' "Strength" pos:[24,218] width:104 height:16 range:[0,10,0.02] type:#float toolTip:"" align:#left
	mapButton 'DispMap' "None" pos:[29,248] width:135 height:29 align:#left
	bitmap 'DispPreview' "Bitmap" pos:[203,208] width:102 height:98 align:#left

	GroupBox 'grp6' "Level Of Detail" pos:[12,328] width:300 height:109 align:#left
	spinner 'LODLevels' "LOD Levels" pos:[25,347] width:67 height:16 range:[1,20,5] type:#integer toolTip:"" align:#left
	spinner 'CurrentLOD' "Current LOD" pos:[172,346] width:64 height:16 range:[0,20,0] type:#integer toolTip:"" align:#left
	spinner 'IterMax' "Iterations Max" pos:[25,373] width:57 height:16 range:[1,20,5] type:#integer toolTip:"" align:#left
	spinner 'IterMin' "Iterations Min" pos:[172,372] width:60 height:16 range:[0,20,0] type:#integer toolTip:"" align:#left
	button 'LODBTN' "Generate LODs" pos:[111,402] width:114 height:21 align:#left


	GroupBox 'ExportBox' "Export" pos:[10,457] width:301 height:67 align:#left
	edittext 'ExportEdit' "" pos:[13,472] width:190 height:21 enabled:false align:#left
	button 'ExportDirBTN' "..." pos:[203,472] width:24 height:20 align:#left
	button 'ExportBTN' "Export" pos:[232,471] width:71 height:24 enabled:false align:#left
	progressBar 'ExportProgress' "ProgressBar" pos:[19,501] width:279 height:14 align:#left

	groupBox 'grp7' "Information" pos:[12,536] width:298 height:82 align:#left
	label 'lbl1' "Pixel Depth" pos:[32,562] width:58 height:18 align:#left
	edittext 'PixelDepthAmount' "Pixel Depth" pos:[32,562] width:230 height:17 enabled:true readOnly:true align:#left
	edittext 'PolyDepthAmount' "Poly Depth" pos:[32,590] width:230 height:17 enabled:true readOnly:true align:#left

	local ExportDir

	fn CheckInfo =
	(
		local tempString = ((GridXMax.value * 1000) / pow IterMax.value 2) as string + " Polys Per Meter"
		PolyDepthAmount.text = tempString
	)

	fn CheckExportEnabled = 
	(
		if Dirty != true and ExportProgress.value == 100 do
		(
			ExportBTN.enabled = true
			ExportProgress.color = green
		)
	)

	fn CalcLODs =
	(
		GridXLOD = (GridXMax-GridXMin)/LODLevels.value
		GridYLOD = (GridYMax-GridYMin)/LODLevels.value
	)

	fn GroupLODs =
	(
		local lengthSegments = int(TerrainSizeX.value / GridXMax.value)
		local widthSegments = int(TerrainSizeY.value / GridYMax.value)
		local arrayLength = lengthSegments*widthSegments
		--deselect
		
		for i = 1 to arrayLength do
		(
				deselect
				clearSelection()
				for n = 1 to PlaneColumns.count do
				(
					selectMore PlaneColumns[n][i]
					print PlaneColumns[n][i].name as string
				)
				--Add new Group to selected Layer
				(LayerManager.getLayerFromName "Terrain_Groups").current = true
				tempGroup = group selection 
				tempI = (i / lengthSegments) as integer
				tempJ = (arrayLength / widthSegments) as integer
				tempGroup.name = "TerrainGroup_"+tempI as string+"_"+TempJ as string
				select tempGroup
				
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
				
				max create mode
				deselect
		)
	)
	
	fn GenerateLODs = 
	(
		for n = 1 to LODLevels.value-1 do
		(
			local LODTurboMod = TurboSmooth()
			local tempString = "Terrain_LOD"+(n as string)
			local LODlayer = LayerManager.newLayerFromName tempString
			LODlayer.current = true
			append AllLayers LODlayer
			
			local lengthSegments = int(TerrainSizeX.value / GridXMax.value)
			local widthSegments = int(TerrainSizeY.value / GridYMax.value)

			local PlaneRow = #()

			max create mode
			deselect
			for i = 1 to lengthSegments do
			(
				for j = 1 to widthSegments do
				(
					NewPlane = Plane length:(GridXMax.value*getGridSpacing()) width:(GridYMax.value*getGridSpacing()) pos:[(GridXMax.value*getGridSpacing())*i,(GridYMax.value*getGridSpacing())*j,0] isSelected:off
					NewPlane.name = "Plane_"+i as string+"_"+j as string+"_"+n as string
					NewPlane.lengthsegs = 1
					NewPlane.widthsegs = 1
					LODlayer.addnode NewPlane
					append AllPlanes NewPlane
					append PlaneRow NewPlane
				)
			)

			append PlaneColumns PlaneRow
			
			--Set Turbosmooth Iterations
			TessAmount = LODLevels.value - n
			LODTurboMod.iterations = TessAmount
			
			--Select all planes on Terrain layer
			LODlayer.select true
			max modify mode
			completeRedraw()
			
			--Add instanced modifiers to all planes
			modPanel.addModToSelection (LODTurboMod)
			modPanel.addModToSelection (UVWMod)
			modPanel.addModToSelection (DisplaceMod)
			
			--Move all planes such that center pivot for all is at world origin
			tempGroup = group selection name:"temp"
			tempGroup.pos = [0,0,0]
			ungroup tempGroup
		
			--Deselect all
			deselect
			clearSelection()
		
		)
		LODGenerated = true
		GroupLODs()
	)
	
	
	
	fn CreatePlanes =
	(
		DisplaceMod.useMap = true

		local lengthSegments = int(TerrainSizeX.value / GridXMax.value)
		local widthSegments = int(TerrainSizeY.value / GridYMax.value)

		local PlaneRow = #()
		
		max create mode
		deselect
		for i = 1 to lengthSegments do
		(
			for j = 1 to widthSegments do
			(
				NewPlane = Plane length:(GridXMax.value*getGridSpacing()) width:(GridYMax.value*getGridSpacing()) pos:[(GridXMax.value*getGridSpacing())*i,(GridYMax.value*getGridSpacing())*j,0] isSelected:off
				NewPlane.name = "Plane_"+i as string+"_"+j as string+"_0"
				NewPlane.lengthsegs = 1
				NewPlane.widthsegs = 1
				layer.addnode NewPlane
				append AllPlanes NewPlane
				append PlaneRow NewPlane
			)
		)

		append PlaneColumns PlaneRow
		
		--Set Turbosmooth Iterations
		TurboMod.iterations = LODLevels.value
		
		--Select all planes on Terrain layer
		layer.select true
		max modify mode
		completeRedraw()
		
		--Add instanced modifiers to all planes
		modPanel.addModToSelection (TurboMod)
		modPanel.addModToSelection (UVWMod)
		modPanel.addModToSelection (DisplaceMod)
		
		--Move all planes such that center pivot for all is at world origin
		tempGroup = group selection name:"temp"
		tempGroup.pos = [0,0,0]
		ungroup tempGroup
		
		--Deselect all and fit to screen
		deselect
		clearSelection()
		max zoomext sel
		max create mode
		
		if Created != true do ExportProgress.value += 33
		Created = true
		CheckExportEnabled()
	)

	on TerrainCreatorRollout open do
	(
		--Backup Old Grid Size
		DisplayTypeBak = units.DisplayType
		MetricTypeBak = units.MetricType
		SystemTypeBak = units.SystemType
		
		GridSpaceBak = GetGridSpacing() 
		GridLinesBak = GetGridMajorLines() 
		
		--Set New Grid Sizes
		units.DisplayType = #Metric
		units.MetricType = #Kilometers
		units.SystemType = #Centimeters
	
		SetGridSpacing 100000.0
		SetGridMajorLines 10.0
		gridPrefs.perspViewGridExtents = 10
		
		tempString = tempString+"Grid Spacing="+getGridSpacing() as string+"cms\n"
		tempString = tempString+"Grid Lines="+getGridMajorLines() as string+"\n"
		
		--Create New Layer called Terrain
		local TerrainLayer = LayerManager.newLayerFromName "Terrain_Groups"
		layer = LayerManager.newLayerFromName "Terrain_LOD0"
		append AllLayers layer
		layer.current = true
		
		IterMax.value = LODLevels.value
		IterMin.value = 0
		
		CheckInfo()
	)
	on TerrainCreatorRollout close do
	(
		--Reset all Grid Sizes to Defaults
		units.DisplayType = DisplayTypeBak
		units.MetricType = MetricTypeBak
		units.SystemType = SystemTypeBak
	
		SetGridSpacing GridSpaceBak
		SetGridMajorLines GridLinesBak
		gridPrefs.perspViewGridExtents = 7
		
		--macros.run "Scene Explorer" "SEDeleteLayerAndChildren"
		
		--Delete Terrain Layer
		for i in AllPlanes do delete i
			
		free AllPlanes
		
		(LayerManager.getLayerFromName "0").current = true
		LayerManager.deleteLayerbyname "Terrain_Groups"
		
		for i = 1 to AllLayers.count do	LayerManager.deleteLayerbyname AllLayers[i].name
			
		free AllLayers
	)
	on TerrainSizeX changed NewValue do
	(
		Dirty = true
		CheckExportEnabled()
	)
	on TerrainSizeY changed NewValue do
	(
		Dirty = true
		CheckExportEnabled()
	)
	
	on IterMax changed NewValue do
	(
		--if(NewValue < 0) do LODLevels.value = 0
		Dirty = true
		CheckExportEnabled()
		CheckInfo()
	)
	on IterMin changed NewValue do
	(
		--if(NewValue < 0) do LODLevels.value = 0
		Dirty = true
		CheckExportEnabled()
	)
	on GridXMax changed NewValue do
	(
		Dirty = true
		CheckExportEnabled()
		CheckInfo()
	)
	on GridXMin changed NewValue do
	(
		Dirty = true
		CheckExportEnabled()
	)
	on GridYMax changed NewValue do
	(
		Dirty = true
		CheckExportEnabled()
		CheckInfo()
	)
	on GridYMin changed NewValue do
	(
		Dirty = true
		CheckExportEnabled()
	)
	on Accept pressed do
	(
		CreatePlanes()
	)
	on DispStrength changed NewValue do
	(
		DisplaceMod.strength = DispStrength.value*getGridSpacing()
	)
	on DispMap picked NewValue do
	(
		DisplaceMod.map = NewValue
		theNewMap = bitmap 102 98
		copy NewValue.bitmap theNewMap
		DispPreview.bitmap = theNewMap
		
		if DispMapChosen != true do ExportProgress.value += 33
		DispMapChosen = true
		CheckExportEnabled()
		
		local tempString = ((TerrainSizeX.value * 1000) / NewValue.bitmap.width as float) as string + " Pixels Per Meter"
		PixelDepthAmount.text = tempString
		--TerrainSizeY.value / NewValue.height
	)
	on LODLevels changed NewValue do
	(
		--if(NewValue < 0) do LODLevels.value = 0
		Dirty = true
		CheckExportEnabled()
	)
	on CurrentLOD changed NewValue do
	(
		if(NewValue < LODLevels.value) do
		(
			TurboMod.iterations = NewValue
		)
		
		if(NewValue > LODLevels.value) do
		(
			CurrentLOD.value = LODLevels.value
		)
		
		--macros.run "Scene Explorer" "SEUnhideSelected"
		--macros.run "Scene Explorer" "SEHideSelected"
	)
	on LODBTN pressed do
	(
		print "LODS"
		GenerateLODs()
	)
	on ExportDirBTN pressed do
	(
		--DebugEdit.text = "Hi\n"
		ExportDir = getSavePath caption:"Choose Export Path" initialDir:(getDir #export)
		if (ExportDir != undefined) do
		(
			ExportEdit.text = ExportDir
			if DirChosen != true do ExportProgress.value += 34
			DirChosen = true
			CheckExportEnabled()
		)
	)
	on ExportBTN pressed do
	(
		if (ExportDir != undefined) do
		(
			/*layer.current = true
			layer.Nodes &theNodesTemp
			deselect
			clearSelection()
			if theNodesTemp.count != 0  do
			(
				for i = 1 to theNodesTemp.count do
				(
					select theNodesTemp[i]
					completeFilePath = (ExportEdit.text + "/" + theNodesTemp[i].name)
					exportFile completeFilePath #noPrompt selectedOnly:true using:FBXEXP
				)
			)*/
			
			--TODO: Export Low Poly as Collision
		
			--TODO: Export LODS
		
			--Select Border (highest LODS)
			--$.EditablePoly.SetSelection #Edge ((polyOp.getOpenEdges $) as bitarray)
		
			--TODO: Scale Border out slightly (overlap amount)
			--TODO: Move Border down slightly
		)
	)
)CreateDialog TerrainCreatorRollout style:#(#style_titlebar, #style_sysmenu, #style_toolwindow) --bgColor:[random 0 255, random 0 255, rand