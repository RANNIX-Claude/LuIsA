-- Inyectar relaciones doctor-paciente
-- Distribuir pacientes entre medicos (5-7 por medico)

INSERT INTO doctor_patient_relationships (id_medico, id_paciente, activo, fecha_asignacion)
SELECT
  m.id,
  p.id,
  true,
  CURRENT_DATE
FROM medicos m
CROSS JOIN LATERAL (
  SELECT id FROM perfiles_pacientes
  ORDER BY RANDOM()
  LIMIT 6
) p
ON CONFLICT DO NOTHING;
