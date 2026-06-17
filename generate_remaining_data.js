const https = require('https');

// Simple UUID v4 generator
function uuidv4() {
    return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
        const r = (Math.random() * 16) | 0;
        const v = c === 'x' ? r : (r & 0x3) | 0x8;
        return v.toString(16);
    });
}

// Credenciales Supabase
const SUPABASE_URL = "https://kcpooneuqdbdavgivbdp.supabase.co";
const SUPABASE_ANON_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtjcG9vbmV1cWRiZGF2Z2l2YmRwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODE1MTE3NDgsImV4cCI6MjA5NzA4Nzc0OH0.dWOhArXA8rv0Jzm-gajRlXtPkuwEg66GNF1YdygidNM";

const headers = {
    "Authorization": `Bearer ${SUPABASE_ANON_KEY}`,
    "apikey": SUPABASE_ANON_KEY,
    "Content-Type": "application/json"
};

// Datos para generación
const NOTAS_SUBJETIVAS = [
    "Paciente refiere dolor de cabeza intermitente desde hace 3 días, acompañado de mareos al cambiar de posición.",
    "Consulta por control de diabetes mellitus tipo 2. Refiere cumplimiento con medicamentos. Glucemias en casa promedio 140-160.",
    "Paciente acude por molestias abdominales postprandiales. Niega síntomas de alarma. Toma omeprazol regularmente.",
    "Refiere fatiga generalizada y dificultad para concentrarse en el trabajo durante la última semana.",
    "Paciente reporta aumento de peso de 3 kg en el último mes a pesar de dieta. Sigue siendo sedentario.",
    "Acude por revisión de presión arterial. Reporta stress laboral importante. Cumple con antihipertensivos.",
    "Consulta por molestia en articulación de rodilla izquierda al subir escaleras hace 2 semanas."
];

const NOTAS_OBJETIVAS = [
    "TA: 145/92, FC: 78, FR: 16, Temp: 36.8, Peso: 85kg, Talla: 1.75m, IMC: 27.8",
    "TA: 130/85, FC: 72, FR: 14, Temp: 36.9, Peso: 78kg, Talla: 1.68m, IMC: 27.6",
    "TA: 155/95, FC: 82, FR: 17, Temp: 37.0, Peso: 92kg, Talla: 1.72m, IMC: 31.1",
    "TA: 125/80, FC: 70, FR: 15, Temp: 36.7, Peso: 70kg, Talla: 1.65m, IMC: 25.7",
    "TA: 140/88, FC: 75, FR: 16, Temp: 36.8, Peso: 88kg, Talla: 1.80m, IMC: 27.2"
];

const VACUNAS = [
    "Influenza", "COVID-19", "Hepatitis B", "Tétanos", "Neumocócica",
    "Herpes Zóster", "Meningocócica", "Tosferina", "Sarampión", "Varicela"
];

// IDs que cargaremos dinámicamente
let PACIENTE_IDS = [];
let MEDICO_IDS = [];
let FRECUENCIA_IDS = [];
let VIA_ADMIN_IDS = [];
let MEDICAMENTO_IDS = [];

function getTable(tableName, limit = 500) {
    return new Promise((resolve) => {
        const url = new URL(`${SUPABASE_URL}/rest/v1/${tableName}?limit=${limit}`);
        const options = {
            hostname: url.hostname,
            path: url.pathname + url.search,
            method: 'GET',
            headers: headers
        };

        const req = https.request(options, (res) => {
            let data = '';
            res.on('data', chunk => data += chunk);
            res.on('end', () => {
                try {
                    const parsed = JSON.parse(data);
                    resolve(Array.isArray(parsed) ? parsed : []);
                } catch (e) {
                    console.log(`Error parsing ${tableName}:`, e.message);
                    resolve([]);
                }
            });
        });

        req.on('error', (e) => {
            console.log(`Error fetching ${tableName}:`, e.message);
            resolve([]);
        });

        req.end();
    });
}

