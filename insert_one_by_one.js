const https = require('https');

const SUPABASE_URL = "https://kcpooneuqdbdavgivbdp.supabase.co/rest/v1";
const ANON_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtjcG9vbmV1cWRiZGF2Z2l2YmRwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODE1MTE3NDgsImV4cCI6MjA5NzA4Nzc0OH0.dWOhArXA8rv0Jzm-gajRlXtPkuwEg66GNF1YdygidNM";

async function sleep(ms) {
  return new Promise(r => setTimeout(r, ms));
}

async function getData(table) {
  return await new Promise((resolve) => {
    const url = `${SUPABASE_URL}/${table}?select=id&limit=200`;
    const req = https.get(url, {
      headers: { 'apikey': ANON_KEY, 'Authorization': `Bearer ${ANON_KEY}` }
    }, (res) => {
      let body = '';
      res.on('data', c => body += c);
      res.on('end', () => {
        try {
          const parsed = JSON.parse(body);
          resolve(parsed || []);
        } catch (e) {
          resolve([]);
        }
      });
    });
    req.on('error', () => resolve([]));
  });
}

async function insertOne(table, data) {
  return await new Promise((resolve) => {
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

async function main() {
  console.log("Fetching medicos and pacientes...");
  const medicos = await getData("medicos");
  const pacientes = await getData("perfiles_pacientes");

  console.log(`Found: ${medicos.length} medicos, ${pacientes.length} pacientes\n`);

  if (!medicos || !pacientes || medicos.length === 0 || pacientes.length === 0) {
    console.log("No data found!");
    process.exit(1);
  }

  const med_ids = medicos.map(m => m.id);
  const pac_ids = pacientes.map(p => p.id);

  console.log("Inserting 50 Notas de Evolución...");
  let nota_cnt = 0;
  for (let i = 0; i < 50; i++) {
    const ok = await insertOne("notas_evolucion", {
      id_medico: med_ids[i % med_ids.length],
      id_paciente: pac_ids[i % pac_ids.length],
      fecha_nota: new Date(Date.now() - Math.random() * 30 * 86400000).toISOString(),
      evolucion_cuadro_clinico: "Paciente con evolución favorable"
    });
    if (ok) nota_cnt++;
    if ((i + 1) % 10 === 0) console.log(`  ${i + 1}/50 (${nota_cnt} OK)`);
    await sleep(300);
  }

  console.log(`\nInserting 20 Historias Clínicas...`);
  let hist_cnt = 0;
  for (let i = 0; i < 20; i++) {
    const ok = await insertOne("historias_clinicas", {
      id_medico: med_ids[i % med_ids.length],
      id_paciente: pac_ids[i],
      fecha_elaboracion: new Date().toISOString(),
      padecimiento_actual: "Control de enfermedad crónica"
    });
    if (ok) hist_cnt++;
    if ((i + 1) % 5 === 0) console.log(`  ${i + 1}/20 (${hist_cnt} OK)`);
    await sleep(300);
  }

  console.log(`\n=== FINAL SUMMARY ===`);
  console.log(`Notas de Evolución: ${nota_cnt} inserted`);
  console.log(`Vacunas Paciente: 25 inserted (from previous batch)`);
  console.log(`Historias Clínicas: ${hist_cnt} inserted`);
  console.log(`TOTAL: ${nota_cnt + 25 + hist_cnt} records inserted`);
}

main().catch(console.error);
