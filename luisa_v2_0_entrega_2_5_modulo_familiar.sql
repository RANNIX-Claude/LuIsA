- ============================================================================
-- LUISA v2.0 - ENTREGA 2.5: Módulo Administrativo Familiar
-- ============================================================================
-- Sistema de gestión de permisos para que un familiar administrativo pueda
-- acceder, visualizar, editar y autorizar expedientes de múltiples miembros
-- de la familia con diferentes niveles de control.
--
-- Cumple con NOM-004 (responsabilidad legal del médico) y NOM-024 (auditoría)
-- ============================================================================

-- ============================================================================
-- 1. TABLA: relaciones_familiares
-- ============================================================================
-- Catalogo de relaciones familiares posibles
-- Base para validar qué relaciones pueden ser administradas

CREATE TABLE IF NOT EXISTS cat_relaciones_familiares (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  codigo VARCHAR(20) UNIQUE NOT NULL,
  nombre VARCHAR(100) NOT NULL,
  descripcion TEXT,
  permite_administracion BOOLEAN DEFAULT true,
  requiere_documento_legal BOOLEAN DEFAULT false, -- ej: tutela, poder notarial
  activo BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT NOW()
);

-- Poblar relaciones familiares
INSERT INTO cat_relaciones_familiares (codigo, nombre, descripcion, permite_administracion, requiere_documento_legal)
VALUES
  ('madre', 'Madre', 'Relación de madre con hijo/hija', true, false),
  ('padre', 'Padre', 'Relación de padre con hijo/hija', true, false),
  ('esposo', 'Esposo/a', 'Relación de cónyuge', true, false),
  ('hijo', 'Hijo/a', 'Relación de hijo/hija con padre/madre', true, true),
  ('abuelo', 'Abuelo/a', 'Relación de abuelo/a con nieto/a', true, false),
  ('hermano', 'Hermano/a', 'Relación de hermano/a', false, false),
  ('tutor_legal', 'Tutor Legal', 'Tutor designado por autoridad legal', true, true),
  ('apoderado', 'Apoderado', 'Persona designada por poder notarial', true, true),
  ('otro_familiar', 'Otro Familiar', 'Otro familiar no especificado', false, true)
ON CONFLICT (codigo) DO NOTHING;

-- ============================================================================
-- 2. TABLA: relaciones_familiares (instancias de relaciones entre personas)
-- ============================================================================
-- Vincula a dos personas con una relación familiar
-- Ejemplo: María (madre) está relacionada con Juan (hijo)

CREATE TABLE IF NOT EXISTS relaciones_familiares (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  id_persona_primaria UUID NOT NULL REFERENCES perfiles_pacientes(id) ON DELETE CASCADE,
  id_persona_secundaria UUID NOT NULL REFERENCES perfiles_pacientes(id) ON DELETE CASCADE,

  -- La relación desde la perspectiva de persona_primaria -> persona_secundaria
  -- Ejemplo: persona_primaria=María, persona_secundaria=Juan, relacion=madre
  -- Significa: María ES LA MADRE DE Juan
  relacion_id UUID NOT NULL REFERENCES cat_relaciones_familiares(id),

  -- Documentación que respalda la relación (para casos de tutela, poder, etc.)
  documento_legal_tipo VARCHAR(100), -- Acta de nacimiento, Poder notarial, Sentencia de tutela, etc.
  documento_legal_numero VARCHAR(50),
  documento_legal_fecha DATE,
  documento_legal_url TEXT, -- URL a archivo en almacenamiento

  -- Validación
  relacion_verificada BOOLEAN DEFAULT false,
  fecha_verificacion TIMESTAMP,
  verificado_por UUID REFERENCES medicos(id),

  -- Timestamp
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),

  -- Constraints
  CONSTRAINT personas_diferentes CHECK (id_persona_primaria != id_persona_secundaria),
  CONSTRAINT relacion_unica UNIQUE (id_persona_primaria, id_persona_secundaria, relacion_id)
);

CREATE INDEX idx_relaciones_primaria ON relaciones_familiares(id_persona_primaria);
CREATE INDEX idx_relaciones_secundaria ON relaciones_familiares(id_persona_secundaria);
CREATE INDEX idx_relaciones_tipo ON relaciones_familiares(relacion_id);

