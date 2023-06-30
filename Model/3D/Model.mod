'# MWS Version: Version 2021.5 - Jun 28 2021 - ACIS 30.0.1 -

'# length = mm
'# frequency = GHz
'# time = ns
'# frequency range: fmin = 2.5 fmax = 5
'# created = '[VERSION]2021.5|30.0.1|20210628[/VERSION]


'@ use template: Planar Coupler & Divider_1.cfg

'[VERSION]2021.5|30.0.1|20210628[/VERSION]
'set the units
With Units
    .Geometry "mm"
    .Frequency "GHz"
    .Voltage "V"
    .Resistance "Ohm"
    .Inductance "H"
    .TemperatureUnit  "Kelvin"
    .Time "ns"
    .Current "A"
    .Conductance "Siemens"
    .Capacitance "F"
End With

'----------------------------------------------------------------------------

'set the frequency range
Solver.FrequencyRange "2.5", "5"

'----------------------------------------------------------------------------

Plot.DrawBox True

With Background
     .Type "Normal"
     .Epsilon "1.0"
     .Mu "1.0"
     .Rho "1.204"
     .ThermalType "Normal"
     .ThermalConductivity "0.026"
      .SpecificHeat "1005", "J/K/kg"
     .XminSpace "0.0"
     .XmaxSpace "0.0"
     .YminSpace "0.0"
     .YmaxSpace "0.0"
     .ZminSpace "0.0"
     .ZmaxSpace "0.0"
End With

With Boundary
     .Xmin "electric"
     .Xmax "electric"
     .Ymin "electric"
     .Ymax "electric"
     .Zmin "electric"
     .Zmax "electric"
     .Xsymmetry "none"
     .Ysymmetry "none"
     .Zsymmetry "none"
End With

' optimize mesh settings for planar structures

With Mesh
     .MergeThinPECLayerFixpoints "True"
     .RatioLimit "20"
     .AutomeshRefineAtPecLines "True", "6"
     .FPBAAvoidNonRegUnite "True"
     .ConsiderSpaceForLowerMeshLimit "False"
     .AnisotropicCurvatureRefinement "True"
     .AnisotropicCurvatureRefinementFSM "True"
End With

With MeshSettings
     .SetMeshType "Hex"
     .Set "RatioLimitGeometry", "20"
     .Set "EdgeRefinementOn", "1"
     .Set "EdgeRefinementRatio", "6"
End With

With MeshSettings
     .SetMeshType "Tet"
     .Set "VolMeshGradation", "1.5"
     .Set "SrfMeshGradation", "1.5"
End With

With MeshSettings
     .SetMeshType "HexTLM"
     .Set "StepsPerWaveNear", "20"
     .Set "StepsPerBoxNear", "10"
     .Set "StepsPerWaveFar", "20"
     .Set "StepsPerBoxFar", "10"
     .Set "RatioLimitGeometry", "20"
End With

' change mesh adaption scheme to energy
' 		(planar structures tend to store high energy
'     	 locally at edges rather than globally in volume)

MeshAdaption3D.SetAdaptionStrategy "Energy"

'----------------------------------------------------------------------------

Dim sDefineAt As String
sDefineAt = "3.75"
Dim sDefineAtName As String
sDefineAtName = "3.75"
Dim sDefineAtToken As String
sDefineAtToken = "f="
Dim aFreq() As String
aFreq = Split(sDefineAt, ";")
Dim aNames() As String
aNames = Split(sDefineAtName, ";")

Dim nIndex As Integer
For nIndex = LBound(aFreq) To UBound(aFreq)

Dim zz_val As String
zz_val = aFreq (nIndex)
Dim zz_name As String
zz_name = sDefineAtToken & aNames (nIndex)

' Define E-Field Monitors
With Monitor
    .Reset
    .Name "e-field ("& zz_name &")"
    .Dimension "Volume"
    .Domain "Frequency"
    .FieldType "Efield"
    .MonitorValue  zz_val
    .Create
End With

' Define H-Field Monitors
With Monitor
    .Reset
    .Name "h-field ("& zz_name &")"
    .Dimension "Volume"
    .Domain "Frequency"
    .FieldType "Hfield"
    .MonitorValue  zz_val
    .Create
End With

Next

'----------------------------------------------------------------------------

With MeshSettings
     .SetMeshType "Tet"
     .Set "Version", 1%
End With

With Mesh
     .MeshType "Tetrahedral"
End With

'set the solver type
ChangeSolverType("HF Frequency Domain")

'----------------------------------------------------------------------------

'@ define material: Copper (annealed)

'[VERSION]2021.5|30.0.1|20210628[/VERSION]
With Material
     .Reset
     .Name "Copper (annealed)"
     .Folder ""
.FrqType "static"
.Type "Normal"
.SetMaterialUnit "Hz", "mm"
.Epsilon "1"
.Mu "1.0"
.Kappa "5.8e+007"
.TanD "0.0"
.TanDFreq "0.0"
.TanDGiven "False"
.TanDModel "ConstTanD"
.KappaM "0"
.TanDM "0.0"
.TanDMFreq "0.0"
.TanDMGiven "False"
.TanDMModel "ConstTanD"
.DispModelEps "None"
.DispModelMu "None"
.DispersiveFittingSchemeEps "Nth Order"
.DispersiveFittingSchemeMu "Nth Order"
.UseGeneralDispersionEps "False"
.UseGeneralDispersionMu "False"
.FrqType "all"
.Type "Lossy metal"
.SetMaterialUnit "GHz", "mm"
.Mu "1.0"
.Kappa "5.8e+007"
.Rho "8930.0"
.ThermalType "Normal"
.ThermalConductivity "401.0"
.SpecificHeat "390", "J/K/kg"
.MetabolicRate "0"
.BloodFlow "0"
.VoxelConvection "0"
.MechanicsType "Isotropic"
.YoungsModulus "120"
.PoissonsRatio "0.33"
.ThermalExpansionRate "17"
.Colour "1", "1", "0"
.Wireframe "False"
.Reflection "False"
.Allowoutline "True"
.Transparentoutline "False"
.Transparency "0"
.Create
End With

'@ new component: component1

'[VERSION]2021.5|30.0.1|20210628[/VERSION]
Component.New "component1"

'@ define cylinder: component1:gnd

'[VERSION]2021.5|30.0.1|20210628[/VERSION]
With Cylinder 
     .Reset 
     .Name "gnd" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .OuterRadius "Rsub" 
     .InnerRadius "0" 
     .Axis "z" 
     .Zrange "0", "tcu" 
     .Xcenter "0" 
     .Ycenter "0" 
     .Segments "0" 
     .Create 
End With

'@ define material: Rogers RO4350B (lossy)

'[VERSION]2021.5|30.0.1|20210628[/VERSION]
With Material
     .Reset
     .Name "Rogers RO4350B (lossy)"
     .Folder ""
