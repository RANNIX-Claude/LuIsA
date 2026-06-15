// ============================================================================
// LUISA v2.0 - Supabase Client & Helpers
// Compartido entre app.html (médico) e index.html (paciente)
// ============================================================================

const SUPABASE_URL = 'https://isxspjlwuzbbtpamkknq.supabase.co';
const SUPABASE_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImlzeHNwamx3dXpiYnRwYW1ra25xIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzk4MDYwMjMsImV4cCI6MjA5NTM4MjAyM30.D5iWO9K7137hFW_pBx9xYASHFfnyUcDthi9_A-6pksA';

const sb = supabase.createClient(SUPABASE_URL, SUPABASE_KEY);

// ============================================================================
// SESSION MANAGEMENT
// ============================================================================

async function checkSession() {
  // Usar nuestra propia sesión en localStorage (no Supabase Auth)
  const sessionStr = localStorage.getItem('luisa_session');
  if (!sessionStr) {
    window.location.href = '/auth.html';
    return null;
  }

  try {
    const session = JSON.parse(sessionStr);

    // Verificar que la sesión no esté expirada (24 horas)
    const SESSION_DURATION = 24 * 60 * 60 * 1000;
    if (Date.now() - session.timestamp > SESSION_DURATION) {
      localStorage.removeItem('luisa_user');
      localStorage.removeItem('luisa_session');
      window.location.href = '/auth.html';
      return null;
    }

    // Devolver objeto similar a Supabase Auth session
    return {
      user: session.user
    };
  } catch (e) {
    console.error('Error parsing session:', e);
    window.location.href = '/auth.html';
    return null;
  }
}

async function logout() {
  localStorage.removeItem('luisa_user');
  localStorage.removeItem('luisa_session');
  window.location.href = '/auth.html';
}

// Obtener usuario actual de localStorage
function getCurrentUser() {
  const userStr = localStorage.getItem('luisa_user');
  if (!userStr) return null;
  try {
    return JSON.parse(userStr);
  } catch (e) {
    return null;
  }
}

// ============================================================================
// MÉDICO - Get current doctor profile
// ============================================================================

async function getCurrentMedico() {
  const session = await checkSession();
  if (!session) return null;

  // JOIN: medicos + usuarios_luisa + cat_especialidades
  const { data, error } = await sb
    .from('medicos')
    .select(`
      *,
      usuarios_luisa:id_usuario (
        nombre_completo,
        email,
        documento_identidad
      ),
      cat_especialidades:especialidad_id (
        nombre,
        codigo
      )
    `)
    .eq('id_usuario', session.user.id)
    .single();

  if (error) {
    console.error('Error loading médico:', error);
    return null;
  }

  // Aplanar la estructura para que el frontend la pueda usar
  if (data) {
    data.nombre_completo = data.usuarios_luisa?.nombre_completo || session.user.nombre_completo;
    data.email = data.usuarios_luisa?.email || session.user.email;
    data.especialidad_nombre = data.cat_especialidades?.nombre || 'Medicina General';
    // Los campos foto_url, firma_digital, telefono, consultorio_* ya vienen de data.*
  }

  return data;
}

// ============================================================================
// MÉDICO - Actualizar perfil (foto, firma, datos del consultorio)
// ============================================================================

async function actualizarPerfilMedico(updates) {
  const session = await checkSession();
  if (!session) return null;

  const { data, error } = await sb
    .from('medicos')
    .update(updates)
    .eq('id_usuario', session.user.id)
    .select()
    .single();

  if (error) {
    console.error('Error actualizando perfil:', error);
    return null;
  }
  return data;
}

// ============================================================================
// PACIENTE - Get current patient profile
// ============================================================================

async function getCurrentPaciente() {
  const session = await checkSession();
  if (!session) return null;

  const { data, error } = await sb
    .from('perfiles_pacientes')
    .select('*')
    .eq('id_usuario', session.user.id)
    .single();

  if (error) {
    console.error('Error loading paciente:', error);
    return null;
  }
  return data;
}

// ============================================================================
// MÉDICO - Get list of patients assigned to doctor
// ============================================================================

async function getMedicoPatients(idMedico) {
  const { data, error } = await sb
    .from('doctor_patient_relationships')
    .select(`
      id_paciente,
      perfiles_pacientes(*)
    `)
    .eq('id_medico', idMedico)
    .eq('activo', true);

  if (error) {
    console.error('Error loading patients:', error);
    return [];
  }
  return data.map(rel => rel.perfiles_pacientes);
}

// ============================================================================
// CITAS - Get appointments
// ============================================================================

