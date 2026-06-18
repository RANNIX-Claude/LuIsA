# CLAUDE.md — LuIsA v2.0 (Sistema de Expediente Clínico Electrónico)

## REGLAS DE OPERACIÓN

- Ejecuta sin preguntar. Decide la opción más razonable y continúa.
- Reporta solo al completar cada fase.
- Los secretos van SOLO en .claude/settings.local.json — nunca en git.
- Usar UTF-8 sin BOM en todos los archivos.
- Después de cada cambio: `git add` → `git commit` → `git push` → Netlify auto-despliega.
- Branch de desarrollo activo: `claude/claude-md-docs-nel4a8` — nunca hacer push a master sin confirmación.

---

## CONTEXTO DEL PROYECTO

**Nombre:** LuIsA — Inteligencia Clínica
**Dominio:** Salud / Expediente Clínico Electrónico México
**Normativas:** NOM-004-SSA3-2012 (expediente electrónico), NOM-024-SSA3-2010 (campos obligatorios)
**Stack:** HTML5 + React 18 inline | Supabase (PostgreSQL) | Netlify Functions | Claude API
**URL producción:** https://proyluisa.netlify.app
**Node:** >=16.0.0

---

## CONEXIONES ACTIVAS

| Servicio     | Detalle                                                                     |
|-------------|-----------------------------------------------------------------------------|
| Git          | github.com/RANNIX-Claude/LuIsA (master = producción)                       |
| Netlify      | jazzy-dieffenbachia-f0f678 — auto-deploy en push a master                  |
| Supabase     | kcpooneuqdbdavgivbdp.supabase.co (PostgreSQL)                              |
| Claude API   | Proxy vía `netlify/functions/claude.js` → https://api.anthropic.com        |

**Supabase CLI (para ejecutar SQL directamente):**
```bash
SUPABASE_ACCESS_TOKEN=sbp_... supabase db query --linked -f script.sql -o table
```

---

## ARQUITECTURA DEL STACK

### Sin build tools — todo inline
- No hay Webpack, Vite, ni bundler. Los archivos HTML cargan React 18 desde CDN (`unpkg.com/react@18/umd/`).
- Babel Standalone transforma JSX en el browser vía `<script type="text/babel">`.
- Supabase JS client cargado desde CDN (`cdn.jsdelivr.net/npm/@supabase/supabase-js@2`).
- **Implicación:** No hay `npm run build`. El deploy es publicar estáticos directamente.

### Autenticación (custom — sin Supabase Auth)
- Implementada manualmente con bcryptjs (hash en browser).
- Sesiones guardadas en `localStorage` (24 h de duración).
- Tabla: `usuarios_luisa` con columna `password_hash`.
- Helpers centralizados en `supabase-client.js`: `checkSession()`, `logout()`, `getCurrentUser()`, `getCurrentMedico()`.

### Netlify Function — `netlify/functions/claude.js`
- Único serverless endpoint: `POST /.netlify/functions/claude`
- Requiere env var `ANTHROPIC_API_KEY` (configurada en Netlify dashboard).
- CORS habilitado para todos los orígenes.
- Mapeo de modelos:
  - `claude-sonnet-4-6` → `claude-sonnet-4-20250514`
  - `claude-opus-4-1` → `claude-opus-4-20250514`
  - Default si no se especifica: `claude-sonnet-4-20250514`

### Routing SPA (netlify.toml)
```
/app        → app.html
/paciente   → paciente.html
/auth       → auth.html
/estudios   → estudios.html
/expediente → expediente.html
/*          → index.html
```

---

## ESTRUCTURA DE ARCHIVOS

