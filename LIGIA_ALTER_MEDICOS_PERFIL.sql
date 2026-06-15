-- ============================================================================
-- AGREGAR CAMPOS DE PERFIL A MÉDICOS
-- Foto, firma digital, datos del consultorio
-- ============================================================================

ALTER TABLE medicos
  ADD COLUMN IF NOT EXISTS foto_url TEXT,
  ADD COLUMN IF NOT EXISTS firma_digital TEXT,
  ADD COLUMN IF NOT EXISTS telefono VARCHAR(20),
  ADD COLUMN IF NOT EXISTS consultorio_nombre VARCHAR(255),
  ADD COLUMN IF NOT EXISTS consultorio_direccion TEXT,
  ADD COLUMN IF NOT EXISTS consultorio_logo_url TEXT,
  ADD COLUMN IF NOT EXISTS horario_atencion VARCHAR(255);

-- ============================================================================
-- AGREGAR CAMPOS A CONSULTAS PARA FIRMA Y ESTADO
-- ============================================================================

ALTER TABLE citas
  ADD COLUMN IF NOT EXISTS firmado BOOLEAN DEFAULT false,
  ADD COLUMN IF NOT EXISTS fecha_firma TIMESTAMP,
  ADD COLUMN IF NOT EXISTS firma_hash VARCHAR(255),
  ADD COLUMN IF NOT EXISTS dx_principal TEXT,
  ADD COLUMN IF NOT EXISTS dx_codigo_cie10 VARCHAR(10),
  ADD COLUMN IF NOT EXISTS padecimiento_actual TEXT,
  ADD COLUMN IF NOT EXISTS signos_vitales JSONB,
  ADD COLUMN IF NOT EXISTS exploracion_fisica TEXT,
  ADD COLUMN IF NOT EXISTS pronostico VARCHAR(50);

-- ============================================================================
-- TABLA DE RECETAS
-- ============================================================================

CREATE TABLE IF NOT EXISTS recetas (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  id_consulta UUID REFERENCES citas(id) ON DELETE CASCADE,
  id_paciente UUID REFERENCES perfiles_pacientes(id),
  id_medico UUID REFERENCES medicos(id),
  fecha TIMESTAMP DEFAULT NOW(),
  medicamentos JSONB NOT NULL,
  indicaciones TEXT,
  proxima_cita DATE,
  firmado BOOLEAN DEFAULT false,
  firma_hash VARCHAR(255),
  qr_code TEXT,
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_recetas_paciente ON recetas(id_paciente);
CREATE INDEX IF NOT EXISTS idx_recetas_consulta ON recetas(id_consulta);

-- ============================================================================
-- TABLA DE ESTUDIOS / ANEXOS
-- ============================================================================

CREATE TABLE IF NOT EXISTS estudios_paciente (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  id_consulta UUID REFERENCES citas(id) ON DELETE SET NULL,
  id_paciente UUID REFERENCES perfiles_pacientes(id) ON DELETE CASCADE,
  id_medico_solicitante UUID REFERENCES medicos(id),
  tipo_estudio_id UUID REFERENCES cat_tipos_estudios(id),
  nombre_estudio VARCHAR(255),
  fecha_solicitud TIMESTAMP DEFAULT NOW(),
  fecha_resultado TIMESTAMP,
  valores JSONB,
  archivo_url TEXT,
  notas TEXT,
  estado VARCHAR(50) DEFAULT 'pendiente',
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_estudios_paciente ON estudios_paciente(id_paciente);
CREATE INDEX IF NOT EXISTS idx_estudios_consulta ON estudios_paciente(id_consulta);

-- ============================================================================
-- PERMISOS
-- ============================================================================

GRANT ALL ON recetas TO anon, authenticated, service_role;
GRANT ALL ON estudios_paciente TO anon, authenticated, service_role;

-- ============================================================================
-- DATOS DE EJEMPLO: Asignar foto y firma a algunos médicos
-- ============================================================================

-- Foto y firma para el primer médico (ejemplo con avatar generado)
UPDATE medicos SET
  foto_url = 'https://ui-avatars.com/api/?name=' ||
             REPLACE((SELECT nombre_completo FROM usuarios_ligia WHERE id = medicos.id_usuario), ' ', '+') ||
             '&background=00C9A7&color=fff&size=200&bold=true',
  telefono = '+52 55 ' || LPAD((1000+FLOOR(RANDOM()*9000))::text, 4, '0') || ' ' || LPAD((1000+FLOOR(RANDOM()*9000))::text, 4, '0'),
  consultorio_nombre = 'Consultorio Médico LIGIA',
  consultorio_direccion = 'Av. Insurgentes Sur ' || (100 + FLOOR(RANDOM()*900))::text || ', CDMX',
  horario_atencion = 'Lun-Vie 9:00-18:00';

-- Verificación
SELECT 'Perfil de médicos actualizado' as resultado,
       (SELECT COUNT(*) FROM medicos WHERE foto_url IS NOT NULL) as con_foto,
       (SELECT COUNT(*) FROM medicos WHERE telefono IS NOT NULL) as con_telefono;
