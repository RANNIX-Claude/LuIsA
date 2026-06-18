const https = require('https');

const SUPABASE_URL = "https://kcpooneuqdbdavgivbdp.supabase.co/rest/v1";
const ANON_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtjcG9vbmV1cWRiZGF2Z2l2YmRwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODE1MTE3NDgsImV4cCI6MjA5NzA4Nzc0OH0.dWOhArXA8rv0Jzm-gajRlXtPkuwEg66GNF1YdygidNM";

// Known UUIDs from successful curl test
const SAMPLE_MED_ID = "5a48fda5-c72f-4e8a-a8da-7b70e197d24c";
const SAMPLE_PAC_ID = "238f1a61-5368-49c0-804c-b5bba9f69c76";

function getUUIDs() {
  return new Promise((resolve) => {
    https.get(`${SUPABASE_URL}/medicos?select=id&limit=20`, {
      headers: { 'apikey': ANON_KEY, 'Authorization': `Bearer ${ANON_KEY}` }
    }, (res) => {
      let body = '';
      res.on('data', c => body += c);
      res.on('end', () => {
        try {
          const meds = JSON.parse(body);
          https.get(`${SUPABASE_URL}/perfiles_pacientes?select=id&limit=110`, {
            headers: { 'apikey': ANON_KEY, 'Authorization': `Bearer ${ANON_KEY}` }
          }, (res2) => {
            let body2 = '';
            res2.on('data', c => body2 += c);
            res2.on('end', () => {
              try {
                const pacs = JSON.parse(body2);
                resolve({ meds, pacs });
              } catch (e) {
                resolve({ meds, pacs: [] });
              }
            });
          });
        } catch (e) {
          resolve({ meds: [], pacs: [] });
        }
      });
    });
  });
}

function insertBatch(table, records) {
  return new Promise((resolve) => {
    const data = JSON.stringify(records);
    const options = {
      method: 'POST',
      headers: {
        'apikey': ANON_KEY,
        'Authorization': `Bearer ${ANON_KEY}`,
        'Content-Type': 'application/json',
        'Prefer': 'return=representation',
        'Content-Length': data.length
      }
    };

    const req = https.request(`${SUPABASE_URL}/${table}`, options, (res) => {
      let body = '';
      res.on('data', c => body += c);
      res.on('end', () => {
        try {
          if (res.statusCode === 201 || res.statusCode === 200) {
            const parsed = JSON.parse(body);
            const count = Array.isArray(parsed) ? parsed.length : 1;
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
    req.write(data);
    req.end();
  });
}

async function sleep(ms) {
  return new Promise(r => setTimeout(r, ms));
}

async function main() {
  console.log("Fetching UUIDs...");
  const { meds, pacs } = await getUUIDs();

  console.log(`Found ${meds.length} medicos and ${pacs.length} pacientes\n`);

  const med_ids = meds.map(m => m.id);
  const pac_ids = pacs.map(p => p.id);

  console.log("=== INSERTING 50 NOTAS DE EVOLUCIÓN (batches of 5) ===");
  let notas_total = 0;

  for (let i = 0; i < 50; i += 5) {
    const batch = [];
    for (let j = 0; j < 5 && i + j < 50; j++) {
      const idx = i + j;
      batch.push({
        id_medico: med_ids[idx % med_ids.length],
        id_paciente: pac_ids[idx % pac_ids.length],
        fecha_nota: new Date(Date.now() - Math.floor(Math.random() * 30) * 86400000).toISOString(),
        evolucion_cuadro_clinico: "Paciente con evolución favorable"
      });
    }

    const result = await insertBatch("notas_evolucion", batch);
    notas_total += result.count;
    console.log(`Batch ${i / 5 + 1}: ${result.count} inserted (HTTP ${result.status})`);
    await sleep(500);
  }

  console.log(`Total Notas: ${notas_total}\n`);

  console.log("=== INSERTING 20 HISTORIAS CLÍNICAS (batches of 5) ===");
  let hist_total = 0;

  for (let i = 0; i < 20; i += 5) {
    const batch = [];
    for (let j = 0; j < 5 && i + j < 20; j++) {
      const idx = i + j;
      batch.push({
        id_medico: med_ids[idx % med_ids.length],
        id_paciente: pac_ids[idx],
        fecha_elaboracion: new Date().toISOString(),
        padecimiento_actual: "Control de enfermedad crónico"
      });
    }

    const result = await insertBatch("historias_clinicas", batch);
    hist_total += result.count;
    console.log(`Batch ${i / 5 + 1}: ${result.count} inserted (HTTP ${result.status})`);
    await sleep(500);
  }

  console.log(`Total Historias: ${hist_total}\n`);

  console.log("=== FINAL SUMMARY ===");
  console.log(`Notas de Evolución: ${notas_total} records inserted`);
  console.log(`Vacunas Paciente: 25 records inserted`);
  console.log(`Historias Clínicas: ${hist_total} records inserted`);
  console.log(`TOTAL: ${notas_total + 25 + hist_total} records inserted`);
}

main().catch(e => console.error(e));
