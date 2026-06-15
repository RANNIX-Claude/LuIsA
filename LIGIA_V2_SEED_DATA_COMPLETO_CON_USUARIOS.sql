-- ============================================================================
-- LIGIA v2.0 - SEED DATA COMPLETO CON USUARIOS AUTENTICABLES
-- 20 MÉDICOS + 100 PACIENTES + 10 ADMINISTRADORES FAMILIARES
-- TODO CON CONTRASEÑAS QUE FUNCIONAN (bcrypt)
-- ============================================================================

-- CONTRASEÑAS USADAS (hasheadas con bcrypt):
-- Médicos: medico123
-- Pacientes: paciente123
-- Administradores: admin123

-- ============================================================================
-- PASO 1: INSERTAR 20 MÉDICOS CON USUARIOS AUTENTICABLES
-- ============================================================================

INSERT INTO usuarios_ligia (id, email, contraseña_hash, nombre_completo, documento_identidad, rol, activo, created_at, updated_at) VALUES
('a0000001-0000-0000-0000-000000000001'::uuid, 'medico001@hospital.mx', crypt('medico123', gen_salt('bf')), 'Carlos García Moreno', 'MED-001', 'medico', true, NOW(), NOW()),
('a0000002-0000-0000-0000-000000000002'::uuid, 'medico002@hospital.mx', crypt('medico123', gen_salt('bf')), 'María Rodríguez Pérez', 'MED-002', 'medico', true, NOW(), NOW()),
('a0000003-0000-0000-0000-000000000003'::uuid, 'medico003@hospital.mx', crypt('medico123', gen_salt('bf')), 'Juan Martínez López', 'MED-003', 'medico', true, NOW(), NOW()),
('a0000004-0000-0000-0000-000000000004'::uuid, 'medico004@hospital.mx', crypt('medico123', gen_salt('bf')), 'Alejandra Castro Rivera', 'MED-004', 'medico', true, NOW(), NOW()),
('a0000005-0000-0000-0000-000000000005'::uuid, 'medico005@hospital.mx', crypt('medico123', gen_salt('bf')), 'Ricardo Hernández Sánchez', 'MED-005', 'medico', true, NOW(), NOW()),
('a0000006-0000-0000-0000-000000000006'::uuid, 'medico006@hospital.mx', crypt('medico123', gen_salt('bf')), 'Patricia Flores García', 'MED-006', 'medico', true, NOW(), NOW()),
('a0000007-0000-0000-0000-000000000007'::uuid, 'medico007@hospital.mx', crypt('medico123', gen_salt('bf')), 'Fernando Silva Díaz', 'MED-007', 'medico', true, NOW(), NOW()),
('a0000008-0000-0000-0000-000000000008'::uuid, 'medico008@hospital.mx', crypt('medico123', gen_salt('bf')), 'Rosario Morales Gutierrez', 'MED-008', 'medico', true, NOW(), NOW()),
('a0000009-0000-0000-0000-000000000009'::uuid, 'medico009@hospital.mx', crypt('medico123', gen_salt('bf')), 'Luis Vargas Romero', 'MED-009', 'medico', true, NOW(), NOW()),
('a0000010-0000-0000-0000-000000000010'::uuid, 'medico010@hospital.mx', crypt('medico123', gen_salt('bf')), 'Graciela Santos León', 'MED-010', 'medico', true, NOW(), NOW()),
('a0000011-0000-0000-0000-000000000011'::uuid, 'medico011@hospital.mx', crypt('medico123', gen_salt('bf')), 'Andres Mendoza Cruz', 'MED-011', 'medico', true, NOW(), NOW()),
('a0000012-0000-0000-0000-000000000012'::uuid, 'medico012@hospital.mx', crypt('medico123', gen_salt('bf')), 'Beatriz Núñez Torres', 'MED-012', 'medico', true, NOW(), NOW()),
('a0000013-0000-0000-0000-000000000013'::uuid, 'medico013@hospital.mx', crypt('medico123', gen_salt('bf')), 'Pablo Díaz Navarro', 'MED-013', 'medico', true, NOW(), NOW()),
('a0000014-0000-0000-0000-000000000014'::uuid, 'medico014@hospital.mx', crypt('medico123', gen_salt('bf')), 'Carmen Reyes Álvarez', 'MED-014', 'medico', true, NOW(), NOW()),
('a0000015-0000-0000-0000-000000000015'::uuid, 'medico015@hospital.mx', crypt('medico123', gen_salt('bf')), 'Manuel Lopez Jimenez', 'MED-015', 'medico', true, NOW(), NOW()),
('a0000016-0000-0000-0000-000000000016'::uuid, 'medico016@hospital.mx', crypt('medico123', gen_salt('bf')), 'Susana Gonzalez Rios', 'MED-016', 'medico', true, NOW(), NOW()),
('a0000017-0000-0000-0000-000000000017'::uuid, 'medico017@hospital.mx', crypt('medico123', gen_salt('bf')), 'Octavio Gutierrez Molina', 'MED-017', 'medico', true, NOW(), NOW()),
('a0000018-0000-0000-0000-000000000018'::uuid, 'medico018@hospital.mx', crypt('medico123', gen_salt('bf')), 'Victoria Bravo Campos', 'MED-018', 'medico', true, NOW(), NOW()),
('a0000019-0000-0000-0000-000000000019'::uuid, 'medico019@hospital.mx', crypt('medico123', gen_salt('bf')), 'Francisco Chavez Rivera', 'MED-019', 'medico', true, NOW(), NOW()),
('a0000020-0000-0000-0000-000000000020'::uuid, 'medico020@hospital.mx', crypt('medico123', gen_salt('bf')), 'Norma Santos Perez', 'MED-020', 'medico', true, NOW(), NOW());

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
FROM usuarios_ligia u
WHERE u.rol = 'medico';

