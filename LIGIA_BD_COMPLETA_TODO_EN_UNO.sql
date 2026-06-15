-- ============================================================================
-- LIGIA v2.0 - SCRIPT COMPLETO TODO EN UNO
-- Schema + 26 Catálogos + Datos de prueba (médicos, pacientes, datos clínicos)
-- Idempotente: se puede re-ejecutar
-- ============================================================================

-- Extensiones necesarias
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- ============================================================================
-- BLOQUE 1: LIMPIAR TODO PRIMERO
-- ============================================================================

DROP TABLE IF EXISTS firma_electronica CASCADE;
DROP TABLE IF EXISTS auditoria_acciones CASCADE;
DROP TABLE IF EXISTS vacunas_paciente CASCADE;
DROP TABLE IF EXISTS diario_eventos CASCADE;
DROP TABLE IF EXISTS medicamentos_paciente CASCADE;
DROP TABLE IF EXISTS notas_hospitalizacion CASCADE;
DROP TABLE IF EXISTS notas_urgencias CASCADE;
DROP TABLE IF EXISTS notas_evolucion CASCADE;
DROP TABLE IF EXISTS historias_clinicas CASCADE;
DROP TABLE IF EXISTS citas CASCADE;
DROP TABLE IF EXISTS family_relationships CASCADE;
DROP TABLE IF EXISTS doctor_patient_relationships CASCADE;
DROP TABLE IF EXISTS perfiles_pacientes CASCADE;
DROP TABLE IF EXISTS medicos CASCADE;
DROP TABLE IF EXISTS usuarios_ligia CASCADE;
DROP TABLE IF EXISTS cat_procedimientos_cie9 CASCADE;
DROP TABLE IF EXISTS cat_tipos_servicios_auxiliares CASCADE;
DROP TABLE IF EXISTS cat_tipos_eventos_auditoria CASCADE;
DROP TABLE IF EXISTS cat_estados_orden CASCADE;
DROP TABLE IF EXISTS cat_tecnicas_quirurgicas CASCADE;
DROP TABLE IF EXISTS cat_riesgos_quirurgicos CASCADE;
DROP TABLE IF EXISTS cat_riesgos CASCADE;
DROP TABLE IF EXISTS cat_reacciones_alergicas CASCADE;
DROP TABLE IF EXISTS cat_niveles_socioeconomicos CASCADE;
DROP TABLE IF EXISTS cat_pronosticos CASCADE;
DROP TABLE IF EXISTS cat_medicamentos CASCADE;
DROP TABLE IF EXISTS cat_diagnosticos CASCADE;
DROP TABLE IF EXISTS cat_unidades_medida CASCADE;
DROP TABLE IF EXISTS cat_tipos_estudios CASCADE;
DROP TABLE IF EXISTS cat_frecuencias_medicamento CASCADE;
DROP TABLE IF EXISTS cat_vias_administracion CASCADE;
DROP TABLE IF EXISTS cat_especialidades CASCADE;
DROP TABLE IF EXISTS cat_tipos_vivienda CASCADE;
DROP TABLE IF EXISTS cat_discapacidades CASCADE;
DROP TABLE IF EXISTS cat_tipos_sanguineo CASCADE;
DROP TABLE IF EXISTS cat_religiones CASCADE;
DROP TABLE IF EXISTS cat_grupos_etnicos CASCADE;
DROP TABLE IF EXISTS cat_estado_civil CASCADE;
DROP TABLE IF EXISTS cat_ocupaciones CASCADE;
DROP TABLE IF EXISTS cat_ciudades CASCADE;
DROP TABLE IF EXISTS cat_estados_republica CASCADE;

-- ============================================================================
-- BLOQUE 2: CATÁLOGOS (26 tablas)
-- ============================================================================

