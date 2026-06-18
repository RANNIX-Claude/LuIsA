const https = require('https');

const SUPABASE_URL = "https://kcpooneuqdbdavgivbdp.supabase.co/rest/v1";
const ANON_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtjcG9vbmV1cWRiZGF2Z2l2YmRwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODE1MTE3NDgsImV4cCI6MjA5NzA4Nzc0OH0.dWOhArXA8rv0Jzm-gajRlXtPkuwEg66GNF1YdygidNM";

async function getData(table) {
  return new Promise((resolve) => {
    https.get(`${SUPABASE_URL}/${table}?select=id&limit=200`, {
      headers: { 'apikey': ANON_KEY, 'Authorization': `Bearer ${ANON_KEY}` }
    }, (res) => {
      let body = '';
      res.on('data', c => body += c);
      res.on('end', () => {
        try {
          resolve(JSON.parse(body) || []);
        } catch (e) {
          resolve([]);
        }
      });
    }).on('error', () => resolve([]));
  });
}

async function insertOne(table, data) {
  return new Promise((resolve) => {
    const json = JSON.stringify([data]);
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

    const req = https.request(`${SUPABASE_URL}/${table}`, options, (res) => {
      let body = '';
      res.on('data', c => body += c);
      res.on('end', () => {
        const ok = res.statusCode === 201 || res.statusCode === 200;
        if (!ok) {
          resolve({ ok: false, status: res.statusCode, error: body.substring(0, 100) });
        } else {
          resolve({ ok: true, status: res.statusCode });
        }
      });
    });

    req.on('error', (e) => resolve({ ok: false, error: e.message }));
    req.write(json);
    req.end();
  });
}

async function main() {
  const medicos = await getData("medicos");
  const pacientes = await getData("perfiles_pacientes");

  console.log(`Medicos: ${medicos.length}, Pacientes: ${pacientes.length}\n`);

  const med_ids = medicos.map(m => m.id);
  const pac_ids = pacientes.map(p => p.id);

  // Test one insert with error info
  console.log("Testing single Notas de Evolución insert...");
  const testResult = await insertOne("notas_evolucion", {
    id_medico: med_ids[0],
    id_paciente: pac_ids[0],
    fecha_nota: new Date().toISOString(),
    evolucion_cuadro_clinico: "Test"
  });
  console.log("Result:", testResult);
  console.log();

  if (testResult.ok) {
    console.log("Testing single Historias insert...");
    const testHist = await insertOne("historias_clinicas", {
      id_medico: med_ids[0],
      id_paciente: pac_ids[0],
      fecha_elaboracion: new Date().toISOString(),
      padecimiento_actual: "Test"
    });
    console.log("Result:", testHist);
  }
}

main();
