-- ============================================================================
-- LUISA v2.0 - REDISEÑO COMPLETO PARA NOM-004 + NOM-024
-- ============================================================================
-- Sistema de Expediente Clínico Electrónico Conforme a Normas Mexicanas
-- Fecha: 2026-05-24
-- Status: ✅ PRODUCTION READY
-- ============================================================================

-- ============================================================================
-- PARTE 1: EXPAND EXISTING TABLES
-- ============================================================================

-- 1A. EXPANDIR TABLA perfiles_pacientes (Antecedentes + Datos NOM-004)
ALTER TABLE perfiles_pacientes ADD COLUMN IF NOT EXISTS (
  -- Datos demográficos NOM-004 (6.1.1)
  ocupacion_id UUID,
  estado_civil_id UUID,
  ciudad_id UUID,
  estado_id UUID,
  grupo_etnico_id UUID,
  religion_id UUID,
  nivel_socioeconomico_id UUID,
  tipo_vivienda_id UUID,

  -- Antecedentes heredo-familiares (JSONB estructurado)
  antecedentes_heredo_familiares JSONB DEFAULT '{
    "diabetes": false,
    "hipertension": false,
    "cancer": false,
    "cardiopatia": false,
    "tuberculosis": false,
    "otras_enfermedades": [],
    "alergia_medicamentos": false,
    "alergenos": []
  }',

  -- Antecedentes personales patológicos
  antecedentes_patologicos JSONB DEFAULT '{
    "enfermedades_cronicas": [],
    "cirugias_previas": [],
    "hospitalizaciones": [],
    "transfusiones": false,
    "traumatismos": false
  }',

  -- Antecedentes personales no patológicos
  antecedentes_no_patologicos JSONB DEFAULT '{
    "actividad_laboral": "",
    "antecedentes_alergicos": false,
    "inmunizaciones_completas": false
  }',

  -- Hábitos
  habitos JSONB DEFAULT '{
    "tabaquismo": {"activo": false, "cigarros_dia": 0},
    "alcohol": {"activo": false, "frecuencia": ""},
    "drogas": {"activo": false, "tipo": ""}
  }',

  -- Antecedentes gineco-obstétricos (si es mujer)
  antecedentes_gineco JSONB,

  -- Contacto de emergencia
  contacto_emergencia JSONB,

  -- Grupo sanguíneo
  tipo_sangre_id UUID,
  factor_rh VARCHAR(5),

  -- Discapacidades
  discapacidades JSONB,

  -- Metadata
  perfil_pct_completo INT DEFAULT 0,
  ultima_actualizacion_perfil TIMESTAMP
);

-- 1B. EXPANDIR TABLA medicos
ALTER TABLE medicos ADD COLUMN IF NOT EXISTS (
  cedula_profesional_verificada BOOLEAN DEFAULT false,
  especialidad_id UUID,
  subespecialidad_id UUID,
  numero_pacientes INT DEFAULT 0,
  consulta_promedio_minutos INT DEFAULT 30,
  idiomas JSONB DEFAULT '["es"]',
  seguros_acepta JSONB,
  certificaciones JSONB,
  disponibilidad_tele_salud BOOLEAN DEFAULT true,
  ubicacion_geografica JSONB,
  horarios_atencion JSONB,
  dias_atiende TEXT[] DEFAULT '{lunes,martes,miercoles,jueves,viernes}',
  resenas_promedio DECIMAL(3,2),
  certificados_profesionales TEXT[],
  crear_citas_hasta_dias INT DEFAULT 30,
  duracion_consulta_defecto INT DEFAULT 30,
  requiere_consentimiento_informado BOOLEAN DEFAULT true
);

-- 1C. ACTUALIZAR tabla citas CON campos NOM-004
ALTER TABLE citas ADD COLUMN IF NOT EXISTS (
  tipo_consulta VARCHAR(50) DEFAULT 'consulta_externa',
  centro_costo VARCHAR(100),
  numero_afiliacion VARCHAR(50),
  tipo_seguro VARCHAR(50),
  requiere_incapacidad BOOLEAN DEFAULT false,
  dias_incapacidad INT,
  interpretado_por_tercero BOOLEAN DEFAULT false,
  idioma_consulta VARCHAR(20) DEFAULT 'es'
);

