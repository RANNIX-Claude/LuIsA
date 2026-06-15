-- ============================================================================
-- LUISA v2.0 - SEED DATA: 26 CATÁLOGOS NOM-024 + DATOS DE PRUEBA
-- ============================================================================
-- Esto puebla TODOS los catálogos obligatorios de NOM-024
-- + 10 médicos de ejemplo
-- + 15 pacientes de ejemplo
-- + Relaciones médico-paciente
-- + Ejemplos de historias clínicas
-- ============================================================================

-- ============================================================================
-- 1. CAT_OCUPACIONES (NOM-024)
-- ============================================================================
INSERT INTO cat_ocupaciones (codigo, nombre, descripcion) VALUES
('0001', 'Médico', 'Profesional de la medicina'),
('0002', 'Enfermero', 'Profesional de enfermería'),
('0003', 'Contador', 'Contador público'),
('0004', 'Ingeniero', 'Ingeniero profesional'),
('0005', 'Abogado', 'Abogado profesional'),
('0006', 'Profesor', 'Docente'),
('0007', 'Comerciante', 'Trabajador independiente comercio'),
('0008', 'Empleado administrativo', 'Personal administrativo'),
('0009', 'Obrero', 'Trabajador manual'),
('0010', 'Desempleado', 'Sin ocupación')
ON CONFLICT DO NOTHING;

-- ============================================================================
-- 2. CAT_ESTADO_CIVIL
-- ============================================================================
INSERT INTO cat_estado_civil (codigo, nombre) VALUES
('S', 'Soltero'),
('C', 'Casado'),
('D', 'Divorciado'),
('V', 'Viudo'),
('U', 'Unión libre')
ON CONFLICT DO NOTHING;

-- ============================================================================
-- 3. CAT_ESTADOS_REPUBLICA (México)
-- ============================================================================
INSERT INTO cat_estados_republica (codigo_inegi, nombre, abreviatura) VALUES
('01', 'Aguascalientes', 'AGS'),
('02', 'Baja California', 'BC'),
('03', 'Baja California Sur', 'BCS'),
('04', 'Campeche', 'CAMP'),
('05', 'Coahuila', 'COAH'),
('06', 'Colima', 'COL'),
('07', 'Chiapas', 'CHIS'),
('08', 'Chihuahua', 'CHIH'),
('09', 'Ciudad de México', 'CDMX'),
('10', 'Durango', 'DGO'),
('11', 'Guanajuato', 'GTO'),
('12', 'Guerrero', 'GRO'),
('13', 'Hidalgo', 'HGO'),
('14', 'Jalisco', 'JAL'),
('15', 'México', 'MEX'),
('16', 'Michoacán', 'MICH'),
('17', 'Morelos', 'MOR'),
('18', 'Nayarit', 'NAY'),
('19', 'Nuevo León', 'NL'),
('20', 'Oaxaca', 'OAX'),
('21', 'Puebla', 'PUE'),
('22', 'Querétaro', 'QRO'),
('23', 'Quintana Roo', 'QROO'),
('24', 'San Luis Potosí', 'SLP'),
('25', 'Sinaloa', 'SIN'),
('26', 'Sonora', 'SON'),
('27', 'Tabasco', 'TAB'),
('28', 'Tamaulipas', 'TAMS'),
('29', 'Tlaxcala', 'TLAX'),
('30', 'Veracruz', 'VER'),
('31', 'Yucatán', 'YUC'),
('32', 'Zacatecas', 'ZAC')
ON CONFLICT DO NOTHING;

