-- ============================================================================
-- LIGIA v2.0 - SEED DATA: ESTUDIOS DE LABORATORIO E IMAGENOLOGÍA
-- ============================================================================
-- Script para cargar reportes de laboratorio, estudios de imagen y análisis clínicos
-- Total estimado: 150-200 reportes
-- Ejecutar DESPUÉS de cargar pacientes, médicos y consultas
-- ============================================================================

-- ESTUDIOS DE LABORATORIO PARA PACIENTES CON PATOLOGÍAS

INSERT INTO reportes_servicios_auxiliares (
  id,
  id_paciente,
  id_medico_solicitante,
  tipo_servicio_id,
  estudio_solicitado,
  fecha_solicitud,
  problema_clinico_en_estudio,
  fecha_realizacion,
  fecha_resultado,
  resultados,
  resultados_json,
  personal_realiza,
  personal_informa,
  firma_electronica,
  created_at
) VALUES

-- LABORATORIO: Paciente EXP-00001 (Juan Pérez - Diabetes)
(gen_random_uuid(),
 (SELECT id FROM perfiles_pacientes WHERE numero_expediente = 'EXP-00001' LIMIT 1),
 (SELECT id FROM medicos WHERE cedula_profesional = 'MED-012-ENDO' LIMIT 1),
 (SELECT id FROM cat_tipos_servicios_auxiliares WHERE nombre = 'Laboratorio' LIMIT 1),
 'Glucosa Basal, Perfil Lipídico, Creatinina, HbA1c',
 '2026-05-10'::timestamp,
 'Diabetes Mellitus Tipo 2, control metabólico',
 '2026-05-10'::timestamp,
 '2026-05-10'::timestamp,
 'Glucosa: 145 mg/dL (elevada), Colesterol total: 218 mg/dL, LDL: 140 mg/dL, HDL: 35 mg/dL (bajo), Triglicéridos: 180 mg/dL, Creatinina: 0.9 mg/dL, HbA1c: 7.2%',
 '{"glucosa": 145, "unidad_glucosa": "mg/dL", "colesterol_total": 218, "ldl": 140, "hdl": 35, "trigliceridos": 180, "creatinina": 0.9, "hba1c": 7.2}'::jsonb,
 'Laboratorista: Ing. José María Rodríguez',
 'Dr. Endocrinólogo: Dra. Beatriz Núñez',
 true,
 NOW()
),

-- LABORATORIO: Paciente EXP-00002 (María López - Hipertensión)
(gen_random_uuid(),
 (SELECT id FROM perfiles_pacientes WHERE numero_expediente = 'EXP-00002' LIMIT 1),
 (SELECT id FROM medicos WHERE cedula_profesional = 'MED-001-CARD' LIMIT 1),
 (SELECT id FROM cat_tipos_servicios_auxiliares WHERE nombre = 'Laboratorio' LIMIT 1),
 'Electrolitos, Creatinina, Perfil hepático',
 '2026-05-08'::timestamp,
 'Hipertensión Arterial, vigilancia por medicamento',
 '2026-05-08'::timestamp,
 '2026-05-08'::timestamp,
 'Sodio: 138 mEq/L (normal), Potasio: 4.1 mEq/L (normal), Creatinina: 0.8 mg/dL (normal), ALT: 24 UI/L, AST: 28 UI/L, Bilirrubina total: 0.7 mg/dL',
 '{"sodio": 138, "potasio": 4.1, "creatinina": 0.8, "alt": 24, "ast": 28, "bilirrubina": 0.7}'::jsonb,
 'Laboratorista: Lic. Carmen Flores',
 'Dr. Cardiólogo: Dr. Carlos García',
 true,
 NOW()
),