.FrqType "all"
.Type "Normal"
.SetMaterialUnit "GHz", "mm"
.Epsilon "3.66"
.Mu "1.0"
.Kappa "0.0"
.TanD "0.0037"
.TanDFreq "10.0"
.TanDGiven "True"
.TanDModel "ConstTanD"
.KappaM "0.0"
.TanDM "0.0"
.TanDMFreq "0.0"
.TanDMGiven "False"
.TanDMModel "ConstKappa"
.DispModelEps "None"
.DispModelMu "None"
.DispersiveFittingSchemeEps "General 1st"
.DispersiveFittingSchemeMu "General 1st"
.UseGeneralDispersionEps "False"
.UseGeneralDispersionMu "False"
.Rho "0.0"
.ThermalType "Normal"
.ThermalConductivity "0.62"
.SetActiveMaterial "all"
.Colour "0.94", "0.82", "0.76"
.Wireframe "False"
.Transparency "0"
.Create
End With

'@ define cylinder: component1:sub

'[VERSION]2021.5|30.0.1|20210628[/VERSION]
With Cylinder 
     .Reset 
     .Name "sub" 
     .Component "component1" 
     .Material "Rogers RO4350B (lossy)" 
     .OuterRadius "Rsub" 
     .InnerRadius "Rfe" 
     .Axis "z" 
     .Zrange "tcu", "tcu+tsub" 
     .Xcenter "-0" 
     .Ycenter "0" 
     .Segments "0" 
     .Create 
End With

'@ define material: TT1-105 ferrite

'[VERSION]2021.5|30.0.1|20210628[/VERSION]
With Material
     .Reset
     .Name "TT1-105 ferrite"
     .Folder ""
     .Rho "0.0"
     .ThermalType "Normal"
     .ThermalConductivity "0"
     .SpecificHeat "0", "J/K/kg"
     .DynamicViscosity "0"
     .Emissivity "0"
     .MetabolicRate "0.0"
     .VoxelConvection "0.0"
     .BloodFlow "0"
     .MechanicsType "Unused"
     .FrqType "all"
     .Type "Normal"
     .MaterialUnit "Frequency", "GHz"
     .MaterialUnit "Geometry", "mm"
     .MaterialUnit "Time", "ns"
     .MaterialUnit "Temperature", "Kelvin"
     .Epsilon "12.2"
     .Mu "1"
     .Sigma "0.0"
     .TanD "0.00025"
     .TanDFreq "3.8"
     .TanDGiven "True"
     .TanDModel "ConstTanD"
     .SetConstTanDStrategyEps "AutomaticOrder"
     .ConstTanDModelOrderEps "3"
     .DjordjevicSarkarUpperFreqEps "0"
     .SetElParametricConductivity "False"
     .ReferenceCoordSystem "Global"
     .CoordSystemType "Cartesian"
     .SigmaM "0.0"
     .TanDM "0.0"
     .TanDMFreq "0.0"
     .TanDMGiven "False"
     .TanDMModel "ConstTanD"
     .SetConstTanDStrategyMu "AutomaticOrder"
     .ConstTanDModelOrderMu "3"
     .DjordjevicSarkarUpperFreqMu "0"
     .SetMagParametricConductivity "False"
     .DispModelEps "None"
     .DispModelMu "Gyrotropic"
     .MuInfinity "55"
     .DispCoeff1Mu "1.98"
     .DispCoeff2Mu "1750"
     .DispCoeff3Mu "270"
     .DispCoeff4MuX "0.0"
     .DispCoeff4MuY "0.0"
     .DispCoeff4MuZ "1220"
     .UseSISystem "False"
     .GyroMuFreq "3.8"
     .DispersiveFittingSchemeEps "Nth Order"
     .MaximalOrderNthModelFitEps "10"
     .ErrorLimitNthModelFitEps "0.1"
     .DispersiveFittingSchemeMu "Nth Order"
     .MaximalOrderNthModelFitMu "10"
     .ErrorLimitNthModelFitMu "0.1"
     .UseGeneralDispersionEps "False"
     .UseGeneralDispersionMu "False"
     .NLAnisotropy "False"
     .NLAStackingFactor "1"
     .NLADirectionX "1"
     .NLADirectionY "0"
     .NLADirectionZ "0"
     .Colour "0", "1", "1" 
     .Wireframe "False" 
     .Reflection "False" 
     .Allowoutline "True" 
     .Transparentoutline "False" 
     .Transparency "0" 
     .Create
End With

'@ define cylinder: component1:ferrite

'[VERSION]2021.5|30.0.1|20210628[/VERSION]
With Cylinder 
     .Reset 
     .Name "ferrite" 
     .Component "component1" 
     .Material "TT1-105 ferrite" 
     .OuterRadius "Rfe" 
     .InnerRadius "0" 
     .Axis "z" 
     .Zrange "tcu", "tcu+tfe" 
     .Xcenter "0" 
     .Ycenter "0" 
     .Segments "0" 
     .Create 
End With

'@ define cylinder: component1:disc

'[VERSION]2021.5|30.0.1|20210628[/VERSION]
With Cylinder 
     .Reset 
     .Name "disc" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .OuterRadius "Rfe" 
     .InnerRadius "0" 
     .Axis "z" 
     .Zrange "tcu+tsub", "tcu+tsub+tcu" 
     .Xcenter "0" 
     .Ycenter "0" 
     .Segments "0" 
     .Create 
End With

'@ activate local coordinates

'[VERSION]2021.5|30.0.1|20210628[/VERSION]
WCS.ActivateWCS "local"

'@ define brick: component1:lin1

'[VERSION]2021.5|30.0.1|20210628[/VERSION]
With Brick
     .Reset 
     .Name "lin1" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Xrange "0", "li" 
     .Yrange "-wli/2", "wli/2" 
     .Zrange "tcu+tsub", "tcu+tsub+tcu" 
     .Create
End With

'@ rotate wcs

'[VERSION]2021.5|30.0.1|20210628[/VERSION]
WCS.RotateWCS "w", "120"

'@ define brick: component1:lin2

'[VERSION]2021.5|30.0.1|20210628[/VERSION]
With Brick
     .Reset 
     .Name "lin2" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Xrange "0", "li" 
     .Yrange "-wli/2", "wli/2" 
     .Zrange "tcu+tsub", "tcu+tsub+tcu" 
     .Create
End With

'@ rotate wcs

'[VERSION]2021.5|30.0.1|20210628[/VERSION]
WCS.RotateWCS "w", "120"

'@ define brick: component1:lin3

'[VERSION]2021.5|30.0.1|20210628[/VERSION]
With Brick
     .Reset 
     .Name "lin3" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Xrange "0", "li" 
     .Yrange "-wli/2", "wli/2" 
     .Zrange "tcu+tsub", "tcu+tsub+tcu" 
     .Create
End With

'@ switch bounding box

'[VERSION]2021.5|30.0.1|20210628[/VERSION]
Plot.DrawBox "False"

'@ define brick: component1:vac1

