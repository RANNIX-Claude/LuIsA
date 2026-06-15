-- ============================================================================
-- LIGIA v2.0 - SCRIPT 2: CATÁLOGOS (26 catálogos)
-- Idempotente: limpia datos previos y carga nuevos
-- ============================================================================

-- ============================================================================
-- LIMPIAR DATOS PREVIOS (orden inverso de FKs)
-- ============================================================================

DELETE FROM cat_procedimientos_cie9;
DELETE FROM cat_tipos_servicios_auxiliares;
DELETE FROM cat_tipos_eventos_auditoria;
DELETE FROM cat_estados_orden;
DELETE FROM cat_tecnicas_quirurgicas;
DELETE FROM cat_riesgos_quirurgicos;
DELETE FROM cat_riesgos;
DELETE FROM cat_reacciones_alergicas;
DELETE FROM cat_niveles_socioeconomicos;
DELETE FROM cat_pronosticos;
DELETE FROM cat_medicamentos;
DELETE FROM cat_diagnosticos;
DELETE FROM cat_unidades_medida;
DELETE FROM cat_tipos_estudios;
DELETE FROM cat_frecuencias_medicamento;
DELETE FROM cat_vias_administracion;
DELETE FROM cat_especialidades;
DELETE FROM cat_tipos_vivienda;
DELETE FROM cat_discapacidades;
DELETE FROM cat_tipos_sanguineo;
DELETE FROM cat_religiones;
DELETE FROM cat_grupos_etnicos;
DELETE FROM cat_estado_civil;
DELETE FROM cat_ocupaciones;
DELETE FROM cat_ciudades;
DELETE FROM cat_estados_republica;

-- ============================================================================
-- CARGAR LOS 26 CATÁLOGOS
-- ============================================================================

-- 1. Estados de la República
INSERT INTO cat_estados_republica (codigo_inegi, nombre, abreviatura) VALUES
('01', 'Aguascalientes', 'AGS'),
('02', 'Baja California', 'BC'),
('09', 'Ciudad de México', 'CDMX'),
('14', 'Jalisco', 'JAL'),
('15', 'Estado de México', 'EDOMEX'),
('19', 'Nuevo León', 'NL'),
('21', 'Puebla', 'PUE'),
('22', 'Querétaro', 'QRO');

-- 2. Ciudades
INSERT INTO cat_ciudades (nombre, estado_id)
SELECT 'CDMX', id FROM cat_estados_republica WHERE abreviatura = 'CDMX';
INSERT INTO cat_ciudades (nombre, estado_id)
SELECT 'Guadalajara', id FROM cat_estados_republica WHERE abreviatura = 'JAL';
INSERT INTO cat_ciudades (nombre, estado_id)
SELECT 'Monterrey', id FROM cat_estados_republica WHERE abreviatura = 'NL';
INSERT INTO cat_ciudades (nombre, estado_id)
SELECT 'Puebla', id FROM cat_estados_republica WHERE abreviatura = 'PUE';

-- 3. Ocupaciones
INSERT INTO cat_ocupaciones (codigo, nombre, descripcion) VALUES
('PROF', 'Profesional', 'Trabajador profesional'),
('EMP', 'Empleado', 'Empleado de oficina'),
('OBR', 'Obrero', 'Trabajador manual'),
('EST', 'Estudiante', 'En formación académica'),
('HOG', 'Hogar', 'Dedicado al hogar'),
('JUB', 'Jubilado', 'Retirado del trabajo'),
('IND', 'Independiente', 'Trabajo independiente');

-- 4. Estado civil
INSERT INTO cat_estado_civil (codigo, nombre) VALUES
('SOL', 'Soltero(a)'),
('CAS', 'Casado(a)'),
('DIV', 'Divorciado(a)'),
('VIU', 'Viudo(a)'),
('UNI', 'Unión libre');

-- 5. Grupos étnicos
INSERT INTO cat_grupos_etnicos (codigo, nombre) VALUES
('MEST', 'Mestizo'),
('IND', 'Indígena'),
('AFR', 'Afromexicano'),
('OTRO', 'Otro');

