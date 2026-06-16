-- ============================================================================
-- LUISA v2.0 - DATOS RICOS Y REALISTAS PARA DEMO
-- 20 médicos + 100 pacientes con nombres mexicanos reales + datos clínicos completos
-- ============================================================================

-- ============================================================================
-- LIMPIAR DATOS ANTERIORES
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
-- 20 MÉDICOS CON NOMBRES Y ESPECIALIDADES REALES
-- ============================================================================

INSERT INTO usuarios_luisa (email, password_hash, nombre_completo, documento_identidad, documento_tipo, rol, activo)
VALUES
('medico001@hospital.mx', crypt('medico1', gen_salt('bf')), 'Dr. Carlos García Moreno', 'MED-001', 'cedula_profesional', 'medico', true),
('medico002@hospital.mx', crypt('medico2', gen_salt('bf')), 'Dra. María Rodríguez López', 'MED-002', 'cedula_profesional', 'medico', true),
('medico003@hospital.mx', crypt('medico3', gen_salt('bf')), 'Dr. Juan Martínez Silva', 'MED-003', 'cedula_profesional', 'medico', true),
('medico004@hospital.mx', crypt('medico4', gen_salt('bf')), 'Dra. Alejandra Castro Flores', 'MED-004', 'cedula_profesional', 'medico', true),
('medico005@hospital.mx', crypt('medico5', gen_salt('bf')), 'Dr. Ricardo Hernández Pérez', 'MED-005', 'cedula_profesional', 'medico', true),
('medico006@hospital.mx', crypt('medico6', gen_salt('bf')), 'Dra. Patricia Flores Gutiérrez', 'MED-006', 'cedula_profesional', 'medico', true),
('medico007@hospital.mx', crypt('medico7', gen_salt('bf')), 'Dr. Fernando Silva Ramírez', 'MED-007', 'cedula_profesional', 'medico', true),
('medico008@hospital.mx', crypt('medico8', gen_salt('bf')), 'Dra. Rosario Morales Díaz', 'MED-008', 'cedula_profesional', 'medico', true),
('medico009@hospital.mx', crypt('medico9', gen_salt('bf')), 'Dr. Luis Vargas Torres', 'MED-009', 'cedula_profesional', 'medico', true),
('medico010@hospital.mx', crypt('medico10', gen_salt('bf')), 'Dra. Graciela Santos Mendoza', 'MED-010', 'cedula_profesional', 'medico', true),
('medico011@hospital.mx', crypt('medico11', gen_salt('bf')), 'Dr. Andrés Mendoza Vega', 'MED-011', 'cedula_profesional', 'medico', true),
('medico012@hospital.mx', crypt('medico12', gen_salt('bf')), 'Dra. Beatriz Núñez Ortiz', 'MED-012', 'cedula_profesional', 'medico', true),
('medico013@hospital.mx', crypt('medico13', gen_salt('bf')), 'Dr. Pablo Díaz Reyes', 'MED-013', 'cedula_profesional', 'medico', true),
('medico014@hospital.mx', crypt('medico14', gen_salt('bf')), 'Dra. Carmen Reyes Cortés', 'MED-014', 'cedula_profesional', 'medico', true),
('medico015@hospital.mx', crypt('medico15', gen_salt('bf')), 'Dr. Manuel López Fuentes', 'MED-015', 'cedula_profesional', 'medico', true),
('medico016@hospital.mx', crypt('medico16', gen_salt('bf')), 'Dra. Susana González Ruiz', 'MED-016', 'cedula_profesional', 'medico', true),
('medico017@hospital.mx', crypt('medico17', gen_salt('bf')), 'Dr. Octavio Gutiérrez Bravo', 'MED-017', 'cedula_profesional', 'medico', true),
('medico018@hospital.mx', crypt('medico18', gen_salt('bf')), 'Dra. Victoria Bravo Chávez', 'MED-018', 'cedula_profesional', 'medico', true),
('medico019@hospital.mx', crypt('medico19', gen_salt('bf')), 'Dr. Francisco Chávez Soto', 'MED-019', 'cedula_profesional', 'medico', true),
('medico020@hospital.mx', crypt('medico20', gen_salt('bf')), 'Dra. Norma Santos Acosta', 'MED-020', 'cedula_profesional', 'medico', true);