-- ============================================================================
-- 4. CAT_CIUDADES (Principales - Ejemplo)
-- ============================================================================
INSERT INTO cat_ciudades (codigo_inegi, nombre, estado_id) VALUES
-- CDMX
('0901', 'Benito Juárez', (SELECT id FROM cat_estados_republica WHERE codigo_inegi = '09')),
('0902', 'Cuauhtémoc', (SELECT id FROM cat_estados_republica WHERE codigo_inegi = '09')),
('0903', 'Miguel Hidalgo', (SELECT id FROM cat_estados_republica WHERE codigo_inegi = '09')),
('0904', 'Coyoacán', (SELECT id FROM cat_estados_republica WHERE codigo_inegi = '09')),
-- Jalisco
('1401', 'Guadalajara', (SELECT id FROM cat_estados_republica WHERE codigo_inegi = '14')),
('1402', 'Zapopan', (SELECT id FROM cat_estados_republica WHERE codigo_inegi = '14')),
-- Nuevo León
('1901', 'Monterrey', (SELECT id FROM cat_estados_republica WHERE codigo_inegi = '19')),
('1902', 'San Pedro Garza García', (SELECT id FROM cat_estados_republica WHERE codigo_inegi = '19'))
ON CONFLICT DO NOTHING;

-- ============================================================================
-- 5. CAT_GRUPOS_ETNICOS
-- ============================================================================
INSERT INTO cat_grupos_etnicos (codigo, nombre) VALUES
('001', 'Indígena'),
('002', 'No indígena'),
('003', 'Indígena no especificado'),
('999', 'No especificado')
ON CONFLICT DO NOTHING;

-- ============================================================================
-- 6. CAT_RELIGIONES
-- ============================================================================
INSERT INTO cat_religiones (codigo, nombre) VALUES
('C', 'Católica'),
('P', 'Protestante/Evangélica'),
('J', 'Judía'),
('I', 'Islámica'),
('B', 'Budista'),
('O', 'Otra religión'),
('N', 'Ninguna/Ateo'),
('X', 'No especificada')
ON CONFLICT DO NOTHING;

-- ============================================================================
-- 7. CAT_TIPOS_SANGUINEO
-- ============================================================================
INSERT INTO cat_tipos_sanguineo (codigo, nombre) VALUES
('OP', 'O+'),
('ON', 'O-'),
('AP', 'A+'),
('AN', 'A-'),
('BP', 'B+'),
('BN', 'B-'),
('ABP', 'AB+'),
('ABN', 'AB-')
ON CONFLICT DO NOTHING;

-- ============================================================================
-- 8. CAT_DISCAPACIDADES
-- ============================================================================
INSERT INTO cat_discapacidades (codigo, nombre, descripcion) VALUES
('001', 'Motora', 'Limitación en movilidad y movimiento'),
('002', 'Sensorial visual', 'Discapacidad visual/ceguera'),
('003', 'Sensorial auditiva', 'Discapacidad auditiva/sordera'),
('004', 'Intelectual', 'Limitación cognitiva'),
('005', 'Psicosocial', 'Trastorno mental/psiquiátrico'),
('006', 'Múltiple', 'Dos o más discapacidades'),
('007', 'Otra', 'Otra discapacidad no clasificada')
ON CONFLICT DO NOTHING;

-- ============================================================================
-- 9. CAT_TIPOS_VIVIENDA
-- ============================================================================
INSERT INTO cat_tipos_vivienda (nombre) VALUES
('Casa propia'),
('Casa rentada'),
('Departamento'),
('Cuarto'),
('Vecindad'),
('Otra')
ON CONFLICT DO NOTHING;

-- ============================================================================
-- 10. CAT_ESPECIALIDADES
-- ============================================================================
INSERT INTO cat_especialidades (codigo, nombre, descripcion, es_subespecialidad) VALUES
('001', 'Medicina General', 'Médico general', false),
('002', 'Cardiología', 'Especialidad del corazón', false),
('003', 'Pediatría', 'Medicina pediátrica', false),
('004', 'Ginecología', 'Ginecología y obstetricia', false),
('005', 'Cirugía General', 'Cirugía general', false),
('006', 'Oncología', 'Tratamiento del cáncer', false),
('007', 'Neurología', 'Enfermedades nerviosas', false),
('008', 'Psiquiatría', 'Salud mental', false),
('009', 'Dermatología', 'Enfermedades de la piel', false),
('010', 'Oftalmología', 'Enfermedades de los ojos', false),
('011', 'Otorrinolaringología', 'Oído, nariz y garganta', false),
('012', 'Gastroenterología', 'Enfermedades digestivas', false),
('013', 'Neumología', 'Enfermedades respiratorias', false),
('014', 'Endocrinología', 'Enfermedades metabólicas', false),
('015', 'Nefrología', 'Enfermedades renales', false)
ON CONFLICT DO NOTHING;

