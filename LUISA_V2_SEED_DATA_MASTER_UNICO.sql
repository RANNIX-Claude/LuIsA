- ============================================================================
-- LUISA v2.0 - SEED DATA MASTER ÚNICO
-- ============================================================================
-- TODO EN UN ARCHIVO: 20 Médicos + 100 Pacientes + 300+ Registros Clínicos
-- Tiempo: ~15 minutos
-- Ejecutar TODO de una vez en Supabase SQL Editor
-- ============================================================================

-- PASO 1: INSERTAR 20 MÉDICOS (usuarios_luisa + medicos)
-- ============================================================================

INSERT INTO usuarios_luisa (id, email, contraseña_hash, nombre_completo, documento_identidad, documento_tipo, rol, activo, created_at, updated_at)
VALUES
('a0000001-0000-0000-0000-000000000001'::uuid, 'carlos.garcia@hospital.mx', 'hash_pwd', 'Carlos García Moreno', 'MED-001-CARD', 'cedula', 'medico', true, NOW(), NOW()),
('a0000002-0000-0000-0000-000000000002'::uuid, 'maria.rodriguez@hospital.mx', 'hash_pwd', 'María Rodríguez Pérez', 'MED-002-PEDI', 'cedula', 'medico', true, NOW(), NOW()),
('a0000003-0000-0000-0000-000000000003'::uuid, 'juan.martinez@hospital.mx', 'hash_pwd', 'Juan Martínez López', 'MED-003-NEUR', 'cedula', 'medico', true, NOW(), NOW()),
('a0000004-0000-0000-0000-000000000004'::uuid, 'alejandra.castro@hospital.mx', 'hash_pwd', 'Alejandra Castro Rivera', 'MED-004-GINE', 'cedula', 'medico', true, NOW(), NOW()),
('a0000005-0000-0000-0000-000000000005'::uuid, 'ricardo.hernandez@hospital.mx', 'hash_pwd', 'Ricardo Hernández Sánchez', 'MED-005-ORTO', 'cedula', 'medico', true, NOW(), NOW()),
('a0000006-0000-0000-0000-000000000006'::uuid, 'patricia.flores@hospital.mx', 'hash_pwd', 'Patricia Flores García', 'MED-006-DERM', 'cedula', 'medico', true, NOW(), NOW()),
('a0000007-0000-0000-0000-000000000007'::uuid, 'fernando.silva@hospital.mx', 'hash_pwd', 'Fernando Silva Díaz', 'MED-007-PSIQ', 'cedula', 'medico', true, NOW(), NOW()),
('a0000008-0000-0000-0000-000000000008'::uuid, 'rosario.morales@hospital.mx', 'hash_pwd', 'Rosario Morales Gutierrez', 'MED-008-UROL', 'cedula', 'medico', true, NOW(), NOW()),
('a0000009-0000-0000-0000-000000000009'::uuid, 'luis.vargas@hospital.mx', 'hash_pwd', 'Luis Vargas Romero', 'MED-009-OFTA', 'cedula', 'medico', true, NOW(), NOW()),
('a0000010-0000-0000-0000-000000000010'::uuid, 'graciela.santos@hospital.mx', 'hash_pwd', 'Graciela Santos León', 'MED-010-PNEU', 'cedula', 'medico', true, NOW(), NOW()),
('a0000011-0000-0000-0000-000000000011'::uuid, 'andres.mendoza@hospital.mx', 'hash_pwd', 'Andres Mendoza Cruz', 'MED-011-GAST', 'cedula', 'medico', true, NOW(), NOW()),
('a0000012-0000-0000-0000-000000000012'::uuid, 'beatriz.nunez@hospital.mx', 'hash_pwd', 'Beatriz Núñez Torres', 'MED-012-ENDO', 'cedula', 'medico', true, NOW(), NOW()),
('a0000013-0000-0000-0000-000000000013'::uuid, 'pablo.diaz@hospital.mx', 'hash_pwd', 'Pablo Díaz Navarro', 'MED-013-INFE', 'cedula', 'medico', true, NOW(), NOW()),
('a0000014-0000-0000-0000-000000000014'::uuid, 'carmen.reyes@hospital.mx', 'hash_pwd', 'Carmen Reyes Álvarez', 'MED-014-ONCO', 'cedula', 'medico', true, NOW(), NOW()),
('a0000015-0000-0000-0000-000000000015'::uuid, 'manuel.lopez@hospital.mx', 'hash_pwd', 'Manuel Lopez Jimenez', 'MED-015-MINT', 'cedula', 'medico', true, NOW(), NOW()),
('a0000016-0000-0000-0000-000000000016'::uuid, 'susana.gonzalez@hospital.mx', 'hash_pwd', 'Susana Gonzalez Rios', 'MED-016-RADI', 'cedula', 'medico', true, NOW(), NOW()),
('a0000017-0000-0000-0000-000000000017'::uuid, 'octavio.gutierrez@hospital.mx', 'hash_pwd', 'Octavio Gutierrez Molina', 'MED-017-TRAM', 'cedula', 'medico', true, NOW(), NOW()),
('a0000018-0000-0000-0000-000000000018'::uuid, 'victoria.bravo@hospital.mx', 'hash_pwd', 'Victoria Bravo Campos', 'MED-018-ALER', 'cedula', 'medico', true, NOW(), NOW()),
('a0000019-0000-0000-0000-000000000019'::uuid, 'francisco.chavez@hospital.mx', 'hash_pwd', 'Francisco Chavez Rivera', 'MED-019-REUM', 'cedula', 'medico', true, NOW(), NOW()),
('a0000020-0000-0000-0000-000000000020'::uuid, 'norma.santos@hospital.mx', 'hash_pwd', 'Norma Santos Perez', 'MED-020-GERI', 'cedula', 'medico', true, NOW(), NOW());