-- Médicos con especialidades específicas
INSERT INTO medicos (id_usuario, cedula_profesional, numero_cedula_verificado, especialidad_id, numero_pacientes, duracion_consulta_defecto, activo)
SELECT
  ul.id,
  ul.documento_identidad,
  true,
  (SELECT id FROM cat_especialidades
    WHERE nombre = (ARRAY['Medicina General','Cardiología','Pediatría','Ginecología','Endocrinología','Medicina General','Cardiología','Pediatría','Ginecología','Endocrinología','Neurología','Psiquiatría','Dermatología','Oftalmología','Otorrinolaringología','Ortopedia','Urología','Reumatología','Oncología','Medicina Familiar'])[CAST(SUBSTRING(ul.documento_identidad FROM 5) AS INTEGER)]
    LIMIT 1),
  FLOOR(RANDOM() * 80 + 30)::integer,
  30,
  true
FROM usuarios_luisa ul WHERE ul.rol = 'medico';

-- ============================================================================
-- 100 PACIENTES CON NOMBRES MEXICANOS REALES
-- ============================================================================

INSERT INTO usuarios_luisa (email, password_hash, nombre_completo, documento_identidad, documento_tipo, rol, activo)
VALUES
('paciente001@email.com', crypt('paciente1', gen_salt('bf')), 'Juan Pérez García', 'PAC-001', 'cedula', 'paciente', true),
('paciente002@email.com', crypt('paciente2', gen_salt('bf')), 'María López Hernández', 'PAC-002', 'cedula', 'paciente', true),
('paciente003@email.com', crypt('paciente3', gen_salt('bf')), 'Carlos Martínez Rodríguez', 'PAC-003', 'cedula', 'paciente', true),
('paciente004@email.com', crypt('paciente4', gen_salt('bf')), 'Ana Fernández López', 'PAC-004', 'cedula', 'paciente', true),
('paciente005@email.com', crypt('paciente5', gen_salt('bf')), 'Roberto Sánchez García', 'PAC-005', 'cedula', 'paciente', true),
('paciente006@email.com', crypt('paciente6', gen_salt('bf')), 'Sofía Ramírez Díaz', 'PAC-006', 'cedula', 'paciente', true),
('paciente007@email.com', crypt('paciente7', gen_salt('bf')), 'Miguel Ángel Torres', 'PAC-007', 'cedula', 'paciente', true),
('paciente008@email.com', crypt('paciente8', gen_salt('bf')), 'Patricia González Ruiz', 'PAC-008', 'cedula', 'paciente', true),
('paciente009@email.com', crypt('paciente9', gen_salt('bf')), 'Fernando Díaz Moreno', 'PAC-009', 'cedula', 'paciente', true),
('paciente010@email.com', crypt('paciente10', gen_salt('bf')), 'Verónica Castillo Mendoza', 'PAC-010', 'cedula', 'paciente', true),
('paciente011@email.com', crypt('paciente11', gen_salt('bf')), 'Lucas Navarro Silva', 'PAC-011', 'cedula', 'paciente', true),
('paciente012@email.com', crypt('paciente12', gen_salt('bf')), 'Gabriela Morales Soto', 'PAC-012', 'cedula', 'paciente', true),
('paciente013@email.com', crypt('paciente13', gen_salt('bf')), 'Diego Reyes Cortés', 'PAC-013', 'cedula', 'paciente', true),
('paciente014@email.com', crypt('paciente14', gen_salt('bf')), 'Alejandra Mendoza Vega', 'PAC-014', 'cedula', 'paciente', true),
('paciente015@email.com', crypt('paciente15', gen_salt('bf')), 'Raúl Hernández Cervantes', 'PAC-015', 'cedula', 'paciente', true),
('paciente016@email.com', crypt('paciente16', gen_salt('bf')), 'Carmen Flores Gutiérrez', 'PAC-016', 'cedula', 'paciente', true),
('paciente017@email.com', crypt('paciente17', gen_salt('bf')), 'Arturo López Fuentes', 'PAC-017', 'cedula', 'paciente', true),
('paciente018@email.com', crypt('paciente18', gen_salt('bf')), 'Rosario Pacheco Domínguez', 'PAC-018', 'cedula', 'paciente', true),
('paciente019@email.com', crypt('paciente19', gen_salt('bf')), 'Javier Ramos Villanueva', 'PAC-019', 'cedula', 'paciente', true),
('paciente020@email.com', crypt('paciente20', gen_salt('bf')), 'Cecilia Gómez Herrera', 'PAC-020', 'cedula', 'paciente', true),
('paciente021@email.com', crypt('paciente21', gen_salt('bf')), 'Mauricio Vázquez Ortega', 'PAC-021', 'cedula', 'paciente', true),
('paciente022@email.com', crypt('paciente22', gen_salt('bf')), 'Elena Cruz Pacheco', 'PAC-022', 'cedula', 'paciente', true),
('paciente023@email.com', crypt('paciente23', gen_salt('bf')), 'Sergio Torres Cabrera', 'PAC-023', 'cedula', 'paciente', true),
('paciente024@email.com', crypt('paciente24', gen_salt('bf')), 'Lucía Aguilar Sandoval', 'PAC-024', 'cedula', 'paciente', true),
('paciente025@email.com', crypt('paciente25', gen_salt('bf')), 'Eduardo Jiménez Salazar', 'PAC-025', 'cedula', 'paciente', true),
('paciente026@email.com', crypt('paciente26', gen_salt('bf')), 'Mónica Ortiz Velasco', 'PAC-026', 'cedula', 'paciente', true),
('paciente027@email.com', crypt('paciente27', gen_salt('bf')), 'Adrián Romero Bravo', 'PAC-027', 'cedula', 'paciente', true),
('paciente028@email.com', crypt('paciente28', gen_salt('bf')), 'Daniela Espinoza Vargas', 'PAC-028', 'cedula', 'paciente', true),
('paciente029@email.com', crypt('paciente29', gen_salt('bf')), 'Héctor Rosales Méndez', 'PAC-029', 'cedula', 'paciente', true),
('paciente030@email.com', crypt('paciente30', gen_salt('bf')), 'Beatriz Cárdenas Lara', 'PAC-030', 'cedula', 'paciente', true),
('paciente031@email.com', crypt('paciente31', gen_salt('bf')), 'Pedro Herrera Soto', 'PAC-031', 'cedula', 'paciente', true),
('paciente032@email.com', crypt('paciente32', gen_salt('bf')), 'Isabel Maldonado Castro', 'PAC-032', 'cedula', 'paciente', true),
('paciente033@email.com', crypt('paciente33', gen_salt('bf')), 'Antonio Beltrán Ramos', 'PAC-033', 'cedula', 'paciente', true),
('paciente034@email.com', crypt('paciente34', gen_salt('bf')), 'Teresa Salinas Ruiz', 'PAC-034', 'cedula', 'paciente', true),
('paciente035@email.com', crypt('paciente35', gen_salt('bf')), 'Rafael Domínguez Aguilar', 'PAC-035', 'cedula', 'paciente', true),
('paciente036@email.com', crypt('paciente36', gen_salt('bf')), 'Margarita Solís Bravo', 'PAC-036', 'cedula', 'paciente', true),
('paciente037@email.com', crypt('paciente37', gen_salt('bf')), 'Alberto Acuña Pérez', 'PAC-037', 'cedula', 'paciente', true),
('paciente038@email.com', crypt('paciente38', gen_salt('bf')), 'Silvia Mejía Cervantes', 'PAC-038', 'cedula', 'paciente', true),
('paciente039@email.com', crypt('paciente39', gen_salt('bf')), 'Ernesto Galván Pacheco', 'PAC-039', 'cedula', 'paciente', true),
('paciente040@email.com', crypt('paciente40', gen_salt('bf')), 'Adriana Padilla Reyes', 'PAC-040', 'cedula', 'paciente', true),
('paciente041@email.com', crypt('paciente41', gen_salt('bf')), 'Mario Cortés Méndez', 'PAC-041', 'cedula', 'paciente', true),
('paciente042@email.com', crypt('paciente42', gen_salt('bf')), 'Lourdes Fernández Vega', 'PAC-042', 'cedula', 'paciente', true),
('paciente043@email.com', crypt('paciente43', gen_salt('bf')), 'José Antonio Núñez', 'PAC-043', 'cedula', 'paciente', true),
('paciente044@email.com', crypt('paciente44', gen_salt('bf')), 'Esperanza Rivas Soto', 'PAC-044', 'cedula', 'paciente', true),
('paciente045@email.com', crypt('paciente45', gen_salt('bf')), 'Guillermo Estrada Castro', 'PAC-045', 'cedula', 'paciente', true),
('paciente046@email.com', crypt('paciente46', gen_salt('bf')), 'Yolanda Méndez Pacheco', 'PAC-046', 'cedula', 'paciente', true),
('paciente047@email.com', crypt('paciente47', gen_salt('bf')), 'Vicente Salazar Ortega', 'PAC-047', 'cedula', 'paciente', true),
('paciente048@email.com', crypt('paciente48', gen_salt('bf')), 'Pilar Aguirre Jiménez', 'PAC-048', 'cedula', 'paciente', true),
('paciente049@email.com', crypt('paciente49', gen_salt('bf')), 'Octavio Beltrán Salinas', 'PAC-049', 'cedula', 'paciente', true),
('paciente050@email.com', crypt('paciente50', gen_salt('bf')), 'Gloria Velasco Romero', 'PAC-050', 'cedula', 'paciente', true);

