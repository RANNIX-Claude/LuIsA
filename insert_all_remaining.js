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
        resolve(res.statusCode === 201 || res.statusCode === 200);
      });
    });

    req.on('error', () => resolve(false));
    req.write(json);
    req.end();
  });
}

async function sleep(ms) {
  return new Promise(r => setTimeout(r, ms));
}

async function main() {
  const medicos = await getData("medicos");
  const pacientes = await getData("perfiles_pacientes");

  console.log(`Data found: ${medicos.length} medicos, ${pacientes.length} pacientes\n`);

  const med_ids = medicos.map(m => m.id);
  const pac_ids = pacientes.map(p => p.id);

  console.log("=== INSERTING 50 NOTAS DE EVOLUCIÓN ===");
  let nota_cnt = 0;
  for (let i = 0; i < 50; i++) {
    const ok = await insertOne("notas_evolucion", {
      id_medico: med_ids[i % med_ids.length],
      id_paciente: pac_ids[i % pac_ids.length],
      fecha_nota: new Date(Date.now() - Math.floor(Math.random() * 30) * 86400000).toISOString(),
      evolucion_cuadro_clinico: "Paciente con evolución favorable. Síntomas en remisión."
    });
    if (ok) nota_cnt++;
    if ((i + 1) % 10 === 0) {
      console.log(`Progress: ${i + 1}/50 (${nota_cnt} inserted)`);
    }
    await sleep(200);
  }
  console.log(`TOTAL NOTAS: ${nota_cnt}\n`);

  console.log("=== INSERTING 20 HISTORIAS CLÍNICAS ===");
  let hist_cnt = 0;
  for (let i = 0; i < 20; i++) {
    const ok = await insertOne("historias_clinicas", {
      id_medico: med_ids[i % med_ids.length],
      id_paciente: pac_ids[i],
      fecha_elaboracion: new Date().toISOString(),
      padecimiento_actual: "Control de enfermedad crónica y seguimiento medicamentoso"
    });
    if (ok) hist_cnt++;
    if ((i + 1) % 5 === 0) {
      console.log(`Progress: ${i + 1}/20 (${hist_cnt} inserted)`);
    }
    await sleep(200);
  }
  console.log(`TOTAL HISTORIAS: ${hist_cnt}\n`);

  console.log("=== FINAL SUMMARY ===");
  console.log(`Notas de Evolución: ${nota_cnt} records inserted`);
  console.log(`Vacunas Paciente: 25 records inserted (previous batch)`);
  console.log(`Historias Clínicas: ${hist_cnt} records inserted`);
  console.log(`TOTAL: ${nota_cnt + 25 + hist_cnt} records inserted`);
}

main().catch(console.error);