```
LuIsA/
├── index.html              Landing page (marketing)         ~100 KB
├── auth.html               Login/Registro médico y paciente  ~24 KB
├── app.html                Dashboard del médico              ~142 KB
├── paciente.html           Portal del paciente               ~81 KB
├── estudios.html           Análisis IA de laboratorio        ~39 KB
├── expediente.html         Expediente compartido QR/token    ~21 KB
├── paciente-nuevo.html     Registro de nuevo paciente        ~18 KB
├── medico.html             Landing alternativa médico        ~142 KB
├── landing.html            Variante de landing               ~24 KB
│
├── supabase-client.js      Cliente Supabase + session helpers
├── netlify/functions/
│   └── claude.js           Proxy API Anthropic
│
├── netlify.toml            Config deploy, routing, CORS, headers
├── package.json            Deps: @anthropic-ai/sdk, netlify-cli
│
├── assets/
│   └── img/
│       ├── logo_horizontal.png
│       ├── logo_horizontal_2.png
│       └── logo_icono.png
│
├── *.sql                   Migraciones y seeds (~50 archivos, ~9 500 líneas)
├── *.js (root)             Scripts de población de datos (no van a producción)
│
├── .claude/
│   ├── settings.json       Permisos Claude Code (bypassPermissions: true)
│   └── launch.json         Dev server: npx serve -p 3030 .
│
├── CLAUDE.md               (este archivo)
├── README.md
├── START_HERE.md
├── QUICK_REFERENCE.md
├── DEPLOYMENT_NETLIFY.md
└── TEST_DATA_REPORT.md
```

### Archivos raíz que NO van a producción
Los siguientes son utilitarios de desarrollo y no afectan el deploy:
- `generate_test_data*.js`, `insert_*.js`, `final_batch_insert.js`, `debug_api.js`
- `*.ps1`, `*.sh` (scripts PowerShell/Shell)
- `_tmp_*.sql` (snippets temporales)
- `generate_test_data.py`

---

## PÁGINAS — DESCRIPCIÓN DETALLADA

| Archivo              | Rol               | Tecnología clave                            |
|---------------------|-------------------|---------------------------------------------|
| `index.html`        | Marketing landing  | Canvas animado, navbar, CTA, sin React       |
| `auth.html`         | Auth dual          | bcryptjs, Supabase, localStorage sesión      |
| `app.html`          | App médico         | React 18 inline, KPIs, agenda, dictación voz |
| `paciente.html`     | Portal paciente    | React 18 inline, expediente, medicamentos    |
| `estudios.html`     | Análisis laboratorio | PDF upload, Claude Vision, barras de probabilidad |
| `expediente.html`   | Expediente público | Solo lectura, acceso por QR/token, audit trail |
| `paciente-nuevo.html` | Registro paciente | Tailwind CSS, formulario NOM-024, multi-sección |
| `medico.html`       | Landing médico alt | DM Sans, pricing, testimoniales             |
| `landing.html`      | Landing variante   | Alternativa a index.html                    |

---

## BASE DE DATOS — SUPABASE

### Catálogos (26 tablas — prefijo `cat_`)
```
cat_estados_republica    cat_ciudades             cat_ocupaciones
cat_estado_civil         cat_grupos_etnicos       cat_religiones
cat_tipos_sanguineo      cat_discapacidades       cat_tipos_vivienda
cat_especialidades       cat_vias_administracion  cat_frecuencias_medicamento
cat_tipos_estudios       cat_unidades_medida      cat_diagnosticos
cat_medicamentos         cat_pronosticos          cat_niveles_socioeconomicos
cat_reacciones_alergicas cat_riesgos              cat_riesgos_quirurgicos
cat_tecnicas_quirurgicas cat_procedimientos_cie9  cat_tipos_servicios_auxiliares
cat_tipos_eventos_auditoria                       cat_estados_orden
```

### Tablas principales (15)
```
usuarios_luisa               medicos                    perfiles_pacientes
doctor_patient_relationships family_relationships       citas
historias_clinicas           notas_evolucion            notas_urgencias
notas_hospitalizacion        medicamentos_paciente      diario_eventos
vacunas_paciente             firma_electronica          auditoria_acciones
```

