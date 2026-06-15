# 🚀 LIGIA v2.0 — Guía de Deploy a Netlify

**Fecha de versión:** 2026-05-26
**Sitio actual:** https://fantastic-crumble-0fea1f.netlify.app
**Supabase:** https://isxspjlwuzbbtpamkknq.supabase.co

---

## ✅ Estado de la versión

Esta versión incluye:

- ✅ Autenticación con `auth_usuario` (RPC + bcrypt directo en frontend)
- ✅ Sesión en localStorage (24h)
- ✅ Vista del paciente con grid de consultas
- ✅ Perfil completo del médico (foto + firma + datos consultorio)
- ✅ Firma electrónica de consultas (SHA-256, NOM-024)
- ✅ Generación de recetas con PDF + firma + QR
- ✅ Impresión de consulta completa (PDF NOM-004)
- ✅ Tab **Consulta Libre** — dictado tipo chat con estructura por IA
- ✅ Tendencias de signos vitales
- ✅ ChatDoc con IA contextual
- ✅ Función Netlify Claude.js arreglada (2 versiones sincronizadas)

---

## 📦 Archivos clave a deployar

### HTMLs principales:
```
├── index.html        Landing
├── auth.html         Login + Registro
├── app.html          Dashboard médico ⭐
├── paciente.html     Vista del paciente
├── expediente.html   Expediente médico
├── landing.html      Landing alternativa
└── estudios.html     Gestión de estudios
```

### Scripts JS:
```
├── supabase-client.js    Conexión Supabase + helpers
├── api-service.js        Servicios API (legacy)
└── config.js             Configuración (si existe)
```

### Netlify:
```
├── netlify.toml              Configuración rutas y headers
├── netlify/functions/
│   └── claude.js             Proxy Anthropic API ⭐
└── .netlify/functions/
    └── claude.js             (idéntico al anterior)
```

---

## 🔑 Variables de ambiente en Netlify

**Dashboard Netlify → Site settings → Environment variables**

| Variable | Valor | Notas |
|----------|-------|-------|
| `ANTHROPIC_API_KEY` | `sk-ant-...` | Para Claude API (obligatorio) |

⚠️ Sin esta variable, el botón "Estructurar con IA" y ChatDoc fallan con error 500.

---

## 🚀 Pasos para deployar

### Opción A: Drag & Drop (más simple)

1. Ve a https://app.netlify.com/sites/fantastic-crumble-0fea1f/deploys
2. Arrastra la **carpeta completa**:
   ```
   C:\Users\asus\OneDrive\work\Ligia\frontend\otra version
   ```
3. Espera ~30-60 segundos
4. Netlify rebuilda las funciones automáticamente
5. **Limpia caché del navegador**: Ctrl + Shift + R

### Opción B: Netlify CLI (avanzado)

```bash
cd "C:\Users\asus\OneDrive\work\Ligia\frontend\otra version"
netlify deploy --prod
```

---

## 🧪 Validación post-deploy

### 1. Verificar Landing
- Ir a: https://fantastic-crumble-0fea1f.netlify.app
- ✅ Carga la landing con logo LIGIA

### 2. Verificar Login
- Ir a: https://fantastic-crumble-0fea1f.netlify.app/auth.html
- Credenciales:
  ```
  Email: medico001@hospital.mx
  Contraseña: medico1
  ```
- ✅ Redirige a `/app.html`

### 3. Verificar IA (Claude)
- En `/app.html`, seleccionar un paciente
- Tab **"💬 Consulta Libre"**
- Escribir: "Paciente con cefalea, TA 130/85, dx migraña"
- Click **"✨ Estructurar con IA"**
- ✅ Debe devolver JSON estructurado sin error

### 4. Verificar PDF de receta
- Tab **"🏠 Resumen"**
- Click **"💊 Nueva Receta"**
- Agregar 1 medicamento
- Click **"✍️ Firmar y descargar"**
- ✅ Descarga PDF con firma

---

## 🐛 Troubleshooting

### Error: "Cannot destructure property 'texto' of 'payload'"
**Causa:** Función Netlify desincronizada
**Fix:** Las 2 versiones de `claude.js` ya están sincronizadas en esta versión.

### Error: 500 en `/.netlify/functions/claude`
**Causa:** `ANTHROPIC_API_KEY` no configurada
**Fix:**
1. Netlify → Site settings → Environment variables
2. Agregar `ANTHROPIC_API_KEY` con tu key de https://console.anthropic.com
3. Click **"Deploys → Trigger deploy"**

### Error: 404 en tablas Supabase
**Causa:** PostgREST cache desactualizado
**Fix:** Supabase SQL Editor:
```sql
NOTIFY pgrst, 'reload schema';
```

### Login no funciona
**Causa:** Las URLs de Supabase en `auth.html`, `supabase-client.js`, `expediente.html`
**Fix:** Verificar que las 3 apunten a `https://isxspjlwuzbbtpamkknq.supabase.co`

---

## 🗄️ Scripts SQL importantes

Si necesitas reconstruir la BD:

```
1. LIGIA_BD_COMPLETA_TODO_EN_UNO.sql    Schema + catálogos + datos demo
2. LIGIA_DATOS_RICOS_REALISTAS.sql      Reemplazar datos con nombres reales
3. LIGIA_ALTER_MEDICOS_PERFIL.sql       Campos foto/firma + tablas recetas/estudios
```

Ejecutar en **Supabase SQL Editor** en ese orden.

---

## 🔐 Credenciales de prueba

| Rol | Email | Contraseña |
|-----|-------|------------|
| 👨‍⚕️ Médico | `medico001@hospital.mx` | `medico1` |
| 👤 Paciente | `paciente001@email.com` | `paciente1` |
| 👩 Mamá (admin familiar) | `mama01@email.com` | `mama1` |

Hay 20 médicos, 100 pacientes y 10 mamás. La numeración es secuencial:
- `medicoNNN@hospital.mx` / `medicoN` (sin ceros en la contraseña)
- `pacienteNNN@email.com` / `pacienteN`
- `mamaNN@email.com` / `mamaN`

---

## 📞 Soporte

Si algo no funciona:
1. Abre DevTools (F12) → Console
2. Anota el error exacto
3. Verifica las variables de Netlify
4. Verifica que la BD esté activa (no en pausa) en Supabase

---

**Última actualización:** 2026-05-26
**Versión:** LIGIA v2.0