-- LABORATORIO: Paciente EXP-00003 (Carlos Martínez - Post-infarto)
(gen_random_uuid(),
 (SELECT id FROM perfiles_pacientes WHERE numero_expediente = 'EXP-00003' LIMIT 1),
 (SELECT id FROM medicos WHERE cedula_profesional = 'MED-001-CARD' LIMIT 1),
 (SELECT id FROM cat_tipos_servicios_auxiliares WHERE nombre = 'Laboratorio' LIMIT 1),
 'Troponina I, Mioglobina, Enzimas cardíacas, Perfil lipídico',
 '2026-05-06'::timestamp,
 'Infarto de miocardio previo, vigilancia de marcadores cardíacos',
 '2026-05-06'::timestamp,
 '2026-05-06'::timestamp,
 'Troponina I: 0.02 ng/mL (normal), Mioglobina: 72 ng/mL, CK: 120 UI/L, LDH: 350 UI/L, Colesterol: 200 mg/dL, Triglicéridos: 150 mg/dL',
 '{"troponina_i": 0.02, "mioglobina": 72, "ck": 120, "ldh": 350, "colesterol": 200, "trigliceridos": 150}'::jsonb,
 'Laboratorista: Lic. Miguel Herrera',
 'Dr. Cardiólogo: Dr. Carlos García',
 true,
 NOW()
),

-- LABORATORIO: Paciente EXP-00004 (Ana Fernández - Revisión general)
(gen_random_uuid(),
 (SELECT id FROM perfiles_pacientes WHERE numero_expediente = 'EXP-00004' LIMIT 1),
 (SELECT id FROM medicos WHERE cedula_profesional = 'MED-015-MINT' LIMIT 1),
 (SELECT id FROM cat_tipos_servicios_auxiliares WHERE nombre = 'Laboratorio' LIMIT 1),
 'Biometría hemática completa, Química sanguínea',
 '2026-05-12'::timestamp,
 'Revisión anual de salud',
 '2026-05-12'::timestamp,
 '2026-05-12'::timestamp,
 'Hemoglobina: 13.5 g/dL (normal), Leucocitos: 7,200 /mm3 (normal), Plaquetas: 245,000 /mm3 (normal), Glucosa: 95 mg/dL, Creatinina: 0.7 mg/dL, Perfil hepático normal',
 '{"hemoglobina": 13.5, "leucocitos": 7200, "plaquetas": 245000, "glucosa": 95, "creatinina": 0.7, "estado": "sin hallazgos"}'::jsonb,
 'Laboratorista: Lic. Patricia Gómez',
 'Dr. Internista: Dr. Manuel Lopez',
 true,
 NOW()
),

-- LABORATORIO: Paciente EXP-00005 (Roberto Sánchez - Hipertensión + Tabaquismo)
(gen_random_uuid(),
 (SELECT id FROM perfiles_pacientes WHERE numero_expediente = 'EXP-00005' LIMIT 1),
 (SELECT id FROM medicos WHERE cedula_profesional = 'MED-010-PNEU' LIMIT 1),
 (SELECT id FROM cat_tipos_servicios_auxiliares WHERE nombre = 'Laboratorio' LIMIT 1),
 'Gasometría arterial, Carboxihemoglobina, Función pulmonar',
 '2026-05-09'::timestamp,
 'Fumador con posible afectación pulmonar',
 '2026-05-09'::timestamp,
 '2026-05-09'::timestamp,
 'pH: 7.38 (normal), PO2: 85 mmHg (bajo-normal), PCO2: 42 mmHg, Carboxihemoglobina: 8.5% (elevada por tabaquismo), Función pulmonar: CVF 85%, VEF1 80%',
 '{"ph": 7.38, "po2": 85, "pco2": 42, "carboxihemoglobina": 8.5, "cvf": 85, "vef1": 80}'::jsonb,
 'Laboratorista: Lic. Fernando Díaz',
 'Dra. Neumólogo: Dra. Graciela Santos',
 true,
 NOW()
),

-- ============================================================================
-- ESTUDIOS DE IMAGENOLOGÍA
-- ============================================================================

