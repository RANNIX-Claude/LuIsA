 ⚡ LUISA v2.0 - Quick Reference Card

**Imprime esto o márcalo en tu teléfono** 📱

---

## 🎯 Los 3 Pasos para Ir a Producción

### 1️⃣ SUPABASE (5 min)
```sql
1. Ve a https://supabase.com → Dashboard
2. SQL Editor → Copia y ejecuta:
   • luisa_v2_0_deploy_completo.sql
   • luisa_v2_0_rls_simple.sql
   • luisa_v2_0_seed_simple.sql
3. ✅ Listo
```

### 2️⃣ ANTHROPIC (2 min)
```
1. Ve a https://console.anthropic.com
2. Account → API Keys → Create Key
3. Copia tu API key (ej: sk-ant-xxxxx)
4. ✅ Listo
```

### 3️⃣ NETLIFY (3 min)
```
Opción A (Más fácil):
1. Zip tu carpeta proyecto
2. https://app.netlify.com/drop
3. Arrastra el ZIP
4. Espera a que termine (< 1 min)
5. ✅ Listo

Opción B (Con Git):
1. git push origin main
2. Ve a https://app.netlify.com/sites
3. Selecciona tu site
4. Site settings → Build & deploy → Environment
5. Agrega ANTHROPIC_API_KEY
6. ✅ Listo
```

---

## 📋 Checklist Post-Deploy (5 min)

```
[ ] Accede a https://tu-sitio.netlify.app
[ ] Click en "Ir al Panel" o "Acceder"
[ ] Login con: elena.garcia@luisa.mx (si creaste usuario)
[ ] Verifica que carga el app correctamente
[ ] Ve a https://tu-sitio.netlify.app/.netlify/functions/claude
    (debe devolver algo así: {"error": "missing type"})
[ ] ✅ TODO FUNCIONA
```

---

## 🔧 Troubleshooting Rápido

| Error | Solución |
|-------|----------|
| `CORS Error` | Revisar netlify.toml headers |
| `API Key not found` | Agregar ANTHROPIC_API_KEY en Netlify settings |
| `Database connection refused` | Verificar Supabase está running |
| `Table does not exist` | Ejecutar SQL deploy nuevamente |
| `RLS policy violation` | ✅ Normal, RLS está funcionando |
| `Blank page` | F12 → Console, revisar errores |

---

## 📱 URLs Importantes

```
Live App: https://tu-sitio.netlify.app/
Doctor App: https://tu-sitio.netlify.app/app
Patient App: https://tu-sitio.netlify.app/paciente
API Docs: https://tu-sitio.netlify.app/.netlify/functions/claude

Admin Dashboards:
Supabase: https://supabase.com/dashboard
Anthropic: https://console.anthropic.com
Netlify: https://app.netlify.com
```

---

## 🔐 Default Test Users

```
Doctor:
  Email: pedro.garcia@luisa.mx
  ID: 550e8400-a29b-41d4-a716-446655440003
  
Patient 1:
  Email: elena.garcia@luisa.mx
  ID: 550e8400-a29b-41d4-a716-446655440001
  
Patient 2:
  Email: pedro.garcia@luisa.mx
  ID: 550e8400-a29b-41d4-a716-446655440002
```

---

## 💾 Files Clave

| Archivo | Propósito | Modificar? |
|---------|-----------|-----------|
| `supabase-client.js` | Conexión a BD | ❌ No |
| `app.html` | App doctor | ✅ Si (customizar) |
| `paciente.html` | App paciente | ✅ Si (customizar) |
| `.netlify/functions/claude.js` | Claude API | ✅ Si (agregar endpoints) |
| `netlify.toml` | Config deploy | ✅ Si (custom domain) |

---

## 📊 Monitorear

**Diario:**
```
Netlify: app.netlify.com → Analytics
Supabase: supabase.com → Logs → API
Anthropic: console.anthropic.com → Usage
```

**Si algo falla:**
```
1. Revisar https://status.netlify.com
2. Revisar https://supabase.com/status
3. Revisar console del navegador (F12)
4. Revisar logs: Netlify → Functions
```

---

## 🚀 Siguiente Versión (Phase 2)

- [ ] Video calls (Telemedicina)
- [ ] Mobile app (React Native)
- [ ] Recetas electrónicas
- [ ] BI Dashboard
- [ ] SMS/WhatsApp alerts

---

## 🆘 Ayuda Rápida

**Error en login:**
```
1. Verificar email existe en Supabase
2. Verificar password es correcto
3. Revisar console (F12 → Console)
```

**Función Claude no funciona:**
```
1. Verificar ANTHROPIC_API_KEY en Netlify settings
2. Verificar tiene crédito en https://console.anthropic.com
3. Ver logs: Netlify → Functions → claude.js
```

**Base de datos no carga:**
```
1. Verificar tablas existen: Supabase → Database
2. Verificar seed data: SELECT COUNT(*) FROM usuarios_luisa;
3. Verificar RLS: Supabase → Auth → Row Level Security
```

---

## 📞 Contactos

```
Problemas Supabase:    → https://supabase.com/support
Problemas Anthropic:   → https://support.anthropic.com
Problemas Netlify:     → https://netlify.com/support
Comunidad:             → https://luisa.slack.com
```

---

## 🎉 ¡Lo Hiciste!

Tu LUISA v2.0 está en producción. 🚀

**Ahora:**
1. Comparte el link con médicos
2. Empieza a recibir pacientes
3. ¡Mejora la salud en México!

---

**Última actualización:** 2026-05-24  
**Versión:** 2.0.0  
**Status:** ✅ LIVE