### Seguridad (RLS)
- Row-Level Security habilitado en todas las tablas principales.
- Políticas definidas en `luisa_rls_only.sql` y `luisa_v2_0_rls_audit_nom024.sql`.
- Acceso anónimo limitado definido en `luisa_rls_anon.sql`.
- Triggers de auditoría automática en `luisa_v2_0_triggers_auditoria_automatica.sql`.
- Triggers de validación/bloqueo en `luisa_v2_0_triggers_validaciones_bloqueos.sql`.

### Extensiones PostgreSQL requeridas
```sql
uuid-ossp   -- UUIDs
pg_trgm     -- búsqueda de texto
pgcrypto    -- hashing
```

### SQL files por categoría
| Tipo             | Archivos clave                                               |
|-----------------|--------------------------------------------------------------|
| Schema principal | `luisa_v2_migration.sql`, `luisa_v2_0_schema_redesign_nom004_nom024.sql` |
| Catálogos seed   | `luisa_v2_0_seed_catalogs_completo.sql`                      |
| Datos de prueba  | `luisa_v2_0_seed_test_data_*.sql` (médicos, pacientes, citas, historias) |
| Seguridad        | `luisa_rls_only.sql`, `luisa_v2_0_rls_audit_nom024.sql`      |
| Triggers         | `luisa_v2_0_triggers_auditoria_automatica.sql`, `..._validaciones_bloqueos.sql` |
| Todo-en-uno      | `LUISA_BD_COMPLETA_TODO_EN_UNO.sql`                         |

---

## DATOS DE PRUEBA CARGADOS

| Entidad         | Cantidad | Credenciales / Notas                        |
|----------------|----------|---------------------------------------------|
| Médicos         | 20       | medico001@hospital.mx … medico020 / pass: `medico1` |
| Pacientes       | 110      | Perfiles completos NOM-024                  |
| Citas           | 300      | Distribuidas en 30 días                     |
| Historias clínicas | 50+   | Notas SOAP estructuradas                    |
| Medicamentos activos | 100 | Asignados a pacientes                      |
| Vacunas         | 30       | Esquemas de vacunación                      |
| Usuarios totales | 130     |                                             |

---

## SISTEMA DE DISEÑO

### Variables CSS (consistentes en todos los archivos)
```css
--navy:  #050C1A    /* fondo principal */
--teal:  #00C9A7    /* acento primario */
--teal2: #00E5BB    /* acento hover */
--teal-dark: #00A88C
--cyan:  #38BDF8    /* acento secundario */
--blue:  #1B5499    /* azul institucional */
--white: #EEF4FF    /* texto/fondo claro */
--muted: #6B8BAE    /* texto secundario */
--gold:  #C9A84C    /* alertas / premium */
```

### Tipografía
| Fuente            | Uso                  |
|-------------------|----------------------|
| Inter             | UI general (400–900) |
| Playfair Display  | Títulos display      |
| JetBrains Mono    | Datos clínicos/código|
| DM Sans           | medico.html / landing|

### Componentes CSS comunes
- Botones: `.btn-primary` (teal), `.btn-secondary` (white), `.btn-outline`
- Cards: `.feature-card`, `.step-card`, `.plan-card`
- Badges: `.badge` + modificadores `critico`, `alto`, `bajo`
- Formularios: `.field` layout con inputs estilizados

---

## FLUJO DE DESARROLLO

### Ciclo normal
```bash
# 1. Editar archivos HTML/JS en rama de feature
git checkout -b feature/nombre-modulo

# 2. Probar localmente
npx serve -p 3030 .   # o: netlify dev

# 3. Commit y push
git add <archivos específicos>
git commit -m "feat: descripción concisa"
git push -u origin feature/nombre-modulo

# 4. Merge a master → Netlify auto-despliega
```

### Aplicar SQL en Supabase
```bash
SUPABASE_ACCESS_TOKEN=sbp_... supabase db query \
  --linked -f mi_script.sql -o table
```

### Probar Netlify Functions localmente
```bash
netlify dev   # expone /.netlify/functions/claude en localhost:8888
```

---

## MÓDULOS — ESTADO DE CONSTRUCCIÓN

