(defglobal ?*paso-counter* = 1)

(deffunction incrementar-paso-counter ()
    (bind ?*paso-counter* (+ ?*paso-counter* 1))
)

(defrule iniciar
    (comenzar_operacion (paciente Paciente) (cirujano1 CirujanoJefe) (cirujano2 Cirujano2) (enfermera Enfermera) (anes Anestesiólogo))
    ?patient <- (patient (name Paciente) (state listo) (location ?patient-location) (operation no))
    (surgeon (name CirujanoJefe) (location ?patient-location))
    (surgeon (name Cirujano2) (location ?patient-location))
    (nurse (name Enfermera) (location ?patient-location))
    (anest (name Anestesiólogo) (location ?patient-location))
    ?plan <- (plan (pasos $?pasos))
    =>
    (bind ?nuevo-paso (str-cat ?*paso-counter* ". comenzar_operacion (paciente Paciente) (cirujano1 CirujanoJefe) (cirujano2 Cirujano2) (enfermera Enfermera) (anes Anestesiólogo)"))
    (modify ?plan (pasos (create$ ?pasos ?nuevo-paso)))
    (modify ?patient (state en_operacion))
    (incrementar-paso-counter)
)

(defrule informar_cirujano
    (informa_inicio (persona1 Cirujano2) (persona2 CirujanoJefe))
    (patient (name Paciente) (state en_operacion) (location ?patient-location) (operation no))
    ?cirujano <- (surgeon (name CirujanoJefe) (location ?patient-location) (state no))
    (surgeon (name Cirujano2) (location ?patient-location) (state no))
    ?plan <- (plan (pasos $?pasos))
    =>
    (bind ?nuevo-paso (str-cat ?*paso-counter* ". (informa_inicio (persona1 Cirujano2) (persona2 CirujanoJefe)) comenzar intervención"))
    (modify ?plan (pasos (create$ ?pasos ?nuevo-paso)))
    (modify ?cirujano (state listo))
    (incrementar-paso-counter)
)

(defrule ordenar_anestesia
    (ordena (persona1 CirujanoJefe) (persona2 Anestesiólogo))
    ?patient <- (patient (name Paciente) (state en_operacion) (location ?patient-location) (operation no))
    (surgeon (name CirujanoJefe) (location ?patient-location) (state listo))
    (anest (name Anestesiólogo) (location ?patient-location) (aplicar_anestesia no))
    ?plan <- (plan (pasos $?pasos))
    =>
    (bind ?nuevo-paso (str-cat ?*paso-counter* ". (ordena (persona1 CirujanoJefe) (persona2 Anestesiólogo)) confirmar y aplicar el anestésico"))
    (modify ?plan (pasos (create$ ?pasos ?nuevo-paso)))
    (modify ?patient (state anestesiado))
    (incrementar-paso-counter)
)

(defrule confirmar_anestesia
    (confirma (persona1 Anestesiólogo) (persona2 CirujanoJefe))
    (patient (name Paciente) (state anestesiado) (location ?patient-location) (operation no))
    (surgeon (name CirujanoJefe) (location ?patient-location) (state listo))
    ?anestesia <-(anest (name Anestesiólogo) (location ?patient-location) (aplicar_anestesia no))
    ?plan <- (plan (pasos $?pasos))
    =>
    (bind ?nuevo-paso (str-cat ?*paso-counter* ". (confirma (persona1 Anestesiólogo) (persona2 CirujanoJefe)) que el paciente se encuentra sedado"))
    (modify ?plan (pasos (create$ ?pasos ?nuevo-paso)))
    (modify ?anestesia (aplicar_anestesia si))
    (incrementar-paso-counter)
)

(defrule ordenar_cirujano2
    (ordena (persona1 CirujanoJefe) (persona2 Cirujano2))
    (patient (name Paciente) (state anestesiado) (location ?patient-location) (operation no))
    (surgeon (name CirujanoJefe) (location ?patient-location) (state listo))
    ?cirujano <- (surgeon (name Cirujano2) (location ?patient-location) (state no))
    (anest (name Anestesiólogo) (location ?patient-location) (aplicar_anestesia si))
    ?plan <- (plan (pasos $?pasos))
    =>
    (bind ?nuevo-paso (str-cat ?*paso-counter* ". (ordena (persona1 CirujanoJefe) (persona2 Cirujano2)) comenzar la intervención"))
    (modify ?plan (pasos (create$ ?pasos ?nuevo-paso)))
    (modify ?cirujano (state listo))
    (incrementar-paso-counter)
)

