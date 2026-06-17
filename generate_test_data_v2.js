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
const NOMBRES_PACIENTES = [
    "María González López", "Juan García Rodríguez", "Ana Martínez Fernández",
    "Carlos López Hernández", "Roberto Jiménez Gutiérrez", "Laura Moreno Pérez",
    "Francisco Torres Ramírez", "Rosa Díaz Castillo", "Antonio Sánchez Montoya",
    "Carmen Ruiz Medina", "David Herrera Campos", "María Elena Rojas Silva",
    "Miguel Ángel Flores Cruz", "Patricia Vargas Reyes", "Jesús Morales Rivas",
    "Alejandra Medina Gómez", "Ricardo Navarro Acosta", "Claudia Esparza Bautista",
    "Felipe Campos López", "Verónica Gutierrez Miranda"
];

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

// IDs de catálogos existentes (obtenidos de inspección previa)
let ESTADO_IDS = [];
let TIPO_SANGRE_IDS = [];
let OCUPACION_IDS = [];
let MEDICAMENTO_IDS = [];
let FRECUENCIA_IDS = [];
let VIA_ADMIN_IDS = [];
let MEDICO_IDS = [];
let CIUDAD_IDS = [];
let ESTADO_CIVIL_IDS = [];
let ESPECIALIDAD_IDS = [];

function getTable(tableName) {
    return new Promise((resolve) => {
        const url = new URL(`${SUPABASE_URL}/rest/v1/${tableName}?limit=500`);
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
                    console.log(`  ✗ Error (${res.statusCode}): ${responseData.substring(0, 100)}`);
                    resolve(false);
                }
            });
        });

        req.on('error', (e) => {
            console.log(`  ✗ Exception: ${e.message.substring(0, 100)}`);
            resolve(false);
        });

        req.write(body);
        req.end();
    });
}

function generateBirthDate() {
    const today = new Date();
    const minAge = 18;
    const maxAge = 85;
    const daysBack = Math.floor(Math.random() * (maxAge - minAge) * 365) + minAge * 365;
    const date = new Date(today.getTime() - daysBack * 24 * 60 * 60 * 1000);
    return date.toISOString().split('T')[0];
}

function generateFutureDate() {
    const today = new Date();
    const daysAhead = Math.floor(Math.random() * 7) + 1;
    const hour = Math.floor(Math.random() * 9) + 8;
    const minute = [0, 15, 30, 45][Math.floor(Math.random() * 4)];

    const date = new Date(today.getTime() + daysAhead * 24 * 60 * 60 * 1000);
    date.setHours(hour, minute, 0, 0);

    return date.toISOString();
}

async function sleep(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
}

