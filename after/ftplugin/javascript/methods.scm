; Object literal methods: `foo: function () {}` / `foo: () => {}`
(pair
  key: (property_identifier) @method_name
  value: (function_expression))

(pair
  key: (property_identifier) @method_name
  value: (arrow_function))

; Class methods and object shorthand methods: `foo() {}`
(method_definition
  name: (property_identifier) @method_name)

; Top-level (or nested) declarations: `function foo() {}` / `function* foo() {}`
(function_declaration
  name: (identifier) @method_name)

(generator_function_declaration
  name: (identifier) @method_name)

; Function-valued bindings: `const foo = () => {}` / `const foo = function () {}`
(variable_declarator
  name: (identifier) @method_name
  value: [
    (arrow_function)
    (function_expression)
  ])

; vim: filetype=query
