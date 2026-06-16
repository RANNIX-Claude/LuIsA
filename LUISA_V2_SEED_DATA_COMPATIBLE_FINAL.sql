- ============================================================================
-- LUISA v2.0 - SEED DATA SCRIPT (100% COMPATIBLE)
-- 100 MÉDICOS + 300 PACIENTES + DATOS CLÍNICOS COMPLETOS
-- ============================================================================
-- FECHA: 2026-05-25
-- ESTADO: LIMPIO, SIN ERRORES DE SINTAXIS
-- ============================================================================

-- ============================================================================
-- PASO 0: LIMPIAR DATOS PREVIOS (ORDEN INVERSO DE FKs)
-- ============================================================================

DELETE FROM medicamentos_paciente;
DELETE FROM vacunas_paciente;
DELETE FROM notas_evolucion;
DELETE FROM notas_hospitalizacion;
DELETE FROM notas_urgencias;
DELETE FROM historias_clinicas;
DELETE FROM citas;
DELETE FROM doctor_patient_relationships;
DELETE FROM family_relationships;
DELETE FROM perfiles_pacientes;
DELETE FROM medicos;
DELETE FROM usuarios_luisa WHERE rol IN ('medico', 'paciente', 'admin_familiar');

-- ============================================================================
-- PASO 1: INSERTAR 100 MÉDICOS CON AUTENTICACIÓN
-- ============================================================================

INSERT INTO usuarios_luisa (id, email, contraseña_hash, nombre_completo, documento_identidad, documento_tipo, rol, activo, created_at, updated_at)
SELECT
  gen_random_uuid() as id,
  CONCAT('medico', LPAD(seq::text, 3, '0'), '@hospital.mx') as email,
  crypt(CONCAT('medico', seq), gen_salt('bf')) as contraseña_hash,
  CASE seq
    WHEN 1 THEN 'Carlos García Moreno'
    WHEN 2 THEN 'María Rodríguez López'
    WHEN 3 THEN 'Juan Martínez Silva'
    WHEN 4 THEN 'Alejandra Castro Flores'
    WHEN 5 THEN 'Ricardo Hernández Pérez'
    WHEN 6 THEN 'Patricia Flores Gutiérrez'
    WHEN 7 THEN 'Fernando Silva Ramírez'
    WHEN 8 THEN 'Rosario Morales Díaz'
    WHEN 9 THEN 'Luis Vargas Torres'
    WHEN 10 THEN 'Graciela Santos Mendoza'
    WHEN 11 THEN 'Andrés Mendoza Vega'
    WHEN 12 THEN 'Beatriz Núñez Ortiz'
    WHEN 13 THEN 'Pablo Díaz Reyes'
    WHEN 14 THEN 'Carmen Reyes Cortés'
    WHEN 15 THEN 'Manuel López Fuentes'
    WHEN 16 THEN 'Susana González Ruiz'
    WHEN 17 THEN 'Octavio Gutiérrez Bravo'
    WHEN 18 THEN 'Victoria Bravo Chávez'
    WHEN 19 THEN 'Francisco Chávez Soto'
    WHEN 20 THEN 'Norma Santos Acosta'
    ELSE CONCAT('Dr(a). Médico ', seq)
  END as nombre_completo,
  CONCAT('MED-', LPAD(seq::text, 3, '0')) as documento_identidad,
  'cedula_profesional' as documento_tipo,
  'medico' as rol,
  true as activo,
  NOW() as created_at,
  NOW() as updated_at
FROM generate_series(1, 100) as seq;

-- Insertar registros en tabla medicos vinculados a usuarios_luisa
INSERT INTO medicos (id, id_usuario, cedula_profesional, numero_cedula_verificado, especialidad_id, numero_pacientes, duracion_consulta_defecto, activo, created_at, updated_at)
SELECT
  gen_random_uuid() as id,
  ul.id as id_usuario,
  ul.documento_identidad as cedula_profesional,
  true as numero_cedula_verificado,
  (SELECT id FROM cat_especialidades WHERE activo = true ORDER BY RANDOM() LIMIT 1) as especialidad_id,
  FLOOR(RANDOM() * 50 + 10)::integer as numero_pacientes,
  30 as duracion_consulta_defecto,
  true as activo,
  NOW() as created_at,
  NOW() as updated_at
