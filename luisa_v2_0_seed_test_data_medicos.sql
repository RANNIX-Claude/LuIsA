-- ============================================================================
-- LUISA v2.0 - SEED DATA: 20 MÉDICOS CON PERFILES COMPLETOS
-- ============================================================================
-- Script para cargar 20 médicos con especialidades, certificaciones y datos reales
-- Ejecutar DESPUÉS de ENTREGA 1, 2 y 2.5
-- ============================================================================

-- 1. Limpiar datos previos (OPCIONAL - comentar si ya hay datos importantes)
-- DELETE FROM medicos WHERE cedula_profesional LIKE 'MED-%';

-- 2. Insertar 20 MÉDICOS CON ESPECIALIDADES VARIADAS

INSERT INTO medicos (
  nombre,
  apellido_paterno,
  apellido_materno,
  especialidad_id,
  cedula_profesional,
  numero_pacientes,
  idiomas,
  certificaciones,
  disponibilidad_tele_salud,
  requiere_consentimiento_informado,
  created_at
) VALUES

-- 1. DR. CARLOS GARCÍA MORENO - Cardiología
('Carlos', 'García', 'Moreno',
  (SELECT id FROM cat_especialidades WHERE nombre = 'Cardiología' LIMIT 1),
  'MED-001-CARD',
  18,
  '["español", "inglés"]'::jsonb,
  '["American Heart Association", "Certificado en Ecocardiografía"]'::jsonb,
  true,
  true,
  NOW()
),

-- 2. DRA. MARÍA RODRÍGUEZ PÉREZ - Pediatría
('María', 'Rodríguez', 'Pérez',
  (SELECT id FROM cat_especialidades WHERE nombre = 'Pediatría' LIMIT 1),
  'MED-002-PEDI',
  24,
  '["español", "inglés", "francés"]'::jsonb,
  '["Pediatría Avanzada", "Vacunología"]'::jsonb,
  true,
  true,
  NOW()
),

-- 3. DR. JUAN MARTÍNEZ LÓPEZ - Neurología
('Juan', 'Martínez', 'López',
  (SELECT id FROM cat_especialidades WHERE nombre = 'Neurología' LIMIT 1),
  'MED-003-NEUR',
  15,
  '["español", "inglés"]'::jsonb,
  '["Neurocirugía", "Epilepsia"]'::jsonb,
  false,
  true,
  NOW()
),

-- 4. DRA. ALEJANDRA CASTRO RIVERA - Ginecología y Obstetricia
('Alejandra', 'Castro', 'Rivera',
  (SELECT id FROM cat_especialidades WHERE nombre = 'Ginecología' LIMIT 1),
  'MED-004-GINE',
  22,
  '["español", "inglés"]'::jsonb,
  '["Obstetricia Avanzada", "Laparoscopia"]'::jsonb,
  true,
  true,
  NOW()
),

-- 5. DR. RICARDO HERNÁNDEZ SÁNCHEZ - Ortopedia
('Ricardo', 'Hernández', 'Sánchez',
  (SELECT id FROM cat_especialidades WHERE nombre = 'Traumatología' LIMIT 1),
  'MED-005-ORTO',
  20,
  '["español"]'::jsonb,
  '["Cirugía Articular", "Artroscopia"]'::jsonb,
  false,
  true,
  NOW()
),

-- 6. DRA. PATRICIA FLORES GARCÍA - Dermatología
('Patricia', 'Flores', 'García',
  (SELECT id FROM cat_especialidades WHERE nombre = 'Dermatología' LIMIT 1),
  'MED-006-DERM',
  19,
  '["español", "inglés"]'::jsonb,
  '["Dermatología Estética", "Laser y Luz Pulsada"]'::jsonb,
  true,
  false,
  NOW()
),

-- 7. DR. FERNANDO SILVA DÍAZ - Psiquiatría
('Fernando', 'Silva', 'Díaz',
  (SELECT id FROM cat_especialidades WHERE nombre = 'Psiquiatría' LIMIT 1),
  'MED-007-PSIQ',
  25,
  '["español", "inglés"]'::jsonb,
  '["Psiquiatría Clínica", "Terapia Cognitivo Conductual"]'::jsonb,
  true,
  true,
  NOW()
),

-- 8. DRA. ROSARIO MORALES GUTIERREZ - Urología
('Rosario', 'Morales', 'Gutierrez',
  (SELECT id FROM cat_especialidades WHERE nombre = 'Urología' LIMIT 1),
  'MED-008-UROL',
  17,
  '["español", "inglés"]'::jsonb,
  '["Uro-oncología", "Cirugía Mínimamente Invasiva"]'::jsonb,
  false,
  true,
  NOW()
),

-- 9. DR. LUIS VARGAS ROMERO - Oftalmología
('Luis', 'Vargas', 'Romero',
  (SELECT id FROM cat_especialidades WHERE nombre = 'Oftalmología' LIMIT 1),
  'MED-009-OFTA',
  21,
  '["español", "inglés"]'::jsonb,
  '["Cirugía Refractiva", "Glaucoma"]'::jsonb,
  true,
  false,
  NOW()
),