-- 50 pacientes más (51-100) generados con función para acelerar
DO $$
DECLARE
  nombres_h TEXT[] := ARRAY['Andrés','Bruno','Cristian','David','Enrique','Felipe','Gabriel','Hugo','Ignacio','Joaquín','Kevin','Leonardo','Marcelo','Nicolás','Óscar','Pedro','Quintín','Ramón','Salvador','Tomás','Ulises','Vicente','Walter','Xavier','Yago','Zacarías'];
  nombres_m TEXT[] := ARRAY['Adriana','Berta','Carolina','Diana','Estela','Fernanda','Gabriela','Helena','Inés','Julia','Karina','Laura','Mariana','Norma','Olga','Paula','Quetzal','Raquel','Sandra','Tania','Úrsula','Valeria','Wendy','Ximena','Yolanda','Zaira'];
  apellidos1 TEXT[] := ARRAY['García','Rodríguez','Martínez','Hernández','López','González','Pérez','Sánchez','Ramírez','Cruz','Flores','Gómez','Díaz','Reyes','Morales','Jiménez','Álvarez','Torres','Ruiz','Vázquez','Castro','Ortiz','Romero','Mendoza','Aguilar'];
  apellidos2 TEXT[] := ARRAY['Vega','Cervantes','Herrera','Salinas','Bravo','Pacheco','Méndez','Soto','Cabrera','Sandoval','Salazar','Velasco','Galván','Padilla','Estrada','Solís','Rivas','Acuña','Maldonado','Domínguez'];
  i INT;
  nombre_completo TEXT;
  es_hombre BOOLEAN;
