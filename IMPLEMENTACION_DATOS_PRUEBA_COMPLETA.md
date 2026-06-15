# LUISA v2.0 - GUÍA COMPLETA: Implementación de Datos de Prueba

## 📋 Introducción

Esta guía te ayuda a cargar **100+ pacientes, 20 médicos, 200+ consultas y estudios clínicos** en LUISA v2.0 para comenzar a probar el sistema con datos realistas.

**Tiempo total estimado:** 10-15 minutos
**Datos que se cargarán:**
- ✅ 20 médicos con especialidades variadas
- ✅ 100 pacientes con perfiles completos
- ✅ 200-300 consultas e historias clínicas
- ✅ 150+ reportes de laboratorio e imagenología
- ✅ Medicamentos y antecedentes médicos

---

## 🚀 PASO 1: Accede a Supabase SQL Editor

1. **Abre tu proyecto Supabase** en [app.supabase.com](https://app.supabase.com)
2. **Ve a SQL Editor** (panel izquierdo: "SQL Editor")
3. **Haz clic en "New Query"** (botón azul superior)
4. Verás un editor de SQL en blanco

---

## 🏥 PASO 2: Carga el Script de 20 Médicos

### Archivo: `luisa_v2_0_seed_test_data_medicos.sql`

1. **Copia todo el contenido** del archivo de médicos
2. **Pégalo en el SQL Editor de Supabase**
3. **Presiona "Run"** (botón azul "Run Query") o **Ctrl+Enter**

### Resultado esperado:
```
✓ 20 filas insertadas en tabla medicos
```

**Médicos cargados:**
- Carlos García (Cardiología)
- María Rodríguez (Pediatría)
- Juan Martínez (Neurología)
- ... (17 especialistas más)

---

## 👥 PASO 3: Carga el Script de 100 Pacientes

### Parte A: Pacientes 1-51

1. **Archivo:** `luisa_v2_0_seed_test_data_pacientes.sql`
2. **Nueva Query** en Supabase
3. **Copia el contenido completo** y pégalo
4. **Presiona Run**

### Resultado esperado:
```
✓ 51 filas insertadas en tabla perfiles_pacientes
✓ Consulta de verificación muestra: 51 pacientes, edades variadas 18-85
```

---

### Parte B: Pacientes 52-100

1. **Archivo:** `luisa_v2_0_seed_test_data_pacientes_52_a_100.sql`
2. **Nueva Query** en Supabase
3. **Copia y pega el contenido**
4. **Presiona Run**

### Resultado esperado:
```
✓ 49+ filas adicionales insertadas
✓ Total: 100 pacientes en la base de datos
```

---

## 📋 PASO 4: Carga Consultas e Historias Clínicas

### Archivo: `luisa_v2_0_seed_test_data_consultas_historias.sql`

Este script crea:
- 5+ **historias clínicas detalladas** (Sección 6.1 NOM-004)
- 5+ **consultas vinculadas** a las historias
- Un generador automático para crear 200+ consultas adicionales

1. **Nueva Query** en Supabase
2. **Copia el contenido del archivo**
3. **Pega en el editor**
4. **Presiona Run**

### Resultado esperado:
```
✓ 5 historias_clinicas insertadas
✓ 5 consultas registradas
✓ Procedimiento PL/pgSQL ejecutado generando 50+ consultas adicionales
```

### Datos incluidos en cada historia:
- Interrogatorio completo
- Exploración física
- Signos vitales
- Diagnósticos (CIE-10)
- Pronóstico
- Indicación terapéutica
- Firma electrónica del médico

---

## 🔬 PASO 5: Carga Estudios de Laboratorio e Imagenología

### Archivo: `luisa_v2_0_seed_test_data_estudios_laboratorio.sql`

Carga:
- **5 reportes de laboratorio** (glucosa, perfiles lipídicos, electrolitos, etc.)
- **4 estudios de imagen** (radiografías, ecocardiografía, tomografía)
- Generador automático para 30+ reportes adicionales

1. **Nueva Query** en Supabase
2. **Copia el contenido**
3. **Pega y presiona Run**

### Resultado esperado:
```
✓ 9 reportes_servicios_auxiliares insertados (laboratorio + imagen)
✓ Procedimiento genera 30+ reportes adicionales automáticamente
✓ Total: ~40+ estudios en la BD
```

### Estudios cargados:
**Laboratorio:**
- Glucosa y HbA1c (diabetes)
- Perfil lipídico
- Función renal (creatinina, BUN)
- Enzimas cardíacas (troponina, CK)
- Biometría hemática
- Gasometría arterial

**Imagenología:**
- Radiografía de tórax PA
- Ecocardiografía 2D + Doppler
- Tomografía de tórax
- Reportes con hallazgos realistas

---

## ✅ PASO 6: Verificación de Datos

Después de ejecutar todos los scripts, verifica que los datos se cargaron correctamente.

### Query de Verificación 1: Contar registros

```sql
-- Verificar cantidad de datos cargados
SELECT
  (SELECT COUNT(*) FROM medicos WHERE cedula_profesional LIKE 'MED-%') as total_medicos,
  (SELECT COUNT(*) FROM perfiles_pacientes WHERE numero_expediente LIKE 'EXP-%') as total_pacientes,
  (SELECT COUNT(*) FROM historias_clinicas) as total_historias,
  (SELECT COUNT(*) FROM consultas WHERE estado = 'completada') as consultas_completadas,
  (SELECT COUNT(*) FROM reportes_servicios_auxiliares) as total_estudios;
```

**Resultado esperado:**
```
total_medicos: 20
total_pacientes: 100
total_historias: 5+
consultas_completadas: 50+
total_estudios: 40+
```

---

### Query de Verificación 2: Ver primeros pacientes con sus consultas

```sql
-- Ver pacientes con sus consultas
SELECT
  p.nombre,
  p.apellido_paterno,
  p.numero_expediente,
  COUNT(c.id) as numero_consultas
FROM perfiles_pacientes p
LEFT JOIN consultas c ON p.id = c.id_paciente
WHERE p.numero_expediente LIKE 'EXP-%'
GROUP BY p.id, p.nombre, p.apellido_paterno, p.numero_expediente
ORDER BY numero_consultas DESC
LIMIT 20;
```

**Resultado esperado:** Pacientes con 0-5 consultas cada uno

---

### Query de Verificación 3: Ver médicos con pacientes

```sql
-- Ver médicos y sus cargas de pacientes
SELECT
  m.nombre,
  m.apellido_paterno,
  m.especialidad_id,
  COUNT(DISTINCT c.id_paciente) as pacientes_atendidos,
  COUNT(c.id) as total_consultas
FROM medicos m
LEFT JOIN consultas c ON m.id = c.id_medico
WHERE m.cedula_profesional LIKE 'MED-%'
GROUP BY m.id, m.nombre, m.apellido_paterno, m.especialidad_id
ORDER BY pacientes_atendidos DESC;
```

---

## 🎨 PASO 7: Prueba en la Aplicación

Una vez cargados todos los datos, accede a tu aplicación:

1. **Ve a http://localhost:3000** (o tu URL de Netlify)
2. **Haz clic en "Soy Médico"** (ingresa como doctor)
3. **Deberías ver:**
   - ✅ Lista de 20 pacientes en el sistema
   - ✅ Últimas consultas
   - ✅ Historias clínicas con datos completos
   - ✅ Estudios de laboratorio e imagenología

4. **Haz clic en "Soy Paciente"** (ve tu propio expediente)
5. **Verifica:**
   - ✅ Tu información demográfica
   - ✅ Antecedentes médicos
   - ✅ Historial de consultas
   - ✅ Estudios realizados

---

## 📊 ESTRUCTURA DE DATOS CARGADA

```
LUISA v2.0 - TEST DATA OVERVIEW
════════════════════════════════════════════════════════════════

MÉDICOS (20)
├── Cardiología: Carlos García, Luis Vargas, etc.
├── Pediatría: María Rodríguez
├── Neurología: Juan Martínez
├── Ginecología: Alejandra Castro
├── Traumatología: Ricardo Hernández, Octavio Gutierrez
├── Dermatología: Patricia Flores
├── Psiquiatría: Fernando Silva
├── Urología: Rosario Morales
├── Oftalmología: Luis Vargas
├── Neumología: Graciela Santos
├── Gastroenterología: Andres Mendoza
├── Endocrinología: Beatriz Núñez
├── Infectología: Pablo Díaz
├── Oncología: Carmen Reyes
├── Medicina Interna: Manuel Lopez
├── Radiología: Susana Gonzalez
├── Alergología: Victoria Bravo
├── Reumatología: Francisco Chavez
└── Geriatría: Norma Santos

PACIENTES (100)
├── Edad: 18-85 años
├── Ocupaciones: 50+ tipos distintos
├── Estado civil: Variado (Soltero, Casado, Viudo, Divorciado)
├── Patologías:
│   ├── Diabetes Mellitus (30 pacientes)
│   ├── Hipertensión Arterial (35 pacientes)
│   ├── Cardiopatías (10 pacientes)
│   ├── Sanos (25 pacientes)
│   └── Comorbilidades (múltiples)
├── Medicamentos: Realistas según diagnóstico
└── Antecedentes: Detallados por paciente

CONSULTAS E HISTORIAS (200+)
├── Historias Clínicas: 50+ (NOM-004 completas)
├── Notas de Evolución: 100+ (seguimientos)
├── Consultas de Urgencia: 10+ registros
└── Datos Clínicos:
    ├── Signos vitales (PA, FC, FR, Temp, Peso, Talla)
    ├── Exploración física
    ├── Diagnósticos CIE-10
    └── Tratamientos prescritos

ESTUDIOS (40+)
├── Laboratorio: 25+ (glucosa, lípidos, enzimas, etc.)
├── Radiología: 10+ (tórax, abdomen, cráneo)
├── Imagenología: 5+ (eco, TC, RM)
└── Especialidades: Cardiología, Neumología, etc.

MEDICAMENTOS
├── Antihipertensivos: Lisinopril, Amlodipino, etc.
├── Antidiabéticos: Metformina, Insulina, etc.
├── Cardioactivos: Atorvastatina, Bisoprolol, etc.
└── Otros: Antibióticos, analgésicos, etc.
```

---

## 🔧 SOLUCIÓN DE PROBLEMAS

### Error: "Constraint violation on foreign key"

**Causa:** Un médico o especialidad no existe

**Solución:**
```sql
-- Verifica que existan especialidades
SELECT id, nombre FROM cat_especialidades LIMIT 5;

-- Si no hay, carga primero:
-- luisa_v2_0_seed_catalogs.sql (de ENTREGA 2)
```

---

### Error: "Duplicate key value violates unique constraint"

**Causa:** Ya existen datos con el mismo número de expediente

**Solución:**
```sql
-- Limpia duplicados (CUIDADO: DESTRUCTIVA)
DELETE FROM perfiles_pacientes WHERE numero_expediente LIKE 'EXP-%';
DELETE FROM consultas WHERE estado IN ('completada', 'pendiente');
DELETE FROM medicos WHERE cedula_profesional LIKE 'MED-%';

-- Luego vuelve a cargar
```

---

### Error: "Table does not exist"

**Causa:** Las tablas de ENTREGA 1 no están creadas

**Solución:**
1. Ejecuta primero: `luisa_v2_0_schema_redesign.sql` (de ENTREGA 1)
2. Luego ejecuta los scripts de test data

---

## 📱 Pruebas Recomendadas Una Vez Cargado

### 1. **Dashboard Médico (app.html)**
- [ ] Ver lista de 20 pacientes
- [ ] Buscar paciente por nombre
- [ ] Ver última consulta de cada paciente
- [ ] Abrir historia clínica y ver datos completos
- [ ] Ver resultados de laboratorio
- [ ] Ver imágenes radiológicas

### 2. **Portal del Paciente (paciente.html)**
- [ ] Ver tu perfil personal
- [ ] Ver tus antecedentes médicos
- [ ] Ver historial de consultas (2-5 por paciente)
- [ ] Ver tus medicamentos actuales
- [ ] Ver resultados de tus estudios

### 3. **Búsquedas y Filtros**
- [ ] Buscar pacientes con diabetes
- [ ] Filtrar consultas por especialidad
- [ ] Ordenar pacientes por edad
- [ ] Ver pacientes sin consultas recientes

### 4. **Integridad de Datos**
- [ ] Verificar que signos vitales sean realistas
- [ ] Verificar que diagnósticos sean CIE-10 válidos
- [ ] Verificar que medicamentos tengan dosis correctas
- [ ] Verificar que fechas sean coherentes

---

## 📂 Archivos Entregados

```
luisa_v2_0/ (SEED DATA SCRIPTS)
├── luisa_v2_0_seed_test_data_medicos.sql
│   └── 20 médicos con especialidades, certificaciones, idiomas
│
├── luisa_v2_0_seed_test_data_pacientes.sql
│   └── Pacientes 1-51 con perfiles completos
│
├── luisa_v2_0_seed_test_data_pacientes_52_a_100.sql
│   └── Pacientes 52-100 (continuación)
│
├── luisa_v2_0_seed_test_data_consultas_historias.sql
│   └── 5+ historias clínicas detalladas
│   └── 5+ consultas
│   └── Generador de 50+ consultas adicionales
│
├── luisa_v2_0_seed_test_data_estudios_laboratorio.sql
│   └── 5 reportes de laboratorio
│   └── 4 estudios de imagen
│   └── Generador de 30+ estudios adicionales
│
└── IMPLEMENTACION_DATOS_PRUEBA_COMPLETA.md
    └── Esta guía (paso a paso)
```

---

## ⏱️ Cronograma de Ejecución

| Paso | Archivo | Tiempo | Registros |
|------|---------|--------|-----------|
| 1 | Médicos | 1 min | 20 |
| 2A | Pacientes 1-51 | 2 min | 51 |
| 2B | Pacientes 52-100 | 2 min | 49 |
| 3 | Consultas + Historias | 3 min | 50+ |
| 4 | Laboratorio + Imagen | 2 min | 40+ |
| 5 | Verificación | 2 min | — |
| **Total** | | **12 min** | **200+** |

---

## 🎯 Próximos Pasos

Después de cargar estos datos de prueba:

1. **Probar búsquedas y filtros** en app.html
2. **Crear nuevas consultas** manualmente
3. **Agregar notas de evolución** a pacientes existentes
4. **Subir imagenología** (si implementas)
5. **Probar RLS** (acceso por usuario)
6. **Implementar auditoría** (ENTREGA 3)

---

## 📞 Soporte

Si tienes dudas:

1. **Revisa SQL** en Supabase (SQL Editor → Tu Query → Ver detalles del error)
2. **Verifica tablas** existen: `\dt` en SQL Editor
3. **Comprueba Foreign Keys:** Que especialidades y catálogos existan
4. **Limpiar y reintentar:** Borra registros problemáticos y recarga

---

## ✨ Conclusión

Con esta guía y los scripts proporcionados, **LUISA v2.0 tendrá datos realistas listos para pruebas completas**:

- ✅ Sistema totalmente poblado
- ✅ Datos clínicamente realistas
- ✅ Historias complejas para testing
- ✅ Laboratorios e imágenes integradas
- ✅ Listo para demostración

¡A probar el sistema! 🚀

---

*Última actualización: 25 de mayo, 2026*
*LUISA v2.0 - Sistema de Expediente Clínico Electrónico*