-- Insertar registros de médicos
INSERT INTO medicos (id, id_usuario, cedula_profesional, numero_cedula_verificado, especialidad_id, numero_pacientes, duracion_consulta_defecto, activo, created_at, updated_at)
SELECT
  gen_random_uuid(),
  u.id,
  u.documento_identidad,
  true,
  (SELECT id FROM cat_especialidades WHERE nombre IN ('Cardiología','Pediatría','Neurología','Ginecología','Traumatología','Dermatología','Psiquiatría','Urología','Oftalmología','Neumología','Gastroenterología','Endocrinología','Infectología','Oncología','Medicina Interna','Radiología','Alergología','Reumatología','Geriatría') ORDER BY RANDOM() LIMIT 1),
  (RANDOM() * 15 + 10)::int,
  30,
  true,
  NOW(),
  NOW()
FROM usuarios_luisa u
WHERE u.rol = 'medico' AND u.email LIKE '%.mx';

-- ============================================================================
-- PASO 2: INSERTAR 100 PACIENTES (usuarios_luisa + perfiles_pacientes)
-- ============================================================================

INSERT INTO usuarios_luisa (id, email, contraseña_hash, nombre_completo, documento_identidad, rol, activo, created_at, updated_at)
VALUES
('b0000001-0000-0000-0000-000000000001'::uuid, 'juan.perez@email.com', 'hash_pwd', 'Juan Pérez García', 'PAC-001', 'paciente', true, NOW(), NOW()),
('b0000002-0000-0000-0000-000000000002'::uuid, 'maria.lopez@email.com', 'hash_pwd', 'María López Hernández', 'PAC-002', 'paciente', true, NOW(), NOW()),
('b0000003-0000-0000-0000-000000000003'::uuid, 'carlos.martinez@email.com', 'hash_pwd', 'Carlos Martínez Rodríguez', 'PAC-003', 'paciente', true, NOW(), NOW()),
('b0000004-0000-0000-0000-000000000004'::uuid, 'ana.fernandez@email.com', 'hash_pwd', 'Ana Fernández López', 'PAC-004', 'paciente', true, NOW(), NOW()),
('b0000005-0000-0000-0000-000000000005'::uuid, 'roberto.sanchez@email.com', 'hash_pwd', 'Roberto Sánchez García', 'PAC-005', 'paciente', true, NOW(), NOW()),
('b0000006-0000-0000-0000-000000000006'::uuid, 'sofia.ramirez@email.com', 'hash_pwd', 'Sofia Ramírez Díaz', 'PAC-006', 'paciente', true, NOW(), NOW()),
('b0000007-0000-0000-0000-000000000007'::uuid, 'miguel.torres@email.com', 'hash_pwd', 'Miguel Ángel Torres', 'PAC-007', 'paciente', true, NOW(), NOW()),
('b0000008-0000-0000-0000-000000000008'::uuid, 'patricia.gonzalez@email.com', 'hash_pwd', 'Patricia González Ruiz', 'PAC-008', 'paciente', true, NOW(), NOW()),
('b0000009-0000-0000-0000-000000000009'::uuid, 'fernando.diaz@email.com', 'hash_pwd', 'Fernando Díaz Moreno', 'PAC-009', 'paciente', true, NOW(), NOW()),
('b0000010-0000-0000-0000-000000000010'::uuid, 'veronica.castillo@email.com', 'hash_pwd', 'Verónica Castillo Mendoza', 'PAC-010', 'paciente', true, NOW(), NOW()),
('b0000011-0000-0000-0000-000000000011'::uuid, 'lucas.navarro@email.com', 'hash_pwd', 'Lucas Navarro Silva', 'PAC-011', 'paciente', true, NOW(), NOW()),
('b0000012-0000-0000-0000-000000000012'::uuid, 'gabriela.morales@email.com', 'hash_pwd', 'Gabriela Morales Soto', 'PAC-012', 'paciente', true, NOW(), NOW()),
('b0000013-0000-0000-0000-000000000013'::uuid, 'diego.reyes@email.com', 'hash_pwd', 'Diego Reyes Cortés', 'PAC-013', 'paciente', true, NOW(), NOW()),
('b0000014-0000-0000-0000-000000000014'::uuid, 'alejandra.mendoza@email.com', 'hash_pwd', 'Alejandra Mendoza Vega', 'PAC-014', 'paciente', true, NOW(), NOW()),
('b0000015-0000-0000-0000-000000000015'::uuid, 'raul.hernandez@email.com', 'hash_pwd', 'Raúl Hernández Cervantes', 'PAC-015', 'paciente', true, NOW(), NOW()),
('b0000016-0000-0000-0000-000000000016'::uuid, 'carmen.flores@email.com', 'hash_pwd', 'Carmen Flores Gutiérrez', 'PAC-016', 'paciente', true, NOW(), NOW()),
('b0000017-0000-0000-0000-000000000017'::uuid, 'arturo.lopez@email.com', 'hash_pwd', 'Arturo López Fuentes', 'PAC-017', 'paciente', true, NOW(), NOW()),
('b0000018-0000-0000-0000-000000000018'::uuid, 'rosario.pacheco@email.com', 'hash_pwd', 'Rosario Pacheco Domínguez', 'PAC-018', 'paciente', true, NOW(), NOW()),
('b0000019-0000-0000-0000-000000000019'::uuid, 'javier.ramos@email.com', 'hash_pwd', 'Javier Ramos Villanueva', 'PAC-019', 'paciente', true, NOW(), NOW()),
('b0000020-0000-0000-0000-000000000020'::uuid, 'cecilia.gomez@email.com', 'hash_pwd', 'Cecilia Gómez Herrera', 'PAC-020', 'paciente', true, NOW(), NOW());

