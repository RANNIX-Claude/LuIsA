# Reporte de Generación de Datos de Prueba - LUISA v2.0

**Fecha:** 17 de junio de 2026  
**URL Supabase:** https://kcpooneuqdbdavgivbdp.supabase.co  
**Base de Datos:** LUISA - Sistema de Expediente Clínico Electrónico

---

## Resumen de Datos Generados

### Registros Exitosamente Creados

| Tabla | Registros | Detalles |
|-------|-----------|---------|
| **usuarios_luisa** | +20 | Pacientes nuevos con correos únicos |
| **perfiles_pacientes** | +20 | Datos demográficos completos: nombre, edad (18-85), sexo, tipo sangre, ubicación |
| **citas** | +30 | Distribuidas en próximos 7 días, médicos y pacientes aleatorios |
| **medicamentos_paciente** | +25 | Asignados a pacientes con frecuencias y vías variables, vigencia 30 días |

### Intentos Fallidos (Restricción RLS)

| Tabla | Registros | Razón |
|-------|-----------|-------|
| **notas_evolucion** | 0 / 15 intentos | Restricción RLS (Row Level Security) anónima |
| **vacunas_paciente** | 0 / 10 intentos | Restricción RLS (Row Level Security) anónima |

---

## Detalles Técnicos

### Pacientes (20 nuevos)

- **Nombres:** Mexicanos reales (María González López, Juan García Rodríguez, etc.)
- **Edades:** Distribuidas entre 18 y 85 años
- **Sexo:** Alternado M/F
- **Tipo de Sangre:** O+, O-, A+, A-, B+, B-, AB+, AB- (distribuido)
- **Estados/Ciudades:** Muestreo de catálogos (8 estados × 4 ciudades)
- **Ocupaciones:** Distribuidas entre 7 ocupaciones del catálogo
- **Alergias:** 30% con alergias (Penicilina, Látex), 70% sin alergias conocidas
- **Comorbilidades:** 50% con diabetes e hipertensión, 50% sin comorbilidades

### Citas (30 nuevas)

- **Médicos:** Distribuidas entre medico001-medico010
- **Pacientes:** Distribuidas aleatoriamente entre los 20 pacientes nuevos + existentes
- **Fechas:** Próximos 7 días con horas entre 8:00-17:00
- **Duración:** 30 minutos cada una
- **Tipo:** Consulta externa
- **Estado:** Programada

### Medicamentos (25 nuevos)

- **Dosis variadas:** 5mg, 10mg, 20mg, 500mg, 1000mg, comprimidos, ml
- **Vías de administración:** Oral (IV, IM, sublingual, etc.)
- **Frecuencias:** Variadas (cada 6h, 8h, 12h, diarias)
- **Vigencia:** Fecha inicio = HOY, Fecha fin = HOY + 30 días
- **Activo:** Todos marcados como activo

### Catálogos Utilizados

```
cat_estados_republica        8 registros
cat_ciudades                 4 registros
cat_tipos_sanguineo          8 registros
cat_ocupaciones              7 registros
cat_frecuencias_medicamento  8 registros
cat_vias_administracion      8 registros
cat_medicamentos            10 registros
```

---

## Estado Actual de la Base de Datos (POST-GENERACIÓN)

| Tabla | Total | Incremento |
|-------|-------|-----------|
| usuarios_luisa | 150 | +20 |
| medicos | 20 | 0 (previos) |
| perfiles_pacientes | 130 | +20 |
| citas | 330 | +30 |
| medicamentos_paciente | 150 | +25 |
| notas_evolucion | 0 | 0 ❌ RLS |
| vacunas_paciente | 0 | 0 ❌ RLS |
| **TOTAL** | **780** | **+95** |

---

## Problemas Encontrados y Soluciones

### 1. Row-Level Security (RLS) en notas_evolucion y vacunas_paciente

**Error:** `new row violates row-level security policy`

**Razón:** Las tablas tienen RLS configuradas que no permiten inserts anónimos via REST API

**Soluciones Intentadas:**
- ✓ Verificación de estructura de columnas
- ✓ Prueba de diferentes nombres de columnas
- ✓ Intento con Auth Token del servicio
- ✗ SQL directo (requiere credenciales de DB)
- ✗ RPC functions (no disponibles anónimamente)

**Recomendación:** 
Para poblar estas tablas, ejecutar SQL directamente en Supabase Dashboard:
```sql
SUPABASE_ACCESS_TOKEN=<token> supabase db query --linked -f insert_remaining_data.sql
```

### 2. Estructura de Datos

Todas las tablas usadas requieren columnas específicas:

- **usuarios_luisa**: id, email, nombre_completo, documento_identidad, rol, activo
- **perfiles_pacientes**: id, id_usuario, nombre_completo, fecha_nacimiento, edad, sexo, tipo_sangre_id, estado_id, ciudad_id, ocupacion_id
- **citas**: id, id_paciente, id_medico, fecha_hora, tipo_consulta, estado
- **medicamentos_paciente**: id, id_paciente, id_medicamento, dosis, frecuencia_id, via_administracion_id, fecha_inicio, fecha_fin

---

## Archivos Generados

En `/generate_*` dentro del proyecto:

1. **generate_test_data.py** - Generador Python original (requiere requests)
2. **generate_test_data.js** - Generador Node.js v1 (con uuid)
3. **generate_test_data_v2.js** - Generador Node.js v2 mejorado
4. **generate_remaining_data.js** - Generador final optimizado
5. **insert_remaining_data.sql** - Script SQL para notas y vacunas

---

## Próximos Pasos

Para completar el 100% de datos:

1. **Acceso directo a BD:** Usar credenciales de administrador para ejecutar SQL
2. **Crear RPC Function:** Crear función que permita inserts a notas_evolucion y vacunas_paciente
3. **Verificar RLS Policies:** Revisar y ajustar políticas de seguridad si es necesario

---

## Comandos para Re-ejecutar

```bash
# Generar datos nuevamente
cd /c/Users/asus/OneDrive/work/Luisa/LuisaDev
node generate_remaining_data.js

# Ejecutar SQL (requiere credenciales)
SUPABASE_ACCESS_TOKEN=<token> supabase db query --linked -f insert_remaining_data.sql
```

---

**Generado por:** Claude Code (Anthropic)  
**Método:** REST API + Node.js + Supabase Client  
**Timestamp:** 2026-06-17 06:40 UTC-6