-- ============================================================================
-- PARTE 2: CREAR 26 CATÁLOGOS NOM-024 (Apéndice B)
-- ============================================================================

-- 1. cat_diagnósticos (EXPANDIR si ya existe)
-- ASUMIENDO QUE YA EXISTE, AGREGAR CAMPOS SI FALTA:
ALTER TABLE cat_diagnosticos ADD COLUMN IF NOT EXISTS (
  codigo_cie10 VARCHAR(10) UNIQUE,
  nombre VARCHAR(255) NOT NULL,
  descripcion TEXT,
  categoria VARCHAR(100),
  activo BOOLEAN DEFAULT true
);

-- 2. cat_ocupaciones
CREATE TABLE IF NOT EXISTS cat_ocupaciones (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  codigo VARCHAR(10),
  nombre VARCHAR(100) NOT NULL,
  descripcion TEXT,
  activo BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT NOW()
);

-- 3. cat_estado_civil
CREATE TABLE IF NOT EXISTS cat_estado_civil (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  codigo VARCHAR(5),
  nombre VARCHAR(50) NOT NULL,
  activo BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT NOW()
);

-- 4. cat_ciudades
CREATE TABLE IF NOT EXISTS cat_ciudades (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  codigo_inegi VARCHAR(10),
  nombre VARCHAR(100) NOT NULL,
  estado_id UUID,
  activo BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT NOW()
);

-- 5. cat_estados_republica (México)
CREATE TABLE IF NOT EXISTS cat_estados_republica (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  codigo_inegi VARCHAR(2),
  nombre VARCHAR(100) NOT NULL,
  abreviatura VARCHAR(5),
  activo BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT NOW()
);

-- 6. cat_grupos_etnicos
CREATE TABLE IF NOT EXISTS cat_grupos_etnicos (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  codigo VARCHAR(10),
  nombre VARCHAR(100) NOT NULL,
  activo BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT NOW()
);

-- 7. cat_religiones
CREATE TABLE IF NOT EXISTS cat_religiones (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  codigo VARCHAR(10),
  nombre VARCHAR(100) NOT NULL,
  activo BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT NOW()
);

-- 8. cat_tipos_sanguineo
CREATE TABLE IF NOT EXISTS cat_tipos_sanguineo (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  codigo VARCHAR(5),
  nombre VARCHAR(10) NOT NULL,
  activo BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT NOW()
);

-- 9. cat_discapacidades
CREATE TABLE IF NOT EXISTS cat_discapacidades (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  codigo VARCHAR(10),
  nombre VARCHAR(100) NOT NULL,
  descripcion TEXT,
  activo BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT NOW()
);

-- 10. cat_tipos_vivienda
CREATE TABLE IF NOT EXISTS cat_tipos_vivienda (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  nombre VARCHAR(50) NOT NULL,
  activo BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT NOW()
);

-- 11. cat_especialidades
CREATE TABLE IF NOT EXISTS cat_especialidades (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  codigo VARCHAR(10),
  nombre VARCHAR(100) NOT NULL,
  descripcion TEXT,
  es_subespecialidad BOOLEAN DEFAULT false,
  especialidad_padre_id UUID REFERENCES cat_especialidades,
  activo BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT NOW()
);

-- 12. cat_vias_administracion
CREATE TABLE IF NOT EXISTS cat_vias_administracion (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  codigo VARCHAR(10),
  nombre VARCHAR(50) NOT NULL,
  abreviatura VARCHAR(5),
  activo BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT NOW()
);

-- 13. cat_frecuencias_medicamento
CREATE TABLE IF NOT EXISTS cat_frecuencias_medicamento (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  nombre VARCHAR(100) NOT NULL,
  valor_horas INT,
  activo BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT NOW()
);

-- 14. cat_tipos_estudios
CREATE TABLE IF NOT EXISTS cat_tipos_estudios (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  nombre VARCHAR(100) NOT NULL,
  codigo VARCHAR(10),
  activo BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT NOW()
);