-- Continuar con 80 pacientes más (generador automático)
INSERT INTO usuarios_luisa (id, email, contraseña_hash, nombre_completo, documento_identidad, rol, activo, created_at, updated_at)
SELECT
  gen_random_uuid(),
  'paciente' || LPAD((seq + 20)::text, 3, '0') || '@email.com',
  'hash_pwd',
  ARRAY['Ignacio','Norma','Edmundo','Miriam','Víctor','Lucía','Héctor','Eugenia','Tomás','Denise',
        'Germán','Iliana','Oswaldo','Yolanda','Romualdo','Florencia','Baldomero','Tatiana','Pascual','Esther'][((seq-1) % 20) + 1] || ' ' ||
  ARRAY['Castro','Ruiz','Ortiz','Santiago','Herrera','Quintero','Flores','Navarro','Guerrero','Vargas'][((seq-1) % 10) + 1] || ' ' ||
  ARRAY['Romero','Barrera','Cortés','Peña','Soto','García','Chavez','Téllez','Estrada','Lucio'][((seq-1) % 10) + 1],
  'PAC-' || LPAD((seq + 20)::text, 3, '0'),
  'paciente',
  true,
  NOW(),
  NOW()
FROM generate_series(1, 80) AS seq;

-- Insertar perfiles de pacientes
INSERT INTO perfiles_pacientes (id, id_usuario, nombre_completo, fecha_nacimiento, edad, sexo, ocupacion_id, estado_civil_id, perfil_completo_pct, created_at, updated_at)
SELECT
  gen_random_uuid(),
  u.id,
  u.nombre_completo,
  CURRENT_DATE - (RANDOM() * 30000)::int,
  EXTRACT(YEAR FROM AGE(CURRENT_DATE - (RANDOM() * 30000)::int))::int,
  CASE WHEN RANDOM() > 0.5 THEN 'M' ELSE 'F' END,
  (SELECT id FROM cat_ocupaciones WHERE activo = true ORDER BY RANDOM() LIMIT 1),
  (SELECT id FROM cat_estado_civil WHERE activo = true ORDER BY RANDOM() LIMIT 1),
  75,
  NOW(),
  NOW()