BEGIN
  FOR i IN 51..100 LOOP
    es_hombre := RANDOM() > 0.5;
    nombre_completo := CASE
      WHEN es_hombre THEN nombres_h[1 + FLOOR(RANDOM() * array_length(nombres_h, 1))]
      ELSE nombres_m[1 + FLOOR(RANDOM() * array_length(nombres_m, 1))]
    END
    || ' ' || apellidos1[1 + FLOOR(RANDOM() * array_length(apellidos1, 1))]
    || ' ' || apellidos2[1 + FLOOR(RANDOM() * array_length(apellidos2, 1))];

    INSERT INTO usuarios_luisa (email, password_hash, nombre_completo, documento_identidad, documento_tipo, rol, activo)
    VALUES (
      CONCAT('paciente', LPAD(i::text, 3, '0'), '@email.com'),
      crypt(CONCAT('paciente', i), gen_salt('bf')),
      nombre_completo,
      CONCAT('PAC-', LPAD(i::text, 3, '0')),
      'cedula', 'paciente', true
    );
  END LOOP;
END $$;

-- Perfiles de pacientes con datos demográficos diversos
INSERT INTO perfiles_pacientes (
  id_usuario, nombre_completo, fecha_nacimiento, edad, sexo,
  tipo_sangre_id, estado_id, ciudad_id,
  domicilio_calle, domicilio_numero, domicilio_cp,
  ocupacion_id, estado_civil_id, grupo_etnico_id, religion_id,
  nivel_socioeconomico_id, tipo_vivienda_id, perfil_completo_pct
)
SELECT
  ul.id,
  ul.nombre_completo,
  CURRENT_DATE - ((RANDOM() * 25000 + 6570)::int) as fecha_nacimiento,
  EXTRACT(YEAR FROM AGE(CURRENT_DATE - ((RANDOM() * 25000 + 6570)::int)))::integer,
  CASE
    WHEN ul.nombre_completo LIKE 'Juan%' OR ul.nombre_completo LIKE 'Carlos%' OR ul.nombre_completo LIKE 'Roberto%'
      OR ul.nombre_completo LIKE 'Miguel%' OR ul.nombre_completo LIKE 'Fernando%' OR ul.nombre_completo LIKE 'Lucas%'
      OR ul.nombre_completo LIKE 'Diego%' OR ul.nombre_completo LIKE 'Raúl%' OR ul.nombre_completo LIKE 'Arturo%'
      OR ul.nombre_completo LIKE 'Javier%' OR ul.nombre_completo LIKE 'Mauricio%' OR ul.nombre_completo LIKE 'Sergio%'
      OR ul.nombre_completo LIKE 'Eduardo%' OR ul.nombre_completo LIKE 'Adrián%' OR ul.nombre_completo LIKE 'Héctor%'
      OR ul.nombre_completo LIKE 'Pedro%' OR ul.nombre_completo LIKE 'Antonio%' OR ul.nombre_completo LIKE 'Rafael%'
      OR ul.nombre_completo LIKE 'Alberto%' OR ul.nombre_completo LIKE 'Ernesto%' OR ul.nombre_completo LIKE 'Mario%'
      OR ul.nombre_completo LIKE 'José%' OR ul.nombre_completo LIKE 'Guillermo%' OR ul.nombre_completo LIKE 'Vicente%'
      OR ul.nombre_completo LIKE 'Octavio%'
    THEN 'M' ELSE 'F'
  END,
  (SELECT id FROM cat_tipos_sanguineo ORDER BY RANDOM() LIMIT 1),
  (SELECT id FROM cat_estados_republica ORDER BY RANDOM() LIMIT 1),
  (SELECT id FROM cat_ciudades ORDER BY RANDOM() LIMIT 1),
  (ARRAY['Av. Insurgentes','Calle Reforma','Av. Universidad','Calle Hidalgo','Av. Juárez','Calle Morelos','Av. Revolución','Calle Madero','Av. Patriotismo','Calle Allende'])[1 + FLOOR(RANDOM() * 10)],
  FLOOR(RANDOM() * 999 + 1)::text,
  LPAD(FLOOR(RANDOM() * 99999 + 1)::text, 5, '0'),
  (SELECT id FROM cat_ocupaciones ORDER BY RANDOM() LIMIT 1),
  (SELECT id FROM cat_estado_civil ORDER BY RANDOM() LIMIT 1),
  (SELECT id FROM cat_grupos_etnicos ORDER BY RANDOM() LIMIT 1),
  (SELECT id FROM cat_religiones ORDER BY RANDOM() LIMIT 1),
  (SELECT id FROM cat_niveles_socioeconomicos ORDER BY RANDOM() LIMIT 1),
  (SELECT id FROM cat_tipos_vivienda ORDER BY RANDOM() LIMIT 1),
  FLOOR(RANDOM() * 30 + 70)::integer