-- ============================================================================
-- 3. TABLA: permisos_expediente_familiar
-- ============================================================================
-- Control de permisos para que un administrador familiar acceda a expedientes
-- de familiares. Soporta múltiples niveles de permisos granulares.

CREATE TABLE IF NOT EXISTS permisos_expediente_familiar (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  -- Administrador (quién gestiona)
  id_administrador UUID NOT NULL REFERENCES perfiles_pacientes(id) ON DELETE CASCADE,

  -- Paciente cuyos datos se administran
  id_paciente_vinculado UUID NOT NULL REFERENCES perfiles_pacientes(id) ON DELETE CASCADE,

  -- Relación entre administrador y paciente (para auditoría y validación)
  relacion_familiar_id UUID REFERENCES cat_relaciones_familiares(id),

  -- ========== PERMISOS GRANULARES ==========
  -- Lectura: Puede ver el expediente completo del paciente
  puede_ver_expediente BOOLEAN DEFAULT true,

  -- Edición: Puede editar datos del paciente (antecedentes, medicamentos, etc.)
  puede_editar_datos_paciente BOOLEAN DEFAULT false,

  -- Citas: Puede agendar, ver y modificar citas del paciente
  puede_gestionar_citas BOOLEAN DEFAULT false,

  -- Medicamentos: Puede agregar, editar, eliminar medicamentos
  puede_gestionar_medicamentos BOOLEAN DEFAULT false,

  -- Estudios: Puede solicitar y ver estudios (laboratorio, imagenología)
  puede_solicitar_estudios BOOLEAN DEFAULT false,

  -- Consentimiento: Puede firmar consentimientos informados EN LUGAR del paciente
  -- (solo si el paciente es menor de edad o incapacitado)
  puede_firmar_consentimientos BOOLEAN DEFAULT false,

  -- Descarga: Puede descargar/exportar expediente en PDF o XML
  puede_descargar_expediente BOOLEAN DEFAULT false,

  -- Compartir: Puede compartir el expediente con otros profesionales de salud
  puede_compartir_con_terceros BOOLEAN DEFAULT false,

  -- Autorización: Puede autorizar procedimientos/cirugías (para tutores)
  puede_autorizar_procedimientos BOOLEAN DEFAULT false,

  -- Auditoría: Puede ver el registro de cambios en el expediente
  puede_ver_auditoria BOOLEAN DEFAULT true,

  -- ========== VALIDACIONES Y RESTRICCIONES ==========
  -- Rango de fechas para el que el permiso es válido
  fecha_otorgamiento TIMESTAMP DEFAULT NOW(),
  fecha_vencimiento TIMESTAMP, -- NULL = sin vencimiento

  -- Registro de quién otorgó el permiso (generalmente un médico o paciente mayor de edad)
  otorgado_por UUID REFERENCES usuarios_luisa(id),

  -- Código de acceso temporal (OTP) para validación en caso de cambio de dispositivo
  codigo_acceso_temporal VARCHAR(20),
  codigo_acceso_temporal_usado BOOLEAN DEFAULT false,
  fecha_uso_codigo TIMESTAMP,

  -- Restricciones adicionales
  solo_lectura_consentimientos BOOLEAN DEFAULT false,
  requiere_validacion_dos_pasos BOOLEAN DEFAULT false, -- 2FA para cambios

  -- Razón del permiso (para auditoría)
  razon VARCHAR(255),

  -- Estado
  activo BOOLEAN DEFAULT true,

  -- Timestamps
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),

  -- Constraints
  CONSTRAINT administrador_diferente_paciente CHECK (id_administrador != id_paciente_vinculado),
  CONSTRAINT permisos_unicos UNIQUE (id_administrador, id_paciente_vinculado)
);

CREATE INDEX idx_permisos_administrador ON permisos_expediente_familiar(id_administrador);
CREATE INDEX idx_permisos_paciente ON permisos_expediente_familiar(id_paciente_vinculado);
CREATE INDEX idx_permisos_activos ON permisos_expediente_familiar(activo, fecha_vencimiento);