'[VERSION]2021.5|30.0.1|20210628[/VERSION]
With Brick
     .Reset 
     .Name "vac1" 
     .Component "component1" 
     .Material "Vacuum" 
     .Xrange "48", "56" 
     .Yrange "-wc/2", "wc/2" 
     .Zrange "0", "tcu+tsub+tcu" 
     .Create
End With

'@ boolean subtract shapes: component1:gnd, component1:vac1

'[VERSION]2021.5|30.0.1|20210628[/VERSION]
Solid.Subtract "component1:gnd", "component1:vac1"

'@ define brick: component1:solid1

'[VERSION]2021.5|30.0.1|20210628[/VERSION]
With Brick
     .Reset 
     .Name "solid1" 
     .Component "component1" 
     .Material "Vacuum" 
     .Xrange "st", "en" 
     .Yrange "-wc/2", "wc/2" 
     .Zrange "0", "tcu+tsub+tcu" 
     .Create
End With

'@ boolean subtract shapes: component1:sub, component1:solid1

'[VERSION]2021.5|30.0.1|20210628[/VERSION]
Solid.Subtract "component1:sub", "component1:solid1"

'@ define brick: component1:solid1

'[VERSION]2021.5|30.0.1|20210628[/VERSION]
With Brick
     .Reset 
     .Name "solid1" 
     .Component "component1" 
     .Material "Vacuum" 
     .Xrange "st", "en" 
     .Yrange "-wc/2", "wc/2" 
     .Zrange "0", "tcu+tsub+tcu" 
     .Create
End With

'@ boolean subtract shapes: component1:lin3, component1:solid1

'[VERSION]2021.5|30.0.1|20210628[/VERSION]
Solid.Subtract "component1:lin3", "component1:solid1"

'@ rotate wcs

'[VERSION]2021.5|30.0.1|20210628[/VERSION]
WCS.RotateWCS "w", "120"

'@ define brick: component1:solid1

'[VERSION]2021.5|30.0.1|20210628[/VERSION]
With Brick
     .Reset 
     .Name "solid1" 
     .Component "component1" 
     .Material "Vacuum" 
     .Xrange "st", "en" 
     .Yrange "-wc/2", "wc/2" 
     .Zrange "0", "tcu+tsub+tcu" 
     .Create
End With

'@ boolean subtract shapes: component1:gnd, component1:solid1

'[VERSION]2021.5|30.0.1|20210628[/VERSION]
Solid.Subtract "component1:gnd", "component1:solid1"

'@ define brick: component1:solid1

'[VERSION]2021.5|30.0.1|20210628[/VERSION]
With Brick
     .Reset 
     .Name "solid1" 
     .Component "component1" 
     .Material "Vacuum" 
     .Xrange "st", "en" 
     .Yrange "-wc/2", "wc/2" 
     .Zrange "0", "tcu+tsub+tcu" 
     .Create
End With

'@ boolean subtract shapes: component1:sub, component1:solid1

'[VERSION]2021.5|30.0.1|20210628[/VERSION]
Solid.Subtract "component1:sub", "component1:solid1"

'@ define brick: component1:solid1

'[VERSION]2021.5|30.0.1|20210628[/VERSION]
With Brick
     .Reset 
     .Name "solid1" 
     .Component "component1" 
     .Material "Vacuum" 
     .Xrange "st", "en" 
     .Yrange "-wc/2", "wc/2" 
     .Zrange "0", "tcu+tsub+tcu" 
     .Create
End With

'@ boolean subtract shapes: component1:lin1, component1:solid1

'[VERSION]2021.5|30.0.1|20210628[/VERSION]
Solid.Subtract "component1:lin1", "component1:solid1"

'@ rotate wcs

'[VERSION]2021.5|30.0.1|20210628[/VERSION]
WCS.RotateWCS "w", "120"

'@ define brick: component1:solid1

'[VERSION]2021.5|30.0.1|20210628[/VERSION]
With Brick
     .Reset 
     .Name "solid1" 
     .Component "component1" 
     .Material "Vacuum" 
     .Xrange "st", "en" 
     .Yrange "-wc/2", "wc/2" 
     .Zrange "0", "tcu+tsub+tcu" 
     .Create
End With

'@ boolean subtract shapes: component1:gnd, component1:solid1

'[VERSION]2021.5|30.0.1|20210628[/VERSION]
Solid.Subtract "component1:gnd", "component1:solid1"

'@ define brick: component1:solid1

'[VERSION]2021.5|30.0.1|20210628[/VERSION]
With Brick
     .Reset 
     .Name "solid1" 
     .Component "component1" 
     .Material "Vacuum" 
     .Xrange "st", "en" 
     .Yrange "-wc/2", "wc/2" 
     .Zrange "0", "tcu+tsub+tcu" 
     .Create
End With

'@ boolean subtract shapes: component1:sub, component1:solid1

'[VERSION]2021.5|30.0.1|20210628[/VERSION]
Solid.Subtract "component1:sub", "component1:solid1"

'@ define brick: component1:solid1

'[VERSION]2021.5|30.0.1|20210628[/VERSION]
With Brick
     .Reset 
     .Name "solid1" 
     .Component "component1" 
     .Material "Vacuum" 
     .Xrange "st", "en" 
     .Yrange "-wc/2", "wc/2" 
     .Zrange "0", "tcu+tsub+tcu" 
     .Create
End With

'@ boolean subtract shapes: component1:lin2, component1:solid1

'[VERSION]2021.5|30.0.1|20210628[/VERSION]
Solid.Subtract "component1:lin2", "component1:solid1"

'@ boolean add shapes: component1:disc, component1:lin1

'[VERSION]2021.5|30.0.1|20210628[/VERSION]
Solid.Add "component1:disc", "component1:lin1"

'@ boolean add shapes: component1:lin2, component1:lin3

'[VERSION]2021.5|30.0.1|20210628[/VERSION]
Solid.Add "component1:lin2", "component1:lin3"

'@ boolean add shapes: component1:disc, component1:lin2

'[VERSION]2021.5|30.0.1|20210628[/VERSION]
Solid.Add "component1:disc", "component1:lin2"

'@ define material: Ferrite