CREATE TABLE cat_estados_republica (id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), codigo_inegi VARCHAR(2), nombre VARCHAR(100), abreviatura VARCHAR(10), activo BOOLEAN DEFAULT true, created_at TIMESTAMP DEFAULT NOW());
CREATE TABLE cat_ciudades (id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), codigo_inegi VARCHAR(10), nombre VARCHAR(100), estado_id UUID REFERENCES cat_estados_republica(id), activo BOOLEAN DEFAULT true, created_at TIMESTAMP DEFAULT NOW());
CREATE TABLE cat_ocupaciones (id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), codigo VARCHAR(10), nombre VARCHAR(100), descripcion TEXT, activo BOOLEAN DEFAULT true, created_at TIMESTAMP DEFAULT NOW());
CREATE TABLE cat_estado_civil (id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), codigo VARCHAR(10), nombre VARCHAR(50), activo BOOLEAN DEFAULT true, created_at TIMESTAMP DEFAULT NOW());
CREATE TABLE cat_grupos_etnicos (id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), codigo VARCHAR(10), nombre VARCHAR(100), activo BOOLEAN DEFAULT true, created_at TIMESTAMP DEFAULT NOW());
CREATE TABLE cat_religiones (id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), codigo VARCHAR(10), nombre VARCHAR(100), activo BOOLEAN DEFAULT true, created_at TIMESTAMP DEFAULT NOW());
CREATE TABLE cat_tipos_sanguineo (id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), codigo VARCHAR(10), nombre VARCHAR(50), activo BOOLEAN DEFAULT true, created_at TIMESTAMP DEFAULT NOW());
CREATE TABLE cat_discapacidades (id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), codigo VARCHAR(10), nombre VARCHAR(100), descripcion TEXT, activo BOOLEAN DEFAULT true, created_at TIMESTAMP DEFAULT NOW());
CREATE TABLE cat_tipos_vivienda (id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), nombre VARCHAR(50), activo BOOLEAN DEFAULT true, created_at TIMESTAMP DEFAULT NOW());
CREATE TABLE cat_especialidades (id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), codigo VARCHAR(10), nombre VARCHAR(100), descripcion TEXT, es_subespecialidad BOOLEAN DEFAULT false, especialidad_padre_id UUID REFERENCES cat_especialidades(id), activo BOOLEAN DEFAULT true, created_at TIMESTAMP DEFAULT NOW());
CREATE TABLE cat_vias_administracion (id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), codigo VARCHAR(10), nombre VARCHAR(50), abreviatura VARCHAR(10), activo BOOLEAN DEFAULT true, created_at TIMESTAMP DEFAULT NOW());
CREATE TABLE cat_frecuencias_medicamento (id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), nombre VARCHAR(100), valor_horas INT, activo BOOLEAN DEFAULT true, created_at TIMESTAMP DEFAULT NOW());
CREATE TABLE cat_tipos_estudios (id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), nombre VARCHAR(100), codigo VARCHAR(10), activo BOOLEAN DEFAULT true, created_at TIMESTAMP DEFAULT NOW());
CREATE TABLE cat_unidades_medida (id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), codigo VARCHAR(10), nombre VARCHAR(50), abreviatura VARCHAR(10), activo BOOLEAN DEFAULT true, created_at TIMESTAMP DEFAULT NOW());
CREATE TABLE cat_diagnosticos (id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), codigo_cie10 VARCHAR(10), nombre VARCHAR(255), descripcion TEXT, categoria VARCHAR(100), activo BOOLEAN DEFAULT true, created_at TIMESTAMP DEFAULT NOW());
CREATE TABLE cat_medicamentos (id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), codigo_atc VARCHAR(10), nombre VARCHAR(255), dosis_recomendada VARCHAR(100), via_administracion_id UUID REFERENCES cat_vias_administracion(id), contraindicaciones TEXT, activo BOOLEAN DEFAULT true, created_at TIMESTAMP DEFAULT NOW());
CREATE TABLE cat_pronosticos (id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), nombre VARCHAR(50), descripcion TEXT, activo BOOLEAN DEFAULT true, created_at TIMESTAMP DEFAULT NOW());
CREATE TABLE cat_niveles_socioeconomicos (id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), nombre VARCHAR(50), codigo VARCHAR(10), activo BOOLEAN DEFAULT true, created_at TIMESTAMP DEFAULT NOW());
CREATE TABLE cat_reacciones_alergicas (id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), nombre VARCHAR(100), severidad VARCHAR(20), activo BOOLEAN DEFAULT true, created_at TIMESTAMP DEFAULT NOW());
CREATE TABLE cat_riesgos (id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), tipo VARCHAR(50), nombre VARCHAR(100), descripcion TEXT, activo BOOLEAN DEFAULT true, created_at TIMESTAMP DEFAULT NOW());
CREATE TABLE cat_riesgos_quirurgicos (id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), nombre VARCHAR(50), nivel INT, descripcion TEXT, activo BOOLEAN DEFAULT true, created_at TIMESTAMP DEFAULT NOW());
CREATE TABLE cat_tecnicas_quirurgicas (id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), nombre VARCHAR(100), abreviatura VARCHAR(10), activo BOOLEAN DEFAULT true, created_at TIMESTAMP DEFAULT NOW());
CREATE TABLE cat_estados_orden (id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), nombre VARCHAR(50), activo BOOLEAN DEFAULT true, created_at TIMESTAMP DEFAULT NOW());
CREATE TABLE cat_tipos_eventos_auditoria (id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), nombre VARCHAR(100), codigo VARCHAR(20), activo BOOLEAN DEFAULT true, created_at TIMESTAMP DEFAULT NOW());
CREATE TABLE cat_tipos_servicios_auxiliares (id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), nombre VARCHAR(100), codigo VARCHAR(10), activo BOOLEAN DEFAULT true, created_at TIMESTAMP DEFAULT NOW());
CREATE TABLE cat_procedimientos_cie9 (id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), codigo_cie9 VARCHAR(10), nombre VARCHAR(255), descripcion TEXT, categoria VARCHAR(100), activo BOOLEAN DEFAULT true, created_at TIMESTAMP DEFAULT NOW());

-- ============================================================================
-- BLOQUE 3: TABLAS PRINCIPALES (15 tablas)
-- ============================================================================