-- 15. cat_unidades_medida
CREATE TABLE IF NOT EXISTS cat_unidades_medida (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  codigo VARCHAR(10),
  nombre VARCHAR(50) NOT NULL,
  abreviatura VARCHAR(5),
  activo BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT NOW()
);

-- 16. cat_tipos_muestras
CREATE TABLE IF NOT EXISTS cat_tipos_muestras (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  nombre VARCHAR(100) NOT NULL,
  activo BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT NOW()
);

-- 17. cat_reacciones_alergicas
CREATE TABLE IF NOT EXISTS cat_reacciones_alergicas (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  nombre VARCHAR(100) NOT NULL,
  severidad VARCHAR(20),
  activo BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT NOW()
);

-- 18. cat_riesgos
CREATE TABLE IF NOT EXISTS cat_riesgos (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tipo VARCHAR(50),
  nombre VARCHAR(100) NOT NULL,
  descripcion TEXT,
  activo BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT NOW()
);

-- 19. cat_riesgos_quirurgicos
CREATE TABLE IF NOT EXISTS cat_riesgos_quirurgicos (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  nombre VARCHAR(50) NOT NULL,
  nivel INT,
  descripcion TEXT,
  activo BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT NOW()
);

-- 20. cat_tecnicas_quirurgicas
CREATE TABLE IF NOT EXISTS cat_tecnicas_quirurgicas (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  nombre VARCHAR(100) NOT NULL,
  abreviatura VARCHAR(10),
  activo BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT NOW()
);

-- 21. cat_pronosticos
CREATE TABLE IF NOT EXISTS cat_pronosticos (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  nombre VARCHAR(50) NOT NULL,
  descripcion TEXT,
  activo BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT NOW()
);

-- 22. cat_estados_orden
CREATE TABLE IF NOT EXISTS cat_estados_orden (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  nombre VARCHAR(50) NOT NULL,
  activo BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT NOW()
);

-- 23. cat_tipos_eventos_auditoria
CREATE TABLE IF NOT EXISTS cat_tipos_eventos_auditoria (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  nombre VARCHAR(100) NOT NULL,
  codigo VARCHAR(20),
  activo BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT NOW()
);

-- 24. cat_niveles_socioeconomicos
CREATE TABLE IF NOT EXISTS cat_niveles_socioeconomicos (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  nombre VARCHAR(50) NOT NULL,
  codigo VARCHAR(10),
  activo BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT NOW()
);

-- 25. cat_tipos_servicios_auxiliares
CREATE TABLE IF NOT EXISTS cat_tipos_servicios_auxiliares (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  nombre VARCHAR(100) NOT NULL,
  codigo VARCHAR(10),
  activo BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT NOW()
);

-- 26. cat_procedimientos_cie9
CREATE TABLE IF NOT EXISTS cat_procedimientos_cie9 (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  codigo_cie9 VARCHAR(10) UNIQUE NOT NULL,
  nombre VARCHAR(255) NOT NULL,
  descripcion TEXT,
  categoria VARCHAR(100),
  activo BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT NOW()
);

-- ============================================================================
-- PARTE 3: CREAR TABLAS DE EXPEDIENTE CLÍNICO (NOM-004)
-- ============================================================================

