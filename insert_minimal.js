const https = require('https');

const SUPABASE_URL = "https://kcpooneuqdbdavgivbdp.supabase.co/rest/v1";
const ANON_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtjcG9vbmV1cWRiZGF2Z2l2YmRwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODE1MTE3NDgsImV4cCI6MjA5NzA4Nzc0OH0.dWOhArXA8rv0Jzm-gajRlXtPkuwEg66GNF1YdygidNM";

function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

async function fetchData(table) {
  return new Promise((resolve) => {
    const url = `${SUPABASE_URL}/${table}?select=id&limit=200`;
    https.get(url, { headers: { 'apikey': ANON_KEY, 'Authorization': `Bearer ${ANON_KEY}` } }, (res) => {
      let body = '';
      res.on('data', c => body += c);
      res.on('end', () => {
        try {
          resolve(JSON.parse(body));
        } catch (e) {
          resolve([]);
        }
      });
    }).on('error', () => resolve([]));
  });
}

async function insertData(table, data) {
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
            resolve({ count: 0, status: res.statusCode, error: body.substring(0, 100) });
          }
        } catch (e) {
          resolve({ count: 0, status: res.statusCode });
        }
      });
    });

    req.on('error', () => resolve({ count: 0 }));
    req.write(json);
    req.end();
  });
}

async function main() {
  const medicos = await fetchData("medicos");
  const pacientes = await fetchData("perfiles_pacientes");

  console.log(`Medicos: ${medicos.length}, Pacientes: ${pacientes.length}\n`);

  const medico_ids = medicos.map(m => m.id);
  const paciente_ids = pacientes.map(p => p.id);

  // Insert Notas with MINIMAL fields
  console.log("Inserting Notas de Evolución (minimal fields)...");
  let notas_total = 0;

  for (let i = 0; i < 50; i += 5) {
    const chunk = [];
    for (let j = 0; j < 5 && i + j < 50; j++) {
      chunk.push({
        id_medico: medico_ids[(i + j) % medico_ids.length],
        id_paciente: paciente_ids[(i + j) % paciente_ids.length],
        fecha_nota: new Date(Date.now() - Math.random() * 30 * 86400000).toISOString(),
        evolucion_cuadro_clinico: "Paciente con evolución favorable"
      });
    }
    const r = await insertData("notas_evolucion", chunk);
    notas_total += r.count;
    console.log(`  Chunk ${i / 5 + 1}: ${r.count} inserted`);
    await sleep(500);
  }

  console.log(`Total Notas: ${notas_total}\n`);

  // Insert Historias with MINIMAL fields
  console.log("Inserting Historias Clínicas (minimal fields)...");
  let historias_total = 0;

  for (let i = 0; i < 20; i += 5) {
    const chunk = [];
    for (let j = 0; j < 5 && i + j < 20; j++) {
      chunk.push({
        id_medico: medico_ids[(i + j) % medico_ids.length],
        id_paciente: paciente_ids[i + j],
        fecha_elaboracion: new Date().toISOString(),
        padecimiento_actual: "Control de enfermedad crónica"
      });
    }
    const r = await insertData("historias_clinicas", chunk);
    historias_total += r.count;
    console.log(`  Chunk ${i / 5 + 1}: ${r.count} inserted`);
    await sleep(500);
  }

  console.log(`Total Historias: ${historias_total}\n`);

  console.log("=== SUMMARY ===");
  console.log(`Notas de Evolución: ${notas_total}`);
  console.log(`Vacunas Paciente: 25 (from previous run)`);
  console.log(`Historias Clínicas: ${historias_total}`);
  console.log(`TOTAL: ${notas_total + 25 + historias_total}`);
}

main();