CREATE TABLE usuarios_ligia (id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), email VARCHAR(255) UNIQUE, password_hash VARCHAR(255), nombre_completo VARCHAR(255), documento_identidad VARCHAR(50), documento_tipo VARCHAR(20), rol VARCHAR(50), activo BOOLEAN DEFAULT true, created_at TIMESTAMP DEFAULT NOW(), updated_at TIMESTAMP DEFAULT NOW());
CREATE TABLE medicos (id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), id_usuario UUID REFERENCES usuarios_ligia(id) ON DELETE CASCADE, cedula_profesional VARCHAR(20), numero_cedula_verificado BOOLEAN DEFAULT false, especialidad_id UUID REFERENCES cat_especialidades(id), subespecialidad_id UUID REFERENCES cat_especialidades(id), numero_pacientes INT DEFAULT 0, duracion_consulta_defecto INT DEFAULT 30, activo BOOLEAN DEFAULT true, created_at TIMESTAMP DEFAULT NOW(), updated_at TIMESTAMP DEFAULT NOW());
CREATE TABLE perfiles_pacientes (id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), id_usuario UUID REFERENCES usuarios_ligia(id) ON DELETE CASCADE, nombre_completo VARCHAR(255), fecha_nacimiento DATE, edad INT, sexo VARCHAR(20), tipo_sangre_id UUID REFERENCES cat_tipos_sanguineo(id), estado_id UUID REFERENCES cat_estados_republica(id), ciudad_id UUID REFERENCES cat_ciudades(id), domicilio_calle VARCHAR(255), domicilio_numero VARCHAR(50), domicilio_cp VARCHAR(10), ocupacion_id UUID REFERENCES cat_ocupaciones(id), estado_civil_id UUID REFERENCES cat_estado_civil(id), grupo_etnico_id UUID REFERENCES cat_grupos_etnicos(id), religion_id UUID REFERENCES cat_religiones(id), nivel_socioeconomico_id UUID REFERENCES cat_niveles_socioeconomicos(id), tipo_vivienda_id UUID REFERENCES cat_tipos_vivienda(id), perfil_completo_pct INT DEFAULT 0, created_at TIMESTAMP DEFAULT NOW(), updated_at TIMESTAMP DEFAULT NOW());
CREATE TABLE doctor_patient_relationships (id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), id_medico UUID REFERENCES medicos(id) ON DELETE CASCADE, id_paciente UUID REFERENCES perfiles_pacientes(id) ON DELETE CASCADE, fecha_asignacion TIMESTAMP DEFAULT NOW(), activo BOOLEAN DEFAULT true, created_at TIMESTAMP DEFAULT NOW());
CREATE TABLE family_relationships (id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), parent_id UUID REFERENCES perfiles_pacientes(id) ON DELETE CASCADE, child_id UUID REFERENCES perfiles_pacientes(id) ON DELETE CASCADE, tipo_relacion VARCHAR(50), puede_acceder BOOLEAN DEFAULT true, created_at TIMESTAMP DEFAULT NOW());
CREATE TABLE citas (id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), id_paciente UUID REFERENCES perfiles_pacientes(id) ON DELETE CASCADE, id_medico UUID REFERENCES medicos(id) ON DELETE CASCADE, fecha_hora TIMESTAMP, tipo_consulta VARCHAR(50) DEFAULT 'consulta_externa', duracion_minutos INT DEFAULT 30, estado VARCHAR(50) DEFAULT 'agendada', notas_paciente TEXT, created_at TIMESTAMP DEFAULT NOW(), updated_at TIMESTAMP DEFAULT NOW());
CREATE TABLE historias_clinicas (id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), id_paciente UUID REFERENCES perfiles_pacientes(id) ON DELETE CASCADE, id_medico UUID REFERENCES medicos(id) ON DELETE CASCADE, fecha_elaboracion TIMESTAMP DEFAULT NOW(), padecimiento_actual TEXT, signos_vitales JSONB, diagnosticos_problemas_clinicos JSONB, pronostico_descripcion TEXT, indicacion_terapeutica TEXT, firmado BOOLEAN DEFAULT false, fecha_firma TIMESTAMP, created_at TIMESTAMP DEFAULT NOW(), updated_at TIMESTAMP DEFAULT NOW());
CREATE TABLE notas_evolucion (id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), id_consulta UUID REFERENCES citas(id), id_paciente UUID REFERENCES perfiles_pacientes(id) ON DELETE CASCADE, id_medico UUID REFERENCES medicos(id) ON DELETE CASCADE, fecha_nota TIMESTAMP DEFAULT NOW(), evolucion_cuadro_clinico TEXT, signos_vitales JSONB, diagnosticos_problemas_clinicos JSONB, pronostico VARCHAR(100), tratamiento_indicaciones JSONB, firmado BOOLEAN DEFAULT false, fecha_firma TIMESTAMP, created_at TIMESTAMP DEFAULT NOW(), updated_at TIMESTAMP DEFAULT NOW());
CREATE TABLE notas_urgencias (id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), id_paciente UUID REFERENCES perfiles_pacientes(id), id_medico UUID REFERENCES medicos(id), fecha_hora_atencion TIMESTAMP DEFAULT NOW(), motivo_atencion TEXT, signos_vitales JSONB, diagnosticos_urgencia JSONB, tratamiento_otorgado TEXT, destino_paciente VARCHAR(100), firmado BOOLEAN DEFAULT false, fecha_firma TIMESTAMP, created_at TIMESTAMP DEFAULT NOW());
CREATE TABLE notas_hospitalizacion (id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), id_paciente UUID REFERENCES perfiles_pacientes(id), id_medico UUID REFERENCES medicos(id), tipo_nota VARCHAR(50), fecha_ingreso TIMESTAMP, fecha_egreso TIMESTAMP, motivo_egreso VARCHAR(50), diagnosticos_finales JSONB, firmado BOOLEAN DEFAULT false, fecha_firma TIMESTAMP, created_at TIMESTAMP DEFAULT NOW());
CREATE TABLE medicamentos_paciente (id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), id_paciente UUID REFERENCES perfiles_pacientes(id) ON DELETE CASCADE, id_medicamento UUID REFERENCES cat_medicamentos(id), dosis VARCHAR(100), via_administracion_id UUID REFERENCES cat_vias_administracion(id), frecuencia_id UUID REFERENCES cat_frecuencias_medicamento(id), fecha_inicio DATE, fecha_fin DATE, activo BOOLEAN DEFAULT true, created_at TIMESTAMP DEFAULT NOW(), updated_at TIMESTAMP DEFAULT NOW());
CREATE TABLE diario_eventos (id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), id_paciente UUID REFERENCES perfiles_pacientes(id) ON DELETE CASCADE, tipo VARCHAR(50), valor VARCHAR(100), descripcion TEXT, fecha TIMESTAMP DEFAULT NOW(), created_at TIMESTAMP DEFAULT NOW());
CREATE TABLE vacunas_paciente (id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), id_paciente UUID REFERENCES perfiles_pacientes(id) ON DELETE CASCADE, nombre_vacuna VARCHAR(255), fabricante VARCHAR(100), numero_lote VARCHAR(50), fecha_aplicacion DATE, created_at TIMESTAMP DEFAULT NOW());
CREATE TABLE auditoria_acciones (id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), id_usuario UUID REFERENCES usuarios_ligia(id), usuario_rol VARCHAR(50), accion VARCHAR(50), tabla_afectada VARCHAR(100), id_registro UUID, valores_anteriores JSONB, valores_nuevos JSONB, timestamp TIMESTAMP DEFAULT NOW(), ip_address VARCHAR(50), created_at TIMESTAMP DEFAULT NOW());
CREATE TABLE firma_electronica (id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), id_usuario UUID REFERENCES usuarios_ligia(id), tabla_nombre VARCHAR(100), id_registro UUID, tipo_firma VARCHAR(20), fecha_firma TIMESTAMP DEFAULT NOW(), valor_hash VARCHAR(255), certificado_digital TEXT, created_at TIMESTAMP DEFAULT NOW());

