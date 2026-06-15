-- ============================================================================
-- LUISA v2.0 - SEED DATA MASTER (VERSIÓN SIMPLIFICADA)
-- UN ARCHIVO ÚNICO - 20 MÉDICOS + 100 PACIENTES + 300+ REGISTROS
-- ============================================================================

-- PASO 1: INSERTAR 20 MÉDICOS
-- ============================================================================

INSERT INTO usuarios_luisa (id, email, contraseña_hash, nombre_completo, documento_identidad, rol, activo, created_at, updated_at) VALUES
('a0000001-0000-0000-0000-000000000001'::uuid, 'carlos.garcia@hospital.mx', 'hash', 'Carlos García', 'MED-001', 'medico', true, NOW(), NOW()),
('a0000002-0000-0000-0000-000000000002'::uuid, 'maria.rodriguez@hospital.mx', 'hash', 'María Rodríguez', 'MED-002', 'medico', true, NOW(), NOW()),
('a0000003-0000-0000-0000-000000000003'::uuid, 'juan.martinez@hospital.mx', 'hash', 'Juan Martínez', 'MED-003', 'medico', true, NOW(), NOW()),
('a0000004-0000-0000-0000-000000000004'::uuid, 'alejandra.castro@hospital.mx', 'hash', 'Alejandra Castro', 'MED-004', 'medico', true, NOW(), NOW()),
('a0000005-0000-0000-0000-000000000005'::uuid, 'ricardo.hernandez@hospital.mx', 'hash', 'Ricardo Hernández', 'MED-005', 'medico', true, NOW(), NOW()),
('a0000006-0000-0000-0000-000000000006'::uuid, 'patricia.flores@hospital.mx', 'hash', 'Patricia Flores', 'MED-006', 'medico', true, NOW(), NOW()),
('a0000007-0000-0000-0000-000000000007'::uuid, 'fernando.silva@hospital.mx', 'hash', 'Fernando Silva', 'MED-007', 'medico', true, NOW(), NOW()),
('a0000008-0000-0000-0000-000000000008'::uuid, 'rosario.morales@hospital.mx', 'hash', 'Rosario Morales', 'MED-008', 'medico', true, NOW(), NOW()),
('a0000009-0000-0000-0000-000000000009'::uuid, 'luis.vargas@hospital.mx', 'hash', 'Luis Vargas', 'MED-009', 'medico', true, NOW(), NOW()),
('a0000010-0000-0000-0000-000000000010'::uuid, 'graciela.santos@hospital.mx', 'hash', 'Graciela Santos', 'MED-010', 'medico', true, NOW(), NOW()),
('a0000011-0000-0000-0000-000000000011'::uuid, 'andres.mendoza@hospital.mx', 'hash', 'Andres Mendoza', 'MED-011', 'medico', true, NOW(), NOW()),
('a0000012-0000-0000-0000-000000000012'::uuid, 'beatriz.nunez@hospital.mx', 'hash', 'Beatriz Núñez', 'MED-012', 'medico', true, NOW(), NOW()),
('a0000013-0000-0000-0000-000000000013'::uuid, 'pablo.diaz@hospital.mx', 'hash', 'Pablo Díaz', 'MED-013', 'medico', true, NOW(), NOW()),
('a0000014-0000-0000-0000-000000000014'::uuid, 'carmen.reyes@hospital.mx', 'hash', 'Carmen Reyes', 'MED-014', 'medico', true, NOW(), NOW()),
('a0000015-0000-0000-0000-000000000015'::uuid, 'manuel.lopez@hospital.mx', 'hash', 'Manuel Lopez', 'MED-015', 'medico', true, NOW(), NOW()),
('a0000016-0000-0000-0000-000000000016'::uuid, 'susana.gonzalez@hospital.mx', 'hash', 'Susana Gonzalez', 'MED-016', 'medico', true, NOW(), NOW()),
('a0000017-0000-0000-0000-000000000017'::uuid, 'octavio.gutierrez@hospital.mx', 'hash', 'Octavio Gutierrez', 'MED-017', 'medico', true, NOW(), NOW()),
('a0000018-0000-0000-0000-000000000018'::uuid, 'victoria.bravo@hospital.mx', 'hash', 'Victoria Bravo', 'MED-018', 'medico', true, NOW(), NOW()),
('a0000019-0000-0000-0000-000000000019'::uuid, 'francisco.chavez@hospital.mx', 'hash', 'Francisco Chavez', 'MED-019', 'medico', true, NOW(), NOW()),
('a0000020-0000-0000-0000-000000000020'::uuid, 'norma.santos@hospital.mx', 'hash', 'Norma Santos', 'MED-020', 'medico', true, NOW(), NOW());

