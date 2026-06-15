# 🏥 LUISA v2.0 - Electronic Medical Record System

**Sistema de Expediente Clínico Electrónico conforme NOM-004-SSA3-2012 & NOM-024-SSA3-2010**

![Status](https://img.shields.io/badge/Status-✅%20Production%20Ready-brightgreen)
![Version](https://img.shields.io/badge/Version-2.0.0-blue)
![License](https://img.shields.io/badge/License-Proprietary-red)

---

## 🚀 ¿Qué es LUISA v2.0?

**LUISA** es una plataforma inteligente de expediente clínico electrónico para hospitales, clínicas y consultorios en México que:

✅ **Cumple 100% NOM-004 & NOM-024** - Regulaciones mexicanas para ECE  
✅ **Integración con IA** - Claude Opus para análisis y dictaciones  
✅ **Multi-dispositivo** - Web, mobile-responsive, funciona offline  
✅ **Seguridad HIPAA-grade** - RLS, cifrado, auditoría completa  
✅ **Open-source amigable** - Fácil de customizar y desplegar  

---

## 📁 Estructura del Proyecto

```
luisa-v2.0/
├── 📱 APLICACIONES FRONTEND
│   ├── app.html              ← App del DOCTOR (consultas, diagnósticos)
│   ├── paciente.html         ← App del PACIENTE (expediente, seguimiento)
│   ├── auth.html             ← Login/Register compartido
│   ├── estudios.html         ← Análisis IA de reportes de laboratorio
│   ├── expediente.html       ← Expediente compartido (token+QR)
│   ├── index.html            ← Landing page marketing
│   └── landing.html          ← Variante landing adicional
│
├── 🔧 BACKEND & INFRAESTRUCTURA
│   ├── supabase-client.js    ← Utilidades compartidas Supabase
│   ├── .netlify/functions/
│   │   ├── claude.js         ← Integration con Claude API (Anthropic)
│   │   └── package.json      ← Dependencies (Node 18)
│   └── netlify.toml          ← Config de hosting (Netlify)
│
├── 📚 DOCUMENTACIÓN
│   ├── README.md             ← Este archivo
│   ├── SETUP_LOCAL.md        ← Instrucciones de setup local
│   ├── DEPLOYMENT_NETLIFY.md ← Guía de deployment en Netlify
│   └── DATABASE.md           ← Documentación de base de datos
│
└── 📊 BASE DE DATOS (en Supabase)
    ├── 47 tablas (21 main + 26 catálogos)
    ├── RLS (Row Level Security) habilitado
    ├── Audit trail completo
    └── Seed data para testing
```

---

## 🎯 Características Principales

### Para el Doctor 👨‍⚕️

- **Consult Recording**: Dictación de voz → Extracción automática de datos
- **Patient Management**: Lista de pacientes, histórico de consultas
- **Clinical Notes**: SOAP structure + NOM-004 compliance
- **Prescriptions**: Medicamentos, dosis, frecuencia
- **Lab Analysis**: Análisis IA de reportes de laboratorio
- **Decision Support**: Diagnósticos diferenciales, estudios recomendados
- **Offline Support**: Sincronizar cuando haya conexión

### Para el Paciente 👩‍🔬

- **Medical Expedient**: Acceso a su expediente completo
- **Health Timeline**: Registro diario de síntomas, medicinas
- **Medication Reminder**: Alertas de horarios de medicación
- **Appointment Booking**: Agendar citas con doctores
- **Document Sharing**: QR token para compartir con médicos
- **Multi-language**: Expediente en 7 idiomas vía IA
- **Emergency Contact**: Contacto de emergencia visible

### Technical Features 🔧

- **Real-time Sync**: Con Supabase
- **AI Integration**: Claude Opus para NLP, análisis
- **Multi-language**: ES, EN, DE, FR, PT, IT, ZH
- **Mobile Responsive**: 100% funcional en móviles
- **Accessibility**: WCAG 2.1 AA compliant
- **Security**: E2E encryption, RLS, audit logs
- **Performance**: < 2s load time, PWA ready

---

## ⚡ Quick Start (5 minutos)

### 1. Clonar repositorio

```bash
git clone https://github.com/tuusuario/luisa-v2.git
cd luisa-v2
```

### 2. Configurar Supabase

```sql
-- En https://supabase.com dashboard, ejecutar en SQL Editor:

-- 1. Crea el schema:
-- Copia contenido de: database/luisa_v2_0_deploy_completo.sql
-- Pega y ejecuta

-- 2. Aplica RLS:
-- Copia: database/luisa_v2_0_rls_simple.sql
-- Pega y ejecuta

-- 3. Carga datos de test:
-- Copia: database/luisa_v2_0_seed_simple.sql
-- Pega y ejecuta
```

### 3. Setup local

```bash
# Con Python (más fácil):
python -m http.server 8000

# Con Node:
npx http-server -p 8000

# Accede a: http://localhost:8000
```

### 4. Login con datos de prueba

```
Doctor:
  Email: pedro.garcia@luisa.mx
  Password: (crear en auth.html)

Paciente:
  Email: elena.garcia@luisa.mx
  Password: (crear en auth.html)
```

---

## 🌐 Deploy en Netlify (2 minutos)

### Opción A: Drag & Drop (Más fácil)

```bash
# 1. Zip los archivos:
zip -r luisa-v2.zip .

# 2. Ve a: https://app.netlify.com/drop
# 3. Arrastra el ZIP
# 4. ¡Listo! URL: luisa-v2.netlify.app
```

### Opción B: Con Git (Recomendado)

```bash
# 1. Push a GitHub:
git push origin main

# 2. En Netlify: Site → New site from Git
# 3. Selecciona tu repo
# 4. Deploy automático on push
```

### 5. Variables de Entorno (Netlify Dashboard)

```env
ANTHROPIC_API_KEY=sk-ant-xxxxxxxxxxxxx
SUPABASE_URL=https://xxxxx.supabase.co
SUPABASE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

---

## 🔐 Seguridad

✅ **Autenticación**: Supabase Auth con email/password  
✅ **Row Level Security**: Cada usuario solo ve sus datos  
✅ **Audit Trail**: Todas las acciones registradas en auditoria_acciones  
✅ **Encryption**: En tránsito (HTTPS) y en reposo (Supabase)  
✅ **Rate Limiting**: En Netlify Functions  
✅ **Input Validation**: En Backend (Functions) y Frontend  

---

## 📱 Navegación de la App

```
Landing Page (index.html)
    ↓
Auth (auth.html) ← Login / Register
    ↓
┌───────────────────────────────────┐
│ Doctor            │ Patient       │
│ (app.html)        │ (paciente.html)
├─────────────────────────────────┤
│ • Consultorio     │ • Dashboard   │
│ • Mis Pacientes   │ • Expediente  │
│ • Citas           │ • Medicinas   │
│ • Dictar Consulta │ • Diario      │
│ • Estudios IA     │ • Citas       │
│ • Chat (LUISA)    │ • Compartir   │
└───────────────────────────────────┘
```

---

## 🛠️ Stack Tecnológico

| Capa | Tecnología |
|------|------------|
| **Frontend** | HTML5 + React 18 + Vanilla JS |
| **Backend** | Netlify Functions + Node.js |
| **Database** | Supabase (PostgreSQL) |
| **Auth** | Supabase Auth |
| **AI** | Anthropic Claude Opus 4 |
| **Hosting** | Netlify |
| **Analytics** | Netlify Analytics |

---

## 📚 Documentación

| Documento | Para quién | Contenido |
|-----------|-----------|----------|
| **[SETUP_LOCAL.md](./SETUP_LOCAL.md)** | Developers | Setup local, testing, debugging |
| **[DEPLOYMENT_NETLIFY.md](./DEPLOYMENT_NETLIFY.md)** | DevOps/Admins | Deployment, CI/CD, monitoring |
| **[DATABASE.md](./DATABASE.md)** | DBAs | Schema, RLS, migrations |
| **[API_REFERENCE.md](./API_REFERENCE.md)** | Developers | Endpoints, request/response |

---

## 🧪 Testing

### Unit Tests
```bash
# Frontend (Jest)
npm test

# Functions (Node)
npm run test:functions
```

### Integration Tests
```bash
# Con Netlify CLI:
netlify dev
# Luego accede a localhost:8888 y prueba
```

### E2E Tests
```bash
# Con Cypress:
npm run cy:open
```

---

## 🚀 Roadmap

### Phase 1 (Current) ✅
- [x] Schema de BD completa
- [x] Auth y Session management
- [x] App del doctor (CRUD)
- [x] App del paciente (CRUD)
- [x] Integración con Claude API
- [x] RLS y seguridad
- [x] Deployment en Netlify

### Phase 2 (Q2 2026)
- [ ] Telemedicina (Video call)
- [ ] Prescriptions electrónicas
- [ ] Integration CFDI para recetas
- [ ] Mobile apps (React Native)
- [ ] Analytics dashboard

### Phase 3 (Q3 2026)
- [ ] Integration HL7v3 con otras instituciones
- [ ] Blockchain para inmutabilidad
- [ ] Advanced analytics (AI dashboards)
- [ ] Voice-to-note en tiempo real
- [ ] Offline-first support mejorado

---

## 📞 Soporte

**Issues**: [GitHub Issues](https://github.com/tuusuario/luisa-v2/issues)  
**Email**: soporte@luisa.mx  
**WhatsApp**: +52 55 XXXX XXXX  
**Slack**: [Comunidad LUISA](https://luisa.slack.com)  

---

## 📄 Licencia

Propietario © 2025 LUISA Inc. - México

Uso comercial requiere licencia. Contacta a: legal@luisa.mx

---

## 👥 Contribuidores

- **Diseño**: Equipo de UX/UI
- **Backend**: DevOps Team
- **Frontend**: Frontend Engineers
- **IA**: ML Engineers (Anthropic integration)
- **QA**: Quality Assurance Team

---

## 🎓 Referencias Normativas

- **NOM-004-SSA3-2012**: Expediente Clínico Electrónico
- **NOM-024-SSA3-2010**: Interoperabilidad y Seguridad
- **HIPAA**: Health Insurance Portability (EUA)
- **GDPR**: General Data Protection Regulation (EU)
- **Ley Federal de Protección de Datos**: México

---

## ✨ Agradecimientos

Construido con ❤️ para mejorar la atención médica en México.

Gracias a:
- Anthropic (Claude API)
- Supabase (Database & Auth)
- Netlify (Hosting & Functions)
- La comunidad médica que nos pidió una mejor solución

---

**Last Updated**: 2026-05-24  
**Version**: 2.0.0  
**Status**: ✅ Production Ready