-- ============================================================================
-- BLOQUE 4: ÍNDICES
-- ============================================================================

CREATE INDEX idx_usuarios_email ON usuarios_ligia(email);
CREATE INDEX idx_medicos_usuario ON medicos(id_usuario);
CREATE INDEX idx_medicos_cedula ON medicos(cedula_profesional);
CREATE INDEX idx_perfiles_usuario ON perfiles_pacientes(id_usuario);
CREATE INDEX idx_citas_paciente ON citas(id_paciente);
CREATE INDEX idx_citas_medico ON citas(id_medico);
CREATE INDEX idx_citas_fecha ON citas(fecha_hora);
CREATE INDEX idx_historia_paciente ON historias_clinicas(id_paciente);
CREATE INDEX idx_historia_medico ON historias_clinicas(id_medico);
CREATE INDEX idx_evolucion_paciente ON notas_evolucion(id_paciente);
CREATE INDEX idx_medic_paciente ON medicamentos_paciente(id_paciente);
CREATE INDEX idx_diario_paciente ON diario_eventos(id_paciente);

-- ============================================================================
-- BLOQUE 5: PERMISOS PARA POSTGREST
-- ============================================================================

GRANT ALL ON ALL TABLES IN SCHEMA public TO anon, authenticated, service_role;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO anon, authenticated, service_role;

-- ============================================================================
-- BLOQUE 6: CARGAR LOS 26 CATÁLOGOS
-- ============================================================================

-- 1. Estados de la República
INSERT INTO cat_estados_republica (codigo_inegi, nombre, abreviatura) VALUES
('01', 'Aguascalientes', 'AGS'), ('02', 'Baja California', 'BC'), ('09', 'Ciudad de México', 'CDMX'),
('14', 'Jalisco', 'JAL'), ('15', 'Estado de México', 'EDOMEX'), ('19', 'Nuevo León', 'NL'),
('21', 'Puebla', 'PUE'), ('22', 'Querétaro', 'QRO');

