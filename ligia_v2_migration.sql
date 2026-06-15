-- LIGIA V2 MIGRACION FINAL
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

ALTER TABLE perfiles_pacientes ADD COLUMN IF NOT EXISTS ocupacion VARCHAR(100);
ALTER TABLE perfiles_pacientes ADD COLUMN IF NOT EXISTS estado_civil VARCHAR(30);
ALTER TABLE perfiles_pacientes ADD COLUMN IF NOT EXISTS ciudad VARCHAR(100);
ALTER TABLE perfiles_pacientes ADD COLUMN IF NOT EXISTS estado_republica VARCHAR(50);
ALTER TABLE perfiles_pacientes ADD COLUMN IF NOT EXISTS idioma_preferido VARCHAR(10) DEFAULT 'es';
ALTER TABLE perfiles_pacientes ADD COLUMN IF NOT EXISTS perfil_pct_completo INT DEFAULT 0;
ALTER TABLE perfiles_pacientes ADD COLUMN IF NOT EXISTS antecedentes_gineco JSONB DEFAULT '{"menarca_edad":null,"fecha_ultima_menstruacion":null,"embarazos":0,"partos":0,"cesareas":0,"abortos":0,"metodo_anticonceptivo":"","menopausia":false}'::jsonb;
ALTER TABLE perfiles_pacientes ADD COLUMN IF NOT EXISTS habitos JSONB DEFAULT '{"tabaquismo":{"activo":false,"cigarros_dia":0},"alcoholismo":{"activo":false},"drogas":false,"ejercicio":{"activo":false}}'::jsonb;
ALTER TABLE perfiles_pacientes ADD COLUMN IF NOT EXISTS contacto_emergencia JSONB DEFAULT '{"nombre":"","parentesco":"","telefono":""}'::jsonb;

CREATE UNIQUE INDEX IF NOT EXISTS idx_pacientes_curp ON perfiles_pacientes(curp) WHERE curp IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_pacientes_id_usuario ON perfiles_pacientes(id_usuario);

