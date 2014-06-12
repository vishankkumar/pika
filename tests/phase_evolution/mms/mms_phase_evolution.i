[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 20
  ny = 20
  uniform_refine = 2
  elem_type = QUAD4
[]

[Variables]
  [./phi]
    block = 0
  [../]
[]

[AuxVariables]
  active = 'u T'
  [./abs_error]
  [../]
  [./u]
    block = 0
  [../]
  [./T]
    block = 0
  [../]
[]

[Functions]
  [./u_func]
    type = ParsedFunction
    value = 0.5*sin(4.0*x*y)
  [../]
  [./T_func]
    type = ParsedFunction
    value = -10*x*y+273
  [../]
  [./phi_func]
    type = ParsedFunction
    value = t*sin(4.0*pi*x)*sin(4*pi*y)
  [../]
[]

[Kernels]
  active = 'mms phi_time'
  [./phi_time]
    type = PikaTimeDerivative
    variable = phi
    property = tau
    block = 0
  [../]
  [./phase_transition]
    type = PhaseTransition
    variable = phi
    mob_name = mobility
    chemical_potential = u
  [../]
  [./mms]
    type = PhaseEvolutionSourceMMS
    variable = phi
    property_user_object = property_uo
    block = 0
  [../]
  [./phi_time]
    type = PikaTimeDerivative
    variable = phi
    property = tau
    block = 0
  [../]
  [./phi_square_gradient]
    type = ACInterface
    variable = phi
    mob_name = mobility
    kappa_name = interface_thickness_squared
    block = 0
  [../]
  [./phi_double_well]
    type = PhaseFieldPotential
    variable = phi
    mob_name = mobility
    block = 0
  [../]
[]

[AuxKernels]
  active = 'u_exact T_exact'
  [./error_aux]
    type = ErrorFunctionAux
    variable = abs_error
    function = u_func
    solution_variable = u
  [../]
  [./u_exact]
    type = FunctionAux
    variable = u
    function = u_func
    block = 0
  [../]
  [./T_exact]
    type = FunctionAux
    variable = T
    function = T_func
    block = 0
  [../]
[]

[BCs]
  [./all]
    type = FunctionDirichletBC
    variable = phi
    boundary = 'bottom left top right'
    function = phi_func
  [../]
[]

[Materials]
  [./ice_props]
    type = IceProperties
    block = 0
    property_user_object = property_uo
    temperature = T
  [../]
  [./constant_props]
    type = ConstantProperties
    block = 0
    property_user_object = property_uo
  [../]
  [./phase_field_props]
    type = PhaseFieldProperties
    block = 0
    property_user_object = property_uo
    temperature = T
  [../]
  [./air]
    type = AirProperties
    block = 0
    property_user_object = property_uo
    temperature = T
  [../]
[]

[UserObjects]
  [./property_uo]
    type = ChemicalPotentialPropertyUserObject
  [../]
[]

[Executioner]
  type = Transient
  num_steps = 10
  dt = .1
  end_time = 1
[]

[Outputs]
  exodus = true
  console = false
  [./console]
    type = Console
    linear_residuals = true
  [../]
[]

[ICs]
  [./phi_ic]
    function = phi_func
    variable = phi
    type = FunctionIC
    block = 0
  [../]
  [./T_ic]
    function = T_func
    variable = T
    type = FunctionIC
  [../]
  [./u_ic]
    function = u_func
    variable = u
    type = FunctionIC
  [../]
[]