-- 2. Ciudades
INSERT INTO cat_ciudades (nombre, estado_id) SELECT 'CDMX', id FROM cat_estados_republica WHERE abreviatura = 'CDMX';
INSERT INTO cat_ciudades (nombre, estado_id) SELECT 'Guadalajara', id FROM cat_estados_republica WHERE abreviatura = 'JAL';
INSERT INTO cat_ciudades (nombre, estado_id) SELECT 'Monterrey', id FROM cat_estados_republica WHERE abreviatura = 'NL';
INSERT INTO cat_ciudades (nombre, estado_id) SELECT 'Puebla', id FROM cat_estados_republica WHERE abreviatura = 'PUE';

-- 3. Ocupaciones
INSERT INTO cat_ocupaciones (codigo, nombre, descripcion) VALUES
('PROF', 'Profesional', 'Trabajador profesional'), ('EMP', 'Empleado', 'Empleado de oficina'),
('OBR', 'Obrero', 'Trabajador manual'), ('EST', 'Estudiante', 'En formación académica'),
('HOG', 'Hogar', 'Dedicado al hogar'), ('JUB', 'Jubilado', 'Retirado del trabajo'),
('IND', 'Independiente', 'Trabajo independiente');

-- 4. Estado civil
INSERT INTO cat_estado_civil (codigo, nombre) VALUES
('SOL', 'Soltero(a)'), ('CAS', 'Casado(a)'), ('DIV', 'Divorciado(a)'),
('VIU', 'Viudo(a)'), ('UNI', 'Unión libre');

-- 5. Grupos étnicos
INSERT INTO cat_grupos_etnicos (codigo, nombre) VALUES
('MEST', 'Mestizo'), ('IND', 'Indígena'), ('AFR', 'Afromexicano'), ('OTRO', 'Otro');

-- 6. Religiones
INSERT INTO cat_religiones (codigo, nombre) VALUES
('CAT', 'Católica'), ('PROT', 'Protestante'), ('CRIS', 'Cristiana'),
('JUD', 'Judía'), ('ISL', 'Islámica'), ('NING', 'Ninguna'), ('OTRA', 'Otra');

-- 7. Tipos sanguíneos
INSERT INTO cat_tipos_sanguineo (codigo, nombre) VALUES
('O+', 'O Positivo'), ('O-', 'O Negativo'), ('A+', 'A Positivo'), ('A-', 'A Negativo'),
('B+', 'B Positivo'), ('B-', 'B Negativo'), ('AB+', 'AB Positivo'), ('AB-', 'AB Negativo');

-- 8. Discapacidades
INSERT INTO cat_discapacidades (codigo, nombre, descripcion) VALUES
('MOT', 'Motora', 'Limitación física de movimiento'), ('SEN', 'Sensorial', 'Visual o auditiva'),
('INT', 'Intelectual', 'Capacidades cognitivas'), ('MEN', 'Mental', 'Salud mental crónica'),
('NING', 'Ninguna', 'Sin discapacidad');

-- 9. Tipos de vivienda
INSERT INTO cat_tipos_vivienda (nombre) VALUES
('Casa propia'), ('Casa rentada'), ('Departamento'),
('Vivienda familiar'), ('Cuarto'), ('Otra');

-- 10. Especialidades médicas
INSERT INTO cat_especialidades (codigo, nombre, descripcion) VALUES
('MG', 'Medicina General', 'Atención médica general'), ('MED-FAM', 'Medicina Familiar', 'Especialidad familiar'),
('CARD', 'Cardiología', 'Especialidad del corazón'), ('PED', 'Pediatría', 'Especialidad infantil'),
('GIN', 'Ginecología', 'Especialidad femenina'), ('END', 'Endocrinología', 'Sistema endocrino'),
('NEU', 'Neurología', 'Sistema nervioso'), ('PSQ', 'Psiquiatría', 'Salud mental'),
('DRM', 'Dermatología', 'Piel'), ('OFT', 'Oftalmología', 'Ojos'),
('OTO', 'Otorrinolaringología', 'Oído, nariz y garganta'), ('ORT', 'Ortopedia', 'Sistema musculoesquelético'),
('URO', 'Urología', 'Sistema urinario'), ('REU', 'Reumatología', 'Articulaciones'),
('ONC', 'Oncología', 'Cáncer');

-- 11. Vías de administración
INSERT INTO cat_vias_administracion (codigo, nombre, abreviatura) VALUES
('ORAL', 'Oral', 'V.O.'), ('IV', 'Intravenosa', 'I.V.'),
('IM', 'Intramuscular', 'I.M.'), ('SC', 'Subcutánea', 'S.C.'),
('TOP', 'Tópica', 'Top'), ('INH', 'Inhalada', 'Inh'),
('REC', 'Rectal', 'Rec'), ('VAG', 'Vaginal', 'Vag');

-- 12. Frecuencias de medicamentos
INSERT INTO cat_frecuencias_medicamento (nombre, valor_horas) VALUES
('Cada 4 horas', 4), ('Cada 6 horas', 6), ('Cada 8 horas', 8),
('Cada 12 horas', 12), ('Cada 24 horas', 24), ('Una vez al día', 24),
('Dos veces al día', 12), ('Tres veces al día', 8);

