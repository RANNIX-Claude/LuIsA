const https = require('https');

const SUPABASE_URL = "https://kcpooneuqdbdavgivbdp.supabase.co/rest/v1";
const ANON_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtjcG9vbmV1cWRiZGF2Z2l2YmRwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODE1MTE3NDgsImV4cCI6MjA5NzA4Nzc0OH0.dWOhArXA8rv0Jzm-gajRlXtPkuwEg66GNF1YdygidNM";

// Test single record with verbose error
const testRecord = {
  id_medico: "test-uuid",
  id_paciente: "test-uuid",
  fecha_nota: new Date().toISOString(),
  evolucion_cuadro_clinico: "Test evolution",
  signos_vitales: { fc: 75, fr: 16, temperatura: 36.8, ta_sistolica: 120, ta_diastolica: 80 },
  diagnosticos_problemas_clinicos: [{ diagnostico: "Test", cie10: "I10" }],
  tratamiento_indicaciones: [{ medicamento: "Test", dosis: "1mg" }],
  pronostico: "Favorable",
  firmado: false
};

console.log("Testing Notas de Evolución insertion with single record...\n");
console.log("Payload:", JSON.stringify([testRecord], null, 2));

const json = JSON.stringify([testRecord]);
const options = {
  method: 'POST',
  headers: {
    'apikey': ANON_KEY,
    'Authorization': `Bearer ${ANON_KEY}`,
    'Content-Type': 'application/json',
    'Prefer': 'return=representation',
    'Content-Length': json.length
  }
};

const req = https.request(`${SUPABASE_URL}/notas_evolucion`, options, (res) => {
  let body = '';
  console.log("\nStatus:", res.statusCode);
  console.log("Headers:", JSON.stringify(res.headers, null, 2));
  res.on('data', chunk => body += chunk);
  res.on('end', () => {
    console.log("\nResponse body:");
    console.log(body);
  });
});

req.on('error', (e) => {
  console.error("Error:", e.message);
});

req.write(json);
req.end();