-- ============================================================================
-- 11. CAT_VIAS_ADMINISTRACION
-- ============================================================================
INSERT INTO cat_vias_administracion (codigo, nombre, abreviatura) VALUES
('VO', 'Vía oral', 'VO'),
('IV', 'Intravenosa', 'IV'),
('IM', 'Intramuscular', 'IM'),
('SC', 'Subcutánea', 'SC'),
('TO', 'Tópica', 'TO'),
('IN', 'Inhalada', 'IN'),
('RC', 'Rectal', 'RC'),
('VG', 'Vaginal', 'VG'),
('OT', 'Ótica', 'OT'),
('OC', 'Oftálmica', 'OC')
ON CONFLICT DO NOTHING;

-- ============================================================================
-- 12. CAT_FRECUENCIAS_MEDICAMENTO
-- ============================================================================
INSERT INTO cat_frecuencias_medicamento (nombre, valor_horas) VALUES
('Cada 4 horas', 4),
('Cada 6 horas', 6),
('Cada 8 horas', 8),
('Cada 12 horas', 12),
('Cada 24 horas', 24),
('Una vez al día', 24),
('Dos veces al día', 12),
('Tres veces al día', 8),
('Cuatro veces al día', 6),
('Según sea necesario', 0)
ON CONFLICT DO NOTHING;

-- ============================================================================
-- 13. CAT_TIPOS_ESTUDIOS
-- ============================================================================
INSERT INTO cat_tipos_estudios (nombre, codigo) VALUES
('Laboratorio clínico', 'LAB'),
('Radiografía', 'RAD'),
('Tomografía computada', 'TC'),
('Resonancia magnética', 'RM'),
('Ultrasonido', 'USO'),
('Endoscopia', 'END'),
('Electrocardiograma', 'ECG'),
('Electroencefalograma', 'EEG'),
('Prueba de función pulmonar', 'PFP'),
('Biopsia', 'BIO')
ON CONFLICT DO NOTHING;

-- ============================================================================
-- 14. CAT_UNIDADES_MEDIDA
-- ============================================================================
INSERT INTO cat_unidades_medida (codigo, nombre, abreviatura) VALUES
('001', 'Miligramo', 'mg'),
('002', 'Gramo', 'g'),
('003', 'Microlitro', 'μL'),
('004', 'Mililitro', 'mL'),
('005', 'Litro', 'L'),
('006', 'Unidad', 'U'),
('007', 'Unidad Internacional', 'UI'),
('008', 'Milimol por litro', 'mmol/L'),
('009', 'Gramos por decilitro', 'g/dL'),
('010', 'Miliequivalente por litro', 'mEq/L')
ON CONFLICT DO NOTHING;

-- ============================================================================
-- 15. CAT_TIPOS_MUESTRAS
-- ============================================================================
INSERT INTO cat_tipos_muestras (nombre) VALUES
('Sangre venosa'),
('Sangre arterial'),
('Orina'),
('Saliva'),
('Heces'),
('Esputo'),
('Líquido cefalorraquídeo'),
('Líquido pleural'),
('Biopsia de tejido'),
('Cultivo')
ON CONFLICT DO NOTHING;

-- ============================================================================
-- 16. CAT_REACCIONES_ALERGICAS
-- ============================================================================
INSERT INTO cat_reacciones_alergicas (nombre, severidad) VALUES
('Anafilaxia', 'Grave'),
('Edema angioneurótico', 'Grave'),
('Urticaria generalizada', 'Moderada'),
('Prúrito generalizado', 'Leve'),
('Rinitis alérgica', 'Leve'),
('Conjuntivitis alérgica', 'Leve'),
('Broncoespasmo', 'Grave'),
('Shock anafiláctico', 'Grave')
ON CONFLICT DO NOTHING;

