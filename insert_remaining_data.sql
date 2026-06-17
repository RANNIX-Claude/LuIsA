-- Insertar 15 notas de evolución clínica
INSERT INTO notas_evolucion (id, id_paciente, id_medico, subjetivo, plan)
SELECT
    gen_random_uuid() as id,
    pp.id as id_paciente,
    m.id as id_medico,
    ARRAY[
        'Paciente refiere dolor de cabeza intermitente desde hace 3 días, acompañado de mareos al cambiar de posición.',
        'Consulta por control de diabetes mellitus tipo 2. Refiere cumplimiento con medicamentos. Glucemias en casa promedio 140-160.',
        'Paciente acude por molestias abdominales postprandiales. Niega síntomas de alarma. Toma omeprazol regularmente.',
        'Refiere fatiga generalizada y dificultad para concentrarse en el trabajo durante la última semana.',
        'Paciente reporta aumento de peso de 3 kg en el último mes a pesar de dieta. Sigue siendo sedentario.',
        'Acude por revisión de presión arterial. Reporta stress laboral importante. Cumple con antihipertensivos.',
        'Consulta por molestia en articulación de rodilla izquierda al subir escaleras hace 2 semanas.'
    ][((ROW_NUMBER() OVER ()) % 7)] as subjetivo,
    'Continuar con medicamentos actuales. Realizar seguimiento en 4 semanas. Estudios si es necesario.' as plan
FROM (
    SELECT pp.id, ROW_NUMBER() OVER (ORDER BY pp.id) as rn
    FROM perfiles_pacientes pp
    LIMIT 15
) pp
CROSS JOIN (
    SELECT m.id, ROW_NUMBER() OVER (ORDER BY m.id) as med_rn
    FROM medicos m
) m
WHERE m.med_rn <= 1
ON CONFLICT DO NOTHING;

-- Insertar 10 vacunas
INSERT INTO vacunas_paciente (id, id_paciente, nombre_vacuna, fecha_aplicacion, proxima_dosis)
SELECT
    gen_random_uuid() as id,
    pp.id as id_paciente,
    ARRAY[
        'Influenza', 'COVID-19', 'Hepatitis B', 'Tétanos', 'Neumocócica',
        'Herpes Zóster', 'Meningocócica', 'Tosferina', 'Sarampión', 'Varicela'
    ][((ROW_NUMBER() OVER ()) % 10) + 1] as nombre_vacuna,
    CURRENT_DATE - (RANDOM() * 365)::int as fecha_aplicacion,
    CURRENT_DATE + 365 as proxima_dosis
FROM (
    SELECT pp.id, ROW_NUMBER() OVER (ORDER BY pp.id) as rn
    FROM perfiles_pacientes pp
    LIMIT 10
) pp
ON CONFLICT DO NOTHING;