-- 13. Tipos de estudios
INSERT INTO cat_tipos_estudios (nombre, codigo) VALUES
('Biometría hemática', 'BH'), ('Química sanguínea', 'QS'), ('Examen general de orina', 'EGO'),
('Perfil de lípidos', 'LIP'), ('Pruebas de función hepática', 'PFH'), ('Pruebas de función renal', 'PFR'),
('Hemoglobina glucosilada', 'HBA1C'), ('Radiografía simple', 'RX'),
('Tomografía computarizada', 'TC'), ('Resonancia magnética', 'RM');

-- 14. Unidades de medida
INSERT INTO cat_unidades_medida (codigo, nombre, abreviatura) VALUES
('MG', 'Miligramos', 'mg'), ('G', 'Gramos', 'g'), ('ML', 'Mililitros', 'ml'),
('L', 'Litros', 'L'), ('MCG', 'Microgramos', 'mcg'),
('UI', 'Unidades Internacionales', 'UI'), ('MMHG', 'Milímetros de Mercurio', 'mmHg'),
('BPM', 'Latidos por Minuto', 'bpm'), ('RPM', 'Respiraciones por Minuto', 'rpm'),
('CM', 'Centímetros', 'cm'), ('KG', 'Kilogramos', 'kg');

-- 15. Diagnósticos CIE-10
INSERT INTO cat_diagnosticos (codigo_cie10, nombre, categoria) VALUES
('I10', 'Hipertensión arterial esencial', 'Cardiovascular'), ('E11', 'Diabetes mellitus tipo 2', 'Endocrino'),
('J45', 'Asma', 'Respiratorio'), ('K29', 'Gastritis y duodenitis', 'Digestivo'),
('M54', 'Dorsalgia', 'Musculoesquelético'), ('F32', 'Episodio depresivo', 'Mental'),
('Z00', 'Control de salud rutinario', 'Preventivo'), ('Z01', 'Otros exámenes especiales', 'Preventivo');

-- 16. Medicamentos
INSERT INTO cat_medicamentos (codigo_atc, nombre, dosis_recomendada) VALUES
('C09AA02', 'Enalapril', '10 mg'), ('A10BA02', 'Metformina', '850 mg'),
('B01AC06', 'Ácido acetilsalicílico (Aspirina)', '100 mg'), ('M01AE01', 'Ibuprofeno', '400 mg'),
('N02BE01', 'Paracetamol', '500 mg'), ('A02BC01', 'Omeprazol', '20 mg'),
('C10AA01', 'Simvastatina', '20 mg'), ('R03AC02', 'Salbutamol', '100 mcg'),
('J01CA04', 'Amoxicilina', '500 mg'), ('C07AB02', 'Metoprolol', '50 mg');

-- 17. Pronósticos
INSERT INTO cat_pronosticos (nombre, descripcion) VALUES
('Favorable', 'Pronóstico positivo'), ('Reservado', 'Pronóstico con precaución'),
('Grave', 'Pronóstico delicado'), ('Crítico', 'Pronóstico de riesgo vital');

-- 18. Niveles socioeconómicos
INSERT INTO cat_niveles_socioeconomicos (codigo, nombre) VALUES
('AB', 'Alto'), ('C+', 'Medio Alto'), ('C', 'Medio'),
('C-', 'Medio Bajo'), ('D+', 'Bajo'), ('D', 'Muy Bajo'), ('E', 'Marginal');

-- 19. Reacciones alérgicas
INSERT INTO cat_reacciones_alergicas (nombre, severidad) VALUES
('Anafilaxia', 'Grave'), ('Urticaria', 'Moderada'), ('Angioedema', 'Grave'),
('Rash cutáneo', 'Leve'), ('Edema de Quincke', 'Grave'),
('Prurito', 'Leve'), ('Broncoespasmo', 'Grave'), ('Náusea', 'Leve');

-- 20. Riesgos generales
INSERT INTO cat_riesgos (tipo, nombre, descripcion) VALUES
('Epidemiológico', 'Exposición a COVID', 'Contacto con caso positivo'),
('Epidemiológico', 'Exposición a TB', 'Contacto con tuberculosis'),
('Sanitario', 'Falta de saneamiento', 'Sin agua potable o drenaje'),
('Quirúrgico', 'Cirugía mayor', 'Procedimiento de alto riesgo'),
('Anestésico', 'ASA III', 'Riesgo anestésico moderado'),
('Anestésico', 'ASA IV', 'Riesgo anestésico alto');

-- 21. Riesgos quirúrgicos
INSERT INTO cat_riesgos_quirurgicos (nombre, nivel, descripcion) VALUES
('Bajo', 1, 'Paciente sano sin comorbilidades'), ('Moderado', 2, 'Enfermedad sistémica leve'),
('Alto', 3, 'Enfermedad sistémica grave'), ('Muy alto', 4, 'Amenaza para la vida'),
('Crítico', 5, 'No esperaría sobrevivir sin operación');