(gen_random_uuid(),
 (SELECT id FROM perfiles_pacientes WHERE numero_expediente = 'EXP-00001' LIMIT 1),
 (SELECT id FROM medicos WHERE cedula_profesional = 'MED-012-ENDO' LIMIT 1),
 (SELECT id FROM cat_tipos_servicios_auxiliares WHERE nombre = 'Radiología' LIMIT 1),
 'Radiografía de tórax posteroanterior',
 '2026-04-15'::timestamp,
 'Evaluación de pulmones en diabético',
 '2026-04-15'::timestamp,
 '2026-04-15'::timestamp,
 'Radiografía de tórax PA: Campos pulmonares sin infiltrados, silueta cardiomediastínica normal, senos costofrénicos libres. Conclusión: Sin hallazgos patológicos agudos',
 '{"tipo": "Radiografía de tórax", "hallazgos": "Normales", "campos_pulmonares": "Limpios", "silueta_cardiaca": "Normal"}'::jsonb,
 'Tecnólogo: Lic. Rodrigo Peña',
 'Dra. Radiología: Dra. Susana Gonzalez',
 true,
 NOW()
),

(gen_random_uuid(),
 (SELECT id FROM perfiles_pacientes WHERE numero_expediente = 'EXP-00003' LIMIT 1),
 (SELECT id FROM medicos WHERE cedula_profesional = 'MED-001-CARD' LIMIT 1),
 (SELECT id FROM cat_tipos_servicios_auxiliares WHERE nombre = 'Radiología' LIMIT 1),
 'Ecocardiografía bidimensional con Doppler',
 '2026-04-15'::timestamp,
 'Evaluación de función cardíaca post-infarto',
 '2026-04-15'::timestamp,
 '2026-04-15'::timestamp,
 'Ecocardiografía: Aurícula izquierda: 40 mm, VD: 35 mm, VI: 55 mm, Fracción de eyección: 45% (moderadamente reducida), Hipocinesia de pared anterior, Insuficiencia mitral leve. Conclusión: Disfunción sistólica moderada con hipocinesia regional',
 '{"fe": 45, "ai": 40, "vd": 35, "vi": 55, "hallazgo_principal": "Hipocinesia anterior", "insuficiencia_mitral": "Leve"}'::jsonb,
 'Tecnólogo: Lic. Alberto Ruiz',
 'Dr. Cardiólogo: Dr. Carlos García',
 true,
 NOW()
),

(gen_random_uuid(),
 (SELECT id FROM perfiles_pacientes WHERE numero_expediente = 'EXP-00004' LIMIT 1),
 (SELECT id FROM medicos WHERE cedula_profesional = 'MED-015-MINT' LIMIT 1),
 (SELECT id FROM cat_tipos_servicios_auxiliares WHERE nombre = 'Radiología' LIMIT 1),
 'Radiografía de tórax posteroanterior',
 '2026-05-12'::timestamp,
 'Revisión de rutina anual',
 '2026-05-12'::timestamp,
 '2026-05-12'::timestamp,
 'Radiografía de tórax PA: Campos pulmonares normales, sin infiltrados, silueta cardiaca normal, senos costofrénicos libres. Conclusión: Normal',
 '{"tipo": "Radiografía de tórax", "hallazgos": "Normales", "estado": "Sin patología"}'::jsonb,
 'Tecnólogo: Lic. Rosa María López',
 'Dra. Radiología: Dra. Susana Gonzalez',
 true,
 NOW()
),

(gen_random_uuid(),
 (SELECT id FROM perfiles_pacientes WHERE numero_expediente = 'EXP-00005' LIMIT 1),
 (SELECT id FROM medicos WHERE cedula_profesional = 'MED-010-PNEU' LIMIT 1),
 (SELECT id FROM cat_tipos_servicios_auxiliares WHERE nombre = 'Radiología' LIMIT 1),
 'Radiografía de tórax PA, tomografía de tórax de baja dosis',
 '2026-05-09'::timestamp,
 'Evaluación por tabaquismo crónico, detección de patología pulmonar',
 '2026-05-09'::timestamp,
 '2026-05-09'::timestamp,
 'Radiografía: Hiperinsuflación pulmonar discreta. TC tórax baja dosis: No se evidencian nódulos pulmonares sospechosos. Cambios enfisematosos leves bilaterales. Conclusión: Cambios compatibles con EPOC leve',
 '{"radiografia": "Hiperinsuflación discreta", "tc": "Sin nódulos", "enfisema": "Leve bilateral", "diagnostico": "EPOC leve"}'::jsonb,
 'Tecnólogo: Lic. Carlos Andrade',
 'Dra. Radiología: Dra. Susana Gonzalez',
 true,
 NOW()
);