FROM usuarios_luisa ul
WHERE ul.rol = 'medico'
ORDER BY ul.created_at DESC
LIMIT 100;

-- ============================================================================
-- PASO 2: INSERTAR 300 PACIENTES CON AUTENTICACIÓN
-- ============================================================================

INSERT INTO usuarios_luisa (id, email, contraseña_hash, nombre_completo, documento_identidad, documento_tipo, rol, activo, created_at, updated_at)
SELECT
  gen_random_uuid() as id,
  CONCAT('paciente', LPAD(seq::text, 3, '0'), '@email.com') as email,
  crypt(CONCAT('paciente', seq), gen_salt('bf')) as contraseña_hash,
  CONCAT('Paciente Nombre ', seq) as nombre_completo,
  CONCAT('PAC-', LPAD(seq::text, 3, '0')) as documento_identidad,
  'cedula' as documento_tipo,
  'paciente' as rol,
  true as activo,
  NOW() as created_at,
  NOW() as updated_at
FROM generate_series(1, 300) as seq;

-- Insertar perfiles de pacientes
INSERT INTO perfiles_pacientes (
  id, id_usuario, nombre_completo, fecha_nacimiento, edad, sexo,
  tipo_sangre_id, estado_id, ciudad_id, ocupacion_id, estado_civil_id,
  grupo_etnico_id, religion_id, nivel_socioeconomico_id, tipo_vivienda_id,
  perfil_completo_pct, created_at, updated_at
)
SELECT
  gen_random_uuid() as id,
  ul.id as id_usuario,
  ul.nombre_completo as nombre_completo,
  CURRENT_DATE - (RANDOM() * 25000)::int as fecha_nacimiento,
  EXTRACT(YEAR FROM AGE(CURRENT_DATE - (RANDOM() * 25000)::int))::integer as edad,
  CASE WHEN RANDOM() > 0.5 THEN 'M' ELSE 'F' END as sexo,
  (SELECT id FROM cat_tipos_sanguineo WHERE activo = true ORDER BY RANDOM() LIMIT 1) as tipo_sangre_id,
  (SELECT id FROM cat_estados_republica WHERE activo = true ORDER BY RANDOM() LIMIT 1) as estado_id,
  (SELECT id FROM cat_ciudades WHERE activo = true ORDER BY RANDOM() LIMIT 1) as ciudad_id,
  (SELECT id FROM cat_ocupaciones WHERE activo = true ORDER BY RANDOM() LIMIT 1) as ocupacion_id,
  (SELECT id FROM cat_estado_civil WHERE activo = true ORDER BY RANDOM() LIMIT 1) as estado_civil_id,
  (SELECT id FROM cat_grupos_etnicos WHERE activo = true ORDER BY RANDOM() LIMIT 1) as grupo_etnico_id,
  (SELECT id FROM cat_religiones WHERE activo = true ORDER BY RANDOM() LIMIT 1) as religion_id,
  (SELECT id FROM cat_niveles_socioeconomicos WHERE activo = true ORDER BY RANDOM() LIMIT 1) as nivel_socioeconomico_id,
  (SELECT id FROM cat_tipos_vivienda WHERE activo = true ORDER BY RANDOM() LIMIT 1) as tipo_vivienda_id,
  75 as perfil_completo_pct,
  NOW() as created_at,
  NOW() as updated_at
FROM usuarios_luisa ul
WHERE ul.rol = 'paciente'
ORDER BY ul.created_at DESC
LIMIT 300;

-- ============================================================================
-- PASO 3: INSERTAR 20 ADMINISTRADORES FAMILIARES (MADRES)
-- ============================================================================

INSERT INTO usuarios_luisa (id, email, contraseña_hash, nombre_completo, documento_identidad, documento_tipo, rol, activo, created_at, updated_at)
SELECT
  gen_random_uuid() as id,
  CONCAT('mama', LPAD(seq::text, 2, '0'), '@email.com') as email,
  crypt(CONCAT('mama', seq), gen_salt('bf')) as contraseña_hash,
  CONCAT('Mamá ', seq) as nombre_completo,
  CONCAT('MAMA-', LPAD(seq::text, 2, '0')) as documento_identidad,
  'cedula' as documento_tipo,
  'admin_familiar' as rol,
  true as activo,
  NOW() as created_at,
  NOW() as updated_at