-- 22. Técnicas quirúrgicas
INSERT INTO cat_tecnicas_quirurgicas (nombre, abreviatura) VALUES
('Abierta', 'OPN'), ('Laparoscópica', 'LAP'), ('Endoscópica', 'END'),
('Robótica', 'ROB'), ('Mínimamente invasiva', 'MI'), ('Microcirugía', 'MIC');

-- 23. Estados de orden
INSERT INTO cat_estados_orden (nombre) VALUES
('Pendiente'), ('En proceso'), ('Ejecutada'),
('Cancelada'), ('Incompleta'), ('Rechazada');

-- 24. Tipos de eventos de auditoría
INSERT INTO cat_tipos_eventos_auditoria (nombre, codigo) VALUES
('Inicio de sesión', 'LOGIN'), ('Cierre de sesión', 'LOGOUT'),
('Lectura', 'READ'), ('Creación', 'CREATE'),
('Modificación', 'UPDATE'), ('Eliminación', 'DELETE'),
('Firma electrónica', 'SIGN'), ('Descarga', 'DOWNLOAD'),
('Exportación', 'EXPORT'), ('Cambio de permisos', 'PERM_CHANGE');

-- 25. Tipos de servicios auxiliares
INSERT INTO cat_tipos_servicios_auxiliares (nombre, codigo) VALUES
('Laboratorio', 'LAB'), ('Radiología', 'RAD'), ('Tomografía', 'TAC'),
('Resonancia Magnética', 'MRI'), ('Ultrasonido', 'USG'), ('Electrocardiograma', 'ECG');

-- 26. Procedimientos CIE-9
INSERT INTO cat_procedimientos_cie9 (codigo_cie9, nombre, categoria) VALUES
('38.93', 'Cateterismo venoso central', 'Cardiovascular'),
('39.61', 'Circulación extracorpórea', 'Cardiovascular'),
('45.13', 'Endoscopia diagnóstica', 'Digestivo'),
('51.23', 'Colecistectomía laparoscópica', 'Digestivo'),
('66.39', 'Salpingectomía bilateral', 'Ginecología'),
('74.10', 'Cesárea cervical baja', 'Obstetricia'),
('81.51', 'Reemplazo total de cadera', 'Ortopedia'),
('86.59', 'Cierre de herida', 'Cirugía menor'),
('88.71', 'Ecografía cabeza/cuello', 'Diagnóstico'),
('99.04', 'Transfusión de paquete globular', 'Hematología');

-- ============================================================================
-- BLOQUE 7: DATOS DE USUARIOS (20 médicos + 100 pacientes + 10 mamás)
-- ============================================================================

-- 20 MÉDICOS con autenticación
INSERT INTO usuarios_ligia (email, password_hash, nombre_completo, documento_identidad, documento_tipo, rol, activo)
SELECT
  CONCAT('medico', LPAD(seq::text, 3, '0'), '@hospital.mx'),
  crypt(CONCAT('medico', seq), gen_salt('bf')),
  CASE seq
    WHEN 1 THEN 'Carlos García Moreno' WHEN 2 THEN 'María Rodríguez López'
    WHEN 3 THEN 'Juan Martínez Silva' WHEN 4 THEN 'Alejandra Castro Flores'
    WHEN 5 THEN 'Ricardo Hernández Pérez' WHEN 6 THEN 'Patricia Flores Gutiérrez'
    WHEN 7 THEN 'Fernando Silva Ramírez' WHEN 8 THEN 'Rosario Morales Díaz'
    WHEN 9 THEN 'Luis Vargas Torres' WHEN 10 THEN 'Graciela Santos Mendoza'
    WHEN 11 THEN 'Andrés Mendoza Vega' WHEN 12 THEN 'Beatriz Núñez Ortiz'
    WHEN 13 THEN 'Pablo Díaz Reyes' WHEN 14 THEN 'Carmen Reyes Cortés'
    WHEN 15 THEN 'Manuel López Fuentes' WHEN 16 THEN 'Susana González Ruiz'
    WHEN 17 THEN 'Octavio Gutiérrez Bravo' WHEN 18 THEN 'Victoria Bravo Chávez'
    WHEN 19 THEN 'Francisco Chávez Soto' ELSE 'Norma Santos Acosta'
  END,
  CONCAT('MED-', LPAD(seq::text, 3, '0')),
  'cedula_profesional', 'medico', true
FROM generate_series(1, 20) as seq;

-- Registros de médicos
INSERT INTO medicos (id_usuario, cedula_profesional, numero_cedula_verificado, especialidad_id, numero_pacientes, duracion_consulta_defecto, activo)
SELECT ul.id, ul.documento_identidad, true,
  (SELECT id FROM cat_especialidades ORDER BY RANDOM() LIMIT 1),
  FLOOR(RANDOM() * 50 + 10)::integer, 30, true
FROM usuarios_ligia ul WHERE ul.rol = 'medico';