-- Crear registros de médicos
INSERT INTO medicos (id, id_usuario, cedula_profesional, numero_cedula_verificado, especialidad_id, numero_pacientes, duracion_consulta_defecto, activo, created_at, updated_at)
SELECT
  gen_random_uuid(),
  u.id,
  u.documento_identidad,
  true,
  (SELECT id FROM cat_especialidades WHERE activo = true ORDER BY RANDOM() LIMIT 1),
  (RANDOM() * 15 + 10)::int,
  30,
  true,
  NOW(),
  NOW()
FROM usuarios_luisa u
WHERE u.rol = 'medico';

-- ============================================================================
-- PASO 2: INSERTAR 100 PACIENTES
-- ============================================================================

INSERT INTO usuarios_luisa (id, email, contraseña_hash, nombre_completo, documento_identidad, rol, activo, created_at, updated_at) VALUES
('b0000001-0000-0000-0000-000000000001'::uuid, 'paciente001@email.com', 'hash', 'Juan Pérez García', 'PAC-001', 'paciente', true, NOW(), NOW()),
('b0000002-0000-0000-0000-000000000002'::uuid, 'paciente002@email.com', 'hash', 'María López Hernández', 'PAC-002', 'paciente', true, NOW(), NOW()),
('b0000003-0000-0000-0000-000000000003'::uuid, 'paciente003@email.com', 'hash', 'Carlos Martínez Rodríguez', 'PAC-003', 'paciente', true, NOW(), NOW()),
('b0000004-0000-0000-0000-000000000004'::uuid, 'paciente004@email.com', 'hash', 'Ana Fernández López', 'PAC-004', 'paciente', true, NOW(), NOW()),
('b0000005-0000-0000-0000-000000000005'::uuid, 'paciente005@email.com', 'hash', 'Roberto Sánchez García', 'PAC-005', 'paciente', true, NOW(), NOW()),
('b0000006-0000-0000-0000-000000000006'::uuid, 'paciente006@email.com', 'hash', 'Sofia Ramírez Díaz', 'PAC-006', 'paciente', true, NOW(), NOW()),
('b0000007-0000-0000-0000-000000000007'::uuid, 'paciente007@email.com', 'hash', 'Miguel Ángel Torres', 'PAC-007', 'paciente', true, NOW(), NOW()),
('b0000008-0000-0000-0000-000000000008'::uuid, 'paciente008@email.com', 'hash', 'Patricia González Ruiz', 'PAC-008', 'paciente', true, NOW(), NOW()),
('b0000009-0000-0000-0000-000000000009'::uuid, 'paciente009@email.com', 'hash', 'Fernando Díaz Moreno', 'PAC-009', 'paciente', true, NOW(), NOW()),
('b0000010-0000-0000-0000-000000000010'::uuid, 'paciente010@email.com', 'hash', 'Verónica Castillo Mendoza', 'PAC-010', 'paciente', true, NOW(), NOW()),
('b0000011-0000-0000-0000-000000000011'::uuid, 'paciente011@email.com', 'hash', 'Lucas Navarro Silva', 'PAC-011', 'paciente', true, NOW(), NOW()),
('b0000012-0000-0000-0000-000000000012'::uuid, 'paciente012@email.com', 'hash', 'Gabriela Morales Soto', 'PAC-012', 'paciente', true, NOW(), NOW()),
('b0000013-0000-0000-0000-000000000013'::uuid, 'paciente013@email.com', 'hash', 'Diego Reyes Cortés', 'PAC-013', 'paciente', true, NOW(), NOW()),
('b0000014-0000-0000-0000-000000000014'::uuid, 'paciente014@email.com', 'hash', 'Alejandra Mendoza Vega', 'PAC-014', 'paciente', true, NOW(), NOW()),
('b0000015-0000-0000-0000-000000000015'::uuid, 'paciente015@email.com', 'hash', 'Raúl Hernández Cervantes', 'PAC-015', 'paciente', true, NOW(), NOW()),
('b0000016-0000-0000-0000-000000000016'::uuid, 'paciente016@email.com', 'hash', 'Carmen Flores Gutiérrez', 'PAC-016', 'paciente', true, NOW(), NOW()),
('b0000017-0000-0000-0000-000000000017'::uuid, 'paciente017@email.com', 'hash', 'Arturo López Fuentes', 'PAC-017', 'paciente', true, NOW(), NOW()),
('b0000018-0000-0000-0000-000000000018'::uuid, 'paciente018@email.com', 'hash', 'Rosario Pacheco Domínguez', 'PAC-018', 'paciente', true, NOW(), NOW()),
('b0000019-0000-0000-0000-000000000019'::uuid, 'paciente019@email.com', 'hash', 'Javier Ramos Villanueva', 'PAC-019', 'paciente', true, NOW(), NOW()),
('b0000020-0000-0000-0000-000000000020'::uuid, 'paciente020@email.com', 'hash', 'Cecilia Gómez Herrera', 'PAC-020', 'paciente', true, NOW(), NOW());

