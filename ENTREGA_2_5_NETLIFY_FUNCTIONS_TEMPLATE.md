 🔌 ENTREGA 2.5: Plantillas Netlify Functions

**Propósito:** Crear las funciones backend que conectan app.html/paciente.html con el módulo familiar de BD  
**Ubicación:** `.netlify/functions/`  
**Lenguaje:** Node.js + Supabase Client SDK  

---

## 📋 Índice de Funciones

| Función | Método | Propósito | Usuario |
|---------|--------|----------|---------|
| `obtener_familiares_administrados` | GET | Lista familiares que administra | Administrador |
| `verificar_permiso_familiar` | POST | Valida si tiene permiso específico | App/Médico |
| `crear_permiso_familiar` | POST | Otorga nuevo permiso | Administrador/Paciente |
| `revocar_permiso_familiar` | POST | Desactiva permiso | Paciente |
| `obtener_auditoria_familiar` | GET | Ver qué cambios hizo | Paciente/Médico |

---

## 🔧 Prerequisitos

### En `.netlify/functions/package.json`:
```json
{
  "dependencies": {
    "@supabase/supabase-js": "^2.38.0"
  }
}
```

### Variables de entorno (Netlify Settings)
```
SUPABASE_URL=https://xxxx.supabase.co
SUPABASE_ANON_KEY=ey...
```

### Archivo auxiliar: `supabase-client.js`
```javascript
const { createClient } = require('@supabase/supabase-js');

const supabaseUrl = process.env.SUPABASE_URL;
const supabaseKey = process.env.SUPABASE_ANON_KEY;

const supabase = createClient(supabaseUrl, supabaseKey);

module.exports = supabase;
```

---

## 1️⃣ Función: `obtener_familiares_administrados.js`

**Propósito:** Obtener lista de familiares que un administrador gestiona  
**Método:** GET  
**Parámetros:** Usuario autenticado (auth.uid)  
**Retorna:** Array de familiares con permisos  

### Código:

```javascript
// .netlify/functions/obtener_familiares_administrados.js

const supabase = require('./supabase-client');

exports.handler = async (event, context) => {
  // CORS
  if (event.httpMethod === 'OPTIONS') {
    return {
      statusCode: 200,
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Headers': 'Content-Type, Authorization'
      }
    };
  }

  try {
    // Obtener usuario autenticado del header
    const authHeader = event.headers.authorization;
    if (!authHeader) {
      return {
        statusCode: 401,
        body: JSON.stringify({ error: 'No authorization header' })
      };
    }

    const token = authHeader.replace('Bearer ', '');

    // Verificar token y obtener usuario
    const { data: { user }, error: authError } = 
      await supabase.auth.getUser(token);

    if (authError || !user) {
      return {
        statusCode: 401,
        body: JSON.stringify({ error: 'Invalid token' })
      };
    }

    // Llamar función SQL que retorna familiares administrados
    const { data, error } = await supabase
      .rpc('obtener_familiares_administrados', {
        p_id_administrador: user.id
      });

    if (error) {
      console.error('RPC error:', error);
      return {
        statusCode: 400,
        body: JSON.stringify({ error: error.message })
      };
    }

    return {
      statusCode: 200,
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        success: true,
        data: data || [],
        count: (data || []).length
      })
    };

  } catch (error) {
    console.error('Handler error:', error);
    return {
      statusCode: 500,
      body: JSON.stringify({
        error: error.message || 'Internal server error'
      })
    };
  }
};
```

### Uso en app.html:

```javascript
// Obtener mis familiares administrados
async function obtenerMisFamiliares() {
  const token = localStorage.getItem('auth_token');
  
  const response = await fetch(
    '/.netlify/functions/obtener_familiares_administrados',
    {
      method: 'GET',
      headers: {
        'Authorization': `Bearer ${token}`,
        'Content-Type': 'application/json'
      }
    }
  );

  const result = await response.json();
  
  if (result.success) {
    // result.data es array de {
    //   id_paciente, nombre, apellido_paterno, relacion,
    //   puede_ver, puede_editar, fecha_vencimiento
    // }
    console.log('Mis familiares:', result.data);
    return result.data;
  } else {
    console.error('Error:', result.error);
    return [];
  }
}

// Mostrar lista en HTML
async function mostrarMisFamiliares() {
  const familiares = await obtenerMisFamiliares();
  
  const listaHTML = familiares.map(f => `
    <div class="familiar-card">
      <h3>${f.nombre} ${f.apellido_paterno}</h3>
      <p>Relación: ${f.relacion}</p>
      <p>Puede ver: ${f.puede_ver ? '✅' : '❌'}</p>
      <p>Puede editar: ${f.puede_editar ? '✅' : '❌'}</p>
      ${f.fecha_vencimiento ? 
        `<p>Vencimiento: ${new Date(f.fecha_vencimiento).toLocaleDateString()}</p>` 
        : ''}
      <button onclick="verExpediente('${f.id_paciente}')">
        Ver Expediente
      </button>
    </div>
  `).join('');
  
  document.getElementById('mis-familiares').innerHTML = listaHTML;
}
```