FROM generate_series(1, 20) as seq;

-- Insertar perfiles para las mamás en perfiles_pacientes
INSERT INTO perfiles_pacientes (
  id, id_usuario, nombre_completo, fecha_nacimiento, edad, sexo,
  tipo_sangre_id, estado_id, ciudad_id, ocupacion_id, estado_civil_id,
  grupo_etnico_id, religion_id, nivel_socioeconomico_id, tipo_vivienda_id,
  perfil_completo_pct, created_at, updated_at
)
SELECT
  gen_random_uuid() as id,
  ul.id as id_usuario,
  ul.nombre_completo as nombre_completo,
  CURRENT_DATE - (RANDOM() * 20000)::int as fecha_nacimiento,
  EXTRACT(YEAR FROM AGE(CURRENT_DATE - (RANDOM() * 20000)::int))::integer as edad,
  'F' as sexo,
  (SELECT id FROM cat_tipos_sanguineo WHERE activo = true ORDER BY RANDOM() LIMIT 1) as tipo_sangre_id,
  (SELECT id FROM cat_estados_republica WHERE activo = true ORDER BY RANDOM() LIMIT 1) as estado_id,
  (SELECT id FROM cat_ciudades WHERE activo = true ORDER BY RANDOM() LIMIT 1) as ciudad_id,
  (SELECT id FROM cat_ocupaciones WHERE activo = true ORDER BY RANDOM() LIMIT 1) as ocupacion_id,
  (SELECT id FROM cat_estado_civil WHERE activo = true ORDER BY RANDOM() LIMIT 1) as estado_civil_id,
  (SELECT id FROM cat_grupos_etnicos WHERE activo = true ORDER BY RANDOM() LIMIT 1) as grupo_etnico_id,
  (SELECT id FROM cat_religiones WHERE activo = true ORDER BY RANDOM() LIMIT 1) as religion_id,
  (SELECT id FROM cat_niveles_socioeconomicos WHERE activo = true ORDER BY RANDOM() LIMIT 1) as nivel_socioeconomico_id,
  (SELECT id FROM cat_tipos_vivienda WHERE activo = true ORDER BY RANDOM() LIMIT 1) as tipo_vivienda_id,
  75 as perfil_completo_pct,
  NOW() as created_at,
  NOW() as updated_at
FROM usuarios_luisa ul
WHERE ul.rol = 'admin_familiar'
ORDER BY ul.created_at DESC
LIMIT 20;

-- ============================================================================
-- PASO 4: CREAR RELACIONES FAMILIARES (MADRES -> HIJOS)
-- ============================================================================

INSERT INTO family_relationships (id, parent_id, child_id, tipo_relacion, puede_acceder, created_at)
SELECT
  gen_random_uuid() as id,
  mama.id as parent_id,
  hijo.id as child_id,
  'madre' as tipo_relacion,
  true as puede_acceder,
  NOW() as created_at
FROM (
  SELECT id, ROW_NUMBER() OVER (ORDER BY created_at DESC) as mama_seq
  FROM perfiles_pacientes
  WHERE id_usuario IN (SELECT id FROM usuarios_luisa WHERE rol = 'admin_familiar')
) mama
CROSS JOIN (
  SELECT id, ROW_NUMBER() OVER (ORDER BY created_at ASC) as patient_seq
  FROM perfiles_pacientes
  WHERE id_usuario IN (SELECT id FROM usuarios_luisa WHERE rol = 'paciente')
) hijo
WHERE hijo.patient_seq <= (mama.mama_seq * 15)
  AND hijo.patient_seq > ((mama.mama_seq - 1) * 15);

-- ============================================================================
-- PASO 5: CREAR RELACIONES MÉDICO-PACIENTE
-- ============================================================================

INSERT INTO doctor_patient_relationships (id, id_medico, id_paciente, fecha_asignacion, activo, created_at)
SELECT
  gen_random_uuid() as id,
  m.id as id_medico,
  pp.id as id_paciente,
  NOW() - (RANDOM() * 365)::int * INTERVAL '1 day' as fecha_asignacion,
  true as activo,
  NOW() as created_at