-- 6. Religiones
INSERT INTO cat_religiones (codigo, nombre) VALUES
('CAT', 'Católica'),
('PROT', 'Protestante'),
('CRIS', 'Cristiana'),
('JUD', 'Judía'),
('ISL', 'Islámica'),
('NING', 'Ninguna'),
('OTRA', 'Otra');

-- 7. Tipos sanguíneos
INSERT INTO cat_tipos_sanguineo (codigo, nombre) VALUES
('O+', 'O Positivo'),
('O-', 'O Negativo'),
('A+', 'A Positivo'),
('A-', 'A Negativo'),
('B+', 'B Positivo'),
('B-', 'B Negativo'),
('AB+', 'AB Positivo'),
('AB-', 'AB Negativo');

-- 8. Discapacidades
INSERT INTO cat_discapacidades (codigo, nombre, descripcion) VALUES
('MOT', 'Motora', 'Limitación física de movimiento'),
('SEN', 'Sensorial', 'Visual o auditiva'),
('INT', 'Intelectual', 'Capacidades cognitivas'),
('MEN', 'Mental', 'Salud mental crónica'),
('NING', 'Ninguna', 'Sin discapacidad');

-- 9. Tipos de vivienda
INSERT INTO cat_tipos_vivienda (nombre) VALUES
('Casa propia'),
('Casa rentada'),
('Departamento'),
('Vivienda familiar'),
('Cuarto'),
('Otra');

-- 10. Especialidades médicas
INSERT INTO cat_especialidades (codigo, nombre, descripcion) VALUES
('MG', 'Medicina General', 'Atención médica general'),
('MED-FAM', 'Medicina Familiar', 'Especialidad familiar'),
('CARD', 'Cardiología', 'Especialidad del corazón'),
('PED', 'Pediatría', 'Especialidad infantil'),
('GIN', 'Ginecología', 'Especialidad femenina'),
('END', 'Endocrinología', 'Sistema endocrino'),
('NEU', 'Neurología', 'Sistema nervioso'),
('PSQ', 'Psiquiatría', 'Salud mental'),
('DRM', 'Dermatología', 'Piel'),
('OFT', 'Oftalmología', 'Ojos'),
('OTO', 'Otorrinolaringología', 'Oído, nariz y garganta'),
('ORT', 'Ortopedia', 'Sistema musculoesquelético'),
('URO', 'Urología', 'Sistema urinario'),
('REU', 'Reumatología', 'Articulaciones'),
('ONC', 'Oncología', 'Cáncer');

-- 11. Vías de administración
INSERT INTO cat_vias_administracion (codigo, nombre, abreviatura) VALUES
('ORAL', 'Oral', 'V.O.'),
('IV', 'Intravenosa', 'I.V.'),
('IM', 'Intramuscular', 'I.M.'),
('SC', 'Subcutánea', 'S.C.'),
('TOP', 'Tópica', 'Top'),
('INH', 'Inhalada', 'Inh'),
('REC', 'Rectal', 'Rec'),
('VAG', 'Vaginal', 'Vag');

-- 12. Frecuencias de medicamentos
INSERT INTO cat_frecuencias_medicamento (nombre, valor_horas) VALUES
('Cada 4 horas', 4),
('Cada 6 horas', 6),
('Cada 8 horas', 8),
('Cada 12 horas', 12),
('Cada 24 horas', 24),
('Una vez al día', 24),
('Dos veces al día', 12),
('Tres veces al día', 8);

-- 13. Tipos de estudios
INSERT INTO cat_tipos_estudios (nombre, codigo) VALUES
('Biometría hemática', 'BH'),
('Química sanguínea', 'QS'),
('Examen general de orina', 'EGO'),
('Perfil de lípidos', 'LIP'),
('Pruebas de función hepática', 'PFH'),
('Pruebas de función renal', 'PFR'),
('Hemoglobina glucosilada', 'HBA1C'),
('Radiografía simple', 'RX'),
('Tomografía computarizada', 'TC'),
('Resonancia magnética', 'RM');

