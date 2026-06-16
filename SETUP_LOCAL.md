 🏠 LUISA v2.0 - Setup Local & Testing

## 📦 Instalación en tu máquina

### Paso 1: Descargar los archivos

```bash
# Clona o descarga estos archivos en una carpeta:
C:\proyectos\luisa-v2\

# Estructura necesaria:
luisa-v2/
├── app.html                          # ✅ App del doctor
├── paciente.html                     # ✅ App del paciente
├── auth.html                         # Login/Register
├── estudios.html                     # Análisis de estudios
├── expediente.html                   # Expediente compartido
├── landing.html o index.html         # Landing page
├── supabase-client.js                # ✅ Utilidades Supabase compartidas
├── .netlify/functions/
│   ├── claude.js                    # ✅ Netlify Function para Claude
│   └── package.json                 # Dependencias
├── netlify.toml                     # ✅ Configuración Netlify
└── DEPLOYMENT_NETLIFY.md            # ✅ Guía de deployment
```

### Paso 2: Configurar Supabase

```sql
-- 1. En tu dashboard de Supabase (https://supabase.com)
-- 2. Ve a SQL Editor y ejecuta estos scripts EN ORDEN:

-- A. Crear schema completo:
-- Copia todo el contenido de: luisa_v2_0_deploy_completo.sql
-- Pega en SQL Editor y ejecuta

-- B. Aplicar RLS:
-- Copia: luisa_v2_0_rls_simple.sql
-- Ejecuta en SQL Editor

-- C. Cargar datos de prueba:
-- Copia: luisa_v2_0_seed_simple.sql
-- Ejecuta en SQL Editor
```

### Paso 3: Verificar usuario de prueba

En Supabase, ve a **Auth > Users** y confirma:

```
Email: elena.garcia@luisa.mx
Rol: administrador_familiar (puede ser cualquiera de los 3 creados)
```

Si no aparecen, ejecuta el seed nuevamente.

---

## 🌍 Ejecutar localmente

### Opción A: Con Python (Más fácil)

```bash
# Navega a tu carpeta
cd C:\proyectos\luisa-v2

# En Windows PowerShell:
python -m http.server 8000

# En Linux/Mac:
python3 -m http.server 8000

# Accede a: http://localhost:8000
```

### Opción B: Con Node.js

```bash
# Instala http-server globalmente
npm install -g http-server

# Ejecuta
http-server -p 8000

# Accede a: http://localhost:8000
```

### Opción C: Con Netlify CLI (Recomendado para Functions)

```bash
# Instala
npm install -g netlify-cli

# Desde la carpeta del proyecto:
netlify dev

# Accede a: http://localhost:8888
# Las functions estarán disponibles en: /.netlify/functions/claude
```

---

## 🧪 Testing Manual

### 1. Test de Login (Doctor)

```
URL: http://localhost:8000/auth.html
Email: pedro.garcia@luisa.mx (crear nuevo o usar test)
Password: TuPassword123

Expected: Redirige a /app.html
```

### 2. Test de App Doctor

```
URL: http://localhost:8000/app.html

Verifica:
✓ Se carga el perfil del médico (Elena García o quien uses)
✓ Se cargan los pacientes asignados en el sidebar
✓ Puedes seleccionar un paciente
✓ Puedes dictar consulta (si tienes micrófono)
✓ Puedes guardar la consulta → Se debe guardar en notas_evolucion
```

### 3. Test de App Paciente

```
URL: http://localhost:8000/paciente.html
Email: paciente@example.com (crear nuevo)
Password: TuPassword123

Verifica:
✓ Se carga tu perfil
✓ Se muestran tus medicamentos (de medicamentos_paciente)
✓ Se muestra tu completitud del expediente
✓ Puedes agregar eventos de salud
```

### 4. Test de Netlify Function (requiere .env)