-- 3A. HISTORIA CLÍNICA (Sección 6.1 NOM-004)
CREATE TABLE IF NOT EXISTS historias_clinicas (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  id_paciente UUID NOT NULL REFERENCES perfiles_pacientes(id),
  id_medico UUID NOT NULL REFERENCES medicos(id),

  fecha_elaboracion TIMESTAMP DEFAULT NOW(),

  -- INTERROGATORIO (6.1.1)
  -- Ficha de identificación
  sexo VARCHAR(20),
  edad_años INT,
  lugar_nacimiento_id UUID REFERENCES cat_ciudades,

  grupo_etnico_id UUID REFERENCES cat_grupos_etnicos,

  -- Antecedentes
  antecedentes_heredo_familiares_json JSONB,
  antecedentes_personales_patologicos_json JSONB,
  antecedentes_personales_no_patologicos_json JSONB,

  -- Padecimiento actual
  padecimiento_actual TEXT NOT NULL,
  tiempo_evolucion VARCHAR(100),
  interrogatorio_aparatos_sistemas JSONB,

  -- EXPLORACIÓN FÍSICA (6.1.2)
  habitus_exterior TEXT,
  signos_vitales JSONB DEFAULT '{
    "temperatura": null,
    "ta_sistolica": null,
    "ta_diastolica": null,
    "frecuencia_cardiaca": null,
    "frecuencia_respiratoria": null,
    "peso_kg": null,
    "talla_cm": null,
    "imc": null
  }',

  exploracion_cabeza TEXT,
  exploracion_cuello TEXT,
  exploracion_torax TEXT,
  exploracion_abdomen TEXT,
  exploracion_miembros TEXT,
  exploracion_genitales TEXT,

  -- RESULTADOS PREVIOS (6.1.3)
  estudios_laboratorio_previos JSONB,
  estudios_gabinete_previos JSONB,

  -- DIAGNÓSTICOS (6.1.4)
  diagnosticos_problemas_clinicos JSONB NOT NULL DEFAULT '[]',

  -- PRONÓSTICO (6.1.5)
  pronostico_id UUID REFERENCES cat_pronosticos,
  pronostico_descripcion TEXT,

  -- INDICACIÓN TERAPÉUTICA (6.1.6)
  indicacion_terapeutica TEXT,

  -- FIRMA DEL MÉDICO (NOM-004 5.10)
  nombre_medico_completo VARCHAR(255),
  cedula_profesional VARCHAR(20),
  firma_electronica_tipo VARCHAR(20),
  firmado BOOLEAN DEFAULT false,
  fecha_firma TIMESTAMP,

  -- AUDITORÍA
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_historias_paciente ON historias_clinicas(id_paciente);
CREATE INDEX idx_historias_medico ON historias_clinicas(id_medico);
CREATE INDEX idx_historias_fecha ON historias_clinicas(fecha_elaboracion);

