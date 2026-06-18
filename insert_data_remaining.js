const https = require('https');

const SUPABASE_URL = "https://kcpooneuqdbdavgivbdp.supabase.co/rest/v1";
const ANON_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtjcG9vbmV1cWRiZGF2Z2l2YmRwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODE1MTE3NDgsImV4cCI6MjA5NzA4Nzc0OH0.dWOhArXA8rv0Jzm-gajRlXtPkuwEg66GNF1YdygidNM";

function fetchData(table) {
  return new Promise((resolve) => {
    const url = `${SUPABASE_URL}/${table}?select=id&limit=200`;
    const options = {
      method: 'GET',
      headers: {
        'apikey': ANON_KEY,
        'Authorization': `Bearer ${ANON_KEY}`,
        'Content-Type': 'application/json'
      }
    };

    const req = https.request(url, options, (res) => {
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
    req.end();
  });
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
          const resp = JSON.parse(body);
          resolve({ count: Array.isArray(resp) ? resp.length : 1, status: res.statusCode });
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
  console.log("=== FETCHING EXISTING DATA ===\n");
  const medicos = await fetchData("medicos");
  const pacientes = await fetchData("perfiles_pacientes");
  console.log(`Found: ${medicos.length} medicos, ${pacientes.length} pacientes\n`);

  const medico_ids = medicos.map(m => m.id).slice(0, 20);
  const paciente_ids = pacientes.map(p => p.id).slice(0, 110);

  if (!medico_ids.length || !paciente_ids.length) {
    console.log("ERROR: No data found!");
    process.exit(1);
  }

  console.log("=== GENERATING DATA ===\n");

  // Generate 50 Notas de Evolución
  console.log("Generating 50 Clinical Evolution Notes...");
  const notas = [];
  const evol_texts = [
    "Paciente con evolución favorable. Síntomas en remisión. Continuar con tratamiento actual.",
    "Mejora parcial observada. Signos vitales estables. Seguimiento en una semana.",
    "Respuesta positiva al tratamiento. Paciente refiere mejoría significativa.",
    "Cuadro clínico estable. Recomendación de seguimiento estrecho en próximas 48 horas.",
    "Evolución sostenida. Cumplimiento adecuado con medicamentos prescritos."
  ];

  for (let i = 0; i < 50; i++) {
    const med_idx = i % medico_ids.length;
    const pac_idx = i % paciente_ids.length;
    const days_back = Math.floor(Math.random() * 30);
    const fecha = new Date(Date.now() - days_back * 24 * 60 * 60 * 1000).toISOString();

    notas.push({
      id_medico: medico_ids[med_idx],
      id_paciente: paciente_ids[pac_idx],
      fecha_nota: fecha,
      evolucion_cuadro_clinico: evol_texts[i % evol_texts.length],
      signos_vitales: {
        fc: 60 + Math.floor(Math.random() * 30),
        fr: 12 + Math.floor(Math.random() * 8),
        temperatura: 36 + Math.random() * 1.5,
        ta_sistolica: 110 + Math.floor(Math.random() * 40),
        ta_diastolica: 70 + Math.floor(Math.random() * 20)
      },
      diagnosticos_problemas_clinicos: [
        { diagnostico: ["Hipertensión", "Diabetes", "Cefalea", "Infección respiratoria"][i % 4], cie10: "I10" }
      ],
      tratamiento_indicaciones: [
        { medicamento: ["Losartán", "Metformina", "Paracetamol", "Amoxicilina"][i % 4], dosis: "standard" }
      ],
      pronostico: "Favorable",
      firmado: Math.random() > 0.3
    });
  }
  console.log("  Generated: 50 notes");

  // Generate 30 Vacunas
  console.log("Generating 30 Vaccine Records...");
  const vacunas = [];
  const vac_names = ["COVID-19", "Influenza", "DPT", "Varicela", "MMR", "Polio", "Hepatitis B", "Dengue", "Neumococo", "Meningococo"];
  const fabricantes = ["Pfizer", "Moderna", "AstraZeneca", "Sanofi", "Merck", "Johnson & Johnson"];

  for (let i = 0; i < 30; i++) {
    const fecha_dias_atras = Math.floor(Math.random() * 180);
    const fecha = new Date(Date.now() - fecha_dias_atras * 24 * 60 * 60 * 1000).toISOString().split('T')[0];

    vacunas.push({
      id_paciente: paciente_ids[i % paciente_ids.length],
      nombre_vacuna: vac_names[i % vac_names.length],
      fabricante: fabricantes[i % fabricantes.length],
      numero_lote: `LOT${String(Math.floor(Math.random() * 100000)).padStart(5, '0')}`,
      fecha_aplicacion: fecha
    });
  }
  console.log("  Generated: 30 vaccine records");

  // Generate 20 Historias Clínicas
  console.log("Generating 20 Clinical History Records...");
  const historias = [];
  const fecha_hoy = new Date().toISOString();

  for (let i = 0; i < 20; i++) {
    historias.push({
      id_medico: medico_ids[i % medico_ids.length],
      id_paciente: paciente_ids[i],
      fecha_elaboracion: fecha_hoy,
      padecimiento_actual: "Control de enfermedad crónica. Seguimiento medicamentoso.",
      signos_vitales: {
        fc: 78,
        fr: 16,
        temperatura: 36.8,
        ta_sistolica: 120,
        ta_diastolica: 80
      },
      diagnosticos_problemas_clinicos: [
        { diagnostico: "Hipertensión Arterial", cie10: "I10" },
        { diagnostico: "Diabetes Mellitus Tipo 2", cie10: "E11" }
      ],
      pronostico_descripcion: "Favorable con adherencia al tratamiento",
      indicacion_terapeutica: "Mantener medicamentos actuales. Seguimiento mensual. Referir a especialidades según sea necesario.",
      firmado: true
    });
  }
  console.log("  Generated: 20 clinical histories");

  console.log("\n=== INSERTING DATA ===\n");

  console.log("Inserting 50 Notas de Evolución...");
  let r1 = await insertData("notas_evolucion", notas);
  if (r1.status === 201 || r1.status === 200) {
    console.log(`  SUCCESS: ${r1.count} records inserted`);
  } else {
    console.log(`  FAILED (HTTP ${r1.status})`);
  }

  console.log("Inserting 30 Vacunas Paciente...");
  let r2 = await insertData("vacunas_paciente", vacunas);
  if (r2.status === 201 || r2.status === 200) {
    console.log(`  SUCCESS: ${r2.count} records inserted`);
  } else {
    console.log(`  FAILED (HTTP ${r2.status})`);
  }

  console.log("Inserting 20 Historias Clínicas...");
  let r3 = await insertData("historias_clinicas", historias);
  if (r3.status === 201 || r3.status === 200) {
    console.log(`  SUCCESS: ${r3.count} records inserted`);
  } else {
    console.log(`  FAILED (HTTP ${r3.status})`);
  }

  console.log("\n=== FINAL SUMMARY ===");
  console.log(`Notas de Evolución: ${r1.count} records inserted`);
  console.log(`Vacunas Paciente: ${r2.count} records inserted`);
  console.log(`Historias Clínicas: ${r3.count} records inserted`);
  console.log(`TOTAL: ${r1.count + r2.count + r3.count} records inserted`);
}

main().catch(console.error);
