SELECT table_name, column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'public'
AND table_name IN ('citas','historias_clinicas','notas_evolucion','medicos','perfiles_pacientes','medicamentos_paciente')
ORDER BY table_name, ordinal_position;