-- 14. Unidades de medida
INSERT INTO cat_unidades_medida (codigo, nombre, abreviatura) VALUES
('MG', 'Miligramos', 'mg'),
('G', 'Gramos', 'g'),
('ML', 'Mililitros', 'ml'),
('L', 'Litros', 'L'),
('MCG', 'Microgramos', 'mcg'),
('UI', 'Unidades Internacionales', 'UI'),
('MMHG', 'Milímetros de Mercurio', 'mmHg'),
('BPM', 'Latidos por Minuto', 'bpm'),
('RPM', 'Respiraciones por Minuto', 'rpm'),
('CM', 'Centímetros', 'cm'),
('KG', 'Kilogramos', 'kg');

-- 15. Diagnósticos CIE-10
INSERT INTO cat_diagnosticos (codigo_cie10, nombre, categoria) VALUES
('I10', 'Hipertensión arterial esencial', 'Cardiovascular'),
('E11', 'Diabetes mellitus tipo 2', 'Endocrino'),
('J45', 'Asma', 'Respiratorio'),
('K29', 'Gastritis y duodenitis', 'Digestivo'),
('M54', 'Dorsalgia', 'Musculoesquelético'),
('F32', 'Episodio depresivo', 'Mental'),
('Z00', 'Control de salud rutinario', 'Preventivo'),
('Z01', 'Otros exámenes especiales', 'Preventivo');

-- 16. Medicamentos
INSERT INTO cat_medicamentos (codigo_atc, nombre, dosis_recomendada) VALUES
('C09AA02', 'Enalapril', '10 mg'),
('A10BA02', 'Metformina', '850 mg'),
('B01AC06', 'Ácido acetilsalicílico (Aspirina)', '100 mg'),
('M01AE01', 'Ibuprofeno', '400 mg'),
('N02BE01', 'Paracetamol', '500 mg'),
('A02BC01', 'Omeprazol', '20 mg'),
('C10AA01', 'Simvastatina', '20 mg'),
('R03AC02', 'Salbutamol', '100 mcg'),
('J01CA04', 'Amoxicilina', '500 mg'),
('C07AB02', 'Metoprolol', '50 mg');

-- 17. Pronósticos
INSERT INTO cat_pronosticos (nombre, descripcion) VALUES
('Favorable', 'Pronóstico positivo'),
('Reservado', 'Pronóstico con precaución'),
('Grave', 'Pronóstico delicado'),
('Crítico', 'Pronóstico de riesgo vital');

-- 18. Niveles socioeconómicos
INSERT INTO cat_niveles_socioeconomicos (codigo, nombre) VALUES
('AB', 'Alto'),
('C+', 'Medio Alto'),
('C', 'Medio'),
('C-', 'Medio Bajo'),
('D+', 'Bajo'),
('D', 'Muy Bajo'),
('E', 'Marginal');

-- 19. Reacciones alérgicas
INSERT INTO cat_reacciones_alergicas (nombre, severidad) VALUES
('Anafilaxia', 'Grave'),
('Urticaria', 'Moderada'),
('Angioedema', 'Grave'),
('Rash cutáneo', 'Leve'),
('Edema de Quincke', 'Grave'),
('Prurito', 'Leve'),
('Broncoespasmo', 'Grave'),
('Náusea', 'Leve');

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
('Bajo', 1, 'Paciente sano sin comorbilidades'),
('Moderado', 2, 'Enfermedad sistémica leve'),
('Alto', 3, 'Enfermedad sistémica grave'),
('Muy alto', 4, 'Amenaza para la vida'),
('Crítico', 5, 'No esperaría sobrevivir sin operación');

-- 22. Técnicas quirúrgicas
INSERT INTO cat_tecnicas_quirurgicas (nombre, abreviatura) VALUES
('Abierta', 'OPN'),
('Laparoscópica', 'LAP'),
('Endoscópica', 'END'),
('Robótica', 'ROB'),
('Mínimamente invasiva', 'MI'),
('Microcirugía', 'MIC');

-- 23. Estados de orden
INSERT INTO cat_estados_orden (nombre) VALUES
('Pendiente'),
('En proceso'),
('Ejecutada'),
('Cancelada'),
('Incompleta'),
('Rechazada');