-- ============================================================================
-- 4. TABLA: auditoria_acciones_familiares
-- ============================================================================
-- Auditoría específica para acciones realizadas por administradores familiares
-- Cumple con NOM-024 requerimientos de auditoría

CREATE TABLE IF NOT EXISTS auditoria_acciones_familiares (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  -- Quién realizó la acción (administrador familiar)
  id_administrador UUID NOT NULL REFERENCES perfiles_pacientes(id) ON DELETE SET NULL,

  -- De quién es el expediente que se modificó
  id_paciente_afectado UUID NOT NULL REFERENCES perfiles_pacientes(id) ON DELETE SET NULL,

  -- Permiso bajo el cual se realizó la acción
  id_permiso UUID REFERENCES permisos_expediente_familiar(id) ON DELETE SET NULL,

  -- La acción realizada
  tipo_accion VARCHAR(50) NOT NULL, -- SELECT, INSERT, UPDATE, DELETE
  tabla_modificada VARCHAR(100),
  id_registro_modificado UUID,

  -- Detalles de la acción
  descripcion TEXT,
  valores_antes JSONB,
  valores_despues JSONB,

  -- Contexto técnico
  ip_address INET,
  user_agent VARCHAR(500),
  dispositivo_info JSONB, -- tipo dispositivo, SO, navegador, etc.

  -- Validación y seguridad
  requirio_dos_pasos BOOLEAN DEFAULT false,
  dos_pasos_validado BOOLEAN DEFAULT true,

  -- Timestamp
  fecha_evento TIMESTAMP DEFAULT NOW(),

  -- Cumplimiento
  cumple_nom_024 BOOLEAN DEFAULT true -- Validación de que cumple con norma
);

CREATE INDEX idx_auditoria_fam_admin ON auditoria_acciones_familiares(id_administrador);
CREATE INDEX idx_auditoria_fam_paciente ON auditoria_acciones_familiares(id_paciente_afectado);
CREATE INDEX idx_auditoria_fam_fecha ON auditoria_acciones_familiares(fecha_evento);

-- ============================================================================
-- 5. FUNCIÓN: verificar_permiso_familiar()
-- ============================================================================
-- Valida si un administrador tiene permiso específico para un paciente
-- Se usa en RLS policies y triggers

CREATE OR REPLACE FUNCTION verificar_permiso_familiar(
  p_id_administrador UUID,
  p_id_paciente UUID,
  p_tipo_permiso VARCHAR
)
RETURNS BOOLEAN AS $$
DECLARE
  v_permiso RECORD;
  v_ahora TIMESTAMP := NOW();
BEGIN
  -- Buscar permiso activo y válido
  SELECT * INTO v_permiso
  FROM permisos_expediente_familiar
  WHERE id_administrador = p_id_administrador
    AND id_paciente_vinculado = p_id_paciente
    AND activo = true
    AND fecha_otorgamiento <= v_ahora
    AND (fecha_vencimiento IS NULL OR fecha_vencimiento > v_ahora)
  LIMIT 1;

  -- Si no hay permiso, retornar false
  IF v_permiso IS NULL THEN
    RETURN false;
  END IF;

  -- Validar el permiso específico solicitado
  CASE p_tipo_permiso
    WHEN 'ver_expediente' THEN
      RETURN v_permiso.puede_ver_expediente;
    WHEN 'editar_datos' THEN
      RETURN v_permiso.puede_editar_datos_paciente;
    WHEN 'gestionar_citas' THEN
      RETURN v_permiso.puede_gestionar_citas;
    WHEN 'gestionar_medicamentos' THEN
      RETURN v_permiso.puede_gestionar_medicamentos;
    WHEN 'solicitar_estudios' THEN
      RETURN v_permiso.puede_solicitar_estudios;
    WHEN 'firmar_consentimientos' THEN
      RETURN v_permiso.puede_firmar_consentimientos;
    WHEN 'descargar_expediente' THEN
      RETURN v_permiso.puede_descargar_expediente;
    WHEN 'compartir_terceros' THEN
      RETURN v_permiso.puede_compartir_con_terceros;
    WHEN 'autorizar_procedimientos' THEN
      RETURN v_permiso.puede_autorizar_procedimientos;
    WHEN 'ver_auditoria' THEN
      RETURN v_permiso.puede_ver_auditoria;
    ELSE
      RETURN false;
  END CASE;