---

## 2️⃣ Función: `verificar_permiso_familiar.js`

**Propósito:** Validar si un administrador tiene permiso específico  
**Método:** POST  
**Body:** 
```json
{
  "id_paciente": "UUID",
  "tipo_permiso": "ver_expediente|editar_datos|gestionar_citas|..."
}
```
**Retorna:** `{ permitido: true/false }`

### Código:

```javascript
// .netlify/functions/verificar_permiso_familiar.js

const supabase = require('./supabase-client');

exports.handler = async (event) => {
  if (event.httpMethod === 'OPTIONS') {
    return {
      statusCode: 200,
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Headers': 'Content-Type, Authorization'
      }
    };
  }

  try {
    // Obtener usuario
    const authHeader = event.headers.authorization;
    const token = authHeader.replace('Bearer ', '');
    const { data: { user } } = await supabase.auth.getUser(token);

    if (!user) {
      return {
        statusCode: 401,
        body: JSON.stringify({ error: 'Not authenticated' })
      };
    }

    // Parsear body
    const { id_paciente, tipo_permiso } = JSON.parse(event.body);

    if (!id_paciente || !tipo_permiso) {
      return {
        statusCode: 400,
        body: JSON.stringify({
          error: 'Missing: id_paciente or tipo_permiso'
        })
      };
    }

    // Tipos de permiso válidos
    const permisoValidos = [
      'ver_expediente',
      'editar_datos',
      'gestionar_citas',
      'gestionar_medicamentos',
      'solicitar_estudios',
      'firmar_consentimientos',
      'descargar_expediente',
      'compartir_terceros',
      'autorizar_procedimientos',
      'ver_auditoria'
    ];

    if (!permisoValidos.includes(tipo_permiso)) {
      return {
        statusCode: 400,
        body: JSON.stringify({
          error: `Invalid permission type. Valid: ${permisoValidos.join(', ')}`
        })
      };
    }

    // Llamar función SQL
    const { data, error } = await supabase
      .rpc('verificar_permiso_familiar', {
        p_id_administrador: user.id,
        p_id_paciente: id_paciente,
        p_tipo_permiso: tipo_permiso
      });

    if (error) {
      console.error('RPC error:', error);
      return {
        statusCode: 400,
        body: JSON.stringify({ error: error.message })
      };
    }

    return {
      statusCode: 200,
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        success: true,
        permitido: data === true,
        tipo_permiso: tipo_permiso
      })
    };

  } catch (error) {
    console.error('Handler error:', error);
    return {
      statusCode: 500,
      body: JSON.stringify({ error: error.message })
    };
  }
};
```

### Uso en app.html:

```javascript
// Verificar si puedo hacer algo con un paciente
async function puedoVerExpediente(idPaciente) {
  const token = localStorage.getItem('auth_token');
  
  const response = await fetch(
    '/.netlify/functions/verificar_permiso_familiar',
    {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${token}`,
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        id_paciente: idPaciente,
        tipo_permiso: 'ver_expediente'
      })
    }
  );

  const result = await response.json();
  return result.permitido === true;
}

// Usar en código
async function accederExpediente(idPaciente) {
  const tienePermiso = await puedoVerExpediente(idPaciente);
  
  if (tienePermiso) {
    // Mostrar expediente
    console.log('Acceso permitido');
  } else {
    // Mostrar error
    alert('No tienes permiso para ver este expediente');
  }
}
```

---

## 3️⃣ Función: `crear_permiso_familiar.js`

**Propósito:** Otorgar nuevo permiso de administración  
**Método:** POST  
**Body:**
```json
{
  "id_paciente_vinculado": "UUID",
  "relacion_codigo": "madre|padre|esposo|hijo|tutor_legal|apoderado",
  "puede_ver_expediente": true,
  "puede_editar_datos_paciente": true,
  "puede_gestionar_citas": true,
  "puede_gestionar_medicamentos": false,
  "puede_solicitar_estudios": false,
  "puede_firmar_consentimientos": false,
  "puede_descargar_expediente": false,
  "puede_compartir_con_terceros": false,
  "puede_autorizar_procedimientos": false,
  "puede_ver_auditoria": true,
  "fecha_vencimiento": "2026-12-31T23:59:59Z",
  "razon": "Madre autorizada para administrar expediente del hijo"
}
```

### Código:

```javascript
// .netlify/functions/crear_permiso_familiar.js

