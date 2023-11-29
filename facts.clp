(deffacts initial-facts
   (patient (name Paciente) (state listo) (location quirofano) (operation no))
   (surgeon (name CirujanoJefe) (location quirofano) (state no) (instruments no))
   (surgeon (name Cirujano2) (location quirofano) (state no) (instruments no))
   (anest (name Anestesiólogo) (location quirofano) (aplicar_anestesia no))
   (nurse (name Enfermera) (location quirofano) (instruments no))
   (plan (pasos))
)