```bash
# Crea .env en tu proyecto:
ANTHROPIC_API_KEY=sk-ant-xxxxxxxxxxxxx

# Test manual (con curl o Postman):
curl -X POST http://localhost:8888/.netlify/functions/claude \
  -H "Content-Type: application/json" \
  -d '{
    "type": "dictation",
    "payload": {
      "texto": "El paciente dice que tiene fiebre de 39 grados y dolor de cabeza",
      "bloque": "padecimiento"
    }
  }'

# Response esperado:
{
  "success": true,
  "resultado": {
    "motivo": "Fiebre y dolor de cabeza",
    "temperatura": "39°C",
    ...
  }
}
```

---

## 🔍 Debugging

### Browser Console (F12)

```javascript
// Ver sesión actual:
sb.auth.getSession().then(({data:{session}}) => console.log(session))

// Ver datos del paciente:
console.log(pacienteData)

// Ver datos del médico:
console.log(medico)

// Verificar conexión a Supabase:
sb.from('usuarios_luisa').select('count', {count: 'exact'})
  .then(r => console.log('Users:', r.data))
```

### Network Tab

```
Verifica que estos requests sean exitosos:

✓ GET /app.html (200)
✓ GET /supabase-client.js (200)
✓ Supabase auth requests (200-400 esperado)
✓ Supabase queries (.select, .insert, etc.)
```

### Logs de Supabase

En el dashboard de Supabase:
- Ve a **Logs → API Logs** para ver todas las queries
- **Auth → Logs** para ver intentos de login
- **Database → Monitoring** para performance

---

## ✅ Checklist de Testing Completo

### Antes de Deployment

```
AUTENTICACIÓN:
[ ] Login con doctor funciona
[ ] Login con paciente funciona
[ ] Logout redirige a auth.html
[ ] Session persiste al recargar página

DOCTOR APP (app.html):
[ ] Carga perfil del doctor
[ ] Carga lista de pacientes
[ ] Puede dictar consulta
[ ] Puede guardar consulta
[ ] Histórico se actualiza
[ ] Puedo navegar entre pacientes

PACIENTE APP (paciente.html):
[ ] Carga mi perfil
[ ] Muestra mis medicamentos
[ ] Muestra mi completitud
[ ] Puedo agregar eventos
[ ] Puedo ver mis citas

NETLIFY FUNCTIONS:
[ ] Dictation extraction funciona
[ ] Lab analysis funciona
[ ] Translation funciona
[ ] Chat con LUISA funciona

DATABASE:
[ ] puedo ver datos en Supabase
[ ] RLS previene acceso no autorizado
[ ] Audit log registra cambios
[ ] Timestamps se actualizan
```

---

## 🚨 Problemas Comunes & Soluciones

| Error | Causa | Solución |
|-------|-------|----------|
| `cors error on localhost` | CORS headers | Usar `http://localhost` no `127.0.0.1` |
| `session is null` | No hay usuario | Login primero, luego accede a /app.html |
| `table does not exist` | Seed no se ejecutó | Ejecutar luisa_v2_0_deploy_completo.sql |
| `RLS policy violation` | Usuario intenta acceder datos de otro | Normal, significa RLS funciona ✓ |
| `Claude API timeout` | API lenta o key inválida | Verificar ANTHROPIC_API_KEY |
| `medicamentos no cargan` | FK faltante | Verificar que el medicamento existe en cat_medicamentos |

---

## 📚 Recursos Útiles

- **Supabase Docs**: https://supabase.com/docs
- **Anthropic API**: https://docs.anthropic.com/
- **Netlify Docs**: https://docs.netlify.com/
- **MDN Web Docs**: https://developer.mozilla.org/

---

## 🎯 Próximo Paso

Una vez todo funciona localmente:

```bash
# Deploy a Netlify (Opción A: Drag & Drop)
# Ve a https://app.netlify.com/drop
# Arrastra tu carpeta del proyecto

# O (Opción B: Con Git)
git push origin main
# Netlify se entera automáticamente y deploya
```

¡Felicidades! 🎉 Tu LUISA v2.0 está lista para producción.
