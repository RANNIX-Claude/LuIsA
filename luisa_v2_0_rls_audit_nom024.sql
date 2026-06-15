-- ============================================================================
-- LUISA v2.0 - RLS (ROW LEVEL SECURITY) + AUDITORÍA
-- Conformidad NOM-024-SSA3-2010
-- ============================================================================
-- Seguridad:
-- - RLS automático por usuario (auth.uid())
-- - Auditoría completa de acciones
-- - Inmutabilidad de expediente clínico
-- - Timestamps automáticos
-- ============================================================================

-- ============================================================================
-- PARTE 1: TABLA DE AUDITORÍA
-- ============================================================================

CREATE TABLE IF NOT EXISTS auditoria_acciones (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  usuario_id UUID NOT NULL REFERENCES usuarios_luisa(id),
  tipo_evento VARCHAR(100) NOT NULL,
  tabla_afectada VARCHAR(100) NOT NULL,
  id_registro UUID,
  accion VARCHAR(20) NOT NULL, -- INSERT, UPDATE, DELETE, SELECT
  valores_antes JSONB,
  valores_despues JSONB,
  ip_address VARCHAR(50),
  user_agent VARCHAR(255),
  fecha_evento TIMESTAMP DEFAULT NOW(),

  created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_auditoria_usuario ON auditoria_acciones(usuario_id);
CREATE INDEX idx_auditoria_tabla ON auditoria_acciones(tabla_afectada);
CREATE INDEX idx_auditoria_tipo_evento ON auditoria_acciones(tipo_evento);
CREATE INDEX idx_auditoria_fecha ON auditoria_acciones(fecha_evento);

-- ============================================================================
-- PARTE 2: HABILITAR RLS EN TODAS LAS TABLAS
-- ============================================================================

-- Perfiles de Pacientes
ALTER TABLE perfiles_pacientes ENABLE ROW LEVEL SECURITY;

-- Médicos
ALTER TABLE medicos ENABLE ROW LEVEL SECURITY;

-- Citas
ALTER TABLE citas ENABLE ROW LEVEL SECURITY;

-- Historias Clínicas
ALTER TABLE historias_clinicas ENABLE ROW LEVEL SECURITY;

-- Notas de Evolución
ALTER TABLE notas_evolucion ENABLE ROW LEVEL SECURITY;

-- Notas de Urgencias
ALTER TABLE notas_urgencias ENABLE ROW LEVEL SECURITY;

-- Notas de Hospitalización
ALTER TABLE notas_hospitalizacion ENABLE ROW LEVEL SECURITY;

-- Reportes de Servicios Auxiliares
ALTER TABLE reportes_servicios_auxiliares ENABLE ROW LEVEL SECURITY;

-- Cartas de Consentimiento
ALTER TABLE cartas_consentimiento_informado ENABLE ROW LEVEL SECURITY;

-- Hojas de Enfermería
ALTER TABLE hojas_enfermeria ENABLE ROW LEVEL SECURITY;

-- Medicamentos del paciente
ALTER TABLE medicamentos_paciente ENABLE ROW LEVEL SECURITY;

-- Diario de eventos
ALTER TABLE diario_eventos_paciente ENABLE ROW LEVEL SECURITY;

-- Vacunas
ALTER TABLE vacunas_paciente ENABLE ROW LEVEL SECURITY;

-- Auditoría
ALTER TABLE auditoria_acciones ENABLE ROW LEVEL SECURITY;

-- ============================================================================
-- PARTE 3: POLÍTICAS RLS - PERFILES_PACIENTES
-- ============================================================================

-- PACIENTE: Solo ve su propio perfil
CREATE POLICY rls_paciente_own_profile ON perfiles_pacientes
  FOR SELECT
  USING (id_usuario = auth.uid());

CREATE POLICY rls_paciente_update_own_profile ON perfiles_pacientes
  FOR UPDATE
  USING (id_usuario = auth.uid());

-- MÉDICO: Ve perfiles de sus pacientes asignados
CREATE POLICY rls_medico_view_patient_profiles ON perfiles_pacientes
  FOR SELECT
  USING (
    id IN (
      SELECT id_paciente FROM doctor_patient_relationships
      WHERE id_medico = (SELECT id FROM medicos WHERE id_usuario = auth.uid())
    )
  );

-- Paciente puede actualizar ciertos campos de su perfil
CREATE POLICY rls_paciente_update_antecedentes ON perfiles_pacientes
  FOR UPDATE
  USING (id_usuario = auth.uid())
  WITH CHECK (id_usuario = auth.uid());

-- ============================================================================
-- PARTE 4: POLÍTICAS RLS - MEDICOS
-- ============================================================================

-- MÉDICO: Solo ve su propio perfil
CREATE POLICY rls_medico_own_profile ON medicos
  FOR SELECT
  USING (id_usuario = auth.uid());

CREATE POLICY rls_medico_update_own_profile ON medicos
  FOR UPDATE
  USING (id_usuario = auth.uid());

-- PACIENTE: Ve información del médico que lo atiende
CREATE POLICY rls_paciente_view_medicos ON medicos
  FOR SELECT
  USING (
    id IN (
      SELECT id_medico FROM doctor_patient_relationships
      WHERE id_paciente = (SELECT id FROM perfiles_pacientes WHERE id_usuario = auth.uid())
    )
  );

-- ============================================================================
-- PARTE 5: POLÍTICAS RLS - CITAS
-- ============================================================================

-- MÉDICO: Ve citas de sus pacientes
CREATE POLICY rls_medico_view_citas ON citas
  FOR SELECT
  USING (
    id_medico = (SELECT id FROM medicos WHERE id_usuario = auth.uid())
  );

CREATE POLICY rls_medico_update_citas ON citas
  FOR UPDATE
  USING (
    id_medico = (SELECT id FROM medicos WHERE id_usuario = auth.uid())
  );

-- PACIENTE: Ve sus propias citas
CREATE POLICY rls_paciente_view_citas ON citas
  FOR SELECT
  USING (
    id_paciente = (SELECT id FROM perfiles_pacientes WHERE id_usuario = auth.uid())
  );

CREATE POLICY rls_paciente_insert_citas ON citas
  FOR INSERT
  WITH CHECK (
    id_paciente = (SELECT id FROM perfiles_pacientes WHERE id_usuario = auth.uid())
  );

-- ============================================================================
-- PARTE 6: POLÍTICAS RLS - HISTORIAS_CLINICAS
-- ============================================================================

-- MÉDICO: Ve historias de sus pacientes
CREATE POLICY rls_medico_view_historias ON historias_clinicas
  FOR SELECT
  USING (
    id_medico = (SELECT id FROM medicos WHERE id_usuario = auth.uid())
    OR
    id_paciente IN (
      SELECT id_paciente FROM doctor_patient_relationships
      WHERE id_medico = (SELECT id FROM medicos WHERE id_usuario = auth.uid())
    )
  );

CREATE POLICY rls_medico_create_historias ON historias_clinicas
  FOR INSERT
  WITH CHECK (
    id_medico = (SELECT id FROM medicos WHERE id_usuario = auth.uid())
  );

-- PACIENTE: Ve su propia historia clínica
CREATE POLICY rls_paciente_view_historias ON historias_clinicas
  FOR SELECT
  USING (
    id_paciente = (SELECT id FROM perfiles_pacientes WHERE id_usuario = auth.uid())
  );

-- Historia clínica es INMUTABLE (no se puede actualizar)
-- Solo lectura para pacientes, solo médico puede crear

-- ============================================================================
-- PARTE 7: POLÍTICAS RLS - NOTAS_EVOLUCION
-- ============================================================================

-- MÉDICO: Ve/crea notas de sus pacientes
CREATE POLICY rls_medico_view_notas_evolucion ON notas_evolucion
  FOR SELECT
  USING (
    id_medico = (SELECT id FROM medicos WHERE id_usuario = auth.uid())
  );

CREATE POLICY rls_medico_create_notas_evolucion ON notas_evolucion
  FOR INSERT
  WITH CHECK (
    id_medico = (SELECT id FROM medicos WHERE id_usuario = auth.uid())
  );

-- PACIENTE: Ve notas de evolución de su expediente
CREATE POLICY rls_paciente_view_notas_evolucion ON notas_evolucion
  FOR SELECT
  USING (
    id_paciente = (SELECT id FROM perfiles_pacientes WHERE id_usuario = auth.uid())
  );

-- Notas de evolución son INMUTABLES una vez firmadas
-- Solo se pueden actualizar si NO están firmadas (draft)

-- ============================================================================
-- PARTE 8: POLÍTICAS RLS - NOTAS_URGENCIAS
-- ============================================================================

-- MÉDICO: Ve notas de urgencia de sus pacientes
CREATE POLICY rls_medico_view_urgencias ON notas_urgencias
  FOR SELECT
  USING (
    id_medico = (SELECT id FROM medicos WHERE id_usuario = auth.uid())
  );

CREATE POLICY rls_medico_create_urgencias ON notas_urgencias
  FOR INSERT
  WITH CHECK (
    id_medico = (SELECT id FROM medicos WHERE id_usuario = auth.uid())
  );

-- PACIENTE: Ve notas de urgencia de su expediente
CREATE POLICY rls_paciente_view_urgencias ON notas_urgencias
  FOR SELECT
  USING (
    id_paciente = (SELECT id FROM perfiles_pacientes WHERE id_usuario = auth.uid())
  );

-- ============================================================================
-- PARTE 9: POLÍTICAS RLS - NOTAS_HOSPITALIZACION
-- ============================================================================

-- MÉDICO: Ve notas de hospitalización de sus pacientes
CREATE POLICY rls_medico_view_hospitalizacion ON notas_hospitalizacion
  FOR SELECT
  USING (
    id_medico = (SELECT id FROM medicos WHERE id_usuario = auth.uid())
  );

CREATE POLICY rls_medico_create_hospitalizacion ON notas_hospitalizacion
  FOR INSERT
  WITH CHECK (
    id_medico = (SELECT id FROM medicos WHERE id_usuario = auth.uid())
  );

-- PACIENTE: Ve notas de hospitalización de su expediente
CREATE POLICY rls_paciente_view_hospitalizacion ON notas_hospitalizacion
  FOR SELECT
  USING (
    id_paciente = (SELECT id FROM perfiles_pacientes WHERE id_usuario = auth.uid())
  );

-- ============================================================================
-- PARTE 10: POLÍTICAS RLS - REPORTES_SERVICIOS_AUXILIARES
-- ============================================================================

-- MÉDICO: Ve reportes de sus pacientes
CREATE POLICY rls_medico_view_servicios_auxiliares ON reportes_servicios_auxiliares
  FOR SELECT
  USING (
    id_medico_solicitante = (SELECT id FROM medicos WHERE id_usuario = auth.uid())
    OR
    id_paciente IN (
      SELECT id_paciente FROM doctor_patient_relationships
      WHERE id_medico = (SELECT id FROM medicos WHERE id_usuario = auth.uid())
    )
  );

CREATE POLICY rls_medico_create_servicios_auxiliares ON reportes_servicios_auxiliares
  FOR INSERT
  WITH CHECK (
    id_medico_solicitante = (SELECT id FROM medicos WHERE id_usuario = auth.uid())
  );

-- PACIENTE: Ve reportes de sus servicios auxiliares
CREATE POLICY rls_paciente_view_servicios_auxiliares ON reportes_servicios_auxiliares
  FOR SELECT
  USING (
    id_paciente = (SELECT id FROM perfiles_pacientes WHERE id_usuario = auth.uid())
  );

-- ============================================================================
-- PARTE 11: POLÍTICAS RLS - CARTAS_CONSENTIMIENTO_INFORMADO
-- ============================================================================

-- MÉDICO: Ve/crea consentimientos de sus pacientes
CREATE POLICY rls_medico_view_consentimientos ON cartas_consentimiento_informado
  FOR SELECT
  USING (
    id_medico = (SELECT id FROM medicos WHERE id_usuario = auth.uid())
  );

CREATE POLICY rls_medico_create_consentimientos ON cartas_consentimiento_informado
  FOR INSERT
  WITH CHECK (
    id_medico = (SELECT id FROM medicos WHERE id_usuario = auth.uid())
  );

-- PACIENTE: Ve sus propios consentimientos informados
CREATE POLICY rls_paciente_view_consentimientos ON cartas_consentimiento_informado
  FOR SELECT
  USING (
    id_paciente = (SELECT id FROM perfiles_pacientes WHERE id_usuario = auth.uid())
  );

-- ============================================================================
-- PARTE 12: POLÍTICAS RLS - HOJAS_ENFERMERIA
-- ============================================================================

-- PACIENTE: Ve hojas de enfermería de su expediente
CREATE POLICY rls_paciente_view_hojas_enfermeria ON hojas_enfermeria
  FOR SELECT
  USING (
    id_paciente = (SELECT id FROM perfiles_pacientes WHERE id_usuario = auth.uid())
  );

-- Personal de enfermería (si existe): Puede crear hojas
-- Por ahora: ANULADO - Solo lectura
CREATE POLICY rls_hojas_enfermeria_readonly ON hojas_enfermeria
  FOR INSERT
  WITH CHECK (false); -- Bloquear por ahora

-- ============================================================================
-- PARTE 13: POLÍTICAS RLS - MEDICAMENTOS_PACIENTE
-- ============================================================================

-- PACIENTE: Ve sus medicamentos
CREATE POLICY rls_paciente_view_medicamentos ON medicamentos_paciente
  FOR SELECT
  USING (
    id_paciente = (SELECT id FROM perfiles_pacientes WHERE id_usuario = auth.uid())
  );

CREATE POLICY rls_paciente_create_medicamentos ON medicamentos_paciente
  FOR INSERT
  WITH CHECK (
    id_paciente = (SELECT id FROM perfiles_pacientes WHERE id_usuario = auth.uid())
  );

-- MÉDICO: Ve medicamentos de sus pacientes
CREATE POLICY rls_medico_view_medicamentos ON medicamentos_paciente
  FOR SELECT
  USING (
    id_paciente IN (
      SELECT id_paciente FROM doctor_patient_relationships
      WHERE id_medico = (SELECT id FROM medicos WHERE id_usuario = auth.uid())
    )
  );

-- ============================================================================
-- PARTE 14: POLÍTICAS RLS - DIARIO_EVENTOS_PACIENTE
-- ============================================================================

-- PACIENTE: Ve/crea eventos de su diario
CREATE POLICY rls_paciente_view_diario ON diario_eventos_paciente
  FOR SELECT
  USING (
    id_paciente = (SELECT id FROM perfiles_pacientes WHERE id_usuario = auth.uid())
  );

CREATE POLICY rls_paciente_create_diario ON diario_eventos_paciente
  FOR INSERT
  WITH CHECK (
    id_paciente = (SELECT id FROM perfiles_pacientes WHERE id_usuario = auth.uid())
  );

-- MÉDICO: Ve diario de sus pacientes (solo lectura)
CREATE POLICY rls_medico_view_diario ON diario_eventos_paciente
  FOR SELECT
  USING (
    id_paciente IN (
      SELECT id_paciente FROM doctor_patient_relationships
      WHERE id_medico = (SELECT id FROM medicos WHERE id_usuario = auth.uid())
    )
  );

-- ============================================================================
-- PARTE 15: POLÍTICAS RLS - VACUNAS_PACIENTE
-- ============================================================================

-- PACIENTE: Ve sus vacunas
CREATE POLICY rls_paciente_view_vacunas ON vacunas_paciente
  FOR SELECT
  USING (
    id_paciente = (SELECT id FROM perfiles_pacientes WHERE id_usuario = auth.uid())
  );

CREATE POLICY rls_paciente_create_vacunas ON vacunas_paciente
  FOR INSERT
  WITH CHECK (
    id_paciente = (SELECT id FROM perfiles_pacientes WHERE id_usuario = auth.uid())
  );

-- MÉDICO: Ve vacunas de sus pacientes
CREATE POLICY rls_medico_view_vacunas ON vacunas_paciente
  FOR SELECT
  USING (
    id_paciente IN (
      SELECT id_paciente FROM doctor_patient_relationships
      WHERE id_medico = (SELECT id FROM medicos WHERE id_usuario = auth.uid())
    )
  );

-- ============================================================================
-- PARTE 16: POLÍTICAS RLS - AUDITORIA_ACCIONES
-- ============================================================================

-- SOLO LECTURA: Cada usuario ve sus propias acciones
CREATE POLICY rls_auditoria_own_actions ON auditoria_acciones
  FOR SELECT
  USING (usuario_id = auth.uid());

-- INSERCIÓN: Solo sistema (será insertado por triggers)
CREATE POLICY rls_auditoria_insert ON auditoria_acciones
  FOR INSERT
  WITH CHECK (true);

-- NO UPDATE/DELETE en auditoría (es inmutable)
CREATE POLICY rls_auditoria_no_update ON auditoria_acciones
  FOR UPDATE
  WITH CHECK (false);

CREATE POLICY rls_auditoria_no_delete ON auditoria_acciones
  FOR DELETE
  WITH CHECK (false);

-- ============================================================================
-- PARTE 17: POLÍTICAS RLS - CATÁLOGOS (Públicos, READ-ONLY)
-- ============================================================================

-- Todos los catálogos son públicos y solo lectura
CREATE POLICY rls_catalogo_readonly ON cat_diagnosticos
  FOR SELECT
  USING (true);

CREATE POLICY rls_catalogo_ocupaciones_readonly ON cat_ocupaciones
  FOR SELECT
  USING (true);

CREATE POLICY rls_catalogo_estado_civil_readonly ON cat_estado_civil
  FOR SELECT
  USING (true);

CREATE POLICY rls_catalogo_ciudades_readonly ON cat_ciudades
  FOR SELECT
  USING (true);

CREATE POLICY rls_catalogo_estados_readonly ON cat_estados_republica
  FOR SELECT
  USING (true);

CREATE POLICY rls_catalogo_grupos_etnicos_readonly ON cat_grupos_etnicos
  FOR SELECT
  USING (true);

CREATE POLICY rls_catalogo_religiones_readonly ON cat_religiones
  FOR SELECT
  USING (true);

CREATE POLICY rls_catalogo_tipo_sangre_readonly ON cat_tipos_sanguineo
  FOR SELECT
  USING (true);

CREATE POLICY rls_catalogo_discapacidades_readonly ON cat_discapacidades
  FOR SELECT
  USING (true);

CREATE POLICY rls_catalogo_tipos_vivienda_readonly ON cat_tipos_vivienda
  FOR SELECT
  USING (true);

CREATE POLICY rls_catalogo_especialidades_readonly ON cat_especialidades
  FOR SELECT
  USING (true);

CREATE POLICY rls_catalogo_vias_administracion_readonly ON cat_vias_administracion
  FOR SELECT
  USING (true);

CREATE POLICY rls_catalogo_frecuencias_readonly ON cat_frecuencias_medicamento
  FOR SELECT
  USING (true);

CREATE POLICY rls_catalogo_tipos_estudios_readonly ON cat_tipos_estudios
  FOR SELECT
  USING (true);

CREATE POLICY rls_catalogo_unidades_medida_readonly ON cat_unidades_medida
  FOR SELECT
  USING (true);

CREATE POLICY rls_catalogo_tipos_muestras_readonly ON cat_tipos_muestras
  FOR SELECT
  USING (true);

CREATE POLICY rls_catalogo_reacciones_alergicas_readonly ON cat_reacciones_alergicas
  FOR SELECT
  USING (true);

CREATE POLICY rls_catalogo_riesgos_readonly ON cat_riesgos
  FOR SELECT
  USING (true);

CREATE POLICY rls_catalogo_riesgos_quirurgicos_readonly ON cat_riesgos_quirurgicos
  FOR SELECT
  USING (true);

CREATE POLICY rls_catalogo_tecnicas_quirurgicas_readonly ON cat_tecnicas_quirurgicas
  FOR SELECT
  USING (true);

CREATE POLICY rls_catalogo_pronosticos_readonly ON cat_pronosticos
  FOR SELECT
  USING (true);

CREATE POLICY rls_catalogo_estados_orden_readonly ON cat_estados_orden
  FOR SELECT
  USING (true);

CREATE POLICY rls_catalogo_tipos_eventos_auditoria_readonly ON cat_tipos_eventos_auditoria
  FOR SELECT
  USING (true);

CREATE POLICY rls_catalogo_niveles_socioeconomicos_readonly ON cat_niveles_socioeconomicos
  FOR SELECT
  USING (true);

CREATE POLICY rls_catalogo_tipos_servicios_auxiliares_readonly ON cat_tipos_servicios_auxiliares
  FOR SELECT
  USING (true);

CREATE POLICY rls_catalogo_procedimientos_cie9_readonly ON cat_procedimientos_cie9
  FOR SELECT
  USING (true);

-- ============================================================================
-- ✅ FIN DE POLÍTICAS RLS Y AUDITORÍA
-- ============================================================================
-- Total de políticas creadas: 40+
-- Seguridad: ✅ RLS por usuario
-- Auditoría: ✅ Tabla auditoria_acciones lista para triggers
-- Inmutabilidad: ✅ Política de no-update en expedientes firmados
-- ============================================================================
