# CLAUDE.md — LuIsA v2.0 (Sistema de Expediente Clínico Electrónico)

## REGLAS DE OPERACIÓN

- Ejecuta sin preguntar. Decide la opción más razonable y continúa.
- Reporta solo al completar cada fase.
- Los secretos van SOLO en .claude/settings.local.json — nunca en git.
- Usar UTF-8 sin BOM en todos los archivos (PowerShell: New-Object System.Text.UTF8Encoding $false).
- Después de cada cambio: git add → commit → push → Netlify auto-despliega.

## CONTEXTO DEL PROYECTO

**Nombre:** LuIsA — Inteligencia Clínica
**Dominio:** Salud / Expediente Clínico Electrónico México
**Normativas:** NOM-004-SSA3-2012, NOM-024-SSA3-2010
**Stack:** HTML5 + React 18 inline | Supabase (PostgreSQL) | Netlify Functions | Claude API
**URL producción:** https://proyluisa.netlify.app

## CONEXIONES ACTIVAS

- **Git:** github.com/RANNIX-Claude/LuIsA (master)
- **Netlify:** jazzy-dieffenbachia-f0f678 (auto-deploy en push)
- **Supabase:** kcpooneuqdbdavgivbdp.supabase.co
- **Supabase CLI:** `SUPABASE_ACCESS_TOKEN=sbp_... supabase db query --linked -f script.sql -o table`

## TABLAS EN SUPABASE (public)

### Catálogos (26)
cat_estados_republica, cat_ciudades, cat_ocupaciones, cat_estado_civil,
cat_grupos_etnicos, cat_religiones, cat_tipos_sanguineo, cat_discapacidades,
cat_tipos_vivienda, cat_especialidades, cat_vias_administracion,
cat_frecuencias_medicamento, cat_tipos_estudios, cat_unidades_medida,
cat_diagnosticos, cat_medicamentos, cat_pronosticos, cat_niveles_socioeconomicos,
cat_reacciones_alergicas, cat_riesgos, cat_riesgos_quirurgicos,
cat_tecnicas_quirurgicas, cat_procedimientos_cie9, cat_tipos_servicios_auxiliares,
cat_tipos_eventos_auditoria, cat_estados_orden

### Tablas principales (15)
usuarios_luisa, medicos, perfiles_pacientes,
doctor_patient_relationships, family_relationships,
citas, historias_clinicas, notas_evolucion,
notas_urgencias, notas_hospitalizacion,
medicamentos_paciente, diario_eventos, vacunas_paciente,
firma_electronica, auditoria_acciones

## DATOS DE PRUEBA CARGADOS

- 20 médicos (medico001@hospital.mx … pass: medico1)
- 110 pacientes, 300 citas, 50 historias clínicas
- 100 medicamentos activos, 130 usuarios totales

## SISTEMA DE DISEÑO

Variables CSS:
- --navy: #050C1A | --teal: #00C9A7 | --teal2: #00E5BB
- --cyan: #38BDF8 | --blue: #1B5499 | --white: #EEF4FF
- --muted: #6B8BAE | --gold: #C9A84C
- Fuentes: Inter, Playfair Display, JetBrains Mono

## PÁGINAS ACTUALES

- index.html — Landing page (marketing)
- auth.html — Login/Register (médico y paciente)
- app.html — App del médico (consultas, dictación, IA)
- paciente.html — App del paciente (expediente, citas, medicamentos)
- estudios.html — Análisis IA de laboratorio
- expediente.html — Expediente compartido por QR/token

## NETLIFY FUNCTION

netlify/functions/claude.js — Proxy a Anthropic API
Modelo default: claude-sonnet-4-20250514

## MÓDULOS A CONSTRUIR (Prompt B)

### Fase 1 — Análisis (COMPLETADO)
Entidades: usuarios_luisa, medicos, perfiles_pacientes, citas, historias_clinicas,
medicamentos_paciente, diario_eventos, vacunas_paciente, notas_evolucion

Procesos clave:
1. Registro paciente → verificación identidad → perfil clínico inicial
2. Agenda cita → recordatorio → consulta → nota evolución
3. Consulta → dictación voz → extracción IA → firma electrónica
4. Prescripción → control adherencia → alertas vencimiento
5. Upload estudio → análisis IA → resultado → enviar paciente

Puntos de automatización IA:
- Dictación de notas clínicas (Whisper/Claude)
- Extracción SOAP de texto libre
- Análisis de laboratorio (PDF → Claude vision)
- Alertas de medicamentos (vencimiento, interacciones)
- Resumen ejecutivo de expediente para médico

### Módulo 1 — Dashboard médico con KPIs reales
### Módulo 2 — Dictación voz → SOAP extraction
### Módulo 3 — Análisis IA estudios de laboratorio
### Módulo 4 — Notificaciones y alertas automáticas
### Módulo 5 — Agente IA de consulta clínica

## DATA WAREHOUSE (Prompt C)

Esquema estrella:
- fact_citas (métricas de agenda)
- fact_consultas (métricas clínicas)
- dim_especialidad, dim_diagnostico, dim_medicamento
- dim_paciente (demografía), dim_medico, dim_tiempo

6 tableros BI:
1. Operacional (citas del día, cancelaciones, ocupación)
2. Clínico (diagnósticos frecuentes, comorbilidades)
3. Farmacológico (medicamentos top, adherencia)
4. Preventivo (vacunas, screening, detecciones)
5. Financiero (productividad médico, consultas/hora)
6. Epidemiológico (tendencias por especialidad, zona)