'[VERSION]2021.5|30.0.1|20210628[/VERSION]
With Material
     .Reset
     .Name "Ferrite"
     .Folder ""
     .Rho "0.0"
     .ThermalType "Normal"
     .ThermalConductivity "0"
     .SpecificHeat "0", "J/K/kg"
     .DynamicViscosity "0"
     .Emissivity "0"
     .MetabolicRate "0.0"
     .VoxelConvection "0.0"
     .BloodFlow "0"
     .MechanicsType "Unused"
     .FrqType "hf"
     .Type "Normal"
     .MaterialUnit "Frequency", "GHz"
     .MaterialUnit "Geometry", "mm"
     .MaterialUnit "Time", "s"
     .Epsilon "12.699999999999999"
     .Mu "1.0"
     .Sigma "0.0031794"
     .TanD "0.00029999999999999997"
     .TanDFreq "15"
     .TanDGiven "True"
     .TanDModel "ConstSigma"
     .SetConstTanDStrategyEps "UserDefinedOrder"
     .ConstTanDModelOrderEps "3"
     .DjordjevicSarkarUpperFreqEps "0"
     .SetElParametricConductivity "False"
     .ReferenceCoordSystem "Global"
     .CoordSystemType "Cartesian"
     .SigmaM "0.0"
     .TanDM "0.0"
     .TanDMFreq "0.0"
     .TanDMGiven "False"
     .TanDMModel "ConstTanD"
     .SetConstTanDStrategyMu "UserDefinedOrder"
     .ConstTanDModelOrderMu "3"
     .DjordjevicSarkarUpperFreqMu "0"
     .SetMagParametricConductivity "False"
     .DispModelEps "None"
     .DispModelMu "Gyrotropic"
     .MuInfinity "1.0"
     .DispCoeff1Mu "2"
     .DispCoeff2Mu "2800"
     .DispCoeff3Mu "500"
     .DispCoeff4MuX "0.0"
     .DispCoeff4MuY "0.0"
     .DispCoeff4MuZ "1272.77"
     .UseSISystem "False"
     .GyroMuFreq "15"
     .DispersiveFittingSchemeEps "1st Order"
     .DispersiveFittingSchemeMu "1st Order"
     .UseGeneralDispersionEps "False"
     .UseGeneralDispersionMu "False"
     .NLAnisotropy "False"
     .NLAStackingFactor "1"
     .NLADirectionX "1"
     .NLADirectionY "0"
     .NLADirectionZ "0"
     .FrqType "all"
     .Type "Normal"
     .MaterialUnit "Frequency", "GHz"
     .MaterialUnit "Geometry", "mm"
     .MaterialUnit "Time", "s"
     .Epsilon "12.699999999999999"
     .Mu "1.0"
     .Sigma "0.0031794"
     .TanD "0.00029999999999999997"
     .TanDFreq "15"
     .TanDGiven "True"
     .TanDModel "ConstSigma"
     .SetConstTanDStrategyEps "UserDefinedOrder"
     .ConstTanDModelOrderEps "3"
     .DjordjevicSarkarUpperFreqEps "0"
     .SetElParametricConductivity "False"
     .ReferenceCoordSystem "Global"
     .CoordSystemType "Cartesian"
     .SigmaM "0.0"
     .TanDM "0.0"
     .TanDMFreq "0.0"
     .TanDMGiven "False"
     .TanDMModel "ConstSigma"
     .SetConstTanDStrategyMu "UserDefinedOrder"
     .ConstTanDModelOrderMu "3"
     .DjordjevicSarkarUpperFreqMu "0"
     .SetMagParametricConductivity "False"
     .DispModelEps "None"
     .DispModelMu "Gyrotropic"
     .MuInfinity "1.0"
     .DispCoeff1Mu "2"
     .DispCoeff2Mu "2800"
     .DispCoeff3Mu "500"
     .DispCoeff4MuX "0.0"
     .DispCoeff4MuY "0.0"
     .DispCoeff4MuZ "1272.77"
     .UseSISystem "False"
     .GyroMuFreq "15"
     .DispersiveFittingSchemeEps "1st Order"
     .DispersiveFittingSchemeMu "1st Order"
     .UseGeneralDispersionEps "False"
     .UseGeneralDispersionMu "False"
     .NLAnisotropy "False"
     .NLAStackingFactor "1"
     .NLADirectionX "1"
     .NLADirectionY "0"
     .NLADirectionZ "0"
     .Colour "0.980392", "0.988235", "0.596078" 
     .Wireframe "False" 
     .Reflection "False" 
     .Allowoutline "True" 
     .Transparentoutline "False" 
     .Transparency "0" 
     .Create
End With

'@ define cylinder: component1:mag1

'[VERSION]2021.5|30.0.1|20210628[/VERSION]
With Cylinder 
     .Reset 
     .Name "mag1" 
     .Component "component1" 
     .Material "Ferrite" 
     .OuterRadius "Rmag" 
     .InnerRadius "0" 
     .Axis "z" 
     .Zrange "tcu+tsub+tcu+hmag", "tcu+tsub+tcu+hmag+tmag" 
     .Xcenter "0" 
     .Ycenter "0" 
     .Segments "0" 
     .Create 
End With

'@ define cylinder: component1:mag2

'[VERSION]2021.5|30.0.1|20210628[/VERSION]
With Cylinder 
     .Reset 
     .Name "mag2" 
     .Component "component1" 
     .Material "Ferrite" 
     .OuterRadius "Rmag" 
     .InnerRadius "0" 
     .Axis "z" 
     .Zrange "-hmag-tmag", "-hmag" 
     .Xcenter "0" 
     .Ycenter "0" 
     .Segments "0" 
     .Create 
End With

'@ pick face

'[VERSION]2021.5|30.0.1|20210628[/VERSION]
Pick.PickFaceFromId "component1:disc", "31"

'@ define port:1

'[VERSION]2021.5|30.0.1|20210628[/VERSION]
' Port constructed by macro Solver -> Ports -> Calculate port extension coefficient


With Port
  .Reset
  .PortNumber "1"
  .NumberOfModes "1"
  .AdjustPolarization False
  .PolarizationAngle "0.0"
  .ReferencePlaneDistance "0"
  .TextSize "50"
  .Coordinates "Picks"
  .Orientation "Positive"
  .PortOnBound "True"
  .ClipPickedPortToBound "False"
  .XrangeAdd "0", "0"
  .YrangeAdd "1.524*6.18", "1.524*6.18"
  .ZrangeAdd "1.524", "1.524*6.18"
  .Shield "PEC"
  .SingleEnded "False"
  .Create
End With

'@ pick face

'[VERSION]2021.5|30.0.1|20210628[/VERSION]
Pick.PickFaceFromId "component1:disc", "16"

'@ pick face

'[VERSION]2021.5|30.0.1|20210628[/VERSION]
Pick.PickFaceFromId "component1:disc", "16"

'@ define port: 2

'[VERSION]2021.5|30.0.1|20210628[/VERSION]
With Port 
     .Reset 
     .PortNumber "2" 
     .Label ""
     .Folder ""
     .NumberOfModes "1"
     .AdjustPolarization "False"
     .PolarizationAngle "0.0"
     .ReferencePlaneDistance "0"
     .TextSize "50"
     .TextMaxLimit "1"
     .Coordinates "Picks"
     .Orientation "positive"
     .PortOnBound "True"
     .ClipPickedPortToBound "False"
     .Xrange "0", "0.035000000000001"
     .Yrange "0", "3.5"
     .Zrange "0", "0"
     .XrangeAdd "1.524", "k*1.524"
     .YrangeAdd "k*1.524", "k*1.524"
     .ZrangeAdd "0.0", "0.0"
     .SingleEnded "False"
     .WaveguideMonitor "False"
     .Create 