-- ============================================================================
-- PASO 2: INSERTAR 100 PACIENTES CON USUARIOS AUTENTICABLES
-- ============================================================================

-- Primeros 20 pacientes (nombres específicos)
INSERT INTO usuarios_ligia (id, email, contraseña_hash, nombre_completo, documento_identidad, rol, activo, created_at, updated_at) VALUES
('b0000001-0000-0000-0000-000000000001'::uuid, 'paciente001@email.com', crypt('paciente123', gen_salt('bf')), 'Juan Pérez García', 'PAC-001', 'paciente', true, NOW(), NOW()),
('b0000002-0000-0000-0000-000000000002'::uuid, 'paciente002@email.com', crypt('paciente123', gen_salt('bf')), 'María López Hernández', 'PAC-002', 'paciente', true, NOW(), NOW()),
('b0000003-0000-0000-0000-000000000003'::uuid, 'paciente003@email.com', crypt('paciente123', gen_salt('bf')), 'Carlos Martínez Rodríguez', 'PAC-003', 'paciente', true, NOW(), NOW()),
('b0000004-0000-0000-0000-000000000004'::uuid, 'paciente004@email.com', crypt('paciente123', gen_salt('bf')), 'Ana Fernández López', 'PAC-004', 'paciente', true, NOW(), NOW()),
('b0000005-0000-0000-0000-000000000005'::uuid, 'paciente005@email.com', crypt('paciente123', gen_salt('bf')), 'Roberto Sánchez García', 'PAC-005', 'paciente', true, NOW(), NOW()),
('b0000006-0000-0000-0000-000000000006'::uuid, 'paciente006@email.com', crypt('paciente123', gen_salt('bf')), 'Sofia Ramírez Díaz', 'PAC-006', 'paciente', true, NOW(), NOW()),
('b0000007-0000-0000-0000-000000000007'::uuid, 'paciente007@email.com', crypt('paciente123', gen_salt('bf')), 'Miguel Ángel Torres', 'PAC-007', 'paciente', true, NOW(), NOW()),
('b0000008-0000-0000-0000-000000000008'::uuid, 'paciente008@email.com', crypt('paciente123', gen_salt('bf')), 'Patricia González Ruiz', 'PAC-008', 'paciente', true, NOW(), NOW()),
('b0000009-0000-0000-0000-000000000009'::uuid, 'paciente009@email.com', crypt('paciente123', gen_salt('bf')), 'Fernando Díaz Moreno', 'PAC-009', 'paciente', true, NOW(), NOW()),
('b0000010-0000-0000-0000-000000000010'::uuid, 'paciente010@email.com', crypt('paciente123', gen_salt('bf')), 'Verónica Castillo Mendoza', 'PAC-010', 'paciente', true, NOW(), NOW()),
('b0000011-0000-0000-0000-000000000011'::uuid, 'paciente011@email.com', crypt('paciente123', gen_salt('bf')), 'Lucas Navarro Silva', 'PAC-011', 'paciente', true, NOW(), NOW()),
('b0000012-0000-0000-0000-000000000012'::uuid, 'paciente012@email.com', crypt('paciente123', gen_salt('bf')), 'Gabriela Morales Soto', 'PAC-012', 'paciente', true, NOW(), NOW()),
('b0000013-0000-0000-0000-000000000013'::uuid, 'paciente013@email.com', crypt('paciente123', gen_salt('bf')), 'Diego Reyes Cortés', 'PAC-013', 'paciente', true, NOW(), NOW()),
('b0000014-0000-0000-0000-000000000014'::uuid, 'paciente014@email.com', crypt('paciente123', gen_salt('bf')), 'Alejandra Mendoza Vega', 'PAC-014', 'paciente', true, NOW(), NOW()),
('b0000015-0000-0000-0000-000000000015'::uuid, 'paciente015@email.com', crypt('paciente123', gen_salt('bf')), 'Raúl Hernández Cervantes', 'PAC-015', 'paciente', true, NOW(), NOW()),
('b0000016-0000-0000-0000-000000000016'::uuid, 'paciente016@email.com', crypt('paciente123', gen_salt('bf')), 'Carmen Flores Gutiérrez', 'PAC-016', 'paciente', true, NOW(), NOW()),
('b0000017-0000-0000-0000-000000000017'::uuid, 'paciente017@email.com', crypt('paciente123', gen_salt('bf')), 'Arturo López Fuentes', 'PAC-017', 'paciente', true, NOW(), NOW()),
('b0000018-0000-0000-0000-000000000018'::uuid, 'paciente018@email.com', crypt('paciente123', gen_salt('bf')), 'Rosario Pacheco Domínguez', 'PAC-018', 'paciente', true, NOW(), NOW()),
('b0000019-0000-0000-0000-000000000019'::uuid, 'paciente019@email.com', crypt('paciente123', gen_salt('bf')), 'Javier Ramos Villanueva', 'PAC-019', 'paciente', true, NOW(), NOW()),
('b0000020-0000-0000-0000-000000000020'::uuid, 'paciente020@email.com', crypt('paciente123', gen_salt('bf')), 'Cecilia Gómez Herrera', 'PAC-020', 'paciente', true, NOW(), NOW());