FROM usuarios_luisa ul
WHERE ul.rol = 'paciente';

-- ============================================================================
-- 10 ADMINISTRADORES FAMILIARES
-- ============================================================================

INSERT INTO usuarios_luisa (email, password_hash, nombre_completo, documento_identidad, documento_tipo, rol, activo)
VALUES
('mama01@email.com', crypt('mama1', gen_salt('bf')), 'Elena Vargas de Pérez', 'MAMA-01', 'cedula', 'admin_familiar', true),
('mama02@email.com', crypt('mama2', gen_salt('bf')), 'María Esther Ramírez', 'MAMA-02', 'cedula', 'admin_familiar', true),
('mama03@email.com', crypt('mama3', gen_salt('bf')), 'Rosario Hernández', 'MAMA-03', 'cedula', 'admin_familiar', true),
('mama04@email.com', crypt('mama4', gen_salt('bf')), 'Guadalupe Torres', 'MAMA-04', 'cedula', 'admin_familiar', true),
('mama05@email.com', crypt('mama5', gen_salt('bf')), 'Concepción López', 'MAMA-05', 'cedula', 'admin_familiar', true),
('mama06@email.com', crypt('mama6', gen_salt('bf')), 'Margarita González', 'MAMA-06', 'cedula', 'admin_familiar', true),
('mama07@email.com', crypt('mama7', gen_salt('bf')), 'Esperanza Sánchez', 'MAMA-07', 'cedula', 'admin_familiar', true),
('mama08@email.com', crypt('mama8', gen_salt('bf')), 'Lourdes Martínez', 'MAMA-08', 'cedula', 'admin_familiar', true),
('mama09@email.com', crypt('mama9', gen_salt('bf')), 'Patricia Rodríguez', 'MAMA-09', 'cedula', 'admin_familiar', true),
('mama10@email.com', crypt('mama10', gen_salt('bf')), 'Carmen Jiménez', 'MAMA-10', 'cedula', 'admin_familiar', true);

-- Perfiles para las mamás
INSERT INTO perfiles_pacientes (
  id_usuario, nombre_completo, fecha_nacimiento, edad, sexo,
  tipo_sangre_id, estado_id, ciudad_id,
  domicilio_calle, domicilio_numero, domicilio_cp,
  ocupacion_id, estado_civil_id, grupo_etnico_id, religion_id,
  nivel_socioeconomico_id, tipo_vivienda_id, perfil_completo_pct
)
SELECT
  ul.id, ul.nombre_completo,
  CURRENT_DATE - ((RANDOM() * 7300 + 14600)::int),
  EXTRACT(YEAR FROM AGE(CURRENT_DATE - ((RANDOM() * 7300 + 14600)::int)))::integer,
  'F',
  (SELECT id FROM cat_tipos_sanguineo ORDER BY RANDOM() LIMIT 1),
  (SELECT id FROM cat_estados_republica ORDER BY RANDOM() LIMIT 1),
  (SELECT id FROM cat_ciudades ORDER BY RANDOM() LIMIT 1),
  (ARRAY['Av. Insurgentes','Calle Reforma','Av. Universidad','Calle Hidalgo','Av. Juárez'])[1 + FLOOR(RANDOM() * 5)],
  FLOOR(RANDOM() * 999 + 1)::text,
  LPAD(FLOOR(RANDOM() * 99999 + 1)::text, 5, '0'),
  (SELECT id FROM cat_ocupaciones WHERE codigo = 'HOG' LIMIT 1),
  (SELECT id FROM cat_estado_civil WHERE codigo = 'CAS' LIMIT 1),
  (SELECT id FROM cat_grupos_etnicos ORDER BY RANDOM() LIMIT 1),
  (SELECT id FROM cat_religiones ORDER BY RANDOM() LIMIT 1),
  (SELECT id FROM cat_niveles_socioeconomicos ORDER BY RANDOM() LIMIT 1),
  (SELECT id FROM cat_tipos_vivienda ORDER BY RANDOM() LIMIT 1),
  85