(defrule solicitar_instrumentos
    (solicita_instrumentos (persona1 Cirujano2) (persona2 Enfermera))
    (patient (name Paciente) (state anestesiado) (location ?patient-location) (operation no))
    (surgeon (name Cirujano2) (location ?patient-location) (state listo) (instruments no))
    ?enfermera <- (nurse (name Enfermera) (location ?patient-location) (instruments no))
    ?plan <- (plan (pasos $?pasos))
    =>
    (bind ?nuevo-paso (str-cat ?*paso-counter* ". (solicitar_instrumentos (persona1 Cirujano2) (persona2 Enfermera))"))
    (modify ?plan (pasos (create$ ?pasos ?nuevo-paso)))
    (modify ?enfermera (instruments si))
    (incrementar-paso-counter)
)

(defrule proveer_instrumentos
    (provee_instrumentos (persona1 Enfermera) (persona2 Cirujano2))
    (patient (name Paciente) (state anestesiado) (location ?patient-location) (operation no))
    ?surgeon <- (surgeon (name Cirujano2) (location ?patient-location) (state listo) (instruments no))
    ?enfermera <- (nurse (name Enfermera) (location ?patient-location) (instruments si))
    ?plan <- (plan (pasos $?pasos))
    =>
    (bind ?nuevo-paso (str-cat ?*paso-counter* ". (provee_instrumentos (persona1 Enfermera) (persona2 Cirujano2))"))
    (modify ?plan (pasos (create$ ?pasos ?nuevo-paso)))
    (modify ?enfermera (instruments no))
    (modify ?surgeon (instruments si))
    (incrementar-paso-counter)
)

(defrule terminar_intervención
    (realiza_intervencion (persona1 Cirujano2) (persona2 Paciente))
    ?paciente <- (patient (name Paciente) (state anestesiado) (location ?patient-location) (operation no))
    (surgeon (name Cirujano2) (location ?patient-location) (state listo) (instruments si))
    ?plan <- (plan (pasos $?pasos))
    =>
    (bind ?nuevo-paso (str-cat ?*paso-counter* ". (realiza_intervencion (persona1 Cirujano2) (persona2 Paciente))"))
    (modify ?plan (pasos (create$ ?pasos ?nuevo-paso)))
    (modify ?paciente (operation si))
    (incrementar-paso-counter)
)

(defrule informar_cirujano2
    (informa_final (persona1 Cirujano2) (persona2 CirujanoJefe))
    (patient (name Paciente) (state anestesiado) (location ?patient-location) (operation si))
    ?cirujano <- (surgeon (name Cirujano2) (location ?patient-location) (state listo) (instruments si))
    ?plan <- (plan (pasos $?pasos))
    =>
    (bind ?nuevo-paso (str-cat ?*paso-counter* ". (informa_final (persona1 Cirujano2) (persona2 CirujanoJefe)) sobre la finalización de la intervención"))
    (modify ?plan (pasos (create$ ?pasos ?nuevo-paso)))
    (modify ?cirujano (state finalizado))
    (incrementar-paso-counter)
)

(defrule finalizar
    (llevar_paciente (persona1 Enfermera) (persona2 Paciente))
    (surgeon (name Cirujano2) (location ?patient-location) (state finalizado) (instruments si))
    ?paciente <- (patient (name Paciente) (state anestesiado) (location ?patient-location) (operation si))
    ?enfermera <- (nurse (name Enfermera) (location ?patient-location) (instruments no))
    ?plan <- (plan (pasos $?pasos))
    =>
    (bind ?nuevo-paso (str-cat ?*paso-counter* ". (llevar_paciente (persona1 Enfermera) (persona2 Paciente))"))
    (modify ?plan (pasos (create$ ?pasos ?nuevo-paso)))
    (modify ?paciente (location SalaDeRecuperación))
    (modify ?enfermera (location SalaDeRecuperación))
    (incrementar-paso-counter)
)