-- 100 PACIENTES con autenticación
INSERT INTO usuarios_ligia (email, password_hash, nombre_completo, documento_identidad, documento_tipo, rol, activo)
SELECT
  CONCAT('paciente', LPAD(seq::text, 3, '0'), '@email.com'),
  crypt(CONCAT('paciente', seq), gen_salt('bf')),
  CONCAT('Paciente Nombre ', seq),
  CONCAT('PAC-', LPAD(seq::text, 3, '0')),
  'cedula', 'paciente', true
FROM generate_series(1, 100) as seq;

-- Perfiles de pacientes
INSERT INTO perfiles_pacientes (id_usuario, nombre_completo, fecha_nacimiento, edad, sexo, tipo_sangre_id, estado_id, ciudad_id, ocupacion_id, estado_civil_id, grupo_etnico_id, religion_id, nivel_socioeconomico_id, tipo_vivienda_id, perfil_completo_pct)
SELECT
  ul.id, ul.nombre_completo,
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
FROM usuarios_ligia ul WHERE ul.rol = 'paciente';

-- 10 ADMINISTRADORES FAMILIARES (Madres)
INSERT INTO usuarios_ligia (email, password_hash, nombre_completo, documento_identidad, documento_tipo, rol, activo)
SELECT
  CONCAT('mama', LPAD(seq::text, 2, '0'), '@email.com'),
  crypt(CONCAT('mama', seq), gen_salt('bf')),
  CONCAT('Mamá ', seq),
  CONCAT('MAMA-', LPAD(seq::text, 2, '0')),
  'cedula', 'admin_familiar', true
FROM generate_series(1, 10) as seq;

-- Perfiles para las mamás
INSERT INTO perfiles_pacientes (id_usuario, nombre_completo, fecha_nacimiento, edad, sexo, tipo_sangre_id, estado_id, ciudad_id, ocupacion_id, estado_civil_id, grupo_etnico_id, religion_id, nivel_socioeconomico_id, tipo_vivienda_id, perfil_completo_pct)
SELECT
  ul.id, ul.nombre_completo,
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
FROM usuarios_ligia ul WHERE ul.rol = 'admin_familiar';

-- ============================================================================
-- BLOQUE 8: RELACIONES (familia + medico-paciente)
-- ============================================================================

-- Relaciones familiares (cada mamá administra 10 hijos)
INSERT INTO family_relationships (parent_id, child_id, tipo_relacion, puede_acceder)
SELECT mama.id, hijo.id, 'madre', true
FROM (
  SELECT id, ROW_NUMBER() OVER (ORDER BY created_at DESC) as seq
  FROM perfiles_pacientes
  WHERE id_usuario IN (SELECT id FROM usuarios_ligia WHERE rol = 'admin_familiar')
) mama
CROSS JOIN (
  SELECT id, ROW_NUMBER() OVER (ORDER BY created_at ASC) as seq
  FROM perfiles_pacientes
  WHERE id_usuario IN (SELECT id FROM usuarios_ligia WHERE rol = 'paciente')
) hijo
WHERE hijo.seq <= (mama.seq * 10) AND hijo.seq > ((mama.seq - 1) * 10);

-- Relaciones médico-paciente
INSERT INTO doctor_patient_relationships (id_medico, id_paciente, fecha_asignacion, activo)
SELECT m.id, pp.id, NOW() - (RANDOM() * 365)::int * INTERVAL '1 day', true
FROM medicos m CROSS JOIN perfiles_pacientes pp
WHERE RANDOM() < 0.3 LIMIT 500;

-- ============================================================================
-- BLOQUE 9: DATOS CLÍNICOS (citas + historias + medicamentos)
-- ============================================================================

-- 300 citas
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

-- 50 historias clínicas
INSERT INTO historias_clinicas (id_paciente, id_medico, fecha_elaboracion, padecimiento_actual, signos_vitales, diagnosticos_problemas_clinicos, pronostico_descripcion, indicacion_terapeutica, firmado, fecha_firma)
SELECT
  pp.id, m.id,
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
  true, NOW()
FROM perfiles_pacientes pp CROSS JOIN medicos m
ORDER BY RANDOM() LIMIT 50;

-- 100 medicamentos prescritos
INSERT INTO medicamentos_paciente (id_paciente, id_medicamento, dosis, via_administracion_id, frecuencia_id, fecha_inicio, activo)
SELECT pp.id,
  (SELECT id FROM cat_medicamentos ORDER BY RANDOM() LIMIT 1),
  '10 mg',
  (SELECT id FROM cat_vias_administracion ORDER BY RANDOM() LIMIT 1),
  (SELECT id FROM cat_frecuencias_medicamento ORDER BY RANDOM() LIMIT 1),
  CURRENT_DATE - (RANDOM() * 365)::int, true
FROM perfiles_pacientes pp LIMIT 100;

-- ============================================================================
-- VERIFICACIÓN FINAL
-- ============================================================================

SELECT 'LIGIA v2.0 - BD CREADA COMPLETAMENTE' as resultado;

SELECT
  'Médicos' as entidad, COUNT(*) as total FROM medicos
UNION ALL SELECT 'Pacientes', COUNT(*) FROM perfiles_pacientes
UNION ALL SELECT 'Usuarios Ligia', COUNT(*) FROM usuarios_ligia
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
