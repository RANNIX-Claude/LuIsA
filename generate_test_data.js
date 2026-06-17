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

const DIAGNOSTICOS = [
    "E11 - Diabetes mellitus tipo 2",
    "I10 - Hipertensión esencial",
    "E78 - Hiperlipidemia",
    "M19 - Artrosis",
    "E66 - Obesidad",
    "J30 - Rinitis alérgica",
    "K21 - Enfermedad del reflujo gastroesofágico",
    "F41 - Trastornos de ansiedad",
    "E05 - Tirotoxicosis",
    "G89 - Dolor no clasificado"
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

const MEDICAMENTOS_COMUNES = [
    "Metformina 500mg", "Lisinopril 10mg", "Simvastatina 20mg", "Omeprazol 20mg",
    "Ibuprofen 400mg", "Amoxicilina 500mg", "Loratadina 10mg", "Sertraline 50mg",
    "Levotiroxina 75mcg", "Losartan 50mg"
];

const VACUNAS = [
    "Influenza", "COVID-19", "Hepatitis B", "Tétanos", "Neumocócica",
    "Herpes Zóster", "Meningocócica", "Tosferina", "Sarampión", "Varicela"
];

const MEDICOS = Array.from({ length: 10 }, (_, i) => `medico${String(i + 1).padStart(3, '0')}`);

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

    return date.toISOString().replace('Z', '').slice(0, 19);
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

async function sleep(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
}

async function main() {
    console.log("=".repeat(60));
    console.log("GENERADOR DE DATOS DE PRUEBA - LUISA v2.0");
    console.log("=".repeat(60));
    console.log(`Timestamp: ${new Date()}`);
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
        const patientId = uuidv4();
        patientIds.push(patientId);

        const nombre = NOMBRES_PACIENTES[i - 1];
        const cedula = 100000000 + i;
        const fechaNac = generateBirthDate();
        const estadoId = (i % 32) + 1;
        const sangreId = (i % 8) + 1;
        const ocupacionId = (i % 7) + 1;
        const sexo = i % 2 === 0 ? 'F' : 'M';

        // Crear usuario
        const userData = {
            id: patientId,
            email: `paciente${String(i).padStart(3, '0')}@example.mx`,
            tipo_usuario: "paciente",
            estado_activo: true
        };

        if (await postToSupabase("usuarios_luisa", userData)) {
            counts.pacientes++;
        }

        await sleep(100);

        // Crear perfil paciente
        const profileData = {
            id: patientId,
            nombre_completo: nombre,
            cedula_profesional: cedula.toString(),
            fecha_nacimiento: fechaNac,
            sexo: sexo,
            estado_republica_id: estadoId,
            tipo_sanguineo_id: sangreId,
            ocupacion_id: ocupacionId,
            telefono: `${5500000000 + i}`,
            direccion: `Calle ${nombre} ${i}, Depto ${i * 2}, México`,
            alergias: i % 3 === 0 ? "Penicilina, Látex" : "Ninguna conocida",
            comorbilidades: i % 2 === 0 ? "Diabetes mellitus tipo 2, Hipertensión" : "Ninguna"
        };

        if (await postToSupabase("perfiles_pacientes", profileData)) {
            console.log(`  ✓ Paciente ${i}: ${nombre}`);
        }

        await sleep(100);
    }

    console.log();
    console.log("[2/5] Creando 30 citas distribuidas...");

    for (let i = 1; i <= 30; i++) {
        const citaId = uuidv4();
        const fechaCita = generateFutureDate();
        const medicoIdx = i % MEDICOS.length;
        const pacienteIdx = i % patientIds.length;

        const citaData = {
            id: citaId,
            medico_id: MEDICOS[medicoIdx],
            paciente_id: patientIds[pacienteIdx],
            fecha_hora: fechaCita,
            duracion_minutos: 30,
            estado: "programada",
            motivo_consulta: "Control rutinario de salud",
            notas: "Cita de revisión periódica"
        };

        if (await postToSupabase("citas", citaData)) {
            counts.citas++;
            console.log(`  ✓ Cita ${i}`);
        }

        await sleep(100);
    }

    console.log();
    console.log("[3/5] Creando 15 notas de evolución clínica...");

    for (let i = 1; i <= 15; i++) {
        const notaId = uuidv4();
        const pacienteIdx = i % patientIds.length;
        const diagnostico = DIAGNOSTICOS[i % DIAGNOSTICOS.length];
        const subjetiva = NOTAS_SUBJETIVAS[i % NOTAS_SUBJETIVAS.length];
        const objetiva = NOTAS_OBJETIVAS[i % NOTAS_OBJETIVAS.length];

        const notaData = {
            id: notaId,
            paciente_id: patientIds[pacienteIdx],
            medico_id: MEDICOS[i % MEDICOS.length],
            fecha_creacion: new Date().toISOString(),
            subjetivo: subjetiva,
            objetivo: objetiva,
            diagnostico: diagnostico,
            plan_tratamiento: "Continuar con medicamentos actuales. Realizar seguimiento en 4 semanas."
        };

        if (await postToSupabase("notas_evolucion", notaData)) {
            counts.notas++;
            console.log(`  ✓ Nota de evolución ${i}`);
        }

        await sleep(100);
    }

    console.log();
    console.log("[4/5] Creando 25 medicamentos asignados...");

    const dosisOptions = ["1 tableta", "2 tabletas", "1 cápsula", "2 cápsulas", "5 ml", "10 ml"];
    const frecuenciasId = [1, 2, 3, 4, 5, 6];

    for (let i = 1; i <= 25; i++) {
        const medicId = uuidv4();
        const pacienteIdx = i % patientIds.length;
        const medicamento = MEDICAMENTOS_COMUNES[i % MEDICAMENTOS_COMUNES.length];
        const dosis = dosisOptions[i % dosisOptions.length];
        const frecuenciaId = frecuenciasId[i % frecuenciasId.length];

        const fechaInicio = new Date().toISOString().split('T')[0];
        const fechaFin = new Date(new Date().getTime() + 30 * 24 * 60 * 60 * 1000).toISOString().split('T')[0];

        const medicData = {
            id: medicId,
            paciente_id: patientIds[pacienteIdx],
            nombre_medicamento: medicamento,
            dosis: dosis,
            frecuencia_id: frecuenciaId,
            via_administracion_id: (i % 5) + 1,
            fecha_inicio: fechaInicio,
            fecha_fin: fechaFin,
            indicaciones: "Tomar según se prescribe para el tratamiento",
            efectos_secundarios: "Ninguno conocido"
        };

        if (await postToSupabase("medicamentos_paciente", medicData)) {
            counts.medicamentos++;
            console.log(`  ✓ Medicamento ${i}: ${medicamento}`);
        }

        await sleep(100);
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
            paciente_id: patientIds[pacienteIdx],
            nombre_vacuna: vacuna,
            fecha_aplicacion: fechaVacuna,
            dosis_numero: 1,
            lote: `LOTE${String(1000000 + i).padStart(8, '0')}`,
            proxima_dosis: proximaDosis
        };

        if (await postToSupabase("vacunas_paciente", vacunaData)) {
            counts.vacunas++;
            console.log(`  ✓ Vacuna ${i}: ${vacuna}`);
        }

        await sleep(100);
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
