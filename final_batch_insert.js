const https = require('https');

const SUPABASE_URL = "https://kcpooneuqdbdavgivbdp.supabase.co/rest/v1";
const ANON_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtjcG9vbmV1cWRiZGF2Z2l2YmRwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODE1MTE3NDgsImV4cCI6MjA5NzA4Nzc0OH0.dWOhArXA8rv0Jzm-gajRlXtPkuwEg66GNF1YdygidNM";

async function request(method, path, data = null) {
  return new Promise((resolve) => {
    const json = data ? JSON.stringify(data) : null;
    const options = {
      method,
      headers: {
        'apikey': ANON_KEY,
        'Authorization': `Bearer ${ANON_KEY}`,
        'Content-Type': 'application/json',
        ...(json && { 'Content-Length': json.length })
      }
    };

    const req = https.request(`${SUPABASE_URL}${path}`, options, (res) => {
      let body = '';
      res.on('data', c => body += c);
      res.on('end', () => {
        try {
          resolve({ status: res.statusCode, data: JSON.parse(body) });
        } catch (e) {
          resolve({ status: res.statusCode, data: null });
        }
      });
    });

    req.on('error', () => resolve({ status: 0, data: null }));
    if (json) req.write(json);
    req.end();
  });
}

async function main() {
  // Get data
  const medRes = await request('GET', '/medicos?select=id&limit=20');
  const pacRes = await request('GET', '/perfiles_pacientes?select=id&limit=110');

  const meds = medRes.data || [];
  const pacs = pacRes.data || [];

  console.log(`Medicos: ${meds.length}, Pacientes: ${pacs.length}\n`);

  if (meds.length === 0 || pacs.length === 0) {
    console.log("ERROR: No data!");
    return;
  }

  const med_ids = meds.map(m => m.id);
  const pac_ids = pacs.map(p => p.id);

  console.log(`First medico: ${med_ids[0]}`);
  console.log(`First paciente: ${pac_ids[0]}\n`);

  // Insert 50 notas
  console.log("Inserting 50 Notas de Evolución in batches...");
  let notas_count = 0;

  for (let batch_start = 0; batch_start < 50; batch_start += 5) {
    const records = [];
    for (let i = batch_start; i < Math.min(batch_start + 5, 50); i++) {
      records.push({
        id_medico: med_ids[i % med_ids.length],
        id_paciente: pac_ids[i % pac_ids.length],
        fecha_nota: new Date(Date.now() - Math.floor(Math.random() * 30) * 86400000).toISOString(),
        evolucion_cuadro_clinico: "Evolución favorable del paciente"
      });
    }

    const res = await request('POST', '/notas_evolucion', records);
    const count = (res.data && Array.isArray(res.data)) ? res.data.length : 0;
    notas_count += count;
    console.log(`  Batch ${batch_start / 5 + 1}: ${count} inserted (HTTP ${res.status})`);

    await new Promise(r => setTimeout(r, 1000));
  }

  console.log(`Total Notas: ${notas_count}\n`);

  // Insert 20 historias
  console.log("Inserting 20 Historias Clínicas in batches...");
  let hist_count = 0;

  for (let batch_start = 0; batch_start < 20; batch_start += 5) {
    const records = [];
    for (let i = batch_start; i < Math.min(batch_start + 5, 20); i++) {
      records.push({
        id_medico: med_ids[i % med_ids.length],
        id_paciente: pac_ids[i],
        fecha_elaboracion: new Date().toISOString(),
        padecimiento_actual: "Control de enfermedad crónica"
      });
    }

    const res = await request('POST', '/historias_clinicas', records);
    const count = (res.data && Array.isArray(res.data)) ? res.data.length : 0;
    hist_count += count;
    console.log(`  Batch ${batch_start / 5 + 1}: ${count} inserted (HTTP ${res.status})`);

    await new Promise(r => setTimeout(r, 1000));
  }

  console.log(`Total Historias: ${hist_count}\n`);

  console.log("=== FINAL SUMMARY ===");
  console.log(`Notas de Evolución: ${notas_count} records`);
  console.log(`Vacunas Paciente: 25 records`);
  console.log(`Historias Clínicas: ${hist_count} records`);
  console.log(`TOTAL: ${notas_count + 25 + hist_count} records inserted`);
}

main();
