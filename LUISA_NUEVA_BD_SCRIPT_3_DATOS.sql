- ============================================================================
-- LUISA v2.0 - SCRIPT 3: DATOS DE PRUEBA (ejecutar después del SCRIPT 2)
-- 20 médicos + 100 pacientes + 10 mamás + datos clínicos
-- IMPORTANTE: Usa "password_hash" (sin ñ)
-- Idempotente: limpia datos previos automáticamente
-- ============================================================================

-- ============================================================================
-- PASO 0: LIMPIAR DATOS PREVIOS (orden inverso de FKs)
-- ============================================================================

DELETE FROM medicamentos_paciente;
DELETE FROM vacunas_paciente;
DELETE FROM diario_eventos;
DELETE FROM notas_evolucion;
DELETE FROM notas_hospitalizacion;
DELETE FROM notas_urgencias;
DELETE FROM historias_clinicas;
DELETE FROM citas;
DELETE FROM doctor_patient_relationships;
DELETE FROM family_relationships;
DELETE FROM auditoria_acciones;
DELETE FROM firma_electronica;
DELETE FROM perfiles_pacientes;
DELETE FROM medicos;
DELETE FROM usuarios_luisa;

-- ============================================================================
-- PASO 1: 20 MÉDICOS con autenticación
-- ============================================================================

INSERT INTO usuarios_luisa (email, password_hash, nombre_completo, documento_identidad, documento_tipo, rol, activo)
SELECT
  CONCAT('medico', LPAD(seq::text, 3, '0'), '@hospital.mx') as email,
  crypt(CONCAT('medico', seq), gen_salt('bf')) as password_hash,
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
    ELSE 'Norma Santos Acosta'
  END as nombre_completo,
  CONCAT('MED-', LPAD(seq::text, 3, '0')) as documento_identidad,
  'cedula_profesional',
  'medico',
  true
FROM generate_series(1, 20) as seq;

-- Registros de médicos
INSERT INTO medicos (id_usuario, cedula_profesional, numero_cedula_verificado, especialidad_id, numero_pacientes, duracion_consulta_defecto, activo)
SELECT
  ul.id,
  ul.documento_identidad,
  true,
  (SELECT id FROM cat_especialidades WHERE activo = true ORDER BY RANDOM() LIMIT 1),
  FLOOR(RANDOM() * 50 + 10)::integer,
  30,
  true
FROM usuarios_luisa ul
WHERE ul.rol = 'medico';

-- ============================================================================
-- PASO 2: 100 PACIENTES con autenticación
-- ============================================================================

INSERT INTO usuarios_luisa (email, password_hash, nombre_completo, documento_identidad, documento_tipo, rol, activo)
SELECT
  CONCAT('paciente', LPAD(seq::text, 3, '0'), '@email.com'),
  crypt(CONCAT('paciente', seq), gen_salt('bf')),
  CONCAT('Paciente Nombre ', seq),
  CONCAT('PAC-', LPAD(seq::text, 3, '0')),
  'cedula',
  'paciente',
  true
FROM generate_series(1, 100) as seq;

-- Perfiles de pacientes
INSERT INTO perfiles_pacientes (
  id_usuario, nombre_completo, fecha_nacimiento, edad, sexo,
  tipo_sangre_id, estado_id, ciudad_id, ocupacion_id, estado_civil_id,
  grupo_etnico_id, religion_id, nivel_socioeconomico_id, tipo_vivienda_id,
  perfil_completo_pct
)
SELECT
  ul.id,
  ul.nombre_completo,
  CURRENT_DATE - (RANDOM() * 25000)::int,
  EXTRACT(YEAR FROM AGE(CURRENT_DATE - (RANDOM() * 25000)::int))::integer,
  CASE WHEN RANDOM() > 0.5 THEN 'M' ELSE 'F' END,
  (SELECT id FROM cat_tipos_sanguineo ORDER BY RANDOM() LIMIT 1),
  (SELECT id FROM cat_estados_republica ORDER BY RANDOM() LIMIT 1),
  (SELECT id FROM cat_ciudades ORDER BY RANDOM() LIMIT 1),
  (SELECT id FROM cat_ocupaciones ORDER BY RANDOM() LIMIT 1),
  (SELECT id FROM cat_estado_civil ORDER BY RANDOM() LIMIT 1),
  (SELECT id FROM cat_grupos_etnicos ORDER BY RANDOM() LIMIT 1),
  (SELECT id FROM cat_religiones ORDER BY RANDOM() LIMIT 1),
  (SELECT id FROM cat_niveles_socioeconomicos ORDER BY RANDOM() LIMIT 1),
  (SELECT id FROM cat_tipos_vivienda ORDER BY RANDOM() LIMIT 1),
  75