-- Generar pacientes 21-100 automáticamente
DO $$
DECLARE
  v_count INT := 21;
BEGIN
  WHILE v_count <= 100 LOOP
    INSERT INTO usuarios_ligia (id, email, contraseña_hash, nombre_completo, documento_identidad, rol, activo, created_at, updated_at)
    VALUES (
      gen_random_uuid(),
      'paciente' || LPAD(v_count::text, 3, '0') || '@email.com',
      crypt('paciente123', gen_salt('bf')),
      'Paciente ' || v_count,
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
  85,
  NOW(),
  NOW()
FROM usuarios_ligia u
WHERE u.rol = 'paciente';

-- ============================================================================
-- PASO 3: INSERTAR 10 ADMINISTRADORES FAMILIARES (MAMÁS)
-- ============================================================================

INSERT INTO usuarios_ligia (id, email, contraseña_hash, nombre_completo, documento_identidad, rol, activo, created_at, updated_at) VALUES
('c0000001-0000-0000-0000-000000000001'::uuid, 'mama001@email.com', crypt('admin123', gen_salt('bf')), 'Rosa García (Mamá de Pacientes)', 'ADM-001', 'admin_familiar', true, NOW(), NOW()),
('c0000002-0000-0000-0000-000000000002'::uuid, 'mama002@email.com', crypt('admin123', gen_salt('bf')), 'María López (Mamá de Pacientes)', 'ADM-002', 'admin_familiar', true, NOW(), NOW()),
('c0000003-0000-0000-0000-000000000003'::uuid, 'mama003@email.com', crypt('admin123', gen_salt('bf')), 'Carmen Rodríguez (Mamá de Pacientes)', 'ADM-003', 'admin_familiar', true, NOW(), NOW()),
('c0000004-0000-0000-0000-000000000004'::uuid, 'mama004@email.com', crypt('admin123', gen_salt('bf')), 'Juana Martínez (Mamá de Pacientes)', 'ADM-004', 'admin_familiar', true, NOW(), NOW()),
('c0000005-0000-0000-0000-000000000005'::uuid, 'mama005@email.com', crypt('admin123', gen_salt('bf')), 'Elena Fernández (Mamá de Pacientes)', 'ADM-005', 'admin_familiar', true, NOW(), NOW()),
('c0000006-0000-0000-0000-000000000006'::uuid, 'mama006@email.com', crypt('admin123', gen_salt('bf')), 'Luz Sánchez (Mamá de Pacientes)', 'ADM-006', 'admin_familiar', true, NOW(), NOW()),
('c0000007-0000-0000-0000-000000000007'::uuid, 'mama007@email.com', crypt('admin123', gen_salt('bf')), 'Patricia González (Mamá de Pacientes)', 'ADM-007', 'admin_familiar', true, NOW(), NOW()),
('c0000008-0000-0000-0000-000000000008'::uuid, 'mama008@email.com', crypt('admin123', gen_salt('bf')), 'Diana Díaz (Mamá de Pacientes)', 'ADM-008', 'admin_familiar', true, NOW(), NOW()),
('c0000009-0000-0000-0000-000000000009'::uuid, 'mama009@email.com', crypt('admin123', gen_salt('bf')), 'Beatriz Torres (Mamá de Pacientes)', 'ADM-009', 'admin_familiar', true, NOW(), NOW()),
('c0000010-0000-0000-0000-000000000010'::uuid, 'mama010@email.com', crypt('admin123', gen_salt('bf')), 'Norma Castillo (Mamá de Pacientes)', 'ADM-010', 'admin_familiar', true, NOW(), NOW());

-- ============================================================================
-- PASO 4: CREAR RELACIONES FAMILIARES (MAMÁS PUEDEN VER EXPEDIENTES DE HIJOS)
-- ============================================================================

-- Mamá 1 (Rosa García) autorizada para ver a pacientes 1-5
INSERT INTO family_relationships (id, parent_id, child_id, tipo_relacion, puede_acceder, created_at)
SELECT
  gen_random_uuid(),
  (SELECT id FROM usuarios_ligia WHERE email = 'mama001@email.com' LIMIT 1),
  u.id,
  'madre',
  true,
  NOW()
FROM usuarios_ligia u
WHERE u.email IN ('paciente001@email.com', 'paciente002@email.com', 'paciente003@email.com', 'paciente004@email.com', 'paciente005@email.com');

-- Mamá 2 (María López) autorizada para ver a pacientes 6-10
INSERT INTO family_relationships (id, parent_id, child_id, tipo_relacion, puede_acceder, created_at)
SELECT
  gen_random_uuid(),
  (SELECT id FROM usuarios_ligia WHERE email = 'mama002@email.com' LIMIT 1),
  u.id,
  'madre',
  true,
  NOW()
FROM usuarios_ligia u
WHERE u.email IN ('paciente006@email.com', 'paciente007@email.com', 'paciente008@email.com', 'paciente009@email.com', 'paciente010@email.com');

-- Mamá 3 (Carmen Rodríguez) autorizada para ver a pacientes 11-15
INSERT INTO family_relationships (id, parent_id, child_id, tipo_relacion, puede_acceder, created_at)
SELECT
  gen_random_uuid(),
  (SELECT id FROM usuarios_ligia WHERE email = 'mama003@email.com' LIMIT 1),
  u.id,
  'madre',
  true,
  NOW()
FROM usuarios_ligia u
WHERE u.email IN ('paciente011@email.com', 'paciente012@email.com', 'paciente013@email.com', 'paciente014@email.com', 'paciente015@email.com');

-- ============================================================================
-- PASO 5: INSERTAR CITAS
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
-- PASO 6: INSERTAR HISTORIAS CLÍNICAS
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
    jsonb_build_object('diagnostico', 'Evaluación clínica', 'cie10', 'Z00')
  ),
  'Favorable',
  'Continuar tratamiento según protocolo',
  true,
  NOW(),
  NOW(),
  NOW()