End With

'@ pick face

'[VERSION]2021.5|30.0.1|20210628[/VERSION]
Pick.PickFaceFromId "component1:disc", "4"

'@ pick face

'[VERSION]2021.5|30.0.1|20210628[/VERSION]
Pick.PickFaceFromId "component1:disc", "4"

'@ define port: 3

'[VERSION]2021.5|30.0.1|20210628[/VERSION]
With Port 
     .Reset 
     .PortNumber "3" 
     .Label ""
     .Folder ""
     .NumberOfModes "1"
     .AdjustPolarization "False"
     .PolarizationAngle "0.0"
     .ReferencePlaneDistance "0"
     .TextSize "50"
     .TextMaxLimit "1"
     .Coordinates "Picks"
     .Orientation "positive"
     .PortOnBound "True"
     .ClipPickedPortToBound "False"
     .Xrange "0", "0.035"
     .Yrange "0", "3.5"
     .Zrange "0", "0"
     .XrangeAdd "1.524", "k*1.524"
     .YrangeAdd "k*1.524", "k*1.524"
     .ZrangeAdd "0.0", "0.0"
     .SingleEnded "False"
     .WaveguideMonitor "False"
     .Create 
End With

'@ define frequency domain solver parameters

'[VERSION]2021.5|30.0.1|20210628[/VERSION]
Mesh.SetCreator "High Frequency" 

With FDSolver
     .Reset 
     .SetMethod "Tetrahedral", "General purpose" 
     .OrderTet "Second" 
     .OrderSrf "First" 
     .Stimulation "All", "All" 
     .ResetExcitationList 
     .AutoNormImpedance "False" 
     .NormingImpedance "50" 
     .ModesOnly "False" 
     .ConsiderPortLossesTet "True" 
     .SetShieldAllPorts "False" 
     .AccuracyHex "1e-6" 
     .AccuracyTet "1e-4" 
     .AccuracySrf "1e-3" 
     .LimitIterations "False" 
     .MaxIterations "0" 
     .SetCalcBlockExcitationsInParallel "True", "True", "" 
     .StoreAllResults "False" 
     .StoreResultsInCache "False" 
     .UseHelmholtzEquation "True" 
     .LowFrequencyStabilization "True" 
     .Type "Auto" 
     .MeshAdaptionHex "False" 
     .MeshAdaptionTet "True" 
     .AcceleratedRestart "True" 
     .FreqDistAdaptMode "Distributed" 
     .NewIterativeSolver "True" 
     .TDCompatibleMaterials "False" 
     .ExtrudeOpenBC "False" 
     .SetOpenBCTypeHex "Default" 
     .SetOpenBCTypeTet "Default" 
     .AddMonitorSamples "True" 
     .CalcPowerLoss "True" 
     .CalcPowerLossPerComponent "False" 
     .StoreSolutionCoefficients "True" 
     .UseDoublePrecision "False" 
     .UseDoublePrecision_ML "True" 
     .MixedOrderSrf "False" 
     .MixedOrderTet "False" 
     .PreconditionerAccuracyIntEq "0.15" 
     .MLFMMAccuracy "Default" 
     .MinMLFMMBoxSize "0.3" 
     .UseCFIEForCPECIntEq "True" 
     .UseFastRCSSweepIntEq "false" 
     .UseSensitivityAnalysis "False" 
     .RemoveAllStopCriteria "Hex"
     .AddStopCriterion "All S-Parameters", "0.01", "2", "Hex", "True"
     .AddStopCriterion "Reflection S-Parameters", "0.01", "2", "Hex", "False"
     .AddStopCriterion "Transmission S-Parameters", "0.01", "2", "Hex", "False"
     .RemoveAllStopCriteria "Tet"
     .AddStopCriterion "All S-Parameters", "0.01", "2", "Tet", "True"
     .AddStopCriterion "Reflection S-Parameters", "0.01", "2", "Tet", "False"
     .AddStopCriterion "Transmission S-Parameters", "0.01", "2", "Tet", "False"
     .AddStopCriterion "All Probes", "0.05", "2", "Tet", "True"
     .RemoveAllStopCriteria "Srf"
     .AddStopCriterion "All S-Parameters", "0.01", "2", "Srf", "True"
     .AddStopCriterion "Reflection S-Parameters", "0.01", "2", "Srf", "False"
     .AddStopCriterion "Transmission S-Parameters", "0.01", "2", "Srf", "False"
     .SweepMinimumSamples "3" 
     .SetNumberOfResultDataSamples "1001" 
     .SetResultDataSamplingMode "Automatic" 
     .SweepWeightEvanescent "1.0" 
     .AccuracyROM "1e-4" 
     .AddSampleInterval "", "", "1", "Automatic", "True" 
     .AddSampleInterval "", "", "", "Automatic", "False" 
     .MPIParallelization "False"
     .UseDistributedComputing "False"
     .NetworkComputingStrategy "RunRemote"
     .NetworkComputingJobCount "3"
     .UseParallelization "True"
     .MaxCPUs "1024"
     .MaximumNumberOfCPUDevices "2"
End With

With IESolver
     .Reset 
     .UseFastFrequencySweep "True" 
     .UseIEGroundPlane "False" 
     .SetRealGroundMaterialName "" 
     .CalcFarFieldInRealGround "False" 
     .RealGroundModelType "Auto" 
     .PreconditionerType "Auto" 
     .ExtendThinWireModelByWireNubs "False" 
     .ExtraPreconditioning "False" 
End With

With IESolver
     .SetFMMFFCalcStopLevel "0" 
     .SetFMMFFCalcNumInterpPoints "6" 
     .UseFMMFarfieldCalc "True" 
     .SetCFIEAlpha "0.500000" 
     .LowFrequencyStabilization "False" 
     .LowFrequencyStabilizationML "True" 
     .Multilayer "False" 
     .SetiMoMACC_I "0.0001" 
     .SetiMoMACC_M "0.0001" 
     .DeembedExternalPorts "True" 
     .SetOpenBC_XY "True" 
     .OldRCSSweepDefintion "False" 
     .SetRCSOptimizationProperties "True", "100", "0.00001" 
     .SetAccuracySetting "Custom" 
     .CalculateSParaforFieldsources "True" 
     .ModeTrackingCMA "True" 
     .NumberOfModesCMA "3" 
     .StartFrequencyCMA "-1.0" 
     .SetAccuracySettingCMA "Default" 
     .FrequencySamplesCMA "0" 
     .SetMemSettingCMA "Auto" 
     .CalculateModalWeightingCoefficientsCMA "True" 
End With

'@ define material: Ferrite