async function getCitas(filterMedicoOrPaciente) {
  let query = sb.from('citas').select('*');

  if (filterMedicoOrPaciente.id_medico) {
    query = query.eq('id_medico', filterMedicoOrPaciente.id_medico);
  }
  if (filterMedicoOrPaciente.id_paciente) {
    query = query.eq('id_paciente', filterMedicoOrPaciente.id_paciente);
  }

  const { data, error } = await query.order('fecha_hora', { ascending: true });

  if (error) {
    console.error('Error loading citas:', error);
    return [];
  }
  return data || [];
}

async function createCita(cita) {
  const { data, error } = await sb
    .from('citas')
    .insert([cita])
    .select()
    .single();

  if (error) {
    console.error('Error creating cita:', error);
    return null;
  }
  return data;
}

async function updateCita(id, updates) {
  const { data, error } = await sb
    .from('citas')
    .update(updates)
    .eq('id', id)
    .select()
    .single();

  if (error) {
    console.error('Error updating cita:', error);
    return null;
  }
  return data;
}

// ============================================================================
// MEDICAMENTOS - Get patient medications
// ============================================================================

async function getPacienteMedicamentos(idPaciente) {
  const { data, error } = await sb
    .from('medicamentos_paciente')
    .select(`
      *,
      cat_medicamentos(nombre),
      cat_vias_administracion(nombre, abreviatura),
      cat_frecuencias_medicamento(nombre, valor_horas)
    `)
    .eq('id_paciente', idPaciente)
    .eq('activo', true);

  if (error) {
    console.error('Error loading medications:', error);
    return [];
  }
  return data || [];
}

// ============================================================================
// EVENTOS - Log health events (glucose, symptoms, etc)
// ============================================================================

async function createDiarioEvento(evento) {
  const { data, error } = await sb
    .from('diario_eventos')
    .insert([evento])
    .select()
    .single();

  if (error) {
    console.error('Error creating evento:', error);
    return null;
  }
  return data;
}

async function getPacienteEventos(idPaciente, limit = 50) {
  const { data, error } = await sb
    .from('diario_eventos')
    .select('*')
    .eq('id_paciente', idPaciente)
    .order('fecha', { ascending: false })
    .limit(limit);

  if (error) {
    console.error('Error loading eventos:', error);
    return [];
  }
  return data || [];
}

// ============================================================================
// NOTAS DE EVOLUCIÓN - Medical notes
// ============================================================================

async function createNotaEvolucion(nota) {
  const { data, error } = await sb
    .from('notas_evolucion')
    .insert([nota])
    .select()
    .single();

  if (error) {
    console.error('Error creating nota:', error);
    return null;
  }
  return data;
}

async function getNotasEvolucion(idPaciente) {
  const { data, error } = await sb
    .from('notas_evolucion')
    .select('*')
    .eq('id_paciente', idPaciente)
    .order('fecha_nota', { ascending: false });

  if (error) {
    console.error('Error loading notas:', error);
    return [];
  }
  return data || [];
}

// ============================================================================
// VACUNAS - Vaccination history
// ============================================================================

async function getVacunasPaciente(idPaciente) {
  const { data, error } = await sb
    .from('vacunas_paciente')
    .select('*')
    .eq('id_paciente', idPaciente)
    .order('fecha_aplicacion', { ascending: false });

  if (error) {
    console.error('Error loading vacunas:', error);
    return [];
  }
  return data || [];
}

// ============================================================================
// UTILITIES
// ============================================================================

function formatDate(isoDate) {
  if (!isoDate) return '—';
  const date = new Date(isoDate);
  return date.toLocaleDateString('es-MX', {
    day: '2-digit',
    month: 'short',
    year: 'numeric'
  });
}

function formatTime(isoDate) {
  if (!isoDate) return '—';
  const date = new Date(isoDate);
  return date.toLocaleTimeString('es-MX', {
    hour: '2-digit',
    minute: '2-digit'
  });
}

function formatDateTime(isoDate) {
  return `${formatDate(isoDate)} ${formatTime(isoDate)}`;
}

// ============================================================================
// ERROR HANDLING
// ============================================================================

function showError(message) {
  const notif = document.createElement('div');
  notif.className = 'notification error';
  notif.innerHTML = `
    <div style="background:#DC2626;color:white;padding:16px;border-radius:8px;box-shadow:0 4px 12px rgba(0,0,0,0.2)">
      <strong>Error:</strong> ${message}
    </div>
  `;
  document.body.appendChild(notif);

  setTimeout(() => notif.remove(), 4000);
}

function showSuccess(message) {
  const notif = document.createElement('div');
  notif.className = 'notification success';
  notif.innerHTML = `
    <div style="background:#059669;color:white;padding:16px;border-radius:8px;box-shadow:0 4px 12px rgba(0,0,0,0.2)">
      <strong>✓</strong> ${message}
    </div>
  `;
  document.body.appendChild(notif);

  setTimeout(() => notif.remove(), 3000);
}