FROM usuarios_luisa ul WHERE ul.rol = 'admin_familiar';

-- ============================================================================
-- RELACIONES FAMILIARES (cada mamá cuida 10 hijos)
-- ============================================================================

INSERT INTO family_relationships (parent_id, child_id, tipo_relacion, puede_acceder)
SELECT mama.id, hijo.id, 'madre', true
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
WHERE hijo.seq <= (mama.seq * 10) AND hijo.seq > ((mama.seq - 1) * 10);

-- ============================================================================
-- RELACIONES MÉDICO-PACIENTE (cada médico tiene ~25-50 pacientes)
-- ============================================================================

INSERT INTO doctor_patient_relationships (id_medico, id_paciente, fecha_asignacion, activo)
SELECT m.id, pp.id, NOW() - (RANDOM() * 365)::int * INTERVAL '1 day', true
FROM medicos m CROSS JOIN perfiles_pacientes pp
WHERE RANDOM() < 0.35;

-- ============================================================================
-- 500 CITAS REALISTAS (pasadas y futuras)
-- ============================================================================

INSERT INTO citas (id_paciente, id_medico, fecha_hora, tipo_consulta, duracion_minutos, estado, notas_paciente)
SELECT
  dpr.id_paciente,
  dpr.id_medico,
  NOW() + (RANDOM() * 60 - 30)::int * INTERVAL '1 day',
  CASE
    WHEN RANDOM() > 0.85 THEN 'urgencia'
    WHEN RANDOM() > 0.95 THEN 'hospitalización'
    ELSE 'consulta_externa'
  END,
  CASE WHEN RANDOM() > 0.7 THEN 45 ELSE 30 END,
  CASE
    WHEN RANDOM() < 0.5 THEN 'completada'
    WHEN RANDOM() < 0.7 THEN 'agendada'
    WHEN RANDOM() < 0.85 THEN 'confirmada'
    ELSE 'cancelada'
  END,
  (ARRAY[
    'Paciente acude por dolor de cabeza recurrente',
    'Control de presión arterial',
    'Revisión de tratamiento de diabetes',
    'Dolor abdominal persistente',
    'Seguimiento postoperatorio',
    'Consulta de rutina',
    'Síntomas respiratorios',
    'Dolor en pecho',
    'Mareos y vértigo',
    'Fatiga crónica'
  ])[1 + FLOOR(RANDOM() * 10)]
FROM doctor_patient_relationships dpr
ORDER BY RANDOM()
LIMIT 500;

-- ============================================================================
-- 100 HISTORIAS CLÍNICAS DETALLADAS
-- ============================================================================