'[VERSION]2021.5|30.0.1|20210628[/VERSION]
With Material 
     .Reset 
     .Name "Ferrite"
     .Folder ""
     .Rho "0.0"
     .ThermalType "Normal"
     .ThermalConductivity "0"
     .SpecificHeat "0", "J/K/kg"
     .DynamicViscosity "0"
     .Emissivity "0"
     .MetabolicRate "0.0"
     .VoxelConvection "0.0"
     .BloodFlow "0"
     .MechanicsType "Unused"
     .FrqType "all"
     .Type "Normal"
     .MaterialUnit "Frequency", "GHz"
     .MaterialUnit "Geometry", "mm"
     .MaterialUnit "Time", "s"
     .Epsilon "12.699999999999999"
     .Mu "1.0"
     .Sigma "0.0031794"
     .TanD "0.00029999999999999997"
     .TanDFreq "15"
     .TanDGiven "True"
     .TanDModel "ConstSigma"
     .SetConstTanDStrategyEps "UserDefinedOrder"
     .ConstTanDModelOrderEps "3"
     .DjordjevicSarkarUpperFreqEps "0"
     .SetElParametricConductivity "False"
     .ReferenceCoordSystem "Global"
     .CoordSystemType "Cartesian"
     .SigmaM "0.0"
     .TanDM "0.0"
     .TanDMFreq "0.0"
     .TanDMGiven "False"
     .TanDMModel "ConstSigma"
     .SetConstTanDStrategyMu "UserDefinedOrder"
     .ConstTanDModelOrderMu "3"
     .DjordjevicSarkarUpperFreqMu "0"
     .SetMagParametricConductivity "False"
     .DispModelEps "None"
     .DispModelMu "Gyrotropic"
     .MuInfinity "1.0"
     .DispCoeff1Mu "2"
     .DispCoeff2Mu "2800"
     .DispCoeff3Mu "500"
     .DispCoeff4MuX "0.0"
     .DispCoeff4MuY "0.0"
     .DispCoeff4MuZ "1272.77"
     .UseSISystem "False"
     .GyroMuFreq "15"
     .DispersiveFittingSchemeEps "1st Order"
     .DispersiveFittingSchemeMu "1st Order"
     .UseGeneralDispersionEps "False"
     .UseGeneralDispersionMu "False"
     .NLAnisotropy "False"
     .NLAStackingFactor "1"
     .NLADirectionX "1"
     .NLADirectionY "0"
     .NLADirectionZ "0"
     .FrqType "hf"
     .Type "Normal"
     .MaterialUnit "Frequency", "GHz"
     .MaterialUnit "Geometry", "mm"
     .MaterialUnit "Time", "s"
     .Epsilon "12.699999999999999"
     .Mu "1.0"
     .Sigma "0.0031794"
     .TanD "0.00029999999999999997"
     .TanDFreq "3.75"
     .TanDGiven "True"
     .TanDModel "ConstSigma"
     .SetConstTanDStrategyEps "UserDefinedOrder"
     .ConstTanDModelOrderEps "3"
     .DjordjevicSarkarUpperFreqEps "0"
     .SetElParametricConductivity "False"
     .ReferenceCoordSystem "Global"
     .CoordSystemType "Cartesian"
     .SigmaM "0.0"
     .TanDM "0.0"
     .TanDMFreq "0.0"
     .TanDMGiven "False"
     .TanDMModel "ConstTanD"
     .SetConstTanDStrategyMu "UserDefinedOrder"
     .ConstTanDModelOrderMu "3"
     .DjordjevicSarkarUpperFreqMu "0"
     .SetMagParametricConductivity "False"
     .DispModelEps "None"
     .DispModelMu "Gyrotropic"
     .MuInfinity "1.0"
     .DispCoeff1Mu "2"
     .DispCoeff2Mu "2800"
     .DispCoeff3Mu "500"
     .DispCoeff4MuX "0.0"
     .DispCoeff4MuY "0.0"
     .DispCoeff4MuZ "1272.77"
     .UseSISystem "False"
     .GyroMuFreq "3.75"
     .DispersiveFittingSchemeEps "1st Order"
     .DispersiveFittingSchemeMu "1st Order"
     .UseGeneralDispersionEps "False"
     .UseGeneralDispersionMu "False"
     .NLAnisotropy "False"
     .NLAStackingFactor "1"
     .NLADirectionX "1"
     .NLADirectionY "0"
     .NLADirectionZ "0"
     .Colour "0.980392", "0.988235", "0.596078" 
     .Wireframe "False" 
     .Reflection "False" 
     .Allowoutline "True" 
     .Transparentoutline "False" 
     .Transparency "0" 
     .Create
End With

'@ define material: TT1-105 ferrite

'[VERSION]2021.5|30.0.1|20210628[/VERSION]
With Material 
     .Reset 
     .Name "TT1-105 ferrite"
     .Folder ""
     .Rho "0.0"
     .ThermalType "Normal"
     .ThermalConductivity "0"
     .SpecificHeat "0", "J/K/kg"
     .DynamicViscosity "0"
     .Emissivity "0"
     .MetabolicRate "0.0"
     .VoxelConvection "0.0"
     .BloodFlow "0"
     .MechanicsType "Unused"
     .FrqType "all"
     .Type "Normal"
     .MaterialUnit "Frequency", "GHz"
     .MaterialUnit "Geometry", "mm"
     .MaterialUnit "Time", "ns"
     .MaterialUnit "Temperature", "Kelvin"
     .Epsilon "12.2"
     .Mu "1"
     .Sigma "0.0"
     .TanD "0.00024"
     .TanDFreq "10"
     .TanDGiven "True"
     .TanDModel "ConstTanD"
     .SetConstTanDStrategyEps "AutomaticOrder"
     .ConstTanDModelOrderEps "3"
     .DjordjevicSarkarUpperFreqEps "0"
     .SetElParametricConductivity "False"
     .ReferenceCoordSystem "Global"
     .CoordSystemType "Cartesian"
     .SigmaM "0.0"
     .TanDM "0.0"
     .TanDMFreq "0.0"
     .TanDMGiven "False"
     .TanDMModel "ConstTanD"
     .SetConstTanDStrategyMu "AutomaticOrder"
     .ConstTanDModelOrderMu "3"
     .DjordjevicSarkarUpperFreqMu "0"
     .SetMagParametricConductivity "False"
     .DispModelEps "None"
     .DispModelMu "Gyrotropic"
     .MuInfinity "55"
     .DispCoeff1Mu "1.98"
     .DispCoeff2Mu "1750"
     .DispCoeff3Mu "269"
     .DispCoeff4MuX "0.0"
     .DispCoeff4MuY "0.0"
     .DispCoeff4MuZ "1220"
     .UseSISystem "False"
     .GyroMuFreq "10"
     .DispersiveFittingSchemeEps "Nth Order"
     .MaximalOrderNthModelFitEps "10"
     .ErrorLimitNthModelFitEps "0.1"
     .UseOnlyDataInSimFreqRangeNthModelEps "False"
     .DispersiveFittingSchemeMu "Nth Order"
     .MaximalOrderNthModelFitMu "10"
     .ErrorLimitNthModelFitMu "0.1"
     .UseOnlyDataInSimFreqRangeNthModelMu "False"
     .UseGeneralDispersionEps "False"
     .UseGeneralDispersionMu "False"
     .NLAnisotropy "False"
     .NLAStackingFactor "1"
     .NLADirectionX "1"
     .NLADirectionY "0"
     .NLADirectionZ "0"
     .Colour "0", "1", "1" 
     .Wireframe "False" 
     .Reflection "False" 
     .Allowoutline "True" 
     .Transparentoutline "False" 
     .Transparency "0" 
     .Create