function postToSupabase(table, data) {
    return new Promise((resolve) => {
        const url = new URL(`${SUPABASE_URL}/rest/v1/${table}`);
        const body = JSON.stringify(data);

        const options = {
            hostname: url.hostname,
            path: url.pathname + url.search,
            method: 'POST',
            headers: {
                ...headers,
                'Content-Length': Buffer.byteLength(body)
            }
        };

        const req = https.request(options, (res) => {
            let responseData = '';
            res.on('data', chunk => responseData += chunk);
            res.on('end', () => {
                if (res.statusCode === 200 || res.statusCode === 201) {
                    resolve(true);
                } else {
                    resolve(false);
                }
            });
        });

        req.on('error', (e) => {
            resolve(false);
        });

        req.write(body);
        req.end();
    });
}

async function sleep(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
}

async function main() {
    console.log("=".repeat(60));
    console.log("GENERADOR DE DATOS ADICIONALES - LUISA v2.0");
    console.log("=".repeat(60));
    console.log(`Timestamp: ${new Date()}`);
    console.log();

    // Cargar datos existentes
    console.log("Cargando datos existentes de la base de datos...");

    const perfWithUser = await getTable("perfiles_pacientes", 500);
    PACIENTE_IDS = perfWithUser.map(p => p.id).filter(Boolean);

    MEDICO_IDS = (await getTable("medicos", 100)).map(m => m.id).filter(Boolean);
    FRECUENCIA_IDS = (await getTable("cat_frecuencias_medicamento", 100)).map(f => f.id).filter(Boolean);
    VIA_ADMIN_IDS = (await getTable("cat_vias_administracion", 100)).map(v => v.id).filter(Boolean);
    MEDICAMENTO_IDS = (await getTable("cat_medicamentos", 500)).map(m => m.id).filter(Boolean);

    console.log(`Pacientes encontrados: ${PACIENTE_IDS.length}`);
    console.log(`Médicos encontrados: ${MEDICO_IDS.length}`);
    console.log(`Medicamentos disponibles: ${MEDICAMENTO_IDS.length}`);
    console.log(`Frecuencias disponibles: ${FRECUENCIA_IDS.length}`);
    console.log();

    const counts = {
        notas: 0,
        medicamentos: 0,
        vacunas: 0
    };

    // FASE 1: Crear 15 notas de evolución clínica
    console.log("[1/3] Creando 15 notas de evolución clínica...");

    for (let i = 1; i <= 15; i++) {
        if (PACIENTE_IDS.length === 0 || MEDICO_IDS.length === 0) {
            console.log("  ✗ No hay pacientes o médicos disponibles");
            break;
        }

        const notaId = uuidv4();
        const pacienteIdx = i % PACIENTE_IDS.length;
        const subjetiva = NOTAS_SUBJETIVAS[i % NOTAS_SUBJETIVAS.length];
        const objetiva = NOTAS_OBJETIVAS[i % NOTAS_OBJETIVAS.length];

        const notaData = {
            id: notaId,
            id_paciente: PACIENTE_IDS[pacienteIdx],
            id_medico: MEDICO_IDS[i % MEDICO_IDS.length],
            subjetivo: subjetiva,
            assessment: "Diabetes mellitus tipo 2 descontrolada",
            plan: "Continuar con medicamentos actuales. Realizar seguimiento en 4 semanas. Estudios si es necesario.",
            observaciones_adicionales: objetiva
        };

        if (await postToSupabase("notas_evolucion", notaData)) {
            counts.notas++;
            console.log(`  ✓ Nota de evolución ${i}`);
        } else {
            console.log(`  ✗ Error al crear nota ${i}`);
        }

        await sleep(100);
    }

    // FASE 2: Crear 25 medicamentos asignados (adicionales a los 100 existentes)
    console.log();
    console.log("[2/3] Creando 25 medicamentos adicionales asignados...");

    const dosisOptions = ["5 mg", "10 mg", "20 mg", "500 mg", "1000 mg", "1 comprimido", "2 comprimidos", "5 ml", "10 ml"];

    for (let i = 1; i <= 25; i++) {
        if (PACIENTE_IDS.length === 0 || MEDICAMENTO_IDS.length === 0 || FRECUENCIA_IDS.length === 0 || VIA_ADMIN_IDS.length === 0) {
            console.log("  ✗ Faltan catálogos necesarios");
            break;
        }

        const medicId = uuidv4();
        const pacienteIdx = i % PACIENTE_IDS.length;
        const dosis = dosisOptions[i % dosisOptions.length];

        const fechaInicio = new Date().toISOString().split('T')[0];
        const fechaFin = new Date(new Date().getTime() + 30 * 24 * 60 * 60 * 1000).toISOString().split('T')[0];

        const medicData = {
            id: medicId,
            id_paciente: PACIENTE_IDS[pacienteIdx],
            id_medicamento: MEDICAMENTO_IDS[i % MEDICAMENTO_IDS.length],
            dosis: dosis,
            via_administracion_id: VIA_ADMIN_IDS[i % VIA_ADMIN_IDS.length],
            frecuencia_id: FRECUENCIA_IDS[i % FRECUENCIA_IDS.length],
            fecha_inicio: fechaInicio,
            fecha_fin: fechaFin,
            activo: true
        };

        if (await postToSupabase("medicamentos_paciente", medicData)) {
            counts.medicamentos++;
            console.log(`  ✓ Medicamento ${i}`);
        } else {
            console.log(`  ✗ Error al crear medicamento ${i}`);
        }

        await sleep(100);
    }

    // FASE 3: Crear 10 registros de vacunas
    console.log();
    console.log("[3/3] Creando 10 registros de vacunas...");

    for (let i = 1; i <= 10; i++) {
        if (PACIENTE_IDS.length === 0) {
            console.log("  ✗ No hay pacientes disponibles");
            break;
        }

        const vacunaId = uuidv4();
        const pacienteIdx = i % PACIENTE_IDS.length;
        const vacuna = VACUNAS[i - 1];

        const diasAtras = Math.floor(Math.random() * 365) + 1;
        const fechaVacuna = new Date(new Date().getTime() - diasAtras * 24 * 60 * 60 * 1000).toISOString().split('T')[0];
        const proximaDosis = new Date(new Date().getTime() + 365 * 24 * 60 * 60 * 1000).toISOString().split('T')[0];

        const vacunaData = {
            id: vacunaId,
            id_paciente: PACIENTE_IDS[pacienteIdx],
            nombre_vacuna: vacuna,
            fecha_aplicacion: fechaVacuna,
            proxima_dosis: proximaDosis,
            lugar: "Centro de Salud Regional"
        };

        if (await postToSupabase("vacunas_paciente", vacunaData)) {
            counts.vacunas++;
            console.log(`  ✓ Vacuna ${i}: ${vacuna}`);
        } else {
            console.log(`  ✗ Error al crear vacuna ${i}`);
        }

        await sleep(100);
    }

    console.log();
    console.log("=".repeat(60));
    console.log("RESUMEN DE DATOS ADICIONALES CREADOS");
    console.log("=".repeat(60));
    console.log(`✓ Notas de evolución:               ${counts.notas}`);
    console.log(`✓ Medicamentos asignados:           ${counts.medicamentos}`);
    console.log(`✓ Vacunas registradas:              ${counts.vacunas}`);
    console.log(`\nTotal de registros nuevos:          ${Object.values(counts).reduce((a, b) => a + b, 0)}`);

    // Mostrar totales finales
    console.log();
    console.log("=== TOTALES EN BASE DE DATOS ===");
    const finalCounts = await Promise.all([
        getTable("usuarios_luisa", 1).then(r => r.length),
        getTable("medicos", 1).then(r => r.length),
        getTable("perfiles_pacientes", 1).then(r => r.length),
        getTable("citas", 1).then(r => r.length),
        getTable("notas_evolucion", 1).then(r => r.length),
        getTable("medicamentos_paciente", 1).then(r => r.length),
        getTable("vacunas_paciente", 1).then(r => r.length)
    ]);

    console.log(`Usuarios:               ${finalCounts[0]}`);
    console.log(`Médicos:                ${finalCounts[1]}`);
    console.log(`Perfiles de pacientes:  ${finalCounts[2]}`);
    console.log(`Citas:                  ${finalCounts[3]}`);
    console.log(`Notas de evolución:     ${finalCounts[4]}`);
    console.log(`Medicamentos asignados: ${finalCounts[5]}`);
    console.log(`Vacunas registradas:    ${finalCounts[6]}`);
    console.log(`\nTimestamp finalización: ${new Date()}`);
    console.log("=".repeat(60));
}

main().catch(console.error);
