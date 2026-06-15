# 🚀 LUISA v2.0 - Guía de Deployment en Netlify

## 📋 Pre-requisitos

- Cuenta en [Netlify](https://app.netlify.com) (gratis)
- Cuenta en [Anthropic](https://console.anthropic.com) (API Key de Claude)
- Acceso a [Supabase](https://supabase.com) (ya configurado)
- Git instalado en tu máquina

---

## ⚙️ 1. Configuración de Variables de Entorno

### En Netlify Dashboard:

1. Ve a **Site settings → Build & deploy → Environment**
2. Agrega estas variables:

```env
ANTHROPIC_API_KEY=sk-ant-xxxxx  # Tu API key de Anthropic
SUPABASE_URL=https://rfoaynoakatxitylfaud.supabase.co
SUPABASE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

**Nota:** Las keys de Supabase ya están en `supabase-client.js`, pero es buena práctica también aquí.

---

## 📤 2. Deploy Rápido (Drag & Drop)

### Opción A: Sin Git (más rápido para pruebas)

```bash
# 1. Zip todos los archivos
cd "C:\Users\asus\OneDrive\work\Luisa\frontend\otra version"
zip -r luisa-v2.zip .

# 2. Ve a https://app.netlify.com/drop
# 3. Arrastra y suelta el ZIP
# 4. ¡Listo! Tu site estará en luisa-v2.netlify.app
```

### Opción B: Con Git (recomendado para producción)

```bash
# 1. Inicializa repositorio git
cd "C:\Users\asus\OneDrive\work\Luisa\frontend\otra version"
git init
git add .
git commit -m "Initial LUISA v2.0 commit"

# 2. Sube a GitHub (o GitLab/Bitbucket)
# En GitHub: crea nuevo repo "luisa-v2"
git remote add origin https://github.com/tu-usuario/luisa-v2.git
git push -u origin main

# 3. En Netlify: New site → Import an existing project
# Selecciona tu repo, ¡y hecho!
```

---

## 🔌 3. Configurar Netlify Functions

Las functions están en `.netlify/functions/claude.js` y se despliegan automáticamente.

### Verificar que funcionan:

```bash
# Localmente (requiere Netlify CLI)
npm install -g netlify-cli
netlify dev

# Luego llama a la función:
curl -X POST http://localhost:8888/.netlify/functions/claude \
  -H "Content-Type: application/json" \
  -d '{
    "type": "dictation",
    "payload": {
      "texto": "El paciente reporta dolor en el pecho",
      "bloque": "padecimiento"
    }
  }'
```

---

## 🧪 4. Testing en Producción

### URLs de la app desplegada:

```
https://tu-sitio.netlify.app/              # Landing page (index.html)
https://tu-sitio.netlify.app/auth          # Login/Register
https://tu-sitio.netlify.app/app           # App del doctor
https://tu-sitio.netlify.app/paciente      # App del paciente
https://tu-sitio.netlify.app/estudios      # Análisis de estudios
https://tu-sitio.netlify.app/expediente    # Expediente compartido
```

### Test con usuarios de prueba:

**Doctor:**
- Email: `pedro.garcia@luisa.mx`
- Password: Usa la que configuraste en auth.html
- Pacientes: Los que están en la BD de Supabase

**Paciente:**
- Email: Crear nuevo en login
- Password: Tu contraseña
- Expediente: Se carga de la BD automáticamente

---

## 📊 5. Monitoreo

### En Netlify Dashboard:

- **Analytics** → Ver visitors, page views, etc.
- **Functions** → Ver logs, invocaciones de Claude
- **Logs** → Deploy logs, errores, etc.

### Errores comunes:

| Problema | Solución |
|----------|----------|
| "Anthropic API key not found" | Verificar ANTHROPIC_API_KEY en Environment |
| "Function not found" | Ejecutar `npm install` en `.netlify/functions/` |
| "CORS error" | Verificar headers en netlify.toml |
| "Database connection refused" | Verificar SUPABASE_URL y SUPABASE_KEY |

---

## 🚀 6. Optimizaciones Recomendadas

### A. Caché estático
En **netlify.toml**, agregar:
```toml
[[headers]]
  for = "/*.{js,css,png,jpg,jpeg,svg}"
  [headers.values]
    Cache-Control = "public, max-age=31536000, immutable"
```

### B. Rate limiting en Functions
```javascript
// En claude.js, agregar:
const rateLimit = require('express-rate-limit');
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 100
});
```

### C. Monitoreo de errores
Integrar Sentry o LogRocket:
```html
<script src="https://browser.sentry-cdn.com/7.91.0/bundle.min.js"></script>
<script>
  Sentry.init({
    dsn: "your-sentry-dsn",
    environment: "production"
  });
</script>
```

---

## 🔐 7. Seguridad

### Antes de ir a producción:

- [ ] HTTPS habilitado (automático en Netlify)
- [ ] CORS headers configurados
- [ ] Environment variables NO en código
- [ ] Validación de entrada en Functions
- [ ] Rate limiting en API
- [ ] RLS habilitado en Supabase (ya está ✅)
- [ ] Certificado de privacidad actualizado

---

## 📞 Soporte

Si tienes problemas:

1. **Verifica los logs de Netlify**: `netlify dev --debug`
2. **Revisa la consola del navegador**: `F12 → Console`
3. **Checa Anthropic API**: https://console.anthropic.com/account/usage
4. **Prueba localmente primero**: `netlify dev`

---

## ✨ ¡Listo!

Tu app LUISA v2.0 está en el cloud. ¡Comparte el link y empieza a recibir pacientes! 🏥

Próximas mejoras:
- [ ] Custom domain
- [ ] SSL/TLS
- [ ] CDN global
- [ ] Backups automáticos
- [ ] Analytics avanzado
