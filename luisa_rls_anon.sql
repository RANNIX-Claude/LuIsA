-- Políticas de lectura para anon (demo con sesión custom en localStorage)
-- El app usa custom auth, no Supabase Auth, así que auth.uid() = null siempre

-- medicos: SELECT abierto para anon
DROP POLICY IF EXISTS rls_medico_anon_select ON medicos;
CREATE POLICY rls_medico_anon_select ON medicos FOR SELECT TO anon USING (true);

-- perfiles_pacientes: SELECT abierto para anon
DROP POLICY IF EXISTS rls_paciente_anon_select ON perfiles_pacientes;
CREATE POLICY rls_paciente_anon_select ON perfiles_pacientes FOR SELECT TO anon USING (true);

-- citas: SELECT abierto para anon
DROP POLICY IF EXISTS rls_citas_anon_select ON citas;
CREATE POLICY rls_citas_anon_select ON citas FOR SELECT TO anon USING (true);

-- citas: INSERT/UPDATE para anon
DROP POLICY IF EXISTS rls_citas_anon_write ON citas;
CREATE POLICY rls_citas_anon_write ON citas FOR ALL TO anon USING (true) WITH CHECK (true);

-- notas_evolucion: acceso anon completo
DROP POLICY IF EXISTS rls_notas_anon ON notas_evolucion;
CREATE POLICY rls_notas_anon ON notas_evolucion FOR ALL TO anon USING (true) WITH CHECK (true);

-- doctor_patient_relationships: SELECT anon
DROP POLICY IF EXISTS rls_dpr_anon ON doctor_patient_relationships;
CREATE POLICY rls_dpr_anon ON doctor_patient_relationships FOR SELECT TO anon USING (true);

-- medicamentos_paciente: acceso anon
DROP POLICY IF EXISTS rls_meds_anon ON medicamentos_paciente;
CREATE POLICY rls_meds_anon ON medicamentos_paciente FOR ALL TO anon USING (true) WITH CHECK (true);

-- historias_clinicas: acceso anon
DROP POLICY IF EXISTS rls_hc_anon ON historias_clinicas;
CREATE POLICY rls_hc_anon ON historias_clinicas FOR ALL TO anon USING (true) WITH CHECK (true);

-- vacunas_paciente: acceso anon
DROP POLICY IF EXISTS rls_vac_anon ON vacunas_paciente;
CREATE POLICY rls_vac_anon ON vacunas_paciente FOR ALL TO anon USING (true) WITH CHECK (true);

-- diario_eventos: acceso anon
DROP POLICY IF EXISTS rls_dev_anon ON diario_eventos;
CREATE POLICY rls_dev_anon ON diario_eventos FOR ALL TO anon USING (true) WITH CHECK (true);

-- usuarios_luisa: SELECT anon
DROP POLICY IF EXISTS rls_usr_anon ON usuarios_luisa;
CREATE POLICY rls_usr_anon ON usuarios_luisa FOR SELECT TO anon USING (true);

-- firma_electronica: acceso anon
DROP POLICY IF EXISTS rls_firma_anon ON firma_electronica;
CREATE POLICY rls_firma_anon ON firma_electronica FOR ALL TO anon USING (true) WITH CHECK (true);