-- 24. Tipos de eventos de auditoría
INSERT INTO cat_tipos_eventos_auditoria (nombre, codigo) VALUES
('Inicio de sesión', 'LOGIN'),
('Cierre de sesión', 'LOGOUT'),
('Lectura', 'READ'),
('Creación', 'CREATE'),
('Modificación', 'UPDATE'),
('Eliminación', 'DELETE'),
('Firma electrónica', 'SIGN'),
('Descarga', 'DOWNLOAD'),
('Exportación', 'EXPORT'),
('Cambio de permisos', 'PERM_CHANGE');

-- 25. Tipos de servicios auxiliares
INSERT INTO cat_tipos_servicios_auxiliares (nombre, codigo) VALUES
('Laboratorio', 'LAB'),
('Radiología', 'RAD'),
('Tomografía', 'TAC'),
('Resonancia Magnética', 'MRI'),
('Ultrasonido', 'USG'),
('Electrocardiograma', 'ECG');

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
-- VERIFICACIÓN FINAL - LOS 26 CATÁLOGOS
-- ============================================================================

SELECT
  'cat_estados_republica' as catalogo, COUNT(*) as registros FROM cat_estados_republica
UNION ALL SELECT 'cat_ciudades', COUNT(*) FROM cat_ciudades
UNION ALL SELECT 'cat_ocupaciones', COUNT(*) FROM cat_ocupaciones
UNION ALL SELECT 'cat_estado_civil', COUNT(*) FROM cat_estado_civil
UNION ALL SELECT 'cat_grupos_etnicos', COUNT(*) FROM cat_grupos_etnicos
UNION ALL SELECT 'cat_religiones', COUNT(*) FROM cat_religiones
UNION ALL SELECT 'cat_tipos_sanguineo', COUNT(*) FROM cat_tipos_sanguineo
UNION ALL SELECT 'cat_discapacidades', COUNT(*) FROM cat_discapacidades
UNION ALL SELECT 'cat_tipos_vivienda', COUNT(*) FROM cat_tipos_vivienda
UNION ALL SELECT 'cat_especialidades', COUNT(*) FROM cat_especialidades
UNION ALL SELECT 'cat_vias_administracion', COUNT(*) FROM cat_vias_administracion
UNION ALL SELECT 'cat_frecuencias_medicamento', COUNT(*) FROM cat_frecuencias_medicamento
UNION ALL SELECT 'cat_tipos_estudios', COUNT(*) FROM cat_tipos_estudios
UNION ALL SELECT 'cat_unidades_medida', COUNT(*) FROM cat_unidades_medida
UNION ALL SELECT 'cat_diagnosticos', COUNT(*) FROM cat_diagnosticos
UNION ALL SELECT 'cat_medicamentos', COUNT(*) FROM cat_medicamentos
UNION ALL SELECT 'cat_pronosticos', COUNT(*) FROM cat_pronosticos
UNION ALL SELECT 'cat_niveles_socioeconomicos', COUNT(*) FROM cat_niveles_socioeconomicos
UNION ALL SELECT 'cat_reacciones_alergicas', COUNT(*) FROM cat_reacciones_alergicas
UNION ALL SELECT 'cat_riesgos', COUNT(*) FROM cat_riesgos
UNION ALL SELECT 'cat_riesgos_quirurgicos', COUNT(*) FROM cat_riesgos_quirurgicos
UNION ALL SELECT 'cat_tecnicas_quirurgicas', COUNT(*) FROM cat_tecnicas_quirurgicas
UNION ALL SELECT 'cat_estados_orden', COUNT(*) FROM cat_estados_orden
UNION ALL SELECT 'cat_tipos_eventos_auditoria', COUNT(*) FROM cat_tipos_eventos_auditoria
UNION ALL SELECT 'cat_tipos_servicios_auxiliares', COUNT(*) FROM cat_tipos_servicios_auxiliares
UNION ALL SELECT 'cat_procedimientos_cie9', COUNT(*) FROM cat_procedimientos_cie9
ORDER BY catalogo;