-- Generar pacientes 21-100
DO $$
DECLARE
  v_count INT := 21;
BEGIN
  WHILE v_count <= 100 LOOP
    INSERT INTO usuarios_luisa (id, email, contraseña_hash, nombre_completo, documento_identidad, rol, activo, created_at, updated_at)
    VALUES (
      gen_random_uuid(),
      'paciente' || LPAD(v_count::text, 3, '0') || '@email.com',
      'hash',
      'Paciente Número ' || v_count,
      'PAC-' || LPAD(v_count::text, 3, '0'),
      'paciente',
      true,
      NOW(),
      NOW()
    );
    v_count := v_count + 1;
  END LOOP;
END $$;

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
  80,
  NOW(),
  NOW()
FROM usuarios_luisa u
WHERE u.rol = 'paciente';

-- ============================================================================
-- PASO 3: INSERTAR CITAS (150+ registros)
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
    'temperatura', ROUND((36.0 + RANDOM() * 2)::numeric, 1),
    'ta_sistolica', ROUND(100 + RANDOM() * 60),
    'ta_diastolica', ROUND(60 + RANDOM() * 30),
    'fc', ROUND(60 + RANDOM() * 30),
    'fr', ROUND(14 + RANDOM() * 6)
  ),
  jsonb_build_array(
    jsonb_build_object('diagnostico', 'Hipertensión Arterial', 'cie10', 'I10')
  ),
  CASE WHEN RANDOM() > 0.5 THEN 'Favorable' ELSE 'Reservado' END,
  'Continuar tratamiento, seguimiento mensual',
  true,
  NOW(),
  NOW(),
  NOW()
FROM perfiles_pacientes pp
CROSS JOIN medicos m
ORDER BY RANDOM()
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
  'Paciente refiere mejoría con tratamiento',
  jsonb_build_object(
    'temperatura', ROUND((36.5 + RANDOM() * 1)::numeric, 1),
    'ta_sistolica', ROUND(120 + RANDOM() * 40),
    'ta_diastolica', ROUND(70 + RANDOM() * 20),
    'fc', ROUND(70 + RANDOM() * 20)
  ),
  jsonb_build_array(
    jsonb_build_object('diagnostico', 'Control de patología', 'cie10', 'Z01')
  ),
  'Favorable',
  jsonb_build_array(
    jsonb_build_object('medicamento', 'Tratamiento continuado')
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
  '10 mg',
  (SELECT id FROM cat_vias_administracion WHERE nombre = 'Oral' LIMIT 1),
  (SELECT id FROM cat_frecuencias_medicamento WHERE activo = true ORDER BY RANDOM() LIMIT 1),
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

SELECT 'CARGA COMPLETADA' as "RESULTADO";

SELECT
  'Médicos' as "ENTIDAD",
  COUNT(*) as "TOTAL"
FROM medicos
UNION ALL
SELECT 'Pacientes', COUNT(*) FROM perfiles_pacientes
UNION ALL
SELECT 'Citas', COUNT(*) FROM citas
UNION ALL
SELECT 'Historias Clínicas', COUNT(*) FROM historias_clinicas
UNION ALL
SELECT 'Notas de Evolución', COUNT(*) FROM notas_evolucion
UNION ALL
SELECT 'Medicamentos', COUNT(*) FROM medicamentos_paciente
ORDER BY 1;

-- ============================================================================
-- FIN - TODO COMPLETADO
-- ============================================================================

