const https = require('https');

const SUPABASE_URL = "https://kcpooneuqdbdavgivbdp.supabase.co/rest/v1";
const ANON_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtjcG9vbmV1cWRiZGF2Z2l2YmRwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODE1MTE3NDgsImV4cCI6MjA5NzA4Nzc0OH0.dWOhArXA8rv0Jzm-gajRlXtPkuwEg66GNF1YdygidNM";

async function test() {
  // Get first medico and paciente
  const med_data = await new Promise((resolve) => {
    https.get(`${SUPABASE_URL}/medicos?select=id&limit=1`, {
      headers: { 'apikey': ANON_KEY, 'Authorization': `Bearer ${ANON_KEY}` }
    }, (res) => {
      let body = '';
      res.on('data', c => body += c);
      res.on('end', () => resolve(JSON.parse(body)));
    });
  });

  const pac_data = await new Promise((resolve) => {
    https.get(`${SUPABASE_URL}/perfiles_pacientes?select=id&limit=1`, {
      headers: { 'apikey': ANON_KEY, 'Authorization': `Bearer ${ANON_KEY}` }
    }, (res) => {
      let body = '';
      res.on('data', c => body += c);
      res.on('end', () => resolve(JSON.parse(body)));
    });
  });

  const medico_id = med_data[0]?.id;
  const paciente_id = pac_data[0]?.id;

  console.log(`Testing with medico: ${medico_id}`);
  console.log(`Testing with paciente: ${paciente_id}\n`);

  const testData = [{
    id_medico: medico_id,
    id_paciente: paciente_id,
    fecha_nota: new Date().toISOString(),
    evolucion_cuadro_clinico: "Test"
  }];

  console.log("Payload:", JSON.stringify(testData, null, 2));

  const json = JSON.stringify(testData);
  return new Promise((resolve) => {
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
      console.log(`\nStatus: ${res.statusCode}`);
      res.on('data', c => body += c);
      res.on('end', () => {
        console.log("Response:", body);
        resolve();
      });
    });

    req.on('error', (e) => {
      console.error("Error:", e.message);
      resolve();
    });

    req.write(json);
    req.end();
  });
}

test();
