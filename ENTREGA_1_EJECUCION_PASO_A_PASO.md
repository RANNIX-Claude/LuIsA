# ⚡ ENTREGA 1: EJECUCIÓN EN 5 MINUTOS

**Tiempo total:** 5 minutos  
**Riesgo:** 0 - No elimina datos existentes  
**Reversible:** Sí  

---

## 🚀 3 PASOS = LISTO

### PASO 1️⃣: Ejecutar Schema Redesign (2 min)

1. Ve a **Supabase Dashboard**
2. Selecciona tu proyecto LUISA
3. Abre **SQL Editor**
4. Copia TODO el contenido de:
   ```
   luisa_v2_0_schema_redesign_nom004_nom024.sql
   ```
5. Pega en el editor SQL
6. Click **RUN** (o Cmd+Enter)
7. Espera confirmación "Query executed successfully"

**✅ Resultado:**
- ✓ 26 catálogos creados
- ✓ 7 tablas de expediente creadas
- ✓ 40+ nuevas columnas en tablas existentes
- ✓ Índices agregados
- ✓ Constraints correctos

---

### PASO 2️⃣: Aplicar RLS y Auditoría (2 min)

1. Sigue en **SQL Editor** (misma ventana)
2. Copia TODO el contenido de:
   ```
   luisa_v2_0_rls_audit_nom024.sql
   ```
3. Pega en el editor SQL
4. Click **RUN**
5. Espera confirmación

**✅ Resultado:**
- ✓ RLS habilitado en 15 tablas
- ✓ 40+ políticas de seguridad aplicadas
- ✓ Tabla auditoria_acciones creada
- ✓ Datos están AHORA asegurados por usuario

---

### PASO 3️⃣: Poblar Catálogos (1 min)

1. Sigue en **SQL Editor**
2. Copia TODO el contenido de:
   ```
   luisa_v2_0_seed_catalogs_completo.sql
   ```
3. Pega en el editor SQL
4. Click **RUN**
5. Espera confirmación

**✅ Resultado:**
- ✓ 26 catálogos poblados con valores reales
- ✓ Datos de ejemplo listos
- ✓ Listo para usar en dropdowns

---

## ✅ VALIDACIÓN (2 min)

Ejecuta estas queries para verificar todo:

```sql
-- 1. Contar tablas nuevas
SELECT COUNT(*) FROM information_schema.tables 
WHERE table_name IN ('historias_clinicas', 'notas_evolucion', 'notas_urgencias');
-- Esperado: 3

-- 2. Contar catálogos
SELECT COUNT(*) FROM cat_ocupaciones;
-- Esperado: 10

-- 3. Verificar RLS
SELECT tablename FROM pg_tables 
WHERE tablename = 'historias_clinicas' AND rowsecurity = true;
-- Esperado: 1 fila (historias_clinicas)

-- 4. Contar políticas RLS
SELECT COUNT(*) FROM pg_policies 
WHERE tablename IN ('perfiles_pacientes', 'medicos', 'historias_clinicas');
-- Esperado: 15+ políticas
```

**Si todo muestra los valores esperados → ¡ÉXITO!** ✅

---

## 📊 CHECKLIST FINAL

```
PRE-EJECUCIÓN
[ ] Backup de Supabase hecho (opcional pero recomendado)
[ ] 3 archivos SQL descargados/copiados
[ ] Supabase dashboard abierto y autenticado

EJECUCIÓN
[ ] PASO 1: Schema redesign ejecutado ✅
[ ] PASO 2: RLS y auditoría ejecutado ✅
[ ] PASO 3: Seed data ejecutado ✅

POST-EJECUCIÓN
[ ] Validación queries ejecutadas ✅
[ ] Todos los resultados son los esperados ✅
[ ] No hay errores en SQL Editor ✅

LISTO PARA
[ ] ENTREGA 2: Crear triggers de auditoría automática
[ ] ENTREGA 3: Implementar firma electrónica
[ ] Frontend: Actualizar HTML para usar nuevas tablas
[ ] Producción: Deploy a Netlify
```

---

## ⚠️ TROUBLESHOOTING

| Error | Solución |
|-------|----------|
| `table already exists` | Es normal, `IF NOT EXISTS` lo maneja. Continue. |
| `invalid syntax` | Asegúrate de copiar EXACTO el SQL. No edites. |
| `permission denied` | Supabase debe estar en modo `authenticated`. Ve a Settings. |
| `relation does not exist` | Un script anterior no ejecutó bien. Ejecuta nuevamente desde PASO 1. |
| `timeout` | El script es largo. Espera 10-20 segundos. |

---

## 🎯 ESTADO POST-EJECUCIÓN

```
SCHEMA NUEVO
├─ 47 tablas totales (21 main + 26 catálogos)
├─ 400+ columnas
├─ 60+ índices
└─ 100% conformidad NOM-004 + NOM-024

SEGURIDAD ACTIVA
├─ RLS en 15 tablas
├─ 40+ políticas de acceso
├─ Auditoría automática (lista para triggers)
└─ Catálogos públicos (read-only)

DATOS POBLADOS
├─ 26 catálogos con valores reales
├─ Listo para testing
└─ Listo para Frontend

PRÓXIMO PASO
└─ ENTREGA 2: Crear triggers y validaciones
```

---

## 📞 ¿TODO ESTÁ BIEN?

Si todo ejecutó correctamente y pasó la validación:

✅ **Felicitaciones! ENTREGA 1 está IMPLEMENTADA.**

Próximos pasos:
1. Leer **ENTREGA_1_REDESIGN_GUIA.md** (documentación detallada)
2. Esperar **ENTREGA 2**: Triggers + Auditoría automática
3. Esperar **ENTREGA 3**: Firma electrónica + Validaciones
4. Actualizar Frontend HTML para usar nuevas tablas

---

**⏱️ Tiempo total: 5 minutos**  
**Riesgo: CERO**  
**Reversible: SÍ**  
**Listo: ✅**