INSERT INTO historias_clinicas (
  id_paciente, id_medico, fecha_elaboracion, padecimiento_actual,
  signos_vitales, diagnosticos_problemas_clinicos,
  pronostico_descripcion, indicacion_terapeutica, firmado, fecha_firma
)
SELECT
  pp.id,
  (SELECT m.id FROM medicos m ORDER BY RANDOM() LIMIT 1),
  NOW() - (RANDOM() * 90)::int * INTERVAL '1 day',
  (ARRAY[
    'Paciente acude por cuadro de 2 semanas de evolución caracterizado por cefalea pulsátil bilateral, refiere intensidad 7/10 con exacerbación matutina. Asociado a náusea ocasional sin vómito. Niega fotofobia y fonofobia.',
    'Masculino con diagnóstico de hipertensión arterial sistémica de 10 años de evolución en tratamiento con enalapril 10 mg c/12h. Acude para control de cifras tensionales, refiere apego adecuado al tratamiento.',
    'Paciente con diabetes mellitus tipo 2 de 15 años de evolución en tratamiento con metformina 850 mg c/12h. Reporta automonitoreos de glucosa 110-180 mg/dL, refiere poliuria nocturna ocasional.',
    'Mujer de 45 años con cuadro de 3 días de evolución caracterizado por dolor lumbar izquierdo intenso, irradiado a flanco. Niega disuria, refiere hematuria macroscópica ocasional.',
    'Paciente postoperatoria de colecistectomía laparoscópica hace 7 días. Refiere evolución favorable, dolor en sitio quirúrgico controlado. Acude para retiro de puntos.',
    'Adulto mayor con antecedente de cardiopatía isquémica. Refiere disnea de esfuerzo progresiva en los últimos 2 meses. Niega ortopnea y disnea paroxística nocturna.',
    'Paciente con cuadro respiratorio caracterizado por tos productiva, expectoración blanquecina, fiebre de 38.5°C y odinofagia de 5 días de evolución.',
    'Masculino joven con dolor torácico de 2 días, opresivo, sin irradiación. Asociado a palpitaciones ocasionales. Niega cuadros similares previos.',
    'Paciente refiere mareos y vértigo de inicio súbito desde hace 3 días. Asociado a náusea pero sin vómito. Refiere sensación de inestabilidad al caminar.',
    'Mujer con fatiga crónica de 6 meses de evolución. Refiere astenia, adinamia, dificultad para concentrarse. Niega fiebre, pérdida de peso significativa.'
  ])[1 + FLOOR(RANDOM() * 10)],
  jsonb_build_object(
    'temperatura', ROUND((36.0 + RANDOM() * 2)::numeric, 1),
    'ta_sistolica', (100 + RANDOM() * 60)::int,
    'ta_diastolica', (60 + RANDOM() * 30)::int,
    'fc', (60 + RANDOM() * 40)::int,
    'fr', (14 + RANDOM() * 6)::int,
    'peso_kg', ROUND((50 + RANDOM() * 50)::numeric, 1),
    'talla_cm', (150 + RANDOM() * 40)::int,
    'saturacion_o2', (94 + RANDOM() * 6)::int
  ),
  jsonb_build_array(
    jsonb_build_object(
      'diagnostico', (ARRAY[
        'Hipertensión arterial esencial',
        'Diabetes mellitus tipo 2',
        'Cefalea tensional',
        'Infección de vías urinarias',
        'Asma bronquial',
        'Gastritis crónica',
        'Lumbalgia mecánica',
        'Ansiedad generalizada',
        'Dislipidemia mixta',
        'Insuficiencia venosa crónica'
      ])[1 + FLOOR(RANDOM() * 10)],
      'cie10', (ARRAY['I10','E11','G44','N39','J45','K29','M54','F41','E78','I87'])[1 + FLOOR(RANDOM() * 10)]
    )
  ),
  (ARRAY['Favorable','Reservado','Bueno con control','Estable'])[1 + FLOOR(RANDOM() * 4)],
  (ARRAY[
    'Mantener tratamiento antihipertensivo. Control en 1 mes. Estudios de laboratorio: BH, QS, EGO, perfil lipídico.',
    'Ajuste de hipoglucemiante: metformina 1000 mg c/12h. HbA1c en 3 meses. Dieta para diabético, ejercicio diario.',
    'Paracetamol 500 mg c/8h por 5 días. Higiene del sueño. Manejo de estrés. Control en 2 semanas.',
    'Antibioticoterapia empírica con ciprofloxacino 500 mg c/12h por 7 días. Hidratación abundante. Urocultivo.',
    'Salbutamol inhalado 2 puff c/6h. Beclometasona inhalada 2 puff c/12h. Evitar alérgenos conocidos.',
    'Omeprazol 20 mg en ayunas por 8 semanas. Modificaciones dietéticas. Evitar irritantes gástricos.',
    'Reposo relativo 1 semana. Ibuprofeno 400 mg c/8h por 5 días. Calor local. Fisioterapia.',
    'Sertralina 50 mg c/24h por 8 semanas. Psicoterapia cognitivo-conductual. Control en 4 semanas.',
    'Atorvastatina 20 mg c/24h. Dieta hipolipemiante. Ejercicio aeróbico 3 veces por semana.',
    'Medias de compresión 20-30 mmHg. Diosmina 600 mg c/24h. Elevación de extremidades inferiores.'
  ])[1 + FLOOR(RANDOM() * 10)],
  true,
  NOW() - (RANDOM() * 90)::int * INTERVAL '1 day'
FROM perfiles_pacientes pp
WHERE pp.id_usuario IN (SELECT id FROM usuarios_luisa WHERE rol = 'paciente')
ORDER BY RANDOM()
LIMIT 100;

-- ============================================================================
-- 200 MEDICAMENTOS PRESCRITOS
-- ============================================================================