### Fase 1 — Análisis ✅ COMPLETADO
Entidades: usuarios_luisa, medicos, perfiles_pacientes, citas, historias_clinicas,
medicamentos_paciente, diario_eventos, vacunas_paciente, notas_evolucion

Procesos clave:
1. Registro paciente → verificación identidad → perfil clínico inicial
2. Agenda cita → recordatorio → consulta → nota evolución
3. Consulta → dictación voz → extracción IA → firma electrónica
4. Prescripción → control adherencia → alertas vencimiento
5. Upload estudio → análisis IA → resultado → enviar paciente

### Módulos pendientes
| # | Módulo                             | Página objetivo |
|---|------------------------------------|-----------------|
| 1 | Dashboard médico con KPIs reales   | app.html        |
| 2 | Dictación voz → extracción SOAP    | app.html        |
| 3 | Análisis IA estudios laboratorio   | estudios.html   |
| 4 | Notificaciones y alertas automáticas | app.html / paciente.html |
| 5 | Agente IA de consulta clínica      | app.html        |

### Puntos de automatización IA
- Dictación de notas clínicas (Web Speech API / Whisper → Claude)
- Extracción SOAP de texto libre (Claude claude-sonnet-4-20250514)
- Análisis de laboratorio (PDF upload → Claude Vision)
- Alertas de medicamentos (vencimiento, interacciones)
- Resumen ejecutivo de expediente para médico

---

## DATA WAREHOUSE (esquema `dw_analitica`)

Definido en `luisa_v2_migration.sql`. Esquema estrella:

**Facts:**
- `fact_citas` — métricas de agenda
- `fact_consultas` — métricas clínicas

**Dims:**
- `dim_especialidad`, `dim_diagnostico`, `dim_medicamento`
- `dim_pacientes_anonimos`, `dim_medico`, `dim_tiempo`
- `fact_eventos_salud`

**6 tableros BI planificados:**
1. Operacional — citas del día, cancelaciones, ocupación
2. Clínico — diagnósticos frecuentes, comorbilidades
3. Farmacológico — medicamentos top, adherencia
4. Preventivo — vacunas, screening, detecciones
5. Financiero — productividad médico, consultas/hora
6. Epidemiológico — tendencias por especialidad y zona

---

## CONVENCIONES PARA IA / CLAUDE CODE

### Al editar HTML
- Mantener `<style>` con variables CSS al inicio del `<head>`.
- Cargar React / Babel / Supabase desde CDN (no agregar npm imports locales).
- No modificar la estructura de autenticación en `supabase-client.js` sin revisar todos los archivos que lo importan.
- `app.html` y `medico.html` son ~142 KB — leer por secciones, no completos de golpe.

### Al crear SQL
- Siempre verificar que las extensiones `uuid-ossp`, `pg_trgm`, `pgcrypto` estén activas.
- Nuevas migraciones deben respetar las políticas RLS existentes.
- Nunca DROP sin confirmación explícita del usuario.
- Nombrar archivos: `luisa_v2_0_<descripcion_concisa>.sql`

### Al usar la Claude API
- Siempre llamar al proxy: `POST /.netlify/functions/claude` (no llamar a api.anthropic.com directamente desde el browser).
- El modelo recomendado actual es `claude-sonnet-4-20250514`.
- `ANTHROPIC_API_KEY` es variable de entorno en Netlify — nunca hardcodearla.

### Seguridad
- No subir a git: API keys, tokens, passwords, `.env`.
- Los secrets van en `.claude/settings.local.json` (gitignored).
- La anon key de Supabase ES pública (diseño intencional de Supabase) — la seguridad real viene del RLS.
- No exponer `service_role` key del lado del cliente.

### Git
- Branch activo de esta sesión: `claude/claude-md-docs-nel4a8`
- Master = producción → auto-deploy inmediato
- Commits descriptivos en inglés o español consistente con el historial
- `git add <archivos específicos>` — nunca `git add -A` para evitar subir scripts temporales o datos sensibles