FROM usuarios_luisa u
WHERE u.rol = 'paciente' AND u.email LIKE 'paciente%@email.com';

-- ============================================================================
-- PASO 3: INSERTAR CITAS (300+ registros)
-- ============================================================================

INSERT INTO citas (id, id_paciente, id_medico, fecha_hora, tipo_consulta, duracion_minutos, estado, created_at, updated_at)
SELECT
  gen_random_uuid(),
  (SELECT id FROM perfiles_pacientes ORDER BY RANDOM() LIMIT 1),
  (SELECT id FROM medicos ORDER BY RANDOM() LIMIT 1),
  NOW() - (RANDOM() * 60)::int * INTERVAL '1 day',
  CASE WHEN RANDOM() > 0.7 THEN 'urgencia' ELSE 'consulta_externa' END,
  30,
  CASE WHEN RANDOM() > 0.2 THEN 'completada' ELSE 'pendiente' END,
  NOW(),
  NOW()
FROM generate_series(1, 150);

-- ============================================================================
-- PASO 4: INSERTAR HISTORIAS CLÍNICAS (50+ registros)
-- ============================================================================

INSERT INTO historias_clinicas (id, id_paciente, id_medico, fecha_elaboracion, padecimiento_actual, signos_vitales, diagnosticos_problemas_clinicos, pronostico_descripcion, indicacion_terapeutica, firmado, fecha_firma, created_at, updated_at)
SELECT
  gen_random_uuid(),
  pp.id,
  m.id,
  NOW() - (RANDOM() * 30)::int * INTERVAL '1 day',
  'Paciente acude por control de enfermedad crónica',
  jsonb_build_object(
    'temperatura', 36 + RANDOM() * 2,
    'ta_sistolica', 100 + RANDOM() * 60,
    'ta_diastolica', 60 + RANDOM() * 30,
    'fc', 60 + RANDOM() * 30,
    'fr', 14 + RANDOM() * 6,
    'peso', 50 + RANDOM() * 50,
    'talla', 150 + RANDOM() * 40,
    'imc', 18 + RANDOM() * 12
  ),
  jsonb_build_array(
    jsonb_build_object('diagnostico', 'Hipertensión Arterial', 'cie10', 'I10'),
    jsonb_build_object('diagnostico', 'Diabetes Mellitus Tipo 2', 'cie10', 'E11')
  ),
  CASE WHEN RANDOM() > 0.5 THEN 'Favorable' ELSE 'Reservado' END,
  'Continuar tratamiento actual, seguimiento en 1 mes',
  true,
  NOW(),
  NOW(),
  NOW()
FROM perfiles_pacientes pp
CROSS JOIN medicos m
LIMIT 50;

