SELECT COUNT(*) as total_relaciones FROM doctor_patient_relationships;
SELECT id_medico, COUNT(*) as pacientes_asignados FROM doctor_patient_relationships GROUP BY id_medico ORDER BY pacientes_asignados DESC LIMIT 5;
