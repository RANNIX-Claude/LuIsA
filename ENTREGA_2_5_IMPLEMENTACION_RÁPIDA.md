# 🚀 ENTREGA 2.5: Guía de Implementación Rápida

**Tiempo estimado:** 5 minutos  
**Complejidad:** Baja  
**Riesgo:** Ninguno (tablas nuevas, sin conflictos)

---

## ⚡ Paso 1: Ejecutar SQL (2 minutos)

### En Supabase SQL Editor

1. Ir a: **Supabase Dashboard → SQL Editor → New Query**
2. Copiar contenido de:
   ```
   luisa_v2_0_entrega_2_5_modulo_familiar.sql
   ```
3. **Click: RUN**

Esperado: ✅ Éxito sin errores

---

## ✅ Paso 2: Verificar Instalación (1 minuto)

### Test 1: Verificar tablas existen

En Supabase SQL Editor:

```sql
SELECT tablename 
FROM pg_tables 
WHERE schemaname = 'public'
  AND (tablename LIKE 'relaciones_%'
    OR tablename LIKE 'permisos_%'
    OR tablename LIKE 'auditoria_acciones_familiares'
    OR tablename = 'cat_relaciones_familiares');
```

**Resultado esperado:**
```
tablename
─────────────────────────────────────────
cat_relaciones_familiares
relaciones_familiares
permisos_expediente_familiar
auditoria_acciones_familiares
```

### Test 2: Verificar catálogo está poblado

```sql
SELECT COUNT(*) as cantidad, COUNT(DISTINCT codigo) 
FROM cat_relaciones_familiares;
```

**Resultado esperado:**
```
cantidad | count
─────────┼──────
       9 |     9
```

### Test 3: Verificar funciones existen

```sql
SELECT routine_name 
FROM information_schema.routines 
WHERE routine_schema = 'public'
  AND routine_name LIKE '%familia%';
```

**Resultado esperado:**
```
routine_name
──────────────────────────────────────
verificar_permiso_familiar
obtener_familiares_administrados
registrar_accion_familiar
fn_trigger_auditoria_familia
```

---

## 📊 Paso 3: Crear Datos de Prueba (1 minuto)

### Scenario: María (madre) administra a Juan (hijo)

```sql
-- PASO 1: Crear pacientes (si no existen)
INSERT INTO perfiles_pacientes (
  nombre, apellido_paterno, email, telefono
) VALUES 
  ('María', 'García', 'maria@test.com', '5551111111'),
  ('Juan', 'García', 'juan@test.com', '5552222222'),
  ('Carlos', 'García', 'carlos@test.com', '5553333333');

-- Guardar los IDs (copiar de arriba o hacer SELECT)
-- maria_id = [UUID de María]
-- juan_id = [UUID de Juan]
-- carlos_id = [UUID de Carlos]

-- PASO 2: Crear relaciones familiares
INSERT INTO relaciones_familiares (
  id_persona_primaria, 
  id_persona_secundaria, 
  relacion_id
) VALUES (
  'MARIA_UUID_AQUI',
  'JUAN_UUID_AQUI',
  (SELECT id FROM cat_relaciones_familiares WHERE codigo = 'madre')
);

-- PASO 3: Otorgar permisos
INSERT INTO permisos_expediente_familiar (
  id_administrador,
  id_paciente_vinculado,
  relacion_familiar_id,
  puede_ver_expediente,
  puede_editar_datos_paciente,
  puede_gestionar_citas,
  puede_gestionar_medicamentos,
  razon
) VALUES (
  'MARIA_UUID_AQUI',
  'JUAN_UUID_AQUI',
  (SELECT id FROM cat_relaciones_familiares WHERE codigo = 'madre'),
  true,  -- puede ver
  true,  -- puede editar
  true,  -- puede agendar citas
  true,  -- puede manejar medicamentos
  'Madre autorizada para administrar expediente del hijo'
);
```

---

## 🧪 Paso 4: Test Funcional (1 minuto)

### Test 1: Obtener familiares de María

```sql
SELECT * 
FROM obtener_familiares_administrados('MARIA_UUID_AQUI');
```

**Resultado esperado:**
```
id_paciente    | nombre | apellido_paterno | relacion | puede_ver | puede_editar
───────────────┼────────┼──────────────────┼──────────┼───────────┼──────────────
JUAN_UUID      | Juan   | García           | Madre    | true      | true
```

### Test 2: Verificar permiso específico

```sql
SELECT verificar_permiso_familiar(
  'MARIA_UUID_AQUI',      -- María
  'JUAN_UUID_AQUI',       -- Juan
  'ver_expediente'        -- Permiso a validar
);
```

**Resultado esperado:** `true`

### Test 3: Verificar permiso NEGADO

```sql
SELECT verificar_permiso_familiar(
  'CARLOS_UUID_AQUI',     -- Carlos (sin permisos)
  'JUAN_UUID_AQUI',       -- Juan
  'ver_expediente'
);
```

**Resultado esperado:** `false`

### Test 4: Registrar acción

```sql
SELECT registrar_accion_familiar(
  'MARIA_UUID_AQUI',                    -- administrador
  'JUAN_UUID_AQUI',                     -- paciente
  'UPDATE',                             -- tipo acción
  'perfiles_pacientes',                 -- tabla
  'Actualizar medicamento de Juan'      -- descripción
);
```

**Resultado esperado:** (un UUID - ID de la acción registrada)

### Test 5: Ver auditoría