const supabase = require('./supabase-client');

exports.handler = async (event) => {
  if (event.httpMethod === 'OPTIONS') {
    return {
      statusCode: 200,
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Headers': 'Content-Type, Authorization'
      }
    };
  }

  try {
    // Obtener usuario
    const authHeader = event.headers.authorization;
    const token = authHeader.replace('Bearer ', '');
    const { data: { user } } = await supabase.auth.getUser(token);

    if (!user) {
      return {
        statusCode: 401,
        body: JSON.stringify({ error: 'Not authenticated' })
      };
    }

    // Parsear body
    const body = JSON.parse(event.body);
    const {
      id_paciente_vinculado,
      relacion_codigo,
      puede_ver_expediente = true,
      puede_editar_datos_paciente = false,
      puede_gestionar_citas = false,
      puede_gestionar_medicamentos = false,
      puede_solicitar_estudios = false,
      puede_firmar_consentimientos = false,
      puede_descargar_expediente = false,
      puede_compartir_con_terceros = false,
      puede_autorizar_procedimientos = false,
      puede_ver_auditoria = true,
      fecha_vencimiento = null,
      razon = ''
    } = body;

    // Validaciones
    if (!id_paciente_vinculado) {
      return {
        statusCode: 400,
        body: JSON.stringify({ error: 'Missing: id_paciente_vinculado' })
      };
    }

    if (id_paciente_vinculado === user.id) {
      return {
        statusCode: 400,
        body: JSON.stringify({
          error: 'No puedes ser administrador de ti mismo'
        })
      };
    }

    // Obtener ID de relación
    const { data: relacionData, error: relError } = 
      await supabase
        .from('cat_relaciones_familiares')
        .select('id')
        .eq('codigo', relacion_codigo)
        .single();

    if (relError || !relacionData) {
      return {
        statusCode: 400,
        body: JSON.stringify({
          error: `Invalid relationship type: ${relacion_codigo}`
        })
      };
    }

    // Crear permiso
    const { data, error } = await supabase
      .from('permisos_expediente_familiar')
      .insert({
        id_administrador: user.id,
        id_paciente_vinculado,
        relacion_familiar_id: relacionData.id,
        puede_ver_expediente,
        puede_editar_datos_paciente,
        puede_gestionar_citas,
        puede_gestionar_medicamentos,
        puede_solicitar_estudios,
        puede_firmar_consentimientos,
        puede_descargar_expediente,
        puede_compartir_con_terceros,
        puede_autorizar_procedimientos,
        puede_ver_auditoria,
        fecha_vencimiento,
        razon,
        otorgado_por: user.id
      })
      .select('*')
      .single();

    if (error) {
      console.error('Insert error:', error);
      
      // Mensaje específico si ya existe
      if (error.message.includes('permisos_unicos')) {
        return {
          statusCode: 409,
          body: JSON.stringify({
            error: 'Ya existen permisos para este paciente'
          })
        };
      }

      return {
        statusCode: 400,
        body: JSON.stringify({ error: error.message })
      };
    }

    // Registrar auditoría
    await supabase
      .rpc('registrar_accion_familiar', {
        p_id_administrador: user.id,
        p_id_paciente: id_paciente_vinculado,
        p_tipo_accion: 'INSERT',
        p_tabla_modificada: 'permisos_expediente_familiar',
        p_descripcion: `Creó permiso de administración: ${razon}`
      });

    return {
      statusCode: 201,
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        success: true,
        permiso: data,
        message: 'Permiso creado exitosamente'
      })
    };

  } catch (error) {
    console.error('Handler error:', error);
    return {
      statusCode: 500,
      body: JSON.stringify({ error: error.message })
    };
  }
};
```

### Uso en app.html:

```javascript
// Crear nuevo permiso
async function otorgarPermisoFamiliar() {
  const token = localStorage.getItem('auth_token');
  
  const response = await fetch(
    '/.netlify/functions/crear_permiso_familiar',
    {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${token}`,
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        id_paciente_vinculado: '12345-uuid-juan',
        relacion_codigo: 'madre',
        puede_ver_expediente: true,
        puede_editar_datos_paciente: true,
        puede_gestionar_citas: true,
        puede_gestionar_medicamentos: true,
        razon: 'Madre autorizada para administrar expediente del hijo'
      })
    }
  );

  const result = await response.json();
  
  if (result.success) {
    alert('Permiso otorgado exitosamente');
    console.log('Nuevo permiso:', result.permiso);
  } else {
    alert('Error: ' + result.error);
  }
}
```

---

## 4️⃣ Función: `revocar_permiso_familiar.js`

**Propósito:** Desactivar/revocar un permiso  
**Método:** POST  
**Body:**
```json
{
  "id_permiso": "UUID"
}
```

### Código:

```javascript
// .netlify/functions/revocar_permiso_familiar.js

const supabase = require('./supabase-client');

exports.handler = async (event) => {
  if (event.httpMethod === 'OPTIONS') {
    return {
      statusCode: 200,
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Headers': 'Content-Type, Authorization'
      }
    };
  }

  try {
    // Obtener usuario
    const authHeader = event.headers.authorization;
    const token = authHeader.replace('Bearer ', '');
    const { data: { user } } = await supabase.auth.getUser(token);

    if (!user) {
      return {
        statusCode: 401,
        body: JSON.stringify({ error: 'Not authenticated' })
      };
    }

    const { id_permiso } = JSON.parse(event.body);

    if (!id_permiso) {
      return {
        statusCode: 400,
        body: JSON.stringify({ error: 'Missing: id_permiso' })
      };
    }

    // Obtener permiso para verificar propiedad
    const { data: permiso, error: getError } = await supabase
      .from('permisos_expediente_familiar')
      .select('id_administrador, id_paciente_vinculado')
      .eq('id', id_permiso)
      .single();

    if (getError || !permiso) {
      return {
        statusCode: 404,
        body: JSON.stringify({ error: 'Permiso no encontrado' })
      };
    }

    // Solo puede revocar:
    // - El paciente afectado (para cualquier administrador)
    // - El administrador (para sí mismo)
    if (permiso.id_paciente_vinculado !== user.id && 
        permiso.id_administrador !== user.id) {
      return {
        statusCode: 403,
        body: JSON.stringify({
          error: 'No tienes permiso para revocar este permiso'
        })
      };
    }

    // Revocar (desactivar)
    const { data, error } = await supabase
      .from('permisos_expediente_familiar')
      .update({
        activo: false,
        updated_at: new Date().toISOString()
      })
      .eq('id', id_permiso)
      .select('*')
      .single();

    if (error) {
      return {
        statusCode: 400,
        body: JSON.stringify({ error: error.message })
      };
    }

    // Registrar auditoría
    await supabase
      .rpc('registrar_accion_familiar', {
        p_id_administrador: permiso.id_administrador,
        p_id_paciente: permiso.id_paciente_vinculado,
        p_tipo_accion: 'UPDATE',
        p_tabla_modificada: 'permisos_expediente_familiar',
        p_descripcion: `Permiso revocado por usuario ${user.id}`
      });

    return {
      statusCode: 200,
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        success: true,
        message: 'Permiso revocado',
        permiso: data
      })
    };

  } catch (error) {
    console.error('Handler error:', error);
    return {
      statusCode: 500,
      body: JSON.stringify({ error: error.message })
    };
  }
};
```

---

## 5️⃣ Función: `obtener_auditoria_familiar.js`

**Propósito:** Ver cambios realizados por administrador  
**Método:** GET  
**Query params:** `?id_paciente=UUID` (opcional)  
**Retorna:** Array de acciones auditadas

### Código:

```javascript
// .netlify/functions/obtener_auditoria_familiar.js

const supabase = require('./supabase-client');

exports.handler = async (event) => {
  if (event.httpMethod === 'OPTIONS') {
    return {
      statusCode: 200,
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Headers': 'Content-Type, Authorization'
      }
    };
  }

  try {
    // Obtener usuario
    const authHeader = event.headers.authorization;
    const token = authHeader.replace('Bearer ', '');
    const { data: { user } } = await supabase.auth.getUser(token);

    if (!user) {
      return {
        statusCode: 401,
        body: JSON.stringify({ error: 'Not authenticated' })
      };
    }

    // Parámetros opcionales
    const idPaciente = event.queryStringParameters?.id_paciente;
    const limite = parseInt(event.queryStringParameters?.limite) || 50;

    // Construir query
    let query = supabase
      .from('auditoria_acciones_familiares')
      .select('*')
      .order('fecha_evento', { ascending: false })
      .limit(limite);

    // Filtrar por paciente si se proporciona
    if (idPaciente) {
      query = query.eq('id_paciente_afectado', idPaciente);
    }

    // Filtrar por administrador (si es paciente, ve cambios de SUS administradores)
    // Si es médico, puede ver su propia auditoría
    query = query.or(
      `id_administrador.eq.${user.id},id_paciente_afectado.eq.${user.id}`
    );

    const { data, error } = await query;

    if (error) {
      console.error('Query error:', error);
      return {
        statusCode: 400,
        body: JSON.stringify({ error: error.message })
      };
    }

    return {
      statusCode: 200,
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        success: true,
        datos: data || [],
        total: (data || []).length
      })
    };

  } catch (error) {
    console.error('Handler error:', error);
    return {
      statusCode: 500,
      body: JSON.stringify({ error: error.message })
    };
  }
};
```

### Uso en paciente.html:

```javascript
// Ver cambios realizados en MI expediente
async function verAuditoriaDelMioExpediente() {
  const token = localStorage.getItem('auth_token');
  const miID = localStorage.getItem('usuario_id');
  
  const response = await fetch(
    `/.netlify/functions/obtener_auditoria_familiar?id_paciente=${miID}`,
    {
      method: 'GET',
      headers: {
        'Authorization': `Bearer ${token}`,
        'Content-Type': 'application/json'
      }
    }
  );

  const result = await response.json();
  
  if (result.success) {
    console.log('Cambios en mi expediente:', result.datos);
    
    // Mostrar tabla
    const tabla = result.datos.map(accion => `
      <tr>
        <td>${new Date(accion.fecha_evento).toLocaleString()}</td>
        <td>${accion.tipo_accion}</td>
        <td>${accion.descripcion}</td>
        <td>${accion.ip_address || 'N/A'}</td>
      </tr>
    `).join('');
    
    document.querySelector('#auditoria tbody').innerHTML = tabla;
  }
}
```

---

## 📋 Checklist para Crear Funciones

- [ ] Crear carpeta `.netlify/functions/` (si no existe)
- [ ] Crear `supabase-client.js` en esa carpeta
- [ ] Crear `obtener_familiares_administrados.js`
- [ ] Crear `verificar_permiso_familiar.js`
- [ ] Crear `crear_permiso_familiar.js`
- [ ] Crear `revocar_permiso_familiar.js`
- [ ] Crear `obtener_auditoria_familiar.js`
- [ ] Actualizar `.netlify/functions/package.json` con @supabase/supabase-js
- [ ] Configurar variables de entorno en Netlify Dashboard:
  - `SUPABASE_URL`
  - `SUPABASE_ANON_KEY`
- [ ] Probar cada función con Postman o curl
- [ ] Integrar en app.html
- [ ] Integrar en paciente.html

---

## 🧪 Testing con cURL

### Test 1: Obtener familiares
```bash
curl -X GET \
  'http://localhost:8888/.netlify/functions/obtener_familiares_administrados' \
  -H 'Authorization: Bearer TOKEN_AQUI' \
  -H 'Content-Type: application/json'
```

### Test 2: Verificar permiso
```bash
curl -X POST \
  'http://localhost:8888/.netlify/functions/verificar_permiso_familiar' \
  -H 'Authorization: Bearer TOKEN_AQUI' \
  -H 'Content-Type: application/json' \
  -d '{
    "id_paciente": "UUID_PACIENTE",
    "tipo_permiso": "ver_expediente"
  }'
```

### Test 3: Crear permiso
```bash
curl -X POST \
  'http://localhost:8888/.netlify/functions/crear_permiso_familiar' \
  -H 'Authorization: Bearer TOKEN_AQUI' \
  -H 'Content-Type: application/json' \
  -d '{
    "id_paciente_vinculado": "UUID",
    "relacion_codigo": "madre",
    "puede_ver_expediente": true,
    "puede_editar_datos_paciente": true,
    "razon": "Test"
  }'
```

---

## 🚀 Próximos Pasos

1. **Copiar código** de cada función a su archivo correspondiente
2. **Actualizar** `.netlify/functions/package.json` con Supabase SDK
3. **Configurar** variables de entorno en Netlify Dashboard
4. **Ejecutar** `npm install --prefix .netlify/functions`
5. **Testing** local con `netlify dev`
6. **Integrar** en app.html y paciente.html
7. **Deploy** a Netlify

---

**✅ Plantillas listas para copiar y usar.**

Tiempo estimado de implementación: 2-3 horas