FROM usuarios_luisa ul
WHERE ul.rol = 'paciente';

-- ============================================================================
-- PASO 3: 10 ADMINISTRADORES FAMILIARES (Madres)
-- ============================================================================

INSERT INTO usuarios_luisa (email, password_hash, nombre_completo, documento_identidad, documento_tipo, rol, activo)
SELECT
  CONCAT('mama', LPAD(seq::text, 2, '0'), '@email.com'),
  crypt(CONCAT('mama', seq), gen_salt('bf')),
  CONCAT('Mamá ', seq),
  CONCAT('MAMA-', LPAD(seq::text, 2, '0')),
  'cedula',
  'admin_familiar',
  true
FROM generate_series(1, 10) as seq;

-- Perfiles para las mamás
INSERT INTO perfiles_pacientes (
  id_usuario, nombre_completo, fecha_nacimiento, edad, sexo,
  tipo_sangre_id, estado_id, ciudad_id, ocupacion_id, estado_civil_id,
  grupo_etnico_id, religion_id, nivel_socioeconomico_id, tipo_vivienda_id,
  perfil_completo_pct
)
SELECT
  ul.id,
  ul.nombre_completo,
  CURRENT_DATE - (RANDOM() * 18000)::int,
  EXTRACT(YEAR FROM AGE(CURRENT_DATE - (RANDOM() * 18000)::int))::integer,
  'F',
  (SELECT id FROM cat_tipos_sanguineo ORDER BY RANDOM() LIMIT 1),
  (SELECT id FROM cat_estados_republica ORDER BY RANDOM() LIMIT 1),
  (SELECT id FROM cat_ciudades ORDER BY RANDOM() LIMIT 1),
  (SELECT id FROM cat_ocupaciones ORDER BY RANDOM() LIMIT 1),
  (SELECT id FROM cat_estado_civil ORDER BY RANDOM() LIMIT 1),
  (SELECT id FROM cat_grupos_etnicos ORDER BY RANDOM() LIMIT 1),
  (SELECT id FROM cat_religiones ORDER BY RANDOM() LIMIT 1),
  (SELECT id FROM cat_niveles_socioeconomicos ORDER BY RANDOM() LIMIT 1),
  (SELECT id FROM cat_tipos_vivienda ORDER BY RANDOM() LIMIT 1),
  80
FROM usuarios_luisa ul
WHERE ul.rol = 'admin_familiar';

-- ============================================================================
-- PASO 4: Relaciones familiares (cada mamá administra 10 hijos)
-- ============================================================================

INSERT INTO family_relationships (parent_id, child_id, tipo_relacion, puede_acceder)
SELECT
  mama.id,
  hijo.id,
  'madre',
  true
FROM (
  SELECT id, ROW_NUMBER() OVER (ORDER BY created_at DESC) as seq
  FROM perfiles_pacientes
  WHERE id_usuario IN (SELECT id FROM usuarios_luisa WHERE rol = 'admin_familiar')
) mama
CROSS JOIN (
  SELECT id, ROW_NUMBER() OVER (ORDER BY created_at ASC) as seq
  FROM perfiles_pacientes
  WHERE id_usuario IN (SELECT id FROM usuarios_luisa WHERE rol = 'paciente')
) hijo
WHERE hijo.seq <= (mama.seq * 10)
  AND hijo.seq > ((mama.seq - 1) * 10);

-- ============================================================================
-- PASO 5: Relaciones médico-paciente
-- ============================================================================

INSERT INTO doctor_patient_relationships (id_medico, id_paciente, fecha_asignacion, activo)
SELECT
  m.id,
  pp.id,
  NOW() - (RANDOM() * 365)::int * INTERVAL '1 day',
  true
FROM medicos m
CROSS JOIN perfiles_pacientes pp
WHERE RANDOM() < 0.3
LIMIT 500;

-- ============================================================================
-- PASO 6: 300 citas
-- ============================================================================