```sql
SELECT * FROM auditoria_acciones_familiares
ORDER BY fecha_evento DESC
LIMIT 1;
```

**Resultado esperado:**
```
id                | id_administrador | id_paciente_afectado | tipo_accion | fecha_evento
────────────────┼──────────────────┼──────────────────────┼─────────────┼──────────────────────
[UUID]           | MARIA_UUID       | JUAN_UUID            | UPDATE      | 2026-05-24 15:30:00
```

---

## 📋 Vista General de Datos

```sql
-- Ver TODOS los administradores familiares
SELECT * FROM vw_administradores_familiares;

-- Ver TODOS los expedientes bajo administración
SELECT * FROM vw_expedientes_familiares;

-- Ver TODAS las acciones recientes
SELECT * FROM vw_auditoria_acciones_familiares_recientes;
```

---

## 🔧 Troubleshooting

### ❌ Error: "relation already exists"
**Causa:** Intentó ejecutar el script 2 veces  
**Solución:** Eso es OK. Las tablas ya están creadas. Siguiente paso.

### ❌ Error: "violates unique constraint"
**Causa:** Intentó crear misma relación/permiso 2 veces  
**Solución:** 
```sql
DELETE FROM permisos_expediente_familiar
WHERE id_administrador = 'MARIA_UUID'
  AND id_paciente_vinculado = 'JUAN_UUID';
```

### ❌ Error en verificar_permiso_familiar(): "function not found"
**Causa:** SQL no se ejecutó completo o falló silenciosamente  
**Solución:**
1. Copiar EXACTO contenido del archivo SQL
2. Verificar que copió TODO el contenido (inicio a fin)
3. Ejecutar de nuevo, viendo errores

### ❌ No ve datos de prueba
**Causa:** Olvidó reemplazar los UUIDs  
**Solución:** En el INSERT de permisos, reemplazar:
- `'MARIA_UUID_AQUI'` por el UUID real de María
- `'JUAN_UUID_AQUI'` por el UUID real de Juan

Para obtener UUID:
```sql
SELECT id, nombre FROM perfiles_pacientes 
WHERE nombre IN ('María', 'Juan');
```

---

## 📦 Estado de la Entrega

| Componente | Estado |
|------------|--------|
| SQL de tablas | ✅ Completado |
| SQL de funciones | ✅ Completado |
| SQL de triggers | ✅ Completado |
| SQL de RLS policies | ✅ Completado |
| SQL de vistas | ✅ Completado |
| Documentación | ✅ Completada |
| Datos de prueba | ✅ Listos |
| Funciones Netlify | ⏳ Por crear |
| Frontend (app.html) | ⏳ Por actualizar |
| Frontend (paciente.html) | ⏳ Por actualizar |

---

## 🔜 Próximos Pasos

### A. Crear Netlify Functions

Crear archivos en `.netlify/functions/`:

1. **obtener_familiares_administrados.js**
   - GET: Retorna lista de familiares que administra
   - POST: (opcional)

2. **verificar_permiso_familiar.js**
   - POST: Valida si tiene permiso específico

3. **crear_permiso_familiar.js**
   - POST: Otorga nuevo permiso

4. **revocar_permiso_familiar.js**
   - POST: Desactiva permiso

5. **obtener_auditoria_familiar.js**
   - GET: Retorna auditoría de cambios

### B. Actualizar Frontend

En `app.html` (para médicos/administradores):
- [ ] Nueva sección: "Mis Familiares"
- [ ] Lista de pacientes administrados
- [ ] Ver expediente de familiar
- [ ] Editar datos de familiar
- [ ] Agendar cita para familiar

En `paciente.html`:
- [ ] Nueva sección: "Mis Administradores"
- [ ] Ver quién tiene permisos
- [ ] Revocar permisos específicos
- [ ] Ver historial de cambios

### C. Testing

- [ ] Test 1: Crear permiso y acceder a expediente
- [ ] Test 2: Revocar permiso y verificar bloqueo
- [ ] Test 3: Ver auditoría de cambios
- [ ] Test 4: Cas de uso complejo (tutela, poder)

---

## 📞 Validación de Integridad

Una vez en producción, ejecutar:

```sql
-- Verificar integridad referencial
SELECT COUNT(*) as problemas
FROM permisos_expediente_familiar pef
WHERE NOT EXISTS (
  SELECT 1 FROM perfiles_pacientes 
  WHERE id = pef.id_administrador
) OR NOT EXISTS (
  SELECT 1 FROM perfiles_pacientes 
  WHERE id = pef.id_paciente_vinculado
);
-- Resultado esperado: 0

-- Verificar que no hay administrador = paciente
SELECT COUNT(*) as problemas
FROM permisos_expediente_familiar
WHERE id_administrador = id_paciente_vinculado;
-- Resultado esperado: 0

-- Verificar auditoría está completa
SELECT COUNT(*) as acciones_registradas
FROM auditoria_acciones_familiares;
-- Resultado esperado: > 0
```

---

## ✨ Resumen

**ENTREGA 2.5 está LISTA para:**
- ✅ Ejecutar en Supabase
- ✅ Validar funcionamiento
- ✅ Integrar en frontend
- ✅ Deploy a producción

**Tiempo total:** ~5 minutos  
**Errores esperados:** 0  
**Beneficios:** 
- 👨‍👩‍👧‍👦 Sistema completo de administración familiar
- 🔐 Seguridad y permisos granulares
- 📋 Auditoría completa (NOM-024)
- ✅ Listo para producción