-- ============================================================================
-- VERIFICACIÓN DE DATOS CARGADOS
-- ============================================================================

SELECT COUNT(*) as total_reportes_auxiliares,
       COUNT(DISTINCT tipo_servicio_id) as tipos_servicios_registrados,
       COUNT(CASE WHEN fecha_resultado IS NOT NULL THEN 1 END) as reportes_completados
FROM reportes_servicios_auxiliares;

-- Resultado esperado: 9 reportes (5 laboratorio + 4 imagen)

-- ============================================================================
-- GENERADOR MASIVO DE REPORTES ADICIONALES (OPCIONAL)
-- ============================================================================
-- Este bloque genera reportes adicionales de forma automática

DO $$
DECLARE
  v_paciente_id UUID;
  v_medico_id UUID;
  v_tipo_servicio_id UUID;
  v_count INT := 0;
BEGIN
  -- Generar reportes para pacientes con patologías (diabetes, hipertensión, etc.)
  FOR v_paciente_id IN
    SELECT id FROM perfiles_pacientes
    WHERE numero_expediente LIKE 'EXP-%'
    AND (antecedentes_patologicos @> '{"enfermedades_cronicas": ["Diabetes Mellitus Tipo 2"]}'
         OR antecedentes_patologicos @> '{"enfermedades_cronicas": ["Hipertensión Arterial"]}')
    LIMIT 30
  LOOP
    -- Seleccionar médico y tipo de servicio aleatorios
    SELECT id INTO v_medico_id FROM medicos ORDER BY RANDOM() LIMIT 1;
    SELECT id INTO v_tipo_servicio_id FROM cat_tipos_servicios_auxiliares ORDER BY RANDOM() LIMIT 1;

    -- Insertar reporte
    INSERT INTO reportes_servicios_auxiliares (
      id, id_paciente, id_medico_solicitante, tipo_servicio_id, estudio_solicitado,
      fecha_solicitud, problema_clinico_en_estudio, fecha_realizacion, fecha_resultado,
      resultados, resultados_json, personal_realiza, personal_informa, firma_electronica, created_at
    ) VALUES (
      gen_random_uuid(), v_paciente_id, v_medico_id, v_tipo_servicio_id,
      'Estudio de seguimiento de patología crónica',
      CURRENT_DATE - (RANDOM() * 30)::INT,
      'Control de enfermedad crónica',
      CURRENT_DATE - (RANDOM() * 25)::INT,
      CURRENT_DATE - (RANDOM() * 20)::INT,
      'Resultados dentro de los parámetros de control',
      '{"estado": "controlado", "fecha_proceso": "' || CURRENT_DATE || '"}'::jsonb,
      'Laboratorista/Tecnólogo',
      'Médico especialista',
      true,
      NOW()
    );

    v_count := v_count + 1;
  END LOOP;

  RAISE NOTICE 'Se han generado % reportes de seguimiento adicionales', v_count;
END $$;

-- ============================================================================
-- NOTAS FINALES
-- ============================================================================
-- Este script proporciona:
-- 1. Reportes de laboratorio realistas para pacientes con patologías (5)
-- 2. Estudios de imagenología (4): Radiografías y Ecocardiografía
-- 3. Generador PL/pgSQL para crear reportes masivamente
--
-- PRÓXIMOS PASOS:
-- 1. Ejecutar ligia_v2_0_seed_test_data_notas_evolucion.sql
-- 2. Ejecutar ligia_v2_0_seed_test_data_medicamentos.sql
-- 3. Validar carga completa e integridad de datos
-- 4. Probar visualización en app.html y paciente.html