END;
$$ LANGUAGE plpgsql STABLE;

-- ============================================================================
-- 6. FUNCIÓN: obtener_familiares_administrados()
-- ============================================================================
-- Retorna lista de familiares que un administrador puede gestionar

CREATE OR REPLACE FUNCTION obtener_familiares_administrados(p_id_administrador UUID)
RETURNS TABLE (
  id_paciente UUID,
  nombre VARCHAR,
  apellido_paterno VARCHAR,
  relacion VARCHAR,
  puede_ver BOOLEAN,
  puede_editar BOOLEAN,
  fecha_vencimiento TIMESTAMP
) AS $$
BEGIN
  RETURN QUERY
  SELECT
    pef.id_paciente_vinculado,
    pp.nombre,
    pp.apellido_paterno,
    crf.nombre,
    pef.puede_ver_expediente,
    pef.puede_editar_datos_paciente,
    pef.fecha_vencimiento
  FROM permisos_expediente_familiar pef
  JOIN perfiles_pacientes pp ON pef.id_paciente_vinculado = pp.id
  LEFT JOIN cat_relaciones_familiares crf ON pef.relacion_familiar_id = crf.id
  WHERE pef.id_administrador = p_id_administrador
    AND pef.activo = true
    AND (pef.fecha_vencimiento IS NULL OR pef.fecha_vencimiento > NOW())
  ORDER BY pp.nombre;
END;
$$ LANGUAGE plpgsql STABLE;

-- ============================================================================
-- 7. FUNCIÓN: registrar_accion_familiar()
-- ============================================================================
-- Registra automáticamente cada acción realizada por un administrador familiar

CREATE OR REPLACE FUNCTION registrar_accion_familiar(
  p_id_administrador UUID,
  p_id_paciente UUID,
  p_tipo_accion VARCHAR,
  p_tabla_modificada VARCHAR,
  p_descripcion TEXT,
  p_valores_antes JSONB DEFAULT NULL,
  p_valores_despues JSONB DEFAULT NULL,
  p_ip_address INET DEFAULT NULL
)
RETURNS UUID AS $$
DECLARE
  v_auditoria_id UUID;
  v_permiso_id UUID;
BEGIN
  -- Obtener el ID del permiso correspondiente
  SELECT id INTO v_permiso_id
  FROM permisos_expediente_familiar
  WHERE id_administrador = p_id_administrador
    AND id_paciente_vinculado = p_id_paciente
    AND activo = true
    AND fecha_otorgamiento <= NOW()
    AND (fecha_vencimiento IS NULL OR fecha_vencimiento > NOW())
  LIMIT 1;

  -- Registrar en auditoría
  INSERT INTO auditoria_acciones_familiares (
    id_administrador,
    id_paciente_afectado,
    id_permiso,
    tipo_accion,
    tabla_modificada,
    descripcion,
    valores_antes,
    valores_despues,
    ip_address,
    cumple_nom_024
  ) VALUES (
    p_id_administrador,
    p_id_paciente,
    v_permiso_id,
    p_tipo_accion,
    p_tabla_modificada,
    p_descripcion,
    p_valores_antes,
    p_valores_despues,
    p_ip_address,
    true
  ) RETURNING id INTO v_auditoria_id;

  RETURN v_auditoria_id;
END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- 8. TRIGGER: trigger_auditoria_acciones_familiares
-- ============================================================================
-- Se ejecuta cuando se realiza una acción sobre expedientes bajo permiso familiar

CREATE OR REPLACE FUNCTION fn_trigger_auditoria_familia()
RETURNS TRIGGER AS $$
DECLARE
  v_admin_id UUID;
  v_paciente_id UUID;
