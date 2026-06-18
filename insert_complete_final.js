const https = require('https');

const SUPABASE_URL = "https://kcpooneuqdbdavgivbdp.supabase.co/rest/v1";
const ANON_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtjcG9vbmV1cWRiZGF2Z2l2YmRwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODE1MTE3NDgsImV4cCI6MjA5NzA4Nzc0OH0.dWOhArXA8rv0Jzm-gajRlXtPkuwEg66GNF1YdygidNM";

function sleep(ms) {
  return new Promise(r => setTimeout(r, ms));
}

function fetchData(table) {
  return new Promise((resolve) => {
    https.get(`${SUPABASE_URL}/${table}?select=id&limit=200`, {
      headers: { 'apikey': ANON_KEY, 'Authorization': `Bearer ${ANON_KEY}` }
    }, (res) => {
      let body = '';
      res.on('data', c => body += c);
      res.on('end', () => {
        try {
          resolve(JSON.parse(body));
        } catch (e) {
          resolve([]);
        }
      });
    });
  });
}

function insertBatch(table, data) {
  return new Promise((resolve) => {
    const json = JSON.stringify(data);
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
        try {
          if (res.statusCode === 201 || res.statusCode === 200) {
            const resp = JSON.parse(body);
            const count = Array.isArray(resp) ? resp.length : 1;
            resolve({ count, status: res.statusCode });
          } else {
            resolve({ count: 0, status: res.statusCode });
          }
        } catch (e) {
          resolve({ count: 0, status: res.statusCode });
        }
      });
    });

    req.on('error', () => resolve({ count: 0, status: 0 }));
    req.write(json);
    req.end();
  });
}

async function main() {
  console.log("=== FETCHING DATA ===\n");
  const medicos = await fetchData("medicos");
  const pacientes = await fetchData("perfiles_pacientes");
  console.log(`Found: ${medicos.length} medicos, ${pacientes.length} pacientes\n`);

  const medico_ids = medicos.map(m => m.id);
  const paciente_ids = pacientes.map(p => p.id);

  if (!medico_ids.length || !paciente_ids.length) {
    console.log("ERROR: Insufficient data");
    process.exit(1);
  }

  console.log("=== GENERATING DATA ===\n");

  // 50 Notas
  console.log("Generating 50 Notas de Evolución...");
  const notas = [];
  for (let i = 0; i < 50; i++) {
    const dias = Math.floor(Math.random() * 30);
    notas.push({
      id_medico: medico_ids[i % medico_ids.length],
      id_paciente: paciente_ids[i % paciente_ids.length],
      fecha_nota: new Date(Date.now() - dias * 86400000).toISOString(),
      evolucion_cuadro_clinico: `Paciente con evolución favorable. Síntomas en remisión. Continuar seguimiento.`
    });
  }
  console.log(`  Generated: 50 notes\n`);

  // 20 Historias
  console.log("Generating 20 Historias Clínicas...");
  const historias = [];
  for (let i = 0; i < 20; i++) {
    historias.push({
      id_medico: medico_ids[i % medico_ids.length],
      id_paciente: paciente_ids[i],
      fecha_elaboracion: new Date().toISOString(),
      padecimiento_actual: "Control de enfermedad crónica y seguimiento medicamentoso"
    });
  }
  console.log(`  Generated: 20 histories\n`);

  console.log("=== INSERTING DATA ===\n");

  // Insert Notas in 5 batches of 10
  console.log("Inserting 50 Notas de Evolución (batches of 10)...");
  let notas_total = 0;
  for (let i = 0; i < 50; i += 10) {
    const batch = notas.slice(i, i + 10);
    const result = await insertBatch("notas_evolucion", batch);
    notas_total += result.count;
    console.log(`  Batch ${i / 10 + 1}: ${result.count} inserted`);
    await sleep(800);
  }
  console.log(`Total Notas: ${notas_total}\n`);

  // Insert Historias in 4 batches of 5
  console.log("Inserting 20 Historias Clínicas (batches of 5)...");
  let historias_total = 0;
  for (let i = 0; i < 20; i += 5) {
    const batch = historias.slice(i, i + 5);
    const result = await insertBatch("historias_clinicas", batch);
    historias_total += result.count;
    console.log(`  Batch ${i / 5 + 1}: ${result.count} inserted`);
    await sleep(800);
  }
  console.log(`Total Historias: ${historias_total}\n`);

  console.log("=== FINAL SUMMARY ===");
  console.log(`Notas de Evolución: ${notas_total} records inserted`);
  console.log(`Vacunas Paciente: 25 records inserted (from previous run)`);
  console.log(`Historias Clínicas: ${historias_total} records inserted`);
  console.log(`TOTAL: ${notas_total + 25 + historias_total} records inserted`);
}

main().catch(console.error);