-- 10. DRA. GRACIELA SANTOS LEÓN - Neumología
('Graciela', 'Santos', 'León',
  (SELECT id FROM cat_especialidades WHERE nombre = 'Neumología' LIMIT 1),
  'MED-010-PNEU',
  18,
  '["español", "inglés"]'::jsonb,
  '["EPOC", "Asma Severo"]'::jsonb,
  true,
  true,
  NOW()
),

-- 11. DR. ANDRES MENDOZA CRUZ - Gastroenterología
('Andres', 'Mendoza', 'Cruz',
  (SELECT id FROM cat_especialidades WHERE nombre = 'Gastroenterología' LIMIT 1),
  'MED-011-GAST',
  20,
  '["español", "inglés"]'::jsonb,
  '["Endoscopia Avanzada", "Hepatología"]'::jsonb,
  false,
  true,
  NOW()
),

-- 12. DRA. BEATRIZ NÚÑEZ TORRES - Endocrinología y Metabolismo
('Beatriz', 'Núñez', 'Torres',
  (SELECT id FROM cat_especialidades WHERE nombre = 'Endocrinología' LIMIT 1),
  'MED-012-ENDO',
  19,
  '["español", "inglés"]'::jsonb,
  '["Diabetes Mellitus", "Tiroidología"]'::jsonb,
  true,
  true,
  NOW()
),

-- 13. DR. PABLO DÍAZ NAVARRO - Infectología
('Pablo', 'Díaz', 'Navarro',
  (SELECT id FROM cat_especialidades WHERE nombre = 'Infectología' LIMIT 1),
  'MED-013-INFE',
  16,
  '["español", "inglés", "italiano"]'::jsonb,
  '["VIH/SIDA", "Tuberculosis"]'::jsonb,
  true,
  true,
  NOW()
),

-- 14. DRA. CARMEN REYES ÁLVAREZ - Oncología Médica
('Carmen', 'Reyes', 'Álvarez',
  (SELECT id FROM cat_especialidades WHERE nombre = 'Oncología' LIMIT 1),
  'MED-014-ONCO',
  14,
  '["español", "inglés"]'::jsonb,
  '["Oncología Pediátrica", "Quimioterapia"]'::jsonb,
  false,
  true,
  NOW()
),

-- 15. DR. MANUEL LOPEZ JIMENEZ - Medicina Interna
('Manuel', 'Lopez', 'Jimenez',
  (SELECT id FROM cat_especialidades WHERE nombre = 'Medicina Interna' LIMIT 1),
  'MED-015-MINT',
  26,
  '["español", "inglés"]'::jsonb,
  '["Clínica General", "Medicina Preventiva"]'::jsonb,
  true,
  true,
  NOW()
),

-- 16. DRA. SUSANA GONZALEZ RIOS - Radiología e Imagenología
('Susana', 'Gonzalez', 'Rios',
  (SELECT id FROM cat_especialidades WHERE nombre = 'Radiología' LIMIT 1),
  'MED-016-RADI',
  17,
  '["español", "inglés"]'::jsonb,
  '["RM Avanzada", "Tomografía de Cuerpo Entero"]'::jsonb,
  false,
  false,
  NOW()
),

-- 17. DR. OCTAVIO GUTIERREZ MOLINA - Traumatología y Cirugía Ortopédica
('Octavio', 'Gutierrez', 'Molina',
  (SELECT id FROM cat_especialidades WHERE nombre = 'Traumatología' LIMIT 1),
  'MED-017-TRAM',
  19,
  '["español", "inglés"]'::jsonb,
  '["Cirugía de Columna", "Fracturas Complejas"]'::jsonb,
  false,
  true,
  NOW()
),

-- 18. DRA. VICTORIA BRAVO CAMPOS - Alergología e Inmunología
('Victoria', 'Bravo', 'Campos',
  (SELECT id FROM cat_especialidades WHERE nombre = 'Alergología' LIMIT 1),
  'MED-018-ALER',
  15,
  '["español", "inglés"]'::jsonb,
  '["Asma y Alergia", "Inmunoterapia"]'::jsonb,
  true,
  true,
  NOW()
),

-- 19. DR. FRANCISCO CHAVEZ RIVERA - Reumatología
('Francisco', 'Chavez', 'Rivera',
  (SELECT id FROM cat_especialidades WHERE nombre = 'Reumatología' LIMIT 1),
  'MED-019-REUM',
  17,
  '["español", "inglés"]'::jsonb,
  '["Artritis Reumatoide", "Lupus Eritematoso"]'::jsonb,
  true,
  true,
  NOW()
),

-- 20. DRA. NORMA SANTOS PEREZ - Geriatría
('Norma', 'Santos', 'Perez',
  (SELECT id FROM cat_especialidades WHERE nombre = 'Geriatría' LIMIT 1),
  'MED-020-GERI',
  23,
  '["español", "inglés"]'::jsonb,
  '["Cuidados del Adulto Mayor", "Demencia"]'::jsonb,
  true,
  true,
  NOW()
);

-- ============================================================================
-- VERIFICACIÓN
-- ============================================================================
SELECT COUNT(*) as total_medicos,
       COUNT(DISTINCT especialidad_id) as especialidades_unicas
FROM medicos
WHERE cedula_profesional LIKE 'MED-%';

-- Resultado esperado: 20 médicos, 15+ especialidades
-- ============================================================================
