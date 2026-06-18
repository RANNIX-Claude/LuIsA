const https = require('https');

const SUPABASE_URL = "https://kcpooneuqdbdavgivbdp.supabase.co/rest/v1";
const ANON_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtjcG9vbmV1cWRiZGF2Z2l2YmRwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODE1MTE3NDgsImV4cCI6MjA5NzA4Nzc0OH0.dWOhArXA8rv0Jzm-gajRlXtPkuwEg66GNF1YdygidNM";

function fetchData(table) {
  return new Promise((resolve) => {
    const url = `${SUPABASE_URL}/${table}?select=id&limit=200`;
    const req = https.get(url, { headers: { 'apikey': ANON_KEY, 'Authorization': `Bearer ${ANON_KEY}` } }, (res) => {
      let body = '';
      res.on('data', chunk => body += chunk);
      res.on('end', () => {
        try {
          resolve(JSON.parse(body));
        } catch (e) {
          resolve([]);
        }
      });
    });
    req.on('error', () => resolve([]));
  });
}

function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

function insertData(table, data) {
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
      res.on('data', chunk => body += chunk);
      res.on('end', () => {
        try {
          if (res.statusCode === 201 || res.statusCode === 200) {
            const resp = JSON.parse(body);
            resolve({ count: Array.isArray(resp) ? resp.length : 1, status: res.statusCode });
          } else {
            resolve({ count: 0, status: res.statusCode, error: body.substring(0, 100) });
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

async function insertInChunks(table, dataList, chunkSize = 10, delayMs = 500) {
  let totalInserted = 0;
  for (let i = 0; i < dataList.length; i += chunkSize) {
    const chunk = dataList.slice(i, i + chunkSize);
    const result = await insertData(table, chunk);
    totalInserted += result.count;
    if (result.error) {
      console.log(`    Chunk ${i / chunkSize + 1}: ${result.count} inserted (HTTP ${result.status})`);
    } else {
      console.log(`    Chunk ${i / chunkSize + 1}: ${result.count} inserted`);
    }
    if (i + chunkSize < dataList.length) {
      await sleep(delayMs);
    }
  }
  return totalInserted;
}

async function main() {
  console.log("=== FETCHING EXISTING DATA ===\n");

  const medicos = await fetchData("medicos");
  const pacientes = await fetchData("perfiles_pacientes");

  console.log(`Found: ${medicos.length} medicos, ${pacientes.length} pacientes\n`);

  if (!medicos.length || !pacientes.length) {
    console.log("ERROR: Not enough data!");
    process.exit(1);
  }

  const medico_ids = medicos.map(m => m.id);
  const paciente_ids = pacientes.map(p => p.id);

  console.log("=== GENERATING DATA ===\n");

  // Generate Notas
  const notas = [];
  for (let i = 0; i < 50; i++) {
    const dias = Math.floor(Math.random() * 30);
    notas.push({
      id_medico: medico_ids[i % medico_ids.length],
      id_paciente: paciente_ids[i % paciente_ids.length],
      fecha_nota: new Date(Date.now() - dias * 86400000).toISOString(),
      evolucion_cuadro_clinico: "Evolución favorable del paciente",
      signos_vitales: { fc: 75, fr: 16, temperatura: 36.8, ta_sistolica: 120, ta_diastolica: 80 },
      diagnosticos_problemas_clinicos: [{ diagnostico: "Hipertensión", cie10: "I10" }],
      tratamiento_indicaciones: [{ medicamento: "Losartán", dosis: "50mg" }],
      pronostico: "Favorable",
      firmado: false
    });
  }

  // Generate Vacunas
  const vacunas = [];
  const names = ["COVID-19", "Influenza", "DPT", "Varicela", "MMR"];
  for (let i = 0; i < 30; i++) {
    const dias = Math.floor(Math.random() * 180);
    vacunas.push({
      id_paciente: paciente_ids[i % paciente_ids.length],
      nombre_vacuna: names[i % names.length],
      fabricante: "Pfizer",
      numero_lote: `LOT${i}`,
      fecha_aplicacion: new Date(Date.now() - dias * 86400000).toISOString().split('T')[0]
    });
  }

  // Generate Historias
  const historias = [];
  for (let i = 0; i < 20; i++) {
    historias.push({
      id_medico: medico_ids[i % medico_ids.length],
      id_paciente: paciente_ids[i],
      fecha_elaboracion: new Date().toISOString(),
      padecimiento_actual: "Control de enfermedad crónica",
      signos_vitales: { fc: 78, fr: 16, temperatura: 36.8, ta_sistolica: 120, ta_diastolica: 80 },
      diagnosticos_problemas_clinicos: [{ diagnostico: "Hipertensión", cie10: "I10" }],
      pronostico_descripcion: "Favorable",
      indicacion_terapeutica: "Seguimiento mensual",
      firmado: true
    });
  }

  console.log("=== INSERTING DATA (SLOW MODE) ===\n");

  console.log("Inserting 50 Notas de Evolución (5 per request)...");
  const notas_count = await insertInChunks("notas_evolucion", notas, 5, 1000);
  console.log(`Total: ${notas_count} inserted\n`);

  console.log("Inserting 30 Vacunas Paciente (5 per request)...");
  const vacunas_count = await insertInChunks("vacunas_paciente", vacunas, 5, 1000);
  console.log(`Total: ${vacunas_count} inserted\n`);

  console.log("Inserting 20 Historias Clínicas (5 per request)...");
  const historias_count = await insertInChunks("historias_clinicas", historias, 5, 1000);
  console.log(`Total: ${historias_count} inserted\n`);

  console.log("=== FINAL SUMMARY ===");
  console.log(`Notas de Evolución: ${notas_count} records inserted`);
  console.log(`Vacunas Paciente: ${vacunas_count} records inserted`);
  console.log(`Historias Clínicas: ${historias_count} records inserted`);
  console.log(`TOTAL: ${notas_count + vacunas_count + historias_count} records inserted`);
}

main().catch(console.error);