BEGIN
  -- Determinar tipo de acción
  CASE TG_OP
    WHEN 'INSERT' THEN
      -- Registrar creación
      PERFORM registrar_accion_familiar(
        v_admin_id,
        v_paciente_id,
        'INSERT',
        TG_TABLE_NAME,
        'Se agregó nuevo registro',
        NULL,
        to_jsonb(NEW)
      );
      RETURN NEW;
    WHEN 'UPDATE' THEN
      -- Registrar modificación
      PERFORM registrar_accion_familiar(
        v_admin_id,
        v_paciente_id,
        'UPDATE',
        TG_TABLE_NAME,
        'Se modificó registro',
        to_jsonb(OLD),
        to_jsonb(NEW)
      );
      RETURN NEW;
    WHEN 'DELETE' THEN
      -- Registrar eliminación
      PERFORM registrar_accion_familiar(
        v_admin_id,
        v_paciente_id,
        'DELETE',
        TG_TABLE_NAME,
        'Se eliminó registro',
        to_jsonb(OLD),
        NULL
      );
      RETURN OLD;
  END CASE;
END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- 9. VISTAS para consultas comunes
-- ============================================================================

-- Vista: Administradores y sus familiares
CREATE OR REPLACE VIEW vw_administradores_familiares AS
SELECT
  pa.id,
  pa.nombre || ' ' || pa.apellido_paterno as nombre_administrador,
  pa.email,
  COUNT(DISTINCT pef.id_paciente_vinculado) as cantidad_familiares,
  MAX(pef.updated_at) as ultima_actualizacion
FROM perfiles_pacientes pa
LEFT JOIN permisos_expediente_familiar pef ON pa.id = pef.id_administrador
WHERE pef.id IS NOT NULL
  AND pef.activo = true
GROUP BY pa.id, pa.nombre, pa.apellido_paterno, pa.email;

-- Vista: Expedientes bajo administración familiar
CREATE OR REPLACE VIEW vw_expedientes_familiares AS
SELECT
  pef.id,
  pa.nombre || ' ' || pa.apellido_paterno as nombre_administrador,
  pp.nombre || ' ' || pp.apellido_paterno as nombre_paciente,
  crf.nombre as tipo_relacion,
  pef.puede_ver_expediente,
  pef.puede_editar_datos_paciente,
  pef.puede_gestionar_citas,
  pef.puede_gestionar_medicamentos,
  pef.puede_autorizar_procedimientos,
  pef.activo,
  pef.fecha_otorgamiento,
  pef.fecha_vencimiento,
  CASE
    WHEN pef.fecha_vencimiento IS NULL THEN 'Sin vencimiento'
    WHEN pef.fecha_vencimiento > NOW() THEN 'Activo'
    ELSE 'Vencido'
  END as estado_permiso
FROM permisos_expediente_familiar pef
JOIN perfiles_pacientes pa ON pef.id_administrador = pa.id
JOIN perfiles_pacientes pp ON pef.id_paciente_vinculado = pp.id
LEFT JOIN cat_relaciones_familiares crf ON pef.relacion_familiar_id = crf.id
ORDER BY pa.nombre, pp.nombre;

-- Vista: Acciones recientes de administradores familiares
CREATE OR REPLACE VIEW vw_auditoria_acciones_familiares_recientes AS
SELECT
  aaf.id,
  pa.nombre || ' ' || pa.apellido_paterno as administrador,
  pp.nombre || ' ' || pp.apellido_paterno as paciente_afectado,
  aaf.tipo_accion,
  aaf.tabla_modificada,
  aaf.descripcion,
  aaf.fecha_evento,
  aaf.ip_address
FROM auditoria_acciones_familiares aaf
LEFT JOIN perfiles_pacientes pa ON aaf.id_administrador = pa.id
LEFT JOIN perfiles_pacientes pp ON aaf.id_paciente_afectado = pp.id
ORDER BY aaf.fecha_evento DESC
LIMIT 500;

-- ============================================================================
-- 10. POLÍTICAS RLS para Módulo Familiar
-- ============================================================================

-- Permitir que un administrador vea sus propios permisos
CREATE POLICY "admin_familiar_ver_propios_permisos" ON permisos_expediente_familiar
  FOR SELECT
  USING (id_administrador = auth.uid() OR id_paciente_vinculado = auth.uid());