CREATE TABLE IF NOT EXISTS cat_diagnosticos (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  codigo_cie10 VARCHAR(10) UNIQUE NOT NULL,
  nombre VARCHAR(255) NOT NULL,
  descripcion TEXT,
  categoria VARCHAR(100),
  activo BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_diag_codigo ON cat_diagnosticos(codigo_cie10);
CREATE INDEX IF NOT EXISTS idx_diag_nombre ON cat_diagnosticos USING gin(nombre gin_trgm_ops);

CREATE TABLE IF NOT EXISTS consultas (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  id_cita UUID REFERENCES citas(id),
  id_paciente UUID NOT NULL REFERENCES perfiles_pacientes(id),
  id_medico UUID NOT NULL REFERENCES medicos(id),
  fecha_consulta TIMESTAMP DEFAULT NOW(),
  motivo_consulta TEXT,
  notas_soap JSONB DEFAULT '{"subjetivo":"","objetivo":"","analisis":"","plan":""}'::jsonb,
  antecedentes TEXT,
  padecimiento_actual TEXT,
  signos_vitales JSONB DEFAULT '{}'::jsonb,
  exploracion_fisica TEXT,
  diagnostico_texto TEXT,
  pronostico VARCHAR(50),
  plan_tratamiento TEXT,
  diagnostico_principal UUID REFERENCES cat_diagnosticos(id),
  diagnosticos_secundarios JSONB DEFAULT '[]'::jsonb,
  tratamiento_estructurado JSONB DEFAULT '[]'::jsonb,
  medicamentos_prescritos TEXT,
  descripcion_clinica TEXT,
  alertas_emitidas TEXT[],
  compliance_score INT DEFAULT 100,
  proxima_cita DATE,
  observaciones TEXT,
  firmado BOOLEAN DEFAULT false,
  fecha_firma TIMESTAMP,
  created_at TIMESTAMP DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_consultas_paciente ON consultas(id_paciente);
CREATE INDEX IF NOT EXISTS idx_consultas_medico ON consultas(id_medico);
CREATE INDEX IF NOT EXISTS idx_consultas_fecha ON consultas(fecha_consulta);

CREATE TABLE IF NOT EXISTS medicamentos_paciente (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  id_paciente UUID NOT NULL REFERENCES perfiles_pacientes(id),
  id_consulta UUID REFERENCES consultas(id),
  nombre_generico VARCHAR(255) NOT NULL,
  nombre_comercial VARCHAR(255),
  dosis VARCHAR(100),
  frecuencia VARCHAR(100),
  via_administracion VARCHAR(50),
  fecha_inicio DATE,
  fecha_fin DATE,
  cronico BOOLEAN DEFAULT false,
  tabletas_por_empaque INT DEFAULT 30,
  tomas_confirmadas INT DEFAULT 0,
  id_medico_prescribio UUID REFERENCES medicos(id),
  activo BOOLEAN DEFAULT true,
  notas TEXT,
  created_at TIMESTAMP DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_meds_paciente ON medicamentos_paciente(id_paciente, activo);

CREATE TABLE IF NOT EXISTS vacunas_paciente (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  id_paciente UUID NOT NULL REFERENCES perfiles_pacientes(id),
  nombre_vacuna VARCHAR(255) NOT NULL,
  fabricante VARCHAR(100),
  lote VARCHAR(100),
  dosis_numero INT DEFAULT 1,
  fecha_aplicacion DATE,
  proxima_dosis DATE,
  lugar VARCHAR(255),
  created_at TIMESTAMP DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_vacunas_paciente ON vacunas_paciente(id_paciente);

CREATE TABLE IF NOT EXISTS accesos_expediente (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  id_paciente UUID NOT NULL REFERENCES perfiles_pacientes(id),
  token VARCHAR(64) NOT NULL UNIQUE,
  tipo VARCHAR(30) DEFAULT 'qr',
  nivel_acceso VARCHAR(20) DEFAULT 'lectura',
  id_medico_destino UUID REFERENCES medicos(id),
  fecha_expiracion TIMESTAMP NOT NULL,
  accedido BOOLEAN DEFAULT false,
  fecha_acceso TIMESTAMP,
  ip_acceso VARCHAR(45),
  activo BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_accesos_token ON accesos_expediente(token, activo);

CREATE TABLE IF NOT EXISTS auditoria_acciones (
  id BIGSERIAL PRIMARY KEY,
  id_usuario UUID,
  tipo_actor VARCHAR(20),
  accion VARCHAR(100),
  tabla_afectada VARCHAR(100),
  id_registro UUID,
  ip VARCHAR(45),
  metadata JSONB DEFAULT '{}'::jsonb,
  created_at TIMESTAMP DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_auditoria_usuario ON auditoria_acciones(id_usuario, created_at);

CREATE SCHEMA IF NOT EXISTS dw_analitica;

CREATE TABLE IF NOT EXISTS dw_analitica.dim_pacientes_anonimos (
  id_paciente_hash VARCHAR(64) PRIMARY KEY,
  edad_anos INT NOT NULL,
  genero CHAR(1),
  estado_republica VARCHAR(50),
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS dw_analitica.fact_eventos_salud (
  id_evento BIGSERIAL PRIMARY KEY,
  id_paciente_hash VARCHAR(64) REFERENCES dw_analitica.dim_pacientes_anonimos(id_paciente_hash),
  codigo_cie10 VARCHAR(10) NOT NULL,
  principio_activo VARCHAR(255),
  fecha_registro DATE NOT NULL,
  estado_republica VARCHAR(50)
);

CREATE OR REPLACE FUNCTION proteger_expediente_nom024()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'DELETE' THEN
    RAISE EXCEPTION 'NOM-024: Registros clinicos inmutables. ID: %', OLD.id;
  END IF;
  IF TG_OP = 'UPDATE' AND OLD.firmado = true THEN
    IF OLD.notas_soap IS DISTINCT FROM NEW.notas_soap
    OR OLD.diagnostico_texto IS DISTINCT FROM NEW.diagnostico_texto
    OR OLD.plan_tratamiento IS DISTINCT FROM NEW.plan_tratamiento THEN
      RAISE EXCEPTION 'NOM-024: Nota % firmada. Use Nota de Evolucion.', OLD.id;
    END IF;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trg_inmutabilidad_nom024 ON consultas;
CREATE TRIGGER trg_inmutabilidad_nom024
  BEFORE UPDATE OR DELETE ON consultas
  FOR EACH ROW EXECUTE FUNCTION proteger_expediente_nom024();

CREATE OR REPLACE FUNCTION pipeline_etl_anonimizar()
RETURNS TRIGGER AS $$
DECLARE
  v_curp TEXT;
  v_genero TEXT;
  v_nacimiento DATE;
  v_hash TEXT;
  v_edad INT;
  v_estado TEXT;
  v_cie10 TEXT;
BEGIN
  SELECT curp, genero::text, fecha_nacimiento, estado_republica
    INTO v_curp, v_genero, v_nacimiento, v_estado
    FROM perfiles_pacientes WHERE id = NEW.id_paciente;
  IF v_curp IS NOT NULL THEN
    v_hash := encode(digest(v_curp, 'sha256'), 'hex');
    v_edad := EXTRACT(YEAR FROM AGE(v_nacimiento))::INT;
    INSERT INTO dw_analitica.dim_pacientes_anonimos (id_paciente_hash, edad_anos, genero, estado_republica)
    VALUES (v_hash, COALESCE(v_edad,0), LEFT(COALESCE(v_genero,'X'),1), v_estado)
    ON CONFLICT (id_paciente_hash) DO UPDATE SET edad_anos = COALESCE(v_edad,0);
    SELECT codigo_cie10 INTO v_cie10 FROM cat_diagnosticos WHERE id = NEW.diagnostico_principal;
    INSERT INTO dw_analitica.fact_eventos_salud (id_paciente_hash, codigo_cie10, principio_activo, fecha_registro, estado_republica)
    VALUES (v_hash, COALESCE(v_cie10,'Z00'), NEW.medicamentos_prescritos, CURRENT_DATE, v_estado);
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trg_etl_analitica ON consultas;
CREATE TRIGGER trg_etl_analitica
  AFTER INSERT ON consultas
  FOR EACH ROW EXECUTE FUNCTION pipeline_etl_anonimizar();

ALTER TABLE perfiles_pacientes ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS paciente_own_profile ON perfiles_pacientes;
CREATE POLICY paciente_own_profile ON perfiles_pacientes
  USING (id_usuario = auth.uid() OR id IN (SELECT id_paciente FROM consultas WHERE id_medico = (SELECT id FROM medicos WHERE id_usuario = auth.uid() LIMIT 1)));

ALTER TABLE consultas ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS medico_own_consultas ON consultas;
CREATE POLICY medico_own_consultas ON consultas
  USING (id_medico = (SELECT id FROM medicos WHERE id_usuario = auth.uid() LIMIT 1));

ALTER TABLE medicamentos_paciente ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS meds_own ON medicamentos_paciente;
CREATE POLICY meds_own ON medicamentos_paciente
  USING (id_paciente IN (SELECT id FROM perfiles_pacientes WHERE id_usuario = auth.uid()) OR id_medico_prescribio = (SELECT id FROM medicos WHERE id_usuario = auth.uid() LIMIT 1));

CREATE OR REPLACE FUNCTION calcular_completitud_perfil(p_id UUID)
RETURNS INT AS $$
DECLARE
  v_pct INT := 0;
  v_nombre TEXT; v_apellidos TEXT; v_fnac DATE;
  v_curp TEXT; v_sangre TEXT; v_tel TEXT;
  v_whatsapp TEXT; v_genero TEXT;
  v_antec_hf JSONB; v_antec_pat JSONB; v_bitacora JSONB;
  v_habitos JSONB; v_contacto JSONB;
BEGIN
  SELECT nombre, apellidos, fecha_nacimiento, curp, tipo_sangre,
         telefono, whatsapp, genero::text,
         antecedentes_heredofamiliares, antecedentes_patologicos,
         bitacora_mantenimiento, habitos, contacto_emergencia
    INTO v_nombre, v_apellidos, v_fnac, v_curp, v_sangre,
         v_tel, v_whatsapp, v_genero,
         v_antec_hf, v_antec_pat, v_bitacora, v_habitos, v_contacto
    FROM perfiles_pacientes WHERE id = p_id;
  IF v_nombre    IS NOT NULL AND v_nombre    != '' THEN v_pct := v_pct + 5;  END IF;
  IF v_apellidos IS NOT NULL AND v_apellidos != '' THEN v_pct := v_pct + 5;  END IF;
  IF v_fnac      IS NOT NULL                       THEN v_pct := v_pct + 5;  END IF;
  IF v_curp      IS NOT NULL                       THEN v_pct := v_pct + 10; END IF;
  IF v_sangre    IS NOT NULL                       THEN v_pct := v_pct + 5;  END IF;
  IF v_tel       IS NOT NULL                       THEN v_pct := v_pct + 5;  END IF;
  IF v_whatsapp  IS NOT NULL                       THEN v_pct := v_pct + 5;  END IF;
  IF v_genero    IS NOT NULL                       THEN v_pct := v_pct + 5;  END IF;
  IF v_antec_hf  IS NOT NULL AND v_antec_hf  != '{}'::jsonb THEN v_pct := v_pct + 10; END IF;
  IF v_antec_pat IS NOT NULL AND v_antec_pat != '{}'::jsonb THEN v_pct := v_pct + 15; END IF;
  IF v_bitacora  IS NOT NULL AND v_bitacora  != '[]'::jsonb THEN v_pct := v_pct + 10; END IF;
  IF v_habitos   IS NOT NULL AND v_habitos   != '{}'::jsonb THEN v_pct := v_pct + 10; END IF;
  IF v_contacto  IS NOT NULL AND (v_contacto->>'nombre') IS NOT NULL AND (v_contacto->>'nombre') != '' THEN v_pct := v_pct + 10; END IF;
  RETURN LEAST(v_pct, 100);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
