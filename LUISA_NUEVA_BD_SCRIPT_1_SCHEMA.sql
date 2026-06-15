-- ============================================================================
-- LUISA v2.0 - SCRIPT 1: SCHEMA COMPLETO (ejecutar primero)
-- Crea: 26 catálogos + 15 tablas principales + índices
-- Idempotente: limpia tablas previas automáticamente
-- ============================================================================

-- Extensiones necesarias
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- ============================================================================
-- LIMPIAR TODO PRIMERO (orden inverso de FKs)
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
DROP TABLE IF EXISTS usuarios_luisa CASCADE;
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
-- CATÁLOGOS (26)
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
-- TABLAS PRINCIPALES (15)
-- IMPORTANTE: usuarios_luisa usa "password_hash" (sin ñ) para compatibilidad PostgREST
-- ============================================================================

CREATE TABLE usuarios_luisa (id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), email VARCHAR(255) UNIQUE, password_hash VARCHAR(255), nombre_completo VARCHAR(255), documento_identidad VARCHAR(50), documento_tipo VARCHAR(20), rol VARCHAR(50), activo BOOLEAN DEFAULT true, created_at TIMESTAMP DEFAULT NOW(), updated_at TIMESTAMP DEFAULT NOW());

CREATE TABLE medicos (id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), id_usuario UUID REFERENCES usuarios_luisa(id) ON DELETE CASCADE, cedula_profesional VARCHAR(20), numero_cedula_verificado BOOLEAN DEFAULT false, especialidad_id UUID REFERENCES cat_especialidades(id), subespecialidad_id UUID REFERENCES cat_especialidades(id), numero_pacientes INT DEFAULT 0, duracion_consulta_defecto INT DEFAULT 30, activo BOOLEAN DEFAULT true, created_at TIMESTAMP DEFAULT NOW(), updated_at TIMESTAMP DEFAULT NOW());

CREATE TABLE perfiles_pacientes (id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), id_usuario UUID REFERENCES usuarios_luisa(id) ON DELETE CASCADE, nombre_completo VARCHAR(255), fecha_nacimiento DATE, edad INT, sexo VARCHAR(20), tipo_sangre_id UUID REFERENCES cat_tipos_sanguineo(id), estado_id UUID REFERENCES cat_estados_republica(id), ciudad_id UUID REFERENCES cat_ciudades(id), domicilio_calle VARCHAR(255), domicilio_numero VARCHAR(50), domicilio_cp VARCHAR(10), ocupacion_id UUID REFERENCES cat_ocupaciones(id), estado_civil_id UUID REFERENCES cat_estado_civil(id), grupo_etnico_id UUID REFERENCES cat_grupos_etnicos(id), religion_id UUID REFERENCES cat_religiones(id), nivel_socioeconomico_id UUID REFERENCES cat_niveles_socioeconomicos(id), tipo_vivienda_id UUID REFERENCES cat_tipos_vivienda(id), perfil_completo_pct INT DEFAULT 0, created_at TIMESTAMP DEFAULT NOW(), updated_at TIMESTAMP DEFAULT NOW());

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

CREATE TABLE auditoria_acciones (id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), id_usuario UUID REFERENCES usuarios_luisa(id), usuario_rol VARCHAR(50), accion VARCHAR(50), tabla_afectada VARCHAR(100), id_registro UUID, valores_anteriores JSONB, valores_nuevos JSONB, timestamp TIMESTAMP DEFAULT NOW(), ip_address VARCHAR(50), created_at TIMESTAMP DEFAULT NOW());

CREATE TABLE firma_electronica (id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), id_usuario UUID REFERENCES usuarios_luisa(id), tabla_nombre VARCHAR(100), id_registro UUID, tipo_firma VARCHAR(20), fecha_firma TIMESTAMP DEFAULT NOW(), valor_hash VARCHAR(255), certificado_digital TEXT, created_at TIMESTAMP DEFAULT NOW());

-- ============================================================================
-- ÍNDICES
-- ============================================================================

CREATE INDEX idx_usuarios_email ON usuarios_luisa(email);
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
-- PERMISOS PARA POSTGREST (anon + authenticated)
-- ============================================================================

GRANT ALL ON ALL TABLES IN SCHEMA public TO anon, authenticated, service_role;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO anon, authenticated, service_role;

-- ============================================================================
-- VERIFICACIÓN FINAL
-- ============================================================================

SELECT 'SCHEMA CREADO EXITOSAMENTE' as resultado,
       (SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'public') as total_tablas;