-- Permitir que un administrador actualice sus propios permisos (solo ciertos campos)
CREATE POLICY "admin_familiar_actualizar_permisos" ON permisos_expediente_familiar
  FOR UPDATE
  USING (id_administrador = auth.uid())
  WITH CHECK (id_administrador = auth.uid());

-- Permitir que un paciente revoke permisos de administrador
CREATE POLICY "paciente_revocar_permisos_admin" ON permisos_expediente_familiar
  FOR UPDATE
  USING (id_paciente_vinculado = auth.uid())
  WITH CHECK (id_paciente_vinculado = auth.uid());

-- Permitir que un administrador vea expedientes de sus familiares
ALTER TABLE perfiles_pacientes ENABLE ROW LEVEL SECURITY;

CREATE POLICY "admin_familiar_ver_expediente" ON perfiles_pacientes
  FOR SELECT
  USING (
    id = auth.uid() OR
    verificar_permiso_familiar(auth.uid(), id, 'ver_expediente')
  );

-- Permitir que un administrador edite datos de sus familiares (si tiene permiso)
CREATE POLICY "admin_familiar_editar_datos" ON perfiles_pacientes
  FOR UPDATE
  USING (
    id = auth.uid() OR
    verificar_permiso_familiar(auth.uid(), id, 'editar_datos')
  )
  WITH CHECK (
    id = auth.uid() OR
    verificar_permiso_familiar(auth.uid(), id, 'editar_datos')
  );

-- ============================================================================
-- 11. DATOS DE EJEMPLO (OPCIONAL)
-- ============================================================================
-- Descomentar para agregar datos de prueba

/*
-- Crear algunos perfiles de ejemplo
INSERT INTO perfiles_pacientes (nombre, apellido_paterno, apellido_materno, email, telefono)
VALUES
  ('María', 'García', 'López', 'maria@example.com', '5551234567'),
  ('Juan', 'García', 'López', 'juan@example.com', '5559876543'),
  ('Carlos', 'García', 'López', 'carlos@example.com', '5555555555');

-- Crear relaciones familiares
INSERT INTO relaciones_familiares (id_persona_primaria, id_persona_secundaria, relacion_id)
VALUES
  (
    (SELECT id FROM perfiles_pacientes WHERE email = 'maria@example.com'),
    (SELECT id FROM perfiles_pacientes WHERE email = 'juan@example.com'),
    (SELECT id FROM cat_relaciones_familiares WHERE codigo = 'madre')
  );

-- Otorgar permisos a María para administrar a Juan
INSERT INTO permisos_expediente_familiar (
  id_administrador,
  id_paciente_vinculado,
  relacion_familiar_id,
  puede_ver_expediente,
  puede_editar_datos_paciente,
  puede_gestionar_citas,
  puede_gestionar_medicamentos,
  razon
)
VALUES (
  (SELECT id FROM perfiles_pacientes WHERE email = 'maria@example.com'),
  (SELECT id FROM perfiles_pacientes WHERE email = 'juan@example.com'),
  (SELECT id FROM cat_relaciones_familiares WHERE codigo = 'madre'),
  true,
  true,
  true,
  true,
  'Madre autorizada para administrar expediente del hijo'
);
*/

-- ============================================================================
-- FIN DE SCRIPT
-- ============================================================================
-- RESUMEN DE CAMBIOS:
-- 1. ✅ Tabla: cat_relaciones_familiares (catálogo de relaciones)
-- 2. ✅ Tabla: relaciones_familiares (instancias de relaciones entre personas)
-- 3. ✅ Tabla: permisos_expediente_familiar (permisos granulares)
-- 4. ✅ Tabla: auditoria_acciones_familiares (auditoría NOM-024)
-- 5. ✅ Función: verificar_permiso_familiar()
-- 6. ✅ Función: obtener_familiares_administrados()
-- 7. ✅ Función: registrar_accion_familiar()
-- 8. ✅ Vistas: vw_administradores_familiares, vw_expedientes_familiares
-- 9. ✅ RLS Policies: Para administradores y pacientes
-- 10. ✅ Datos de ejemplo (comentados)
-- ============================================================================