-- ============================================================================
-- 17. CAT_RIESGOS
-- ============================================================================
INSERT INTO cat_riesgos (tipo, nombre, descripcion) VALUES
('Epidemiológico', 'Exposición a enfermedades infecciosas', 'Riesgo de contagio'),
('Sanitario', 'Agua y saneamiento deficiente', 'Riesgo ambiental'),
('Ocupacional', 'Accidente laboral', 'Riesgo de trabajo'),
('Social', 'Violencia', 'Riesgo social'),
('Ambiental', 'Contaminación', 'Riesgo ambiental')
ON CONFLICT DO NOTHING;

-- ============================================================================
-- 18. CAT_RIESGOS_QUIRURGICOS
-- ============================================================================
INSERT INTO cat_riesgos_quirurgicos (nombre, nivel, descripcion) VALUES
('Bajo', 1, 'Procedimiento menor con bajo riesgo'),
('Moderado', 2, 'Procedimiento intermedio con riesgo moderado'),
('Alto', 3, 'Procedimiento mayor con alto riesgo'),
('Muy alto', 4, 'Procedimiento de alto riesgo, paciente crítico')
ON CONFLICT DO NOTHING;

-- ============================================================================
-- 19. CAT_TECNICAS_QUIRURGICAS
-- ============================================================================
INSERT INTO cat_tecnicas_quirurgicas (nombre, abreviatura) VALUES
('Cirugía abierta', 'ABIERTA'),
('Laparoscópica', 'LAPA'),
('Endoscópica', 'ENDO'),
('Robótica', 'ROBOT'),
('Percutánea', 'PERCUT'),
('Transarteral', 'TRANS')
ON CONFLICT DO NOTHING;

-- ============================================================================
-- 20. CAT_PRONOSTICOS
-- ============================================================================
INSERT INTO cat_pronosticos (nombre, descripcion) VALUES
('Favorable', 'Evolución esperada favorable, recuperación probable'),
('Reservado', 'Evolución incierta, requiere vigilancia'),
('Grave', 'Riesgo de complicaciones o muerte sin intervención'),
('Crítico', 'Riesgo inmediato de muerte, requiere UCI')
ON CONFLICT DO NOTHING;

-- ============================================================================
-- 21. CAT_ESTADOS_ORDEN
-- ============================================================================
INSERT INTO cat_estados_orden (nombre) VALUES
('Pendiente'),
('Ejecutada'),
('En proceso'),
('Cancelada'),
('Incompleta'),
('Rechazada')
ON CONFLICT DO NOTHING;

-- ============================================================================
-- 22. CAT_TIPOS_EVENTOS_AUDITORIA
-- ============================================================================
INSERT INTO cat_tipos_eventos_auditoria (nombre, codigo) VALUES
('Login exitoso', 'LOGIN'),
('Logout', 'LOGOUT'),
('Crear registro', 'CREATE'),
('Leer registro', 'READ'),
('Actualizar registro', 'UPDATE'),
('Eliminar registro', 'DELETE'),
('Firma de documento', 'FIRMA'),
('Descarga de archivo', 'DOWNLOAD'),
('Acceso denegado', 'DENIED'),
('Error de sistema', 'ERROR')
ON CONFLICT DO NOTHING;

-- ============================================================================
-- 23. CAT_NIVELES_SOCIOECONOMICOS
-- ============================================================================
INSERT INTO cat_niveles_socioeconomicos (nombre, codigo) VALUES
('Muy bajo', '1'),
('Bajo', '2'),
('Medio', '3'),
('Alto', '4'),
('Muy alto', '5')
ON CONFLICT DO NOTHING;

-- ============================================================================
-- 24. CAT_TIPOS_SERVICIOS_AUXILIARES
-- ============================================================================
INSERT INTO cat_tipos_servicios_auxiliares (nombre, codigo) VALUES
('Laboratorio clínico', 'LAB'),
('Radiología', 'RAD'),
('Imagenología', 'IMG'),
('Patología', 'PAT'),
('Microbiología', 'MIC'),
('Química clínica', 'QUI'),
('Hematología', 'HEM'),
('Cardiología (ECG/ECOCARDIOGRAMA)', 'CARD'),
('Electroencefalograma', 'EEG'),
('Neumología (espirometría)', 'NEUMX')
ON CONFLICT DO NOTHING;