async function main() {
    console.log("=".repeat(60));
    console.log("GENERADOR DE DATOS DE PRUEBA - LUISA v2.0");
    console.log("=".repeat(60));
    console.log(`Timestamp: ${new Date()}`);
    console.log();

    // Cargar catálogos
    console.log("Cargando catálogos...");
    ESTADO_IDS = (await getTable("cat_estados_republica")).map(r => r.id).filter(Boolean);
    TIPO_SANGRE_IDS = (await getTable("cat_tipos_sanguineo")).map(r => r.id).filter(Boolean);
    OCUPACION_IDS = (await getTable("cat_ocupaciones")).map(r => r.id).filter(Boolean);
    MEDICAMENTO_IDS = (await getTable("cat_medicamentos")).map(r => r.id).filter(Boolean);
    FRECUENCIA_IDS = (await getTable("cat_frecuencias_medicamento")).map(r => r.id).filter(Boolean);
    VIA_ADMIN_IDS = (await getTable("cat_vias_administracion")).map(r => r.id).filter(Boolean);
    CIUDAD_IDS = (await getTable("cat_ciudades")).map(r => r.id).filter(Boolean);
    ESTADO_CIVIL_IDS = (await getTable("cat_estado_civil")).map(r => r.id).filter(Boolean);

    // Cargar médicos y especialidades
    const medicosData = await getTable("medicos");
    MEDICO_IDS = medicosData.map(m => m.id).filter(Boolean);
    const especialidadesData = await getTable("cat_especialidades");
    ESPECIALIDAD_IDS = especialidadesData.map(e => e.id).filter(Boolean);

    console.log(`Estados: ${ESTADO_IDS.length} | Sangre: ${TIPO_SANGRE_IDS.length} | Ocupaciones: ${OCUPACION_IDS.length}`);
    console.log(`Medicamentos: ${MEDICAMENTO_IDS.length} | Médicos: ${MEDICO_IDS.length}`);
    console.log(`Ciudades: ${CIUDAD_IDS.length} | Frecuencias: ${FRECUENCIA_IDS.length}`);
    console.log();

    const counts = {
        pacientes: 0,
        citas: 0,
        notas: 0,
        medicamentos: 0,
        vacunas: 0
    };

    // FASE 1: Crear 20 pacientes
    console.log("[1/5] Creando 20 pacientes con perfiles...");
    const patientIds = [];

    for (let i = 1; i <= 20; i++) {
        const patientUserId = uuidv4();
        const patientProfileId = uuidv4();
        patientIds.push({ userId: patientUserId, profileId: patientProfileId });

        const nombre = NOMBRES_PACIENTES[i - 1];
        const fechaNac = generateBirthDate();
        const sexo = i % 2 === 0 ? 'F' : 'M';

        // Calcular edad
        const today = new Date();
        const birthDate = new Date(fechaNac);
        let age = today.getFullYear() - birthDate.getFullYear();
        const monthDiff = today.getMonth() - birthDate.getMonth();
        if (monthDiff < 0 || (monthDiff === 0 && today.getDate() < birthDate.getDate())) {
            age--;
        }

        // Crear usuario
        const userData = {
            id: patientUserId,
            email: `paciente${String(i).padStart(3, '0')}@example.mx`,
            nombre_completo: nombre,
            documento_identidad: `PAC${String(100000 + i).padStart(6, '0')}`,
            documento_tipo: "cedula",
            rol: "paciente",
            activo: true
        };

        if (await postToSupabase("usuarios_luisa", userData)) {
            counts.pacientes++;
        }

        await sleep(50);

        // Crear perfil paciente
        const profileData = {
            id: patientProfileId,
            id_usuario: patientUserId,
            nombre_completo: nombre,
            fecha_nacimiento: fechaNac,
            edad: age,
            sexo: sexo,
            tipo_sangre_id: TIPO_SANGRE_IDS[Math.floor(Math.random() * TIPO_SANGRE_IDS.length)],
            estado_id: ESTADO_IDS[Math.floor(Math.random() * ESTADO_IDS.length)],
            ciudad_id: CIUDAD_IDS.length > 0 ? CIUDAD_IDS[Math.floor(Math.random() * CIUDAD_IDS.length)] : null,
            domicilio_calle: `Calle ${nombre}`,
            domicilio_numero: `${i * 100}`,
            domicilio_cp: String(1000 + i).padStart(5, '0'),
            ocupacion_id: OCUPACION_IDS[Math.floor(Math.random() * OCUPACION_IDS.length)],
            estado_civil_id: ESTADO_CIVIL_IDS.length > 0 ? ESTADO_CIVIL_IDS[Math.floor(Math.random() * ESTADO_CIVIL_IDS.length)] : null,
            grupo_etnico_id: null,
            religion_id: null,
            nivel_socioeconomico_id: null,
            tipo_vivienda_id: null,
            perfil_completo_pct: 75
        };

        if (await postToSupabase("perfiles_pacientes", profileData)) {
            console.log(`  ✓ Paciente ${i}: ${nombre}`);
        }

        await sleep(50);
    }

    console.log();
    console.log("[2/5] Creando 30 citas distribuidas...");

    for (let i = 1; i <= 30; i++) {
        const citaId = uuidv4();
        const fechaCita = generateFutureDate();
        const medicoIdx = i % MEDICO_IDS.length;
        const pacienteIdx = i % patientIds.length;

        const citaData = {
            id: citaId,
            id_paciente: patientIds[pacienteIdx].profileId,
            id_medico: MEDICO_IDS[medicoIdx],
            fecha_hora: fechaCita,
            tipo_consulta: "consulta_externa",
            duracion_minutos: 30,
            estado: "programada",
            notas_paciente: "Cita de revisión periódica"
        };

        if (await postToSupabase("citas", citaData)) {
            counts.citas++;
            console.log(`  ✓ Cita ${i}`);
        }

        await sleep(50);
    }

    console.log();
    console.log("[3/5] Creando 15 notas de evolución clínica...");

    for (let i = 1; i <= 15; i++) {
        const notaId = uuidv4();
        const pacienteIdx = i % patientIds.length;
        const subjetiva = NOTAS_SUBJETIVAS[i % NOTAS_SUBJETIVAS.length];
        const objetiva = NOTAS_OBJETIVAS[i % NOTAS_OBJETIVAS.length];

        const notaData = {
            id: notaId,
            id_paciente: patientIds[pacienteIdx].profileId,
            id_medico: MEDICO_IDS[i % MEDICO_IDS.length],
            fecha_creacion: new Date().toISOString(),
            subjetivo: subjetiva,
            objetivo: objetiva,
            plan_tratamiento: "Continuar con medicamentos actuales. Realizar seguimiento en 4 semanas."
        };

        if (await postToSupabase("notas_evolucion", notaData)) {
            counts.notas++;
            console.log(`  ✓ Nota de evolución ${i}`);
        }

        await sleep(50);
    }

    console.log();
    console.log("[4/5] Creando 25 medicamentos asignados...");

    const dosisOptions = ["10 mg", "20 mg", "500 mg", "1 comprimido", "2 comprimidos", "5 ml"];

    for (let i = 1; i <= 25; i++) {
        const medicId = uuidv4();
        const pacienteIdx = i % patientIds.length;
        const dosis = dosisOptions[i % dosisOptions.length];

        const fechaInicio = new Date().toISOString().split('T')[0];
        const fechaFin = new Date(new Date().getTime() + 30 * 24 * 60 * 60 * 1000).toISOString().split('T')[0];

        const medicData = {
            id: medicId,
            id_paciente: patientIds[pacienteIdx].profileId,
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
        }

        await sleep(50);
    }

    console.log();
    console.log("[5/5] Creando 10 registros de vacunas...");

    for (let i = 1; i <= 10; i++) {
        const vacunaId = uuidv4();
        const pacienteIdx = i % patientIds.length;
        const vacuna = VACUNAS[i - 1];

        const diasAtras = Math.floor(Math.random() * 365) + 1;
        const fechaVacuna = new Date(new Date().getTime() - diasAtras * 24 * 60 * 60 * 1000).toISOString().split('T')[0];
        const proximaDosis = new Date(new Date().getTime() + 365 * 24 * 60 * 60 * 1000).toISOString().split('T')[0];

        const vacunaData = {
            id: vacunaId,
            id_paciente: patientIds[pacienteIdx].profileId,
            nombre_vacuna: vacuna,
            fecha_aplicacion: fechaVacuna,
            numero_dosis: 1,
            lote: `LOTE${String(1000000 + i).padStart(8, '0')}`,
            proxima_dosis: proximaDosis
        };

        if (await postToSupabase("vacunas_paciente", vacunaData)) {
            counts.vacunas++;
            console.log(`  ✓ Vacuna ${i}: ${vacuna}`);
        }

        await sleep(50);
    }

    console.log();
    console.log("=".repeat(60));
    console.log("RESUMEN DE DATOS CREADOS");
    console.log("=".repeat(60));
    console.log(`✓ Pacientes (usuarios + perfiles):  ${counts.pacientes}`);
    console.log(`✓ Citas creadas:                    ${counts.citas}`);
    console.log(`✓ Notas de evolución:               ${counts.notas}`);
    console.log(`✓ Medicamentos asignados:           ${counts.medicamentos}`);
    console.log(`✓ Vacunas registradas:              ${counts.vacunas}`);
    console.log(`\nTotal de registros:                 ${Object.values(counts).reduce((a, b) => a + b, 0)}`);
    console.log(`Timestamp finalización:             ${new Date()}`);
    console.log("=".repeat(60));
}

main().catch(console.error);