End With

'@ define material: Ferrite

'[VERSION]2021.5|30.0.1|20210628[/VERSION]
With Material 
     .Reset 
     .Name "Ferrite"
     .Folder ""
     .Rho "0.0"
     .ThermalType "Normal"
     .ThermalConductivity "0"
     .SpecificHeat "0", "J/K/kg"
     .DynamicViscosity "0"
     .Emissivity "0"
     .MetabolicRate "0.0"
     .VoxelConvection "0.0"
     .BloodFlow "0"
     .MechanicsType "Unused"
     .FrqType "hf"
     .Type "Normal"
     .MaterialUnit "Frequency", "GHz"
     .MaterialUnit "Geometry", "mm"
     .MaterialUnit "Time", "s"
     .Epsilon "12.699999999999999"
     .Mu "1.0"
     .Sigma "0.000794849"
     .TanD "0.00029999999999999997"
     .TanDFreq "10"
     .TanDGiven "True"
     .TanDModel "ConstSigma"
     .SetConstTanDStrategyEps "UserDefinedOrder"
     .ConstTanDModelOrderEps "3"
     .DjordjevicSarkarUpperFreqEps "0"
     .SetElParametricConductivity "False"
     .ReferenceCoordSystem "Global"
     .CoordSystemType "Cartesian"
     .SigmaM "0.0"
     .TanDM "0.0"
     .TanDMFreq "0.0"
     .TanDMGiven "False"
     .TanDMModel "ConstTanD"
     .SetConstTanDStrategyMu "UserDefinedOrder"
     .ConstTanDModelOrderMu "3"
     .DjordjevicSarkarUpperFreqMu "0"
     .SetMagParametricConductivity "False"
     .DispModelEps "None"
     .DispModelMu "Gyrotropic"
     .MuInfinity "1.0"
     .DispCoeff1Mu "2"
     .DispCoeff2Mu "2800"
     .DispCoeff3Mu "500"
     .DispCoeff4MuX "0.0"
     .DispCoeff4MuY "0.0"
     .DispCoeff4MuZ "1272.77"
     .UseSISystem "False"
     .GyroMuFreq "10"
     .DispersiveFittingSchemeEps "1st Order"
     .DispersiveFittingSchemeMu "1st Order"
     .UseGeneralDispersionEps "False"
     .UseGeneralDispersionMu "False"
     .NLAnisotropy "False"
     .NLAStackingFactor "1"
     .NLADirectionX "1"
     .NLADirectionY "0"
     .NLADirectionZ "0"
     .FrqType "all"
     .Type "Normal"
     .MaterialUnit "Frequency", "GHz"
     .MaterialUnit "Geometry", "mm"
     .MaterialUnit "Time", "s"
     .Epsilon "12.699999999999999"
     .Mu "1.0"
     .Sigma "0.0031794"
     .TanD "0.00029999999999999997"
     .TanDFreq "15"
     .TanDGiven "True"
     .TanDModel "ConstSigma"
     .SetConstTanDStrategyEps "UserDefinedOrder"
     .ConstTanDModelOrderEps "3"
     .DjordjevicSarkarUpperFreqEps "0"
     .SetElParametricConductivity "False"
     .ReferenceCoordSystem "Global"
     .CoordSystemType "Cartesian"
     .SigmaM "0.0"
     .TanDM "0.0"
     .TanDMFreq "0.0"
     .TanDMGiven "False"
     .TanDMModel "ConstSigma"
     .SetConstTanDStrategyMu "UserDefinedOrder"
     .ConstTanDModelOrderMu "3"
     .DjordjevicSarkarUpperFreqMu "0"
     .SetMagParametricConductivity "False"
     .DispModelEps "None"
     .DispModelMu "Gyrotropic"
     .MuInfinity "1.0"
     .DispCoeff1Mu "2"
     .DispCoeff2Mu "2800"
     .DispCoeff3Mu "500"
     .DispCoeff4MuX "0.0"
     .DispCoeff4MuY "0.0"
     .DispCoeff4MuZ "1272.77"
     .UseSISystem "False"
     .GyroMuFreq "15"
     .DispersiveFittingSchemeEps "1st Order"
     .DispersiveFittingSchemeMu "1st Order"
     .UseGeneralDispersionEps "False"
     .UseGeneralDispersionMu "False"
     .NLAnisotropy "False"
     .NLAStackingFactor "1"
     .NLADirectionX "1"
     .NLADirectionY "0"
     .NLADirectionZ "0"
     .Colour "0.980392", "0.988235", "0.596078" 
     .Wireframe "False" 
     .Reflection "False" 
     .Allowoutline "True" 
     .Transparentoutline "False" 
     .Transparency "0" 
     .Create
End With

'@ define material: NdFe35

'[VERSION]2021.5|30.0.1|20210628[/VERSION]
With Material 
     .Reset 
     .Name "NdFe35"
     .Folder ""
     .Rho "0.0"
     .ThermalType "Normal"
     .ThermalConductivity "0"
     .SpecificHeat "0", "J/K/kg"
     .DynamicViscosity "0"
     .Emissivity "0"
     .MetabolicRate "0.0"
     .VoxelConvection "0.0"
     .BloodFlow "0"
     .MechanicsType "Unused"
     .FrqType "all"
     .Type "Normal"
     .MaterialUnit "Frequency", "GHz"
     .MaterialUnit "Geometry", "mm"
     .MaterialUnit "Time", "ns"
     .MaterialUnit "Temperature", "Kelvin"
     .Epsilon "1"
     .Mu "1.099"
     .Sigma "625000"
     .TanD "0.0"
     .TanDFreq "9.4"
     .TanDGiven "False"
     .TanDModel "ConstTanD"
     .SetConstTanDStrategyEps "AutomaticOrder"
     .ConstTanDModelOrderEps "3"
     .DjordjevicSarkarUpperFreqEps "0"
     .SetElParametricConductivity "False"
     .ReferenceCoordSystem "Global"
     .CoordSystemType "Cartesian"
     .SigmaM "0"
     .TanDM "0.0"
     .TanDMFreq "0.0"
     .TanDMGiven "False"
     .TanDMModel "ConstTanD"
     .SetConstTanDStrategyMu "AutomaticOrder"
     .ConstTanDModelOrderMu "3"
     .DjordjevicSarkarUpperFreqMu "0"
     .SetMagParametricConductivity "False"
     .DispModelEps  "None"
     .DispModelMu "Gyrotropic"
     .MuInfinity "1.0"
     .DispCoeff1Mu "2"
     .DispCoeff2Mu "1800"
     .DispCoeff3Mu "240"
     .DispCoeff4MuX "-11824"
     .DispCoeff4MuY "0.0"
     .DispCoeff4MuZ "0.0"
     .UseSISystem "False"
     .GyroMuFreq "10"
     .DispersiveFittingSchemeEps "Nth Order"
     .MaximalOrderNthModelFitEps "10"
     .ErrorLimitNthModelFitEps "0.1"
     .UseOnlyDataInSimFreqRangeNthModelEps "False"
     .DispersiveFittingSchemeMu "Nth Order"
     .MaximalOrderNthModelFitMu "10"
     .ErrorLimitNthModelFitMu "0.1"
     .UseOnlyDataInSimFreqRangeNthModelMu "False"
     .UseGeneralDispersionEps "False"
     .UseGeneralDispersionMu "False"
     .NLAnisotropy "False"
     .NLAStackingFactor "1"
     .NLADirectionX "1"
     .NLADirectionY "0"
     .NLADirectionZ "0"
     .Colour "0", "1", "1" 
     .Wireframe "False" 
     .Reflection "False" 
     .Allowoutline "True" 
     .Transparentoutline "False" 
     .Transparency "0" 
     .Create
