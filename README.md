# 🏥 LUISA v2.0 — Inteligencia Clínica

**Sistema de Expediente Clínico Electrónico (ECE)** para México, conforme a **NOM-004-SSA3-2012** y **NOM-024-SSA3-2010**.

---

## 📋 Estado Actual

| Componente | Estado |
|-----------|--------|
| Dashboard con KPIs | ✅ Completado |
| Dictación + SOAP | ✅ Completado |
| Análisis Laboratorio | ✅ Completado |
| Registro Pacientes NOM-024 | ✅ Completado |
| Datos de prueba | ✅ 110 pacientes, 300 citas, 50+ notas |
| Interfaz profesional | ✅ Portal OSMEDIK design |

---

## 🔐 Credenciales de Prueba

**Médicos:**
```
Email:    medico001@hospital.mx
Password: medico1
```

Disponibles: `medico001` a `medico020`

**URLs:**
- 🌐 https://proyluisa.netlify.app
- 🔐 https://proyluisa.netlify.app/auth
- 📊 https://proyluisa.netlify.app/app

---

## 🚀 Módulos Implementados

### 1. Dashboard Médico (`/app.html`)
- 4 KPIs en tiempo real
- Alertas dinámicas
- Agenda del día
- Tabs: Dashboard, Agenda, Pacientes, Consulta
- PWA ready

### 2. Dictación de Voz (`🎤` en Dashboard)
- Dictación en español (Web Speech API)
- Extracción SOAP automática con Claude
- Guardado en base de datos

### 3. Análisis de Laboratorio (`/estudios.html`)
- Upload PDF de resultados
- Análisis con Claude IA
- Extracción de valores y clasificación

### 4. Registro de Paciente (`/paciente-nuevo.html`)
- Formulario NOM-024 completo
- Integración con catálogos
- Validación de campos
- Auto-guardado en Supabase

---

## 💾 Datos Disponibles

```
110 pacientes      con perfiles completos
20  médicos        con cedula y especialidad
300 citas          distribuidas en próximos 30 días
100 medicamentos   asignados a pacientes
50+ notas evolución con SOAP estructurado
30  vacunas        registradas
26  catálogos      (NOM-024 completo)
```

---

## 🛠 Stack

- **Frontend:** HTML5 + Tailwind CSS + Vanilla JS
- **Backend:** Supabase PostgreSQL (41 tablas)
- **IA:** Claude Sonnet 4 vía Netlify Functions
- **Hosting:** Netlify (auto-deploy)
- **PWA:** Service Worker + offline support

---

## 📱 Flujo de Uso

1. **Login:** `/auth.html` → medico001@hospital.mx / medico1
2. **Dashboard:** Ver KPIs, alertas, agenda
3. **Dictar Consulta:** Click 🎤 → habla → Claude extrae SOAP
4. **Registrar Paciente:** Click "Nuevo Paciente" → llena formulario NOM-024
5. **Ver Laboratorio:** `/estudios.html` → sube PDF → análisis IA

---

## ✅ Conforme a Normativas

- NOM-004-SSA3-2012 (Expedientes Clínicos)
- NOM-024-SSA3-2010 (Campos de datos obligatorios)
- RLS por usuario
- Auditoría de acciones
- Firma digital

---

**Versión:** 2.0.0 | **Estado:** Producción ✅ | **Última actualización:** 2026-06-17
