-- RLS LUISA v2.0

ALTER TABLE perfiles_pacientes ENABLE ROW LEVEL SECURITY;
ALTER TABLE medicos ENABLE ROW LEVEL SECURITY;
ALTER TABLE citas ENABLE ROW LEVEL SECURITY;
ALTER TABLE historias_clinicas ENABLE ROW LEVEL SECURITY;
ALTER TABLE notas_evolucion ENABLE ROW LEVEL SECURITY;
ALTER TABLE medicamentos_paciente ENABLE ROW LEVEL SECURITY;
ALTER TABLE diario_eventos ENABLE ROW LEVEL SECURITY;
ALTER TABLE vacunas_paciente ENABLE ROW LEVEL SECURITY;
ALTER TABLE auditoria_acciones ENABLE ROW LEVEL SECURITY;
ALTER TABLE doctor_patient_relationships ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS rls_paciente_own ON perfiles_pacientes;
CREATE POLICY rls_paciente_own ON perfiles_pacientes FOR SELECT USING (id_usuario = auth.uid());
DROP POLICY IF EXISTS rls_paciente_update ON perfiles_pacientes;
CREATE POLICY rls_paciente_update ON perfiles_pacientes FOR UPDATE USING (id_usuario = auth.uid());

DROP POLICY IF EXISTS rls_medico_own ON medicos;
CREATE POLICY rls_medico_own ON medicos FOR SELECT USING (id_usuario = auth.uid());
DROP POLICY IF EXISTS rls_medico_update ON medicos;
CREATE POLICY rls_medico_update ON medicos FOR UPDATE USING (id_usuario = auth.uid());

DROP POLICY IF EXISTS rls_citas_medico ON citas;
CREATE POLICY rls_citas_medico ON citas FOR ALL USING (id_medico IN (SELECT id FROM medicos WHERE id_usuario = auth.uid()));
DROP POLICY IF EXISTS rls_citas_paciente ON citas;
CREATE POLICY rls_citas_paciente ON citas FOR SELECT USING (id_paciente IN (SELECT id FROM perfiles_pacientes WHERE id_usuario = auth.uid()));

DROP POLICY IF EXISTS rls_historias_medico ON historias_clinicas;
CREATE POLICY rls_historias_medico ON historias_clinicas FOR ALL USING (id_medico IN (SELECT id FROM medicos WHERE id_usuario = auth.uid()));
DROP POLICY IF EXISTS rls_historias_paciente ON historias_clinicas;
CREATE POLICY rls_historias_paciente ON historias_clinicas FOR SELECT USING (id_paciente IN (SELECT id FROM perfiles_pacientes WHERE id_usuario = auth.uid()));

DROP POLICY IF EXISTS rls_medicamentos_paciente ON medicamentos_paciente;
CREATE POLICY rls_medicamentos_paciente ON medicamentos_paciente FOR ALL USING (id_paciente IN (SELECT id FROM perfiles_pacientes WHERE id_usuario = auth.uid()));

DROP POLICY IF EXISTS rls_diario_paciente ON diario_eventos;
CREATE POLICY rls_diario_paciente ON diario_eventos FOR ALL USING (id_paciente IN (SELECT id FROM perfiles_pacientes WHERE id_usuario = auth.uid()));

DROP POLICY IF EXISTS rls_vacunas_paciente ON vacunas_paciente;
CREATE POLICY rls_vacunas_paciente ON vacunas_paciente FOR ALL USING (id_paciente IN (SELECT id FROM perfiles_pacientes WHERE id_usuario = auth.uid()));

DROP POLICY IF EXISTS rls_auditoria_own ON auditoria_acciones;
CREATE POLICY rls_auditoria_own ON auditoria_acciones FOR SELECT USING (id_usuario = auth.uid());

DROP POLICY IF EXISTS rls_dpr_medico ON doctor_patient_relationships;
CREATE POLICY rls_dpr_medico ON doctor_patient_relationships FOR ALL USING (id_medico IN (SELECT id FROM medicos WHERE id_usuario = auth.uid()));