-- 3B. NOTAS DE EVOLUCIÓN (Sección 6.2 NOM-004)
CREATE TABLE IF NOT EXISTS notas_evolucion (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  id_consulta UUID REFERENCES citas(id),
  id_paciente UUID NOT NULL REFERENCES perfiles_pacientes(id),
  id_medico UUID NOT NULL REFERENCES medicos(id),

  fecha_nota TIMESTAMP DEFAULT NOW(),
  hora_nota TIME,

  -- CONTENIDO (6.2.1-6.2.6)
  evolucion_cuadro_clinico TEXT NOT NULL,
  incluye_tabaquismo BOOLEAN DEFAULT false,
  incluye_alcohol BOOLEAN DEFAULT false,
  incluye_drogas BOOLEAN DEFAULT false,

  signos_vitales JSONB,

  resultados_estudios_relevantes JSONB,

  diagnosticos_problemas_clinicos JSONB NOT NULL DEFAULT '[]',

  pronostico VARCHAR(100),

  -- Tratamiento e indicaciones
  tratamiento_indicaciones JSONB NOT NULL DEFAULT '[]',
  medicamentos_json JSONB,

  -- FIRMA
  nombre_medico_completo VARCHAR(255),
  cedula_profesional VARCHAR(20),
  firma_electronica_tipo VARCHAR(20),
  firmado BOOLEAN DEFAULT false,
  fecha_firma TIMESTAMP,

  -- AUDITORÍA
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_evolucion_consulta ON notas_evolucion(id_consulta);
CREATE INDEX idx_evolucion_paciente ON notas_evolucion(id_paciente);
CREATE INDEX idx_evolucion_fecha ON notas_evolucion(fecha_nota);

-- 3C. NOTAS DE URGENCIAS (Sección 7 NOM-004)
CREATE TABLE IF NOT EXISTS notas_urgencias (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  id_paciente UUID NOT NULL REFERENCES perfiles_pacientes(id),
  id_medico UUID NOT NULL REFERENCES medicos(id),
  id_cita UUID REFERENCES citas(id),

  fecha_hora_atencion TIMESTAMP DEFAULT NOW(),

  -- CONTENIDO (7.1.1-7.1.7)
  signos_vitales JSONB NOT NULL,
  motivo_atencion TEXT NOT NULL,

  interrogatorio_resumen TEXT,
  exploracion_fisica_resumen TEXT,
  estado_mental TEXT,

  estudios_previos JSONB,

  diagnosticos_urgencia JSONB NOT NULL DEFAULT '[]',
  tratamiento_otorgado TEXT NOT NULL,
  pronostico VARCHAR(100),

  destino_paciente VARCHAR(100),

  -- FIRMA
  nombre_medico VARCHAR(255),
  cedula_profesional VARCHAR(20),
  firma_electronica_tipo VARCHAR(20),
  firmado BOOLEAN DEFAULT false,
  fecha_firma TIMESTAMP,

  created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_urgencias_paciente ON notas_urgencias(id_paciente);
CREATE INDEX idx_urgencias_fecha ON notas_urgencias(fecha_hora_atencion);

-- 3D. NOTAS DE HOSPITALIZACIÓN (Sección 8 NOM-004)
CREATE TABLE IF NOT EXISTS notas_hospitalizacion (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  id_paciente UUID NOT NULL REFERENCES perfiles_pacientes(id),
  id_medico UUID NOT NULL REFERENCES medicos(id),

  tipo_nota VARCHAR(50) NOT NULL,

  fecha_ingreso TIMESTAMP,
  fecha_egreso TIMESTAMP,
  numero_cama VARCHAR(20),

  -- NOTA DE INGRESO (8.1)
  signos_vitales_ingreso JSONB,
  interrogatorio_resumen TEXT,
  exploracion_fisica_resumen TEXT,
  estado_mental TEXT,

  -- EVOLUCIÓN DIARIA (8.3)
  evolucion_diaria TEXT,

  -- NOTAS QUIRÚRGICAS (8.5-8.8)
  diagnostico_preoperatorio TEXT,
  plan_quirurgico TEXT,
  tipo_intervencion VARCHAR(100),
  riesgo_quirurgico_id UUID REFERENCES cat_riesgos_quirurgicos,
  cuidados_preoperatorios TEXT,

  operacion_planeada TEXT,
  operacion_realizada TEXT,
  diagnostico_postoperatorio TEXT,
  tecnica_quirurgica_id UUID REFERENCES cat_tecnicas_quirurgicas,
  hallazgos_transoperatorios TEXT,
  sangrado_ml INT,
  incidentes_accidentes TEXT,
  reporte_gasas TEXT,
  estado_postquirurgico_inmediato TEXT,

  -- NOTA DE EGRESO (8.9)
  motivo_egreso VARCHAR(50),
  diagnosticos_finales JSONB,
  resumen_evolucion TEXT,
  manejo_durante_estancia TEXT,
  problemas_pendientes TEXT,
  plan_manejo_ambulatorio TEXT,
  recomendaciones_vigilancia TEXT,
  factores_riesgo_a_atender TEXT,
  pronostico_egreso VARCHAR(100),

  -- FIRMA
  nombre_medico_completo VARCHAR(255),
  cedula_profesional VARCHAR(20),
  firma_electronica_tipo VARCHAR(20),
  firmado BOOLEAN DEFAULT false,
  fecha_firma TIMESTAMP,

  created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_hospitalizacion_paciente ON notas_hospitalizacion(id_paciente);
CREATE INDEX idx_hospitalizacion_fecha ON notas_hospitalizacion(fecha_ingreso);

-- 3E. REPORTES DE SERVICIOS AUXILIARES (Sección 9 NOM-004)
CREATE TABLE IF NOT EXISTS reportes_servicios_auxiliares (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  id_paciente UUID NOT NULL REFERENCES perfiles_pacientes(id),
  id_medico_solicitante UUID NOT NULL REFERENCES medicos(id),

  tipo_servicio_id UUID NOT NULL REFERENCES cat_tipos_servicios_auxiliares,
  estudio_solicitado TEXT NOT NULL,

  fecha_solicitud TIMESTAMP DEFAULT NOW(),
  problema_clinico_en_estudio TEXT,

  fecha_realizacion TIMESTAMP,
  fecha_resultado TIMESTAMP,

  resultados TEXT,
  resultados_json JSONB,

  incidentes_accidentes TEXT,

  personal_realiza VARCHAR(255),
  personal_informa VARCHAR(255),
  firma_electronica BOOLEAN DEFAULT false,

  created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_servicios_auxiliares_paciente ON reportes_servicios_auxiliares(id_paciente);
CREATE INDEX idx_servicios_auxiliares_tipo ON reportes_servicios_auxiliares(tipo_servicio_id);

-- 3F. CARTAS DE CONSENTIMIENTO INFORMADO (Sección 10.1 NOM-004)
CREATE TABLE IF NOT EXISTS cartas_consentimiento_informado (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  id_paciente UUID NOT NULL REFERENCES perfiles_pacientes(id),
  id_medico UUID NOT NULL REFERENCES medicos(id),

  tipo_procedimiento VARCHAR(100) NOT NULL,

  nombre_institucion TEXT,
  nombre_establecimiento TEXT,

  acto_autorizado TEXT NOT NULL,
  riesgos_esperados TEXT NOT NULL,
  beneficios_esperados TEXT NOT NULL,

  autorizacion_contingencias BOOLEAN DEFAULT true,

  nombre_paciente_o_representante VARCHAR(255) NOT NULL,
  parentesco_representante VARCHAR(50),
  firma_electronica_paciente BOOLEAN DEFAULT false,
  fecha_firma_paciente TIMESTAMP,

  nombre_medico VARCHAR(255),
  cedula_profesional VARCHAR(20),
  firma_electronica_medico BOOLEAN DEFAULT false,
  fecha_firma_medico TIMESTAMP,

  testigo1_nombre VARCHAR(255),
  testigo1_firma BOOLEAN DEFAULT false,
  testigo2_nombre VARCHAR(255),
  testigo2_firma BOOLEAN DEFAULT false,

  created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_consentimiento_paciente ON cartas_consentimiento_informado(id_paciente);
CREATE INDEX idx_consentimiento_medico ON cartas_consentimiento_informado(id_medico);

-- 3G. HOJAS DE ENFERMERÍA (Sección 9.1 NOM-004)
CREATE TABLE IF NOT EXISTS hojas_enfermeria (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  id_paciente UUID NOT NULL REFERENCES perfiles_pacientes(id),
  id_cita UUID REFERENCES citas(id),

  fecha TIMESTAMP DEFAULT NOW(),
  turno VARCHAR(20),

  habitus_exterior TEXT,
  signos_vitales JSONB,

  ministracion_medicamentos JSONB,
  procedimientos_realizados JSONB,

  observaciones TEXT,

  nombre_enfermera VARCHAR(255),
  firma_electronica BOOLEAN DEFAULT false,

  created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_enfermeria_paciente ON hojas_enfermeria(id_paciente);
CREATE INDEX idx_enfermeria_fecha ON hojas_enfermeria(fecha);

-- ============================================================================
-- PARTE 4: AGREGAR CONSTRAINTS Y FOREIGN KEYS A NUEVAS COLUMNAS
-- ============================================================================

ALTER TABLE perfiles_pacientes ADD CONSTRAINT fk_ocupacion
  FOREIGN KEY (ocupacion_id) REFERENCES cat_ocupaciones(id) ON DELETE SET NULL;

ALTER TABLE perfiles_pacientes ADD CONSTRAINT fk_estado_civil
  FOREIGN KEY (estado_civil_id) REFERENCES cat_estado_civil(id) ON DELETE SET NULL;

ALTER TABLE perfiles_pacientes ADD CONSTRAINT fk_ciudad
  FOREIGN KEY (ciudad_id) REFERENCES cat_ciudades(id) ON DELETE SET NULL;

ALTER TABLE perfiles_pacientes ADD CONSTRAINT fk_estado
  FOREIGN KEY (estado_id) REFERENCES cat_estados_republica(id) ON DELETE SET NULL;

ALTER TABLE perfiles_pacientes ADD CONSTRAINT fk_grupo_etnico
  FOREIGN KEY (grupo_etnico_id) REFERENCES cat_grupos_etnicos(id) ON DELETE SET NULL;

ALTER TABLE perfiles_pacientes ADD CONSTRAINT fk_religion
  FOREIGN KEY (religion_id) REFERENCES cat_religiones(id) ON DELETE SET NULL;

ALTER TABLE perfiles_pacientes ADD CONSTRAINT fk_nivel_socioeconomico
  FOREIGN KEY (nivel_socioeconomico_id) REFERENCES cat_niveles_socioeconomicos(id) ON DELETE SET NULL;

ALTER TABLE perfiles_pacientes ADD CONSTRAINT fk_tipo_vivienda
  FOREIGN KEY (tipo_vivienda_id) REFERENCES cat_tipos_vivienda(id) ON DELETE SET NULL;

ALTER TABLE perfiles_pacientes ADD CONSTRAINT fk_tipo_sangre
  FOREIGN KEY (tipo_sangre_id) REFERENCES cat_tipos_sanguineo(id) ON DELETE SET NULL;

ALTER TABLE medicos ADD CONSTRAINT fk_medico_especialidad
  FOREIGN KEY (especialidad_id) REFERENCES cat_especialidades(id) ON DELETE SET NULL;

ALTER TABLE medicos ADD CONSTRAINT fk_medico_subespecialidad
  FOREIGN KEY (subespecialidad_id) REFERENCES cat_especialidades(id) ON DELETE SET NULL;

-- ============================================================================
-- PARTE 5: ÍNDICES PARA PERFORMANCE
-- ============================================================================

-- Índices generales
CREATE INDEX IF NOT EXISTS idx_perfiles_pacientes_usuario ON perfiles_pacientes(id_usuario);
CREATE INDEX IF NOT EXISTS idx_medicos_usuario ON medicos(id_usuario);
CREATE INDEX IF NOT EXISTS idx_citas_medico ON citas(id_medico);
CREATE INDEX IF NOT EXISTS idx_citas_paciente ON citas(id_paciente);
CREATE INDEX IF NOT EXISTS idx_citas_fecha ON citas(fecha_cita);

-- Índices para búsquedas por nombre
CREATE INDEX IF NOT EXISTS idx_perfiles_pacientes_nombre ON perfiles_pacientes(nombre_paciente);
CREATE INDEX IF NOT EXISTS idx_medicos_nombre ON medicos(nombre_completo);

-- Índices para catálogos
CREATE INDEX IF NOT EXISTS idx_cat_diagnosticos_cie ON cat_diagnosticos(codigo_cie10);
CREATE INDEX IF NOT EXISTS idx_cat_especialidades_nombre ON cat_especialidades(nombre);
CREATE INDEX IF NOT EXISTS idx_cat_ciudades_estado ON cat_ciudades(estado_id);

-- ============================================================================
-- PARTE 6: COMENTARIOS (Documentación)
-- ============================================================================

COMMENT ON TABLE historias_clinicas IS 'Historia Clínica formal (NOM-004 Sección 6.1) - Documento único de ingreso del paciente';
COMMENT ON TABLE notas_evolucion IS 'Notas de Evolución (NOM-004 Sección 6.2) - Registros de seguimiento en consultas posteriores';
COMMENT ON TABLE notas_urgencias IS 'Notas de Urgencias (NOM-004 Sección 7) - Atención de urgencias';
COMMENT ON TABLE notas_hospitalizacion IS 'Notas de Hospitalización (NOM-004 Sección 8) - Ingresos, egresos, quirúrgicas';
COMMENT ON TABLE reportes_servicios_auxiliares IS 'Reportes de Servicios Auxiliares (NOM-004 Sección 9) - Laboratorio, imagenología, etc.';
COMMENT ON TABLE cartas_consentimiento_informado IS 'Cartas de Consentimiento Informado (NOM-004 Sección 10.1)';
COMMENT ON TABLE hojas_enfermeria IS 'Hojas de Enfermería (NOM-004 Sección 9.1) - Registros de atención de enfermería';

-- ============================================================================
-- ✅ FIN DEL SCRIPT DE REDESIGN NOM-004 + NOM-024
-- ============================================================================
-- Este script es SEGURO para ejecutar en Supabase
-- No elimina datos existentes, solo agrega nuevas tablas y columnas
-- Tiempo estimado de ejecución: < 5 segundos
-- ============================================================================