INSERT INTO citas (id_paciente, id_medico, fecha_hora, tipo_consulta, duracion_minutos, estado, notas_paciente)
SELECT
  (SELECT id_paciente FROM doctor_patient_relationships ORDER BY RANDOM() LIMIT 1),
  (SELECT id_medico FROM doctor_patient_relationships ORDER BY RANDOM() LIMIT 1),
  NOW() + (RANDOM() * 60)::int * INTERVAL '1 day' - (RANDOM() * 30)::int * INTERVAL '1 day',
  CASE WHEN RANDOM() > 0.8 THEN 'urgencia' ELSE 'consulta_externa' END,
  30,
  CASE WHEN RANDOM() > 0.3 THEN 'completada' ELSE 'agendada' END,
  CASE WHEN RANDOM() > 0.7 THEN 'Paciente refiere molestias' ELSE NULL END
FROM generate_series(1, 300);

-- ============================================================================
-- PASO 7: 50 historias clínicas
-- ============================================================================

INSERT INTO historias_clinicas (
  id_paciente, id_medico, fecha_elaboracion, padecimiento_actual,
  signos_vitales, diagnosticos_problemas_clinicos,
  pronostico_descripcion, indicacion_terapeutica,
  firmado, fecha_firma
)
SELECT
  pp.id,
  m.id,
  NOW() - (RANDOM() * 30)::int * INTERVAL '1 day',
  'Paciente acude por control de enfermedad crónica',
  jsonb_build_object(
    'temperatura', ROUND((36.0 + RANDOM() * 2)::numeric, 1),
    'ta_sistolica', (100 + RANDOM() * 60)::int,
    'ta_diastolica', (60 + RANDOM() * 30)::int,
    'fc', (60 + RANDOM() * 40)::int,
    'fr', (14 + RANDOM() * 6)::int
  ),
  jsonb_build_array(jsonb_build_object('diagnostico', 'Hipertensión Arterial', 'cie10', 'I10')),
  CASE WHEN RANDOM() > 0.5 THEN 'Favorable' ELSE 'Reservado' END,
  'Continuar tratamiento, seguimiento mensual',
  true,
  NOW()
FROM perfiles_pacientes pp
CROSS JOIN medicos m
ORDER BY RANDOM()
LIMIT 50;

-- ============================================================================
-- PASO 8: 100 medicamentos prescritos
-- ============================================================================

INSERT INTO medicamentos_paciente (
  id_paciente, id_medicamento, dosis, via_administracion_id,
  frecuencia_id, fecha_inicio, activo
)
SELECT
  pp.id,
  (SELECT id FROM cat_medicamentos ORDER BY RANDOM() LIMIT 1),
  '10 mg',
  (SELECT id FROM cat_vias_administracion ORDER BY RANDOM() LIMIT 1),
  (SELECT id FROM cat_frecuencias_medicamento ORDER BY RANDOM() LIMIT 1),
  CURRENT_DATE - (RANDOM() * 365)::int,
  true
FROM perfiles_pacientes pp
LIMIT 100;

-- ============================================================================
-- VERIFICACIÓN FINAL
-- ============================================================================

SELECT 'DATOS CARGADOS' as resultado;

SELECT
  'Médicos' as entidad, COUNT(*) as total FROM medicos
UNION ALL SELECT 'Pacientes', COUNT(*) FROM perfiles_pacientes
UNION ALL SELECT 'Usuarios', COUNT(*) FROM usuarios_luisa
UNION ALL SELECT 'Citas', COUNT(*) FROM citas
UNION ALL SELECT 'Historias Clínicas', COUNT(*) FROM historias_clinicas
UNION ALL SELECT 'Medicamentos', COUNT(*) FROM medicamentos_paciente
UNION ALL SELECT 'Relaciones Familiares', COUNT(*) FROM family_relationships
UNION ALL SELECT 'Relaciones Médico-Paciente', COUNT(*) FROM doctor_patient_relationships
ORDER BY entidad;

-- ============================================================================
-- CREDENCIALES DE ACCESO
-- ============================================================================
-- 👨‍⚕️ MÉDICOS:   medico001@hospital.mx ... medico020@hospital.mx
--                 Contraseña: medico1 ... medico20
--
-- 👤 PACIENTES:  paciente001@email.com ... paciente100@email.com
--                 Contraseña: paciente1 ... paciente100
--
-- 👩 MAMÁS:      mama01@email.com ... mama10@email.com
--                 Contraseña: mama1 ... mama10
-- ============================================================================