End With

'@ define material colour: NdFe35

'[VERSION]2021.5|30.0.1|20210628[/VERSION]
With Material 
     .Name "NdFe35"
     .Folder ""
     .Colour "1", "0", "0" 
     .Wireframe "False" 
     .Reflection "False" 
     .Allowoutline "True" 
     .Transparentoutline "False" 
     .Transparency "0" 
     .ChangeColour 
End With

'@ delete shape: component1:mag1

'[VERSION]2021.5|30.0.1|20210628[/VERSION]
Solid.Delete "component1:mag1"

'@ delete shape: component1:mag2

'[VERSION]2021.5|30.0.1|20210628[/VERSION]
Solid.Delete "component1:mag2"

'@ define cylinder: component1:mag1

'[VERSION]2021.5|30.0.1|20210628[/VERSION]
With Cylinder 
     .Reset 
     .Name "mag1" 
     .Component "component1" 
     .Material "NdFe35" 
     .OuterRadius "Rmag" 
     .InnerRadius "0" 
     .Axis "z" 
     .Zrange "tcu+tsub+tcu+hmag", "tcu+tsub+tcu+hmag+tmag" 
     .Xcenter "0" 
     .Ycenter "0" 
     .Segments "0" 
     .Create 
End With

'@ define cylinder: component1:mag2

'[VERSION]2021.5|30.0.1|20210628[/VERSION]
With Cylinder 
     .Reset 
     .Name "mag2" 
     .Component "component1" 
     .Material "NdFe35" 
     .OuterRadius "Rmag" 
     .InnerRadius "0" 
     .Axis "z" 
     .Zrange "-hmag-tmag", "-hmag" 
     .Xcenter "0" 
     .Ycenter "0" 
     .Segments "0" 
     .Create 
End With

'@ define material: Folder1/Magnet

'[VERSION]2021.5|30.0.1|20210628[/VERSION]
With Material 
     .Reset 
     .Name "Magnet"
     .Folder "Folder1"
     .Rho "0.0"
     .ThermalType "Normal"
     .ThermalConductivity "0"
     .SpecificHeat "0", "J/K/kg"
     .DynamicViscosity "0"
     .Emissivity "0"
     .MetabolicRate "0.0"
     .VoxelConvection "0.0"
     .BloodFlow "0"
     .MechanicsType "Unused"
     .FrqType "all"
     .Type "Pec"
     .MaterialUnit "Frequency", "GHz"
     .MaterialUnit "Geometry", "mm"
     .MaterialUnit "Time", "ns"
     .MaterialUnit "Temperature", "Kelvin"
     .Epsilon "1.0"
     .Mu "1.0"
     .ReferenceCoordSystem "Global"
     .CoordSystemType "Cartesian"
     .NLAnisotropy "False"
     .NLAStackingFactor "1"
     .NLADirectionX "1"
     .NLADirectionY "0"
     .NLADirectionZ "0"
     .Colour "0.752941", "0.752941", "0.752941" 
     .Wireframe "False" 
     .Reflection "False" 
     .Allowoutline "True" 
     .Transparentoutline "False" 
     .Transparency "0" 
     .Create
End With

'@ delete shape: component1:mag1

'[VERSION]2021.5|30.0.1|20210628[/VERSION]
Solid.Delete "component1:mag1"

'@ delete shape: component1:mag2

'[VERSION]2021.5|30.0.1|20210628[/VERSION]
Solid.Delete "component1:mag2"

'@ new component: component2

'[VERSION]2021.5|30.0.1|20210628[/VERSION]
Component.New "component2"

'@ define cylinder: component2:mag1

'[VERSION]2021.5|30.0.1|20210628[/VERSION]
With Cylinder 
     .Reset 
     .Name "mag1" 
     .Component "component2" 
     .Material "Folder1/Magnet" 
     .OuterRadius "Rmag" 
     .InnerRadius "0" 
     .Axis "z" 
     .Zrange "tcu+tfe+tcu+hmag", "tcu+tfe+tcu+hmag+tmag" 
     .Xcenter "0" 
     .Ycenter "0" 
     .Segments "0" 
     .Create 
End With

'@ define cylinder: component2:mag2

'[VERSION]2021.5|30.0.1|20210628[/VERSION]
With Cylinder 
     .Reset 
     .Name "mag2" 
     .Component "component2" 
     .Material "Folder1/Magnet" 
     .OuterRadius "Rmag" 
     .InnerRadius "0" 
     .Axis "z" 
     .Zrange "-hmag-tmag", "-hmag" 
     .Xcenter "0" 
     .Ycenter "0" 
     .Segments "0" 
     .Create 
End With

'@ delete shape: component1:ferrite

'[VERSION]2021.5|30.0.1|20210628[/VERSION]
Solid.Delete "component1:ferrite"

'@ define cylinder: component1:ferrite

'[VERSION]2021.5|30.0.1|20210628[/VERSION]
With Cylinder 
     .Reset 
     .Name "ferrite" 
     .Component "component1" 
     .Material "Ferrite" 
     .OuterRadius "Rfe" 
     .InnerRadius "0" 
     .Axis "z" 
     .Zrange "tcu", "tcu+tfe" 
     .Xcenter "-0" 
     .Ycenter "-0" 
     .Segments "0" 
     .Create 
End With

'@ define frequency range

'[VERSION]2021.5|30.0.1|20210628[/VERSION]
Solver.FrequencyRange "2.5", "5"

'@ activate global coordinates

'[VERSION]2021.5|30.0.1|20210628[/VERSION]
WCS.ActivateWCS "global"

'@ switch working plane

'[VERSION]2021.5|30.0.1|20210628[/VERSION]
Plot.DrawWorkplane "false"