INSERT INTO medicamentos_paciente (
  id_paciente, id_medicamento, dosis, via_administracion_id,
  frecuencia_id, fecha_inicio, activo
)
SELECT
  pp.id,
  (SELECT id FROM cat_medicamentos ORDER BY RANDOM() LIMIT 1),
  (ARRAY['10 mg','25 mg','50 mg','100 mg','500 mg','850 mg','1 g'])[1 + FLOOR(RANDOM() * 7)],
  (SELECT id FROM cat_vias_administracion ORDER BY RANDOM() LIMIT 1),
  (SELECT id FROM cat_frecuencias_medicamento ORDER BY RANDOM() LIMIT 1),
  CURRENT_DATE - (RANDOM() * 365)::int,
  RANDOM() > 0.2
FROM perfiles_pacientes pp, generate_series(1, 2)
WHERE pp.id_usuario IN (SELECT id FROM usuarios_luisa WHERE rol = 'paciente')
LIMIT 200;

-- ============================================================================
-- 100 NOTAS DE EVOLUCIÓN
-- ============================================================================

INSERT INTO notas_evolucion (
  id_consulta, id_paciente, id_medico, fecha_nota,
  evolucion_cuadro_clinico, signos_vitales,
  diagnosticos_problemas_clinicos, pronostico,
  tratamiento_indicaciones, firmado, fecha_firma
)
SELECT
  c.id, c.id_paciente, c.id_medico, c.fecha_hora,
  (ARRAY[
    'Paciente con evolución favorable. Refiere disminución de sintomatología con tratamiento actual. Sin efectos adversos.',
    'Persiste sintomatología, se ajusta tratamiento. Paciente con apego parcial al manejo.',
    'Mejoría clínica significativa. Cifras tensionales en rango. Continúa tratamiento.',
    'Estabilidad clínica. Sin nuevos eventos. Cumple tratamiento como prescrito.',
    'Cuadro clínico controlado. Refiere tolerancia adecuada a medicamentos.',
    'Paciente refiere mejoría parcial. Persistencia de algunos síntomas. Se ajusta dosis.',
    'Recuperación satisfactoria postoperatoria. Sin datos de complicación.',
    'Control metabólico aceptable. HbA1c en rango terapéutico.',
    'Evolución crónica estable. Acude para receta médica.',
    'Paciente con descompensación leve. Se intensifica tratamiento.'
  ])[1 + FLOOR(RANDOM() * 10)],
  jsonb_build_object(
    'temperatura', ROUND((36.5 + RANDOM() * 1)::numeric, 1),
    'ta_sistolica', (110 + RANDOM() * 40)::int,
    'ta_diastolica', (70 + RANDOM() * 20)::int,
    'fc', (65 + RANDOM() * 25)::int,
    'fr', (14 + RANDOM() * 6)::int
  ),
  jsonb_build_array(
    jsonb_build_object('diagnostico', 'Control de patología crónica', 'cie10', 'Z01')
  ),
  (ARRAY['Favorable','Estable','Reservado','Bueno'])[1 + FLOOR(RANDOM() * 4)],
  jsonb_build_array(
    jsonb_build_object('medicamento', 'Continuar tratamiento'),
    jsonb_build_object('control', 'Cita en 4 semanas')
  ),
  true,
  c.fecha_hora
FROM citas c
WHERE c.estado = 'completada'
ORDER BY RANDOM()
LIMIT 100;

-- ============================================================================
-- VERIFICACIÓN FINAL
-- ============================================================================

SELECT 'DATOS RICOS Y REALISTAS CARGADOS' as resultado;

SELECT
  'Médicos (con especialidades)' as entidad, COUNT(*) as total FROM medicos
UNION ALL SELECT 'Pacientes (nombres reales)', COUNT(*) FROM perfiles_pacientes
UNION ALL SELECT 'Usuarios totales', COUNT(*) FROM usuarios_luisa
UNION ALL SELECT 'Citas', COUNT(*) FROM citas
UNION ALL SELECT 'Historias Clínicas detalladas', COUNT(*) FROM historias_clinicas
UNION ALL SELECT 'Medicamentos prescritos', COUNT(*) FROM medicamentos_paciente
UNION ALL SELECT 'Notas de evolución', COUNT(*) FROM notas_evolucion
UNION ALL SELECT 'Relaciones familiares', COUNT(*) FROM family_relationships
UNION ALL SELECT 'Relaciones médico-paciente', COUNT(*) FROM doctor_patient_relationships
ORDER BY entidad;

-- Muestra de pacientes con nombres reales
SELECT nombre_completo, edad, sexo FROM perfiles_pacientes ORDER BY RANDOM() LIMIT 10;