FROM medicos m
CROSS JOIN perfiles_pacientes pp
WHERE RANDOM() < 0.3
LIMIT 800;

-- ============================================================================
-- PASO 6: INSERTAR 800+ CITAS
-- ============================================================================

INSERT INTO citas (id, id_paciente, id_medico, fecha_hora, tipo_consulta, duracion_minutos, estado, notas_paciente, created_at, updated_at)
SELECT
  gen_random_uuid() as id,
  (SELECT id_paciente FROM doctor_patient_relationships ORDER BY RANDOM() LIMIT 1) as id_paciente,
  (SELECT id_medico FROM doctor_patient_relationships ORDER BY RANDOM() LIMIT 1) as id_medico,
  NOW() + (RANDOM() * 60)::int * INTERVAL '1 day' - (RANDOM() * 30)::int * INTERVAL '1 day' as fecha_hora,
  CASE WHEN RANDOM() > 0.8 THEN 'urgencia' WHEN RANDOM() > 0.5 THEN 'hospitalización' ELSE 'consulta_externa' END as tipo_consulta,
  30 as duracion_minutos,
  CASE WHEN RANDOM() > 0.3 THEN 'completada' WHEN RANDOM() > 0.1 THEN 'confirmada' ELSE 'agendada' END as estado,
  CASE WHEN RANDOM() > 0.7 THEN 'Paciente refiere molestias' ELSE NULL END as notas_paciente,
  NOW() - (RANDOM() * 60)::int * INTERVAL '1 day' as created_at,
  NOW() - (RANDOM() * 60)::int * INTERVAL '1 day' as updated_at
FROM generate_series(1, 800);

-- ============================================================================
-- PASO 7: INSERTAR HISTORIAS CLÍNICAS (100+)
-- ============================================================================

INSERT INTO historias_clinicas (
  id, id_paciente, id_medico, fecha_elaboracion, padecimiento_actual,
  signos_vitales, diagnosticos_problemas_clinicos,
  pronostico_descripcion, indicacion_terapeutica,
  firmado, fecha_firma, created_at, updated_at
)
SELECT
  gen_random_uuid() as id,
  pp.id as id_paciente,
  m.id as id_medico,
  NOW() - (RANDOM() * 30)::int * INTERVAL '1 day' as fecha_elaboracion,
  'Paciente acude por control de enfermedad crónica' as padecimiento_actual,
  jsonb_build_object(
    'temperatura', ROUND((36.0 + RANDOM() * 2)::numeric, 1),
    'ta_sistolica', (100 + RANDOM() * 60)::int,
    'ta_diastolica', (60 + RANDOM() * 30)::int,
    'fc', (60 + RANDOM() * 40)::int,
    'fr', (14 + RANDOM() * 6)::int,
    'peso_kg', ROUND((50 + RANDOM() * 40)::numeric, 1),
    'talla_cm', (150 + RANDOM() * 40)::int
  ) as signos_vitales,
  jsonb_build_array(
    jsonb_build_object(
      'diagnostico', 'Hipertensión Arterial',
      'cie10', 'I10'
    )
  ) as diagnosticos_problemas_clinicos,
  CASE WHEN RANDOM() > 0.5 THEN 'Favorable' ELSE 'Reservado' END as pronostico_descripcion,
  'Continuar tratamiento, seguimiento mensual' as indicacion_terapeutica,
  true as firmado,
  NOW() - (RANDOM() * 30)::int * INTERVAL '1 day' as fecha_firma,
  NOW() - (RANDOM() * 30)::int * INTERVAL '1 day' as created_at,
  NOW() - (RANDOM() * 30)::int * INTERVAL '1 day' as updated_at
FROM perfiles_pacientes pp
CROSS JOIN medicos m
ORDER BY RANDOM()
LIMIT 150;

-- ============================================================================
-- PASO 8: INSERTAR NOTAS DE EVOLUCIÓN (200+)
-- ============================================================================