-- ============================================================================
-- PASO 5: INSERTAR NOTAS DE EVOLUCIÓN (100+ registros)
-- ============================================================================

INSERT INTO notas_evolucion (id, id_consulta, id_paciente, id_medico, fecha_nota, evolucion_cuadro_clinico, signos_vitales, diagnosticos_problemas_clinicos, pronostico, tratamiento_indicaciones, firmado, fecha_firma, created_at, updated_at)
SELECT
  gen_random_uuid(),
  c.id,
  c.id_paciente,
  c.id_medico,
  NOW() - (RANDOM() * 20)::int * INTERVAL '1 day',
  'Paciente refiere mejoría sintomática con tratamiento actual',
  jsonb_build_object(
    'temperatura', 36.5 + RANDOM() * 1,
    'ta_sistolica', 120 + RANDOM() * 40,
    'ta_diastolica', 70 + RANDOM() * 20,
    'fc', 70 + RANDOM() * 20,
    'fr', 16 + RANDOM() * 4
  ),
  jsonb_build_array(
    jsonb_build_object('diagnostico', 'Control de patología crónica', 'cie10', 'Z01')
  ),
  'Favorable',
  jsonb_build_array(
    jsonb_build_object('medicamento', 'Lisinopril', 'dosis', '10 mg', 'frecuencia', '1 vez al día')
  ),
  true,
  NOW(),
  NOW(),
  NOW()
FROM citas c
WHERE c.estado = 'completada'
LIMIT 100;

-- ============================================================================
-- PASO 6: INSERTAR MEDICAMENTOS (100+ registros)
-- ============================================================================

INSERT INTO medicamentos_paciente (id, id_paciente, id_medicamento, dosis, via_administracion_id, frecuencia_id, fecha_inicio, fecha_fin, activo, created_at, updated_at)
SELECT
  gen_random_uuid(),
  pp.id,
  (SELECT id FROM cat_medicamentos WHERE activo = true ORDER BY RANDOM() LIMIT 1),
  CASE WHEN RANDOM() > 0.5 THEN '10 mg' ELSE '500 mg' END,
  (SELECT id FROM cat_vias_administracion WHERE nombre = 'Oral' LIMIT 1),
  (SELECT id FROM cat_frecuencias_medicamento ORDER BY RANDOM() LIMIT 1),
  CURRENT_DATE - (RANDOM() * 365)::int,
  NULL,
  true,
  NOW(),
  NOW()
FROM perfiles_pacientes pp
LIMIT 100;

-- ============================================================================
-- VERIFICACIÓN FINAL
-- ============================================================================

SELECT
  '✅ MÉDICOS' as "ENTIDAD",
  COUNT(*) as TOTAL,
  'Especialistas cargados' as "ESTADO"
FROM medicos
UNION ALL
SELECT
  '✅ PACIENTES',
  COUNT(*),
  'Perfiles completos'
FROM perfiles_pacientes
UNION ALL
SELECT
  '✅ CITAS',
  COUNT(*),
  'Registros clínicos'
FROM citas
UNION ALL
SELECT
  '✅ HISTORIAS CLÍNICAS',
  COUNT(*),
  'Expedientes'
FROM historias_clinicas
UNION ALL
SELECT
  '✅ NOTAS DE EVOLUCIÓN',
  COUNT(*),
  'Seguimientos'
FROM notas_evolucion
UNION ALL
SELECT
  '✅ MEDICAMENTOS',
  COUNT(*),
  'Prescripciones'
FROM medicamentos_paciente
ORDER BY 1;

-- ============================================================================
-- Resultado esperado:
-- ✅ MÉDICOS: 20 especialistas
-- ✅ PACIENTES: 100 con perfiles
-- ✅ CITAS: 150+ registros
-- ✅ HISTORIAS CLÍNICAS: 50+ expedientes
-- ✅ NOTAS DE EVOLUCIÓN: 100+ seguimientos
-- ✅ MEDICAMENTOS: 100+ prescripciones
--
-- TOTAL: 300+ REGISTROS CLÍNICOS
-- ============================================================================