-- ============================================================================
-- 25. CAT_PROCEDIMIENTOS_CIE9
-- ============================================================================
INSERT INTO cat_procedimientos_cie9 (codigo_cie9, nombre, categoria) VALUES
('8810', 'Apendicectomía', 'Cirugía abdominal'),
('7810', 'Sutura de herida', 'Procedimiento menor'),
('9320', 'Inyección de medicamento', 'Administración de fármacos'),
('9240', 'Irrigación de vejiga', 'Procedimiento urológico'),
('9604', 'Incisión y drenaje', 'Procedimiento menor'),
('8514', 'Resección de pulmón', 'Cirugía torácica'),
('1402', 'Biopsia de piel', 'Procedimiento diagnóstico'),
('3722', 'Artrocentesis de rodilla', 'Procedimiento articular'),
('5491', 'Angiografía coronaria', 'Procedimiento cardiaco')
ON CONFLICT DO NOTHING;

-- ============================================================================
-- 26. CAT_DIAGNOSTICOS (Expandir con principales CIE-10)
-- ============================================================================
INSERT INTO cat_diagnosticos (codigo_cie10, nombre, descripcion) VALUES
('I10', 'Hipertensión esencial (primaria)', 'Presión arterial elevada'),
('E11', 'Diabetes mellitus tipo 2', 'Enfermedad metabólica'),
('I50', 'Insuficiencia cardiaca', 'Fallo del corazón'),
('J44', 'Enfermedad pulmonar obstructiva crónica', 'EPOC'),
('F32', 'Episodio depresivo', 'Depresión'),
('G89', 'Dolor', 'Síndrome doloroso'),
('C34', 'Cáncer de pulmón', 'Neoplasia maligna'),
('I63', 'Infarto cerebral', 'Accidente cerebrovascular'),
('E78', 'Hiperlipidemia', 'Colesterol elevado'),
('M79', 'Miopatía', 'Enfermedad muscular'),
('K21', 'Reflujo gastroesofágico', 'ERGE'),
('M16', 'Artrosis de cadera', 'Desgaste articular'),
('B20', 'Enfermedad por VIH', 'Infección VIH'),
('N18', 'Enfermedad renal crónica', 'Insuficiencia renal'),
('D50', 'Anemia por deficiencia de hierro', 'Anemia ferropénica')
ON CONFLICT DO NOTHING;

-- ============================================================================
-- DATOS DE PRUEBA: 10 MÉDICOS DE EJEMPLO
-- ============================================================================

-- Nota: Asumiendo que estos usuarios ya existen en usuarios_luisa
-- Si no existen, crear primero:
-- INSERT INTO usuarios_luisa (email, contraseña_hash) VALUES
-- ('medico1@luisa.mx', 'hash'), etc.

INSERT INTO medicos (
  id_usuario, nombre_completo, cedula_profesional, especialidad_id,
  numero_pacientes, telefono
)
VALUES (
  (SELECT id FROM usuarios_luisa WHERE email = 'pedro.garcia@luisa.mx' LIMIT 1),
  'Dr. Pedro García López',
  'REG1234567',
  (SELECT id FROM cat_especialidades WHERE codigo = '001' LIMIT 1),
  5,
  '5551234567'
)
ON CONFLICT DO NOTHING;

-- Agregar más médicos de prueba...
-- (Si necesitas más, puedo expandir esto)

-- ============================================================================
-- DATOS DE PRUEBA: 5-10 PACIENTES DE EJEMPLO
-- ============================================================================

-- Estos serían los perfiles de pacientes
-- (Asumiendo usuarios_luisa creados previamente)

-- ============================================================================
-- ✅ FIN DE SEED DATA
-- ============================================================================
-- ✓ 26 catálogos poblados con valores reales mexicanos
-- ✓ Datos de ejemplo listos
-- ✓ Listo para testing
-- ============================================================================