INSERT INTO notas_evolucion (
  id, id_consulta, id_paciente, id_medico, fecha_nota,
  evolucion_cuadro_clinico, signos_vitales,
  diagnosticos_problemas_clinicos, pronostico,
  tratamiento_indicaciones, firmado, fecha_firma, created_at, updated_at
)
SELECT
  gen_random_uuid() as id,
  c.id as id_consulta,
  c.id_paciente as id_paciente,
  c.id_medico as id_medico,
  c.fecha_hora as fecha_nota,
  'Paciente refiere mejoría parcial con el tratamiento' as evolucion_cuadro_clinico,
  jsonb_build_object(
    'temperatura', ROUND((36.5 + RANDOM() * 1)::numeric, 1),
    'ta_sistolica', (120 + RANDOM() * 40)::int,
    'ta_diastolica', (70 + RANDOM() * 20)::int,
    'fc', (70 + RANDOM() * 20)::int,
    'fr', ROUND(14 + RANDOM() * 6)::int
  ) as signos_vitales,
  jsonb_build_array(
    jsonb_build_object('diagnostico', 'Control de patología', 'cie10', 'Z01')
  ) as diagnosticos_problemas_clinicos,
  'Favorable' as pronostico,
  jsonb_build_array(
    jsonb_build_object('medicamento', 'Tratamiento continuado')
  ) as tratamiento_indicaciones,
  true as firmado,
  NOW() as fecha_firma,
  NOW() - (RANDOM() * 20)::int * INTERVAL '1 day' as created_at,
  NOW() - (RANDOM() * 20)::int * INTERVAL '1 day' as updated_at
FROM citas c
WHERE c.estado = 'completada'
LIMIT 200;

-- ============================================================================
-- PASO 9: INSERTAR MEDICAMENTOS (300+)
-- ============================================================================

INSERT INTO medicamentos_paciente (
  id, id_paciente, id_medicamento, dosis, via_administracion_id,
  frecuencia_id, fecha_inicio, fecha_fin, activo, created_at, updated_at
)
SELECT
  gen_random_uuid() as id,
  pp.id as id_paciente,
  (SELECT id FROM cat_medicamentos WHERE activo = true ORDER BY RANDOM() LIMIT 1) as id_medicamento,
  '10 mg' as dosis,
  (SELECT id FROM cat_vias_administracion WHERE activo = true ORDER BY RANDOM() LIMIT 1) as via_administracion_id,
  (SELECT id FROM cat_frecuencias_medicamento WHERE activo = true ORDER BY RANDOM() LIMIT 1) as frecuencia_id,
  CURRENT_DATE - (RANDOM() * 365)::int as fecha_inicio,
  NULL as fecha_fin,
  true as activo,
  NOW() as created_at,
  NOW() as updated_at
FROM perfiles_pacientes pp
LIMIT 300;

-- ============================================================================
-- PASO 10: VERIFICACIÓN FINAL
-- ============================================================================

SELECT 'CARGA COMPLETADA EXITOSAMENTE' as resultado;

SELECT
  'Médicos' as entidad,
  COUNT(*) as total
FROM medicos
UNION ALL
SELECT 'Pacientes', COUNT(*) FROM perfiles_pacientes
UNION ALL
SELECT 'Usuarios LUISA', COUNT(*) FROM usuarios_luisa
UNION ALL
SELECT 'Citas', COUNT(*) FROM citas
UNION ALL
SELECT 'Historias Clínicas', COUNT(*) FROM historias_clinicas
UNION ALL
SELECT 'Notas de Evolución', COUNT(*) FROM notas_evolucion
UNION ALL
SELECT 'Medicamentos', COUNT(*) FROM medicamentos_paciente
UNION ALL
SELECT 'Relaciones Familiares', COUNT(*) FROM family_relationships
UNION ALL
SELECT 'Relaciones Médico-Paciente', COUNT(*) FROM doctor_patient_relationships
ORDER BY entidad;

-- ============================================================================
-- CREDENCIALES DE ACCESO
-- ============================================================================
-- MÉDICOS: medico001@hospital.mx hasta medico100@hospital.mx
-- Contraseña: medico{número} (ej: medico1, medico2, etc.)
--
-- PACIENTES: paciente001@email.com hasta paciente300@email.com
-- Contraseña: paciente{número} (ej: paciente1, paciente2, etc.)
--
-- ADMINISTRADORES FAMILIARES: mama01@email.com hasta mama20@email.com
-- Contraseña: mama{número} (ej: mama1, mama2, etc.)
-- ============================================================================
