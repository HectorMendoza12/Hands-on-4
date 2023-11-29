(deftemplate patient
    (slot name)
    (slot state)
    (slot location)
    (slot operation)
)

(deftemplate surgeon
    (slot name)
    (slot location)
    (slot state)
    (slot instruments)
)

(deftemplate nurse
    (slot name)
    (slot location)
    (slot instruments)
)

(deftemplate anest
    (slot name)
    (slot location)
    (slot aplicar_anestesia)
)

(deftemplate comenzar_operacion
    (slot paciente)
    (slot cirujano1)
    (slot cirujano2)
    (slot enfermera)
    (slot anes)
)

(deftemplate informa_inicio
    (slot persona1)
    (slot persona2)
)

(deftemplate informa_final
    (slot persona1)
    (slot persona2)
)

(deftemplate ordena
    (slot persona1)
    (slot persona2)
)

(deftemplate confirma
    (slot persona1)
    (slot persona2)
)

(deftemplate solicita_instrumentos
    (slot persona1)
    (slot persona2)
)

(deftemplate provee_instrumentos
    (slot persona1)
    (slot persona2)
)

(deftemplate realiza_intervencion
    (slot persona1)
    (slot persona2)
)

(deftemplate llevar_paciente
    (slot persona1)
    (slot persona2)
)

(deftemplate plan
    (multislot pasos)
)