;; extends

(import_clause
 (named_imports
  (import_specifier
   name: (identifier) @variable.import)))

;(variable_declarator
;  name: (identifier) @variable.declaration)
(variable_declarator
  (identifier) @variable.declaration)

;(variable_declarator
;  name: (object_pattern
;    (object_assignment_pattern
;      left: (shorthand_property_identifier_pattern) @variable.declaration)))
(variable_declarator
  (object_pattern
    (object_assignment_pattern
      (shorthand_property_identifier_pattern) @variable.declaration)))

;(variable_declarator
;  name: (object_pattern
;    (shorthand_property_identifier_pattern) @variable.declaration))
(variable_declarator
  (object_pattern
    (shorthand_property_identifier_pattern) @variable.declaration))

;(variable_declarator
;  name: (array_pattern
;    (identifier) @variable.declaration))
(variable_declarator
  (array_pattern
    (identifier) @variable.declaration))

(pair (property_identifier) @variable.declaration)
(object (shorthand_property_identifier) @variable.declaration)
(property_signature (property_identifier) @variable.declaration)