FROM perfiles_pacientes pp
CROSS JOIN medicos m
ORDER BY RANDOM()
LIMIT 50;

-- ============================================================================
-- PASO 7: INSERTAR NOTAS DE EVOLUCIÓN
-- ============================================================================

INSERT INTO notas_evolucion (id, id_consulta, id_paciente, id_medico, fecha_nota, evolucion_cuadro_clinico, signos_vitales, diagnosticos_problemas_clinicos, pronostico, tratamiento_indicaciones, firmado, fecha_firma, created_at, updated_at)
SELECT
  gen_random_uuid(),
  c.id,
  c.id_paciente,
  c.id_medico,
  NOW() - (RANDOM() * 20)::int * INTERVAL '1 day',
  'Paciente refiere mejoría sintomática',
  jsonb_build_object(
    'temperatura', ROUND((36.5 + RANDOM() * 1)::numeric, 1),
    'ta_sistolica', ROUND(120 + RANDOM() * 40),
    'ta_diastolica', ROUND(70 + RANDOM() * 20),
    'fc', ROUND(70 + RANDOM() * 20)
  ),
  jsonb_build_array(
    jsonb_build_object('diagnostico', 'Seguimiento', 'cie10', 'Z01')
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
-- PASO 8: INSERTAR MEDICAMENTOS
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

SELECT '✅ CARGA COMPLETADA - SISTEMA LISTO PARA AUTENTICAR' as "RESULTADO";

SELECT
  'MÉDICOS autenticables' as "ENTIDAD",
  COUNT(*) as "TOTAL",
  'medico001-020@hospital.mx / medico123' as "ACCESO"
FROM usuarios_ligia WHERE rol = 'medico'
UNION ALL
SELECT
  'PACIENTES autenticables',
  COUNT(*),
  'paciente001-100@email.com / paciente123'
FROM usuarios_ligia WHERE rol = 'paciente'
UNION ALL
SELECT
  'ADMINISTRADORES FAMILIARES',
  COUNT(*),
  'mama001-010@email.com / admin123'
FROM usuarios_ligia WHERE rol = 'admin_familiar'
UNION ALL
SELECT
  'RELACIONES FAMILIARES (mamá-hijo)',
  COUNT(*),
  'Guardadas en family_relationships'
FROM family_relationships
UNION ALL
SELECT
  'CITAS registradas',
  COUNT(*),
  'Para consultas'
FROM citas
UNION ALL
SELECT
  'HISTORIAS CLÍNICAS',
  COUNT(*),
  'Expedientes completos'
FROM historias_clinicas
UNION ALL
SELECT
  'NOTAS DE EVOLUCIÓN',
  COUNT(*),
  'Seguimientos médicos'
FROM notas_evolucion
UNION ALL
SELECT
  'MEDICAMENTOS',
  COUNT(*),
  'Prescripciones activas'
FROM medicamentos_paciente
ORDER BY 1;

-- ============================================================================
-- EJEMPLO DE USO
-- ============================================================================
--
-- MÉDICO (Ver sus pacientes y consultas):
-- Email: medico001@hospital.mx
-- Contraseña: medico123
-- Podrá ver lista de pacientes asignados y sus consultas
--
-- PACIENTE (Ver su expediente):
-- Email: paciente001@email.com
-- Contraseña: paciente123
-- Podrá ver su perfil, antecedentes, consultas, medicamentos, estudios
--
-- ADMINISTRADOR FAMILIAR (Ver expedientes de hijos):
-- Email: mama001@email.com
-- Contraseña: admin123
-- Podrá ver expedientes de pacientes 001-005 (sus hijos autorizados)
--
-- ============================================================================

